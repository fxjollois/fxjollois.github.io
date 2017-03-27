library(shiny)

source("module1.R")

shinyUI(fluidPage(
  titlePanel("Première application"),
  helpText("Nous allons utiliser ici une programme en module"),
  
  tabsetPanel(
    tabPanel(
      "Panel 1",
      titlePanel("Travail fait en TP"),
      
      # Travail fait précédemment
      sidebarLayout(
        sidebarPanel(
          module1Input("choix"),
          textOutput("resumeMpg"),
          textOutput("resumeVar"),
          textOutput("corMpgVar")
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("avec plot", plotOutput("nuage1")),
            tabPanel("avec ggplot (1ere version)", plotOutput("nuage2")),
            tabPanel("avec ggplot (2eme version)", plotOutput("nuage3"))
          ),
          tableOutput("tableau")
        )
      )
    ),
    tabPanel(
      "Panel 2",
      titlePanel("Analyse de variables qualitatives"),
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "ql.choix", "Variable",
            c("cyl", "vs", "am", "gear", "carb")
          )
        ),
        mainPanel(
          plotOutput("ql.bar"),
          plotOutput("ql.pie"),
          tableOutput("ql.tab")
        )
      )
      
      # autre chose
    ),
    tabPanel(
      "Panel 3",
      titlePanel("Croisement de variables qualitatives"),
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "qlql.choix1", "Variable 1",
            c("cyl", "vs", "am", "gear", "carb")
          ),
          selectInput(
            "qlql.choix2", "Variable 2",
            c("cyl", "vs", "am", "gear", "carb")
          )
        ),
        mainPanel(
          plotOutput("qlql.bar"),
          tableOutput("qlql.tab")
        )
      )
    )
  )
))