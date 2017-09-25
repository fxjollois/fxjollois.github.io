library(shiny)
library(shinydashboard)
library(ggplot2)

load("../donnees/ca/ca.RData")

shinyServer(
  function(input, output) {
    output$evol.courbe <- renderPlot({
      # Calcul du ca total par mois
      df = aggregate(ca ~ mois_numero, ca_tout, sum)
      
      # Affichage de l'évolution
      ggplot(df, aes(mois_numero, ca)) +
        geom_line() +
        scale_x_continuous(breaks = 1:12)
    })
    
    output$testannee <- renderTable({
      aggregate(ca ~ annee, ca_tout, sum)
    })
  }
)