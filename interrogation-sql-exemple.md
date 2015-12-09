---
title: Exemple de requêtes - SQL
---

Cette page vous permet de voir en application l'interrogation de données à l'aide du
langage *SQL*

## Quelques exemples pour (peut-être ?) mieux comprendre

On va travailler avec les tables suivantes :

```
CLIENT(NumClt, Nom, Prenom, Adresse)
TVA(NumTx,Valeur)
PRODUIT(NumPrd, Designation, PrixHT, QteStock, #TxTVA)
FACTURE(NumFac, #NumClt, Total)
ACHAT(#NumFac, #NumPrd, Qte)
```

Ici, chaque table a une clé primaire simple, qui est le premier attribut (par exemple,
`NumClt`pour la table `CLIENT`). Les `#` permettent d'indiquer les clés externes 
(ou références à une autre table).

Dans la suite, vous verrez des questions qu'on se pose et comment on peut les résoudre 
à l'aide de SQL

### Nom et prénom des clients.

Ici, nous ne devons faire qu'une **projection** (sélection des colonnes à afficher).

```
SELECT   Nom, Prenom
    FROM CLIENT;
```
		
### Produits de moins de 10 euros HT strictement.

La, c'est l'inversion, c'est une **restriction** (sélection des lignes à afficher). 
Le `*` permet d'afficher tous les attributs de la table `PRODUIT`.

```sql
SELECT    *
    FROM  PRODUIT
    WHERE PrixHT > 10;
```

### Numéro de produit, désignation et prix TTC de chaque produit.

Les informations du produit (numéro, désignation et prix hors taxe) sont présentes
dans la table `PRODUIT`. Mais pour calculer le prix TTC, nous devons aussi utiliser
la table `TVA` pour avoir la valeur du taux à appliquer à chaque produit. Donc nous
devons faire une **jointure**. Comme vous allez le voir, il y a plusieurs façons de
réaliser celle-ci.

```sql
-- Première possibilité : produit cartésien + restriction 
-- On renomme le résultat du calcul
SELECT    NumPrd, Designation, 
          PrixHT * (1 + Valeur / 100) AS PrixTTC
    FROM  PRODUIT, TVA
    WHERE PRODUIT.NumTx = TVA.NumTx;
	
-- Deuxième possibilité : introduction des alias
SELECT    NumPrd, Designation, 
          PrixHT * (1 + Valeur / 100) AS PrixTTC
    FROM  PRODUIT P, TVA T
    WHERE P.NumTx = T.NumTx;
	
-- Troisième possibilité : avec l'opérateur INNER JOIN
SELECT   NumPrd, Designation, 
         PrixHT * (1 + Valeur / 100) AS PrixTTC
    FROM PRODUIT P 
        INNER JOIN TVA T ON P.NumTx = T.NumTx;
	
-- Quatrième possibilité : avec l'opérateur NATURAL JOIN (possible ici car
-- l'attribut NumTx est présent dans les deux tables (avec le même nom)
SELECT    NumPrd, Designation, 
          PrixHT * (1 + Valeur / 100) AS PrixTTC
    FROM  PRODUIT NATURAL JOIN TVA;
```

### Clients (numéro, nom et prénom) 

#### Ayant au moins 1 facture à leur nom

Ici, nous devons juste nous assurer que le client est dans la liste des clients
ayant fait un achat, donc présent dans la table `FACTURE`.

```sql
-- Première possibilité : avec une jointure
SELECT    C.NumClt, Nom, Prenom
    FROM  CLIENT C, FACTURE F
    WHERE C.NumClt = F.NumClt;
-- ou
SELECT   C.NumClt, Nom, Prenom
    FROM CLIENT C NATURAL JOIN FACTURE;
	
-- Deuxième possibilité : avec l'opérateur IN
SELECT    NumClt, Nom, Prenom
    FROM  CLIENT
    WHERE NumClt IN (SELECT NumClt FROM FACTURE);

-- Troisème possibilité : avec l'opérateur EXISTS
SELECT    NumClt, Nom, Prenom
    FROM  CLIENT C
    WHERE EXISTS 
        (SELECT   NumClt 
            FROM  FACTURE F 
            WHERE F.NumClt = C.NumClt);
```

#### Ayant au moins 5 factures à leur nom

