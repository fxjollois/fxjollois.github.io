---
title: Statistiques descriptives sous R
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(eval = FALSE);
```

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

Fonction `summary()` :

- Statistiques basiques sur un vecteur, 
- Dépendantes du type du vecteur
	- `numeric`: moyenne et quelques autres indicateurs
	- `factor` ou `character` : occurences 
- Si appliquée sur un `data.frame`, appliquée sur chaque variable.

```{r}
summary(mtcars)
summary(mtcars$mpg)
summary(mtcars$cyl)
summary(as.factor(mtcars$cyl))
```

## Univarié - quanti

Plusieurs fonctions de calculs de statistiques descriptives

```{r}
mean(mtcars$mpg)
sum(mtcars$mpg)
var(mtcars$mpg)
sd(mtcars$mpg)
min(mtcars$mpg)
max(mtcars$mpg)
range(mtcars$mpg)
median(mtcars$mpg)
quantile(mtcars$mpg)
quantile(mtcars$mpg, probs = 0.99)
quantile(mtcars$mpg, probs = c(0.01, 0.1, 0.9, 0.99))
```

Ajouter l'option `na.rm = TRUE` en cas de données manquantes

## Univarié - quanti

Il existe tout un ensemble de fonctions graphiques, dont voici quelques exemples

**Histogramme**

```{r}
hist(mtcars$mpg)
hist(mtcars$mpg, breaks = 20)
hist(mtcars$mpg, breaks = c(10, 15, 18, 20, 22, 25, 35))
```

**Boîte à moustache**

```{r}
boxplot(mtcars$mpg)
```

**QQ-plot**

```{r}
qqnorm(mtcars$mpg)
qqline(mtcars$mpg)
```

## Univarié - quali

Deux fonctions pour les calculs d'occurences et de fréquences

```{r}
table(mtcars$cyl)
prop.table(table(mtcars$cyl))
```

**Diagramme en barres**

```{r}
barplot(table(mtcars$cyl))
```

**Diagramme circulaires**

```{r}
pie(table(mtcars$cyl))
```

## Bivarié - quanti vs quanti

Calcul des corrélations et des covariances

```{r}
cov(mtcars$mpg, mtcars$wt)
cor(mtcars$mpg, mtcars$wt)
cor(mtcars$mpg, mtcars$wt, method = "spearman") # ou "kendall" - "pearson" par défaut
```

**Nuage de points**

```{r}
plot(mtcars$mpg, mtcars$wt)
plot(mtcars$mpg ~ mtcars$wt)
plot(mpg ~ wt, mtcars)
```

## Bivarié - quanti vs quanti

On peut aller plus loin en faisant un modéle linéaire simple. 

```{r}
m = lm(mpg ~ wt, data = mtcars)
m
summary(m)
plot(m)
plot(mpg ~ wt, data = mtcars)
abline(m, col = "red")
```

## Bivarié - quali vs quali

Table de contingence, mais aussi fréquences totales et marginales (en lignes et en colonnes)

```{r}
t <- table(mtcars$cyl, mtcars$am)
print(t)
prop.table(t)
prop.table(t, margin = 1)
prop.table(t, margin = 2)
```

## Bivarié - quali vs quali

**Mosaic plot**

```{r}
mosaicplot(t) 
```

**Diagramme d'association**

```{r}
assocplot(t)
```

**Diagramme en barres**

```{r}
barplot(t)
barplot(t, beside = T)
barplot(prop.table(t, margin = 2), beside = T)
```

## Bivarié - quali vs quali

**Diagramme en barres empilées**

```{r}
barplot(prop.table(t, margin = 2))
```

**Heatmap** (*à la main*)

```{r}
image(t(t), axes = F)
axis(1, at = seq(0, 1, length = ncol(t)), labels = colnames(t), lwd = 0)
axis(2, at = seq(0, 1, length = nrow(t)), labels = rownames(t), lwd = 0)
```

## Bivarié - quali vs quanti

En plus d'obtenir les statistiques par modalité de la variable qualitative, on peut représenter les boîtes à moustaches.

```{r}
tapply(mtcars$mpg, mtcars$cyl, mean)
tapply(mtcars$mpg, mtcars$cyl, summary)
boxplot(mpg ~ cyl, data = mtcars)
par(mfrow = c(3, 1), mar = c(2, 2, 2, 0) + 0.1)
for (c in c(4, 6, 8)) {
  hist(mtcars$mpg[mtcars$cyl == c], xlim = range(mtcars$mpg), main = c)
}
```

## Pour aller plus loin

Il existe plusieurs librairies pour réaliser des graphiques sous R. Une très utilisée est [`ggplot2`](http://ggplot2.org/)

**Chargement**

```{r}
library(ggplot2)
libraru(reshape2) # pour la fonction melt()
```

**quanti**

```{r}
qplot(mpg, data = mtcars, binwidth = 2)
qplot(0, mpg, data = mtcars, geom = "boxplot")
qplot(sample = mpg, data = mtcars, stat = "qq")
```

## `ggplot2`

**quali**

```{r}
qplot(factor(cyl), data = mtcars)
qplot(cyl, data = mtcars, geom = "bar")
ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) + 
	geom_bar(width = 1) + coord_polar(theta = "y")
```

**quanti vs quanti**

```{r}
qplot(wt, mpg, data = mtcars)
qplot(wt, mpg, data = mtcars, geom = c("point", "smooth"))
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point() + 
	geom_smooth(method = "lm")
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_bin2d()
```

## `ggplot2`

**quali vs quali**

```{r}
tab = melt(prop.table(table(mtcars$cyl, mtcars$am), margin = 1))
ggplot(data=tab, aes(x=factor(Var1), y=value, fill=factor(Var2))) +
    geom_bar(stat="identity")
ggplot(data=tab, aes(x=factor(Var1), y=value, fill=factor(Var2))) +
    geom_bar(stat="identity", position=position_dodge())

tab = melt(table(mtcars$cyl, mtcars$am))
ggplot(data=tab, aes(x=factor(Var1), y=factor(Var2), fill=value)) +
    geom_tile()
ggplot(data=tab, aes(x=factor(Var1), y=factor(Var2), size=value)) +
    geom_point()
```

## `ggplot2`

**quali vs quanti**

```{r}
qplot(factor(cyl), mpg, data = mtcars, geom = "boxplot")
ggplot(data=mtcars, aes(mpg)) + geom_histogram(binwidth = 2) + 
	facet_grid(cyl ~ 1)
```

**et plus encore**

```{r}
ggplot(mtcars, aes(mpg, wt, color=hp, size=disp)) + 
	geom_point() + facet_grid(cyl ~ am)
```