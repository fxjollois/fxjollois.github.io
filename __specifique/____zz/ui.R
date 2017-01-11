library(shiny)

shinyUI(fluidPage(
    titlePanel("TP 11"),
    
    tabsetPanel(
        tabPanel(
            "Vue globale",
            plotOutput("glob.docs"),
            tableOutput("glob.top10")
        ),
        
        tabPanel(
            "Vue par pays",
            sidebarLayout(
                sidebarPanel(
                    selectInput("pays.choix", "Pays", choices = unique(sci$Country))
                ),
                mainPanel(
                    plotOutput("pays.evol"),
                    plotOutput("pays.rank")
                )
            )
        ),
        
        tabPanel(
            "Vue par année",
            sidebarLayout(
                sidebarPanel(
                    selectInput("year.choix", "Année", choices = unique(sci$Year)),
                    sliderInput("year.taille", "Taille du top", min = 3, max = 50, value = 10)
                ),
                mainPanel(
                    tableOutput("year.top")
                )
            )
        ),
        
        tabPanel(
            "Vue par rangs",
            plotOutput("rank.evol")
        )
    )
))