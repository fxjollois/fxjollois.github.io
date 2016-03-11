---
title: Logiciels stats - R - TP2
---

## Base de données utilisée

Nous allons utiliser dans ce TP une base de données classique, `Gymnase2000`. Cette base de données concernent des sportifs, des sports et des gymnases. Un sportif peut jouer, arbitrer et/ou entraîner un ou plusieurs sports (ou aucun). Dans un gymnase, il peut y avoir une ou plusieurs séances d'un sport, avec un entraîneur spécifié.

Vous pouvez accéder aux tables de cette base de données via le chargement du fichier `Gymnase2000.RData` avec la commande `load()` dans **R**. Le fichier est disponible [ici](https://drive.google.com/folderview?id=0BzA8L2nqa1n5NXZBTHJnclFZMDA&usp=drive_web).


## Exemples 

### Sportifs (identifiant, nom et prénom) entre 20 et 30 ans ?

```r
subset(Sportifs, 
       subset = Age > 20 & Age < 30, 
       select = c(IdSportif, Nom, Prenom)
       )
```

### Gymnases avec des séances le dimanche

```r
# avec jointure
unique(
    subset(
        merge(Gymnases, Seances),
        subset = tolower(Jour) == "dimanche",
        select = c(Ville, NomGymnase)
    )
)
# sans jointure
subset(Gymnases,
       subset = IdGymnase %in% subset(Seances, subset = tolower(Jour) == "dimanche")$IdGymnase,
       select = c(Ville, NomGymnase)
)
```

### Nom et prénom du conseiller de "Kervadec"

```r
# avec jointure
subset(
    merge(
        subset(Sportifs, 
               subset = Nom == "KERVADEC", 
               select = c(Nom, IdSportifConseiller)),
        subset(Sportifs,
               select = -IdSportifConseiller),
        by.x = "IdSportifConseiller",
        by.y = "IdSportif"
    ),
    select = c(Nom.y, Prenom)
)
# sans jointure
subset(
    Sportifs,
    subset = IdSportif == subset(Sportifs, subset = Nom == "KERVADEC")$IdSportifConseiller,
    select = c(Nom, Prenom)
)
```

### Dans quels gymnases et quels jours y a t-il des séances de hand ball ?

```r
unique(
    transform(
        subset(
            merge(Gymnases, Seances),
            subset = IdSport == subset(Sports, subset = Libelle == "Hand ball")$IdSport,
            select = c(Ville, NomGymnase, Jour)
        ),
        Jour = tolower(Jour)
    )
)
```

### Gymnases avec la plus petite superficie

```r
# avec calcul direct
subset(
    Gymnases,
    subset = Surface == min(Gymnases$Surface)
)
# avec jointure et calcul d'agrégat
merge(
    Gymnases,
    aggregate(Surface ~ 1, data = Gymnases, min)
)
```

## Questions

### Récupération de données simples

1. Quels sont les gymnases de "Villetaneuse" ou de "Sarcelles" qui ont une surface de plus de 400 m2 ?
2. Quels sportifs n'ont pas de conseillers ?
3. Quels sportifs (identifiant et nom) ne jouent aucun sport ?
4. Quels sont les sportifs qui sont aussi des conseillers ?
5. Quels sont les entraîneurs qui sont aussi joueurs ?
6. Quels sont les sportifs (identifiant et nom) qui jouent du hand ball ?
7. Dans quels gymnases peut-on jouer au hockey le mercredi apres 15H ?

### Calcul d'agrégats

1. Quelle est la moyenne d'âge des sportives qui jouent du basket ball ?
2. Pour chaque sportif donner le nombre de sports qu'il joue.
3. Pour chaque gymnase de Montmorency : quel est le nombre de séances journalières de chaque sport propose ?
4. Pour chaque entraîneurs de hand ball quel est le nombre de séances journalières qu'il assure ?
5. A partir de la réponse à la question 2, ajouter le nombre de sports qu'il arbitre et qu'il entraîne. On veut avoir tous les sportifs dans le tableau final.
6. Quels sont les sportifs les plus jeunes ?
7. Pour chaque gymnase de Stains donner par jour d'ouverture les horaires des premières et dernières séances
