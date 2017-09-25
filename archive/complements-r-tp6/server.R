library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)

shinyServer(
    function(input, output) {
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
            # Ajout du test pour savoir si la progression a pu être calculée
            if (is.na(valeur)) { # valeur == NA -> Problème sur 2000 a priori
                infoBox(
                    title = "Progression",
                    value = "Erreur",
                    subtitle = "Données manquantes",
                    icon = icon("warning"),
                    color = "yellow"
                )
            } else { # valeur OK -> on l'affiche
                couleur = ifelse(valeur < 200, "red", ifelse(valeur < 350, "light-blue", "green"))
                infoBox(
                    title = "Progression",
                    value = paste(valeur, "%"),
                    subtitle = "Entre 2000 et 2015",
                    icon = icon("line-chart"),
                    fill = TRUE,
                    color = couleur
                ) 
            }
            
        })
        
        # valueBox() en fonction de la ville choisie
        output$volume <- renderUI({
            if (input$ville == "Toutes les villes") {
                df = txhousing
            } else {
                df = subset(txhousing, city == input$ville)
            }
            valeur = sum(df$volume, na.rm = TRUE)
            couleur = ifelse(valeur < 2e9, "red", ifelse(valeur < 50e9, "light-blue", "green"))
            valueBox(
                value = round(valeur / 1e9, 2),
                subtitle = "Volume totale des ventes (en milliards)",
                icon = icon("usd"),
                color = couleur
            )
        })
        
        # nombre total de ventes
        output$nombre <- renderUI({
            if (input$ville == "Toutes les villes") {
                df = txhousing
            } else {
                df = subset(txhousing, city == input$ville)
            }
            valeur = sum(df$sales, na.rm = TRUE)
            p(valeur)
        })
        
        # prix médian de ventes
        output$prixmed <- renderUI({
            if (input$ville == "Toutes les villes") {
                df = txhousing
            } else {
                df = subset(txhousing, city == input$ville)
            }
            valeur = median(df$median, na.rm = TRUE)
            p(valeur)
        })
        
        # tableau des consommation, année par année et mois par mois
        output$consotab <- renderTable({
            if (input$ville == "Toutes les villes") {
                df = txhousing
            } else {
                df = subset(txhousing, city == input$ville)
            }
            a = aggregate(volume ~ year + month, df, sum)
            b = acast(a, year ~ month, value.var = "volume")
            c = b / 1e6
        }, rownames = TRUE, digits = 0, na = "-")
        
        # TOP Villes
        output$topvilles <- renderTable({
            df = aggregate(volume / 1e9 ~ city, txhousing, sum)  
            df = df[order(df$volume, decreasing = T),]
            nb = as.numeric(input$nbvilles)
            names(df) = c("Ville", "Volume")
            head(df, nb)
        }, digits = 2)
        # TOP Année
        output$topannees <- renderTable({
            df = aggregate(volume / 1e9 ~ year, txhousing, sum)  
            df = df[order(df$volume, decreasing = T),]
            nb = as.numeric(input$nbannees)
            names(df) = c("Année", "Volume")
            head(df, nb)
        }, digits = 2)
        # TOP Mois
        output$topmois <- renderTable({
            df = aggregate(volume / 1e9 ~ month, txhousing, sum)  
            df = df[order(df$volume, decreasing = T),]
            nb = as.numeric(input$nbmois)
            names(df) = c("Mois", "Volume")
            head(df, nb)
        }, digits = 2)
        
    }
)