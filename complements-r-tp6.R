library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)

runApp(shinyApp(
    ui = dashboardPage(
        dashboardHeader(
            title = "TP 6"
        ),
        dashboardSidebar(
            selectInput(
                "ville",
                "Choix de la ville",
                c("Toutes les villes", unique(txhousing$city))
            ),
            sidebarMenu(
                menuItem("Résumé", tabName = "resume", icon = icon("dashboard")),
                menuItem("TOP", tabName = "top", icon = icon("thumbs-up")),
                menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(
                    "resume",
                    box(
                        title = "Volume des ventes",
                        plotOutput("conso"),
                        footer = "Données provenant de txhousing",
                        status = "info",
                        solidHeader = TRUE,
                        width = 8
                    ),
                    uiOutput("progression"),
                    valueBox(
                        value = "?",
                        subtitle = "Volume totale des ventes",
                        icon = icon("usd"),
                        color = "light-blue"
                    ),
                    tabBox(
                        title = "Informations",
                        width = 4,
                        tabPanel("Nombre", "Nombre de ventes"),
                        tabPanel("Prix médian", "prix médian")
                    )
                ),
                tabItem(
                    "top"
                )
            )
        ),
        title = "TP 6",
        skin = "yellow"
    ),
    server = function(input, output) {
        output$conso <- renderPlot({
            if (input$ville == "Toutes les villes") {
                df = aggregate(volume ~ date, txhousing, sum)
            } else {
                df = aggregate(volume ~ date, 
                               subset(txhousing, city == input$ville),
                               sum)
            }
            
            ggplot(df, aes(date, volume)) + geom_line()
        })
        
        output$progression <- renderUI({
            if (input$ville == "Toutes les villes") {
                med2000 = median(subset(txhousing, year == 2000)$volume, na.rm = T)
                med2015 = median(subset(txhousing, year == 2015)$volume, na.rm = T)
            } else {
                med2000 = median(subset(txhousing, year == 2000 & city == input$ville)$volume, 
                                 na.rm = T)
                med2015 = median(subset(txhousing, year == 2015 & city == input$ville)$volume, 
                                 na.rm = T)
            }
            
            
            valeur = round(med2015 / med2000 * 100, 2)
            couleur = ifelse(valeur < 200, "red", ifelse(valeur < 350, "light-blue", "green"))
            infoBox(
                title = "Progression",
                value = paste(valeur, "%"),
                subtitle = "Entre 2000 et 2015",
                icon = icon("line-chart"),
                fill = TRUE,
                color = couleur
            )
        })
    }
))