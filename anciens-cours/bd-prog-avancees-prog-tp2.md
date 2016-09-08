---
title: Programmation avancées - TP 2 - Reporting sur un data warehouse
---

Nous allons travailler sur la base de données **CA** (disponible au format `.RData` [ici](https://drive.google.com/folderview?id=0BzA8L2nqa1n5aFRpSklFNnZfdm8&usp=drive_web)). Pour charger les données, vous devez faire :

```r
load("ca.RData")
```

Cette base de données est un (petit) **data warehouse** contenant :

- une table des faits (`ca`) avec :
	- le chiffre d'affaire selon les dimensions
	- les clés de chaque dimension
- trois dimensions :
	- `mois` : date (avec le mois et l'année)
	- `groupe` : avec une hiérarchie (département > groupe > sous-groupe)
	- `provenance`

Pour réaliser une jointure entre la table `ca` et chacune des autres, voici le code à exécuter :

```r
# Avec la dimension groupe
ca_groupe = merge(ca, groupe, 
                  by.x = "groupe_no", 
                  by.y = "no")
# Avec la dimension mois
ca_mois = merge(ca, mois, 
                  by.x = "mois_no", 
                  by.y = "no")
# Avec la dimension provenance
ca_prov = merge(ca, provenance, 
                  by.x = "prov_no", 
                  by.y = "no")
# Avec toutes les dimensions en une seule fois
ca_all = merge(merge(merge(ca, groupe, by.x = "groupe_no", by.y = "no"),
                     mois, by.x = "mois_no", by.y = "no"),
               provenance, by.x = "prov_no", by.y = "no")
```

## A FAIRE 

Nous allons faire un travail sur plusieurs onglets, pour présenter les résultats de l'entreprise sous la forme d'un reporting dynamique à l'aide de Shiny sous RStudio. Voici la demande à réaliser pour chaque onglet :

- **Global** :
	- On veut voir le montant total sur les deux années, et pour chaque année
		- Evolution de deux façon :
		- sur la totalité de la période
		- comparaison des deux années
- **Provenance** :
	- Réprésentation de toutes les provenances sur le même graphique
		- Evolution sur la période ou comparaison des deux années (au choix)
		- Choix de la provenance (toutes par défaut)
- **Groupe** :
	- Réprésentation d'une sélection (département, groupe ou sous-groupe) sur le même graphique
	- Evolution sur la période ou comparaison des deux années (au choix)
	- Choix du département (aucun par défaut)
		- une fois le département choisi, choix du groupe ou tout le département si aucun choix
		- une fois le groupe choisi, choix du sous-groupe ou tout le groupe si aucun choix
	- Comment faire pour permettre une comparaison entre les départements ? entre les groupes d'un département ? entre les sous-groupes d'un groupe ?
- **Analyse approfondie** :
	- Quelles analyses statistiques peut-on réaliser pour analyser les résultats de l'entreprise ?
	- Quelles visualisations peut-on mettre en place dans le même but ?

A vous de développer une application permettant les rendus indiqués, et laissant les choix à l'utilisateur tels qu'indiqués. Si toutefois vous voulez apporter des compléments (graphiques et/ou tableaux supplémentaires, choix différent), vous êtes libre totalement libre de le faire. 

## A SAVOIR

### Exécution de code `R`

Dans le fichier `server.R`, si vous intégrer du code avant la fonction `shinyServer()`, celui-ci sera exécuté dès le lancement de l'application (i.e. dès que vous cliquer sur `runApp` donc). Dans ce cadre, il est par exemple possible d'appeler un fichier `.R` (voire plusieurs) contenant des fonctions utiles pour votre applications. Ensuite, le code intégré au début de la fonction anonyme définie dans `shinyServer()` sera exécuté dès l'ouverture d'une nouvelle session sur votre application (donc à chaque fois que quelqu'un ira sur l'URL de l'application).

Voici un squelette d'un fichier type `server.R` :

```r
library(shiny)

# Code exécuté au démarrage de l'application
# Par exemple une connexion à une base de données ou un chargement de code via la fonction source()

shinyServer(function(input, output, session) {

  # Code exécuté au démarrage d'une nouvelle session d'un utilisateur
  # Par exemple une requête SQL sur une base de données ou un chargement de données brutes

    output$rendu <- renderXXX({
      # Code exécuté au début démarrage puis à chaque modification d'un input si celui-ci est utilisé ici
      # Par exemple une mise à jour d'un graphique selon un choix de paramètre ou autre fait par l'utilisateur
    })

})
```

### Modification du style de l'application

Vous pouvez changer le thème de votre application via un certain nombre de thèmes prédéfinis, mais vous pouvez aussi en récupérer un pour Bootstrap (framework de développement d'application web - utilisé par exemple, après personnalisation j'imagine, sur le site de la NASA, de la FIFA et de VEVO). 

Pour cela, dans le fichier `ui.R`, vous devez intégrer les éléments suivants :
```r
# Chargement de la librairie shinythemes
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("cosmo"), # choix du thème (cosmo ici)
  title = "votre titre",
  ... # le reste
))
```

Pour avoir plus d'informations, vous pouvez aller sur ce [lien](http://rstudio.github.io/shinythemes/). Et une recherche sur la toile devrait vous permettre de récupérer des thèmes pour Bootstrap (gratuits ou payants).