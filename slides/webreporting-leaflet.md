---
title: Librairie Leaflet
author: Cartographie en JavaScript
---

## Introduction à son utilisation

[Lien](http://leafletjs.com/) vers la librairie

- Librairie très complète pour de la cartographie
- Open source et avec une grande communauté d'utilisateur
- Assez simple d'utilisation, et performante
- Adaptée à l'utilisation sur mobile
- Basée sur des fonds de cartes issues généralement de [OpenStreetMap](http://openstreetmap.org/) 

[Exemple](../webreporting/exemple-leaflet.html)

## Chargement de la librairie

En 2 points :

- Chargement de la feuille de style dans une balise `link`

```html
<link rel="stylesheet" 
    href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css">
````

- Chargement de la librairie dans une balise `script`

```html
<script src="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js">
</script>
```

- Définir une hauteur à la `div` qui recevra la carte 

```html
<div id="map" style="width: 600px; height: 400px"></div>
```

## Définition de la carte

Création de la carte, en définissant 

- la `div` qui recevra la carte
- les coordonnées géographiques (latitude et longitude) du centre de la carte
- le niveau de zoom (entre 1 - la terre entière, et 18 - un pâté de maison)
- éventuellement quelques options sur les zooms possibles, les limites de la zone visible, et les couches à ajouter

```js
var map = L.map('map').setView([51.505, -0.09], 13);
```

## Ajout des tuiles 

Les tuiles sont les éléments des cartes et représentent un ensemble de petites images, plus rapides à charger qu'une seule grosse image

Il est possible ici aussi de définir un certain nombre d'options (zoom, taille des tuiles, opacité, z-index, ...)

```js
L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: 
        '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);
```        

*NB* : il est bien évidemment d'usage de citer la source des cartes

## Ajout d'éléments sur la carte

- `marker()` : marqueur sur la carte, au point déterminé par le tableau (latitude, longitude) passé en paramètre
- `circle()` : cercle, avec le centre (défini comme ci-dessus) comme premier paramètre et le rayon (en mètres) en deuxième paramètre
- `polygon()` : polygone fermé, déterminé par la suite des points définis dans un tableau
- ...
- Pour chaque forme, on peut ajouter des options (ici couleur pour `circle()`)
- `addTo()` : ajoute l'élément à la carte
- `bindPopup()` : détermine le texte, passé en paramètre, à afficher lorsqu'on clique sur l'objet
- `openPopup()` : ouvre la popup directement

---

- Marqueur, avec popup affiché directement

```js
L.marker([51.5, -0.09]).addTo(map)
	.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
```

- Cercle, avec option

```js
L.circle([51.508, -0.11], 500, {
	color: 'red',
	fillColor: '#f03',
	fillOpacity: 0.5
}).addTo(map).bindPopup("I am a circle.");
```

- Polygone

```js
L.polygon([
	[51.509, -0.08],
	[51.503, -0.06],
	[51.51, -0.047]
]).addTo(map).bindPopup("I am a polygon.");
```

## Gestion des événements

Lors de la gestion des événements, le paramètre contient l'objet `latlng` qui contient la latitude et la longitude

```js
var popup = L.popup();

function onMapClick(e) {
	popup
        .setLatLng(e.latlng)
        .setContent("You clicked the map at " + e.latlng.toString())
        .openOn(map);
}

map.on('click', onMapClick);
```