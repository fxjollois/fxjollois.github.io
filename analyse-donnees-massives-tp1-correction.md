---
title: TP1 - Introduction à MongoDB - *correction*
subtitle: Analyse de Données Massives - Master 1ère année
---

## A faire

Répondre aux questions suivantes

##### 1. Quels sont les sportifs (identifiant, nom et prénom) qui ont entre 20 et 30 ans ?

```js
db.Sportifs.find({
        "Age": { "$gte": 20 },
        "Age": { "$lte": 30 }
    },
    {
        "_id": 0,
        "IdSportif": 1,
        "Nom": 1,
        "Prenom": 1
    })
```

##### 2. Quels sont les gymnases de "Villetaneuse" ou de "Sarcelles" qui ont une surface de plus de 400 m2 ?

```js
db.Gymnases.find(
    {
        "Ville": { "$in": [ "VILLETANEUSE", "SARCELLES"]},
        "Surface": { "$gte": 400 }
    },
    {
        "_id": 0,
        "NomGymnase": 1,
        "Ville": 1,
        "Surface": 1
    })
```

##### 3. Quels sont les sportifs (identifiant et nom) qui pratiquent du hand ball ?

```js
db.Sportifs.find(
    {
        "Sports.Jouer": "Hand ball"
    },
    {
        "_id": 0,
        "IdSportif": 1,
        "Nom": 1
    }
)
```

##### 4. Dans quels gymnases et quels jours y a t-il des séances de hand ball ?

```js
db.Gymnases.find(
    {
        "Seances.Libelle": "Hand ball"
    },
    {
        "_id": 0,
        "NomGymnase": 1,
        "Ville": 1,
        "Seances.Jour": 1,
        "Seances.Libelle": 1
    }
)
```

**Problème** d'affichage des jours

```js
db.Gymnases.aggregate([
    { $unwind : "$Seances" },
    { $match: { "Seances.Libelle" : "Hand ball" }},
    { $project: { 
        "Gymnase" : "$NomGymnase", 
        "Ville" : "$Ville",
        "Jour" : { $toLower : "$Seances.Jour" }
    }},
    { $group: {
        "_id": { "Nom": "$Gymnase", "Ville": "$Ville", "Jour": "$Jour" },
        "nb": { $sum: 1 }
    }},
    { $sort: {
        "_id.Ville": 1,
        "_id.Nom": 1,
        "nb": -1
    }}
])
```

##### 5. Dans quels gymnases peut-on jouer au hockey le mercredi apres 15H ?

```js
db.Gymnases.find(
    {
        "Seances.Libelle": "Hockey",
        "Seances.Jour" : { "$in": [ "mercredi", "Mercredi" ]},
        "Seances.Horaire": { "$gte" : 15 }
    },
    {
        "_id": 0,
        "NomGymnase": 1,
        "Ville": 1,
        "Seances.Jour": 1,
        "Seances.Libelle": 1,
        "Seances.Horaire": 1
    }
)
```


**Problème** de sélection (visible si on fait `$lte`)

```js
db.Gymnases.aggregate([
    { $unwind: "$Seances" },
    { $match: {
        "Seances.Libelle" : "Hockey",
        "Seances.Jour": { "$in": [ "mercredi", "Mercredi" ]},
        "Seances.Horaire": { "$gte": 15 }
    }},
    { $project: {
        "_id": 0,
        "Gymnase" : "$NomGymnase", 
        "Ville" : "$Ville"
    }},
    { $sort: {
        "Ville": 1,
        "Gymnase": 1
    }}
])
```


##### 6. Quels sportifs (identifiant et nom) ne pratiquent aucun sport ?

```js
db.Sportifs.find(
    {
        "Sports" : { "$exists" : false }
    },
    {
        "_id": 0,
        "Nom":  1
    }
)
```

##### 7. Quels gymnases n'ont pas de séances le dimanche ?

```js
db.Gymnases.find(
    {
        "Seances.Jour" : { "$nin" : [ "dimanche", "Dimanche" ]}
    },
    {
        "_id": 0,
        "NomGymnase": 1,
        "Ville": 1,
        "Seances.Jour": 1
    }
)
```

##### 8. Quels gymnases ne proposent que des séances de basket ball ou de volley ball ?

```js
db.Gymnases.find(
    {
        "$nor": [
            { "Seances.Libelle": { "$ne": "Basket ball" }},
            { "Seances.Libelle": { "$ne": "Volley ball" }}
        ]
    },
    {
        "_id": 0,
        "NomGymnase": 1,
        "Ville": 1,
        "Seances.Libelle": 1
    }
)
```

##### 9. Quels sont les entraîneurs qui sont aussi joueurs ?

```js
db.Sportifs.find(
    {
        "Sports.Jouer" : { "$exists" : true },
        "Sports.Entrainer" : { "$exists" : true }
    },
    {
        "_id": 0,
        "Nom":  1
    }
)
```

##### 10. Quels sont les sportifs qui sont des conseillers ?

```js
db.Sportifs.find(
    {
        "IdSportif": { "$in": db.Sportifs.distinct("IdSportifConseiller")}
    },
    {
        "_id": 0,
        "Nom":  1
    }
)
```

##### 11. Pour le sportif "Kervadec" quel est le nom de son conseiller ?

```js
db.Sportifs.find(
    {
        "IdSportif": db.Sportifs.find({ "Nom": "KERVADEC" })[0].IdSportifConseiller
    },
    {
        "_id": 0,
        "Sports": 0
    }
)
```

##### 12. Quels entraîneurs entraînent du hand ball et du basket ball ?

