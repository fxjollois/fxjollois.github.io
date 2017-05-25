library(shiny)
library(shinydashboard)

sci = read.table("scimagojr-1996-2014.csv", header = T, sep = ";", quote = NULL, dec = ",")

shinyUI(
  dashboardPage(
    dashboardHeader(
      title = "Récapitulatif"
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Production", tabName = "prod", icon = icon("university")),
        menuItem("Evolution du TOP 10", tabName = "rang", icon = icon("random")),
        menuItem("Base 100", tabName = "base100", icon = icon("line-chart")),
        menuItem("Lien Documents/Citations", tabName = "lien", icon = icon("link"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "prod",
          box(title = "TOP pays", footer = "basé sur la production de documents", status = "info", solidHeader = T,
              width = 4,
              radioButtons("prod.taille", "Taille du TOP", choices = c(3, 5, 10, 20), selected = 5, inline = T),
              tableOutput("prod.top")),
          box(title = "Evolution globale", footer = "basée sur la production de documents", status = "info", solidHeader = T,
              width = 8,
              plotOutput("prod.evol"))
        ),
        tabItem(
          tabName = "rang",
          box(title = "Evolution des rangs sur la période", status = "warning", solidHeader = T,
              width = 12,
              plotOutput("rang.plot"))
        ),
        tabItem(
          tabName = "base100",
          box(title = "Evolution de la production des pays", status = "success", footer = "en base 100 en 1996",
              solidHeader = T,
              width = 9,
              plotOutput("base100.plot")),
          box(title = "Choix des pays à représenter", status = "success",
              solidHeader = T,
              width = 3,
              checkboxGroupInput("base100.choix", "Pays", choices = unique(sci$Country), 
                                 selected = c("France", "United States", "United Kingdom")))
        ),
        tabItem(
          tabName = "lien",
          box(title = "Lien entre le nombre de documents et le nombre de citations de documents, par pays",
              status = "danger", solidHeader = T, height = 800,
              width = 12,
              plotOutput("lien.plot"))
        )
      )
    )
  )
)