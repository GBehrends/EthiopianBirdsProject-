##########################################
##########################################
# A Script for Plotting Structure Output #
##########################################

######################
# Load Libraries #####
library(stringi) #####
library(ggplot2)  ####
library(tidyverse) ###
######################

# Set how many k you used, file path, and colors
setwd("<location of Q files")
workdir <- "<location of Q files>/"

# This script will work with files named in the following way (50KBP signifies
# the amount of SNP spacing to remove linkage disequilibrium):
file.Q <- "<species>_50KBP_2.Q"
output_dir <- "<location for plots>"
k <- 3


# If facet wrapping, will have to change order of colors for each plot because
# STRUCTURE will not align clusters (K) between runs. You will need to change the
# order of the colors between plots so that they line up across different 
# species Q files. 

k.cols <-  c("wheat3", "orchid4", "olivedrab")


# Reading in files and prep 

  Q <- read.delim(paste0(workdir, file.Q), sep = "\t", header = F)
  name <- sapply(str_split(file.Q, "_50KBP"), "[", 1)
  Q <- Q[c(10, 7:9, 5)]
  colnames(Q) <- c("Sample", "K1", "K2", "K3", "Location")
  Q$Sample <- factor(Q$Sample, levels = Q$Sample)

# Consolidating multiple k columns into one column for plotting
  p <-
    Q %>%
# You will need to add K4, K5, etc if you have more clusters than 3.  
    gather(K1, K2, K3,
           key = "Cluster",
           value = "Ancestry_Probability") %>%
    
    ggplot(aes(x = Sample, y = Ancestry_Probability, fill = Cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 1, , col = "black") + 
    scale_fill_manual(values = k.cols) +
    #ylab("Ancestry Proportion") +
    theme(plot.title = element_text(face = "italic"),
          axis.text.x = element_text(angle = 40, 
                                     size = 8,
                                     hjust = 1,
                                     vjust = 1.5),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(), 
          axis.title.y = element_blank(), 
          panel.grid = element_blank(),
          panel.background = element_blank(),
          legend.position = "none",
          panel.spacing = unit(c(0,0,0,0), "cm")) + 
    ggtitle(paste0(substr(name, 1, 1), ". ",
                  sapply(strsplit(name, "_"), "[", 2)))
  
  pdf(paste0(output_dir, name, "_Plot.pdf"), height = 8, width = 9)
  plot(p)
  dev.off()
  
  assign(paste0(name, "_Plot"), p)
  
#########################################
## Plotting as Facet Wrap ###############
#########################################

pdf(file = paste0(output_dir, "Structure_50KBPFacet.pdf"),
    height = 6, width = 10)
plot_grid(plotlist = mget(ls(pattern = "Plot")))
dev.off()
