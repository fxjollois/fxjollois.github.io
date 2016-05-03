---
title: Visualisation de données - D3.js
subtitle: Data-Driven Documents
---

[D3.js](http://www.d3js.org) est une librairie `javascript` très complète avec beaucoup d'exemples à disposition, avec une personnalisation totale possible. Elle permet l'accès à des primitives `SVG` permettant toute innovation. Malheureusement, elle est peu accessible directement et assez technique.

## Fonctionnement typique

L'edée principale est de lier les données au **DOM** (*Document Object Model*), et d'appliquer des transformations, basées sur les données, au document.

Il y a plusieurs concepts spécifiques à bien comprendre pour l'utiliser pleinement :

- Sélection, modification, ajout et insertion d'éléments
- Ajout de données au DOM
- Propriété dynamique, et Transformation
- Chaînage des fonctions

## Base 

### Sélection et modification

Il existe deux fonctions de sélection respectivement d'un élément (`select()`) et de l'ensemble des éléments (`selectAll()`) correspondant à la définition passée en paramètre (sélecteur idem que pour le CSS) :

```js
var selection1 = d3.select("selecteur");
var selection2 = d3.selectAll("selecteur");
```

On a de plus deux fonctions sur l'objet renvoyé par ces sélecteurs pour connaître la taille de la sélection :

- `size()` : taille de la sélection
- `empty()` : sélection vide ou non


### Modification, ajout et insertion d'éléments

Plusieurs fonctions permettent de modifier les éléments sélectionnés (comme par exemple `style()` pour appliquer des règles `CSS` ou `html()` pour modifier le contenu de la balise). Le code suivant permet de mettre le texte en rouge pour tout le corps de la page

```js
var corps = d3.select("body");
corps.style("color", "red");
```

Deux fonctions sont utiles pour respectivement insérer un élément `HTML` fils à la fin (`append()`) ou au début (`insert()`) d'un élément père, qui s'utilisent comme suit :

```js
selection.append("balise");
selection.insert("balise");
```

### Exemple 

Ici, on sélectionne la balise `<body>` (qui est vide au départ). Dans cette sélection, on ajoute deux balises `div`, pour mettre dans la première la taille de la sélection (`1` normalement) et dans la seconde le test si elle est vide ou non (normalement `false`). Enfin, on met le texte de la sélection en rouge (donc tout).

<p data-height="320" data-theme-id="0" data-slug-hash="bVMMjZ" data-default-tab="js,result" data-user="fxjollois" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/fxjollois/pen/bVMMjZ/">d3.js : base de la librairie</a> by FX Jollois (<a href="http://codepen.io/fxjollois">@fxjollois</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Ajout de données au DOM

Avec la fonction `data()` sur une sélection, il est possible de lier les données passées en paramètres (ce doit être un **tableau**) au DOM à la sélection en question. Le code suivant affecte chaque élément du tableau à chaque élément renvoyé par le sélecteur précédent

```js
var selection = d3.selectAll("selecteur");
selection.data(tableau);
```

S'il y a différence entre la taille de la sélection et la taille du tableau passé en paramètre de `data()`, il existe deux fonctions utiles pour gérer ces cas :

- `enter()` : pour gérer les éléments du tableau en plus
- `exit()` : pour gérer les éléments de la sélection en plus

### Propriété dynamique

Sur chaque sélection, on peut appliquer des modifications de style ou de contenu (voire autre), en fonction des données sont liées au DOM. On passe par l'utilisation d'une fonction anonyme, dont les paramètres peuvent être, dans cet ordre :

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

### Exemples

#### Ajout de données + propriété dynamique

Dans cet exemple, on affecte les données du tableau (qui contient des couleurs) à chaque `div` du `body`. Et on affecte un style `CSS` (la couleur), en prenant comme valeur celle contenu dans le tableau.

<p data-height="266" data-theme-id="0" data-slug-hash="eprrjJ" data-default-tab="html,result" data-user="fxjollois" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/fxjollois/pen/eprrjJ/">d3.js : data + style dynamique</a> by FX Jollois (<a href="http://codepen.io/fxjollois">@fxjollois</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

#### fonction `enter()`

Le tableau passé en paramètre de `data()` est ici plus long que la sélection. Pour les valeurs supplémentaires du tableau (sélectionnées avec le `enter()`), on ajoute des `div` (avec `append()`).

<p data-height="266" data-theme-id="0" data-slug-hash="wKjjXN" data-default-tab="html,result" data-user="fxjollois" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/fxjollois/pen/wKjjXN/">d3.js : data + enter()</a> by FX Jollois (<a href="http://codepen.io/fxjollois">@fxjollois</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

#### fonction `exit()`

C'est ici le contraire, le tableau est plus petit que la sélection. Pour les éléments de la sélection en trop (sélectionnés avec le `exit()`), on les supprime (avec `remove()`).

<p data-height="266" data-theme-id="0" data-slug-hash="LpmmmL" data-default-tab="html,result" data-user="fxjollois" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/fxjollois/pen/LpmmmL/">d3.js : data + exit()</a> by FX Jollois (<a href="http://codepen.io/fxjollois">@fxjollois</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Chaînage des fonctions

Il faut absolument comprendre le principe généralement appliqué en `JS` orienté objet : 

> **Toute fonction d'un objet renvoie cet objet** 

Ceci est vrai sauf si la fonction a pour but de renvoyer un résultat spécifique. Et cela ne concerne donc que les procédures (qui sont aussi des fonctions en JS).

Le corollaire de ce principe est intéressant : 

> Il est possible d'enchaîner un grand nombre de fonctions directement 

Dans l'exemple ci-dessous, on utilise ce principe pour créer autant de `div` qu'il y a de couleurs dans le tableau, en indiquant le contenu `HTML` de celles-ci, et en leur appliquant un style `CSS` spécifique. 

<p data-height="266" data-theme-id="0" data-slug-hash="MaGGxK" data-default-tab="js,result" data-user="fxjollois" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/fxjollois/pen/MaGGxK/">d3.js : chaînage des fonctions</a> by FX Jollois (<a href="http://codepen.io/fxjollois">@fxjollois</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>


