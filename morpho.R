setwd("C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2")
library(dplyr)
library(FactoMineR)
library(factoextra)
library(ggrepel)
library(umap)
library(pheatmap)

# Loading data ####
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

# Computing ratios ####
data=data.frame(data)
data$UWI=data$uw/data$dm #evolution
data$WWI=data$ww/data$wh #dépression
data$WHI=data$wh/data$dm # Whorld height index 
data$Shape = data$ww/data$dm # Shape
data$WER =  (data$dm/(data$dm-data$wh))^2 #Whorl expansion rate 
data$o=data$e/data$dm #ornementation

# Reference ammonites ####
ref.df=openxlsx::read.xlsx("references.xlsx")
ref.df$Numéro=as.character(ref.df$Numéro)
ref.df=ref.df[ref.df$Numéro%in%rownames(data),]

# Labeling ammonites ####
data$label="?"
data[as.character(ref.df$Numéro),"label"]=ref.df$Genre
data$label2=substr(data$label,1,3) # abbreviation
data=data[data$label!="Dichotomoceras",] # pas de Dichotomoceras dans l'oxf moyen

# Personal identification (may be wrong !!)
data["3","label"]="Otosphinctes (?)"
data["7","label"]="Otosphinctes (?)"
data["8","label"]="Otosphinctes (?)"
data["11","label"]="Otosphinctes (?)"
data["13","label"]="Otosphinctes (?)"
data["14","label"]="Otosphinctes (?)"
data["19","label"]="Passendorferia birmensdorfense (?)"
data["21","label"]="Otosphinctes (?)"
data["35","label"]="Passendorferia birmensdorfense (?)"

# Colors of labels ####
col_label=c(`?` = "#95BBB6", `Otosphinctes (?)` = "#9041CC", 
            `Passendorferia birmensdorfense (?)` = "#857028", 
            Passendorferia =  "#f5d667",
            Dichotomosphinctes = "#C4553E",
            Subdiscosphinctes = "#4E4637", 
           # Dichotomoceras = "#2ca836",
            Otosphinctes =  "#615998"
             )
col_label2=col_label
names(col_label2)=substr(names(col_label),1,3) 

# Selecting variables for PCA + scaling ####
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
ref=which(as.numeric(rownames(data_pca))>=500) # identification of ref points
res.pca=PCA(data_pca,graph = FALSE,ind.sup = ref)
pc_var=cumsum(res.pca$eig[,2])
nb_axe=min(which(pc_var>80))

plot(res.pca,choix="var")
plot(res.pca,c(1,3),choix="var")

pca.coord=rbind(res.pca$ind$coord,res.pca$ind.sup$coord)
data_plot=merge(pca.coord,data,by="row.names") %>%
  data.frame()
data_plot$names=data_plot$Row.names
data_plot$names[as.numeric(data_plot$Row.names)>=500]=data_plot$label2[as.numeric(data_plot$Row.names)>=500]

pheatmap(t(pca.coord),annotation_col=annotation_col,
         annotation_color=list(label=col_label))

value="UWI"
data_plot$value=data_plot[,value]
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = value)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle(value)



ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
 scale_color_manual(values=col_label)+theme_bw() 

ggplot(data_plot,aes(x=Dim.1,y=Dim.3,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  scale_color_manual(values=col_label)+theme_bw() 

# clustering #####
FUNcluster=function(x,k) {
  hc=hclust(dist(x), method="ward.D2")
  clustering=cutree(hc,k=k) #%>% setNames(rownames(x))
  res=list()
  res[["cluster"]]=clustering
  return(res)
}


# Determiner le nombre optimal de clusters
fviz_nbclust(pca.coord[,1:nb_axe], FUNcluster, method = "silhouette")+ theme_classic()
k=5

clustering=(FUNcluster(pca.coord[,1:nb_axe],k=k))$cluster
names(clustering)=rownames(pca.coord)
annotation_col$clustering=paste0("cl",clustering[rownames(annotation_col)])
pheatmap(t(pca.coord[,1:nb_axe]), 
         cutree_cols = k,clustering_method="ward.D2",
         annotation_col=annotation_col,
         annotation_color=list(label=col_label))


data_plot$clustering=paste0("cl",clustering[data_plot$Row.names])

ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = clustering)) +
  theme_bw() 
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  theme_bw() 

# Umap ####
res_umap=umap(pca.coord[,1:nb_axe])
colnames(res_umap$layout)=paste0("UMAP",1:2)

data_plot2=merge(data_plot,res_umap$layout,by.x="Row.names",by.y="row.names")
ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  scale_color_manual(values=col_label)+theme_bw() 
ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = clustering)) +
  theme_bw() 


ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = UWI)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle("UWI")


ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = WER)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle("WER")

ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = dm)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle("dm")

