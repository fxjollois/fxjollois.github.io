---
title: Logiciels stats - SAS - TP3
---

## Données

Nous allons utiliser le jeu de données `prdsale` déjà présent dans la librairie `sashelp` dans **SAS Studio**. Il y a 1440 lignes et 10 colonnes dans cette table.

Voici le résultat de `proc contents` (permettant d'avoir des informations sur une table) :

| | Variable | Type | Long. | Format | Libellé |
|-|-|-|-|-|-|
|1  | ACTUAL   | Num.  |8  |DOLLAR12.2 | Actual Sales |
|2  | PREDICT  | Num.  |8  |DOLLAR12.2 | Predicted Sales |
|3  | COUNTRY  | Texte |10 |\$CHAR10.  | Country |
|4  | REGION   | Texte |10 |\$CHAR10.  | Region |
|5  | DIVISION | Texte |10 |\$CHAR10.  | Division |
|6  | PRODTYPE | Texte |10 |\$CHAR10.  | Product type |
|7  | PRODUCT  | Texte |10 |\$CHAR10.  | Product |
|8  | QUARTER  | Num.  |8  |8.         | Quarter |
|9  | YEAR     | Num.  |8  |4.         | Year |
|10 | MONTH    | Num.  |8  |MONNAME3.  | Month |

## Travail à faire

1. Décrire chaque variable de manière appropriée, selon le type de la variable
2. Décrire le lien entre les variables `ACTUAL` et `PREDICT`
3. Décrire le lien entre 
	- `ACTUAL` et chacune des autres variables de la table
	- idem pour `PREDICT`
4. Décrire les lien entre `ACTUAL` et `PREDICT`, et chacune des autres variables de la table
	- il existe plusieurs moyens de représenter chaque lien
	- ne pas hésiter à en essayer plusieurs pour trouver la plus représentative
