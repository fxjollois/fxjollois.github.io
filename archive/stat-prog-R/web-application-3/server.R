library(shiny)
library(FactoMineR)
pca = PCA(iris, quali.sup = 5, graph = FALSE)

shinyServer(function(input, output) {

    output$text <- renderText({
        paste(input$stat, "values of attributes for each species")
    })
    
    output$tab <- renderTable({
        aggregate(. ~ Species, iris, function(x) {
            switch(input$stat,
                   mean = mean(x),
                   median = median(x),
                   min = min(x),
                   max = max(x))
        })
    }, digits = 2)
    
    output$graph <- renderPlot({
        dimX = as.numeric(input$dimX)
        dimY = as.numeric(input$dimY)
        m = data.frame(x = pca$ind$coord[,dimX],
                       y = pca$ind$coord[,dimY])
        par(mar = c(4, 4, 0, 0) + .1)
        plot(y ~ x, m,
             col = rainbow(3)[iris$Species], pch = 19,
             xlab = paste("Dimension", dimX),
             ylab = paste("Dimension", dimY))
    })
})
