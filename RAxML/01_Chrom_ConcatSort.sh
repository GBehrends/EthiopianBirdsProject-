#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=RAxML_Cat
#SBATCH --nodes=1 --ntasks=4
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-<number of split scaffolds in chrom_list>

. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

## Concatenating genotyped VCFs into complete chromosomes using a split chromosome list as an array job
chr_array=$( head -n${SLURM_ARRAY_TASK_ID} <chrom_list> | tail -n1 )

# Ending of file names will depend on how the chromosomal scaffolds were subdivided during genotyping
chr_start=<gVCF directory>/${chr_array}__a.g.vcf

chr_output=<output_directory>/${chr_array}.g.vcf

grep "#" ${chr_start} > ${chr_output}

# Iterating through all files starting with chromosome prefix within your gVCF directory and concatenating them
for i in $( ls <gVCF directory> | grep -v "idx" | grep "vcf" | grep "${chr_array}"); do grep -v "#" ${i} >> ${chr_output}; done

# Sort the concatenated vcf files
bcftools sort ${chr_output} > ${chr_output%%.*}.sorted.vcf

# Rename the sorted vcf files
mv ${chr_output%%.*}.sorted.vcf ${chr_output}

# Now you will have a collection of all gVCFs including those that were concatenated and those that were not split all in the same location
# and with the same file extension to be run through 
