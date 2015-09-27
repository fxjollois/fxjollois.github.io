parameters: slides
# Web-Reporting

## Introduction à la data visualisation interactive

1. Qu'est-ce que le web-reporting ?
2. Pourquoi la visualisation ?
3. Pourquoi le web ?
4. Comment ?

---
# Le web-reporting ?

## Reporting

Rapport (plus ou moins court) sensé rendre compte de l'activité d'un service, d'une direction voire d'une entreprise. Il intègre à la fois des éléments numériques et des éléments graphiques. On a recourt aux techniques suivantes :
- **Statistiques**
- Calcul de **KPI** et création d'indicateurs
- **Visualisation de données**

## Web-Reporting

Idem mais accessible via une page web, avec idéalement de l'interactivité et une mise à jour automatisé (sinon, un PDF suffit amplement)

---
## Pour qui ?

Très généralement adressé à des décideurs (directeur de service, d'agence, DG, ...) qui vont s'appuyer dessus pour orienter à plus ou moins long terme l'avenir de leur service/agence/direction/entreprise/...

## Importance du reporting

A l'heure actuelle (masse de données, besoin de réactivité, ...), il est primordial que les décideurs puissent avoir les informations les plus lisibles, les plus à jour et les plus fiables.

---
## Place dans le schéma info 

- Place légitime : en sortie d'un entrepôt de données (ou magasin de données), pour la restitution d'information
- Sinon : possiblement sur des données opérationnelles pour des reporting d'activités très focalisées

## Contraintes

- Données souvent agrégées, venant de plusieurs tables (si données sources) et donc pouvant prendre du temps à être consolidées si pas d'entrepôts
- Réactivité
- Interactivité : le destinataire doit pouvoir *jouer* avec la représentation pour faire sa propre analyse

---
Source : https://developers.google.com/chart/interactive/docs/gallery/controls

<iframe src="exemple-reporting.html" style="width:100%; height: 100%; border: 0;"></iframe>

---
# Pourquoi la visualisation ?

## Visualisation de données

Représentation graphique de données plus ou moins complexe, permettant la mise en valeur de tendances ou points importants. Élément de plus en plus utilisé en data-journalisme d'abord, puis dans les entreprise

## Historique

Usage connu depuis plusieurs siècles (cf exemple dans la [page wikipedia](https://fr.wikipedia.org/wiki/Repr%C3%A9sentation_graphique_de_donn%C3%A9es_statistiques) sur le sujet).

On parle maintenant de **dataviz**

---
# Pourquoi le web ?

Tendance très forte dans le domaine de la dataviz, le passage au web est dû à plusieurs facteurs

## Aucune réelle contrainte logicielle

Tout ordinateur à l'heure actuelle est équipé gratuitement d'un navigateur. Toutefois, les outils utilisés fonctionnent très souvent sur les derniers générations de navigateurs.

## Interactivité

Au contraire de documents PDF classiques, une page web permet d'intégrer des éléments d'interactivité pour permettre à l'utilisateur d'analyser finement les données à disposition, plutôt que d'avoir un reporting qui contient tous les croisements possibles et inimaginables.

---
# Comment ?

## Utilisation des technologies web 

**HTML** et **CSS** bien évidemment, mais surtout **SVG** ou **Canvas** pour les aspects graphiques, et **JavaScript** pour l'importation des données, la création des graphiques, la manipulation de la page et la gestion des événements.

## Tout à la main ?

Non bien évidemment, car beaucoup trop lourd. Nous utilisons des **librairies JS**, dont les plus connus sont les suivantes :
- [Google Charts](https://developers.google.com/chart/)
- [D3.js](http://d3js.org/)
- [Raphaeljs](http://raphaeljs.com/)
- [Highcharts](http://www.highcharts.com/)