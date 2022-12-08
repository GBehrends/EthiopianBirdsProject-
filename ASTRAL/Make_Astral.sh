#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=ASTRAL3
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition=nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-<number of species in specieslist>

# This is a script to generate an ASTRAL 3 species tree from the RAxML gene trees when each species had its own directory.
# Script will also output a list with each species and how many gene trees were created for reference. 

workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/

array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/specieslist | tail -n1 )

cat ${workdir}/RAxML/${array}/windows/RAxML_bipartitions* >> ${workdir}/RAxML/${array}_50KBP.trees

ls -U ${workdir}/RAxML/${array}/windows/RAxML_bipartitions* | wc -l >> ${workdir}/RAxML/50KBP_treeCounts.tsv

# Creating ASTRAL trees with individuals forced into monophyletic groups 
java -jar /lustre/work/gbehrend/Astral/astral.5.7.8.jar \ 
-o ${workdir}/RAxML/${array}_50KBP_ASTRAL.tre
