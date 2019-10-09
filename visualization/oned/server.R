library("shiny")
library("tidyverse")

source("functions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        a <- input$refresh
        
        if (input$random) {
            x <- rnorm(input$n_points, 
                       mean = input$mean,
                       sd   = input$sd)
        } else {
            x <- qnorm((1:input$n_points)/(input$n_points + 1),
                       mean = input$mean,
                       sd   = input$sd)
        }
        
        f <- rdeepgp(x           = x, 
                     sigma       = input$sigma,
                     lengthscale = input$lengthscale,
                     n_layers    = input$n_layers)
        
        ggplot(data.frame(x = x, f = f), aes(x,f)) + 
            geom_line() +
            theme_bw()

    })

})
