library(shiny)
library(reshape2)
library(ggplot2)
library(scales)
library(FactoMineR)
library(mclust)

load("pendigits.RData")

showDigitPartition <- function(z, mean, pca) {
    tab = table(z)
    ncl = length(tab)
    par(mfcol = c(2, ncl), mar = c(0, 0, 0, 0) + .1)
    for (k in 1:ncl) {
        if (ncl == 1) {
            drawn(mean, n = tab[k], point = TRUE)
        } else {
            drawn(mean[k,], n = tab[k], point = TRUE)
        }
        plot(Dim.2 ~ Dim.1, subset(pca, cluster == k),
             xlim = range(res2$Dim.1),
             ylim = range(res2$Dim.2),
             col = rainbow(ncl)[k], pch = 19, 
             axes = FALSE, xlab = "", ylab = "", frame.plot = TRUE)
    }
}

shinyServer(function(input, output) {
   
    # Description
    output$desc.digit <- renderPlot({
        ggplot(pen, aes(digit, fill = digit)) + 
            geom_bar() +
            xlab("") + ylab("") +
            theme_minimal() +
            theme(axis.text.x = element_blank(),
                  axis.ticks.x = element_blank())
    })
    output$desc.coord <- renderPlot({
        ggplot(pen.melt, aes(digit, value, color = digit)) + 
            geom_boxplot() +
            facet_wrap(~ variable) +
            theme_minimal() +
            xlab("") + ylab("") +
            theme(axis.text.x = element_blank(),
                  axis.ticks.x = element_blank())
    })
    output$desc.average <- renderPlot({
        par(mfrow = c(2, 5))
        for (i in 0:9) {
            s = subset(pen, digit == i)
            # Computing the average values
            mean = apply(s[-17], 2, mean)
            # Drawn the first drawn
            drawn(s[1,1:16], col = "gray90", n = i)
            # Add all other drawn
            for (j in 2:nrow(s)) 
                drawn(s[j,1:16], col = "gray90", add = TRUE)
            # Last, add the average line
            drawn(mean[-17], add = TRUE)
        }
    })
    output$desc.pca.plot <- renderPlot({
        g = ggplot(res2, aes(Dim.1, Dim.2, color = digit)) +
            geom_point() +
            theme_minimal()
        if (input$desc.pca.type == "Separated") {
            g = g + facet_wrap(~ digit) +
                guides(color = FALSE)
        } 
        g
    })
    
    # HAC
    output$hac.tree <- renderPlot({
        dig = as.numeric(input$hac.digit)
        ncl = as.numeric(input$hac.ncl)
        tree = hac.ward[[dig+1]]
        par(mar = c(2, 2, 0, 0) + .1)
        plot(tree, hang = -1, labels = FALSE,
             main = "")
        if (ncl > 1)
            rect.hclust(tree, ncl)
    })
    output$hac.plot <- renderPlot({
        dig = as.numeric(input$hac.digit)
        ncl = as.numeric(input$hac.ncl)
        z = cutree(hac.ward[[dig+1]], ncl)
        mean = apply(subset(pen, digit == dig, -digit), 2, tapply, z, mean)
        pca = data.frame(subset(res2, digit == dig, -digit),
                         cluster = z)
        showDigitPartition(z, mean, pca)
    })

    # kmeans
    output$km.r2 <- renderPlot({
        dig = as.numeric(input$km.digit)
        ncl = as.numeric(input$km.ncl)
        I = km[[dig+1]][[1]]$totss
        B = sapply(km[[dig+1]], function(res) return(res$betweenss))
        ggplot(data.frame(G = 1:10, r2 = B / I), aes(G, r2)) +
            geom_line() +
            scale_x_discrete(limits = 1:10) +
            scale_y_continuous(labels = percent) +
            theme_minimal() +
            geom_vline(xintercept = ncl, color = "grey30", linetype = 2) +
            geom_hline(yintercept = B[ncl] / I, color = "grey30", linetype = 2)
    })
    output$km.plot <- renderPlot({
        dig = as.numeric(input$km.digit)
        ncl = as.numeric(input$km.ncl)
        z = km[[dig+1]][[ncl]]$cluster
        mean = km[[dig+1]][[ncl]]$centers
        pca = data.frame(subset(res2, digit == dig, -digit),
                         cluster = z)
        showDigitPartition(z, mean, pca)
    })

    # Mixture model
    output$mclust.crit <- renderPlot({
        dig = as.numeric(input$mclust.digit)
        ncl = as.numeric(input$mclust.ncl)
        crit = data.frame(t(sapply(mclust[[dig+1]], function(m) {
            return(c(G = m$G, BIC = m$bic, ICL = m$ICL, AIC = m$AIC, AIC3 = m$AIC3))
        })))
        names(crit) = c("G", "BIC", "ICL", "AIC", "AIC3")
        ggplot(crit, aes_string("G", input$mclust.choice)) +
            geom_line() +
            scale_x_discrete(limits = 1:10) +
            theme_minimal() +
            geom_vline(xintercept = ncl, color = "grey30", linetype = 2) +
            geom_hline(yintercept = crit[ncl,input$mclust.choice], color = "grey30", linetype = 2)
    })
    output$mclust.plot <- renderPlot({
        dig = as.numeric(input$mclust.digit)
        ncl = as.numeric(input$mclust.ncl)
        z = mclust[[dig+1]][[ncl]]$classification
        mean = t(mclust[[dig+1]][[ncl]]$parameters$mean)
        pca = data.frame(subset(res2, digit == dig, -digit),
                         cluster = z)
        showDigitPartition(z, mean, pca)
    })    
})
