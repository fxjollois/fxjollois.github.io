library(shiny)
library(FactoMineR)
pca = PCA(iris, quali.sup = 5, graph = FALSE)
nDim = ncol(pca$ind$coord)

shinyServer(function(input, output, session) {
    
    observe({
        updateRadioButtons(session, "dimX",
                           choices = 1:nDim,
                           inline = TRUE,
                           selected = 1)
        updateRadioButtons(session, "dimY",
                           choices = 1:nDim,
                           inline = TRUE,
                           selected = 2)
    })
    
    observe({
        dimX = input$dimX
        if (input$dimY == dimX) {
            dimY = which(!(1:nDim == dimX))[1]
            updateRadioButtons(session, "dimY",
                               selected = dimY)
        }
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
    
    subPCA <- reactive({
        if (input$dimX == 0) return(NULL)
        dimX = as.numeric(input$dimX)
        dimY = as.numeric(input$dimY)
        m = data.frame(x = pca$ind$coord[,dimX],
                       y = pca$ind$coord[,dimY])
    })
    
    output$graph <- renderPlot({
        m = subPCA()
        if (is.null(m)) return(NULL)
        par(mar = c(4, 4, 0, 0) + .1)
        plot(y ~ x, m,
             col = rainbow(3)[iris$Species], pch = 19,
             xlab = paste("Dimension", input$dimX),
             ylab = paste("Dimension", input$dimY))
    })
})
