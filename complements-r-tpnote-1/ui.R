library(shiny)
library(shinydashboard)

load("../donnees/ca/ca.RData")

shinyUI(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Evolution mensuelle", tabName = "evol", icon = icon("line-chart"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "evol",
          box(
            selectInput("evol.annee", "Année", c("Toutes", unique(ca_tout$annee)))
          ),
          box(
            width = 6,
            valueBox("test", "sous titre", width = 6),
            tableOutput("testannee"),
            #infoBox("re test", width = 6)
            plotOutput("evol.courbe")
          )
        )
      )
    )
  )
)