---
title: Statistiques exploratoires avec R
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

A l'aide du package `stats` (présent directement dans R)

<div class="columns-2">
- Avec la fonction `prcomp()` : retourne moins d'informations

```r
acp1 = prcomp(iris[-5])
print(acp1)
print(summary(acp1))
plot(acp1)
biplot(acp1)
```
&nbsp;

- Avec la fonction `princomp()` : assez complète

```r
acp2 = princomp(iris[-5])
print(acp2)
print(summary(acp2))
plot(acp2)
loadings(acp2)
biplot(acp2)
```
</div>

## Analyse de données

### Analyse en composantes principales (ACP)

A l'aide du package `FactoMineR`, utilisation de la fonction `PCA()` 

- Très bien réalisée et fournissant toutes les informations utiles à l'interprétation

```r
library(FactoMineR)
acp3 = PCA(iris, quali.sup = 5, graph = FALSE)
summary(acp3)
barplot(acp3$eig[,1], main="Eigenvalues", names.arg=1:nrow(acp3$eig))
plot(acp3)
plot(acp3, choix = "var")
plot(acp3, 
	col.ind = "grey70", col.quali = "black", 
	label = "quali")
```

## Analyse de données

### Analyse factorielle des correspondances (AFC)

A l'aide du package `MASS`, utlisation de la fonction `corresp()`

```r
library(MASS)
tab = table(mtcars$cyl, mtcars$gear)
df = as.data.frame.matrix(tab)
afc1 = corresp(df)
print(afc1)
plot(afc1)
```

<div class="small">
*Attention* : le paramètre doit être une table de contingence au format `data.frame`
</div>

## Analyse de données

### Analyse factorielle des correspondances (AFC)

A l'aide du package `FactoMineR`, utlisation de la fonction `CA()`

```r
library(FactoMineR)
afc2 = CA(table(mtcars$cyl, mtcars$gear), graph = FALSE)
print(afc2)
print(summary(afc2))
plot(afc2)
```

## Analyse de données

### Analyse factorielle des correspondances multiples (AFCM)

A l'aide du package `MASS`, utlisation de la fonction `mca()`

```r
library(MASS)
df = subset(mtcars, select = c(cyl, vs, am, gear, carb))
df = data.frame(lapply(df, factor))
afcm1 = mca(df)
print(afcm1)
plot(afcm1)
```

<div class="small">
*Attention* : le paramètre doit être un `data.frame`, avec uniquement des variables de type `factor`
</div>

## Analyse de données

### Analyse factorielle des correspondances multiples (AFCM)

A l'aide du package `FactoMineR`, utlisation de la fonction `MCA()`

```r
library(FactoMineR)
df = subset(mtcars, select = c(cyl, vs, am, gear, carb))
df = data.frame(lapply(df, factor))
afcm2 = MCA(df, graph = FALSE)
print(afcm2)
print(summary(afcm2))
plot(afcm2)
dimdesc(afcm2)
plotellipses(afcm2)
```

<div class="small">
*Attention* : le paramètre doit être un `data.frame`, avec uniquement des variables de type `factor`
</div>

## Classification

### Classification hiérarchique (CAH)

Utilisation de la fonction `hclust()` du package `stats`

```r
d = dist(iris[-5])
h = hclust(d)
print(h)
plot(h)
z = cutree(h, 3)
table(z, iris$Species)

hward = hclust(dist(iris[-5]), "ward.D2")
plot(hward)
zward = cutree(hward, 3)
table(zward, iris$Species)
```

## Classification

### Classification directe ($k$-means)

Utilisation de la fonction `kmeans()` du package `stats`

```r
km3 = kmeans(iris[-5], 3, nstart = 30, iter.max = 20)
print(km3)
pairs(iris[-5], col = rainbow(3)[km3$cluster], pch = 19)

library(ggplot2)
library(FactoMineR)
acp = PCA(iris[-5], graph = FALSE)
ggplot(transform(acp$ind$coord, km3 = factor(km3$cluster)), 
    aes(x=Dim.1, y=Dim.2, color=km3)) + geom_point()
```

## Classification

### Choix du nombre de classe

Avec `kmeans()`

```r
lk = 1:9
km = lapply(lk, kmeans, x = iris[-5], nstart = 20)
I = km[[1]]$totss
W = unlist(lapply(km, function(res) return(res$tot.withinss))) 
B = unlist(lapply(km, function(res) return(res$betweenss))) 
r2 = B / I
PsF = (r2 / (lk - 1)) / ((1 - r2) / (nrow(iris) - lk))
library(ggplot2)
plot(1:9, r2, type = "l")
plot(1:9, PsF, type = "l")
```
