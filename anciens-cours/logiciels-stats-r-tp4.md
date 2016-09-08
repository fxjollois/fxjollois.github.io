---
title: Logiciels stats - R - TP4
---

## Données

Nous allons reprendre sur le jeu de données `us_data` disponible dans la librairie `sashelp` de SAS, basé sur les [données de l'US Census 2010](http://www.census.gov/2010census/data/), et disponible au format `csv`[ici](logiciels-stats/US_DATA.csv).

## Travail à faire

- Analyser les états en fonction de leur population (variables `POPULATION_xxxx`) à l'aide 
	- d'une ACP (essayer avec standardisation et sans) 
	- d'une AFC
- Faire de même pour la densité (variables `DENSITY_xxxx`)
- Faire une partition en un nombre de classes adapté sur chaque ensemble de données précédent
	- Choisir le nombre de classes à l'aide de la CAH et de $k$-means (avec $r^2$ et $PseudoF$)
	- Prendre la partition obtenue avec $k$-means (et le nombre de classes choisi)
	- Comparer les deux partitions obtenues entre elles, et avec les régions et les divisions présentes dans les données