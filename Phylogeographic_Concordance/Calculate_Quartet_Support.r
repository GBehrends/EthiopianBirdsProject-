library(ape)

# Placing node supports on trees and saving them as non-nexus. 

setwd(<path to files>)

# Gather branch labels showing support for topologies
for (a in 1:3){
  support <- c()
  for (i in 1:100){
    tree <- read.nexus(file = paste(getwd(), "/", i, "_sum_h", a, ".tre", 
                                    sep = ""))
    support <- c(support, tree$node.label[2])
  }
  # Map support with 95% CI back onto the tree
  CI <- paste("[", (round(mean(as.numeric(support)) - (sd(support)*2), 2)), 
              ";", (round(mean(as.numeric(support)) + (sd(support)*2), 2)), "]",
              sep = "")
  tree$node.label[2] <- paste((round(mean(as.numeric(support)), 2)), CI, sep = "")
  plot.phylo(tree, type = "unrooted")
  assign(paste0("hyp_tre_", a), tree)
  write.tree(tree, file = paste("hyp", a, ".tre", sep = ""))
}
