library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)

sci = read.table("scimagojr-1996-2014.csv", header = T, sep = ";", quote = NULL, dec = ",")

shinyServer(
  function(input, output) {
    # Premier onglet
    output$prod.top <- renderTable({
      df = aggregate(Documents ~ Country, sci, sum)
      df.ordre = df[order(df$Documents, decreasing = T),]
      head(df.ordre, as.numeric(input$prod.taille))
    })
    
    output$prod.evol <- renderPlot({
      df = aggregate(Documents ~  Year, sci, sum)
      ggplot(df, aes(Year, Documents)) +
        geom_line(lwd = 1.5) +
        scale_x_discrete(limits = 1996:2014) +
        theme_minimal() +
        xlab("Années") + ylab("Nombre de documents produits")
    })
    
    # Deuxième onglet
    output$rang.plot <- renderPlot({
      df = subset(sci, Rank <= 10)
      ggplot(df, aes(Year, Rank, color = Country, group = Country)) +
        geom_line(lwd = 1.5) +
        scale_y_reverse(breaks = 10:1) +
        scale_x_discrete(limits = 1996:2014) +
        theme_minimal() +
        xlab("Années") + ylab("Rang")
    })
    
    # Troisième onglet
    output$base100.plot <- renderPlot({
      df = subset(sci, 
                  subset = Country %in% input$base100.choix,
                  select = c(Country, Year, Documents))
      df.large = dcast(df, Country ~ Year)
      df.base100 = t(apply(df.large[,-1], 1, function(v) return(v / v[1] * 100)))
      rownames(df.base100) = df.large$Country
      df.base100.melt = melt(df.base100)
      ggplot(df.base100.melt, aes(Var2, value, color = Var1)) +
        geom_line(lwd = 1.5) +
        scale_x_discrete(limits = 1996:2014) +
        theme_minimal() +
        xlab("Années") + ylab("Evolution en base 100") + labs(color = "Pays sélectionnés")
    })
    
    # Quatrième onglet
    output$lien.plot <- renderPlot({
      aggDocuments = aggregate(Documents ~ Country, sci, sum)
      aggCitations = aggregate(Citations ~  Country, sci, sum)
      aggRank = aggregate(Rank ~  Country, sci, median)
      aggHindex = aggregate(H.index ~ Country, sci, mean)
      agg = merge(merge(merge(aggDocuments, aggCitations), aggRank), aggHindex)
      ggplot(agg, aes(Documents, Citations, color = Rank, size = H.index, label = Country)) +
        geom_point() +
        geom_text(size = 4, color = "black", check_overlap = T) +
        scale_x_log10() +
        scale_y_log10() +
        scale_color_gradient2(low = "green", high = "red", mid = "gray70", midpoint = 100) +
        theme_minimal() +
        labs(caption = "les échelles sont logarithmique, la taille des points dépend du H-index moyen, la couleur du rang médian")
    }, height = 700)
  }
)