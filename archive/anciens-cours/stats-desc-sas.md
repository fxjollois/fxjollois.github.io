---
title: Statistiques descriptives sous SAS
---

## Plan

- Univarié
	- Variable quantitative
	- Variable qualitative
- Bivarié
	- Var quanti vs quanti
	- Var quali vs quali
	- Var quali vs quanti

Avec pour chaque point, les statistiques à calculer et les graphiques usuels à produire.

## Univarié

### Variable quantitative

Trois procédures pour produire les statistiques usuelles

- `PROC MEANS` et `PROC SUMMARY`
- `PROC UNIVARIATE`

Plusieurs procédures pour produire les différents graphiques

- `PROC UNIVARIATE`
- `PROC GPLOT` (un peu obsolète)
- `PROC SGPLOT`

## Univarié - quanti

### `PROC MEANS` et `PROC SUMMARY`

- `vardef=n` : changer le calcul de la variance ($\frac{}{n}$ au lieu de $\frac{}{(n-1)}$) (*vrai dans d'autres procédures aussi*)
- `maxdec=2` : arrondi à 2 décimales
- `mean`, `median`, `Q1`, `Q3`, ... : statistiques à calculer
- `noprint` : n'affiche rien dans la sortie (*vrai dans d'autres procédures aussi*)

```sas
proc means 
		data = sashelp.cars
		vardef=n mean median Q1 Q3 maxdec=2;
	var _NUMERIC_;
run;
```

## Univarié - quanti

### `PROC UNIVARIATE`

Plus complète que `MEANS` ou `SUMMARY`

- `outtable` : création d'une table de résultats
- `histogram` : dessine un histogramme
- `qqplot` : dessine le QQ-plot
- ...

```sas
proc univariate 
		data = sashelp.cars 
		outtable = iris_univ;
	var MPG_City;
	histogram;
	qqplot;
run;
```

## Univarié - quanti

### `PROC SGPLOT` - Histogramme

- `histogram` pour déclarer les variables pour lesquelles produire un histogramme
- `density` pour ajouter la densité calculée :
	- sur l'hypothèse d'une loi normale par défaut
	- possibilité d'ajouter une version par noyau
- toute procédure graphique doit être terminer par un `quit;`

```sas
proc sgplot data=sashelp.cars;
	histogram MPG_City;
	density MPG_City;
	density MPG_City / type=kernel;
	keylegend / location=inside position=topright;
run;
quit;
```

## Univarié - quanti

### `PROC SGPLOT` - Boxplot

- `hbox` ou `vbox` pour définir les variables pour lesquelles produire une boîte à moustache (resp. horizontale et verticale)

```sas
proc sgplot data=sashelp.cars;
	hbox MPG_City;
run;
quit;
```

## Univarié - quanti

### `PROC SGPLOT` - Boxplot

Pour avoir plusieurs variables sur un même graphique (à ne faire que si les variables ont même échelle - i.e. même unité ou variables standardisées)

```sas
data temp;
	set sashelp.iris;
	id = _N_;
proc transpose data=temp name=VarName out=tempbis (rename= (col1=Valeur));
	by id;
run;
proc sgplot data=tempbis;
	vbox Valeur / group=varName;
run;
quit;
```

## Univarié

### Variable qualitative

Une procédure pour produire les statistiques usuelles

- `PROC FREQ`

Deux procédures pour produire les différents graphiques

- `PROC GCHART` (un peu obsolète)
- `PROC SGPLOT`


## Univarié - quali

### `PROC FREQ`

- `tables` pour déterminer les variables catégorielles à utiliser
- quelques options utiles :
	- `nocum` pour retirer les occurences et fréquences cumulées
	- `nopercent` pour n'avoir que les occurences (nommées *frequency* en anglais - attention)
	- ...

```sas
proc freq data=sashelp.cars;
	tables Origin / nocum nopercent;
run;
```

## Univarié - quali

### `PROC FREQ` - diagramme en barres

- `plots` permet d'afficher les diagrammes
	- `freqplot` : diagramme en barres
	- ...
	- `all` : tous les diagrammes disponibles

