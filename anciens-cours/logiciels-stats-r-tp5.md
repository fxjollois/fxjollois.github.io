---
title: Logiciels stats - R - TP5
---

## Données

Nous allons travailler sur les données **Pen Digits** de l'*UCI Machine Learning Repository* (cf [Pen-Based Recognition of Handwritten Digits Data Set](https://archive.ics.uci.edu/ml/datasets/Pen-Based+Recognition+of+Handwritten+Digits)). Nous disposons de deux fichiers

- [`pendigits.tra`](logiciels-stats/pendigits.tra)
- [`pendigits.tes`](logiciels-stats/pendigits.tes)

Ces données sont composées de :

-  Coordonnées $(X_i,Y_i)$ de huit points ($i=1,\ldots,8$) dans le tracé du chiffre écrit par le scripteur
-  Chiffre normalement écrit par le scripteur (parmi $0, 1, \ldots, 9$)

Il y a en tout 10992 tracés (un millier environ par chiffre).

## Fonction spécifique

La fonction suivante permet de dessiner le chiffre dela première ligne d'une table passée en paramètre :

```r
dessineChiffre <- function(v, titre = NULL) {
    if (is.data.frame(v))
        v = unlist(v)
    don = data.frame(
        x = v[seq(1,15,by=2)],
        y = v[seq(2,16,by=2)],
        position = 1:8
    )
    g = ggplot(don, aes(x, y)) + xlim(0, 100) + ylim(0, 100) +
        geom_path() +
        geom_text(aes(label = position)) + 
        theme_void() 
    if (!is.null(titre))
        g = g + ggtitle(titre)
    g
}
```

Cette fonction peut donc être utilisée à n'importe quel moment det vous pouvez voir le résultat de son exécution en testant (après avoir importer correctement les données) :

```r
dessineChiffre(pen.tra[1,1:16], pen.tra[1,17])
```

## Travail

1. Importer les deux fichiers
2. Assembler les deux tables en une seule, et renommer les variables comme suit :
	- `V1`, `V3`, `V5`, ..., `V15` : `Xi` (`i` de 1 à 8)
	- `V2`, `V4`, `V6`, ..., `V16` : `Yi` (idem pour `i`)
	- `V17` : `chiffre`
3. Trouver combien il y a de tracés pour chaque chiffre de $0$ à $9$
4. Dessiner le premier exemple de chaque chiffre, en utilisant la fonction ci-dessus
5. Calculer les moyennes pour chaque variable, pour chaque chiffre
6. Représenter les *tracés moyens* pour chaque chiffre, à l'aide de la fonction
7. Comparer les $X$ et les $Y$ pour chaque chiffre
	- une manipulation des données est peut-être utile pour représenter de manière à pouvoir comparer les chiffres
8. Faire une ACP sur les données et représenter le premier plan factoriel, en ajoutant l'information du chiffre pour chaque point, via une couleur par exemple
9. Représenter, sur le plan factoriel, les points pour chaque chiffre séparemment, et repèrer les chiffres pour lesquels un découpage en partition est judicieuse
10. Faire une classification sur les chiffres nécessitant un partitionnement
	- Faire une CAH et choisir un nombre de classes 
	- Effectuer un $k$-means avec ce nombre de classes (pour affiner la partition)
	- Représenter les points sur le premier plan factoriel pour chaque classe
	- Représenter les *tracés moyens* de chaque classe