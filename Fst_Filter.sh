#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=filt_All 
#SBATCH --nodes=1 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-123		
		
		
		
		
		
									  ###Beginning Steps###

for i in $(cat ../specieslist); do 

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} helper6.txt | tail -n1 )

##  define main working directory
workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/${i} 


							      
							      
							      #### Grouping Filters ###
## run vcftools set to 6 minDP filter  
outputdir=/lustre/scratch/gbehrend/EthiopianBirdsProject/Fst/${i} # Define output directory

vcftools --vcf  ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0 --minQ 20 --minGQ 20 --minDP 6 --max-meanDP 50 --min-alleles 2 --max-alleles 2 --mac 1  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${outputdir}/${input_array}

done; 

done




