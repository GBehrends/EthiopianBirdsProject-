# Install required packages
install.packages("matrixStats")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("adegenet")
install.packages("vcfR")
install.packages("combinat")
install.packages("dartR")
install.packages("knitr")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("gdsfmt")
BiocManager::install("SNPRelate")

library(dplyr)
library(vcfR)
library(ggplot2)
library(matrixStats)
library(adegenet)
library(combinat)
library(dartR)
library(knitr)
library(BiocManager)
library(gdsfmt)
library(SNPRelate)
library(beepr)
library(stringi)
library(stringr)
 
# Make Genlight Object
Cossypha_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Cossypha_semirufa_NoAZ_QUAL20.vcf", verbose = 2)
Serinus_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Serinus_tristriatus_NoAZ_QUAL20.vcf", verbose = 2)
Melaenornis_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Melaenornis_chocolatinus_NoAZ_QUAL20.vcf", verbose = 2)
Zosterops_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Zosterops_poliogastrus_NoAZ_QUAL20.vcf", verbose = 2)
Turdus_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Turdus_abyssinicus_NoAZ_QUAL20.vcf", verbose = 2)
Parophasma_Genlight_Fst <- gl.read.vcf("/Volumes/T7/Scripts and Data/Fst/NewRef_Concat/Parophasma_galinieri_NoAZ_QUAL20.vcf", verbose = 2)


# Set population info for each species' individuals in Genlight object.  
pop(Cossypha_Genlight_Fst)<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 
ploidy(Cossypha_Genlight_Fst) <- 2

pop(Parophasma_Genlight_Fst)<- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 
ploidy(Parophasma_Genlight_Fst) <- 2

pop(Melaenornis_Genlight_Fst)<- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Bale Mountains", "Choke Mountains")) 
ploidy(Melaenornis_Genlight_Fst) <- 2

pop(Serinus_Genlight_Fst)<- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Choke Mountains", "Choke Mountains", "Choke Mountains")) 
ploidy(Serinus_Genlight_Fst) <- 2

pop(Turdus_Genlight_Fst)<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 
ploidy(Turdus_Genlight_Fst) <- 2

