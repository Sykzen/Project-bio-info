# R script pour faire des distributions
# !/usr/bin/env Rscript
library(lattice)
library(VennDiagram)

# LECTURE DU FICHIER
annot.file <- "export_slim_buster/bcftools_query_devcf.txt"
annotations <- read.table(annot.file, h = FALSE, na.strings = ".")
colnames(annotations) <- c("CHROM", "POS", "REF", "ALT", "QD", "FS", "MQ", "MQRankSum", "ReadPosRankSum", "SOR")

# INITIALISATION DES SEUILS
lim.QD <- 18
lim.FS <- 0
lim.MQRankSum <- 0.5
lim.MQ <- 62
lim.ReadPosRankSum <- 3
lim.SOR <- 0

# CREATION DES FIGURES
pdf(paste(annot.file, "Filtres_.pdf", sep = " "))
## FIGURE DE QD
prop.QD <- length(which(annotations$QD > lim.QD)) / nrow(annotations)
plot(density(annotations$QD, na.rm = T), main = "QD", sub = paste("Filtre: QD >", lim.QD, "( = ", signif(prop.QD, 3), "% des SNP) ", sep = ""))
abline(v = lim.QD, col = "red")



## FIGURE DE FS
prop.FS <- length(which(annotations$FS > lim.FS)) / nrow(annotations)
plot(density(annotations$FS, na.rm = T), main = "FS", sub = paste("Filtre: FS >", lim.FS, "( = ", signif(prop.FS, 3), "% des SNP) ", sep = ""))
abline(v = lim.FS, col = "red")



## FIGURE DE MQRankSum
prop.MQRankSum <- length(which(annotations$MQRankSum < lim.MQRankSum)) / nrow(annotations)
plot(density(annotations$MQRankSum, na.rm = T), main = "MQRankSum", sub = paste("Filtre: MQRankSum <", lim.MQRankSum, "( = ", signif(prop.MQRankSum, 3), "% des SNP) ", sep = ""))
abline(v = lim.MQRankSum, col = "red")

## FIGURE DE MQ
prop.MQ <- length(which(annotations$MQ < lim.MQ)) / nrow(annotations)
plot(density(annotations$MQ, na.rm = T), main = "MQ", sub = paste("Filtre: MQ <", lim.MQ, "( = ", signif(prop.MQ, 3), "% des SNP) ", sep = ""))
abline(v = lim.MQ, col = "red")
## FIGURE DE ReadPosRankSum
prop.ReadPosRankSum <- length(which(annotations$ReadPosRankSum < lim.ReadPosRankSum)) / nrow(annotations)
plot(density(annotations$ReadPosRankSum, na.rm = T), main = "ReadPosRankSum", sub = paste("Filtre: ReadPosRankSum <", lim.ReadPosRankSum, "( = ", signif(prop.ReadPosRankSum, 3), "% des SNP) ", sep = ""))
abline(v = lim.ReadPosRankSum, col = "red")


## FIGURE DE SOR
prop.SOR <- length(which(annotations$SOR > lim.SOR)) / nrow(annotations)
plot(density(annotations$SOR, na.rm = T), main = "SOR", sub = paste("Filtre: SOR >", lim.SOR, "( = ", signif(prop.SOR, 3), "% des SNP) ", sep = ""))
abline(v = lim.SOR, col = "red")
dev.off()

# DIAGRAMME DE VENN
qd.pass <- which(annotations$QD > lim.QD)
fs.pass <- which(annotations$FS > lim.FS)
sor.pass <- which(annotations$SOR > lim.SOR)
mq.pass <- which(annotations$MQ < lim.MQ)
mqrs.pass <- which(annotations$MQRankSum < lim.MQRankSum)
rprs.pass <- which(annotations$ReadPosRankSum < lim.ReadPosRankSum)

# un diagramme de Venn ne prend que 5 catégories, il faudra peut etre en faire plusieurs. Voici un exemple
venn.diagram(
  x = list(qd.pass, fs.pass, mq.pass, sor.pass, rprs.pass),
  category.names = c("QD", "FS", "MQ", "SOR", "ReadPosRankSum"),
  fill = c("blue", "darkgreen", "orange", "yellow", "red"),
  output = TRUE,
  filename = "MondiagrammedeVenn.png"
)
venn.diagram(
  x = list(qd.pass, rprs.pass, mq.pass, sor.pass, mqrs.pass),
  category.names = c("QD", "ReadPosRankSum", "MQ", "SOR", "MQRanksSum"),
  fill = c("blue", "darkgreen", "orange", "yellow", "red"),
  output = TRUE,
  filename = "MondiagrammedeVenn_sor.png"
)
venn.diagram(
  x = list(qd.pass, fs.pass, mq.pass, rprs.pass, mqrs.pass),
  category.names = c("QD", "FS", "MQ", "ReadPosRankSum", "MQRanksSum"),
  fill = c("blue", "#23ca23", "orange", "yellow", "red"),
  output = TRUE,
  filename = "MondiagrammedeVenn_alpine.png"
)