---
title: BD avancées - TP1
---

Dans ce TP, nous allons reprendre la base de données Gymnase2000 (disponible au format `JSON` [ici](https://drive.google.com/folderview?id=0BzA8L2nqa1n5NXZBTHJnclFZMDA&usp=drive_web)).

Mais nous allons utiliser ce script de connexion sous `R` en utilisant la librairie [rmongodb](https://github.com/mongosoup/rmongodb) (les requêtes sont très ressemblantes à ce qu'on peut faire en direct sur la console) :

```r
library(rmongodb)

# Création de la connextion
con = mongo.create(host = "172.19.32.10")
mongo.is.connected(con) # renvoie TRUE si c'est OK

# Liste des bases de données et des collections de la base "gym"
mongo.get.databases(con)
mongo.get.database.collections(con, "gym")

# Nombre de documents dans la collection "Sportifs" de la BD "gym"
mongo.count(con, "gym.Sportifs")
# Liste les valeurs distinctes de la variable "Sexe" de la collection "gym.Sportifs"
mongo.distinct(con, "gym.Sportifs", "Sexe")
# Retourne le premier document
mongo.find.one(con, "gym.Sportifs")
# Idem mais transformé en liste
mongo.bson.to.list(mongo.find.one(con, "gym.Sportifs"))
# Valeur de la variable "Nom" du résultat précédemment trouvé
mongo.bson.value(mongo.find.one(con, "gym.Sportifs"), "Nom")
# Liste de tous les documents
mongo.find.all(con, "gym.Sportifs")
# Idem mais dans un curseur
cursor = mongo.find(con, "gym.Sportifs")
while (mongo.cursor.next(cursor))
  print(mongo.cursor.value(cursor))
# Liste des noms de toutes les sportives
mongo.find.all(
  con, "gym.Sportifs",
  query = '{ "Sexe": "F"}',
  fields= '{ "_id": 0, "Nom": 1 }'
  )
```

Il est impératif de répondre aux demandes sans utiliser le langage SQL.

### Requêtes à créer

01. Quels sont les sportifs (identifiant, nom et prénom) qui ont entre 20 et 30 ans ?
02. Quels sont les gymnases de "Villetaneuse" ou de "Sarcelles" qui ont une surface de plus de 400 m2 ?
03. Quels sont les sportifs (identifiant et nom) qui pratiquent du hand ball ?
04. Dans quels gymnases et quels jours y a t-il des séances de hand ball ?
05. Dans quels gymnases peut-on jouer au hockey le mercredi apres 15H ?
06. Quels sportifs (identifiant et nom) ne pratiquent aucun sport ?
07. Quels gymnases n'ont pas de séances le dimanche ?
08. Quels gymnases ne proposent que des séances de basket ball ou de volley ball ?
09. Quels sont les entraîneurs qui sont aussi joueurs ?
10. Quels sont les sportifs qui sont des conseillers ?
11. Pour le sportif "Kervadec" quel est le nom de son conseiller ?
12. Quels entraîneurs entraînent du hand ball et du basket ball ?
13. Quels sont les couples de sportifs (identifiant et nom et prénom de chaque) de même age ?
14. Quelle est la moyenne d'âge des sportives qui pratiquent du basket ball ?
15. Quels sont les sportifs les plus jeunes ?
16. Quels sont les gymnases de "Stains" ou de "Montmorency" qui ont la plus grande surface ?
17. Quels entraîneurs n'entraînent que du hand ball ou du basket ball ?
18. Quels sont les couples de sportifs (identifiant et nom et prénom de chaque) de même âge avec le même conseiller ?
19. Quels sportifs n'ont pas de conseillers ?
20. Pour chaque sportif donner le nombre de sports qu'il arbitre
21. Pour chaque gymnase de Stains donner par jour d'ouverture les horaires des premières et dernières
séances
22. Pour chaque entraîneurs de hand ball quel est le nombre de séances journalières qu'il assure ?
23. Quels sont les gymnases ayant plus de 15 séances le mercredi ?
24. Pour chaque gymnase de Montmorency : quel est le nombre de séances journalières de chaque sport
propose ?
25. Dans quels gymnases et quels jours y a t-il au moins 4 séances de volley ball dans la journée ?

## Solutions

- [Première partie](bd-prog-avancees-bd-tp1-solution1.R) : 4 premières questions