#!/bin/bash 
#SBATCH --job-name=msmc_to_vcf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=18
#SBATCH --array=1-6

module load gcc/10.1.0
module load r/4.0.2

# Set working directory 
workdir=?

# Array to go through all six species 
array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/specieslist | tail -n1 )

# Make a scripts to convert vcfs to msmc files for each species 
sed "s/species/${array}/g" ${workdir}/MSMC2/vcf_to_msmc.r > ${workdir}/MSMC2/${array}_msmc.r
  
# Convert vcfs to msmc format files for all species and their samples 
Rscript ${workdir}/MSMC2/${array}_msmc.r

# Add species msmc file paths to a list that will be used when running MSMC2 (helper1.txt):
cd ${array}_demography
for i in $(find ~+ -type d | sed '1d' | sed 's,\./,,g'); do echo "${i}/*txt" >> \
${workdir}/MSMC2/helper1.txt; done

# MSMC2 output prefixes (helper2.txt): 
for i in $(find ~+ -type d | sed '1d' | sed 's,\./,,g'); do echo "${i}" >> \
${workdir}/MSMC2/helper2.txt; done
for i in $(find ~+ -type d | sed '1d' | sed 's,\./,,g'); do for x in {1..10}; do \
echo "${i}_b${x}" >> ${workdir}/MSMC2/helper2.txt; done

 



