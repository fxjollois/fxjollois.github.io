---
title: TP - Complément sur la librairie D3.js
---

## Données

On va utiliser des données publiques de la RATP : [le trafic entrant par station en 2015](http://data.ratp.fr/explore/dataset/trafic-annuel-entrant-par-station-du-reseau-ferre-2015-test/).

Nous allons travailler sur le résumé de ces données, par arrondissement, pour la ville de Paris uniquement. Les données sont disponibles [ici](donnees/RATP-trafic-entrant-2015/trafic-annuel-entrant-par-station-du-reseau-ferre-2015-resume.csv).



Vous devez réaliser les points suivants :

- Lire les données à l'aide de D3
- Afficher un tableau indiquant, pour chaque arrondissement :
	- le nombre de stations
	- le nombre total d'entrées dans les stations de cet arrondissement
	- le nombre de stations de métro
	- le nombre total d'entrées dans le métro 	- le nombre de stations de RER
	- le nombre total d'entrées dans le RER
- Afficher un diagramme en barres verticales, représentant pour chaque arrondissement, le nombre total d'entrées
- Afficher un diagramme circulaire montrant la répartition `Métro`/`RER` des stations
	- par défaut, répartition en nombre de stations
	- possibilité d'avoir la répartition en nombre d'entrées
- Lorsque l'utilisateur cliquera sur le graphique circulaire (donc sélectionnera métro ou RER), le graphique du dessous devra correspondre au réseau choisi
- Réfléchir pour avoir un affichage **graphique** de la répartition métro/RER pour les stations et pour les entrées, par arrondissement 


<!--

On reprend le sujet du [TP sur Google Charts](webreporting-tp-google-charts.html) pour faire le même reporting avec la librairie [**d3.js**](http://d3js.org).

Vous pouvez voir un aperçu du rendu à avoir sur cette [page](webreporting/tp-d3-comp/rendu/)

-->
