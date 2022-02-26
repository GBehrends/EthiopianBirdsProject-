## Setting Branch Lengths for ASTRAL III Trees and Plotting Them ##

library(ape)
library(phytools)
library(stringr)

branch_length <- "<your branch length>"
working_directory <- "<directory with ASTRAL trees>"


x_files <- list.files(working_directory, 
                      pattern = "_Astral.tre")
for (i in 1:length(x_files)){
  x <- read.tree(x_files[i])
  x$edge.length[is.nan(x$edge.length)] <- NA
  x$edge.length[is.na(x$edge.length)] <- branch_length
  write.tree(x, file = paste0(gsub(".tre", "", x_files[i]), "_corrected.tre"))
  pdf(file = paste0(gsub(".tre", "", x_files[i]), ".pdf"), height = 6,
      width = 6)
  x <- midpoint.root(x)
  plot(x)
  dev.off()
}


