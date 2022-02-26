## PLotting PCA Results from Plink ##
# Some code adapted from Plink PCA Tutorial @ https://speciationgenomics.github.io/pca/

library(tidyverse)
library(stringr)

# Set all the Location vectors for each species in this fashion. Location idenifiers for 
# each sample should be in the same order as the sample names appear in the VCF. 
<species>_Pop <- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", 
                             "Menagesha", "Menagesha", "Choke_Mountains", 
                             "Choke_Mountains", "Choke_Mountains")) 

# Set colors for your locations, one color per location
Loc_Colors <- c("wheat3", "olivedrab","orchid4")


# Getting list of files to loop through
setwd("<path to eigenval and eigenvec files>")
outputdir <- "<directory for plot outputs>"
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

  # Percent of variance explained
  pve <- data.frame(PC = 1:nrow(pca), pve = eigenval/sum(eigenval)*100)
  
  # Plot
  print(ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
  + ylab("Percentage variance explained") + theme_bw()) 
 
  
    a <-ggplot(pca, aes(PC1, PC2, col = Location)) + 
    geom_point(size = 3) +
    scale_colour_manual(values = Loc_Colors) +
    coord_equal() + theme_bw() +
    xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + 
      theme(plot.margin = unit(c(0, 0, 0, 0), "cm"),
                               legend.position = "none") +
                               
   # May have to modify xlim() and ylim() depending on spread of data
   
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
