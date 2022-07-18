#!/bin/bash 
#SBATCH --job-name=strct_Zosterops_poliogastrus
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=?
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=8G

# Load conda environment with STRUCTURE installed 
. ~/conda/etc/profile.d/conda.sh
conda activate <env_name>

# SampleID.txt was a list of all samples used here to calculate the number of individuals in the input structure file. -L was the number of loci with 3
# subtracted to account for the added columns containing things like population info. -D was was set to a random number for the starting seed. 
structure -K 3 \
-N $(awk 'END{print NR}' ../../Zosterops_poliogastrus/00fastq/SampleID.txt) \
-L $(awk '{print NF-3; exit}' ../strct_files/Zosterops_poliogastrus_50000_corrected.structure) \
-i ../strct_files/Zosterops_poliogastrus_50000_corrected.structure \
-o ../outdir/Zosterops_poliogastrus_50_replicate \
-D $RANDOM
