
module1Input <- function(id) {
    selectInput(id, "Abscisse", c("wt", "hp", "disp"))
}

module1Output <- function(id) {
    output$nuage1 <- renderPlot({
        plot(mtcars$mpg ~ mtcars[,input[id]], 
             main = "Consommation",
             xlab = input[id], ylab = "mpg")
    })
}