#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Deep GP: scalar inputs, scalar hidden layers, scalar output"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Gaussian input:"),
            sliderInput("n_points",
                         "Number of points",
                         value = 501,
                         min = 11, 
                         max = 1001),
            checkboxInput("random",
                          "Random Input (if not, then quantiles are used)."),
            numericInput("mean", 
                         "Input mean:",
                         value = 0),
            numericInput("sd",
                         "Input SD:",
                         value = 1),
            
            hr(),
            h3("Layers:"),
            sliderInput("n_layers",
                        "Number of layers:",
                        value = 1,
                        min = 0,
                        max = 5,
                        step = 1),
            numericInput("sigma",
                        "Spatial SD:",
                        value = 2,
                        min = 1e-6),
            numericInput("lengthscale",
                         "Spatial lengthscale:",
                         value = 1,
                         min = 1e-6)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            actionButton("refresh", "Refresh"),
            plotOutput("distPlot")
        )
    )
))
