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
                        "Number of hidden layers:",
                        value = 0,
                        min = 0,
                        max = 3,
                        step = 1),
            h4("Layer 0 (data):"),
            numericInput("sigma0",
                         "Spatial SD:",
                         value = 2,
                         min = 1e-6),
            numericInput("lengthscale0",
                         "Spatial lengthscale:",
                         value = 1,
                         min = 1e-6),
            numericInput("nugget0",
                         "Nugget:",
                         value = 0,
                         min = 0),
            
            h4("Layer 1:"),
            numericInput("sigma1",
                         "Spatial SD:",
                         value = 2,
                         min = 1e-6),
            numericInput("lengthscale1",
                         "Spatial lengthscale:",
                         value = 1,
                         min = 1e-6),
            numericInput("nugget1",
                         "Nugget:",
                         value = 0,
                         min = 0),
            
            h4("Layer 2:"),
            numericInput("sigma2",
                         "Spatial SD:",
                         value = 2,
                         min = 1e-6),
            numericInput("lengthscale2",
                         "Spatial lengthscale:",
                         value = 1,
                         min = 1e-6),
            numericInput("nugget2",
                         "Nugget:",
                         value = 0,
                         min = 0),
            
            h4("Layer 3:"),
            numericInput("sigma3",
                         "Spatial SD:",
                         value = 2,
                         min = 1e-6),
            numericInput("lengthscale3",
                         "Spatial lengthscale:",
                         value = 1,
                         min = 1e-6),
            numericInput("nugget3",
                         "Nugget:",
                         value = 0,
            #              min = 0),
            # 
            # h4("Layer 4:"),
            # numericInput("sigma4",
            #              "Spatial SD:",
            #              value = 2,
            #              min = 1e-6),
            # numericInput("lengthscale4",
            #              "Spatial lengthscale:",
            #              value = 1,
            #              min = 1e-6),
            # numericInput("nugget4",
            #              "Nugget:",
            #              value = 0,
                         min = 0)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            actionButton("refresh", "Refresh"),
            plotOutput("yvx"),
            plotOutput("hidden1"),
            plotOutput("hidden2"),
            plotOutput("hidden3"),
            plotOutput("xv")
        )
    )
))
