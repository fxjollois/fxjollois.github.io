---
title: Librairie Google Charts
---

## Introduction à son utilisation

[Lien](https://developers.google.com/chart/) vers la librairie

- Librairie facile à utilisée
- Grand choix de graphiques à disposition
- Personnalisation possible
- Sur des données au format `DataTable` spécifique

[Exemple](../webreporting/exemple-google-charts.html)

## Etapes pour son utilisation

Les cinq étapes à suivre pour créer un graphique avec Google Charts

1. **Chargement** de la librairie
2. Formatage des **données**
3. **Personnalisation** du graphique
4. **Création** du graphique
5. Ajout d'**interactivité**

## Chargement de la librairie

En 2 étapes :

1. Chargement de la librairie **Google JSAPI** avec l'URL `https://www.google.com/jsapi` dans une balise `script`
2. Chargement de la librairie **Google Visualization**, en indiquant le ou les packages à charger (i.e. `corechart`, `table`, ...) avec la fonction `google.load` prenant en paramètres :
    - la librairie `visualization` 
    - la version de celle-ci (`1` pour version stable, `1.1` pour la nouvelle)
    - la liste des packages 

Ajout d'une fonction (`google.setOnLoadCallback (f)`) permettant le lancement d'une fonction `f` lorsque la librairie est chargée, pour éviter les problèmes de synchronisation

## sur l'exemple

```html
<script type="text/javascript" src="https://www.google.com/jsapi">
</script>
<script type="text/javascript">

 // Chargement de la librairie et du package corechart
 google.load('visualization', '1.0', {'packages':['corechart']});

 // Définition de la fonction à exécuter (drawChart) lorsque la 
 // librairie est chargée
 google.setOnLoadCallback(drawChart);
 
 ...
 </script>
```

## Formatage des données

Utilisation de la classe `google.visualization.DataTable` :

- objet à deux dimensions
- colonnes définies par un type, avec label et/ou id

Possibilité de créer un objet de différentes manières :

- Création d'un objet vide, définition des colonnes puis insertion des lignes
- A partir d'un tableau JSON, avec un format spécifique (la première ligne contenant les infos des colonnes)
- A partir d'un littéral JSON, avec aussi un format spécifique (deux objets : un pour la définition des colonnes, un pour les valeurs des lignes)
- A l'aide d'une requête `SQL` sur une source *Spreadsheet* ou *Fusion Table*

## sur l'exemple

```js
// Création d une variable, instance de DataTable
var data = new google.visualization.DataTable();

// Définition des colonnes de la table
data.addColumn('string', 'Topping');
data.addColumn('number', 'Slices');

// Insertion des lignes (ici en une fois)
data.addRows([
  ['Mushrooms', 3],
  ['Onions', 1],
  ['Olives', 1],
  ['Zucchini', 1],
  ['Pepperoni', 2]
]);
```

## Personnalisation du graphique

Chaque graphique est personnalisable à l'aide de paramètres pour certains communs à tous, pour d'autres spécifiques à chaque type de graphique

Utilisation d'un objet JSON contenant la définition des paramètres du graphique

Quelques paramètres communs :

- `width` et `height` : largeur et hauteur du graphique
- `title` : titre
- ...

## sur l'exemple

```js
// Création d un objet JSON
var options = {
    // on définit ici le titre et la taille du graphique
    'title':'How Much Pizza I Ate Last Night',
    'width': 600,
    'height': 400,
    // ainsi que les paramètres de la légende, qui peuvent être 
    // détaillée dans un objet JSON
    'legend': {
        position: 'bottom', 
        textStyle: {
            color: 'blue', 
            fontSize: 10
        }
    }
};
```

## Création du graphique

En 2 étapes :

- Instanciation dans une variable du type de graphique (via une fonction spécifique à chaque type de l'objet `google.visualization` prenant en paramètre l'id de la div conteneur)
    - `PieChart` pour un diagramme circulaire
    - `BarChart` pour un diagramme en barre horizontale
    - ...
- Dessin du graphique via la fonction `draw()` prenant en paramètre deux objets 
    - les données
    - les options

## sur l'exemple

```js
// Création d une instance de PieChart, et indication du conteneur 
// du graphique
var cont = document.getElementById('chart_div');
var chart = new google.visualization.PieChart(cont);

// Dessin du graphique selon les données et les options 
// en paramètres
chart.draw(data, options);
```

**Note** Dans le corps du fichier HTML doit se trouver une `div` dont l'identifiant est `chart_div`
```
<body>
    <div id="chart_div"></div>
</body>
```

## Ajout d'interactivité

Possibilité d'ajouter un *listener* sur un graphique (via la fonction `google.visualization.events.addListener()`) prenant en paramètre :

- la variable instance du graphique
- le type d'événement
    - `ready`, `select`, `error`, `onmouseover` et `onmouseout`
- la fonction à exécuter lors de l'événement

Fonctions des instances intéressantes dans ce cas :

- `getSelection`, `getValue`
- `setSelection`

## sur l'exemple

```js
// Définition de la fonction a exécuter lors de l événement
function selectHandler() {
    // Récupération de la sélection
    var selectedItem = chart.getSelection()[0];
    // si sélection
    if (selectedItem) {
        // récupération de la valeur choisie
        var topping = data.getValue(selectedItem.row, 0);
        // affichage via pop-up classique
        alert('The user selected ' + topping);
    }
}
// Ajout du listener sur le graphique, pour l événement "select"
google.visualization.events.addListener(
    chart, 'select', selectHandler);    
```
