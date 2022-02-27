#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=filt_species
#SBATCH --nodes=1 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-<number of genotpyed scaffolds in the helper6.txt file 

## A script to filter vcf files for STRUCTURE, DAPC, PCA, RAxML, MSMC2, Reich's FST and Calculating Obsevred Heterozygosity
## Add this to each species directory in the 12_filter_scripts subdirectory
                
                                                        ###Beginning Steps###

# define input files from helper file during genotyping
. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} helper6.txt | tail -n1 )

##  define main working directory
workdir=<species_directory>

# GATK 4.2.3 did not give genotype quality calls anymore, so remove the quality call filters for VCFtools. It should be fine if the average depth of coverage is ~20. 
# Filter for Observed Heterozygosity 
vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 0.05 --minDP 6 --max-meanDP 50  --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/NoThin_Vcf_0.5/${input_array}

# Filter for STRUCTURE/DAPC 10kbp
# vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0  --minDP 6 --max-meanDP 50 --min-alleles 2 --mac 2 --max-alleles 2  --max-maf 0.49 --thin 20000 --remove-indels --recode --recode-INFO-all --out ${workdir}/10kbp_filtered_vcf/${input_array}

# Filter for STRUCTURE/DAPC 20kbp
# vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0  --minDP 6 --max-meanDP 50 --min-alleles 2 --max-alleles 2  --mac 2 --max-maf 0.49 --thin 10000 --remove-indels --recode --recode-INFO-all --out ${workdir}/20kbp_filtered_vcf/${input_array}

# Filter for RAxML
vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 0.8  --minDP 6 --max-meanDP 50  --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/phylo_vcf/${input_array}

# Filter for MSMC
vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 0.05  --minDP 6 --max-meanDP 50  0 --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/msmc_vcf/${input_array}



