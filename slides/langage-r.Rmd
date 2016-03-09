---
title: Langage R
---

## Le logiciel

[**R**](http://www.r-project.org) :

- outil très présent dans le monde scientifique et de plus en plus présent dans les entreprises
- open source : gratuit, modifiable
- langage de script
- de nombreux packages pour augmenter les capacités
- outil complémentaire : [RStudio](https://www.rstudio.com/)
	- Interface de développement pratique et bien pensée

## Concepts importants - données

Dans **R**, on manipule des variables pour avoir comme types d'objet :

- `vector` : tableau de $n$ éléments de type identique 	- un scalaire est considéré comme un `vector` dans **R**
- `matrix` : tableau à 2 dimensions (tous les élements doivent avoir le même type)
- `array`: extension de `matrix` à $d$ dimensions ($d$ pouvant être supérieur à 3)
- `data.frame` : équivalent à une table **SAS** ou **SQL** (ensemble de lignes caractérisées par des colonnes, ayant des types différents éventuellement)
- `list` : collection d'objets (`vector`, `matrix`, ...)

## Concepts importants - types

Pour les éléments, il existe différents types de valeur possible 

- `null` : valeur `null`
- `NA` : valeur manquante dans un vecteur ou autre
- `integer` : entier
- `numeric` (`double`, `real`) : réel
- `character` : chaîne de caractères
- `factor` : variable qualitative (format dédié)
- `date` : pour les aspects temporels (date + heure + fuseau horaire)

## Manipulation de variables

<div class="columns-2">

- Affectation : `=` ou `<-`
- Opérateurs classiques : 
	- `+`, `-`, `*`, `/`, `**`, `()`, ...
	- `==`, `!=`, `<`, `<=`, `>`, `>=`
- élément $i$ d'un vecteur : `vecteur[i]` 
	- `i` commence à 1
- éléments d'une `matrix` ou d'un `data.frame` :
	- cellule $i,j$ : `matrice[i,j]`
	- ligne $i$ : `matrice[i,]`
	- colonne $j$ : `matrice[,j]` 
	- colonne $j$ spécifiquement pour `data.frame` : `df[j]`

- Opérations sur `vector` ou `matrix` ou `data.frame` possibles :
	- élément par élément : `+`, `-`, ..., `==`, ...
	- comparaison d'ensemble : `%in%` (plutôt pour `vector`)
	- multiplication matricielle : `%*%`

</div>


## Utilisation de fonctions

En plus des opérateurs de base, comme dans tout langage impératif, il existe un grand nombre de fonction de base, plus un grand nombre de **packages** permettant d'augmenter les capacités du langage.

Spécificités 

- Appel classique (`fonction(paramètres)`)
- Mais paramètres nommés, avec valeur par défaut possible
	- utilisation classique : une valeur par paramètre, dans l'ordre
	- utilisation sans ordre : `paramètre = valeur`, dans l'ordre souhaité
	- utilisation avec valeur par défaut : valeurs seulement pour les paramètres dont on doit donner une valeur, et éventuellement d'autres dont on veut modifier la valeur par défaut

## Exemple de fonction 

<div class = "columns-2">
```{r ex-fonction}
# Fonction faisant la somme de a et de b
# a : valeur obligatoire lors de l'appel
# b : valeur optionnel (10 si non donné)
f <- function (a, b = 10) {
	res = a + b
	return (res)
}
# classique
f(1, 2)
# classique avec nommage
f(a = 1, b = 2)
# ordre inversé
f(b = 2, a = 1)
# avec valeur par défaut pour b
f(1)
# idem avec nommage explicite de a
f(a = 1)
```
</div>

## Eléments de langage

### Expressions multiples 

- séparées par un saut de ligne ou par `;` (optionnel si saut de ligne)
- inclus dans des `{ }` dans les opérateurs suivants

### Traitement conditionnel

- `if (condition) expression`
- `if (condition) expression else expression`

### Traitement itératif

- `for (variable in sequence) expression`
- `while (condition) expression`

## Importation de données

Importation de fichier texte avec la commande `read.table()`, avec les paramètres suivants (avec `valeur` par défaut éventuelle) :

- `file` : nom du fichier
- `header` : présence ou non des noms de variables (`FALSE`)
- `sep` : séparateur de variable (` `)
- `na.strings` : chaîne(s) pour valeurs manquantes (`NA`)
- `skip` : nombre de lignes à ne pas prendre en compte en début de fichier (`0`)
- `nrow` : nombre de lignes à lire (`-1`)
- `stringsAsFactors` : transformations des chaînes en `factor` ou non (`TRUE`)
- ...

Fonction renvoyant un `data.frame`

## Importation de données

- Quelques fonctions dérivés avec des valeurs par défaut différentes 
	- `read.csv()`, `read.csv2()`
	- `read.delim()`, `read.delim2()`
- Fonction `write.table` permettant d'écrire dans un fichier texte, à partir d'un `data.frame`

Si besoin, fonction `readLines()` 

- Lecture direct du texte
- Renvoi un `vector` de taille nombre de ligne (une ligne par `cellule` du tableau)
- Utile si on ne connaît pas le format ou si celui-ci est trop complexe pour `read.table()`

## Restitution de données 

- Dans la console, taper le nom de la variable permet de l'afficher
- Comportement idem que d'utiliser la fonction `print()` (une seule variable)
- Fonction `cat()` permettant d'afficher en une fois plusieurs variables ou chaînes

<div class = "columns-2">
```{r ex-print}
a = "FX"
a
print(a)
```

```{r ex-print2}
cat("Bonjour", a)
cat("Bonjour ", a, 
    ", bonne journée !", sep = "")
```
</div>

## Attributs d'un `data.frame`

Un `data.frame`, en plus de sa valeur, peut avoir des attributs. C'est une liste spécifique.

- liste des attributs avec la fonction `attributes`
	- `class` : `data.frame`
	- `names` : nom des variables
	- `row.names` : nom des objets (liste de $1$ à $n$ si rien de spécifié)
- attribution d'un attribut avec la fonction `attr(df, attr)`

Fonctions utiles

- `dim(df)`, `nrow(df)`, `ncol(df)` : dimensions (nb lignes et nb colonnes) en une fois ou séparemment

## Exemple {.smaller}

<div class = "columns-2">
```{r ex-df}
a = data.frame(x = 1:4, y = 5:8)
print(a)
dim(a)
nrow(a)
ncol(a)
attr(a, "info") = "exemple de data.frame"
attributes(a)
``` 
</div>

## Interrogation de données

cf slides 

- [Concepts pour l'interrogation de données](interrogation-concepts.html)
- [Interrogation de données sous R](interrogation-r.html)

## Statistiques descriptives univariées

cf slides

- [Statistiques descriptives sous R](stats-desc-r.html)

## Statistiques exploratoires

cf slides

- [Statistiques exploratoires sous R](stats-explo-r.html)
