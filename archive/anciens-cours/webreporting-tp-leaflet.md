---
title: TP - Utilisation de Leaflet.js
---

Voici quelques liens qui ont permis de réaliser la base du TP ou qui vous aideront à réaliser la demande :

- Données :
    - [fichier GeoJSON des départements](webreporting/tp-leaflet/departements.geojson)
    - [fichier Taux de chômage](webreporting/tp-leaflet/departements-chomage.tsv)
- Source des données :
    - Les [communes au format GeoJSON](https://github.com/gregoiredavid/france-geojson) : **attention**, dans ces fichiers, les coordonnées sont inversées (`[long, lat]` au lieu de `[lat, long]`)
    - Les [données du chômage](http://www.insee.fr/fr/themes/tableau.asp?reg_id=99&ref_id=TCRD_025) issues de l'INSEE
- Lien pour le code
    - Un [parser](http://papaparse.com/) pour lire un fichier CSV
    - Un [exeple](http://leafletjs.com/examples/geojson.html) pour travailler avec du GeoJSON et Leaflet
    - Un [autre](http://leafletjs.com/examples/choropleth.html) un peu plus poussé, pour ajouter de l'interaction
    - Une [présentation](http://bost.ocks.org/mike/leaflet/) par Mike Bostocks pour l'utilisation avec **d3.js**

Base de travail :

- [sans d3.js](webreporting/tp-leaflet/base-simple/)
- [avec d3.js](webreporting/tp-leaflet/base-d3/)

## A faire

A partir de cette base, vous devez :

- faire en sorte que le zoom de la carte soit limité (ni trop grand, ni trop petit)
- jouer sur l'opacité lors du passage de la souris pour que le département soit bien visible
- améliorer l'affichage des informations en créant une fenêtre `tooltip` affichant toutes les informations dont on dispose
- donner la possibilité de choisir l'indicateur permettant la coloration des départements
    - dans ce cas, il serait judicieux de faire une échelle commune à tous les indicateurs, du genre de celle de l'INSEE
- s'intéresser aux autres tuiles disponibles via Open Street Map, et les autres fournisseurs

Pour avoir le résultat proposé, regarder :

- [solution sans d3.js](webreporting/tp-leaflet/solution-simple/)
- [solution avec d3.js](webreporting/tp-leaflet/solution-d3/) 


## *Bonus*

Pour ceux qui ont fini tôt, vous pouvez réaliser une cartographie des scénarios de prévision de la population à horizon 2040 selon l'INSEE ([fichiers source](http://www.insee.fr/fr/themes/detail.asp?reg_id=99&ref_id=proj-dep-population-2010)). Il vous sera bien évidemment nécessaire de faire un peu de manipulation de fichiers auparavant. Essayez d'abord avec le scénario central.
