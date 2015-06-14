# Cassandra
type: slides

## Présentation 

BD NoSQL distribué de type *Column Store* ([site web](http://cassandra.apache.org))

Objectifs :
- Gérer de grands volumes de données
- Résister aux pannes
- Réaliser le tout de manière performante

---
## Histoire

- Créé par Facebook, puis passé en Open Source
- Projet Apache maintenant 

## Quelques liens 

- [Documentation DataStax](http://www.datastax.com/docs) sur Cassandra
- [Introduction à Cassandra](http://www.jaxio.com/2012/01/06/introduction-a-cassandra-nosql-video.html), Nicolas Romanetti


---
## Quelques utilisateurs connus

- Apple (pas de source disponible)
- [Instagram](http://planetcassandra.org/blog/interview/facebooks-instagram-making-the-switch-to-cassandra-from-redis-a-75-insta-savings/)
- [Netflix](http://fr.slideshare.net/adrianco/migrating-netflix-from-oracle-to-global-cassandra)
- [eBay](http://fr.slideshare.net/jaykumarpatel/cassandra-at-ebay-13920376)
- [Reddit](http://planetcassandra.org/blog/interview/reddit-upvotes-apache-cassandra-for-horizontal-scaling-managing-17000000-votes-daily/)
- [D'autres encore](http://planetcassandra.org/companies/) :
	- Avast, Symantec
	- BlackBerry, Orange
	- Call of Duty, Ubisoft
	- Chronopost, FedEx, La Poste
	- Dell, HP, IBM, Microsoft
	- Disney
	- ING Group, PayPal
	- NASA
	- Shazam, SoundCloud, Spotify
	- The New York Times, The Weather Channel
	- Twitter
	- ...
	
---
## Modèle des données

<style>
	.colfam { background-color: #ded; border: solid 1px black; }
	.row { display: inline-flex; background-color: #333; padding: 5px; margin: 5px; }
	.rowkey { float: left; width:150px; background-color: #ddd; border: solid 1px black; text-align: center; }
	.column { float:left; background-color: #ddd; border: solid 1px black; }
	.cell { width: 150px; background-color: white; border: solid 1px black; text-align: center; }
	.name { background-color: #999; color: white;}
</style>

- `Column` : plus petite entité de la base
	- ensemble (`name`, `value`, `timestamp`)

<div class="column">
	<div class="cell name">name</div>
	<div class="cell">value</div>
	<div class="cell">timestamp</div>
</div>
<div style="clear: both;"></div>

- `Row` : ensemble de `columns` identifié par une clé (`row key`)
	- Pas de contraintes sur les `columns`: deux `rows` peuvent avoir un ensemble de `columns` complètement distincts
	- Equivalent d'un tuple (ligne) d'une table relationnelle

<div class="row">
<div class="rowkey">row key</div>
<div class="column">
	<div class="cell name">col.name</div>
	<div class="cell">col.value</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">col.name</div>
	<div class="cell">col.value</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">col.name</div>
	<div class="cell">col.value</div>
	<div class="cell">timestamp</div>
</div>
<span style="font-size:80%;color:white;text-align:center;margin-left:1em;">...<br>(2 milliards de<br>colonnes possible)</span>
</div>

---

- `table` : ensemble de `rows` identifié par un nom
	- Equivalent à une table relationnelle
	- ici, `Personnes` en est une
	- Pour accéder à une valeur atomique : `Personnes|1|nom = Jollois`

<div class="colfam">
<div style="text-align:center;"><strong>Personnes</strong></div>
<div class="row">
<div class="rowkey">1</div>
<div class="column">
	<div class="cell name">nom</div>
	<div class="cell">Jollois</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">prenom</div>
	<div class="cell">FX</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">adresse</div>
	<div class="cell">chez lui</div>
	<div class="cell">timestamp</div>
</div>
</div>

<div class="row">
<div class="rowkey">2</div>
<div class="column">
	<div class="cell name">nom</div>
	<div class="cell">Autre</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">adresse</div>
	<div class="cell">chez lui aussi</div>
	<div class="cell">timestamp</div>
</div>
</div>

<div class="row">
<div class="rowkey">4</div>
<div class="column">
	<div class="cell name">nom</div>
	<div class="cell">Connu</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">prenom</div>
	<div class="cell">Alain</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">adresse</div>
	<div class="cell">ailleurs</div>
	<div class="cell">timestamp</div>
</div>
<div class="column">
	<div class="cell name">page web</div>
	<div class="cell">http://sapage.ext</div>
	<div class="cell">timestamp</div>
</div>
</div>
</div>

---
## Quelques précisions

- le nom d'une colonne peut aussi être une valeur 
	- `valueless column` : il n'y a rien d'autre que le nom, qui est la donnée
- les colonnes sont triés par leur nom
- `counter column` : permet de compter (en incrémentant/décrémentant), pas de `timestamp`
- `expiring column` : comme son nom l'indique, `column` avec une certaine durée de vie (`TTL`: *time to live*)
- `composite column` : clé primaire à plusieurs valeurs, fait pour gérer des `rows` très larges
- `collection column` : ensemble de valeur de même type associé à un nom de `column` 
	- `set`, 
	- `list`, 
	- `map`

---
## Quelques précisions encore

- Deux types de `table`:
	- **statique** : ensemble de `columns` similaires entre les `rows` (très proche d'une table classique donc, utilisation de méta-données possible)
	- **dynamique** : les `column` ne se ressemblent que très peu (accès à gérer par les applications)
- récupération de `slice` de `columns` (en indiquant les `columns` de départ et de fin)
- pas de jointures : duplication des données dans des `tables` différentes, à penser lors de la conception du modèle
- recherche possible que sur les `row keys` : index secondaire à créer si on veut faire des recherches avec d'autres critères
- `keyspace` : espace intégrant des `tables` (équivalent à un schéma de BDR) servant principalement à contrôler les réplications

Il faut réfléchir aux requêtes qu'on voudra exécuter pour réfléchir au modèle.

Plusieurs solutions possibles à chaque problème.

---
## Passage à l'échelle

L'intérêt de **Cassandra** est la gestion des gros volumes :
- BD distribuée avec une architecture `masterless`
- plusieurs **noeuds**, tous identiques en fonctionnement
- passage à l'échelle *linéaire* (en fonction du nombre de noeuds)
- données partitionnées selon les `row keys` : une `row` est insécable, mais deux `rows` d'une même `table` peuvent ne pas être au même endroit
	- on parle de `partition key` (potentiellement une partie de la `primary key`)

Quelques notions sont très importantes à comprendre :
- **Ring** 
- **Partition**
- **Replication**

---
## Architecture du réseau

- Termes utilisés :
	- *Node* : noeud, composant de base
	- *Data center* : collection de noeuds reliés (correspondant à un regroupement physique ou virtuel)
	- *Cluster* : ensemble de *data centers*
	- *Coordinator* : le noeud contacté par le client sert de coordinateur pour savoir quel noeud questionner pour répondre à la demande du client
	- *Commit log* : informations à écrire d'abord intégrées à ce *log*, puis réparties sur les noeuds, puis supprimées ou archivées
	- *Gossip* : communication entre noeuds pour s'échanger des informations (lieu et état)
- Les noeuds sont (virtuellement) placés sur un anneau (**ring**)
- Chaque noeud a un identifiant (déterminé par un nombre entre 1 et le nombre de noeuds)

---
## Distribution et réplication des données

Cheminement pour intégrer une donnée dans le système :
1. Le client indique à un noeud la donnée qu'il veut écrire
2. Le noeud devient alors le coordinateur pour cette donnée
3. Assignation de la donnée au noeud correspondant (via un `partitionner`) 
	- plusieurs choix de répartition :
		- `hash value` sur `partition key`, chaque noeud a une plage de `hash value`, 
		- on fait de l'aléatoire
		- on garde un ordre sur la clé
	- à terme, les noeuds seront *balancés* (i.e. même charge de données)
4. Pour éviter les défaillances lors d'une panne, on utilise une réplication :
	- définition d'un `replication factor` ou `RF` qui indique le nombre de copie
	- deux stratégies possible :
		- `SimpleStrategy` : sur le noeud indiqué par le `partitionner` et les suivants dans l'anneau (un seul data center)
		- `NetworkTopologyStrategy` : permet de distribuer sur plusieurs data centers (pour éviter les problèmes lors de la faille d'un data center)
		
---
## Cohérence de la base

Doit-on s'assurer que toutes les données sont répliquées correctement lors de l'écriture ?
- Dépendant du contexte
- Définition du niveau de `consistency` en écriture :
	- `ALL` : tous les replicas sont écrits
	- `QUORUM` : une majorité des replicas sont écrits 
	- `ONE`, `TWO`, `THREE`: un, deux ou trois replicas sont écrits
	- ...

Doit-on s'assurer que toutes les données lues sont les dernières écrites ?
- Dépendant du contexte
- Définition du niveau de `consistency` en lecture :
	- `ALL` : tous les replicas sont lus
	- `QUORUM` : une majorité des replicas sont lus 
	- `ONE`, `TWO`, `THREE`: un, deux ou trois replicas sont lus
	- ...

---
## Cohérence de la base (suite)

Cassandra est une BD avec une cohérence **BASE**

Le choix des niveaux de cohérence en écriture et en lecture va déterminer la balance entre **CP** et **AP** (sur le théorème **CAP**)

Si consistence forte demandée : 
- on se fixe comme règle `W` + `R` > `RF` 
	- `W` : nombre de noeuds contactés en lecture
	- `R`: nombre de noeuds contactés en écriture
	- `RF`: nombre de replicas
- exemple : `ALL` en écriture et `ONE` en lecture

---
## En cas de défaillance

- Si un noeud est *down*, une fois réparé, il faut le recharger avec les données des autres noeuds
	- Plusieurs possibilité de réparation (séquentiel/parallèlement, incrémentalement, ...)
- Si c'est juste une opération qui n'a pas pu être réparé 
	- problème réseau ou autre
	- notion de `hinted handoff` : 
		- on écrit la donnée sur une autre noeud disponible
		- ce noeud écrit sur le noeud initialement prévu lorsque celui-ci revient dans le *ring*
		- processus utilisant le *gossip* (protocole peer to peer : chaque noeud contacte jusqu'à trois autres noeuds chaque seconde)
- Gestion des suppressions avec la notion de `tombstone`
	- garde en mémoire la suppression pendant un certain temps
	- renvoie la suppression sur les replicas qui étaient *down* 

Plus il y a de noeuds, et plus le replication factor est grand, plus le système est résistant aux défaillances

---
## Langage d'interrogation 

Cassandra dispose d'un langage d'interrogation : `CQL` (pour *Cassandra Query Language*)
- Documentation assez propre ([lien](http://www.datastax.com/documentation/cql/3.1/index.html))
- Très proche de `SQL` :
	- `CREATE TABLE tab ();`
	- `ALTER TABLE tab ADD att type;`	
	- `INSERT INTO tab (att, ...) VALUES (exp, ...);`
	- `UPDATE tab SET att = exp WHERE cond;`
	- `SELECT * FROM tab WHERE cond ORDER BY col;`
	- `DROP TABLE tab;`
	- `DELETE FROM tab WHERE cond;`
	- ...
- Pour chaque `column`, il existe la fonction `WRITETIME` permettant de savoir quand a été écrit la donnée

---
## Performances de Cassandra

- Très rapide en écriture
	- pas d'update
	- toutes les évolutions sont écrites
	- suppressions des infos obsolètes lors d'une `compaction`
- Très rapide en lecture
	- utilisation de `bloom filter` (outil permettant de vérifier que la donnée n'est pas déjà présente dans la mémoire avant d'aller faire des opérations sur disques)
	- regarde ensuite dans le `cache`

Quelques comparatifs :
- Sur [PlanetCassandra](http://planetcassandra.org/nosql-performance-benchmarks/)
- Par [DataStax](http://www.datastax.com/dev/blog/cassandra-architecture-and-performance-mid-2014) (promoteur de Cassandra)
- Sur [Cubrid.org](http://www.cubrid.org/blog/dev-platform/nosql-benchmarking/) (indépendant)
	
---
## Interface avec les langages

Plusieurs interfaces existent avec les langages courants ([voir ici](http://planetcassandra.org/client-drivers-tools/))
- ODBC
- PHP, Node.js
- C++, Java, .NET
- Python, R, Scala
- Spark

Librairie [RCassandra](http://www.rforge.net/RCassandra/index.html) permettant de se connecter à Cassandra à partir de **R**
- `RC.connect` et `RC.close` pour gérer la connection
- `RC.get` (et d'autres) pour récupérer des informations
- `RC.insert` et `RC.mutation` pour insertion et mise à jour

[Python-driver](http://datastax.github.io/python-driver/getting_started.html) permettant de se connecter à Cassandra à partir de **Python**
