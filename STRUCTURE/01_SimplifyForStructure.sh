#################################################################################################################
####### For preparing STRUCTURE files with informative sampling locations used in the LOCPRIOR STRUCTURE model ##
#################################################################################################################

# This script assumes that vcf files have been generated with desired thinning parameters to limit linkage 
# disequilibrium as STRCUTURE's admixture model assumes marker independence. 

#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=simplify
#SBATCH --nodes=1 --ntasks=4
#SBATCH --partition 
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-125


# Preparing vcf files to be converted into structure format  

. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

mkdir simple

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} <list of scaffold vcfs> | tail -n1 )

bcftools query -f '%POS\t%REF\t%ALT[\t%GT]\n ' ${input_array}.recode.vcf > simple/${input_array}.simple.vcf



