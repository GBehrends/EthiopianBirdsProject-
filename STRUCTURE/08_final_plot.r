################################################################################
### Plotting STRUCTURE "f" File Outputs Individually
## Author: Garrett Behrends 
#
## Description: 
# Takes a f file output from STRUCTURE, extracts the Q matrix, and builds a bar
# plot of the results. Be sure to clear the environment before and after use.  
#
## Last Modified: June 24th, 2022 @ 18:24. 
################################################################################
### Load libraries

library(tidyverse)
library(ggplot2)
library(cowplot)

################################################################################
### Reading in all STRUCTURE f output files and storing them as Q matrix 
### objects...

# Choose number of K
k <- 4

# Read in the Q matrices for all f files using my Q Matrix Function

source("<path to q matrix function from previous steps")
setwd("<workdir>")
x_files <- list.files(pattern = "_f")

for (x in 1:length(x_files)){
  p <- Q.Matrix(file = x_files[x], k = k, extraCols = "Location")
  assign(paste0(paste0(sapply(strsplit(x_files[x], "_20", ), "[", 1)), ".Q"), p)
  remove(p)
}

################################################################################
### SampleID lists: These should be made for each individual in the STRUCTURE 
### run if the original sample IDs were truncated in the outputted f file. 

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

##################################################################################
### Plotting each Q matrix object individually...

name <- "Cossypha_semirufa"
k.cols <- c("olivedrab",  "dodgerblue3", "orchid4", "wheat3") 

Q <- get(paste0(name, ".Q"))
Q$Sample <- get(paste0(name, "_SampleID"))

# Some columns may need reordering if some samples dont appear by eachother in 
# the STRUCTURE input file 
Q <- Q[c(1,2,3,4,5,6,7,8),]


# Set as factor so keep sample ID order in plot 
Q$Sample <- factor(Q$Sample, levels = Q$Sample)

Q <- gather(Q, paste0("K", rep(1:k)),
         key = "Cluster",
         value = "Ancestry_Probability") 
 
p <-  
  ggplot(data = Q, aes(x = as.factor(Sample), y = Ancestry_Probability, fill = Cluster)) +
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

assign(paste0(name, "_Plot"), p)

plot(p)

################################################################################
### Saving plot to pdf once it looks good in RStudio.

pdf(paste0("<out_dir>", name, 
           "_K4_Plot.pdf"), height = 8, width = 9)
plot(p)
dev.off()

################################################################################
### Facet wrapped plot

pdf("<out_file>",
            height = 3, width = 12)
plot_grid(ncol = 6, plotlist = mget(ls(pattern = "_Plot")))
dev.off()

################################################################################
### Saving the plot information

save.image("<out_file>")

