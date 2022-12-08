## Background for Part 1
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



## Background for part 2
To assess genome-wide frequency/support for all possible topologies, we used custom R scripts. This was feasible
because our hypothesis topologies are quartets with 3 location "tips" and an outgroup, so there are only 3 possible topologies.
However, we are concerned with the relationships between locations and want support for each without reliance on counting monophyly. 
Briefly, all gene trees from all species are sampled for 1 random tip per location plus the outgroup. The tips are then 
renamed according to sampling location or "OG". All sampled topologies are stored in a file. Three tree files are then given for the 
three possible topologies and sample toplogy support is summarized for each target topology as a bootstrap consensus tree. After 
bootstrapping a number of times, The three hypotheses trees are summarized again with the boostraps to provide an estimate of the 
frequency of each topology in the genome with confidence intervals. 


# Step 1
Run Gene_Tree_Sample.r. 

# Step 2 
Create hypothesis .tre files and name them h<topology number>.tre. These will serve as target trees to map support from sample topologies to. 

# Step 3 
Run Create_Summary_Trees.sh. It may be better to submit it as a batch job because it takes a while. 

# Step 4
Run Calculate_Quartet_Support.r to map suppport and confidence intervals onto the final trees and save them as .tre files instead of nexus. 

