---
title: Logiciels stats - SAS - TP6
---

## Données

Nou allons travailler sur les données présentes dans les fichiers suivants (présents dans le répertoire `/courses/dee4fb65ba27fe300/CA/`), avec un petit explicatif de certaines variables (les autres pouvant se déduire assez facilement) :

- `ca.csv` :
	- `ca` : chiffre d'affaires des ventes correspondant au mois, au groupe et à la provenance indiquée
- `groupe.csv` :
	- `departement` > `groupe` > `sous-groupe` (un sous-groupe fait partie d'un groupe, qui fait lui-même partie d'un département)
- `mois.csv`
- `provenance.csv` :
	- `provenance` de la vente

On a donc dans ces tables les chiffres d'affaires (ou CA) des ventes de janvier 2003 à décembre 2004, pour des provenances diverses et pour des groupes différents (plus spécifiquement, on va jusqu'au détail sous-groupe, mais qu'on peut regrouper par groupe, puis par département).

Voici les correspondances entre les attributs de la table `ca` et les attributs des autres tables pour les jointures :

| `ca` | Table | Attribut de jointure dans la table |
|-|-|-|
| `groupe_no` | `groupe` | `no`|
| `mois_no` | `mois` | `no` |
| `prov_no` | `provenance` | `no`|


## Travail à faire

### Importation (2 points)

Importer les données dans quatre tables - une table par fichier donc.

**Bonus** : écrire une macro simplifiant cette étape d'importation (*1 point*)

### Manipulation de données (10 points)

Traiter les demandes suivantes en **créant les tables** `demandeX` (avec `X` étant le numéro de la demande), en créant toutes les tables intermédiaires qu'ils vous semblent nécessaires :

1. Somme, Moyenne, médiane, minimum, maximum, premier et troisième quartile du CA (au global donc) - *1 point*
2. Somme des CA par provenance - *1 point*
3. Somme des CA par département et par groupe - *1 point*
4. Somme des CA par provenance, pour 2004 uniquement - *2 point*
5. Somme des CA par département, pour 2003 d'un côté et pour 2004 de l'autre (2 colonnes à avoir donc) - *2 points*
	- Table résultante avec 
		- en ligne : les départements
		- en colonne : somme CA 2003 et somme CA 2004
6. Différence des sommes de CA entre 2003 et 2004, pour chaque mois et pour chaque provenance - *3 points*
	- Table résultante avec 
		- en ligne : les provenance
		- en colonne : les mois
		- une cellule : différence entre 2003 et 2004 pour un mois et une provenance précise

### Statistiques descriptives (5 points)

Traiter les demandes suivantes en **créant les graphiques** ayant pour titre `graphiqueX` (avec `X` étant le numéro du graphique), en créant toutes les tables intermédiaires qu'ils vous semblent nécessaires :

1. Evolution par mois de la somme des CA pour 2003 et pour 2004, globalement - *1 point*
2. Idem, mais pour chaque département - *1.5 point*
3. Carte de couleur (*heatmap*) pour les mois de 2004 (en abcisse), et pour les provenances (en ordonnée), représentant les sommes de CA dans chaque cellule - *1.5 points*

### Statistiques exploratoires (3 points)

Sur la table `demande6` :

1. Faire une ACP et une AFC, et produire les premiers plans factoriel de chaque analyse - *1.5 point*
2. Faire une CAH sur les provenances et afficher les graphiques permettant de choisir du nombre de classes - *1.5 point*


## Rendu

Vous devez suivre les indications suivantes :

- Envoyer votre code SAS par courriel : 
	- adresse : `francois - xavier . jollois [@] parisdescartes . fr`
	- supprimer les espaces et les `[]`
- Commenter votre code SAS pour décrire les différentes étapes effectuées
- Travail autonome : en cas de copie flagrante, les notes seront divisées par autant de TP identiques
- Respecter **très strictement** les consignes