```sas
proc freq data=sashelp.cars;
	tables Origin / plots=freqplot;
run;
```

## Univarié - quali

### `PROC SGPLOT` - Diagramme en barres ou équivalent

- `hbar` ou `vbar` pour définir les variables pour le diagramme en barres (resp. horizontales et verticales)
- `dot` pour un diagramme avec des points
- `hline` et `vline` pour obtenir une ligne (valable pour les variables ordinales)

```sas
proc sgplot data=sashelp.cars;
	hbar Origin;
run;
quit;
```

## Univarié - quali

### `PROC GCHART` - Diagramme circulaire

- `pie` pour déterminer la variable à utiliser
- `donut` pour la version avec un *trou* au centre
- `noheading` pour supprimer l'en-tête automatique
- `percent=` pour indiquer où afficher le pourcentage (non affiché par défaut - ici en dehors de la part)

```sas
proc gchart data=sashelp.cars;
	pie Origin / noheading percent=outside;
run;
quit;
```

## Bivarié

### Variables quantitative vs quantitative

Une seule procédure pour les statistiques

- `PROC CORR`

Plusieurs procédures pour les graphiques 

- `PROC GPLOT` (un peu obsolète)
- `PROC SGPLOT`

## Bivarié - quanti vs quanti

### `PROC CORR`

- `var` pour lister les variables à considérer pour le calcul des corrélations
- `pearson`, `spearman` et `kendall` pour spécifier les différents coefficients de corrélations à calculer (et les tests, faits automatiquement)

```sas
proc corr data=sashelp.cars pearson spearman kendall;
	var Invoice  Horsepower MPG_City MPG_Highway;
run;
```

## Bivarié - quanti vs quanti

### `PROC SGPLOT` - nuage de points

- `scatter` pour produire le nuage de points en déterminant les variables `X` et `Y`
- `ellipse` permet d'ajouter l'ellipse de densisté du couple de variables

```sas
proc sgplot data=sashelp.cars;
	scatter X=Horsepower Y=Invoice;
	ellipse X=Horsepower Y=Invoice;
run;
quit;
```

## Bivarié - quanti vs quanti

### `PROC SGPLOT` - heatmap

- `heatmap` pour produire la carte en déterminant les variables `X` et `Y`
- `xbinsize` et `ybinsize` pour déterminer la taille des catégories créées pour chaque variable 
- possibilité de déterminer le nombre de bins plutôt que la taille

```sas
proc sgplot data=sashelp.cars;
	heatmap X=Horsepower Y=Invoice / xbinsize=50 ybinsize=10000;
	ellipse X=Horsepower Y=Invoice;
run;
quit;
```

## Bivarié - quanti vs quanti

### `PROC SGPLOT` - régression

- ajout de la courbe de régression (linéaire par défaut)
- `reg` pour produire le nuage de points en déterminant les variables `X` et `Y`, avec la courbe
- `degree` permet de déterminer le degré de la régression

```sas
proc sgplot data=sashelp.cars;
	reg X=Horsepower Y=Invoice;
run;
quit;
```

## Bivarié - quanti vs quanti

### `PROC SGPLOT` - loess plot

- approximation du lien non-linéaire entre les deux variables
- `loess` pour produire le nuage de points en déterminant les variables `X` et `Y`, avec la courbe `loess`
- `smooth` permet de lisser la courbe (faible valeur, proche de 0) ou de la faire la plus proche des données (forte valeur, proche de 1)

```sas
proc sgplot data=sashelp.cars;
	loess X=Horsepower Y=Invoice / smooth=.1;
run;
quit;
```

Existe aussi en version $B$-spline pénalisé (avec `pbspline`)

## Bivarié - quanti vs quanti

### `PROC SGPLOT` - needle plot

- variation des valeurs de $Y$ autour d'une valeur à définir, le tout en fonction des valeurs de $X$
- `needle` pour produire le graphique en déterminant les variables `X` et `Y`

```sas
proc sgplot data=sashelp.cars;
	needle X=Horsepower Y=Invoice / baseline= 50000;
run;
quit;
```

