setwd("C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2")
library(dplyr)
library(FactoMineR)
library(factoextra)
library(ggrepel)
library(umap)
library(pheatmap)

#500 https://ammonites.org/Fiches/0524.htms

dirs=list.dirs() %>% .[.!="."]
dirs=dirs[grepl("Ammonite",dirs)]

data=c()
for (d in dirs) {
  N=gsub("./Ammonite","",d) %>% as.numeric()
  data_D=read.csv(paste0(d,"/ammonite",gsub("./Ammonite","",d),".csv"))
  rownames(data_D)=c("dm","wh","uw","e")
  data_D2=read.csv(paste0(d,"/ammonite",gsub("./Ammonite","",d),"ww.csv"))
  rownames(data_D2)="ww"
  data_D3=rbind(data_D[,6,drop=FALSE],data_D2[,6,drop=FALSE]) %>% data.frame()
  data=rbind(data,t(data_D3))
  rownames(data)[nrow(data)]=N
}
data=data.frame(data)
data$UWI=data$uw/data$dm #evolution
data$WWI=data$ww/data$wh #dépression
data$WHI=data$wh/data$dm # Whorld height index 
data$Shape = data$ww/data$dm # Shape
data$WER =  (data$dm/(data$dm-data$wh))^2 #Whorl expansion rate 
data$o=data$e/data$dm #ornementation

ref=openxlsx::read.xlsx("references.xlsx")
ref$Numéro=as.character(ref$Numéro)
ref=ref[ref$Numéro%in%rownames(data),]
data$label="?"
data[as.character(ref$Numéro),"label"]=ref$Genre
data=data[data$label!="Dichotomoceras" ,]
data["3","label"]="Otosphinctes (?)"
data["7","label"]="Otosphinctes (?)"
data["8","label"]="Otosphinctes (?)"
data["11","label"]="Otosphinctes (?)"
data["13","label"]="Otosphinctes (?)"
data["14","label"]="Otosphinctes (?)"
data["19","label"]="Passendorferia birmensdorfense (?)"
data["21","label"]="Otosphinctes (?)"
col_label=hues::iwanthue(length(unique(data$label))) %>% setNames(unique(data$label))
col_label=c(`?` = "#95BBB6", `Otosphinctes (?)` = "#9041CC", 
            `Passendorferia birmensdorfense (?)` = "#857028", 
            Passendorferia =  "#f5d667",
            Dichotomosphinctes = "#C4553E",
            Subdiscosphinctes = "#4E4637", 
            Dichotomoceras = "#2ca836", Otosphinctes =  "#615998"
             )

data_pca=data[,c("dm","WWI","WER","UWI","Shape","WHI","o")]
#data_pca=data[,c("WER","UWI","Shape","WHI")]
#data_pca=data[,c("WWI","WER","UWI","Shape","WHI")]
data_pca=scale(data_pca) %>% data.frame()


# Heatmap  #####
annotation_col=data[,"label",drop=FALSE]
pheatmap(t(data_pca), cutree_cols = 5, cutree_rows = 4,
         annotation_col=annotation_col,
         annotation_color=list(label=col_label))

# PCA #####
res.pca=PCA(data_pca,graph = FALSE)

plot(res.pca,choix="var")
plot(res.pca,c(1,3),choix="var")

pca.coord=res.pca$ind$coord
data_plot=merge(pca.coord,data,by="row.names") %>%
  data.frame()
pheatmap(t(pca.coord),annotation_col=annotation_col,
         annotation_color=list(label=col_label))

value="UWI"
data_plot$value=data_plot[,value]
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = value)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle(value)



ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
 scale_color_manual(values=col_label)+theme_bw() 

ggplot(data_plot,aes(x=Dim.1,y=Dim.3,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  scale_color_manual(values=col_label)+theme_bw() 

# clustering #####
hc=hclust(dist((pca.coord[,1:3])), method="ward.D2")
k=6
clustering=cutree(hc,k=k) 
names(clustering)=rownames(pca.coord)
annotation_col$clustering=paste0("cl",clustering[rownames(annotation_col)])
pheatmap(t(pca.coord[,1:3]), 
         cutree_cols = k,
         annotation_col=annotation_col,
         annotation_color=list(label=col_label))


data_plot$clustering=paste0("cl",clustering[data_plot$Row.names])

ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = clustering)) +
  theme_bw() 
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  theme_bw() 

# Umap ####
res_umap=umap(pca.coord)
colnames(res_umap$layout)=paste0("UMAP",1:2)

data_plot2=merge(data_plot,res_umap$layout,by.x="Row.names",by.y="row.names")
ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  scale_color_manual(values=col_label)+theme_bw() 
ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=Row.names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = clustering)) +
  theme_bw() 
