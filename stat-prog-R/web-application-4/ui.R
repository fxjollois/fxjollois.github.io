library(shiny)

shinyUI(fluidPage(
  titlePanel("Web application"),
  sidebarLayout(
      sidebarPanel(
          helpText("Choose the statistic you want to compute"),
          selectInput("stat", "Statistic", c("mean", "median", "min", "max")),
          helpText("Choose the PCA dimension to plot"),
          radioButtons("dimX", "X", choices = 0),
          radioButtons("dimY", "Y", choices = 0)
      ),
      mainPanel(
          helpText("Mean values of attributes for each species"),
          tableOutput("tab"),
          helpText("PCA first factorial map for individuals"),
          plotOutput("graph")
      )
  )
))
