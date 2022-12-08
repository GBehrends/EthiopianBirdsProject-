#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=outgroup_vcf
#SBATCH --nodes=1 --ntasks=12
#SBATCH --partition=quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-41

# Original number of chromosomes -> 41
                
                                                        ###Beginning Steps#
# define input files from helper file during genotyping
. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} vcf_list.txt | tail -n1 )

##  define main working directory
workdir=<output directory>

# For loop through remeaining species
for i in $(cat ../../specieslist); do 

# Filter out individuals from target species and keep one outgroup as secificied by the keeplist. # Specifying max missing filter again. 20% missing info
# out of all individuals in the group VCF will be different from the percentage of missing individuals per site in the species VCF so this filter is appplied 
# here once more. 
vcftools --gzvcf ${workdir}/VCF/${input_array}.vcf.gz  --max-missing 0.8 --keep ${i}_keeplist.txt --recode --recode-INFO-all --out ${workdir}/${i}/${input_array}

# Bgzip and index the new vcf file 
bgzip -c ${workdir}/${i}/${input_array}.recode.vcf > ${workdir}/${i}/${input_array}.vcf.gz

# Tabix the new vcf 
tabix -p vcf ${workdir}/${i}/${input_array}.vcf.gz

# Remove the non zipped vcf
rm ${workdir}/${i}/${input_array}.recode.vcf; done 
