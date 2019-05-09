load("x_emp.RData")
load("y_emp.RData")
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Kernel Desitity with partial Ovary Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("dataRange",
                  label = "Choose the data range:",
                  min = 1,
                  max = 49, step = 1, value = 2)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
