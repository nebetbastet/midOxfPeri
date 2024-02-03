library(shiny)
library(ggplot2)
library(tidyverse)
library(viridis)
library(FactoMineR)
library(umap)
library(shinythemes)
library(shinydashboard)
options(shiny.maxRequestSize = 160*1024^2)

dataset <- readRDS("data.RDS")
res_umap0 <- readRDS("res_umap0.RDS")
beta <- readRDS("beta.RDS")

# ui ####
ui <- fluidPage(
  theme = shinytheme("sandstone"),
  dashboardHeader(
    title= div(h3("Perisphinctidae de l'Oxfordien Moyen", style="margin: 0;"), 
               h4('Zone à Transversarium, sous-zone à Parandieri', style="margin: 0;"))
  ),
 # titlePanel("Perisphinctidae de l'Oxfordien Moyen"),
  
  sidebarPanel(
    
    numericInput("dm", "diamètre (dm)", 0, min = 0, max = 100),
    numericInput("wh", "hauteur de la spire (wh)", 0, min = 0, max = 100),
    numericInput("ww", "largeur de la spire (ww)", 0, min = -100, max = 100),
    numericInput("uw", "diamètre de l'ombilic (uw)", 0, min = -100, max = 100),
    numericInput("e", "écart entre les côtes", 0, min = -100, max = 100),
    
    selectInput('unit', 'Unité', c("cm","mm")),
    selectInput('method', 'Méthode', c("Mesure directe","Photographie")),
    
    selectInput('value', 'Que visualiser ?',
                c("Groupes de ressemblance"="clustering",
                  "Diamètre (cm)"="dm",
                  "Indice de largeur de la spire (WWI = ww/dm)"="WWI",
                  "Taux d'expansion des spires (WER)"="WER",
                  "Indice de Largeur Ombilical (UWI = uw/dm)"="UWI",
                  "Epaisseur (ww/wh)"="Shape",
                  "Indice de hauteur de la spire (WHI = wh/dm)"="WHI",
                  "Densité de la costulation"="densite"
                ))           
    
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)


input=list()
input$dm=10
input$wh=3
input$uw=5
input$e=0.2
input$ww=2
input$value="densite"
input$unit="cm"
input$method="Mesure directe"

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
    newData$densite=newData$dm/newData$e
    
    dataset$densite=dataset$dm/dataset$e
    
    # Harmoniser
    varToCorrect=rownames(beta)
    x=as.matrix(newData[,varToCorrect])
    
    # checking sens 
    # Dans le jeu de données de base, UWI est > chez les réf
    # Donc si beta["UWI",] doit est negatif, batchx est positif pour Mesure directe
    # if (beta["UWI",]<0) {
      if (input$method=="Mesure directe") {
        batchx =  1
      } else {
        batchx = - 1
      }
    # } else {
    #   if (input$method=="Mesure directe") {
    #     batchx =-  1
    #   } else {
    #     batchx =  1
    #   }
    # }
    
   
    newData0=newData
    newData[,varToCorrect]=t(as.matrix(t(newData0[,varToCorrect])) + beta %*% t( batchx))
    newData0[,varToCorrect]
    newData[,varToCorrect]
    
    
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
                    by="row.names", all=TRUE) 
    

    rownames(data_plot)=data_plot$names=data_plot$Row.names

    data_plot$clustering=dataset[rownames(data_plot),"clustering_boot"]
    data_plot["newData",c("Row.names","label","label2","clustering","names")]=c("0","Ton ammonite","?","Ton ammonite",
                                                                                "Ton ammonite")
    data_plot$names[as.numeric(data_plot$Row.names)>=500]=data_plot$label2[as.numeric(data_plot$Row.names)>=500]
    data_plot["newData",colnames(newData)]=newData[,colnames(newData)]
    #data_plot$densite=max(data_plot$o)-data_plot$o

    data_plot$value=data_plot[,input$value]   
    data_plot=data.frame(data_plot)
      
    
  })
  
  output$plot <- renderPlot({
    
    col_cl=c( yellow = "#f3c300", purple = "#875692", 
               orange = "#f38400", lightblue = "#a1caf1", red ="darkgreen", buff = "#c2b280") 
    names(col_cl)=paste0("cl",1:length(col_cl))
    col_cl=c(col_cl,"Ton ammonite"="red")
    
    
    
    p <- ggplot(data_plot(),
                aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
      geom_point(aes(color = value)) +
      #geom_text(hjust=0, vjust=0,aes(color = value)) +
      ggtitle(input$value)+theme_bw()+ 
      ggrepel::geom_text_repel(data=data_plot()[data_plot()$label!="?",],
                      aes(label=label,color = value))
    
    if (is.numeric(data_plot()$value)) {

      p <- p+ #scale_colour_viridis()
        scale_color_gradientn(colours=wesanderson::wes_palette("Zissou1", 100, type = "continuous"))
      
    }
    
    if (input$value=="clustering") {
      p <- p+scale_colour_manual(values=col_cl)
    }
    
    
    print(p)
    
  }, height=650)
  
}


# app.R ####
shinyApp(ui, server)
