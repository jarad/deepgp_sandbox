library("shiny")
library("tidyverse")

source("functions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # Generate explanatory variables
    x <- reactive({
        if (input$random) {
            rnorm(input$n_points, 
                  mean = input$mean,
                  sd   = input$sd)
        } else {
            qnorm((1:input$n_points)/(input$n_points + 1),
                  mean = input$mean,
                  sd   = input$sd)
        }
    })
    
    # Collect parameters in vector
    sigma <- reactive({ 
        c(input$sigma0,
          input$sigma1,
          input$sigma2,
          input$sigma3,
          input$sigma4) 
    })        
    lengthscale <- reactive({ 
        c(input$lengthscale0, 
          input$lengthscale1, 
          input$lengthscale2, 
          input$lengthscale3, 
          input$lengthscale4 )
    })        
    nugget <- reactive({ 
        c(input$nugget0, 
          input$nugget1, 
          input$nugget2, 
          input$nugget3, 
          input$nugget4 )
    })
    
    f <- reactive({

        a <- input$refresh
        
        # Simulate Deep GP
        rdeepgp(x           = x(), 
                sigma       = sigma(),
                lengthscale = lengthscale(),
                nugget      = nugget(),
                n_layers    = input$n_layers)
    })
    
    output$yvx <- renderPlot({
        plot(f()[,input$n_layers+2],
             f()[,1],
             type="l")
    })
    
    output$hidden1 <- renderPlot({
        if (input$n_layers > 0) {
            ordr <- order(f()[,2])
            plot(f()[ordr,2],
                 f()[ordr,1], 
                 type="l",
                 main = paste("hidden layer 1 versus y"))
        }
    })
    
    output$hidden2 <- renderPlot({
        if (input$n_layers > 1) {
            ordr <- order(f()[,3])
            plot(f()[ordr,3],
                 f()[ordr,2], 
                 type="l",
                 main = paste("hidden layer 2 versus hidden layer 1"))
        }
    })
    
    output$hidden3 <- renderPlot({
        if (input$n_layers > 2) {
            ordr <- order(f()[,4])
            plot(f()[ordr,4],
                 f()[ordr,3], 
                 type="l",
                 main = paste("hidden layer 3 versus hidden layer 2"))
        }
    })
    
    output$xv <- renderPlot({
        plot(f()[,input$n_layers+2],
             f()[,input$n_layers+1], 
             type="l",
             main = paste("x versus hidden layer 1"))
    })
    
})
