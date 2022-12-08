### Subsampling Gene Trees###

# Given a concatenated file containing gene trees (one tree per line):
# For every gene tree in the file, one sample (gene tree tip) will be randomly 
# drawn per location. All other tips will be dropped and the remaining sampled
# tips will renamed by their location, representing OTUs. These subsampled gene 
# trees can then be used to make maximum clade credibility trees to give support 
# for nodes representing phylogeographic breaks between the OTUs on a hypothesis 
# tree.

# Installs or load libraries:
library(ape)
library(stringr)

# Create a tsv that contains all individuals in one column and their 
# corresponding sampling location in another column. 
# Here I have three sampling locations called Bale, Menagesha, and Choke. These 
# will represent three major nodes each having different numbers of individuals 
# depending on the species. Using this location information, I can test the 
# monophyly of all individuals belonging to each location in each gene tree. 
df <- read.csv(file = "<location of csv>", header = F, sep = "\t")


# To avoid bias from species with more gene trees, an equal random subsample 
# of gene trees will be taken from each species. Here, sample size n 
# corresponds to number of gene trees present in the species with the least 
# gene trees. 
n <- 49157

# Set the number of replicate mcc summary trees desired. 
iterations <- 100

species <- unique(df$Species)
setwd("/Volumes/T7/Scripts_and_Data/RAxML/Trees_Files")

# For every species, 100 files, each containing one subsampled tree per gene tree 
# will be generated to make 100 maximum clade credibility trees. 
# These will be combined later to give point estimated of node support along with 
# confidence intervals.

for (a in 1:iterations){  
  
  count <- 0  
  
  # Start for loop to iterate through all species. Each species has a .trees file 
  # containing concatenated RAxML gene trees. 
  for (s in 1:length(species)){
    trees <- read.csv(file = paste0(species[s], ".trees"), sep = "\n", 
                      header = F)
    trees <- as.data.frame(trees[sample(nrow(trees), size = n), ])
    
    # Subset the dataframe to contain only information on current species 
    df2 <- df[df$Species == species[s],]
      
        
      # Iterate through each gene tree in the .trees file and randomly sample 
      # one tip from each location.
      for (i in 1:nrow(trees)){
        tree <- trees[i, 1]
        tree <- read.tree(text = tree)
        
        # Define outgroup to maintain the root 
        outgrp <- tree$tip.label[-grep(pattern = species[s], x = tree$tip.label)]
        outgrp <- sapply(strsplit(outgrp, "_"), "[[", 3)
        
        # Loop through unique locations to get 1 random sample from each for the species. 
        tips <- c()
        locs <- unique(df2$Locality)
        for (l in 1:length(locs)){
          tips <- c(tips, sample(df2$Sample[df2$Locality == locs[l]], size = 1))
        }
        
        # Update new species names  
        if(species[s] == "Crithagra_tristriata"){
          tree$tip.label <- gsub("Serinus_tristriatus", "Crithagra_tristriata", tree$tip.label)
        }
        if(species[s] == "Sylvia_galinieri"){
          tree$tip.label <- gsub("Parophasma", "Sylvia", tree$tip.label)
        }
        
        # Add outgroup to the list of subsample tips to maintain the root in every subtree. 
        tips <- c(tips, outgrp)
        
        # Remove species names from tip labels so only sample number remains
        tree$tip.label <- sapply(strsplit(tree$tip.label, "_"), "[[", 3)
        
        # Drop all tips not specified in the tips vector. 
        tree <- drop.tip(tree, tip = tree$tip.label[-match(tips, tree$tip.label)])
        
        # Change tip names to their corresponding location. All species samples will now belong to 
        # a location OTU. 
        # Also rename the outgroup sample to OG.
        for (l in 1:length(tree$tip.label)){
          if(tree$tip.label[l] == outgrp){
            tree$tip.label[l] <- "OG"
          } else {
            tree$tip.label[l] <- df2$Locality[df2$Sample == tree$tip.label[l]]
          }
        }
        
        # Root tre to outgroup 
        # tree <- root.phylo(tree, outgroup = tree$tip.label[tree$tip.label == "OG"])
        
        # Append the subsampled gene tree to a file. 
        write.tree(tree, file = paste(getwd(), "/replicate_trees/", a, "_sub.trees", sep = ""), 
                   append = TRUE)
        
        # Print every 100 gene trees subsampled  to gaugue progress. 
        if(round(i/10000, 0) == i/10000){
          count <- count + i
          print(paste("Sampled", count, "subtrees", sep = " "))
        }
      }
  }
  
  # Print when each specified iteration is finished. 
  print(paste0(a, "th Iteration Finished"))
}



