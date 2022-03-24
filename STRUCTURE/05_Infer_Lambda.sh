#!/bin/bash 
#SBATCH --job-name=strct_species
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=2

# Running structure on a K of 1 to infer Lambda. 

. ~/conda/etc/profile.d/conda.sh
conda activate strct

# Set directory containing structure files and the output directory 
StrctDir=/lustre/scratch/gbehrend/EthiopianBirdsProject/structure/strct_files
outputdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/structure/inferlambda_out

# Be sure to run with sampling location identifiers in the structure input files 
structure -K 1 -N $(cut -f1 ${StrctDir}/species_50000_corrected.structure | uniq | wc -l) \
-L $(awk '{print NF-3; exit}' ${StrctDir}/species_50000_corrected.structure | cut -f1) \ 
-i ${StrctDir}/species_50000_corrected.structure \
-o ${outputdir}/species_50_rep \
-D $RANDOM 
