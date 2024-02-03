setwd("C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2")
library(dplyr)
library(FactoMineR)
library(factoextra)
library(ggrepel)
library(umap)
library(pheatmap)

# functions to compute coeff ####
coeffBatch=function(x,batch=batch) {
  
  design = matrix(1, nrow(x), 1)
  
  batch <- as.factor(batch)
  contrasts(batch) <- contr.sum(levels(batch))
  batch <- model.matrix(~batch)[, -1, drop = FALSE]
  rownames( batch)=rownames(x)
  
  fit <- limma::lmFit(t(x), cbind(design, batch))
  beta <- fit$coefficients[, -(1:ncol(design)), drop = FALSE]
  beta[is.na(beta)] <- 0
  return(beta)
  
}



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
data=data.frame(data)


# Reference ammonites ####
ref.df=openxlsx::read.xlsx("references.xlsx")
ref.df$Numéro=as.character(ref.df$Numéro)
ref.df=ref.df[ref.df$Numéro%in%rownames(data),]
notParanideri=ref.df$Numéro[ref.df$Parandieri=="Non"]
data=data[!rownames(data)%in%notParanideri,]
ref.df=ref.df[ref.df$Parandieri=="Oui",]

# Computing ratios ####
data=data.frame(data)
data$UWI=data$uw/data$dm #evolution
data$WWI=data$ww/data$wh #dépression
data$WHI=data$wh/data$dm # Whorld height index 
data$Shape = data$ww/data$dm # Shape
data$WER =  (data$dm/(data$dm-data$wh))^2 #Whorl expansion rate 
data$o=data$e/data$dm #ornementations



# harmoniser ####
HC_JDS=ref.df[ref.df$Source%in%c("HC","JSD"),"Numéro"]
data$DirectMeasure="No"
data[as.numeric(rownames(data))>=500,"DirectMeasure"]="Yes"
data[HC_JDS,"DirectMeasure"]="No"

varToCorrect=c("UWI","WWI","WHI","Shape","WER")
varToCorrect=c("WWI","Shape")
data0=data
x=as.matrix(data0[,varToCorrect])
batch=data0$DirectMeasure
data[,varToCorrect]=t(limma::removeBatchEffect(t(x), batch=batch))


beta=coeffBatch(x,batch=batch)

boxplot(data0$UWI~data0$DirectMeasure)
boxplot(data$UWI~data$DirectMeasure)

boxplot(data0$o~data0$DirectMeasure)
boxplot(data$o~data$DirectMeasure)

#test
data2=data0
x=as.matrix(data2[,varToCorrect])
batch2 <- as.factor(batch)
contrasts(batch2) <- contr.sum(levels(batch2))
batch2 <- model.matrix(~batch2)[, -1, drop = FALSE]
rownames( batch2)=rownames(x)

data2[,varToCorrect]=t(as.matrix(t(x)) - beta %*% t(batch2))
boxplot(data2$UWI~data2$DirectMeasure)
boxplot(data0$UWI~data0$DirectMeasure)
#c'est bon !
saveRDS(beta,"C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2/shiny/midOxfPeri/beta.RDS")




# Labeling ammonites ####
data$label="?"
data[as.character(ref.df$Numéro),"label"]=ref.df$Espèce_dim
data$label2="?"
data[as.character(ref.df$Numéro),"label2"]=ref.df$Name


# Personal identification (may be wrong !!)
# data["1","label"]="Sub_Dic?"
# data["2","label"]="Sub_Dic?"
# data["16","label"]="Sub_Dic?"
# data["3","label"]="Oto?"
# data["7","label"]="Oto?"
# data["8","label"]="Oto?"
# data["11","label"]="Oto?"
# data["13","label"]="Oto?"
# data["14","label"]="Oto?"
# data["19","label"]="Pass?"
# data["21","label"]="Oto?"
# data["35","label"]="Pass?"
# data["23","label"]="Pass?"
# data["48","label"]="Oto?"
# data["5","label"]="Dic?"
# data["10","label"]="Dic?"

# Colors of labels ####
col_label=hues::iwanthue(n=length(unique(data$label))) %>% setNames(unique(data$label))
col_cl0=c( yellow = "#f3c300", purple = "#875692", 
         orange = "#f38400", lightblue = "#a1caf1", red = "#be0032", buff = "#c2b280", 
         gray = "#848482", green = "#008856", purplishpink = "#e68fac", 
         blue = "#0067a5", yellowishpink = "#f99379", violet = "#604e97", 
         orangeyellow = "#f6a600", purplishred = "#b3446c", greenishyellow = "#dcd300", 
         reddishbrown = "#882d17", yellowgreen = "#8db600", yellowishbrown = "#654522", 
         reddishorange = "#e25822", olivegreen = "#2b3d26")  %>% setNames(paste0("cl",1:20))
