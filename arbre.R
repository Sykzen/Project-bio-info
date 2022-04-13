if (!requireNamespace("BiocManager", quietly = TRUE))
   install.packages("BiocManager")
BiocManager::install("SNPRelate")

install.packages("ape")
install.packages("RColorBrewer")
library(gdsfmt)
library("SNPRelate") # pour charger les donner et les manipuler
library(ape) # pour faire des arbres
library(RColorBrewer) 
file="SNP_PASS"
ofile=paste(file,".gds",sep="")
ifile=paste(file,".vcf.gz",sep="")
snpgdsVCF2GDS(ifile, ofile,verbose=TRUE)
genofile <- snpgdsOpen(ofile)
## A propos des échantillons ##
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))
n <- 26
qual.col.pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col.vector = unlist(mapply(brewer.pal, qual.col.pals$maxcolors, rownames(qual_col_pals)))[1:n]
#HCCluster permet de déterminer les groupes par permutation (Z threshold: 15, outlier threshold: 5):
ibs.hc <- snpgdsHCluster(snpgdsIBS(genofile, num.thread=2, autosome.only=FALSE))

## On peut indiquer des groupes prédéfinis (comme dans l'article) avec l'option samp.group=
rv <- snpgdsCutTree(ibs.hc ,col.list=col.vector)
pdf(paste(file,"_Arbre.pdf",sep=""),height=250)
 plot(rv$dendogram, main="Arbre selon IBS", horiz=T)

  legend("topright", 
         legend=sample.id, 
         col=col.vector, 
         pch=19, 
         ncol=2) # associe le nom de l'échantillon à la couleur du vecteur, on la place en haut à droite
dev.off()