## Linux Script for summarizing subsampled gene trees. 

# Start an interactive session (Will take a while) 
interactive -p <> -c <>

# Set working directory 
workdir=<path to output sampled gene trees file> 

# For 3 hypothesis topologies
for a in {1..3}; do
for i in {1..100}; do 
sumtrees.py --target-tree-filepath=${workdir}/h${a}.tree \
-o ${workdir}/replicate_trees/${i}_sum_h${a}.tre ${workdir}/replicate_trees/${i}_sub.trees ; done ;done 