pop(Zosterops_Genlight_Fst)<- as.factor(c("Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Bale Mountains", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 
ploidy(Zosterops_Genlight_Fst) <- 2


____________________________________________________________________________________________________________________________________________________________________________________________________

### Jessica Rick Reich's FST Function ###
## Sourced from https://github.com/jessicarick/reich-fst

## reich fst estimator
## vectorized version
## input=genlight object
## FST will be calculated between pops in genlight object
## specify number of bootstraps using "bootstrap=100"

reich.fst <- function(gl, bootstrap=FALSE, plot=FALSE, verbose=TRUE) { 
  if (!require("matrixStats",character.only=T, quietly=T)) {
    install.packages("matrixStats")
    library(matrixStats, character.only=T)
  }
  if (!require("dplyr",character.only=T, quietly=T)) {
    install.packages("dplyr")
    library(dplyr, character.only=T)
  }
  
  nloc <- gl@n.loc
  npop <- length(levels(gl@pop))
  
  fsts <- matrix(nrow=npop,
                 ncol=npop,
                 dimnames=list(levels(gl@pop),levels(gl@pop)))
  
  if (bootstrap != FALSE){
    n.bs <- bootstrap
    bs <- data.frame(matrix(nrow=nrow(combinat::combn2(levels(gl@pop))),
                            ncol=n.bs+5))
  }
  
  k <- 0
  
  for (p1 in levels(gl@pop)){
    for (p2 in levels(gl@pop)){
      if (which(levels(gl@pop) == p1) < which(levels(gl@pop) == p2)) {
        k <- 1+k
        
        pop1 <- gl.keep.pop(gl, p1, mono.rm=FALSE, v=0)
        pop2 <- gl.keep.pop(gl, p2, mono.rm=FALSE, v=0)
        
        a1 <- colSums2(as.matrix(pop1),na.rm=T)
        a2 <- colSums2(as.matrix(pop2),na.rm=T)
        n1 <- apply(as.matrix(pop1),2,function(x) 2*sum(!is.na(x)))
        n2 <- apply(as.matrix(pop2),2,function(x) 2*sum(!is.na(x)))
        
        h1 <- (a1*(n1-a1))/(n1*(n1-1))
        h2 <- (a2*(n2-a2))/(n2*(n2-1))
        
        N <- (a1/n1 - a2/n2)^2 - h1/n1 - h2/n2
        D <- N + h1 + h2
        
        F <- sum(N, na.rm=T)/sum(D, na.rm=T)
        fsts[p2,p1] <- F
        if (verbose == TRUE) {
          print(paste("Pop1: ",p1,", Pop2: ",p2,", Reich FST: ",F,sep=""))
        }
        
        if (bootstrap != FALSE) {
          if (verbose == TRUE) {
            print("beginning bootstrapping")
          }
          
          bs[k,1:3] <- c(p2,p1,as.numeric(F))
          
          for (i in 1:n.bs){
            loci <- sample((1:nloc), nloc, replace=TRUE)
            
            pop1.bs <- matrix(as.matrix(pop1)[,loci],
                              ncol=length(loci))
            pop2.bs <- matrix(as.matrix(pop2)[,loci],
                              ncol=length(loci))
            
            a1 <- colSums2(as.matrix(pop1.bs),na.rm=T)
            a2 <- colSums2(as.matrix(pop2.bs),na.rm=T)
            n1 <- apply(as.matrix(pop1.bs),2,function(x) 2*sum(!is.na(x)))
            n2 <- apply(as.matrix(pop2.bs),2,function(x) 2*sum(!is.na(x)))
            
            h1 <- (a1*(n1-a1))/(n1*(n1-1))
            h2 <- (a2*(n2-a2))/(n2*(n2-1))
            
            N <- (a1/n1 - a2/n2)^2 - h1/n1 - h2/n2
            D <- N + h1 + h2
            
            F.bs <- sum(N, na.rm=T)/sum(D, na.rm=T)
            bs[k,i+5] <- F.bs
          }
          if (verbose == TRUE){
            print(paste("bootstrapping 95% CI: ",
                        quantile(bs[k,6:(n.bs+5)],0.025,na.rm=T),"-",
                        quantile(bs[k,6:(n.bs+5)],0.975,na.rm=T)))
          }
          
          bs[k,4:5] <- c(quantile(bs[k,6:(n.bs+5)],0.025,na.rm=T),
                         quantile(bs[k,6:(n.bs+5)],0.975,na.rm=T))
        }
        
      }
    }
  }
  
  fsts[fsts < 0] <- 0
  
  if (bootstrap != FALSE){
    colnames(bs)[1:5] <- c("pop1","pop2","fst_estimate","min_CI","max_CI")
    fst.list <- list(fsts,bs)
    names(fst.list) <- c("fsts","bootstraps")
    
    if (plot == TRUE){
      print("drawing plot with bootstraps")
      
      if (!require("ggplot2",character.only=T, quietly=T)) {
        install.packages("ggplot2")
        library(ggplot2, character.only=T)
      }
      
      plot.data <- bs[,1:5]
      plot.data$fst_estimate <- as.numeric(plot.data$fst_estimate)
      plot.data$min_CI <- as.numeric(plot.data$min_CI)
      plot.data$max_CI <- as.numeric(plot.data$max_CI)
      plot.data$pop_pair <- paste(plot.data$pop1,plot.data$pop2,sep="_")
      plot.data$signif <- case_when(plot.data$min_CI > 0 ~ TRUE,
                                    TRUE ~ FALSE)
      
      
      bs.plot <- ggplot(plot.data, aes(x=pop_pair,y=fst_estimate,col=signif)) + 
        geom_point(size=2) + 
        coord_flip() + 
        geom_errorbar(aes(ymin=min_CI,ymax=max_CI),width=0.1,size=1) + 
        geom_hline(yintercept=0, lty=2, lwd=1, col="gray50") + 
        theme_minimal() + 
        theme(legend.position="none")
      
      print(bs.plot)
    }
  } else {
    fst.list <- list(fsts)
    names(fst.list) <- "fsts"
    
    if (plot == TRUE){
      print("drawing plot without bootstraps")
      
      if (!require("ggplot2",character.only=T, quietly=T)) {
        install.packages("ggplot2")
        library(ggplot2, character.only=T)
      }
      
      plot.data <- data.frame(combinat::combn2(row.names(fsts)),
                              fst_estimate=fsts[lower.tri(fsts)])
      plot.data$pop_pair <- paste(plot.data$X1,plot.data$X2,sep="_")
      
      fst.plot <- ggplot(plot.data, aes(x=pop_pair,y=fst_estimate)) + 
        geom_point(size=2) + 
        coord_flip() + 
        geom_hline(yintercept=0, lty=2, lwd=1, col="gray50") + 
        theme_minimal() + 
        theme(legend.position="none")
      
      print(fst.plot)
    }
  }
  
  return(fst.list)
  
  beepr::beep()
}


# Run Reich's Fst for Genlights
Zost_FST <- reich.fst(Zosterops_Genlight_Fst, bootstrap = FALSE, plot = TRUE)
Seri_FST <- reich.fst(Serinus_Genlight_Fst, bootstrap = FALSE, plot = TRUE)
Turd_FST <- reich.fst(Turdus_Genlight_Fst, bootstrap = FALSE, plot = TRUE)
Paro_FST <- reich.fst(Parophasma_Genlight_Fst, bootstrap = FALSE, plot = TRUE)
Mela_FST <- reich.fst(Melaenornis_Genlight_Fst, bootstrap = FALSE, plot = TRUE)
Coss_FST <- reich.fst(Cossypha_Genlight_Fst, bootstrap = FALSE, plot = TRUE)


library(tibble)
## Making table for plotting. My population pairs were separated by the Blue Nile Valley (BNV) and Great Rift Valley (GRV).    
Fst_Table <- NULL
Fst_List <- ls(pattern = "FST$", all.names = T)
for (x in 1:length(Fst_List)) {
  name <- str_remove(Fst_List[x], "_FST")
  t <- as.data.frame(get(Fst_List[x]))
  GRV <- cbind(name, t[3,1])
  BNV <- cbind(name, t[3,2])
  t <- rbind.data.frame(GRV, BNV)
  rownames(t) <-c("GRV", "BNV")
  assign(paste0(Fst_List[x], "_Plot"), t)
  Fst_Table <- rbind.data.frame(Fst_Table, t)
}
Fst_Table <- rownames_to_column(Fst_Table)
colnames(Fst_Table) <- c("Barrier", "Species", "FST")
Fst_Table$Barrier <- str_remove(Fst_Table$Barrier, "[:digit:]")
Fst_Table$FST <- as.numeric(Fst_Table$FST)



library(ggtext)
library(RColorBrewer)
setwd("/Users/garrettbehrends/Desktop/untitled folder")

# PLot line graphs with various symbols representing species 
pdf(file = "NoAZ_QUAL20_FST_Line2.pdf", height = 12, width = 10)
ggplot(Fst_Table, aes(x = Barrier, y = FST, color = Species, shape = Species)) + 
  theme_bw() +
  labs(y = expression(F[ST])) + 
  theme(text = element_text(size=20)) +
  scale_shape_manual(values=c(15, 16, 17, 18, 19, 20),
                     labels = c( expression(italic("C. semirufa")), expression(italic("M. chocolatinus")), 
                                 expression(italic("P. galinieri")), expression(italic("C. tristriata")), 
                                 expression(italic("T. abyssinicus")), expression(italic("Z. poliogastrus")))) +
  scale_color_manual(values = c("grey62", "darkorchid4", "grey19", "darkolivegreen4", "wheat3", "lightsalmon4"),
                     labels = c( expression(italic("C. semirufa")), expression(italic("M. chocolatinus")), 
                                 expression(italic("P. galinieri")), expression(italic("C. tristriata")), 
                                 expression(italic("T. abyssinicus")), expression(italic("Z. poliogastrus")))) +
  geom_point(size = 15, alpha = 0.95, aes(shape = Species)) + 
  geom_line(aes(group = Species, color = Species), size = 2.5, show.legend = FALSE) +
  scale_y_continuous() 
dev.off()

save.image(file="/Volumes/T7/Scripts and Data/Fst/R Project/FST_info.R")
 