## Bivarié

### Variables qualitative vs qualitative

Une seule procédure pour les statistiques

- `PROC FREQ`

Plusieurs procédures pour les graphiques 

- `PROC FREQ`
- `PROC GCHART` (un peu obsolète)
- `PROC SGPLOT` et `PROC SGPANEL`

## Bivarié - quali vs quali

### `PROC FREQ`

- `tables` permet de définir les deux variables qualitatives à croiser
- `nopercent`, `norow`, `nocol`, `nofreq` permettent du supprimer l'affichage de respectivement : les pourcentages globaux, les profils lignes, les profils colonnes et les occurences

```sas
proc freq data = sashelp.cars;
	tables Type * Origin / nofreq nopercent norow;
run;
```

## Bivarié - quali vs quali

### `PROC FREQ` - diagramme en barres

- `plots` permet de définir les graphiques à produire
- `freqplot` est par défaut un diagramme en barres séparées
- `mosaicplot` produit un diagramme proche d'un diagramme en barres empilées

```sas
proc freq data = sashelp.cars;
	tables Origin * Type / plots = freqplot;
	tables Type * Origin / 
		plots = (
			mosaicplot 
			freqplot(twoway=stacked scale=grouppct)
		); 
run;
```

## Bivarié - quali vs quali

### `PROC SGPLOT` - Diagramme en barres séparées

- `hbar` ou `vbar` comme précédemment
- `group`, option de `hbar`|`vbar`, permet de spécifier la variable supplémentaire de regroupement

```sas
proc sgplot data = sashelp.cars;
	vbar Origin / group=Type groupdisplay=cluster;
run;
quit;
```

## Bivarié - quali vs quali

### `PROC SGPANEL` - Diagramme en barres séparées

- `hbar` ou `vbar` comme pour `PROC SGPLOT`
- `panelby` permet de créer des graphiques séparées dans différents panneaux

```sas
proc sgpanel data = sashelp.cars;
	panelby Origin;
	vbar Type;
run;
quit;
```

## Bivarié - quali vs quali

### `PROC SGPLOT` - Diagramme en barres empilées

- `proc freq` permettant de stocker les profils colonnes dans une table
- `hbar` ou `vbar`, avec `group` comme précédemment
- `response` permet de définir comment calculer la taille des blocs (ici les pourcentages en colonnes donc)

```sas
proc freq data = sashelp.cars noprint;
	tables Type * Origin / out=cars_temp outpct;  
proc sgplot data = cars_temp;
	vbar Origin / response=pct_col group=Type;
run;
quit;
```

## Bivarié - quali vs quali

### `PROC SGPLOT` - heatmap

- représentation graphique directe de la table de contingence

```sas
proc sgplot data=sashelp.cars;
	heatmap X=Type Y=Origin;
run;
quit;
```

- `colorresponse` permet de spécifier la variable pour la couleur : ici, on représente donc les profils colonnes

```sas
proc freq data = sashelp.cars noprint;
	tables Origin * Type / out=cars_temp outpct;  
proc sgplot data = cars_temp;
	heatmap X=Origin Y=Type / colorresponse=pct_col colormodel=TwoColorRamp;
run;
quit;
```

## Bivarié - quali vs quali

### `PROC SGPLOT` - bubble plot

- représentation graphique directe de la table de contingence

```sas
proc freq data = sashelp.cars noprint;
	tables Origin * Type / out=cars_temp outpct;  
proc sgplot data = cars_temp;
	bubble X=Origin Y=Type size=count;
run; quit;
```

- ici des profils colonnes 

```sas
proc freq data = sashelp.cars noprint;
	tables Origin * Type / out=cars_temp outpct;  
proc sgplot data = cars_temp;
	bubble X=Origin Y=Type size=pct_col / 
		colorresponse=pct_col colormodel=TwoColorRamp;
run; quit;
```

## Bivarié - quali vs quali

### `PROC SGPLOT` - needle plot

- la variable `Y` est ici les profils colonnes, `group` permettant de spécifier la deuxième variable qualitative
- le choix de 33.33 % pour `baseline` vient du fait qu'`Origin` a trois modalités possibles

