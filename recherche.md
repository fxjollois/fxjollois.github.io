---
title: Recherche
---

Mes travaux de recherche se placent dans une optique d'**Apprentissage non-supervisée** 
et concernent principalement la classification automatique (ou **clustering**) sur des 
données qualitatives ou binaires, dans un cadre **Fouille de Données**. J'utilise une 
approche probabiliste, avec l'utilisation des **modèles de mélange**, et à l'aide de 
l'algorithme EM (Dempster et al, 1977), ou de dérivés (CEM, SEM, ...). 
	
Les problématiques principales de ce type de méthode sont d'une part la recherche du 
nombre de classes. Pour ce faire, plusieurs critères probabilistes ont été étudiés 
et certains d'entre eux s'avèrent très intéressant. Une autre approche est la 
classification mixte, qui consiste à combiner les avantages de la classification simple 
(recherche d'une partition en $s$ classes) et la classification hiérarchique (recherche 
d'une hiérarchie de classes sur l'ensemble des objets).
	
D'autre part, la lenteur de convergence de EM peut s'avérer rédhibitoire pour l'appliquer 
sur des données de grandes tailles, comme cela est souvent le cas en Fouille de Données 
(ou Data Mining). Ainsi, j'ai étudié différentes techniques d'accélération de cet 
algorithme et proposé une nouvelle méthode, plus performante sur les données qualitatives 
et quantitatives que d'autres méthodes classiques. Le principe de cette méthode est 
d'optimiser le travail en se concentrant sur les individus importants.
	
De plus, je m'intéresse à la classification croisée, où le but est de chercher une 
partition optimale en lignes et en colonnes simultanément. La pratique courante est 
d'utiliser une méthode de classification simple sur les lignes, puis sur les colonnes 
séparement. Ceci peux engendrer une perte spécifique du lien possible entre un groupe 
de lignes et un groupe de variables. Il est donc préférable de concevoir la recherche 
de ces deux partitions simultanément. Dans cette optique, nous avons développé un 
algorithme de classification croisée hiérarchique (HBCM). 

Voici la liste de mes [publications](publications.html).
