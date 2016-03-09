---
title: Logiciels stats - SAS - TP5
---

## Données

Nous allons travailler sur les données **Pen Digits** de l'*UCI Machine Learning Repository* (cf [Pen-Based Recognition of Handwritten Digits Data Set](https://archive.ics.uci.edu/ml/datasets/Pen-Based+Recognition+of+Handwritten+Digits)). Nous disposons de deux fichiers, disponibles dans le répertoire `/courses/dee4fb65ba27fe300/` :

- `pendigits.tra`
- `pendigits.tes`

Ces données sont composées de :

-  Coordonnées $(X_i,Y_i)$ de huit points ($i=1,\ldots,8$) dans le tracé du chiffre écrit par le scripteur
-  Chiffre normalement écrit par le scripteur (parmi $0, 1, \ldots, 9$)

Il y a en tout 10992 tracés (un millier environ par chiffre).

## Macro spécifique

La macro suivante permet de dessiner le chiffre dela première ligne d'une table passée en paramètre :

```sas
%macro DESSINE(table);
data ___dessine;
	set &table;
	retain xsys ysys '2' function 'label'; 
	if (_n_ = 1) then 
	do;
		array ax x1-x8; 
		array ay y1-y8; 
		do i = 1 to 8; 
			x = ax[i]; 
			y = ay[i];	
			text = ''||i; 
			call symput('chiffre', trim(left(chiffre)));
			output; 
		end;
	end;
run;
title "&chiffre";
axis1 label=none major=none minor=none value=none order=(-10 to 110 by 10);
proc gplot data=___dessine anno=___dessine; 
	plot y*x / haxis=axis1 vaxis=axis1;
	symbol v=none i=join;
run; quit;
proc delete data=___dessine;
run;
%mend;
```

Une fois exécutée, une macro est stockée et peut donc être réutilisée à n'importe quel moment de la session. Vous pouvez voir le résultat de son exécution en testant :

```sas
%dessine(pendigits);
```

## Travail

1. Importer les deux fichiers, à l'aide d'une `PROC IMPORT`
2. Assembler les deux tables en une seule, et renommer les variables comme suit :
	- `VAR1`, `VAR3`, `VAR5`, ..., `VAR15` : `Xi` (`i` de 1 à 8)
	- `VAR2`, `VAR4`, `VAR6`, ..., `VAR16` : `Yi` (idem pour `i`)
	- `VAR17` : `chiffre`
3. Trouver combien il y a de tracés pour chaque chiffre de $0$ à $9$
4. Dessiner le premier exemple de chaque chiffre, en utilisant la macro ci-dessus
5. Calculer les moyennes pour chaque variable, pour chaque chiffre
6. Représenter les *tracés moyens* pour chaque chiffre, à l'aide de la macro
7. Comparer les $X$ et les $Y$ pour chaque chiffre
	- une manipulation des données est peut-être utile pour représenter de manière à pouvoir comparer les chiffres
8. Faire une ACP sur les données et représenter le premier plan factoriel, en ajoutant l'information du chiffre pour chaque point, via une couleur par exemple
9. Représenter, sur le plan factoriel, les points pour chaque chiffre séparemment, et repèrer les chiffres pour lesquels un découpage en partition est judicieuse
10. Faire une classification sur les chiffres nécessitant un partitionnement
	- Faire une CAH et choisir un nombre de classes 
	- Effectuer un $k$-means avec ce nombre de classes (pour affiner la partition)
	- Représenter les points sur le premier plan factoriel pour chaque classe
	- Représenter les *tracés moyens* de chaque classe