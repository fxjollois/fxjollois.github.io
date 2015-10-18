# Web Reporting

## Slides de cours 

- [Introduction au Web Reporting](intro)
- [Introduction à la programmation web statique](html-css-svg)
- [Introduction à la programmation web dynamique](javascript)

- [Introduction à Google Charts](googlecharts)

## Sujets TP

### TP1. HTML, CSS et JS 

[Première utilisation HTML, CSS et JS](http://embed.plnkr.co/7pv3ri/preview)
- Vous verrez un aperçu du rendu (*Preview*)
- Avec l'onglet *Code* (en haut à droite), vous pouvez voir le contenu de chaque fichier
- En cliquant sur *Edit*, vous pourrez éditer ces fichiers et faire le travail demandé

## TP2. Librairie Google Charts

A partir des données suivantes, que vous copierez dans un fichier JSON
```json
{
  "valeurs": [12, 5, 21, 18, 14, 15, 23, 31],
  "modalites": ["A", "B", "C", "E", "Z", "AZ", "qq", "J"]
}
```

- Créer trois graphiques via la librairie Google Charts
    - une table des données, avec deux colonnes et 8 lignes (plus les en-têtes de colonnes)
    - un diagramme en barre verticales des modalités
    - un diagramme en barre horizontables des modalités
- Modifier les options pour respecter les consignes suivantes 
    - table : affichage du numéro de ligne, pas de tri possible
    - pas de légende sur les diagrammes en barres
    - un titre sur le diagramme en barres verticales
    - changement de la couleur des barres
- Ajouter la gestion de la sélection d'une modalité dans un graphique avec :
    - la modalité choisie devient sélectionnée dans les deux autres graphiques
    - si plus de sélection, idem sur les autres graphiques
- On a en plus la variable `"groupe": ["A", "A", "B", "B", "A", "B", "B", "B"]` dans notre JSON
    - modifier le fichier de données et le formatage de celles-ci au format `DataTable` pour prendre en compte les groupes des modalités
    - faire un diagramme circulaire sur la répartition des groupes 
        - voir la fonction de [regroupement](https://developers.google.com/chart/interactive/docs/reference#google_visualization_data_group)
        - répartition en nombre en premier
        - répartition en somme des valeurs
- BONUS
    - faire une mise en page adaptée de tous les graphiques
    - réfléchir à l'ajout de boutons permettant de passer de l'une à l'autre des représentations du diagramme circulaire
    - réfléchir à la restriction sur les deux autres graphiques et à la sélection (ou mise en avant) sur la table des modalités correspondantes au groupe sélectionné dans le diagramme circulaire