```sas
proc freq data = sashelp.cars noprint;
	tables Origin * Type / out=cars_temp outpct;  
proc sgplot data = cars_temp;
	needle X=Type Y=pct_col / group=Origin groupdisplay=cluster baseline=33.33;
run; quit;
```

## Bivarié

### Variables quantitative vs qualitative

Plusieurs procédures pour les statistiques

- `PROC MEANS` ou `PROC SUMMARY`
- `PROC UNIVARIATE`

Plusieurs procédures pour les graphiques 

- `PROC GPLOT` ou `GCHART` (un peu obsolète)
- `PROC SGPLOT` et `PROC SGPANEL`

## Bivarié - quanti vs quali

### `PROC MEANS`, `SUMMARY` et `UNIVARIATE`

- L'ajout de la clause `class` permet de déterminer la variable qualitative à utiliser, afin de calculer les statistiques pour chaque modalité

```sas
proc means data = sashelp.cars;
	class Origin;
	var Invoice;
run;

proc univariate data = sashelp.cars;
	class Origin;
	var Invoice;
	histogram;
	qqplot;
run;
```

## Bivarié - quanti vs quali

### `PROC SGPLOT` et `PROC SGPANEL` - Histogrammes et densités

- Utilisation de `sgplot` plutôt pour les densités
 
```sas
proc sgplot data = sashelp.cars;
	density Invoice / group=Origin;
run; quit;
```

- Utilisation de `sgpanel` pour les histogrammes
- `panelby` pour spécifier la variable qualitative

```sas
proc sgpanel data = sashelp.cars;
	panelby Origin;
	histogram Invoice;
run; quit;
```

## Bivarié - quanti vs quali

### `PROC SGPLOT` - Boîtes à moustache

- `hbox` et `vbox` comme précédemment
- `group` pour spécifier la variable qualitative
- `sgpanel` peut aussi être utilisé, mais la comparaison entre les boîtes est moins facile

```sas
proc sgplot data = sashelp.cars;
	hbox Invoice / group=Origin;
run; quit;
```

## Bivarié - quanti vs quali

### `PROC SGPLOT` - needle plot

- Calcul des moyennes par modalité de la variable qualitative en premier
- Choix de `baseline` : moyenne générale de la variable quantitative
- `Y` doit absolument être la variable quantitative

```sas
proc summary data = sashelp.cars;
	class Origin;
	var Invoice;
	output out=cars_temp(where=(_TYPE_=1)) mean=Invoice;
proc sgplot data = cars_temp;
	needle X=Origin Y=Invoice / baseline=30014.70;
run;quit;
```

## Bivarié - quanti vs quali

### `PROC SGPLOT` - waterfall plot

- intéressant dans le cas d'une variable qualitative ayant du sens lorsqu'elle est cumulée
- `category` pour la variable qualitative et `response` pour la variable quantitative

```sas
proc sgplot data = sashelp.cars;
	waterfall category=Origin response=Invoice;
run; quit;
```

## Bivarié - quanti vs quali

### `PROC SGPLOT` - nuage de points jitter

- `jitter` : randomisation légère 

```sas
proc sgplot data = sashelp.cars;
	scatter X=Origin Y=Invoice / jitter;
run; quit;
```

- Résultat améliorable, en le faisant manuellement

```sas
data cars_temp;
	set sashelp.cars;
	jitter = rand('uniform')*.3 +
		1*(Origin="Asia") + 2*(Origin="Europe") + 3*(Origin="USA");
proc sgplot data = cars_temp;
	scatter X=jitter Y=Invoice / group=Origin groupdisplay=cluster;
	xaxis display=none;
run; quit;
```

## Trivarié voire plus

Différents graphiques sont adaptés pour représentés plus de deux variables :

- *bubble plot* : taille des bulles fonction d'une variable quantitative (résumée)
- *scatter plot* : double axe des ordonnés (un à gauche et un autre à droite)
- *heatmap* : couleur en fonction d'une variable quantitative
- utilisation de `sgpanel` pour avoir plusieurs représentations

