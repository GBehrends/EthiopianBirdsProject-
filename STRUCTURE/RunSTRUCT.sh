#!/bin/bash 
#SBATCH --job-name=strct_species
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=8G

. ~/conda/etc/profile.d/conda.sh
conda activate strct

# Set paths for less typing
input=<path to input structure file>
output=<path to output>

# Note that this script was run on STRUCTURE files formatted so that each individual's genotypes 
# comprised two rows and not two columns. 
structure -K 3 -N $(cut -f1 ${input} | uniq | wc -l) \
-L $(awk '{print NF-3; exit}' ${input}) \
-i ${input} \
-o ${output} \
-D $RANDOM 
