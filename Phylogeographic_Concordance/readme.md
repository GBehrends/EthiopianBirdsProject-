## Background
ASTRAL III has an option to force monophyly of prespecified tips. This is generally used when, for  
example, there are representatives of a hypothesis species and the user wishes to see quartet support 
for when all representatives from that species are monophyletic. Here, I am testing phylogeographic 
concordance, or shared phylogenetic breaks across all study species corresponding to biogeographic barriers.
So, all gene tree tips in all species are grouped according to their sampling location and forced 
to be monophyletic by sampling location. Since ASTRAL is simply looking at topologies from input gene trees, 
this method can be used to measure quartet/posterior support for a given phylogeographic hypothesis where 
species within a community will be monophyletic according to sampling location and have a shared community 
response to phylogeographic breaks. 

## Step 1
Run through the steps in the RAxML directory. This gave a bunch of gene trees for different species. 

## Step 2
Make a map_file.txt file like the example provided that specifies what sampling location all tips/samples 
belong to across all the input gene trees.  

# Step 3
Run the Make_ASTRAL_PC.sh script. 

