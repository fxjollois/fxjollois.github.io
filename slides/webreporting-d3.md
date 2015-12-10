---
title: Librairie D3.js
date: Data-Driven Documents
---


## Introduction à son utilisation

[Lien](http://www.d3js.org) vers la librairie

- Librairie très complète avec beaucoup d'exemples à disposition
- Personnalisation totale possible
- Accès à des primitives `SVG` permettant toute innovation
- Peu accessible directement et assez technique

[Exemple](../webreporting/exemple-d3.html)

## Fonctionnement typique

Idée principale : 

- Lier les données au DOM
- Appliquer des transformations, baées sur les données, au document

Plusieurs concepts à comprendre :

- Base : sélection, modification, ajout et insertion d'éléments
- Ajout de données au DOM
- Propriété dynamique, et Transformation
- Chaînage des fonctions

## Base : sélection et modification

- Deux fonctions de sélection respectivement d'un élément (`select()`) et de l'ensemble des éléments (`selectAll()`) correspondant à la définition passée en paramètre (sélecteur idem que pour le CSS) :

```js
d3.select("selecteur");
d3.selectAll("selecteur");
```

- Une fonction (`size()`) permettant de connaître la taille de la sélection
- Une fonction (`empty()`) permettant de savoir si la sélection est vide

## Base : modification, ajout et insertion d'éléments

- Plusieurs fonctions pour modifier les éléments sélectionnés (par exemple `style()` ou `html()`). Le code suivant permet de mettre le texte en rouge pour tout le corps de la page

```js
var corps = d3.select("body");
corps.style("color", "red");
```

- Deux fonctions pour respectivement insérer un élément HTML fils à la fin (`append()`) ou au début (`insert()`) d'un élément père, qui s'utilisent comme suit :

```js
selection.append("balise");
selection.insert("balise");
```

## Exemple : sur la base de d3.js

<p data-height="268" data-theme-id="0" data-slug-hash="bVMMjZ" data-default-tab="result" data-user="fxjollois" class='codepen'>See the Pen <a href='http://codepen.io/fxjollois/pen/bVMMjZ/'>d3.js : base de la librairie</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Ajout de données au DOM

- Avec la fonction `data()` sur une sélection, il est possible de lier les données passées en paramètres (ce doit être un tableau) au DOM à la sélection en question. Le code suivant affecte chaque élément du tableau à chaque élément renvoyé par le sélecteur précédent

```js
var selection = d3.selectAll("selecteur");
selection.data(tableau);
```

- S'il y a différence entre la taille de la sélection et la taille du tableau passé en paramètre de `data()`, il existe deux fonctions utiles
    - `enter()` : pour gérer les éléments du tableau en plus
    - `exit()` : pour gérer les éléments de la sélection en plus

## Propriété dynamique

- Sur chaque sélection, on peut appliquer des modifications de style ou de contenu (voire autre), en fonction des données sont liées au DOM
- Utilisation d'une fonction anonyme, dont les paramètres peuvent être, dans cet ordre :
    - la valeur de l'élément du tableau affectée à l'élément
    - la position de la valeur dans le tableau
    - il est possible de n'utiliser que la valeur, voire aucun paramètre si besoin

```js
var selection = d3.selectAll("selecteur");
selection.data(tableau);
selection.html(function(d, i) {
    return "position = " + i + ", valeur = " + d;
})
```

## Exemple : ajout de données + propriété dynamique

<p data-height="268" data-theme-id="0" data-slug-hash="eprrjJ" data-default-tab="result" data-user="fxjollois" class='codepen'>See the Pen <a href='http://codepen.io/fxjollois/pen/eprrjJ/'>d3.js</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Exemple : fonction `enter()`

<p data-height="268" data-theme-id="0" data-slug-hash="wKjjXN" data-default-tab="result" data-user="fxjollois" class='codepen'>See the Pen <a href='http://codepen.io/fxjollois/pen/wKjjXN/'>d3.js</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Exemple : fonction `exit()`

<p data-height="268" data-theme-id="0" data-slug-hash="LpmmmL" data-default-tab="result" data-user="fxjollois" class='codepen'>See the Pen <a href='http://codepen.io/fxjollois/pen/LpmmmL/'>d3.js</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Chaînage des fonctions

- Principe généralement appliqué en JS orienté objet : **toute fonction d'un objet renvoie cet objet** 
    - sauf si la fonction a pour but de renvoyer un résultat spécifique
    - donc concerne plutôt les procédures (qui sont des fonctions en JS)
- Corollaire : il est possible d'enchaîner un grand nombre de fonctions directement 

<p data-height="268" data-theme-id="0" data-slug-hash="MaGGxK" data-default-tab="result" data-user="fxjollois" class='codepen'>See the Pen <a href='http://codepen.io/fxjollois/pen/MaGGxK/'>d3.js</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>
