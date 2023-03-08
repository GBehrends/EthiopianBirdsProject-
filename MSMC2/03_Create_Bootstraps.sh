#!/bin/sh
#SBATCH --job-name=b00t
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition=quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-<number of lines in scaffoldslist.txt> 

# Establish Working Directory 
workdir=? 

# Establish the number of scaffolds for each sample
scaffold=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/scaffoldlist.txt | tail -n1 )

/lustre/scratch/gbehrend/EthiopianBirdsProject/MSMC2/msmc-tools/multihetsep_bootstrap.py  \
-n 10 \
-s 1000000 \
--chunks_per_chromosome 30 \
--nr_chromosomes ${scaffold} \
--seed 324324 bootstrap *txt
