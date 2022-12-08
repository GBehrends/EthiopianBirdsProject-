#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=ASTRAL3
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition=nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-6

workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/

array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/specieslist | tail -n1 )


# Creating ASTRAL trees with individuals forced into monophyletic groups 
java -jar /lustre/work/gbehrend/Astral/astral.5.7.8.jar \
-a ${workdir}/RAxML/${array}/map_file.txt \
-i ${workdir}/RAxML/${array}_50KBP.trees \
-o ${workdir}/RAxML/${array}_50KBP_ASTRAL_LocMono.tre \
--outgroup OG -q --branch-annotate 2
