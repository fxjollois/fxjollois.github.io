library(shiny)

shinyUI(fluidPage(
    titlePanel("Première application"),
    
    tabsetPanel(
        tabPanel("Panel1",
                 titlePanel("titre Panel 1"),
                 
                 # Travail fait précédemment
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("choix", "Abscisse", c("wt", "hp", "disp")),
                         textOutput("resumeMpg"),
                         textOutput("resumeVar"),
                         tableOutput("tableau")
                     ),
                     mainPanel(
                         plotOutput("nuage")
                     )
                 )
        ),
        tabPanel("Panel2",
                 titlePanel("titre Panel 2")
                 # idem
        )
        # autres onglets possibles
    )
))