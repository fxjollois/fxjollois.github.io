---
title: Programmation avancées - TP 1 - Introduction à Shiny
---

Le package `shiny` permet de développer très facilement des applications web à partir de `R`. Grâce à cette librairie, et d'autres librairies `R` dédiés à la réalisation de graphique, il est ainsi possible de générer des tableaux de bord, introduisant même des méthodes statistiques approfondies.

Pour cela, nous allons utiliser le jeu de données `mtcars` présent sous R.

## Première application

Une application `shiny` nécessite deux fichiers nommés spécifiquement au minimum :

- `server.R` : définissant les opérations à réaliser lors de la création de la page et lors des différentes interactions de l'utilisateur ;
- `ui.R` : définissant l'interface utilisateur (**UI** signifiant *User Interface*), avec les différentes parties telles que le titre, les différentes boutons ou sélecteurs et les graphiques et/ou textes.

### Page simple avec un titre

Dans un nouveau répertoire, créer les deux fichiers `R` avec le contenu suivant :

#### `server.R` :
```r
library(shiny)

shinyServer(function(input, output) {})
```

#### `ui.R` :
```r
library(shiny)

shinyUI(fluidPage(
  titlePanel("Première application")
))
```

Une fois ces fichiers enregistrés, pour voir le résultat, vous pouvez soit cliquer sur `Run App` en haut à droite de l'éditeur de texte, soit exécuter la commande `runApp()` dans la console. Vous devriez voir une fenêtre avec juste le titre qui s'affiche. 

### Ajout d'un graphique

On va ajouter un nuage de points entre la variable `mpg` (consommation en Miles/US Gallon) et `wt` (poids) du jeu de données `mtcars`. Il faut donc modifier les deux fichiers :

#### `server.R` :
```r
library(shiny)

shinyServer(function(input, output) {
  output$nuage <- renderPlot({
    plot(mpg ~ wt, data = mtcars, main = "Consommation en fonction du poids")
  })
})
```

#### `ui.R` :
```r
library(shiny)

shinyUI(fluidPage(
  titlePanel("Première application"),
  plotOutput("nuage")
))
```

Que faut-il noter ?

- On ajoute dans l'interface une zone, nommée `nuage` qui sera une sortie graphique (`plotOutput`) ;
- On définit le contenu de cette zone (`output$nuage`) comme étant un rendu graphique (`renderPlot`), dans lequel on met du code `R` permettant de faire un graphique. Le code ici présent est tou ) fait classique.

### Ajout d'un bouton d'action

On ajoute ici un bouton permettant de sélectionner la variable de l'axe $x$ (`wt` dans notre exemple). Nous allons laisser à l'utilisateur le choix entre `wt`, `hp` (puissance) et `disp` (cylindrée). Il faut donc modifier les deux fichiers :

#### `server.R` :
```r
library(shiny)

shinyServer(function(input, output) {
  output$nuage <- renderPlot({
    plot(mtcars$mpg ~ mtcars[,input$choix], main = "Consommation")
  })
})
```

#### `ui.R` :
```r
library(shiny)

shinyUI(fluidPage(
  titlePanel("Première application"),
  selectInput("choix", "Abscisse", c("wt", "hp", "disp")),
  plotOutput("nuage")
))
```

Que faut-il noter ?

- Dans l'interface, on ajoute une zone de sélection (`selectInput`) nommée `choix`, avec un titre (`Abscisse`) et donc une liste de choix (`c("wt", "hp", "disp")`) ;
- Côté serveur, on redéfinit le graphique pour qu'il s'adapte automatiquement à la sélection de l'utilisateur. Pour cela, on se base sur le fait que la sélection (`input$choix`) sera une chaîne de caractère parmi les trois proposées. La commande `mtcars[,input$choix]` renverra donc bien le vecteur de la colonne choisie par l'utilisateur.

### Ajout d'une zone de texte

On souhaite ajouter maintenant le calcul automatique de la moyenne des deux variables sélectionnées. Pour cela, nous allons modifier les fichiers comme suit :

#### `server.R` :
```r
library(shiny)

shinyServer(function(input, output) {
  output$nuage <- renderPlot({
    plot(mtcars$mpg ~ mtcars[,input$choix], main = "Consommation")
  })
  
  output$resumeMpg <- renderText({
    paste("Moyenne mpg :", mean(mtcars$mpg, na.rm = T))
  })
  output$resumeVar <- renderText({
    paste("Moyenne", input$choix, ":", mean(mtcars[,input$choix], na.rm = T))
  })
})
```

#### `ui.R` :
```r
library(shiny)

shinyUI(fluidPage(
  titlePanel("Première application"),
  selectInput("choix", "Abscisse", c("wt", "hp", "disp")),
  plotOutput("nuage"),
  textOutput("resumeMpg"),
  textOutput("resumeVar")
))
```

Que faut-il noter ?

- Côté utilisateur, on a ajouter deux zones de texte (`textOutput`), nommées `resumeMpg` pour la moyenne de la consommation, et `resumeVar` pour la moyenne de l'autre variable ;
- Dans le serveur, on définit le texte qu'on affiche comme une concaténation de chaîne avec le calcul de la moyenne de la variable.

### Un peu de mise en page

Il est prévu une mise en page en deux zones :

- une zone servant à faire des sélections ou des actions ;
- une zone principale, où le rendu sera dépendant des choix faits.

On ne modifie ici que le fichier d'interface.

#### `ui.R`
```r
library(shiny)

shinyUI(fluidPage(
  titlePanel("Première application"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("choix", "Abscisse", c("wt", "hp", "disp")),
      textOutput("resumeMpg"),
      textOutput("resumeVar")
    ),
    mainPanel(
      plotOutput("nuage")
    )
  )
))
```

Que faut-il noter ?

- La commande `sidebarLayout` permet donc de définir cette séparation en deux parties (environ 1/3-2/3). Elle doit contenir deux choses :
  - la commande `sidebarPanel` qui contient les éléments qui seront donc à gauche par défaut
  - la commande `mainPanel` qui sera celle à droite et prenant le plus de place
- On peut mettre la partie `sidebarPanel`  à droite avec `sidebarLayout(position = "right", ..., ...)`

## A FAIRE

Dans la partie interface, il est possible de créer un système d'onglet avec :
```r
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Panel1",
      titlePanel("titre Panel 1")
      # autres commandes UI (par exemple sidebarLayout)
    ),
    tabPanel("Panel2",
      titlePanel("titre Panel 2")
      # idem
    )
    # autres onglets possibles
  )
))
```

### Premier onglet

Le travail fait précédemment (ce qu'il y a dans le `sidebarLayout()`).

### Deuxième onglet

On veut compléter notre application avec une partie pour l'analyse de variables qualitatives. Vous devez donc faire en sorte que :

- l'utilisateur puisse choisir une variable parmi `cyl`, `vs`, `am`, `gear` et `carb`
- le système affiche le diagramme en barres et le diagramme circulaire, ainsi qu'un tableau des occurences et des fréquences des modalités

### Troisième onglet

On veut croiser les variables qualitatives :

- l'utilisateur doit donc choisir deux variables parmi celles citées (on ne gère pas la possibilité que l'utilisateur choisisse la même deux fois pour le moment)
- le système affiche un diagramme en barres empilées ainsi que le tableau de contingence, avec les sommes en lignes et en colonnes
