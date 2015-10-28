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
- Chaînage des commandes

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

<iframe width="100%" height="300" src="//jsfiddle.net/fxjollois/fmpdt2qc/embedded/html,js,result" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

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

<iframe width="100%" height="300" src="//jsfiddle.net/fxjollois/xpmcfwbs/embedded/html,js,result" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

---
## Exemple : fonction `enter()`

<iframe width="100%" height="300" src="//jsfiddle.net/fxjollois/a93fzd70/embedded/html,js,result" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

---
## Exemple : fonction `exit()`

<iframe width="100%" height="300" src="//jsfiddle.net/fxjollois/Lpay57dh/embedded/html,js,result" allowfullscreen="allowfullscreen" frameborder="0"></iframe>