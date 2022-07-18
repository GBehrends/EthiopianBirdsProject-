#########################################################
# A Script for Plotting Multiple Structure Runs at Once #
#########################################################

# This script was created with files named likeso:
# <species_name>_<thinning window>_<replicate number>_f
# Thinning windows were 10,20, and 50 (in KBP)
# EX: Turdus_abyssinicus_20_1_f
# Script may need to be modified when calling the SampleID1, SampleID2, and 
# SampleID objects when converting the STRUCTURE output files into a Q matrix. 

######################
# Load Libraries #
library(stringi)
library(ggplot2)
library(tidyverse)
library(cowplot)
######################

# Set how many k you used and choose colors 
species <- "Cossypha_semirufa"
k <- 4
k.cols <-  c("wheat3", "orchid4", "olivedrab", "goldenrod3") 

setwd("/Volumes/T7/Scripts_and_Data/STRUCTURE/f_files_and_plots/K4_10_Cossypha")
x_files <- list.files(pattern = species)

# List character vectors of sample IDs here if the truncated sample IDs in the 
# STRUCTURE output files were not different from each other. In my case it was 
# truncated so each of my individuals had the beginning of their sample ID only,
# so the plot could not distinguish them from one another at the end. These
# vectors will be inserted into that column to correct that. 

Melaenornis_chocolatinus_SampleID <- c("EB002",
                                       "EB003",
                                       "EB053",
                                       "EB059",
                                       "EB063",
                                       "EB067",
                                       "EB084")

Sylvia_galinieri_SampleID <- c("EB004",
                               "EB017",
                               "EB056",
                               "EB070",
                               "EB073",
                               "EB076")

Cossypha_semirufa_SampleID <- c("EB008",
                                "EB009",
                                "EB024",
                                "EB044",
                                "EB062",
                                "EB069",
                                "EB085",
                                "EB087")

Crithagra_tristriata_SampleID <- c("EB007",
                                   "EB015",
                                   "EB043",
                                   "EB058",
                                   "EB064",
                                   "EB086",
                                   "EB092",
                                   "EB094")

Turdus_abyssinicus_SampleID <- c("EB001",
                                 "EB006",
                                 "EB010",
                                 "EB042",
                                 "EB045",
                                 "EB046",
                                 "EB079",
                                 "EB088",
                                 "EB093")

Zosterops_poliogastrus_SampleID <- c("EB013",
                                     "EB049",
                                     "EB050",
                                     "EB051",
                                     "EB065",
                                     "EB081",
                                     "EB089",
                                     "EB090")

# Converting f Files to a Q Matrix
source("<location of the Q_matrix function from the previous step>")
for (x in 1:length(x_files)){
  name <- sapply(strsplit(x_files[x], "_f"), "[", 1)
  SampleID1 <- sapply(strsplit(name, "_"), "[", 1)
  SampleID2 <- sapply(strsplit(name, "_"), "[", 2)
  SampleID <- mget(paste0(SampleID1, "_", SampleID2, "_SampleID"))
  
  Q <- Q.Matrix(file = x_files[x], k = k, extraCols = "Location")
  Q$Sample <- unlist(SampleID)
  assign(paste0(x_files[x], ".Q"), Q)
  

# Consolidating multiple k columns into one for plotting
  p <-
    Q %>%
    
    gather(paste0("K", seq(1:k)),
           key = "Cluster",
           value = "Ancestry_Probability") %>%
    
    ggplot(aes(x = Sample, y = Ancestry_Probability, fill = Cluster)) +
    geom_bar(stat = "identity", position = "stack", width = 1, , col = "black") + 
    scale_fill_manual(values = k.cols) +
    #ylab() +
    theme(plot.title = element_text(face = "italic", size = 10),
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
    ggtitle(x_files[x])
  
  #pdf(paste0("/Volumes/T7/Scripts_and_Data/STRUCTURE/Plot/20KBP_Strct/K3/All_f/", name, "_Plot.pdf"), height = 8, width = 9)
  #plot(p)
  #dev.off()
  
  assign(paste0(name, "_Plot"), p)
  #remove(mget(paste0(species, ".Q")))
}  

#pdf(file = paste0(getwd(), "/",
                  #species, "_10KBP_K2.pdf"), height = 6, width = 10)
plot_grid(plotlist = mget(ls(pattern = paste0("_Plot"))))
remove(list = c(ls(pattern = "*Q"), ls(pattern = "*_Plot")))
#dev.off()
################################################################################

save.image("<output file")
