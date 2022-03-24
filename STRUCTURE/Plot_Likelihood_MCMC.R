#################################################################################################
## A script to plot likelihood flucations through MCMC iterations of STRUCTURE to determine    ##
## if STRUCTURE replicate runs have converged on similar values. This ensures that no f output ##
## that you choose will have ancestry proportions derived from a model stuck in a suboptimal   ##
## parameter space. Use files with a .txt extension.                                           ##
#################################################################################################


######################################################
## Load Libraries 
library(tidyverse) 
library(ggplot2)
library(cowplot)
#######################################################

setwd("<location of txt files containing the info of likelihood scores over MCMC iterations>")

# Set directory for plots to go in. 
outputdir <- "<path>/"
outputfile <- "<filename>"

x_files <- list.files(pattern = ".txt")

p = NULL
for (x in 1:length(x_files)){
  n <- sapply(str_split(x_files[x], "\\."), "[", 1)
  n2 <- sapply(str_split(x_files[x], "\\."), "[", 2)
  c <- c("Rep", "Alpha", "F1", "F2", "F3", "r", "Ln_Likelihood")
  f <- read.delim(x_files[x], sep = "\t", header = F,
                  skipNul = T, fill = T)
  f <- f[-1,]
  f <- f[-(nrow(f)),]
  f <- f[1:7]
  colnames(f) <- c
  min.lim <- min(f$Ln_Likelihood) - 1000
  max.lim <- max(f$Ln_Likelihood) + 1000
  p <- ggplot(f, aes(x = Rep, y = Ln_Likelihood)) +
    geom_point() +
    scale_y_continuous(limits = c(min.lim, max.lim))
  
  assign(paste0(n, "_", n2, "_Plot"), p)
}

n <- unique(sapply(str_split(x_files, "\\."), "[", 1))
p = NULL

for (y in 1:length(n)){
  list.p <- ls(pattern = n[y])
  
  p <- 
  plot_grid(plotlist = mget(list.p))
  assign(paste0(n[y], "_Plot"), p)
  
pdf(file = paste0(file = paste(outputdir, 
                    n[y], outputfile))
plot(p)  
dev.off()
}


# Facetted outputs will allow to compare between replicate runs of STRUCTURE with ease. If all the 
# runs have converged on a similar value, then it is ok to use these runs. Be sure to check all the 
# Q plots on the later steps t o make sure they are also giving consistent admixture proportions 
# across replicate runs. 






