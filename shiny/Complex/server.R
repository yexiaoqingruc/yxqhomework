## server.R

library(ncvreg)
library(ggplot2)
library(dplyr)
library(gridExtra)
load("x_emp.RData")
load("y_emp.RData")
source("ADMM.R")
source("K.R")
source("group_member.R")
source("ST.R")

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
    
    result_emp = estimation_ADMM(x_emp, y_emp, as.numeric(input$LambdaRange), as.numeric(input$OmegaRange))
    gr_num = result_emp[[1]] %>% as.numeric
    
    if (gr_num > 4){
      
      p = ggplot(res, aes(x = resi, y = ..density..)) + 
        geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
        geom_density() + xlim(range(res))
      
      pp = ggplot(res, aes(x = resi, y = ..density..)) + 
        labs(title = "The parameters are not so good for the dataset")
      
      grid.arrange(p, pp, ncol = 2)
    }
    else{
      data_ov = cbind(y_emp, x_emp)
      beta_hat_emp = result_emp[[3]] %>% as.numeric
      gr_mem_emp = result_emp[[4]] %>% as.numeric %>% group_member(n = length(y_emp))
      
      
      nf = layout(matrix(1 : (grid_num + 1), nrow = 1))
      layout.show(nf)
      
      ggplot(res, aes(x = resi, y = ..density..)) + 
        geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
        geom_density() + xlim(range(res))
      
      for (i in 1 : gr_num) {
        group_ser = gr_mem_emp[i, ] %>% na.omit 
        if (length(group_ser) > 10){
          group = data_ov[group_ser, ] %>% as.matrix
          group_mu = result_emp[[2]][group_ser[1]] %>% as.numeric
          res1 = (group[, 1] - group_mu - group[, -1] %*% beta_hat_emp) %>% as.data.frame
          colnames(res) = "resi"
          
          ggplot(res1, aes(x = resi, y = ..density..)) + 
            geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
            geom_density() + xlim(range(res))
        }
           
      }
      
    }
    
    
    
    
    # x    <- faithful[, 2]
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
