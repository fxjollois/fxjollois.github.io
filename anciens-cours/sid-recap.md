---
title: Informatique Décisionnelle
author: Récapitulatif
date: DUT STID 2ème année
---

## Démarche décisionnelle

1. Identifier les sources des données
2. Faire un audit sur la qualité des données
3. Modéliser le ou les datamarts
4. Créer le ou les datamarts
5. Etablir le schéma d'intégration des données
6. Déterminer les méta-données du SID
7. Mettre en place les outils de restitution

### Identifier les sources des données

- SIs opérationnels
- Données autres 
	- internes : fichiers texte, tableurs, ...
	- externes : données achetées, via API
- Cartographie des sources et des correspondances

### Faire un audit sur la qualité des données

- Suivi de la qualité important tout au long de la chaîne décisionnelle
- Production des données
- Stockage et format des données
- Récupération des données

### Modéliser le ou les datamarts

- Identifier les processus importants de l'entreprise
- Pour chaque processus
	- Choisir la granularité 
	- Déterminer les dimensions 
	- Déterminer les faits
- Rendre conformes le plus de dimensions possibles

### Créer le ou les datamarts

- Choix logiciels :
	- Système de stockage des données (SGBDR)
	- Système de récupération des données (ETL)
	- Système de restitution des données (reporting)
	- important de réfléchir en même temps pour des raisons de compatibilité
- Scripts de création des tables de faits et de dimensions

### Etablir le schéma d'intégration des données

- Spécification des transformations
	- Calculs, agrégats et jointures
	- Normalisation, décodage, ...
	- Nettoyage, données manquantes
- Détermination du processus d'alimentation
	- Fréquences de mise à jour du SID à partir des sources
	- Contrôles à effectuer
- Utilisation d'outils ETL
	- soit dédiés (Talend, Informatica, ...)
	- soit utilisation de programmes dans des langages tels que SAS, R ou autre

### Déterminer les méta-données du SID

- Schémas 
	- datamarts
	- datawarehouse
- Schémas des sources
- Description du process ETL
- Historiques des chargements, modifications, ...
- Hiérarchies présentes dans les dimensions
- Droits d'accès 

### Mettre en place les outils de restitution

- Point crucial dans le décisionnel
	- Sans reporting, aucun intérêt du SID
- Déterminer les restitutions à produire :
	- Reporting statique
	- Reporting dynamique type OLAP ou autre
	- Planning des productions
- Utilisation d'outils de restitution :
	- soit dédiés (Tableau, QlikView, ...)
	- soit utilisation de programmes dans des langages tels que SAS, R, D3.js ou autre
- Réponses à des demandes spécifiques :
	- Production de fichiers pour des analyses statistiques
	- Production de reporting ad-hoc 

## Sur ADVWORKS

- Etapes 1 et 2 : non abordées
- Modélisation : cf TD
- Création du datamart : à faire
- Schéma d'intégration : à faire (insertion en une fois)
- Méta-données : non abordées ici
- Outils de restitution : cf prochains TP

## Evaluation

- Examen papier
- TP noté
- Projet à faire
