library(shiny)
library(ggplot2)

sci = read.table("scimagojr-1996-2014.csv",
                 header = T, sep = ";", quote = '"', 
                 dec = ",", encoding = "UTF-8")

evolb100 <- function(x) {
  return (x / x[1] * 100)
}

shinyServer(
  function(input, output) {
    # Vue globale
    output$glob.evol <- renderPlot({
      agg = aggregate(Documents ~ Year, sci, sum)
      ggplot(agg, aes(Year, Documents)) + geom_line()
    })
    output$glob.top <- renderTable({
      agg = aggregate(Documents ~ Country, sci, sum)
      head(agg[order(agg$Documents, decreasing = TRUE),], 10)
    })
    
    # Vue par pays
    subPays <- reactive({
      subset(sci, Country == input$pays.choix & Year <= 2004)
    })
    output$pays.docs <- renderPlot({
      ggplot(subPays(), aes(Year, evolb100(Documents))) + geom_line()
    })
    output$pays.rang <- renderPlot({
      ggplot(subPays(), aes(Year, Rank)) + 
        geom_line() +
        scale_y_reverse(breaks = 1:max(sci$Rank))
    })
    
    # Vue par année
    subAnnee <- reactive({
      subset(sci, 
             Year == input$annee.choix, 
             c("Country", "Documents", "Citations", "H.index"))
    })
    output$annee.top <- renderTable({
      sub = subAnnee()
      head(sub[order(sub$Documents, decreasing = TRUE),], input$annee.taille)
    })
    
    # Vue par rangs
    output$rangs <- renderPlot({
      sub = subset(sci, Rank <= 10)
      ggplot(sub, aes(Year, Rank, color = Country)) +
        geom_line() +
        scale_y_reverse(breaks = 1:10)
    })
    
  }
)