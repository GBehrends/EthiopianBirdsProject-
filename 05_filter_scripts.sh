#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=keep 
#SBATCH --nodes=1 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-123

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} helper6.txt | tail -n1 )

# define main working directory
workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/<species directory> 

#Use different --thin filter settings to space SNPs apart to limit the effects of linkage on downstream analyses 

#keeplist.txt is a list of all sample IDs within the combined vcf files that you want to isolate. In my Ethiopian Birds Project, I did it for my 6 focal species individually. 

# run vcftools with SNP output spaced 10kbp
mkdir ${workdir}/10kbp_filtered_vcf

vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0 --minQ 20 --minGQ 20 --minDP 8 --max-meanDP 50 --min-al
leles 2 --max-alleles 2 --mac 1 --thin 10000 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/10kbp_filtered_vcf/${input_
array}

# run vcftools with SNP output spaced 20kbp
mkdir ${workdir}/20kbp_filtered_vcf

vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0 --minQ 20 --minGQ 20 --minDP 8 --max-meanDP 50 --min-al
leles 2 --max-alleles 2 --mac 1 --thin 20000 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/20kbp_filtered_vcf/${input_
array}

# Run vcftools with no thinning filter 
mkdir ${workdir}/NoThin_Vcf

vcftools --vcf ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0 --minQ 20 --minGQ 20 --minDP 8 --max-meanDP 50 --min-al
leles 2 --max-alleles 2 --mac 1 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/NoThin_Vcf/${input_
array}

