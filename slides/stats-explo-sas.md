---
title: Statistiques exploratoires sous SAS
---

## Statistiques exploratoires

- Analyse de données
	- Analyse en composantes principales (ACP)
	- Analyse factorielle des correspondances (AFC)
	- Analyse factorielle des correspondances multiples (AFCM ou ACM)
- Classification
	- Classification hiérarchique (CAH)
	- Classification directe ($k$-means)

## Analyse de données

### Analyse en composantes principales (ACP)

- Utilisation de la `PROC PRINCOMP`
- Deux tables en sorties
	-  `out=` pour récupérer les coordonnées des individus sur les composantes principales
	-  `outstat=` pour récupérer les informations autres (sur les variables, matrice de variance/covariance, et valeurs et vecteurs propres)
- Plusieurs graphiques directement disponibles dans la version classique de SAS (et pas disponible dans SAS Studio)  

## Analyse de données

### ACP - code

- ACP en elle-même

```sas
proc princomp data = sashelp.iris out=iris_pca outstat=iris_pca_stat;
	var _NUMERIC_;
run;
```
- Pour représenter le premier plan factoriel

```sas
proc sgplot data = iris_pca;
	scatter x=Prin1 y=Prin2 / 
		group=Species markerattrs=(SYMBOL=CircleFilled);
run; quit;
```

## Analyse de données

### Analyse factorielle des correspondances (AFC)

- Utilisation de la `PROC CORRESP`
- Indication dans `tables` du couple de variables à utiliser pour la table de contingence (séparée par une `,`)
- Spécification des stats de sorties : `all` pour tout, sinon voir aide de SAS
- Deux tables en sortie :
	- `out=` (ou `outc=`) pour récupérer les coordonnées des points sur les axes factoriels (avec contribution et qualité de représentation)
	- `outf=` pour récupérer les fréquences observées, attendues, et autres statistiques

## Analyse de données

### AFC - code

- AFC en elle-même
	- produit par défaut les graphiques nécessaires

```sas
proc corresp data = sashelp.cars all 
		out = cars_afc_1 outf = cars_afc_2;
	tables type, origin;
run;
```

## Analyse de données

### Analyse factorielle des correspondances multiples (AFCM)

- Utilisation de la `PROC CORRESP` avec l'option `mca`
- Indication dans `tables` ds variables à utiliser (sans `,`)
- Spécification des stats de sorties : `all` pour tout, sinon voir aide de SAS
- Deux tables en sortie :
	- `out=` (ou `outc=`) pour récupérer les coordonnées des points sur les axes factoriels (avec contribution et qualité de représentation)
	- `outf=` pour récupérer les fréquences observées, attendues, et autres statistiques

## Analyse de données

### AFCM - code

- AFCM en elle-même
	- produit par défaut les graphiques nécessaires

```sas
proc corresp data = sashelp.cars mca all 
		out = cars_afcm_1 outf = cars_afcm_2;
	tables type origin DriveTrain Cylinders;
run;
```

## Classification

### Classification hiérarchique (CAH)

- `PROC CLUSTER` pour créer le dendrogramme
	- `method=` pour spécifier la méthode (`ward`, `single`, ...)
	- `rsquare`, `pseudo`, `ccc` pour représenter graphiquement ces critères de choix du nombre de classes
	- `outree` pour récupérer le dengramme et les statistiques associées
	- présentation du dendogramme par défaut
- `PROC TREE` pour représenter le dendrogramme
	- `ncl=` pour découper le dendrogramme en $k$ classes
	- `out=` pour récupérer la partition ainsi créée

## Classification

### CAH - code

```sas
proc cluster data = sashelp.iris 
		method = ward 
		rsquare ccc pseudo 
		outtree = iris_tree;
	var _NUMERIC_;
run;

proc tree data = iris_tree ncl = 3 out = iris_clust_cah;
	copy Petal: Sepal:;
run;

proc sgscatter data = iris_clust_cah;
	matrix Petal: Sepal: / 
		group = cluster markerattrs=(SYMBOL=CircleFilled) ;
run; quit;
```

## Classification

### Classification directe ($k$-means)

- `PROC FASTCLUS` pour appliquer l'algorithme $k$-means
	- `maxc=` pour définir le nombre de classes
	- `maxiter=` pour définir le nombre d'itérations maximal
	- `converge=` pour spécifier le seuil de convergence 
	- `out=` pour récupérer les données augmentées de la partition
	- `mean=` pour récupérer les centres des classes
	- `outstat=` pour récupérer tout un ensemble de statistiques, dont les critères de choix du nombre de classes

## Classification

### $k$-means - code

```sas
proc fastclus data = sashelp.iris 
	maxc = 3 maxiter = 20 converge = 0 vardef = n
	out = iris_km 
	mean = iris_km_mean 
	outstat = iris_km_stat;
	var _NUMERIC_;
run;

proc sgscatter data = iris_km;
	matrix Petal: Sepal: / 
		group = cluster markerattrs=(SYMBOL=CircleFilled) ;
run; quit;
```

## Liens intéressants

Programmes disponibles :

- [Macros de P. Besse](http://www.math.univ-toulouse.fr/~besse/pub/sas/) sur [WikiStat](http://wikistat.fr/)
- [Macros de l'INSEE](http://www.insee.fr/fr/methodes/default.asp?page=outils/analyse_donnees/accueil_analyse.htm)