La, nous devons compter le nombre de factures (et donc d'achats) pour chaque client
afin de déterminer lesquels ont 5 (ou plus) factures à leur nom. Nous allons donc
combiner un **calcul d'agrégat** avec une restriction sur ce calcul.

```sql
-- Première possibilité : jointure et calcul d'agrégat en une fois
SELECT       C.NumClt, Nom, Prenom
    FROM     CLIENT C, FACTURE F
    WHERE    C.NumClt = F.NumClt
    GROUP BY C.NumClt, Nom, Prenom
    HAVING   COUNT(*) >= 5;
		
-- Deuxième possibilité : calcul d'agrégat dans une sous-requête
SELECT    NumClt, Nom, Prenom
    FROM  CLIENT
    WHERE NumClt IN 
	   (SELECT      NumClt 
	       FROM     FACTURE 
	       GROUP BY NumClt 
	       HAVING   COUNT(*) > 5);
```

#### N'ayant aucune facture à leur nom (cas possible : un client a commencé puis annulé sa commande)

Quand nous faisons une jointure, les clients ayant une facture sont obligatoirement
dans le résultat. Et nous ne pouvons pas faire de `HAVING COUNT(*) = 0` car cela
n'a aucun sens (s'il y a la valeur, c'est qu'elle est au moins sur une ligne). Il
faut donc utiliser le `NOT IN` ou le `NOT EXISTS`. On peut aussi utiliser l'opérateur
`LEFT JOIN` (par exemple) et tester le numéro de facture est `NULL`.

```sql
-- Première possibilité : avec l'opérateur NOT IN
SELECT    NumClt, Nom, Prenom
    FROM  CLIENT
    WHERE NumClt NOT IN 
	   (SELECT NumClt FROM FACTURE);

-- Deuxième possibilité : avec l'opérateur NOT EXISTS
SELECT    NumClt, Nom, Prenom
    FROM  CLIENT C
    WHERE NOT EXISTS 
	   (SELECT   NumClt 
	       FROM  FACTURE F 
	       WHERE F.NumClt = C.NumClt);
	
-- Troisième possibilité : avec un LEFT JOIN et un test = NULL (à tester si ca
-- fonctionne réellement, mais il n'y a pas de raison que ce soit le contraire)
SELECT    C.NumClt, Nom, Prenom
    FROM  CLIENT C 
	   LEFT JOIN FACTURE F ON C.NumClt = F.NumClt
    WHERE NumFac IS NULL;
```
	
### Produits achetés (avec la quantité totale sur tous les achats) par le client 28.

Dans ce cas, nous avons besoin de quatre tables :

- `CLIENT` et `PRODUIT` naturellement,
- `FACTURE` et `ACHATS` car il nous faut relier les deux tables précédentes.

Voici une proposition de requête. Comme nous pourrez vous en apercevoir, il y a
plusieurs autres possibilités (sur les jointures, sur les calculs d'agrégats, ...)

```sql
SELECT       P.NumPrd, Designation, 
             SUM(Qte) AS QteTotal
    FROM     CLIENT C, PRODUIT P, FACTURE F, ACHATS A
    WHERE    C.NumClt = F.NumClt
    AND      F.NumFac = A.NumFac
    AND      A.NumPrd = P.NumPrd
    AND      C.NumClt = 28
    GROUP BY P.NumPrd, Designation;
```

### Récupération des informations concernant la facture 121

Pour éditer une facture, nous avons trois étapes :

1. Récupérer les informations du client (numéro, nom, prénom et adresse)
2. Récupérer la liste des produits qui sont sur la facture (numéro de produit,
désignation, prix HT, prix TTC, quantité, taux TVA)
3. Calculer le montant total de la facture (celui-ci n'étant pas encore calculé)

#### Informations du client

Nous choisissons ici de le faire avec l'opérateur `IN`.

```sql
SELECT    NumClt, Nom, Prenom, Adresse
    FROM  CLIENT
    WHERE NumClt IN 
	   (SELECT NumClt FROM FACTURE WHERE NumFac = 121);
```

#### Liste des produits achetés  

Idem pour sélectionner les produits de la facture 121, mais il faut tout de même
faire une jointure pour avoir le taux de TVA à appliquer.

```sql
SELECT    NumPrd, Designation, 
          PrixHT * (1 + Valeur / 100) AS PrixTTC
    FROM  PRODUIT NATURAL JOIN TVA
    WHERE NumPrd IN 
	   (SELECT NumPrd FROM ACHATS WHERE NumFac = 121);
```

#### Montant total de la facture.

Il faut reprendre la requête ci-dessus pour la modifier légèrement pour faire le 
calcul du total (avec `SUM`).

```sql
SELECT    SUM(PrixHT * (1 + Valeur / 100)) AS Total
    FROM  PRODUIT NATURAL JOIN TVA
    WHERE NumPrd IN 
	   (SELECT NumPrd FROM ACHATS WHERE NumFac = 121);
```

