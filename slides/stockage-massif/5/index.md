type: slides
# MongoDB

## Présentation

BD  NoSQL distribué de type *Document Store* ([site web](http://www.mongodb.com/)) 

Objectifs :
- Gérer de gros volumes
- Facilité de déploiement et d'utilisation
- Possibilité de faire des choses complexes tout de même

---
## Histoire

- Développé par la compagnie *10gen* (devenu *mongodb* maintenant) depuis 2007
- Devenu open source en 2009
- BD NoSQL la plus connue

## Quelques liens

- [Documentation MongoDB](http://docs.mongodb.org/manual/) plutôt très bien faite
- [The Little MongoDB book](http://openmymind.net/mongodb.pdf)

---
## Quelques utilisateurs connus

- [The Weather Channel](http://www.mongodb.com/customers/weather-channel)
- [MetLife](http://www.mongodb.com/customers/metlife)
- [Bosch](http://www.mongodb.com/customers/bosch)
- [Expedia](http://www.mongodb.com/customers/expedia)
- [Forbes](http://www.mongodb.com/customers/forbes)
- [D'autres encore](http://www.mongodb.com/who-uses-mongodb)
	- Gov.uk, NCI, City of Chicago
	- BuzzFeed, eBay, FourthSquare, McAfee, LinkedIn
	- GAP, Under Armour,
	- The New York Times, MTV
	- Bouygues Telecom, Orange
	- ...

---

## Modèle des données

Principe de base : les données sont des `documents`
- stocké en *Binary JSON* (`BSON`)
- documents similaires rassemblés dans des `collections`
- pas de schéma des documents définis en amont
	- contrairement à un BD relationnel ou NoSQL de type *Column Store*
- les documents peuvent d'avoir aucun point commun entre eux
- un document contient (généralement) l'ensemble des informations
	- pas (ou très peu) de jointure à faire
- BD respectant **CP** (dans le théorème *CAP*)
	- propriétés ACID au niveau d'un document
    
---

## Point sur JSON

- **JavaScript Object Notation**
- Créé en 2005
- Format d'échange de données structurées léger
- Schéma des données non connu et contenu dans les données
- Basé sur deux notions :
	- collection de couples clé/valeur
	- liste de valeurs ordonnées
- Structures (au sens algorithme) présentes :
	- objet (couples clé/valeur) : `{}`, `{ "nom": "jollois", "prenom": "fx" }`
	- tableau (collection de valeurs) : `[]`, `[ 1, 5, 10]`
	- une valeur dans un objet ou dans un tableau peut être elle-même un objet ou un tableau


Validation possible du JSON sur [jsonlint.com/](http://jsonlint.com/)

---
## Exemple d'un JSON

```json
{
	"tubd": {
		"formation": "DU Analyste Big Data",
		"responsable": { "nom": "Poggi", "courriel": "jean-michel.poggi@parisdescartes.fr" },
		"etudiants" : [
			{ "id": 1, "nom": "jollois", "prenom": "fx" },
			{ "id": 2, "nom": "aristote", "details": "délégué" },
			{ "id": 5, "nom": "platon" }
		],
		"ouverte": true
	},
	"tudv": {
		"formation": "DU Data Visualisation",
		"ouverte": false,
		"todo": [
			"Creation de la maquette",
			"Validation par le conseil"
			],
		"responsable": { "nom": "Jollois" }
	}
}
```

---
## Compléments

`BSON` : extension de `JSON`
- Quelques types supplémentaires (identifiant spécifique, binaire, date, ...)
- Distinction entier et réel

Schéma dynamique
- Documents variant très fortement entre eux, même dans une même collection
- On parle de **self-describing documents**
- Ajout très facile d'un nouvel élément pour un document, même si cet élément est inexistant pour les autres
- Pas de `ALTER TABLE` ou de redesign de la base

Pas de jointures entre les collections
- Utilisation de `find()` et des curseurs

On peut commencer à travailler sans phase longue de modélisation 

---
## Distribution et réplication des données

- Réplication 
	- Définition d'un *replication set* (ensemble de noeuds pour réplication)
	- un noeud primaire par *set*
	- demandes envoyées au noeud primaire et réplication par la suite
	- si noeud primaire *down*, vote entre les noeuds secondaires pour trouver un nouveau noeud primaire
- Partitionnement horizontal (ou *sharding*) supporté 
	- Données
		- Découpage des données sur la base de clés
		- Allocation d'une plage de clé (ou plage de *hash* de clé) à chaque *shards*
		- Chaque *shard* est un *replication set*
	- Routeur (*query routers*) pour l'interface avec les clients
		- un ou plusieurs routeurs par *shard*
	- Trois serveurs de configuration pour stocker les métadonnées
	- Ajout de nouveaux *shards* assez simple


---
## Comparatif (fait par MongoDB)

Voici un comparatif sur quelques propriétés entre MongoDB, les BD relationnelles classiques 
et les BD NoSQL de type *key-value*

Property             | MONGODB | RELATIONAL | KEY-VALUE
---------------------|---------|------------|-----------
Rich Data Model      | Yes | No  | No
Dynamic Schema       | Yes | No  | Yes
Typed Data           | Yes | Yes | No
Data Locality        | Yes | No  | Yes
Field Updates        | Yes | Yes | No
Easy for Programmers | Yes | No  | Yes/No

BD de type *key-value* par forcément facile à manipuler si les structures de données sont complexes

	
---
## Langage d'interrogation

- Pas de SQL (forcément), ni de langage proche
- Définition d'un langage propre
- Langage permettant plus que les accès aux données
	- définition de variables
	- boucles
	- ...

Commandes suivantes réalisables à partir du `shell`

---
## Requêtage

- En écriture
	- `db.collection.insert(document)` : pour insérer de nouveaux documents
		- si la collection n'existe pas, elle est créée automatiquement
		- si l'identifiant `_id` n'est pas spécifié, il est automatiquement généré
		- possibilité d'utiliser la méthode `upsert` (en indiquant l'option)
			- mise à jour du document si présente
			- insertion sinon
	- `db.collection.update(cond, para)` : pour mettre à jour un ou plusieurs documents respectant une condition 
		- si `para` est un document classique, on remplace tout le document
		- si `para` est un document spécifique (avec `$set`, `$inc` ou `$push`), on met à jour le document
	- `db.collection.remove()` : pour supprimer des documents
		- en ajoutant un critère pour n'en supprimer que quelques uns.

---
## Requêtage

- En lecture
	- `db.collection.find()` : retourne les documents de la collection
	- `db.collection.find( { criteria } )` : retourne ceux qui spécifie le ou les critères
	- `db.collection.find( { criteria }, { element: val } )` : retourne que certains éléments des documents 
		- pour chaque élément
			- si `val=1`, il sera présent (inclusion)
			- si `val=0`, il sera absent (exclusion)
		- `_id` toujours présent, sauf si explicitement exclu (avec `_id: 0`)
		- ici `criteria` peut ne pas être présent
	- `db.collection.find().limit( nb )` : pour se limiter à un certain nombre de document
	- `db.collection.find().sort()` : pour trier les documents
	- si le résultat d'un `find()` est stocké dans une variable, on créé un `cursor`
		- `cursor.hasNext()` pour savoir s'il reste des documents dedans
		- `cursor.next()` : document suivant dans le curseur
		- `cursor.objsLeftInBatch()` : pour savoir combien de document il reste dans le curseur

---
## Agrégat

- `db.collection.agregate( tableau )` : calcul d'agrégat
	- mots-clés : `$group`, `$project`, `$match`, `$sort`, `$limit`, `$sum`
	- tableau passé en paramètre :
		- cellule  présente avec `$group` : détermine les regroupements et les calculs 
		- cellule après le `$group` : détermine le tri ou les conditions sur les agrégats
		- cellule avant le `$group` : détermine les conditions sur les documents 
	- `$unwind` permettant de naviguer dans des tableaux présents dans le document
- `db.collection.group( objet )` : agrégat avec une fonction particulière
	- fonction définie en JavaScript
	- objet passé en paramètre :
		- `key` : champs de regroupement (simple ou multiple)
		- `reduce` : fonction
		- `initial` : initialisation du résultat, si besoin
- `db.collection.mapReduce( map, reduce, options)` : algo Map-Reduce sur les documents 
	- `map` : fonction JavaScript
	- `reduce` : fonction JavaScript
	- `options` : options de l'algorithme

---
## Performance de MongoDB

- Développement rapide et itératif
- Modèle des données très flexible
- Passage à l'échelle très simple ([voir ici](https://www.mongodb.com/mongodb-scale) par exemple)
- Service de gestion du déploiement de MongoDB
- Declaré *DBMS of the Year 2014* ([voir ici](http://db-engines.com/en/blog_post/41))

Quelques comparatifs
- [Sur eventuallycoding](http://www.eventuallycoding.com/index.php/comparaison-de-moteurs-de-base-de-donnees-pour-du-stockage-de-logs/) avec elasticsearch, MySQL et Cassandra
- [Un comparatif indépendant](http://www.altoros.com/vendor_independent_comparison_of_nosql_databases.html) sur demande
- [par Open Software Integrators](http://osintegrators.com/sites/default/files/Mongo.Whitepaper.pdf) avec Hadoop

---
## Interface avec les langages

Plusieurs interfaces existent avec les langages courants ([voir ici](http://docs.mongodb.org/ecosystem/drivers/))
- PHP, Node.js
- C, C++, Java, .NET
- Perl, Ruby
- Python, R, Scala, Matlab

2 librairies permettant de se connecter à MongoDB à partir de **R** (mais hors *CRAN*)
- [rmongodb](https://github.com/gerald-lindsly/rmongodb) 
- [RMongo](https://github.com/tc/RMongo)

[PyMongo](http://api.mongodb.org/python/current/) permettant de se connecter à MongoDB à partir de **Python**
