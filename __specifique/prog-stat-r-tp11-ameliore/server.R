library(shiny)
library(ggplot2)
library(RColorBrewer)

sci = read.table("scimagojr-1996-2014.csv",
                 header = T, sep = ";", quote = '"', 
                 dec = ",", encoding = "UTF-8",
                 stringsAsFactors = FALSE)

evolb100 <- function(x) {
  return (x / x[1] * 100)
}

shinyServer(
  function(input, output) {
    # Vue globale
    output$glob.evol <- renderPlot({
      agg = aggregate(Documents ~ Year, sci, sum)
      ggplot(agg, aes(Year, Documents)) + 
        geom_line(size = 1) +
        theme_minimal() +
        theme(panel.grid = element_blank()) +
        xlab("") + ylab("")
    })
    output$glob.top <- renderTable({
      agg = aggregate(Documents ~ Country, sci, sum)
      head(agg[order(agg$Documents, decreasing = TRUE),], 10)
    })
    
    # Vue par pays
    subPays <- reactive({
      subset(sci, Country == input$pays.choix)
    })
    output$pays.docs <- renderPlot({
      agg = aggregate(Documents ~ Year, sci, sum)
      ggplot(subPays(), aes(Year, evolb100(Documents))) + 
        geom_line(size = 1) +
        theme_minimal() +
        theme(panel.grid = element_blank()) +
        xlab("") + ylab("") +
        geom_hline(yintercept = 100, linetype = 2, color = "gray30") +
        annotate("text", x = 1996, y = 100, vjust = 1, hjust = 1,
                 color = "gray30",
                 label = "100") +
        geom_line(data = agg, aes(Year, evolb100(Documents)), 
                  color = "gray30", linetype = 3) +
        annotate("text", x = 2014, y = tail(evolb100(agg$Documents), 1),
                 label = "Evolution\nmondiale",
                 hjust = 1, vjust = 1)
    })
    output$pays.info <- renderInfoBox({
      docs = subPays()$Documents
      evol = docs[length(docs)] / docs[1]
      agg = aggregate(Documents ~ Year, sci, sum)
      evol.glob = agg$Documents[nrow(agg)] / agg$Documents[1]
      infoBox(
        "Progression",
        paste0(round(evol * 100), "%"),
        icon = icon(ifelse(evol >= evol.glob, "thumbs-up", "thumbs-down")),
        color = ifelse(evol >= evol.glob, "green", "yellow")
      )
    })
    output$pays.rang <- renderPlot({
      sub = subPays()
      ggplot(sub, aes(Year, Rank)) + 
        geom_line(size = 1) +
        scale_y_reverse(limits = c(max(sci$Rank), 1)) +
        theme_minimal() +
        theme(panel.grid = element_blank()) +
        xlab("") + ylab("") +
        geom_hline(yintercept = max(sub$Rank), linetype = 2, color = "darkred") +
        annotate("text", 
                 x = 1996,
                 y = max(sub$Rank), 
                 label = max(sub$Rank),
                 vjust = 1.5, hjust = 1,
                 color = "darkred") +
        geom_hline(yintercept = min(sub$Rank), linetype = 2, color = "darkgreen") +
        annotate("text", 
                 x = 2014,
                 y = min(sub$Rank), 
                 label = min(sub$Rank),
                 vjust = -.5, hjust = -1,
                 color = "darkgreen")
    })
    
    # Vue par année
    subAnnee <- reactive({
      subset(sci, 
             Year == input$annee.choix, 
             c("Country", "Documents", "Citations", "H.index"))
    })
    output$annee.top <- renderTable({
      sub = subAnnee()
      head(sub[order(sub[,input$annee.crit], decreasing = TRUE),], 
           input$annee.taille)
    })
    
    # Vue par rangs
    output$rangs <- renderPlot({
      sub = subset(sci, Rank <= 10)
      last = merge(aggregate(Year ~ Country, sub, max), sub)
      nbCouleurs = length(unique(sub$Country))
      getPalette = colorRampPalette(brewer.pal(8, "Dark2"))
      ggplot(sub, aes(Year, Rank, color = Country)) +
        geom_line(size = 1) +
        scale_color_manual(values = getPalette(nbCouleurs)) +
        scale_y_reverse(breaks = 1:10) +
        theme_minimal() +
        theme(panel.grid = element_blank(), legend.position = "none") +
        xlab("") + ylab("") +
        geom_text(data = last, aes(Year, Rank, label = Country), 
                  vjust = -.5, hjust = 1)
    })
    
  }
)