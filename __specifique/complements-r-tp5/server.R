library(shiny)
library(ggplot2)
library(scales)

source("module1.R")

shinyServer(function(input, output) {
    # Panel 1
    callModule("module2Output", "choix")
    tabXY <- reactive({
        tab = data.frame(y = mtcars$mpg,
                         x = mtcars[, input$choix])
    })
    output$nuage2 <- renderPlot({
        ggplot(tabXY(), aes(x, y)) + geom_point() +
            xlab(input$choix) + ylab("mpg")
    })
    output$nuage3 <- renderPlot({
        ggplot(mtcars, aes_string(input$choix, "mpg")) +
            geom_point()
    })
    
    output$resumeMpg <- renderText({
        res = round(mean(mtcars$mpg, na.rm = T), 2)
        paste("Moyenne mpg :", res)
    })
    output$resumeVar <- renderText({
        res = round(mean(mtcars[, input$choix], na.rm = T), 2)
        paste("Moyenne", input$choix, ":", res)
    })
    output$corMpgVar <- renderText({
        res = round(cor(mtcars$mpg, mtcars[, input$choix]), 2)
        paste0("Correlation mpg|", input$choix, " : ", res)
    })
    
    output$tableau <- renderTable({
        sub = subset(mtcars, select = c("mpg", input$choix))
        sapply(sub, summary)
    }, rownames = TRUE)
    
    # Panel 2
    output$ql.bar <- renderPlot({
        mtcars$nouv = factor(mtcars[, input$ql.choix])
        ggplot(mtcars, aes(nouv, fill = nouv)) +
            geom_bar() +
            xlab("") + labs(fill = input$ql.choix)
    })
    output$ql.pie <- renderPlot({
        mtcars$nouv = factor(mtcars[, input$ql.choix])
        ggplot(mtcars, aes("", fill = nouv)) +
            geom_bar(aes(y = (..count..) / sum(..count..)), width = 1) +
            coord_polar(theta = "y") +
            scale_y_continuous(labels = percent) +
            xlab("") + ylab("") +
            theme(axis.ticks = element_blank()) +
            labs(fill = input$ql.choix)
    })
    output$ql.tab <- renderTable({
        t = unclass(table(mtcars[, input$ql.choix]))
        data.frame(Modalite = names(t),
                   Effectif = t)
    })
    
    # Panel 3
    output$qlql.bar <- renderPlot({
        tab = data.frame(x = factor(mtcars[, input$qlql.choix1]),
                         y = factor(mtcars[, input$qlql.choix2]))
        ggplot(tab, aes(x, fill = y)) +
            geom_bar(position = "fill") +
            scale_y_continuous(labels = percent) +
            xlab(input$qlql.choix1) +
            ylab("") +
            labs(fill = input$qlql.choix2)
    })
    output$qlql.tab <- renderTable({
        tab = table(mtcars[, input$qlql.choix1],
                    mtcars[, input$qlql.choix2])
        dimnames(tab)[[1]] = paste(input$qlql.choix1, dimnames(tab)[[1]], sep = "=")
        dimnames(tab)[[2]] = paste(input$qlql.choix2, dimnames(tab)[[2]], sep = "=")
        addmargins(unclass(tab))
    }, rownames = TRUE)
})