# HBase
type: slides

## Présentation

BD NoSQL distribué de type *Column Store*

Objectifs :
- Avoir un grande disponibilité
- Gérer les accès aléatoires en lecture et en écriture, tout en étant **consistent** 
- Servir de couche au-dessus de Hadoop et HDFS pour le stockage des données

---

## Histoire

- Basé sur BigTable de Google (2006)
- Prototype sorti en 2007, participation à Hadoop
- Hadoop : Top-level project par Apache en 2008
	- HBase devient un sous-projet
- En 2010, HBase repasse top-level project
- BD directement disponible et intégré à **Hadoop**

## Quelques liens 

- [Document sur Apache](http://hbase.apache.org/book.html)
- [post de Jim Wilson](http://jimbojw.com/wiki/index.php?title=Understanding_Hbase_and_BigTable)
- [Présentation à HUG France 2013](http://fr.slideshare.net/hugfrance/hugfr-sl2013-hbase)

---

## Quelques utilisateurs connus

- [Hadoop](hadoop.apache.org) bien sûr
- [Facebook](https://www.facebook.com/notes/facebook-engineering/the-underlying-technology-of-messages/454991608919) pour les messages
- [Yahoo!](https://developer.yahoo.com/blogs/ydn/apache-hbase-yahoo-multi-tenancy-helm-again-203911418.html)
- [Adobe](http://highscalability.com/blog/2010/3/16/1-billion-reasons-why-adobe-chose-hbase.html)
- [D'autres ici](http://wiki.apache.org/hadoop/Hbase/PoweredBy)
	- BigSecret
	- Caree.rs
	- Flurry
	- Infolinks
	- ...

---

## Modèle des données

- Données stockées dans des `tables`, contenant des `rows` et des `columns`
	- terminologie très (trop) proche des BD relationnelles
- `Table` : ensemble de `rows`
- `Row` : une `row key` associée à un certain nombre de `columns`
	- triées (alpha) sur la `row key` dans la table
- `Column` : donnée de base décrite par une `column family` et un `column qualifier`
- `Column family` : regroupement physique de `columns` (a priori correspondant au même thème)
	- chaque `row` d'une table a les mêmes `column families`
	- à définir lors de la création de la table
- `Column qualifier` : variable appartenant à une `column family`
	- sans contraintes (ajout possible d'un `qualifier` n'existant pas au préalable)
- `Cell`: donnée atomique comprenant la `row key`, la `column family`, le `column qualifier`, la valeur et un `timestamp` 
	- `timestamp` utile pour connaître la version de la donnée
	- nombre de versions à stocker paramètrable

---

## Quelques précisions

- `Rows` stockés selon l'ordre alphabétique des `row keys`
	- Pour optimiser certaines demandes, on peut avoir envie que des `rows` soient proches
	- Exemple classique : `row key` est un nom de domaine
		- `mail.chezmoi.fr`, `www.chezmoi.fr`, `www.parlabas.fr`
		- si pas de changement, `www.chezmoi.fr` plus proche de `www.parlabas.fr` que de `mail.chezmoi.fr`
		- inversion du nom de domaine : `fr.chezmoi.www` et `fr.chezmoi.mail` très proches
- Opérations possibles dans HBase (CRUD + scan)
	- `Get` : récupération des informations d'une `row`
	- `Put` : ajout d'une `row` ou mise à jour si déjà existante (**upsert**)
	- `Scan` : permet la réalisation d'opérations sur tout ou partie des `rows`
	- `Delete` : suppression d'une `row`
    
---

## Quelques précisions encore

- Types de données supportées
	- Tout ce qui est convertissable en tableau de `bytes` est stockable (chaîne, nombre,
objets complexes, images)
	- `Counters`
- Utilisation possible de `TTL` : durée de vie d'une donnée
- Création de la `row key`: on peut faire en sorte qu'il y ait de l'information directement
dans la clé (ce qui permettra des traitements plus rapides)
- Schéma à définir
	- les tables
	- les familles de colonnes

---
## Distribution et réplication des données

- Utilisation de HDFS pour stocker les données dans les fichiers
	- une `column family` par table dans un fichier (appelé `HTable`)
- Une `HTable` est composée de plusieurs `regions`
	- partitionnement horizontal
- Fonctionnement basé sur deux types de serveur : **Master** et **RegionServer**
	- Noeud **Master** (un seul) gérant les opérations du cluster
		- affectation, répartition, partitionnement
		- utilisation de **ZooKeeper** (gestion de configuration pour systèmes distribués)
	- Noeuds **RegionServer** (plusieurs esclaves)
		- stockage des données (par `regions`), exécution des lectures et écritures
		- dialogue direct avec les clients 

---
## Compléments

- Répartition automatique des données sur les `RegionServer`
- Partitionnement tout autant automatique
- Consistence forte 
- `table` triés par `rows`, et `rows` triés par `columns` 
	- accès rapide
- Clés composées à utiliser pour simplifier les opérations de tri et de regroupement
- Insertion et suppression d'un noeud dans le réseau

---
## Langage d'interrogation 

- général
	- `describe` : description d'une table
- en lecture
	- `get` : récupération d'une `row`
		- sélection de colonnes possible
	- `scan` : lecture des lignes d'une table
- en écriture
	- `create` : création d'une table
		- avec les `column family` en plus
		- paramètres possibles pour les `cf
	- `alter` : modification du schéma d'une table
	- `drop`: suppression d'une table
	- `put`: ajout d'une cellule dans une table
	- `delete`: suppression d'une ou plusieurs cellules

---
## Performances de Cassandra

- Environnement complexe mais très complet
- Eco-système très développé
- Communauté active
- Quelques comparatifs entre HBase et Cassandra
	- [sur BigDataNoob](http://bigdatanoob.blogspot.fr/2012/11/hbase-vs-cassandra.html) 
	- [sur infoworld](http://www.infoworld.com/article/2610656/database/big-data-showdown--cassandra-vs--hbase.html)
	- [post assez complet ](https://ria101.wordpress.com/2010/02/24/hbase-vs-cassandra-why-we-moved/)

	
---
## Interface avec les langages

- Client natif en JAVA ([lien vers la documentation](http://hbase.apache.org/apidocs/overview-summary.html))
- Plusieurs interfaces existent avec les langages courants ([voir ici](http://hbase.apache.org/book.html#external_apis))
	- Thrift
	- C/C++
	- Python, Scala
- Collection de librairies [RHadoop](https://github.com/RevolutionAnalytics/RHadoop/wiki) permettant de se connecter à HBase à partir de **R** (mais hors *CRAN*)
	- [rhbase](https://github.com/RevolutionAnalytics/RHadoop/wiki/user%3Erhbase%3EHome)
- Librairies permettant de se connecter à HBase à partir de **Python**
	- [HappyBase](http://happybase.readthedocs.org/en/latest/) 
	- [starbase](https://github.com/barseghyanartur/starbase)