col_cl0=c(col_cl0,'Ref'="gray10")




# Selecting variables for PCA + scaling ####
sel_var=c("dm","WWI","WER","UWI","Shape","WHI","o")
data_pca=data[,sel_var]
data_pca=scale(data_pca) %>% data.frame()

# Heatmap  #####
annotation_col=data[,"label",drop=FALSE]
pheatmap(t(data_pca), cutree_cols = 4, cutree_rows = 4,
         annotation_col=annotation_col,
         annotation_color=list(label=col_label))

# PCA #####
ref=which(as.numeric(rownames(data_pca))>=500) # identification of ref points
mine=which(as.numeric(rownames(data_pca))<500)
res.pca=PCA(data_pca,graph = FALSE)
pc_var=cumsum(res.pca$eig[,2])
nb_axe=min(which(pc_var>80))

plot(res.pca,choix="var")
plot(res.pca,c(1,3),choix="var")

pca.coord=rbind(res.pca$ind$coord,res.pca$ind.sup$coord)
data_plot=merge(pca.coord,data,by="row.names") %>%
  data.frame()
data_plot$names=data_plot$Row.names
data_plot$names[as.numeric(data_plot$Row.names)>=500]=data_plot$label2[as.numeric(data_plot$Row.names)>=500]
rownames(data_plot)=data_plot$Row.names

pheatmap(t(pca.coord),annotation_col=annotation_col,
         annotation_color=list(label=col_label))

data_ref=data_plot[data_plot$label2!="?",]
rownames(ref.df)=ref.df$Numéro
data_ref$Genre=ref.df[rownames(data_ref),"Genre"]
cols=as.numeric(as.factor(data_ref$Genre))
h=data_ref$Dim.1 %>% setNames(make.names(data_ref$label,unique=TRUE))
barplot(sort(h), col=cols[order(h)], las=2)
h=data_ref$Dim.2 %>% setNames(make.names(data_ref$label,unique=TRUE))
barplot(sort(h), col=cols[order(h)], las=2)

ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = UWI)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle("UWI")

ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+
  geom_text(hjust=0, vjust=0,aes(color = dm)) +
  scale_color_gradient(low="blue",  high="red")+theme_bw() +
  ggtitle("dm")


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
col_cl=col_cl0[c(paste0("cl",1:k),"Ref")]

clustering=(FUNcluster(pca.coord[,1:nb_axe],k=k))$cluster
names(clustering)=rownames(pca.coord)
annotation_col$clustering=paste0("cl",clustering[rownames(annotation_col)])
annotation_col$clustering[annotation_col$clustering=="clNA"]="Ref"
pheatmap(t(pca.coord[,1:nb_axe]), 
         cutree_cols = k,clustering_method="ward.D2",
         annotation_col=annotation_col,
         annotation_color=list(label=col_label, clustering=col_cl))


data_plot$clustering=paste0("cl",clustering[data_plot$Row.names])
data_plot$clustering[data_plot$clustering=="clNA"]="Ref"

ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  scale_color_manual(values=col_cl) +
  geom_text(hjust=0, vjust=0,aes(color = clustering)) +
  theme_bw() 
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  scale_color_manual(values=col_label) +
  theme_bw() 
ggplot(data_plot,aes(x=Dim.1,y=Dim.2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = dm)) +
  theme_bw() 

# Median per cluster ####
data2=data
data2$Involution=max(data2$UWI)-data2$UWI
data2$densite=max(data2$o)-data2$o
Names_var=c("dm"="Taille de la coquille", 
            "Involution"="Niveau d'involution", 
            "Shape"="Epaisseur de la coquille", 
            "WER"="Taux d'augmentation du diamètre de la coquille par tour",
            "densite"="Densité de la costulation")
unite=c("dm"="cm", 
        "Involution"="1 - taille_ombilic/taille totale", 
        "Shape"="cm/cm", 
        "WER"="cm/cm",
        "densite"="cm/cm")


med=apply(data_pca, 2, FUN=function(x) {
  medx=aggregate(x,by=list(clustering[rownames(data_pca)]),FUN=median)[,2] %>%
    setNames(paste0("cl",1:k))
  return(medx)
})
annot_cl=paste0("cl",unique(clustering)) %>% setNames(paste0("cl",unique(clustering))) %>% data.frame()
colnames(annot_cl)="cluster"
pheatmap(t(scale(med)),
         annotation_col=annot_cl,
         annotation_colors = list(cluster=col_cl))




# Umap ####
res_umap=umap(pca.coord[,1:nb_axe])
colnames(res_umap$layout)=paste0("UMAP",1:2)

