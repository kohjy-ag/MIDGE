args <- commandArgs(TRUE)

input <- args[1]	#"ha90_results.aln"	#"ha_results.aln"	#"results.aln"
title <- args[2]	#"Heatmap haplotypes_reservoirs 90% cluster"	#"Heatmap haplotypes_reservoirs"	#"Heatmap of N030_midge"
output <- args[3]		#"heatmap_haplotypes_reservoirs_90.pdf"	#"heatmap_haplotypes_reservoirs.pdf"	#"heatmap_N030_midge.pdf"

data=read.table(input,header=F)[,1:3]

data2=data[,c(2,1,3)]	#symmetry
colnames(data2)=colnames(data)

data=rbind(data,data2)
data=data[with(data, order(V1, V2)), ]
data=data[!duplicated(data), ]

library(reshape2)
library(gplots)
abc=dcast(data, V2~V1)

rn=abc[,1]
abc=abc[,-1]
abc = sapply(abc, as.numeric)
rownames(abc)=rn
abc[is.na(abc)] <- 100

###THIS PART IS OPTIONAL
#rownames(abc)[rownames(abc)!="cp45932minion_usr_motu3_4seq"]=""
#rownames(abc)[rownames(abc)=="cp45932minion_usr_motu3_4seq"]="Singleton MOTU3"
#colnames(abc)[colnames(abc)!="cp45932minion_usr_motu3_4seq"]=""
#colnames(abc)[colnames(abc)=="cp45932minion_usr_motu3_4seq"]=""


my_palette <- colorRampPalette(c("white", "yellow", "red"))(n = 1000)
pdf(output)
par(cex.main=0.7)
heatmap.2(abc,main=title,scale="none",
                                  
                                  #For the tree
                                  dendrogram = "row", 
                                  hclustfun = function(x) hclust(x,method = 'complete'),
                                  distfun = function(x) dist(x,method = 'euclidean'),
                                  #cellnote=as.matrix(abc),notecol="black",notecex=1,
                                  margins =c(5,5),
                                  col=my_palette,
				  density.info="none", trace="none")



dev.off()

