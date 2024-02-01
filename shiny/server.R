library(shiny)
library(ggplot2)
library(tidyverse)

input=list()
input$dm=10
input$wh=3
input$uw=5
input$e=0.2
input$ww=2
input$value="clustering"

function(input, output) {
  
  
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
    
    res.pca=PCA(data_pca,graph = FALSE,ind.sup = nrow(res.pca))
    pca.coord=rbind(res.pca$ind$coord,res.pca$ind.sup$coord)
    pc_var=cumsum(res.pca$eig[,2])
    nb_axe=min(which(pc_var>80))
    
    # Umap ####
    res_umap=umap(pca.coord[,1:nb_axe])
    umap.coord=res_umap$layout
    colnames(umap.coord)=paste0("UMAP",1:2)
    
    # Plot
    data_plot=merge(umap.coord,data,by="row.names", all=TRUE) %>%
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
      ggtitle("UWI")+theme_bw()
    
    print(p)
    
  }, height=650)
  
}
