---
title: Logiciels stats - SAS - TP4
---

## Données

Nous allons travailler sur le jeu de données `us_data` disponible dans la librairie `sashelp` de SAS, basé sur les [données de l'US Census 2010](http://www.census.gov/2010census/data/).

Ce jeu de données concernent les états des USA, sur plusieurs dizaines d'indicateurs, sur la population, de 1910 à 2010.

## Travail à faire

- Analyser les états en fonction de leur population (variables `POPULATION_xxxx`) à l'aide 
	- d'une ACP (essayer avec standardisation et sans) 
	- d'une AFC
- Faire de même pour la densité (variables `DENSITY_xxxx`)
- Faire une partition en un nombre de classes adapté sur chaque ensemble de données précédent
	- Choisir le nombre de classes à l'aide de la CAH
	- Affiner la partition avec $k$-means (en l'initialisant avec les centres des classes obtenus précédemment)
	- Comparer les deux partitions obtenues entre elles, et avec les régions et les divisions présentes dans les données