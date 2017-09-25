---
title: "Interrogation de données avec SAS"
author: "FX Jollois"
date: "... ou comment faire du SQL sans SQL dans SAS"
output: ioslides_presentation
---

## Introduction

But de cette présentation :

> Présenter une comparaison (**non exhaustive**) entre le langage **SQL** et le langage [**SAS**](http://www.sas.com) pour l'**interrogation** d'une base de données relationnelles

Plan :

- Rappel (très rapide) sur les concepts de l'algèbre relationnelle
- Comment faire du SQL sous SAS ?
- Comment faire autrement sous SAS ?

Pré-requis :

- Connaissance du SQL
- Connaissance du langage SAS

## Interrogation de données

Ensemble des opérations de l'algèbre relationnelle utilisée pour obtenir des informations à partir d'une base de données relationnelles :

- Restriction
- Projection
- Calcul et fonction
- Agrégat
- Opérations ensemblistes
- Jointures

Les données sont disponibles [ici](http://fxjollois.github.io/accesdonnees.html)

## SQL sous SAS

La `PROC SQL` sous SAS permet d'exécuter toutes les requêtes SQL :

- *DDL* : définition (`CREATE`, `ALTER`, `DROP`)
- *DML* : manipulation (`INSERT`, `UPDATE`, `DELETE`)
- *DCL* : contrôle (`COMMIT`, `ROLLBACK`, ...)
- *DQL* : requêtage (`SELECT`)

La syntaxe est la suivante :

```sas
PROC SQL;
  requête(s);
QUIT;
```

## Autrement sous SAS

Le langage SAS contient deux types d'*opérations* :

- Etape `DATA` : 
    - opération permettant la manipulation des différentes tables, 
    - plutôt dédiée à des opérations ligne par ligne 
    - `SET` permet l'importation des données d'une table existante

```sas
DATA nouvelle_table;
  SET nom_table;
  commande(s);
RUN;
```

## Autrement sous SAS (suite)

- Procédure `PROC` : 
    - opération permettant la réalisation de calculs (statistique, modélisation, et beaucoup d'autres)
    - plutôt dédiée à des opérations sur les colonnes
    - certaines procédures nécessitent un `QUIT` à la fin

```sas
PROC nom_procedure OPTION(S);
  OPTION(S);
RUN;
```

## A noter

Les étapes `DATA` ont pour but de créer une nouvelle table, sans affichage, alors que les procédures `PROC` ont le comportement inverse (affichage sans nécessairement de stockage du résultat). Pour afficher une table sous SAS, on utilise le code suivant :

```sas
PROC PRINT DATA=nom_table OPTION(S);
  OPTION(S);
RUN;
```

## Restriction

- 2 possibilités
    - `WHERE` ou `IF` dans une étape `DATA`
    - `WHERE` dans une `PROC` (avec deux façons de le faire)
- Combinaison avec `&` ou `AND`, `|` ou `OR`, `!` ou `NOT`, et `()

```sas
DATA nouvelle_table;
  SET nom_table;
  WHERE | IF condition(s);
RUN;

PROC PRINT DATA = nom_table;
  WHERE condition(s);
RUN;

PROC PRINT DATA = nom_table (WHERE= (condition(s)));
RUN;
```

## Projection

- Dans une étape `DATA` :
    - clause `KEEP` : liste des colonnes à garder
    - clause `DROP` : liste des colonnes à supprimer
- Renommage avec la clause `RENAME`
- Suppression des doublons avec la `PROC SORT` et l'option `NODUPKEY`

```sas
DATA nouvelle_table;
  SET nom_table;
  KEEP nom_colonne(s);
  RENAME nom_colonne = nouveau_nom;
RUN;
PROC SORT DATA = nouvelle_table NODUPKEY;
  BY nom_colonne(s);      *nouveau nom ici;
RUN;
```

## Calcul et fonction

- Définition des calculs dans un `DATA`
- Opérateurs usuels : `+ - / * ()`
- Beaucoup d'autres opérateurs et fonctions disponibles
- Ajout de colonnes à la table importée dans le `SET`

```sas
DATA nouvelle_table;
  SET nom_table;
  nom1 = expression;
  nom2 = fonction(colonne, paramètre(s));
RUN;
```

## Agrégat

- 3 possibilités :
    - Utilisation de la `PROC SUMMARY` ou de la `PROC MEANS`
        - Définition des agrégats à faire et des statistiques à calculer
        - Affichage des résultats (par défaut pour `MEANS` et possible pour `SUMMARY`)
        - Récupération du résultat dans une table (par défaut oour `SUMMARY` et possible pour `MEANS`)
    - Utilisation d'un `DATA`
        - avec un `RETAIN` (implicite ou explicite)
        - Création d'une nouvelle table
        - Calcul à faire *à la main* (i.e. Moyenne = Somme / Nombre)

## Agrégat - `MEANS` ou `SUMMARY`

```sas
PROC MEANS DATA = nom_table liste_stats;
  VAR liste_colonnes_calculs;
  CLASS liste_colonnes_groupes;
RUN;

PROC SUMMARY DATA = nom_table;
  VAR liste_colonnes_calculs;
  CLASS liste_colonnes_groupes;
  OUTPUT OUT = nouvelle_table stat = nom_stat ...;
RUN;
```

*NB* : si on veut faire différents calculs pour différentes variables, on doit préciser `stat(colonne) = nom_stat` pour chaque calcul voulu.

## Agrégat - `DATA`

```sas
DATA nouvelle_table;
  RETAIN decompte;
  SET nom_table;
  BY variable_groupe;       *tri à faire avant;
  
  IF first.variable_groupe THEN decompte = 0;
  
  decompte = decompte + 1;
  
  IF last.variable_groupe THEN OUTPUT;

  KEEP variable_groupe decompte;
RUN;
```

*NB* : ce type de code permet de réaliser un calcul d'agrégat complexe. 

## Opérations ensemblistes

- Utilisation d'une étape `DATA` avec la clause `MERGE`
    - Avec la clause `BY _ALL_`
    - Option `(IN = var)` dans l'appel des tables
- Condition sur les variables créés :
    - Union : `A | B` (inutile)
    - Intersection : `A & B`
    - Différence : `A & !B`

```sas
DATA nouvelle_table;
  MERGE nom_tableA (IN = A) nom_tableB (IN = B);
  BY _ALL_;
  IF (condition);
RUN;
```

## Jointures

- Utilisation d'une étape `DATA` avec la clause `MERGE`
    - Variables de jointures dans le `BY`
    - Option `(IN = var)` si jointure externe
    - Avec condition sur les variables créées
        - Interne : `A & B`
        - Externe gauche : `A`
        - Externe droite : `B`
        - Externe complète : `A | B` (inutile)
- Tri des tables à faire sur ces variables obligatoirement
    - avec `PROC SORT`

## Jointures (suite)

```sas
PROC SORT DATA = nom_tableA;
  BY variables_jointures;
PROC SORT DATA = nom_tableB;
  BY variables_jointures;
DATA nouvelle_table;
  MERGE nom_tableA (IN = A) nom_tableB (IN = B);
  BY variables_jointures;
  IF (condition);
RUN;
```

*NB* : 

- Avec les conditions `A & !B`, `!A & B` ou `A+B=1`, il est possible d'avoir des résultats non obtenable avec SQL (lignes sans correspondances)
- `RUN` implicite pour SAS au début d'un `DATA` ou d'une `PROC`
- Produit cartésien impossible avec le `MERGE`
