# Terminal branches in ASTRAL are not infomrative and they have no branch lengths. Also, trees
# will be of different total heights according to the study species. This script adds branch lengths to
# the terminal branches porportional to the overall height of the tree which standardizes the 
# terminal branches across all trees. This allows for easy visualization later across trees from 
# different taxa so that some tips are not overly long/short in some. 

library(ape)

# Specify the proportion of tree hiehgt you wish for the tips to be. 
prop <- 0.05

tree <- read.tree(file = "/Volumes/T7/Scripts_and_Data/RAxML/ReducedOutGroup_20KBP/Crithagra20KBP_Astral.tre")
tree$edge.length[is.na(tree$edge.length)] <- (prop*max(nodeHeights(tree), na.rm = T))
tree$tip.label <- sapply(strsplit(tree$tip.label, "_"), "[[", 3)
write.tree(tree, file = "/Volumes/T7/Scripts_and_Data/RAxML/ReducedOutGroup_20KBP/Crithagra20KBP_ShortTips.tre")
plot(tree)
