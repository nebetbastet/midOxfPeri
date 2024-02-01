library(shiny)
library(ggplot2)
library(tidyverse)
library(viridis)
library(FactoMineR)
library(umap)
library(shinythemes)
options(shiny.maxRequestSize = 160*1024^2)

dataset <- readRDS("data.RDS")
res_umap0 <- readRDS("res_umap0.RDS")

# ui ####
ui <- fluidPage(
  theme = shinytheme("sandstone"),
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

# server ####
server <- function(input, output) {
  
  
  data_plot<- reactive({
    newData<- c(input$dm, input$wh,input$uw,input$e,input$ww) %>%
      setNames(c("dm", "wh", "uw", "e", "ww")) %>% t() %>%
      data.frame()
    rownames(newData)="newData"
    
    if (input$unit=="mm"){
      newData=newData/10
    }
    
    # Computing ratios ####
    newData$UWI=newData$uw/newData$dm #evolution
    newData$WWI=newData$ww/newData$wh #dépression
    newData$WHI=newData$wh/newData$dm # Whorld height index 
    newData$Shape = newData$ww/newData$dm # Shape
    newData$WER =  (newData$dm/(newData$dm-newData$wh))^2 #Whorl expansion rate 
    newData$o=newData$e/newData$dm #ornementations
    
    
    # Selecting variables for PCA + scaling ####
    sel_var=c("dm","WWI","WER","UWI","Shape","WHI","o")
    data_pca=rbind(dataset[,sel_var],newData[,sel_var])
    data_pca=scale(data_pca) %>% data.frame()
    
    data_pca=rbind(dataset[,sel_var],newData[,sel_var])
    data_pca=scale(data_pca) %>% data.frame()
    
    res.pca=PCA(data_pca,graph = FALSE,ind.sup = nrow(data_pca))
    pca.coord=rbind(res.pca$ind$coord,res.pca$ind.sup$coord)
    pc_var=cumsum(res.pca$eig[,2])
    nb_axe=min(which(pc_var>80))
    
    # Umap ####
    #set.seed(0)
    #res_umap0=umap(pca.coord[rownames(pca.coord)!="newData",1:nb_axe])
    res_umap.new = predict(res_umap0, pca.coord[rownames(pca.coord)=="newData",1:nb_axe,drop=FALSE])
    res_umap.new
    umap.coord=rbind(res_umap0$layout,res_umap.new) %>% data.frame()
    colnames(umap.coord)=paste0("UMAP",1:2)
    
    # Plot
    data_plot=merge(umap.coord,dataset[,-which(colnames(dataset)%in%c("UMAP1","UMAP2"))],
                    by="row.names", all=TRUE) %>%
      data.frame()
    rownames(data_plot)=data_plot$names=data_plot$Row.names
    data_plot["newData",c("Row.names","label","label2")]=c("0","?","?")
    data_plot$names[as.numeric(data_plot$Row.names)>=500]=data_plot$label2[as.numeric(data_plot$Row.names)>=500]
    data_plot["newData",c("dm","WWI","WER","UWI","Shape","WHI","o")]=newData[,sel_var]
    
    data_plot$clustering=dataset[rownames(data_plot),"clustering_boot"]
    data_plot$value=data_plot[,input$value]
    data_plot=data.frame(data_plot)
    
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(data_plot(),
                aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
      geom_text(hjust=0, vjust=0,aes(color = value)) +
      #scale_color_gradient(low="blue",  high="red") +
      ggtitle(input$value)+theme_bw()
    
    if (is.numeric(data_plot()$value)) {
      p <- p+scale_colour_viridis()
    }
    
    
    print(p)
    
  }, height=650)
  
}


# app.R ####
shinyApp(ui, server)
