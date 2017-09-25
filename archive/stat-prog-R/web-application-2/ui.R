library(shiny)

shinyUI(fluidPage(
  titlePanel("Web application"),
  sidebarLayout(
      sidebarPanel(),
      mainPanel(
          helpText("Mean values of attributes for each species"),
          tableOutput("tab"),
          helpText("PCA first factorial map for individuals"),
          plotOutput("graph")
      )
  )
))
