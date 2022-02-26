## PLotting PCA Results from Plink ##

library(tidyverse)
library(stringr)

# Set all the population vectors for each species
Cossypha_semirufa_pop<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 

Parophasma_galinieri_pop<- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 

Melaenornis_chocolatinus_pop <- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Bale Mountains", "Choke Mountains")) 

Serinus_tristriatus_pop<- as.factor(c("Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Choke Mountains", "Choke Mountains", "Choke Mountains")) 

Turdus_abyssinicus_pop<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 

Zosterops_poliogastrus_pop<- as.factor(c("Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Bale Mountains", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")) 


# Getting list of files to loop through
setwd("/Volumes/T7/Scripts_and_Data/PCA/eigen")
outputdir <- "/Volumes/T7/Scripts_and_Data/PCA/Plots/"
x_files <- list.files()
names <- sapply(strsplit(x_files, "\\."), "[[", 1)

for (x in 1:length(names)){
  a <- NULL
  pca <- read_table2(paste0(names[x], ".eigenvec"), col_names = FALSE)
  eigenval <- scan(paste0(names[x], ".eigenval"))
  
  # sort out the pca data
  # remove nuisance column
  pca <- pca[,-1]
  # set names
  names(pca)[1] <- "ind"
  names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
  pop <- paste0(str_remove(names[x], "[0-9]+"), "pop")
  pca <- cbind.data.frame(pca, get(pop))
  colnames(pca)[ncol(pca)]<- "Location"
  pca <- as_tibble(pca)

  # first convert to percentage variance explained
  pve <- data.frame(PC = 1:nrow(pca), pve = eigenval/sum(eigenval)*100)
  
  # make plot
  print(ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
  + ylab("Percentage variance explained") + theme_light()) 
  
  # calculate the cumulative sum of the percentage variance explained
  cumsum(pve$pve)
  
    a <-ggplot(pca, aes(PC1, PC2, col = Location)) + 
    geom_point(size = 3) +
    scale_colour_manual(values = c("wheat3", "olivedrab","orchid4")) +
    coord_equal() + theme_bw() +
    xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + 
      theme(plot.margin = unit(c(0, 0, 0, 0), "cm"),
                               legend.position = "none") +
      xlim(c(-0.7, 0.7)) +
      ylim(c(-0.9, 0.9)) +
      ggtitle(str_replace(str_remove(names[x], "_[0-9]+"), "_", " ")) +
    ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
    
    file_name <- paste0(names[x], ".pdf")
    pdf(file = paste0(outputdir, file_name), height = 6, width =6)  
    plot(a)
    dev.off()
    assign(paste0(names[x], "_Plot"), a)
}

library(cowplot)
pdf(file = paste0(outputdir, "Facet10KBP.pdf"), height = 6, width = 8) 
plot_grid(plotlist=mget(ls(pattern = "10_Plot")))
dev.off()

pdf(file = paste0(outputdir, "Facet20KBP.pdf"), height = 6, width = 8) 
plot_grid(plotlist=mget(ls(pattern = "20_Plot")))
dev.off()

plot(Serinus_tristriatus_10_Plot)
