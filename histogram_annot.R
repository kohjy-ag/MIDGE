args<-commandArgs(TRUE)

outdir = args[3]
input=paste(outdir,"/ha_mapprofile_MOTUadded.txt.sorted_tmp",sep="")
output = args[1]
cluster_perc = args[2]
title=paste("Proportion of reads mapped to reference with MOTU (clustered at ",cluster_perc,"%)",sep="")

data=read.table(input,header=F)

#cols=c("violetred","springgreen","yellow",rep("slategray1",nrow(data)-4))	#TO UPDATE ##"turquoise2"
cols <- ifelse(data[,2] == "Tanytarsus_oscillans", "violetred",
		ifelse(data[,2] == "Tanytarsus_formosanus", "springgreen",
			ifelse(data[,2] == "MOTU3", "yellow","slategray1")))

pdf(output)
par(mar=c(7.1,4.1,2,2.1))
barplot(data$V1/sum(data$V1),names.arg=data$V2,las=2,cex.names=0.4,main=title,cex.axis=1.2,col=cols)
dev.off() 
