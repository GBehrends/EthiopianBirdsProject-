#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=step1
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

module load intel java

chr_array=$( head -n${SLURM_ARRAY_TASK_ID} helper1.txt | tail -n1 )

ind_array=$( head -n${SLURM_ARRAY_TASK_ID} helper2.txt | tail -n1 )

