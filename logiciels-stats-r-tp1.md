---
title: Logiciels stats - R - TP1
---

<style>
.fichier {
    width: 100%;
    height: 100px;
)
</style>

Le but de ce TP est de commencer à manipuler les fichiers, et les `data.frame` **R** pour se familiariser avec le langage.

## Importation de fichiers

Vous devez importer les fichiers texte qui suivent, après les avoir enregistrer et placer dans un répertoire spécifique de préférence.

[`Iris.txt`](logiciels-stats/Iris.txt)

Pas de difficulté majeure, si ce n'est la taille de la variable `Species` (des valeurs ont plus de 8 caractères).

<object data="logiciels-stats/Iris.txt" type="text/plain" class="fichier">
    impossible à afficher
</object>
      
[`heart.txt`](logiciels-stats/heart.txt)Ici non plus, pas de difficulté. Le séparateur est la tabulation (`\t` en R). 

<object data="logiciels-stats/heart.txt" type="text/plain" class="fichier">
    impossible à afficher
</object>

[`Detroit_homicide.txt`](logiciels-stats/Detroit_homicide.txt)Ici, les premières lignes ne sont pas à prendre en considération lors de l'importation. Et nous avons des `labels` pour les variables.<object data="logiciels-stats/Detroit_homicide.txt" type="text/plain" class="fichier">
    impossible à afficher
</object>

[`hepatitis.TXT`](logiciels-stats/hepatitis.TXT)Attention à l'indicateur de données manquantes (`?` dans ce fichier).
<object data="logiciels-stats/hepatitis.TXT" type="text/plain" class="fichier">
    impossible à afficher
</object>      


## Compléments de langage

Reprendre l'importation du fichier `heart.txt` (cf ci-dessus), et répondre aux questions suivantes en complétant le code précédemment écrit.

1. Créer une indicatrice binaire `FALSE/TRUE` pour la présence ou non de problème de coeur (dernière variable)
2. Créer une variable comptant le nombre de fois où une variable est égale à `A` (entre `type_douleur`, `sucre`, `electro`, et `vaisseau`)
3. Créer une variable `factor` à partir de l'indicatrice binaire faite au point 1 avec comme labels des modalités `presence` pour `TRUE` et `absence` pour `FALSE`
4. Créer un nouveau `data.frame` avec uniquement les individus ayant strictement moins de 60 ans
5. Créer maintenant, à partir du précédent, deux `data.frames` : 
    - une pour les hommes
    - une autre pour les femmes

Reprendre l'importation du fichier `detroit_homicide.txt` (cf ci-dessus)

1. Intégrer le texte introductif dans un attribut du `data.frame`
2. Intégrer les labels des variables dans un autre attribut, sous forme de `data.frame` à deux colonnes
