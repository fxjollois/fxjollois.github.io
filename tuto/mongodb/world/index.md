# World DB - MongoDB

Dans ce tutoriel, nous allons voir comment, à partir d'une base de données relationnelle
classique, nous pouvons passer à une base de données de type NoSQL, et plus particulièrement 
une BD *Document Store*, orientée document. Pour cela, nous allons utiliser [MongoDB](http://www.mongodb.org/)

**MongoDB** se base sur des documents JSON. Ceux-ci peuvent inclure des éléments de tout
type, dont des tableaux ou des objets complexes. 

Pour information, la base de données de départ est au format [SQLite](http://www.sqlite.org/).

## La base de données de départ

<script src="../lib/BDRschema.js"></script>
<div id="worldDB"></div>
<script>
var paper = Raphael("worldDB", 400, 200);
// paper.rect(0, 0, 400, 300);
tA = paper.table(0, 0, "Country", 
                 ["Code", "Name", "..."])
tB = paper.table(300, 0, "City", 
                 ["ID", "Name", "CodeCountry", "Population"])
tC = paper.table(200, 100, "CountryLanguage", 
                 [ "CodeCountry", "Language", "IsOfficiel", "Percentage"])
paper.connection(tA, tB)
paper.connection(tA, tC)
</script>

## Les choix pour les changements

Ici, j'ai fait le choix de n'avoir qu'un document JSON par pays, et donc pour chaque tuple
de la table `Country`, nous aurons un JSON intégrant les informations de `City` et de
`CountryLanguage`. Voici ce à quoi va ressembler le document pour un pays :

```js
{
	Code: "XXX",
	Name: "Nom du pays",
	...,
	Capital: { Name: "Nom de la capitale", Population: 123456789 },
	Cities: [
		{ Name: "Nom de la ville", Population: 12345 },
		...
	],
	OffLang: [
		{ Language: "Nom de la langue", Percentage: 12.3 },
		...
	],
	NonOffLang: [
		{ Language: "Nom de la langue", Percentage: 12.3 },
		...
	]
}
```

Bien évidemment, il faut gérer les cas particuliers :
- sans capitale,
- sans villes autre que la capitale, voire aucune ville associée,
- sans langue officielle,
- sans langue non officielle.

Pour cela, les objets en seront pas présents dans le document du pays concerné. C'est là
la force des BD NoSQL justement, deux entités peuvent avoir un schéma différent. Cette
non présence de l'information sera très bien gérée par la base de données. Lors d'une
recherche sur la population de la capitale par exemple, les pays dont le document
correspondant n'a pas le champs `Capital` ne seront pas pris en compte tout simplement.

## De SQLite à MongoDB

Il nous faut donc créer un script pour passer de l'un à l'autre. J'ai fait le choix de
le faire avec [R](http://www.r-project.org), car c'est un logiciel que je maîtrise bien.

Voici le code utilisé :

```r
a mettre
```

## Requêtage SQL et NoSQL - type MongoDB

C'est bien évidemment ici la partie intéressante : nous allons regarder quelles sont les
différences entre un requêtage SQL sur la base de données au format relationnel (donc
sous SQLite) et un requêtage via MongoDB sur cette même base de données, mais au format
*Document Store*.


