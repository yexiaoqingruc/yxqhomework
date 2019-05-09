## server.R

library(ncvreg)
library(ggplot2)
library(dplyr)
load("x_emp.RData")
load("y_emp.RData")

library(shiny)
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    
    # generate bins based on input$bins from ui.R

    x_emp = xx_emp[, ((input$dataRange - 1) * 330) : ((input$dataRange - 1) * 330 + 700)]
    
    cvfit = cv.ncvreg(x_emp, y_emp)
    fit = cvfit$fit
    betancv = fit$beta[,cvfit$min]
    betancv = betancv[-1]
    res = y_emp - x_emp %*% betancv
    res = res %>% as.data.frame
    colnames(res) = "resi"
    
    p = ggplot(res, aes(x = resi, y = ..density..)) + 
      geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
      geom_density() + xlim(range(res))
    
    p
    # x    <- faithful[, 2]
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
