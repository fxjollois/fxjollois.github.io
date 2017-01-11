library(shiny)
library(ggplot2)

sci = read.table("../../donnees/scimagojr-1996-2014.csv",
                 header = T, sep = ";", quote = '"', dec = ",")

base100 <- function(docs) {
    docs / docs[1] * 100
}

shinyServer(function(input, output) {
    
    # tab1 : Vue globale
    output$glob.docs <- renderPlot({
        agg = aggregate(Documents ~ Year, sci, sum)
        ggplot(agg, aes(Year, Documents)) + geom_line()
    })
    output$glob.top10 <- renderTable({
        agg = aggregate(Documents ~ Country, sci, sum)
        head(agg[order(agg$Documents, decreasing = TRUE),], 10)
    })
    
    # tab2 : Vue par pays
    subPays <- reactive({
        subset(sci, Country == input$pays.choix)
    })
    output$pays.evol <- renderPlot({
        sub = subPays()
        sub$Evol = base100(sub$Documents)
        ggplot(sub, aes(Year, Evol)) + geom_line()
    })
    output$pays.rank <- renderPlot({
        sub = subPays()
        ggplot(sub, aes(Year, Rank)) + geom_line()
    })
    
    # tab3 : Vue par pays
    output$year.top <- renderTable({
        sub = subset(sci, Year == input$year.choix, select = c(Country, Documents, Citations, H.index))
        head(sub[order(sub$Documents, decreasing = TRUE),], input$year.taille)
    })
    
    # tab4 : Vue par rang
    output$rank.evol <- renderPlot({
        sub = subset(sci, Rank <= 10)
        ggplot(sub, aes(Year, Rank, color = Country)) + geom_line() +
            scale_y_reverse(limits = c(10, 1), breaks = 1:10)
    })
})