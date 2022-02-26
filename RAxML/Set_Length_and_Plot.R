## Setting Branch Lengths for ASTRAL III Trees

library(ape)
library(phytools)
library(stringr)
setwd("/Volumes/T7/Scripts_and_Data/RAxML/ASTRAL III Output")

x_files <- list.files("/Volumes/T7/Scripts_and_Data/RAxML/ASTRAL III Output", 
                      pattern = "_Astral.tre")
for (i in 1:length(x_files)){
  x <- read.tree(x_files[i])
  x$edge.length[is.nan(x$edge.length)] <- NA
  x$edge.length[is.na(x$edge.length)] <- 0.003
  write.tree(x, file = paste0(gsub(".tre", "", x_files[i]), "_corrected.tre"))
  pdf(file = paste0(gsub(".tre", "", x_files[i]), ".pdf"), height = 6,
      width = 6)
  x <- midpoint.root(x)
  plot(x)
  dev.off()
}


