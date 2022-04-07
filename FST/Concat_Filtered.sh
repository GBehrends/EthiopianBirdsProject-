#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=concat_${species}
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-6


species=$( head -n${SLURM_ARRAY_TASK_ID} ../specieslist | tail -n1 )
workdir=../${species}/FST_QUAL20


grep "#" ${workdir}/NC_044213.2__e.recode.vcf > ${species}_NoAZ_QUAL20.vcf
grep -v "#" ${workdir}/*recode.vcf >> ${species}_NoAZ_QUAL20.vcf

