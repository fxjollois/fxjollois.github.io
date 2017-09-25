library(shiny)
library(shinydashboard)
library(ggplot2)

shinyUI(
    dashboardPage(
        dashboardHeader(
            title = "TP 6"
        ),
        dashboardSidebar(
            selectInput(
                "ville",
                "Choix de la ville",
                c("Toutes les villes", unique(txhousing$city))
            ),
            sidebarMenu(
                menuItem("Résumé", tabName = "resume", icon = icon("dashboard")),
                menuItem("TOP", tabName = "top", icon = icon("thumbs-up")),
                menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(
                    "resume",
                    tabBox(
                        title = "Volume des ventes",
                        tabPanel("Courbe", plotOutput("conso")),
                        tabPanel("Tableau", tableOutput("consotab")),
                        width = 8
                    ),
                    uiOutput("progression"),
                    uiOutput("volume"),
                    tabBox(
                        title = "Informations",
                        width = 4,
                        tabPanel("Nombre", "Nombre de ventes", uiOutput("nombre")),
                        tabPanel("Prix médian", "Prix médian", uiOutput("prixmed"))
                    )
                ),
                tabItem(
                    "top",
                    box(
                        title = "Villes",
                        width = 4,
                        solidHeader = T,
                        status = "info",
                        radioButtons("nbvilles", "Taille du TOP", c(3, 5, 10), inline = T),
                        tableOutput("topvilles")
                    ),
                    box(
                        title = "Années",
                        width = 4,
                        solidHeader = T,
                        status = "info",
                        radioButtons("nbannees", "Taille du TOP", c(3, 5, 10), inline = T),
                        tableOutput("topannees")
                    ),
                    box(
                        title = "Mois",
                        width = 4,
                        solidHeader = T,
                        status = "info",
                        radioButtons("nbmois", "Taille du TOP", c(3, 5, 10), inline = T),
                        tableOutput("topmois")
                    )
                )
            )
        ),
        title = "TP 6",
        skin = "yellow"
    )
)