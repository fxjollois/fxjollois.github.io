---
title: Paradigme MapReduce et algorithme EM
---

## F.-X. Jollois

### Séminaire équipe Fouille de données, LIPADE 
### 1er décembre 2014

Présentation basée sur la lecture des articles présentés ci-après et quelques autres sources.

But : faire un point technique sur le sujet 

## Introduction

Quelques références intéressantes :

- *Parallel K-Means Clustering Based on MapReduce*, Weizhong Zhao et al [article](www.geog.ucsb.edu/~hu/papers/ParallelK.pdf)
- *Large-Scale Data Sets Clustering Based on MapReduce and Hadoop*, Ping ZHOU et al [article](http://www.jofcis.com/publishedpapers/2011_7_16_5956_5963.pdf)
- *Map-Reduce for Machine Learning on Multicore*, ChengTao Chu et al [article](http://www.cs.stanford.edu/~ang/papers/nips06-mapreducemulticore.pdf)
- *Heterogeneous Computing Based K-Means Clustering Using Hadoop-MapReduce Framework*, Ganage et al [article](http://www.ijarcsse.com/docs/papers/Volume_3/6_June2013/V3I6-0292.pdf)
- *Serial and parallel implementations of model-based clustering via parsimonious Gaussian mixture models*, P.D. McNicholas et al [article](http://www.sciencedirect.com/science/article/pii/S0167947309000632)
- *Fully Distributed EM for Very Large Datasets*, Jason Wolfe et al [article](http://w01fe.com/berkeley/pubs/08-icml-em.pdf)

## Plan de la présentation

- Paradigme de MapReduce
- Dans un cadre de classification
- Adaptation de EM à MapReduce
- Conclusion 
- Alternatives

## Présentation de MapReduce

- Framework développé par Google
- Permet l'écriture simple de programmes sur des clusters informatiques (possiblement très gros)
- Idée de base de la parallélisation des tâches : diviser pour régner
- 2 étapes donc :
	- Etape 1 :
		1. Diviser le travail à faire en plusieurs tâches 
		2. Réaliser les tâches en parallèle 
	- Etape 2 :
		3. Récupérer les différents résultats
		4. Regrouper ceux-ci pour obtenir le résultat final

## Paradigme de MapReduce

Le framework MapReduce est constitué de :
- un seul *JobTracker*, qui sera le chef d'orchestre :
	- programmation (*scheduling*) des jobs aux musiciens
	- gestion des défaillances de ceux-ci
- un *TaskTracker* par noeud du cluster, qui sera un musicien :
	- exécution des tâches demandés par le chef

Le travail se fait exclusivement sur des paires $< key, value>$
- Entrées : ensemble de paires $< key, value>$
- Sorties d'un job : paires $< key, value>$

## Schéma de MapReduce 

<img src="mapreduce-em/Mapreduce.png" style="margin: 0 auto;" width="673">

<div class="footnote">Source : <a href="http://commons.wikimedia.org/wiki/File:Mapreduce.png" target="_blank">http://commons.wikimedia.org/wiki/File:Mapreduce.png</a></div>

## Etapes Map et Reduce

Comme indiqué, cela s'articule autour de deux grandes étapes (**Map** et **Reduce**)  :
- Etape **Map** :
	- réalisé dans chaque noeud du cluster
	- souvent un seul des deux paramètres intéressant 
	- calcule une liste de couples $< key, value >$
- Etape **Reduce** :
	- traitement sur les valeurs ($value$) pour chaque $key$
	- travail possible en parallèle
	- tous les couples avec le même $key$ arrivent au même *worker*
	
## Exemple basique : comptage de mots

Deux fonctions à écrire : `map(key, value)` et `reduce(key, value)`

```php
map(string key, string value) {
	// key: document name
	// value: document contents
	for each word w in value 
		emit <w, 1>
}

reduce(string key, list value) {
	// key: word
	// value: list of each word appareance
	sum = 0
	for each v in value
		sum = sum + v
	emit <key, sum>
}
```

<div class="footnote">Ceci n'est pas un exemple littéral, mais une adaptation pour illustration</div>

## Exemple basique : comptage de mots

<img src="mapreduce-em/example-mapreduce-wordcount.png" width=100%>

<div class="footnote">Source : <a href="http://blog.trifork.com/wp-content/uploads/2009/08/" target="_blank">http://blog.trifork.com/wp-content/uploads/2009/08/</a></div>

## Algorithme plus détaillé de MapReduce

- Lecture des entrées dans le système de fichier distribué, découpages en blocs de taille identique, et assignation de chaque bloc à un *worker*
- Application de la fonction `map()` dans chaque *worker*
- Distribution des résultats de `map()` (étape **Shuffle**) en fonction des clés
- Application de la fonction `reduce()` (en parallèle ou non, selon les besoins)
- Ecriture de la sortie dans le système de fichier distribué (généralement)

## Caractéristiques 

- Modèle de programmation simple : 
	- deux fonctions à écrire (`map()` et `reduce()`)
	- indépendant du système de stockage
	- adaptatif à tout type de données
- Ajout possible d'une fonction `combine()` des résultats de `map()` pour les couples avec même clé
- Système gérant seul le découpage, l'allocation et l'exécution
- Tolérance aux défaillances (redémarrage de tâches, réaffectation)
- Parallélisation invisible à l'utilisateur

## Quelques critiques

- Pas de garantie d'être rapide : attention à l'étape *shuffle* qui peut prendre du temps, et qui n'est pas adaptable par l'utilisateur
- Coût de communication pouvant être important
- Pas adapté à des problèmes où les données peuvent tenir en mémoire ou à un petit cluster
- Pas de support de langage haut niveau, tel que SQL
- Est une réelle nouveauté ?
	- Proche d'autres implémentations, tel que *Clusterpoint* ou *MongoDB* 
	- Facilement applicable avec PL/SQL sous *Oracle*
- Pas optimisé au niveau des entres/sorties, et donc pas forcément adapté à un problème de *Machine Learning* dans lequel on doit régulièrement lire le même jeu de données plusieurs fois

## Implémentations

Toutes *open source* et *forkable* sur GitHub

- **Hadoop** [site web](http://hadoop.apache.org/)
	- Framework basé sur le système de fichiers distribués *HDFS*
- **CouchDB** [site web](http://couchdb.apache.org/)
	- BD *NoSQL*, basée sur JSON et JavaScript
- **InfiniSpan** [site web](http://infinispan.org/)
	- BD *NoSQL* 
- **MongoDB** [site web](http://www.mongodb.org/)
	- BD *NoSQL*, basée sur JSON et JavaScript
- **Riak** [site web](http://basho.com/riak/)
	- BD *NoSQL* 

## Et dans un cadre de classification

- Proposition d'implémentation des fonctions `map()` et `reduce()` dans le cadre de $k$-means en dimension 2
- Présentation des détails de certains articles :
	- Implémentations sensiblement différentes selon les articles
	- Dans l'article *Parallel K-Means Clustering Based on Mapreduce*, Weizhong Zhao et al [lien](www.geog.ucsb.edu/~hu/papers/ParallelK.pdf)
	- Dans l'article *Map-Reduce for Machine Learning on Multicore*, Cheng-Tao Chu et al [lien](http://www.cs.stanford.edu/~ang/papers/nips06-mapreducemulticore.pdf)
	- Dans l'article *Large-Scale Data Sets Clustering Based on MapReduce and Hadoop*, Ping ZHOU et al [lien](http://www.jofcis.com/publishedpapers/2011_7_16_5956_5963.pdf)
- Réflexion dans le cadre de *EM*

## Dans le cadre de $k$-means - `map()`

Proposition d'implémentation des fonctions `map()` et `reduce()` en dimension 2

```php
map(key, value) { 
	//key: subset id
	// value: subset of the dataset
	for each i in values {
		ki = assignCluster(i, centers)
		centersNew[ki][x] += i[x]
		centersNew[ki][y] += i[y]
		centersNew[ki][n] += 1 // or i[n] if weighted objects
	}
	for each k {
		emit (k, centersNew[k]) // where centersNew[k] is a vector (x, y, n)
	}
}
```

## Dans le cadre de $k$-means - `reduce()`

```php
reduce(key, value) { 
	// key: cluster id
	// value: list of vectors (x, y, n) emit by map() functions
	x = 0, y = 0, n = 0
	for each v in value {
		x += v[x], y += v[y], n += v[n]
	}
	x = x / n
	y = y / n
	emit(k, [x, y, n])
}
```

## *Parallel K-Means Clustering Based on MapReduce*, Weizhong Zhao et al [lien](www.geog.ucsb.edu/~hu/papers/ParallelK.pdf)

- Implémentation de $k$-means dans le contexte MapReduce
- 3 fonctions détaillées :
	- `map()` :
		- Entrées : centres des classes, couple (id de l'individu, valeurs pour l'individu)
		- Sorties : couple (classe affectée, chaîne représentant les valeurs de l'individu)
	- `combine()` :
		- Entrées : couple (id de la classe, liste des individus affectées à la classe)
		- Sorties : couple (id de la classe, chaîne représentant les sommes des valeurs et le nombre d'individus)
	- `reduce()`
		- Entrées : couple (id de la classe, liste des calculs partiels de somme et des nombres d'individus)
		- Sorties : couple (id de la classe, chaîne représentant les centres des classes)

## *Map-Reduce for Machine Learning on Multicore*, Cheng-Tao Chu et al [lien](http://www.cs.stanford.edu/~ang/papers/nips06-mapreducemulticore.pdf)

- Adaptation de plusieurs méthodes dans le contexte *MapReduce*
- $k$-means : 
	- Découpage des données en sous-groupes
	- Calcul de la distance des individus aux centres, par sous-groupes
	- Calcul des sommes dans chaque sous-groupes et calcul des nouveaux centroïdes
- EM : 
	- chaque mapper travaille sur un sous-groupe spécifique des données
	- Dans l'étape E, les mappers calculent les probabilités a posteriori $t_{ik}$
	- Dans l'étape M :
		- pour les probabilités d'appartenance aux classes, chaque mapper fait la somme des $t_{ik}$ et le reducer fait la somme et divise par $n$
		- pour les moyennes, chaque mapper fait la somme des valeurs pondérées par les probas a posteriori et la somme des probas, et le reducer fait les sommes et la division
		- pour les matrices de variance-covariance, chaque mapper fait les sommes localement, et le reducer fait les sommes et la division
	
## *Large-Scale Data Sets Clustering Based on MapReduce and Hadoop*, Ping ZHOU et al [lien](http://www.jofcis.com/publishedpapers/2011_7_16_5956_5963.pdf)

- Travail sur des données de type texte (via *Document Vector Representation* et *Vector space model*)
- Quatre étapes pour effectuer un $k$-means sur les documents :
	1. Preprocessing des documents :
		- mapping : d'un document $d$ à une ensemble de $(w\_{md}$,$n\_{md})$
		- reducer : pour obtenir des couples $(w\_m, n\_{md}) \forall d=1,...,D$
	2. Deuxième preprocessing pour le calcul de *DFR* et *TF/IDF*
		- via un job MapReduce
	3. Fonction `map()` pour calcul des distances entre chaque document et chaque centre, et affectation
		- renvoie un couple $(k, v\_d)$ pour chaque document $d$ ($v\_d$ étant ses coordonnées)
		- combinaison possible des sorties pour une même valeur de $k$ avant envoie vers le reducer
	4. Fonction `reduce()` pour le calcul des nouveaux centres
		- création d'un tuple $(iteration, k, g\_k, Card\_k)$
	5. Si convergence, alors arrêt, sinon retour à l'étape 3


## Dans le cadre de *EM* 

- Implémentations suivant les propositions précédentes :
	- `map()` (étape E) sur les données locales et `reduce()` pour chaque classe pour le calcul des paramètres
	- `map()` pour le calcul local dans les étapes E et M, et `reduce()` pour regroupement des résultats après chaque passage
- Autre possibilité à envisager ?
	- `map()` qui réalise un algo EM complet localement, avec des paramètres initiaux différents pour chaque noeud (centres, nombre de classes, ...)
	- `reduce()` qui regroupe les résultats pour des nombres de classes identiques par exemple
- et encore ?

## Conclusion

- MapReduce :
	- intéressant car facile à programmer et avec pas de réelle gestion de la parallélisation des tâches
	- beaucoup de communications
	- peut-être pas optimal pour la classification automatique
- Alternative de parallèlisation des calculs :
	- avec une approche décentralisée ou basée sur des arbres (cf ci-après)
	- avec une approche *In Memory* de type **Spark** (cf ci-après)
- Utilisation de MPI (*Message Passing Interface*), en gérant les communications directement et la répartition des tâches

## *Fully Distributed EM for Very Large Datasets*, Jason Wolfe et al [lien](http://w01fe.com/berkeley/pubs/08-icml-em.pdf)

Implémentation de EM selon trois topologies différentes :
- **MapReduce** : 
	- Etape E sur les données locales par chaque noeud
	- Reducer qui récupère les résultats et les agrègent pour les renvoyer aux noeuds
	- Etape M calculé sur les données locales par chaque noeud
- **AllPairs** : 
	- Approche décentralisée, et synchronisée
	- Chaque noeud renvoie à tous les autres noeuds ses résultats locaux
- **JunctionTree** :
	- Réseau de noeuds sous forme d'arbre de structure arbitraire
	- Résultats locaux renvoyés et retransmis par les noeuds intermédiaires de l'arbre
	
## D'autres voies encore 

- **Spark** [lien](http://spark.apache.org)
	- projet Apache
	- Framework pour le calcul sur cluster informatique
- **Distributed R** [lien](https://github.com/vertica/DistributedR)
	- projet GitHub, mais développé par HP Vertica
	- extension permettant de réaliser des programmes bénéficiant de la parallélisation
- **BID Data Project** [lien](http://bid2.berkeley.edu/bid-data-project/)
	- projet issu de Berkely, et sur GitHub
	- dédié Machine Learning
- sous **Python** [lien](https://wiki.python.org/moin/ParallelProcessing)
	- existence de plusieurs librairies permettant le travail sur plusieurs processeurs
- **Flink** [lien](http://flink.incubator.apache.org/)
	- projet Apache en incubation
- **H2O** [lien](http://0xdata.com/h2o/)
	- disponible sous GitHub, développé par 0xdata
	- dédié Machine Learning, et interfaçable avec R
