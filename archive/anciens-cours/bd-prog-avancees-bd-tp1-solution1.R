# Fonction permettant un affichage plus "joli" du résultat d'une requête find
mongoQueryFind <- function (...) {
  cursor = mongo.find(...)
  while (mongo.cursor.next(cursor)) {
    print(mongo.cursor.value(cursor))
    cat("\n")
  }
}
mongoQueryFind(con, "gym.Sportifs", limit = 5L)
mongo.find.all(con, "gym.Sportifs", limit = 5L)

# 1. Quels sont les sportifs (identifiant, nom et prénom)
# qui ont entre 20 et 30 ans ?
mongoQueryFind(
  con, "gym.Sportifs",
  query= '{ "Age": { "$gte": 20, "$lte": 30 } }',
  fields= '{ "_id":0, "IdSportif": 1, "Nom": 1, "Prenom": 1, "Age": 1 }'
)

# 2. Quels sont les gymnases de “Villetaneuse” ou de “Sarcelles” qui
ont une surface de plus de 400 m2 ?
mongoQueryFind(
  con, "gym.Gymnases",
  query = '{
    "Surface": { "$gt": 400 },
    "Ville": { "$in": [ "VILLETANEUSE", "SARCELLES" ]}
  }',
  fields = '{ "_id":0, "NomGymnase": 1, "Ville": 1}'
)

# 3. Quels sont les sportifs (identifiant et nom) qui pratiquent du hand ball ?
mongoQueryFind(
  con, "gym.Sportifs",
  query='{"Sports.Jouer": "Hand ball" }',
  fields = '{ "_id":0, "IdSportif": 1, "Nom": 1, "Prenom": 1,
"Sports.Jouer": 1 }'
)

# 4. Dans quels gymnases et quels jours y a t-il des séances de hand ball ?
mongoQueryFind(
  con, "gym.Gymnases",
  query= '{ "Seances.Libelle": "Hand ball" }',
  fields= '{ "_id": 0, "NomGymnase": 1, "Seances.Jour": 1,
"Seances.Libelle": 1}'
)
mongo.aggregation(
  con, "gym.Gymnases",
  pipeline = list(
    '{ "$match" : {"Seances": { "$elemMatch": {"Libelle": "Hand ball"}} } }',
    '{ "$unwind" : "$Seances" }',
    '{ "$match" : { "Seances.Libelle" : "Hand ball" } }',
    '{ "$group" : {
        "_id" : "$_id",
        "Gymnase": { "$addToSet": "$NomGymnase"},
        "Jour" : { "$addToSet" : "$Seances.Jour" },
        "Sport" : { "$addToSet" : "$Seances.Libelle" }
    }}'
  )
)