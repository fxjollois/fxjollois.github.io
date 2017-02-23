---
title: Interrogation de données
date: du NoSQL avec MongoDB
---

## Plan 

- Introduction à MongoDB
    - JSON
    - NoSQL
- Opérations usuelles

## Présentation

BD NoSQL distribué de type *Document Store* ([site web](http://www.mongodb.com/)) 

Objectifs :

- Gérer de gros volumes
- Facilité de déploiement et d'utilisation
- Possibilité de faire des choses complexes tout de même

## Modèle des données

Principe de base : les données sont des `documents`

- stocké en *Binary JSON* (`BSON)
- documents similaires rassemblés dans des `collections`
- pas de schéma des documents définis en amont
	- contrairement à un BD relationnel ou NoSQL de type *Column Store*
- les documents peuvent n'avoir aucun point commun entre eux
- un document contient (généralement) l'ensemble des informations
	- pas (ou très peu) de jointure à faire
- BD respectant **CP** (dans le théorème *CAP*)
	- propriétés ACID au niveau d'un document

	
## Point sur `JSON`

- `JavaScript Object Notation`
- Créé en 2005
- On parle de **littéral**
- Format d'échange de données structurées léger
- Schéma des données non connu 
    - contenu dans les données
- Basé sur deux notions :
	- collection de couples clé/valeur
	- liste de valeurs ordonnées

---

*(`JSON` suite)* 

- Structures possibles :
	- objet (couples clé/valeur) : 
	   - `{}`
	   - `{ "nom": "jollois", "prenom": "fx" }`
	- tableau (collection de valeurs) : 
	   - `[]`
	   - `[ 1, 5, 10]`
	- une valeur dans un objet ou dans un tableau peut être elle-même un littéral
- Deux types atomiques (`string` et `number`) et trois constantes (`true`, `false`, `null`)

Validation possible du JSON sur [jsonlint.com/](http://jsonlint.com/)

---

```json
{
	"tubd": {
		"formation": "DU Analyste Big Data",
		"responsable": { "nom": "Poggi", "prenom": "JM" },
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
		"responsable": { "nom": "Métivier" }
	}
}
```

## Compléments

`BSON` : extension de `JSON`

- Quelques types supplémentaires (identifiant spécifique, binaire, date, ...)
- Distinction entier et réel

**Schéma dynamique**

- Documents variant très fortement entre eux, même dans une même collection
- On parle de **self-describing documents**
- Ajout très facile d'un nouvel élément pour un document, même si cet élément est inexistant pour les autres
- Pas de `ALTER TABLE` ou de redesign de la base

**Pas de jointures entre les collections**


## Langage d'interrogation

- Pas de SQL (bien évidemment), ni de langage proche
- Définition d'un langage propre
- Langage permettant plus que les accès aux données
	- définition de variables
	- boucles
	- ...

Commandes suivantes réalisables à partir du `shell`

Existence d'une librairie R : [rmongodb](https://github.com/mongosoup/rmongodb)

## Restriction

La commande `db.collection.find()`, dans laquelle `collection` désigne la collection sur laquelle on travaille, permet de retourner tous les documents.

La commande `db.collection.findOne()` retourne un élément (le premier a priori).

Pour faire une restriction, on doit passer un critère (ou un ensemble de critère) en paramètre :

```js
db.collection.find({ attribut: valeur });
```

Les critères sont au format `JSON`

## Projection

Toujours avec la commande `db.collection.find()`, il est possible de ne choisir que certains éléments à afficher. Pour cela, on doit passer en deuxième paramètre un littéral `JSON` avec pour chaque élément

- si `attribut: 1`, il sera présent (inclusion)
- si `attribut: 0`, il sera absent (exclusion)
- `_id` toujours présent, sauf si explicitement exclu (avec `_id: 0`)

Si on veut une projection sans restriction :

```js
db.collection.find({ }, { attribut1: 1, attribut2: 1 });
```

## Décompte, Limitation du résultat et Tri

Pour compter le nombre de documents :

```js
db.collection.find().count();
```

Pour n'avoir que les $n$ premiers documents :

```js
db.collection.find().limit(10);
```

Pour trier les documents, fonction `sort()`, qui prend en paramètre un littéral décrivant quels attributs on utilise et comment :

- si `attribut: 1` : tri croissant
- si `attribut: -1` : tri décroissant

```js
db.collection.find().sort({ attribut: 1 });
```

## Agrégat

Il existe la fonction `db.collection.aggregate( tableau )` qui permet le calcul d'agrégat. Le tableau peut contenir les éléments suivants (dans des littéraux) :

- `$project` : redéfinition des documents (si nécessaire)
- `$match` : restriction sur les documents à utiliser
- `$group` : regroupements et calculs à effectuer
- `$sort` : tri sur les agrégats
- ...

```js
db.collection.aggregate([
    { $group: { 
        _id: "$attributQl", 
        total: { $sum: "$attributQt" } 
    } }
])
```

## Curseurs

Il n'existe **pas de processus de jointures** dans MongoDB (ce n'est pas l'idée).

Pour cela, on doit utiliser des curseurs (ou `cursor`) en stockant le résulat d'un `find()` dans une variable, on créé un `cursor`. Celui-ci a des fonctions permettant de naviguer dans ce résultat (pour faire les jointures)

- `cursor.hasNext()` : pour savoir s'il reste des documents dedans
- `cursor.next()` : document suivant dans le curseur
- `cursor.objsLeftInBatch()` : pour savoir combien de document il reste dans le curseur


## Map-Reduce

Le paradigme **Map-Reduce** permet de décomposer une tâche en deux étapes :

1. **Map** : application d'un algo sur chaque document, cet algo renvoyant un résultat ou une série de résultat
2. **Reduce** : synthèse des résultats renvoyés dans l'étape précédente selon certains critères

Exemple classique : *décompte des mots présents dans un ensemble de texte*

- *Map* : pour chaque texte, à chaque mot rencontré, on créé un couple `<mot, 1>` (un document = beaucoup de résultats générés)
- *Reduce* : pour chaque mot, on fait la somme des valeurs pour obtenir le nombre de fois où chaque mot apparaît dans l'ensemble des textes à disposition

## Map-Reduce (suite)

On utilise la fonction `db.collection.mapReduce()` pour appliquer l'algo Map-Reduce sur les documents de la collection, avec les paramètres suivants :

- `map` : fonction JavaScript
    - aucun paramètre
    - `emit(key, value)` pour créer un couple résultat
- `reduce` : fonction JavaScript
    - deux paramètres : `key` et `values` (tableau des valeurs créés à l'étape précédente)
    - `return result` pour renvoyer le résultat
- `out` : collection dans laquelle stocker les résultats
- ...


		
