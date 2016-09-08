##################################################
# Récupération de données simples

# 1. Quels sont les gymnases de “Villetaneuse” ou de “Sarcelles” qui ont une surface de plus de 400 m2 ?
subset(Gymnases, 
       subset = Ville %in% c("SARCELLES", "VILLETANEUSE") & Surface > 400,
       select = c(Ville, NomGymnase))

# 2. Quels sportifs n’ont pas de conseillers ?
subset(Sportifs, 
       subset = is.na(IdSportifConseiller),
       select = c(Nom, Prenom))

# 3. Quels sportifs (identifiant et nom) ne jouent aucun sport ?
subset(Sportifs,
       subset = !(IdSportif %in% Jouer$IdSportif),
       select = c(Nom, Prenom))

# 4. Quels sont les sportifs qui sont aussi des conseillers ?
subset(Sportifs,
       subset = IdSportif %in% Sportifs$IdSportifConseiller,
       select = c(Nom, Prenom))

# 5. Quels sont les entraîneurs qui sont aussi joueurs ?
unique(subset(
    merge(Sportifs,
          merge(Jouer, Entrainer, 
                by.x = "IdSportif", by.y = "IdSportifEntraineur")),
    select = c(Nom, Prenom)
))

# 6. Quels sont les sportifs (identifiant et nom) qui jouent du hand ball ?
subset(
    merge(
        Sportifs,
        merge(Jouer,
              subset(Sports, subset = Libelle == "Hand ball"))
    ),
    select = c(IdSportif, Nom, Prenom)
)

# 7. Dans quels gymnases peut-on jouer au hockey le mercredi après 15H ?
subset(
    merge(
        Gymnases,
        merge(
            subset(Seances, 
                   subset = Horaire >= 15 & tolower(Jour) == "mercredi"),
            subset(Sports,
                   subset = Libelle == "Hockey")
        )
    ),
    select = c(Ville, NomGymnase, Jour, Horaire, Duree)
)

##################################################
# Calcul d’agrégats

# 1. Quelle est la moyenne d’âge des sportives qui jouent du basket ball ?
aggregate(
    Age ~ 1, 
    data = merge(subset(Sportifs, subset = Sexe == "F"),
                 merge(Jouer, subset(Sports, subset = Libelle == "Basket ball"))),
    mean
)

# 2. Pour chaque sportif donner le nombre de sports qu’il joue.
subset(
    transform(
        merge(
            Sportifs,
            setNames(
                aggregate(IdSport ~ IdSportif, Jouer, length), 
                c("IdSportif", "NbSports")
            ),
            all.x = T
        ),
        NbSports = replace(NbSports, which(is.na(NbSports)), 0)
    ),
    select = c(Nom, Prenom, NbSports)
)

# 3. Pour chaque gymnase de Montmorency : quel est le nombre de séances journalières de chaque sport proposé ?
setNames(
    aggregate(
        . ~ NomGymnase + Libelle + Jour,
        transform(
            merge(
                subset(Gymnases, 
                       subset = Ville == "SARCELLES", 
                       select = c(IdGymnase, NomGymnase)),
                subset(merge(Seances, Sports), 
                       select = c(IdGymnase, Jour, Libelle))
            ),
            Jour = tolower(Jour)
        ),
        length
    ),
    c("Gymnase", "Sport", "Jour", "Nb Seances")
)

# 4. Pour chaque entraîneurs de hand ball quel est le nombre de séances journalières qu’il assure ?
aggregate(
    . ~ Jour + Nom + Prenom, 
    transform(
        subset(
            merge(
                merge(
                    Sportifs, 
                    merge(
                        Entrainer, 
                        subset(
                            Sports, 
                            subset = Libelle == "Hand ball"
                        )
                    ), 
                    by.x = "IdSportif", 
                    by.y = "IdSportifEntraineur"
                ), 
                Seances, 
                by.x = "IdSportif", 
                by.y = "IdSportifEntraineur"
            ), 
            select = c(Nom, Prenom, Jour, Horaire)
        ), 
        Jour = tolower(Jour)
    ), 
    length
)

# 5. A partir de la réponse à la question 2, ajouter le nombre de sports qu’il arbitre et qu’il entraîne. On veut avoir tous les sportifs dans le tableau final.
transform(
    merge(
        merge(
            merge(
                subset(Sportifs, select = c(IdSportif, Nom, Prenom)),
                setNames(aggregate(IdSport ~ IdSportif, Jouer, length), c("IdSportif", "NbJ")),
                all.x = T
            ),
            setNames(aggregate(IdSport ~ IdSportif, Arbitrer, length), c("IdSportif", "NbA")),
            all.x = T
        ),
        setNames(aggregate(IdSport ~ IdSportifEntraineur, Entrainer, length), c("IdSportif", "NbE")),
        all.x = T
    ),
    NbJ = replace(NbJ, which(is.na(NbJ)), 0),
    NbA = replace(NbA, which(is.na(NbA)), 0),
    NbE = replace(NbE, which(is.na(NbE)), 0)
)

# 6. Quels sont les sportifs les plus jeunes ?
subset(
    merge(Sportifs, aggregate(Age ~ 1, Sportifs, min)),
    select = c(Nom, Prenom)
)

# 7. Pour chaque gymnase de Stains donner par jour d’ouverture les horaires des premières et dernières séances
aggregate(
    Horaire ~ Jour + NomGymnase,
    transform(
        subset(merge(Gymnases, Seances), 
               subset = Ville == "STAINS"), 
        Jour = tolower(Jour)),
    function (sub) { return (c(Min = min(sub), Max = max(sub))); }
)
