---
title: Langage SAS
---

## Le logiciel

[**SAS**](http://www.sas.com) :

- acteur majeur sur le marché des logiciels de statistiques
- outil principal : **SAS Base** ou **SAS Studio** (en ligne)
    - langage propriétaire
    - scripts à exécuter (tout ou partie au choix)
    - 3 parties importantes :
        - éditeur de texte
        - journal d'exécution
        - résultats

## Concepts importants - Données

- Table 
    - ensemble de lignes décrites par des colonnes nommées (dites aussi variables)
    - types de variable : numérique, alpha-numérique, date
    - stockées dans des librairies
- Librairie
    - répertoire de stockage des tables
    - `work` : espace temporaire (vidé à la fin d'une session), utilisé par défaut
    - `sashelp`, `maps`, ... : librairies existantes par défaut
    - possibilité de créer sa propre librairie, en poitant le répertoire voulu pour le stockage (persistant)

```sas
libname lib '/chemin/vers/repertoire';
```

## Concepts importants - Langage

- Etape `DATA`
    - définition, importation, modification des tables
    - commandes exécutées pour chaque ligne de manière identique et séparée
    - quelques commandes spécifiques pour travailler avec des infos de lignes précédentes
- Procédure (`PROC`)
    - manipulation sur des colonnes 
    - calculs statistiques, graphiques, ...
    - quelques procédures spécifiques de manipulation de tables

## Importation de données

### Etape `DATA` - Avec insertion directe des données 

- table stockée dans la librairie `work` si non spécifiée
- indiquer `lib.tab` pour mettre la table dans la librairie `lib`
- 3 variables créées 
    - `X` numérique
    - `Y` numérique
    - `Z` alpha-numérique
- `label` : permet d'ajouter une description à une variable ou à une table

## Importation de données

### Etape `DATA` - Avec insertion directe des données 

```sas
data tab (label= "table exemple");
    input X Y Z$;
    label X = "Variable X"
          Y = "Variable Y";
    cards;
1 12 A
2 15 A
1 10 B
1  9 C
3 13 B
3  8 A
run;
```

## Importation de données

### Etape `DATA`  - Avec importation 

- données dans un fichier texte
- options usuels :
    - délimiteur (avec `dlm = ';'` par exemple)
    - première observation à considérer (`firstobs = `)
    - nombre d'observation (`n = `)
- variables
    - nombre et type à connaître

```sas
data tab;
    infile 'chemin/vers/fichier' options;
    input variables;
run;
```

## Importation de données

### Procédure `IMPORT`

- données possibles : fichier texte, Excel, Access, ...
- options usuelles :
    - type de données (avec `dbms=dlm` pour texte par exemple)
    - `replace` pour indiquer si on remplace la table si elle existe
- paramètres usuels :
    - si `dbms=dlm`, alors	`delimiter=";"`
    - présence ou non des noms de variables (avec `getnames=yes` ou `no`)

```sas
proc import datafile='/chemin/vers/fichier' out=tab options;
    paramètres;
run;
```

## `FORMAT` et `INFORMAT`

2 concepts complémentaires :

- `INFORMAT` : indique comment transformer une valeur (souvent à l'importation) pour la mettre dans un format spécifique
    - impact fort dans les calculs car modification du stockage
    - exemple : une variable sexe codée 1 ou 2 (numérique donc) transformée en caractère `H` ou `F`
- `FORMAT` : indique comment présenter une valeur stockée dans un type spécifique
    - pas d'impact dans les calculs car pas de modifications du stockage
    - exemple : un nombre réel stocké très précisemment (sans limite de précision) pourra être affiché avec un arrondià 2 décimales

## `INFORMAT` 

### Par défaut

- `X` et `Y` implicitement au format numérique
- `Z` alpha-numérique (informat spécifié `$`)

```sas
data tab;
    input X Y Z$;
    cards;
1 12 A
2 15 A
3 13 B
3  8 ABCDEFGHIJ
run;
```

Par défaut, la taille d'une chaîne alpha-numérique est de 8. Ici, la dernière valeur de `Z` sera donc `ABCDEFGH`.

## `INFORMAT` 

### Spécification dans `input`

- idem pour `X` et `Y`
- On spécifie que la variable `Z` a 10 caractères maximum possibles

```sas
data tab;
    input X Y Z $10.;
    cards;
1 12 A
2 15 A
3 13 B
3  8 ABCDEFGHIJ
run;
```

## `INFORMAT` 

### Spécification dans `input`

Avec indication de la position de début de lecture de la variable 

- `X` : débute au début de la ligne (`@1`) et  caractère de taille 1 (`$1.`)
- `Y` : débute à la position 3 (`@3`) et numérique (`2.` qui devient `8.` automatiquement)
- `Z` : débute à la position 6 (`@6`) et chaîne de taille 10 (`$10.`)

```sas
data tab;
    input @1 X $1. @3 Y 2. @6 Z $10.;
    cards;
1 12 A
2 15 A
3 13 B
3  8 ABCDEFGHIJ
run;
```

## `INFORMAT` 

### Spécification dans `informat`

- idem que précédemment, sans nécessité de spécifier la position de départ 
- pratique dans beaucoup de cas avec des informats spécifiques

```sas
data tab;
    informat X $1. Y 2. Z $10.;
    input X Y Z $;
    cards;
1 12 A
2 15 A
3 13 B
3  8 ABCDEFGHIJ
run;
```

## `FORMAT`

### Spécification dans `format`

- Limitation de `Z` à 5 caractères pour l'affichage (`format Z $5.`)
- Pas de modification du stockage (cf `ZZ` qui contient bien toute la dernière chaîne)

```sas
data tab;
    informat X $1. Y 2. Z $10.;
    format Z $5.;
    input X $ Y Z $;
    ZZ = Z;
    cards;
1 12 A
2 15 A
3 13 B
3  8 ABCDEFGHIJ
run;
```

## Procédure `FORMAT`

Permet de définir des informats (avec `invalue`) ou des formats (avec `value`) spécifiques

```sas
proc format;
	value $typeX 
		'1' = 'Valeur A'
		'2' = 'Valeur B'
		'3' = 'Autre';
run;
proc print data = tab;
	format X $typeX.;
run;
```

Un autre moyen d'utiliser les formats est de le faire localement dans une procédure `PRINT` comme ci-dessus. Le format ne sera utilisé que pour l'affichage lors de l'exécution de cette procédure.

## Procédure `FORMAT`

### Résultat :

|Obs.| 	X| 	Y| 	Z| 	ZZ|
|-|-|-|-|-|
|1| 	Valeur A| 	12| 	A| 	A|
|2| 	Valeur B| 	15| 	A| 	A|
|3| 	Autre| 	13| 	B| 	B|
|4| 	Autre| 	8| 	ABCDE| 	ABCDEFGHIJ|


## Restitution de données

### Affichage simple - procédure `PRINT`

- options usuelles :
    - `noobs` pour ne pas afficher le numéro des lignes
    - `label` pour afficher le label des variables et non le nom
- paramètres usuels :
    - `var` pour lister les variables à afficher
    - `by` pour faire un affichage pour chaque modalité d'une variable (ou plusieurs)
    - `sum` pour spécifier des variables à sommer (ajout d'une ligne de total)

```sas
proc print data = tab options;
    paramètres;
run;
```

## Sélecteur de variables

Il existe des moyens de sélectionner plusieurs variables ensemble, sans les lister toutes :

- `_ALL_` : sélecteur spécifique pour toutes les variables
- `_NUMERIC_` : sélecteur spécifique pour les variables numériques
- `_CHARACTER_` : sélecteur spécifique pour les variables alpha-numériques
- `v1-vN` : sélecteur spécifique pour les variables nommées `v1`, `v2`, `v3`, ..., `vN` 
- `X--Z` : sélecteur spécifique pour les variables de `X` à `Z` dans la liste des variables de la table


## Restitution de données

### Sauvegarde dans une table à partir d'une autre

Pour récupérer les données d'une table pour les mettre dans une autre, qui sera créée (si existante alors détruite), on utilise une étape `DATA`

```sas
data tab_out;
    set tab_in;
    opérations;
run;
```

## Quelques éléments de langages

### Création de variables 

- Opérateurs usuels : `+`, `-`, `*`, `/`, `()`
- Fonctions diverses :
    - chaînes
    - dates
    - numériques 
- `_N_` : numéro de la ligne courante
- Clause `WHERE` permettant de sélectionner seulement les lignes respectant une condition précise
    - utilisable aussi dans une procédure 

## Quelques éléments de langages

### Traitement conditionnel - `if`

#### Simple 

```sas
if (condition) then opération;
```

#### Complet 

```sas
if (condition) then
do;
    opérations
end;
else
do;
    opérations;
end;
```

## Quelques éléments de langages

### Données manquantes

- Numérique :  `.`
- Alpha-numérique : `""`

### Ecriture ou suppression dans une étape `DATA`

- `delete` permet de supprimer la ligne
- `output` permet d'écrire la ligne dans la table résultat
    - `output tab1` permet de spécifier la table de sortie
- à combiner avec une condition

## Quelques éléments de langages

### Exemple

```sas
data tabA tabB;
    set tab;
    XY = X + Y;
    Z1 = substr(X, 1, 1);
    id = 'no' || _N_;
    where Y > 10;
    if (X = .) then 
        output tabA;
    else
        output tabB;
run; 
```

## Interrogation de données

cf slides 

- [Concepts pour l'interrogation de données](interrogation-concepts.html)
- [Interrogation de données sous SAS](interrogation-sas.html)

## Manipulations supplémentaires

### Transposition de matrice

```sas
proc transpose data = tab;
run;
```

### Autre ?

## Statistiques descriptives

cf slides 

- [Statistiques descriptives sous SAS](stats-desc-sas.html)

## Statistiques exploratoires

cf slides 

- [Statistiques exploratoires sous SAS](stats-explo-sas.html)
