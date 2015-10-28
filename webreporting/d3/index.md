parameters: slides
# Librairie D3.js

Data-Driven Documents

## Introduction à son utilisation

[Lien](http://www.d3js.org) vers la librairie

- Librairie très complète avec beaucoup d'exemples à disposition
- Personnalisation totale possible
- Accès à des primitives `SVG` permettant toute innovation
- Peu accessible directement et assez technique

[Exemple](exemple.html)

---
## Fonctionnement typique

Idée principale : 

- Lier les données au DOM
- Appliquer des transformations, baées sur les données, au document

Plusieurs concepts à comprendre :

- Base : sélection, modification, ajout et insertion d'éléments
- Ajout de données au DOM
- Propriété dynamique, et Transformation
- Chaînage des fonctions

---
## Base : sélection et modification

- Deux fonctions de sélection respectivement d'un élément (`select()`) et de l'ensemble des éléments (`selectAll()`) correspondant à la définition passée en paramètre (sélecteur idem que pour le CSS) :

```
d3.select("selecteur");
d3.selectAll("selecteur");
```

- Une fonction (`size()`) permettant de connaître la taille de la sélection
- Une fonction (`empty()`) permettant de savoir si la sélection est vide

---
## Base : modification, ajout et insertion d'éléments

- Plusieurs fonctions pour modifier les éléments sélectionnés (par exemple `style()` ou `html()`). Le code suivant permet de mettre le texte en rouge pour tout le corps de la page

```
var corps = d3.select("body");
corps.style("color", "red");
```

- Deux fonctions pour respectivement insérer un élément HTML fils à la fin (`append()`) ou au début (`insert()`) d'un élément père, qui s'utilisent comme suit :

```
selection.append("balise");
selection.insert("balise");
```

---
## Exemple : sur la base de d3.js

<iframe height='268' scrolling='no' src='//codepen.io/fxjUPD/embed/bVMMjZ/?height=268&theme-id=0&default-tab=result' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/fxjUPD/pen/bVMMjZ/'>d3.js : base de la librairie</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

---
## Ajout de données au DOM

- Avec la fonction `data()` sur une sélection, il est possible de lier les données passées en paramètres (ce doit être un tableau) au DOM à la sélection en question. Le code suivant affecte chaque élément du tableau à chaque élément renvoyé par le sélecteur précédent

```
var selection = d3.selectAll("selecteur");
selection.data(tableau);
```

- S'il y a différence entre la taille de la sélection et la taille du tableau passé en paramètre de `data()`, il existe deux fonctions utiles
    - `enter()` : pour gérer les éléments du tableau en plus
    - `exit()` : pour gérer les éléments de la sélection en plus

---
## Propriété dynamique

- Sur chaque sélection, on peut appliquer des modifications de style ou de contenu (voire autre), en fonction des données sont liées au DOM
- Utilisation d'une fonction anonyme, dont les paramètres peuvent être, dans cet ordre :
    - la valeur de l'élément du tableau affectée à l'élément
    - la position de la valeur dans le tableau
    - il est possible de n'utiliser que la valeur, voire aucun paramètre si besoin

```
var selection = d3.selectAll("selecteur");
selection.data(tableau);
selection.html(function(d, i) {
    return "position = " + i + ", valeur = " + d;
})
```

---
## Exemple : ajout de données + propriété dynamique

<iframe height='268' scrolling='no' src='//codepen.io/fxjUPD/embed/eprrjJ/?height=268&theme-id=0&default-tab=result' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/fxjUPD/pen/eprrjJ/'>d3.js : data + style dynamique</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

---
## Exemple : fonction `enter()`

<iframe height='268' scrolling='no' src='//codepen.io/fxjUPD/embed/wKjjXN/?height=268&theme-id=0&default-tab=result' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/fxjUPD/pen/wKjjXN/'>d3.js : data + enter()</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

---
## Exemple : fonction `exit()`

<iframe height='268' scrolling='no' src='//codepen.io/fxjUPD/embed/LpmmmL/?height=268&theme-id=0&default-tab=result' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/fxjUPD/pen/LpmmmL/'>d3.js : data + exit()</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>

---
## Chaînage des fonctions

- Principe généralement appliqué en JS orienté objet : **toute fonction d'un objet renvoie cet objet** 
    - sauf si la fonction a pour but de renvoyer un résultat spécifique
    - donc concerne plutôt les procédures (qui sont des fonctions en JS)
- Corollaire : il est possible d'enchaîner un grand nombre de fonctions directement 

<iframe height='268' scrolling='no' src='//codepen.io/fxjollois/embed/MaGGxK/?height=268&theme-id=0&default-tab=result' frameborder='no' allowtransparency='true' allowfullscreen='true' style='width: 100%;'>See the Pen <a href='http://codepen.io/fxjollois/pen/MaGGxK/'>d3.js : chaînage des fonctions</a> by FX Jollois (<a href='http://codepen.io/fxjollois'>@fxjollois</a>) on <a href='http://codepen.io'>CodePen</a>.
</iframe>