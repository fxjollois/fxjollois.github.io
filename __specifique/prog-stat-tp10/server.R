library(shiny)

shinyServer(function(input, output) {
    output$nuage <- renderPlot({
        plot(mtcars$mpg ~ mtcars[,input$choix], main = "Consommation")
    })
    
    output$resumeMpg <- renderText({
        paste("Moyenne mpg :", mean(mtcars$mpg, na.rm = T))
    })
    output$resumeVar <- renderText({
        paste("Moyenne", input$choix, ":", mean(mtcars[,input$choix], na.rm = T))
    })
    
    output$tableau <- renderTable({
        sub = subset(mtcars, select = c("mpg", input$choix))
        sapply(sub, summary)
    })
})