library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel("TP 11 noté"),
    
    tags$style("table { margin: 0 auto; }"),
    
    tabsetPanel(
      
      # Vue globale
      tabPanel(
        "Global",
        titlePanel("Vue globale des données"),
        plotOutput("glob.evol"),
        tableOutput("glob.top")
      ),
      
      # Vue par pays
      tabPanel(
        "Par pays",
        titlePanel("Détails par pays"),
        sidebarLayout(
          sidebarPanel(
            selectInput("pays.choix", "Pays",
                        choices = unique(sci$Country))
          ),
          mainPanel(
            plotOutput("pays.docs"),
            plotOutput("pays.rang")
          )
        )
      ),
      
      # Vue par annÃ©e
      tabPanel(
        "Par année",
        titlePanel("Détails par année"),
        sidebarLayout(
          sidebarPanel(
            selectInput("annee.choix", "Année",
                        choices = unique(sci$Year)),
            sliderInput("annee.taille", "Taille du top",
                        min = 3, max = 25, value = 10, step = 1)
          ),
          mainPanel(
            tableOutput("annee.top")
          )
        )
      ),
      
      # Vue par rangs (bonus)
      tabPanel(
        "Rangs",
        titlePanel("Evolution du top 10"),
        plotOutput("rangs")
      )
    )
  )
)