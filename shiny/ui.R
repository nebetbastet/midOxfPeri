library(shiny)
library(ggplot2)

dataset <- readRDS("data.RDS")

fluidPage(
  
  titlePanel("Perisphinctidae de l'Oxfordien Moyen"),
  
  sidebarPanel(
    
    numericInput("dm", "diamètre", 0, min = 0, max = 100),
    numericInput("wh", "wh", 0, min = 0, max = 100),
    numericInput("ww", "ww", 0, min = -100, max = 100),
    numericInput("uw", "uw", 0, min = -100, max = 100),
    numericInput("e", "e", 0, min = -100, max = 100),
    
    selectInput('unit', 'Unité', c("cm","mm")),
    selectInput('method', 'Méthode', c("Mesure directe","Photographie")),
                
    selectInput('value', 'Que visualiser ?',
                c("clustering","dm","WWI","WER","UWI","Shape","WHI","o"
                                            ))           
                
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)
