library(shiny)
library(FactoMineR)
pca = PCA(iris, quali.sup = 5, graph = FALSE)

shinyServer(function(input, output) {

    output$tab <- renderTable({
        aggregate(. ~ Species, iris, mean)
    }, digits = 2)
    
    output$graph <- renderPlot({
        par(mar = c(4, 4, 0, 0) + .1)
        plot(Dim.2 ~ Dim.1, pca$ind$coord,
             col = rainbow(3)[iris$Species], pch = 19)
    })
})
