---
title: "Interrogation de données avec R"
author: "FX Jollois"
date: "... ou comment faire du SQL sans SQL dans R"
output: ioslides_presentation
---

## Introduction

But de cette présentation :

> Présenter une comparaison (**non exhaustive**) entre le langage **SQL** et le langage [**R**](http://www.r-project.org) pour l'**interrogation** d'une base de données relationnelles

Plan :

- Rappel (très rapide) sur les concepts de l'algèbre relationnelle
- Comment faire du SQL sous R ?
- Comment faire autrement sous R ?

Pré-requis :

- Connaissance du SQL
- Connaissance du langage R

## Interrogation de données

Ensemble des opérations de l'algèbre relationnelle utilisée pour obtenir des informations à partir d'une base de données relationnelles :

- Restriction
- Projection
- Calcul et fonction
- Agrégat
- Opérations ensemblistes
- Jointures

Les données sont disponibles [ici](http://fxjollois.github.io/accesdonnees.html)

## SQL sous R

Il existe plusieurs librairies permettant de se connecter directement à une base de données (`SQLite`, `MySQL`, `Oracle`, ...), et de récupérer le résultat d'une requête exécutée par le SGBD.

La librairie [`sqldf`](https://cran.r-project.org/web/packages/sqldf/index.html) permet :

- de réaliser des opérations SQL sur une base de données existantes, en spécifiant le *driver* ;
- de créer une base de données *ex-nihilo* (type défini par le *driver* choisi) ;
- de requêter directement les `data.frame` présent dans R.

```r
library(sqldf)
sqldf("SELECT * FROM iris;")
```


## Autrement sous R

Le langage `R` intègre, de base, un certain nombre d'opérateurs permettant de réaliser les opérations usuelles d'algèbre relationnelle :

- `subset` : restriction et projection
- `transform` : calcul et fonction
- `aggregate` : agrégat
- `rbind` et `merge`  : opérations ensemblistes
- `merge` : jointures

*NB* : ne sont présentés ici que les fonctions de base du langage `R`. Il existe certains packages permettant de réaliser aussi ces mêmes opérations relationnelles.

## Restriction

La fonction `subset` renvoie une `data.frame` restreinte aux lignes respectant une condition (simple ou complexe) passée en paramètre :

```r
subset(df, subset = condition)
```

*NB* : Dans la condition, nous utilisons le nom des variables sans préciser le nom de la table avant.

## Projection

Nous utilisons ici la même fonction `subset` que pour la restriction. Il est nécessaire de passer en paramètre  la liste des variables à conserver, dans le paramètre `keep`.

```r
subset(df, select = liste_attributs)
```

Pour supprimer les doublons du résultat, de manière identique au `DISTINCT` en SQL, il faut utiliser la fonction `unique`.

```r
unique(subset(df, select = liste_attributs))
```

## Calcul et fonction

Pour tout ce qui est définition de nouvelles variables, nous utilisons la fonction `transform`, dans laquelle nous décrivons l'expression pour la ou les nouvelles variables.

```r
transform(df, var = expression)
```

*NB* : dans l'expression, il est possible d'utiliser les fonctions `R`.

## Agrégat

La fonction `aggregate` permet de réaliser des opérations d'agrégats sur des `data.frames`. Dans ce cas, il ne peut y avoir qu'un seul type d'agrégat par utilisation de `aggregate` (i.e. pour faire deux opérations - par exemple `COUNT` et `SUM`, il faut 2 utilisations d'aggregate).

```r
# calcul d'agrégat global
aggregate(attribut ~ 1, df, agregat)
# avec regroupement 
aggregate(attribut ~ regroupement, df, agregat)
# si plusieurs attributs de regroupement : 
aggregate(attribut ~ att1 + att2 + ..., df, agregat)
```

*NB* : `agregat` représente le calcul d'agrégat à effectuer (`length` pour un dénombrement, `sum` pour une somme, ...).

## Opérations ensemblistes

La fonction `rbind` assemble deux `data.frames` ensemble l'un *au-dessous* de l'autre, et dans ce sens fait une **union** complète (toutes les lignes sont présentes, et donc certaines éventuellement en double).

```r
rbind(df1, df2)
```

La fonction `merge` permet de réaliser cela plus proprement et de choisir si on veut une **union** ou une **intersection** (ne fonctionne que si les deux `data.frames` ont les mêmes colonnes).

```r
# Union
merge(df1, df2, all = T)
# Intersection
merge(df1, df2)
```

Rien pour réaliser directement une différence.

## Jointures

On utilise la même fonction `merge` pour réaliser les jointures, et les différentes jointures (interne, externe gauche, externe droite ou complète) se spécifient à l'aide des paramètres `all`, `all.x` et `all.y`. Si on veut indiquer les colonnes pour les jointures, il est possible des les spécifier via `by` et `by.x`/`by.y`.

```r
# Jointure interne
merge(df1, df2)
# Jointure gauche (droite avec all.y = T)
merge(df1, df2, all.x = T)
# Jointure complète
merge(df1, df2, all = T)
# Jointure en spécifiant les colonnes
merge(df1, df2, by.x = liste_att1, by.y = liste_att2)
```