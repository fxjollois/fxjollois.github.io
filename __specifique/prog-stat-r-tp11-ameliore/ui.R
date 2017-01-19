library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "TP 11 noté"),
  dashboardSidebar(
    sidebarMenu(
      
      # Vue globale
      menuItem(
        "Global",
        tabName = "glob",
        icon = icon("line-chart")
      ),
      
      # Vue par pays
      menuItem(
        "Par pays",
        tabName = "pays",
        icon = icon("globe")
      ),
      
      # Vue par année
      menuItem(
        "Par année",
        tabName = "annee",
        icon = icon("calendar")
      ),
      
      # Vue par rangs (bonus)
      menuItem(
        "Rangs",
        tabName = "rang",
        icon = icon("sort-amount-desc")
      )
    )    
  ),
  dashboardBody(
    tabItems(
      
      # Vue globale
      tabItem(
        tabName = "glob",
        titlePanel("Vue globale des données"),
        box(
          title = "Evolution de la production scientifique", 
          status = "primary", width = 12, solidHeader = TRUE,
          plotOutput("glob.evol")
        ),
        box(
          title = "TOP 10", 
          status = "primary", width = 12, solidHeader = TRUE,
          tags$style("table { margin: 0 auto; }"),
          tableOutput("glob.top")
        )
      ),
      
      # Vue par pays
      tabItem(
        tabName = "pays",
        titlePanel("Détails par pays"),
        fluidRow(
          box(
            title = "Choix", 
            status = "warning", width = 6, solidHeader = TRUE,
            selectInput("pays.choix", "Pays",
                        choices = sort(unique(sci$Country)),
                        selected = "France")
          ),
          infoBoxOutput("pays.info")
        ),
        fluidRow(
          tabBox(
            title = "Informations", 
            width = 12, 
            tabPanel("Documents", 
                     plotOutput("pays.docs"),
                     helpText("Evolution en base 100 en 1996")),
            tabPanel("Rang", plotOutput("pays.rang"))
          )
        )
      ),
      
      # Vue par année
      tabItem(
        tabName = "annee",
        titlePanel("Détails par année"),
        fluidRow(
          box(
            title = "Choix de l'année", 
            status = "warning", width = 6, solidHeader = TRUE,
            selectInput("annee.choix", NULL,
                        choices = unique(sci$Year))
          ),
          box(
            title = "Paramètres", 
            status = "warning", width = 6, solidHeader = TRUE,
            sliderInput("annee.taille", "Taille du TOP",
                        min = 3, max = 25, value = 10, step = 1),
            radioButtons("annee.crit", "Critère", 
                         choices = c("Documents", "Citations", "H.index"))
          )
        ),
        fluidRow(
          box(
            title = "TOP", 
            status = "primary", width = 12, solidHeader = TRUE,
            tableOutput("annee.top")
          )
        )
      ),
      
      # Vue par rangs (bonus)
      tabItem(
        tabName = "rang",
        titlePanel("Evolution du top 10"),
        box(
          title = "Evolution", 
          status = "primary", width = 12, solidHeader = TRUE,
          plotOutput("rangs")
        )
      )
    )
  )    
)