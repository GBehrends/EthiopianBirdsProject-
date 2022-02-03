#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=species_Cat
#SBATCH --nodes=1 --ntasks=10
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-22

. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

## Concatenating genotyped VCFs into complete chromosomes using a split chromosome list
chr_array=$( head -n${SLURM_ARRAY_TASK_ID} <chrom_list> | tail -n1 )

# Ending of file names will depend on how the chromosomal scaffolds were subdivided during ggenotyping
chr_start=<gVCF directory>/${chr_array}__a.g.vcf

chr_output=<output_directory>/${chr_array}.g.vcf

grep "#" ${chr_start} > ${chr_output}

# Iterating through all files starting with chromosome prefix within your gVCF directory and concatenating them
for i in $( ls <gVCF directory> | grep -v "idx" | grep "vcf" | grep "${chr_array}"); do grep -v "#" ${i} >> ${chr_output}; done


