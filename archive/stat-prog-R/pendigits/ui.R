library(shiny)
library(shinythemes)

shinyUI(navbarPage(
    "Pen digits",
    theme = shinytheme("darkly"),
    
    # Description of the data
    tabPanel(
        "Description",
        tabsetPanel(
            tabPanel(
                "Digit distribution",
                helpText("The digits are approximatively equi-distributed"),
                plotOutput("desc.digit")
            ),
            tabPanel(
                "Coordinates distribution",
                helpText(""),
                plotOutput("desc.coord")
            ),
            tabPanel(
                "Average digits",
                helpText(""),
                plotOutput("desc.average")
            ),
            tabPanel(
                "PCA",
                radioButtons("desc.pca.type",
                             "Plot type",
                             c("Global", "Separated"),
                             inline = TRUE),
                plotOutput("desc.pca.plot")
            )
        )
    ),
    
    # HAC
    tabPanel(
        "HAC",
        sidebarLayout(
            sidebarPanel(
                selectInput("hac.digit",
                            "Digit",
                            0:9),
                radioButtons("hac.ncl",
                             "Number of clusters",
                             1:10)
            ),
            mainPanel(
                plotOutput("hac.tree"),
                plotOutput("hac.plot")
            )
        )
    ),
    
    # kmeans
    tabPanel(
        "kmeans",
        sidebarLayout(
            sidebarPanel(
                selectInput("km.digit",
                            "Digit",
                            0:9),
                radioButtons("km.ncl",
                             "Number of clusters",
                             1:10)
            ),
            mainPanel(
                plotOutput("km.r2", height = 200),
                plotOutput("km.plot")
            )
        )
    ),
    
    # Mixture model
    tabPanel(
        "mclust",
        sidebarLayout(
            sidebarPanel(
                selectInput("mclust.digit",
                            "Digit",
                            0:9),
                radioButtons("mclust.ncl",
                             "Number of clusters",
                             1:10)
            ),
            mainPanel(
                fluidRow(
                    column(3, selectInput("mclust.choice", "Criterion", c("BIC", "ICL", "AIC", "AIC3"))),
                    column(9, plotOutput("mclust.crit", height = 200))
                ),
                plotOutput("mclust.plot")
            )
        )
    ),
    
    # Original data
    navbarMenu(
        "Original data",
        tabPanel("pendigits.tra",
                 tags$pre(includeText("../../donnees/pendigits.tra"))),
        tabPanel("pendigits.tes",
                 tags$pre(includeText("../../donnees/pendigits.tes")))
    )

))