data_plot2=merge(data_plot,res_umap$layout,by.x="Row.names",by.y="row.names")
rownames(data_plot2)=data_plot2$Row.names


# Bootrapping ####
pc=0.7
R=500

boot=matrix(0,nrow=nrow(pca.coord),ncol=nrow(pca.coord))
for (r in 1:R) {
  set.seed(r)
  index_r=sample(rownames(pca.coord),round(pc*nrow(pca.coord)))
  clustering_r=(FUNcluster(pca.coord[index_r,1:nb_axe],k=k))$cluster
  boot_r=matrix(0,nrow=nrow(pca.coord),ncol=nrow(pca.coord))
  colnames(boot_r)=rownames(boot_r)=rownames(pca.coord)
  for (clr in clustering_r) {
    ind_cl=index_r[clustering_r==clr]
    boot_r[ind_cl,ind_cl]=1

  }
  boot=boot+boot_r
 # print(max(boot))
}
colnames(boot)=rownames(boot)=rownames(pca.coord)
nb_cl=apply(boot,1,max)
boot2=boot/nb_cl
diag(boot2)
colnames(boot2)=rownames(boot2)=rownames(pca.coord)
pheatmap(boot2, clustering_method="ward.D2")
fviz_nbclust(boot2, FUNcluster, method = "silhouette")+ theme_classic()
clustering_boot=paste0("cl",(FUNcluster(boot2,k=6))$cluster) %>% setNames(rownames(pca.coord))
col_cl2=col_cl0[unique(clustering_boot)]
pheatmap(boot2, clustering_method="ward.D2",
         annotation_col=data.frame(clustering_boot),
         annotation_colors = list(clustering_boot=col_cl2))
data_plot2$clustering_boot=clustering_boot[data_plot2$Row.names]
data_plot2$clustering_boot[is.na(data_plot2$clustering_boot)]="Ref"

ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = data_plot2$clustering_boot),size=4) +
  theme_bw()  +
  scale_color_manual(values=col_cl2) 


ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  geom_text(hjust=0, vjust=0,aes(color = UWI)) +
  theme_bw() + scale_color_gradientn(colors=c("blue","yellow","red"))

# ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
#   geom_text(hjust=0, vjust=0,aes(color = UWI)) +
#   theme_bw() + 
#   scale_colour_stepsn(colors=c("blue","yellow","red"))

  # ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  # geom_text(hjust=0, vjust=0,aes(color = dm)) +
  # theme_bw() + 
  #   scale_colour_stepsn(colors=c("blue","yellow","red"))
    
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = dm)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red"))

  # ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #   geom_text(hjust=0, vjust=0,aes(color = o)) +
  #   theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red")) 
  
  
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = o)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red"))
  
  
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = Shape)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red")) 
  
  
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = Dim.1)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red")) 
  
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = Dim.2)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red")) 
  
  ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
    geom_text(hjust=0, vjust=0,aes(color = Dim.3)) +
    theme_bw() +   scale_color_gradientn(colors=c("blue","yellow","red")) 
  
ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = label)) +
  theme_bw()  +
  scale_color_manual(values=col_label)


ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  #geom_point(aes(color = value,size=5))+ 
  geom_text(hjust=0, vjust=0,aes(color = data_plot2$clustering_boot),size=4) +
  theme_bw()  +
  scale_color_manual(values=col_cl2) 