```js
db.Sportifs.find(
    {
        "Sports.Entrainer": "Hand ball", 
        "Sports.Entrainer": "Basket ball" 
    },
    {
        "_id": 0,
        "Nom": 1,
        "Sports.Entrainer": 1
    }
)
```

```js
db.Sportifs.find(
    {
        $and: [
            { "Sports.Entrainer": "Hand ball" }, 
            { "Sports.Entrainer": "Basket ball" }
        ]        
    },
    {
        "_id": 0,
        "Nom": 1,
        "Sports.Entrainer": 1
    }
)
```

##### 13. Quels sont les couples de sportifs (identifiant et nom et prénom de chaque) de même age ?

NE PAS FAIRE

##### 14. Quelle est la moyenne d'âge des sportives qui pratiquent du basket ball ?

```js
db.Sportifs.aggregate([
    { $match: { "Sports.Jouer": "Basket ball", "Sexe": { $in: [ "f", "F" ]} }},
    { $group: { "_id": null, "AgeMoyen": { $avg: "$Age" }}}
])
```

##### 15. Quels sont les sportifs les plus jeunes ?

On stocke le résultat de l'aggrégation dans une variable.

```js
var agemin = db.Sportifs.aggregate([ 
    { $group: { _id: null, "agemin": { $min: "$Age" } } } 
]).next();
```

On cherche les sportifs avec `Age = agemin.agemin`.

```js
db.Sportifs.find(
    {
        "Age": agemin.agemin
    },
    {
        "_id": 0,
        "Nom": 1,
        "Age": 1
    }
)
```

##### 16. Quels sont les gymnases de "Stains" ou de "Montmorency" qui ont la plus grande surface ?

On peut chercher les plus grands gymnases de chaque ville. 

```js
var grand = db.Gymnases.aggregate([
    { $group: { _id: "$Ville", surfmax: { $max: "$Surface" }} }
]).toArray();
```

Ensuite, on cherche 

```js

```


##### 17. Quels entraîneurs n'entraînent que du hand ball ou du basket ball ?

On récupère la liste des sports entraînés.

```js
var sports = db.Sportifs.distinct("Sports.Entrainer");
```

On fait un filtre pour supprimer le hand et le basket.

```js
var autres = sports.filter(function(s) { return (s != "Hand ball" & s != "Basket ball") });
```

On cherche ceux qui entraîne l'un ou l'autre, mais pas d'autres sports.

```js
db.Sportifs.find(
    {
        $and: [
            { $or: [
                { "Sports.Entrainer": "Hand ball" },
                { "Sports.Entrainer": "Basket ball" }
            ] },
            { "Sports.Entrainer" : { $nin : autres }}
        ]
    },
    {
        "_id": 0,
        "Nom": 1,
        "Sports.Entrainer": 1
    }
)
```

##### 18. Quels sont les couples de sportifs (identifiant et nom et prénom de chaque) de même âge avec le même conseiller ?

NE PAS FAIRE

##### 19. Quels sportifs n'ont pas de conseillers ?

```js
db.Sportifs.find(
    {
        "IdSportifConseiller": { $exists: false }
    },
    {
        "_id": 0,
        "Nom": 1
    }
)
```

##### 20. Pour chaque sportif donner le nombre de sports qu'il arbitre

```js
db.Sportifs.aggregate([
    { $match: { "Sports.Arbitrer": { $exists: true }}},
    { $unwind: "$Sports.Arbitrer"},
    { $group: { _id: "$Nom", "nbArbitrer": { $sum: 1 }}}
])
```

##### 21. Pour chaque gymnase de Stains donner par jour d'ouverture les horaires des premières et dernières séances

```js
db.Gymnases.aggregate([
    { $match: { "Ville": "STAINS" } },
    { $unwind: "$Seances" },
    { $project: { "nom": "$NomGymnase", "jour": { $toLower: "$Seances.Jour" }, "h": "$Seances.Horaire"}},
    { $group: { _id: { "nom": "$nom", "jour": "$jour" }, "debut": { $min: "$h"}, "fin": { $max: "$h" }}}
])
```

##### 22. Pour chaque entraîneurs de hand ball quel est le nombre de séances journalières qu'il assure ?

On récupère la liste des identifiants des entraîneurs de Hand.

```js
var entraineursHand = db.Sportifs.find({ "Sports.Entrainer" : "Hand ball" }, { _id: 0, IdSportif: 1 }).toArray().map(function(e) { return e.IdSportif });
```

On les utilise pour faire la restriction (avec le `$match`) dans l'aggrégation.

```js
db.Gymnases.aggregate([
    { $unwind: "$Seances" },
    { $match: { "Seances.IdSportifEntraineur": { $in: entraineursHand }}},
    { $project : { "ent": "$Seances.IdSportifEntraineur", "jour": { $toLower: "$Seances.Jour"}}},
    { $group: { _id: { "entraineur": "$ent", "jour": "$jour"}, nbSeances: { $sum: 1}}}
])
```


##### 23. Quels sont les gymnases ayant plus de 15 séances le mercredi ?

A priori, il n'y en a aucun.

```js
db.Gymnases.aggregate([
    { $unwind: "$Seances" },
    { $match: { "Seances.Jour": { $in: [ "mercredi", "Mercredi" ] }}},
    { $group: { _id: { "nom": "$NomGymnase", "ville": "$Ville" }, "nbMercredi": { $sum: 1 }}},
    { $match: { "nbMercredi": { $gte: 15 }}}
])
```

##### 24. Pour chaque gymnase de Montmorency : quel est le nombre de séances journalières de chaque sport propose ?

A faire pour vous entraîner...

##### 25. Dans quels gymnases et quels jours y a t-il au moins 4 séances de volley ball dans la journée ?

A faire pour vous entraîner...

