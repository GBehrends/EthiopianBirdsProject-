#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=step3
#SBATCH --nodes=1 --ntasks=10
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-

module load intel java

chr_array=$( head -n${SLURM_ARRAY_TASK_ID} helper4.txt | tail -n1 )

interval_array=$( head -n${SLURM_ARRAY_TASK_ID} helper5.txt | tail -n1 )

name_array=$( head -n${SLURM_ARRAY_TASK_ID} helper6.txt | tail -n1 )