ggplot(data_plot2,
       aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
  geom_point(aes(color = dm)) +
  #geom_text(hjust=0, vjust=0,aes(color = value)) +
  theme_bw()+ 
  geom_text_repel(data=data_plot2[rownames(data_ref),],aes(label=label))



rgl::plot3d(data_plot2$Dim.1,data_plot2$Dim.2,data_plot2$Dim.3,
            col=col_cl2[(data_plot2$clustering_boot)],
            size=10
            )


rgl::plot3d(data_plot2$UWI,data_plot2$dm,data_plot2$o,
            col=col_cl2[(data_plot2$clustering_boot)],
            size=10
)




med=apply(data_pca, 2, FUN=function(x) {
  k=length(unique(clustering_boot[rownames(data_pca)[cond]]))
  medx=aggregate(x,by=list(clustering_boot[rownames(data_pca)]),FUN=median)[,2] %>%
    setNames(paste0("cl",1:k))
  return(medx)
})
annot_cl=unique(clustering_boot) %>% 
  setNames(paste0(unique(clustering_boot))) %>% data.frame()
colnames(annot_cl)="cluster"
pheatmap(t(scale(med)),
         annotation_col=annot_cl,
         annotation_colors = list(cluster=col_cl2))

cond=(1:nrow(data_pca))[!1:nrow(data_pca)%in%ref]
med2=apply(data_pca[cond,], 2, FUN=function(x) {
  k=length(unique(clustering_boot[rownames(data_pca)[cond]]))
  medx=aggregate(x,by=list(clustering_boot[rownames(data_pca)[cond]]),FUN=median)[,2] %>%
    setNames(paste0("cl",1:k))
  return(medx)
})
annot_cl=unique(clustering_boot) %>% 
  setNames(paste0(unique(clustering_boot))) %>% data.frame()
colnames(annot_cl)="cluster"
pheatmap(t(scale(med2)),
         annotation_col=annot_cl,
         annotation_colors = list(cluster=col_cl2))


# Boxplot ####


for (v in names(Names_var)) {
  boxplot(data2[,v]~clustering_boot[rownames(data_pca)],
          main=Names_var[v], xlab="", ylab=unite[v],
          col=col_cl)
  
}


# Organizing pictures in function of clusters ####
unlink("Clusters_pictures",recursive = TRUE)
dir.create("Clusters_pictures")
for (cl in unique(clustering_boot)) {
  dir.create(paste0("Clusters_pictures/",cl))
  Number_cl=data_plot2[data_plot2$clustering_boot==cl,"Row.names"]
  for (n in Number_cl) {
    nb_0=3-nchar(n)
    d=paste0("./Ammonite",paste0(rep(0,nb_0),collapse=""),n)
    pics=c(list.files(d)[grep(".jpg",list.files(d))],
           list.files(d)[grep(".png",list.files(d))])
    To_vec=c()
    for (i in 1:length(pics)) {
      from=paste0(d,"/",pics[i])
      
      to=paste0(d,"/ammonite",paste0(rep(0,nb_0),collapse=""),n,letters[i],".jpg")
      To_vec=c(To_vec,to)
      file.rename(from, to)
    }
    tofiles=  gsub(paste0(d,"/"),paste0("Clusters_pictures/",cl,"/"),To_vec)
    file.copy(To_vec,tofiles)
    
  }

}


# 
# # Bootrapping with ref ####
# pc=0.7
# R=500
# boot=matrix(0,nrow=nrow(pca.coord),ncol=nrow(pca.coord))
# for (r in 1:R) {
#   index_r=sample(rownames(pca.coord),round(pc*nrow(pca.coord)))
#   clustering_r=(FUNcluster(pca.coord[index_r,1:nb_axe],k=k))$cluster
#   boot_r=matrix(0,nrow=nrow(pca.coord),ncol=nrow(pca.coord))
#   colnames(boot_r)=rownames(boot_r)=rownames(pca.coord)
#   for (clr in clustering_r) {
#     ind_cl=index_r[clustering_r==clr]
#     boot_r[ind_cl,ind_cl]=1
#     
#   }
#   boot=boot+boot_r
#   print(max(boot))
# }
# colnames(boot)=rownames(boot)=rownames(pca.coord)
# nb_cl=apply(boot,1,max)
# boot2=boot/nb_cl
# diag(boot2)
# colnames(boot2)=rownames(boot2)=rownames(pca.coord[,1:nb_axe])
# pheatmap(boot2, clustering_method="ward.D2")
# fviz_nbclust(boot2, FUNcluster, method = "silhouette")+ theme_classic()
# clustering_boot=paste0("cl",(FUNcluster(boot2,k=10))$cluster) %>% setNames(rownames(pca.coord))
# col_cl2=c(col_cl0[unique(clustering_boot)],Ref="gray10")
# pheatmap(boot2, clustering_method="ward.D2",
#          annotation_col=data.frame(clustering_boot),
#          annotation_colors = list(clustering_boot=col_cl2))
# data_plot2$clustering_boot=clustering_boot[data_plot2$Row.names]
# data_plot2$clustering_boot[is.na(data_plot2$clustering_boot)]="Ref"
# ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
#   #geom_point(aes(color = value,size=5))+ 
#   geom_text(hjust=0, vjust=0,aes(color = clustering_boot)) +
#   theme_bw()  +
#   scale_color_manual(values=col_cl2)
# ggplot(data_plot2,aes(x=UMAP1,y=UMAP2,label=names,size=5)) +
#   #geom_point(aes(color = value,size=5))+ 
#   geom_text(hjust=0, vjust=0,aes(color = label)) +
#   theme_bw()  +
#   scale_color_manual(values=col_label)

# Saving files
saveRDS(data_plot2,"C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2/shiny/midOxfPeri/data.RDS")
saveRDS(res_umap,"C:/Users/nebet/Documents/Fossiles/Oxfordien du Poitou/Photos 2/shiny/midOxfPeri/res_umap0.RDS")
