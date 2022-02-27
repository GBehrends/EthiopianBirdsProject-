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
outputdir=${workdir}/FST_QUAL20 # Define output directory
vcftools --vcf  ${workdir}/03_vcf/${input_array}.g.vcf  --max-missing 1.0 --minQ 20 --minGQ 20 --minDP 6 --max-meanDP 50 \
--min-alleles 2 --max-alleles 2 --mac 1  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${outputdir}/${input_array}

done; done

## Remove chromsomes 4A (partial neosex chromosome) and Z because they interfere with genome-wide FST calculations.  
for x in $(ls ${workdir}/FST_QUAL20/NC_044241.2*); do rm ${x}; done
for x in $(ls ${workdir}/FST_QUAL20/NC_044216.2*); do rm ${x}; done







