---
title: TP - Initiation à HTML, CSS et JS 
---

Première utilisation HTML, CSS et JS ([lien vers Plnker](http://embed.plnkr.co/7pv3ri/preview)) :

- Vous verrez un aperçu du rendu (*Preview*)
- Avec l'onglet *Code* (en haut à droite), vous pouvez voir le contenu de chaque fichier
- En cliquant sur *Edit*, vous pourrez éditer ces fichiers et faire le travail demandé

## A faire

Créer un script permettant de faire un diagramme avec les contraintes suivantes :

- barres verticales, 
- largeur du graphique égale à celle de la fenêtre,
- largeur des barres en fonction du nombre de celles-ci (et donc du nombre de modalités),
- modalités affichées en dessous de chaque barre,
- valeurs affichées au dessus de chaque barre,
- résultat fonctionnel quelque soit le nombre de modalités données (tester avec
  différentes valeurs)
- changement de couleur de la barre sur laquelle passe la souris
- gestion des plusieurs clics sur les boutons :
  - le premier clique créé et affiche le diagramme
  - le deuxième le cache, sans le supprimer
  - le troisième l'affiche de nouveau, sans le recréer donc

Pour améliorer le graphique, on choisit de ne plus afficher directement la
valeur sur le graphique. On veut une fenêtre *pop-up* qui s'affiche lorsque la
souris passe sur une barre. Dans cette fenêtre, on veut la modalité et la valeur
associée. On souhaite que cette fenêtre suive le curseur de la souris. On doit
faire attention à l'affichage si la souris est proche d'un bord de la fenêtre.

Pour encode améliorer, on souhaite récupérer les données à partir d'un fichier
texte au format **JSON**, de ce type :
```json
{
  "valeurs": [12, 5, 21, 18, 14],
  "modalites": ["A", "B", "C", "E", "Z"]
}
```
