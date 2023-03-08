#!/bin/bash 
#SBATCH --job-name=msmc_to_vcf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=18
#SBATCH --array=1

module load gcc/10.1.0
module load r/4.0.2

# Set working directory 
workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject

# Array to go through all six species 
array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/specieslist | tail -n1 )

# Make a scripts to convert vcfs to msmc files for each species 
sed "s/species/${array}/g" ${workdir}/MSMC2/vcf_to_msmc.r > ${workdir}/MSMC2/${array}_msmc.r
  
# Convert vcfs to msmc format files for all species and their samples 
Rscript ${workdir}/MSMC2/${array}_msmc.r

# Go into species demography directory where all samples msmsc files are stored 
cd ${workdir}/MSMC2/${array}_demography;

# Loop over each species sample directory 
for i in $(find ./ -type d | grep -v bootstrap | sed '1d' | sed 's,\./,,g'); do 

  # Go to sample directory containing its scaffolds 
  cd ${workdir}/MSMC2/${array}_demography/${i}

  # Calculate the number of scaffolds that need to be bootstrapped for the sample 
  boots="$(ls scaf* | wc -l)"
 
  # Run bootstrapping using the python script provided from msmc developers
  /lustre/scratch/gbehrend/EthiopianBirdsProject/MSMC2/msmc-tools/multihetsep_bootstrap.py  \
  -n 10 \
  -s 1000000 \
  --chunks_per_chromosome 30 \
  --nr_chromosomes ${boots} \
  --seed 324324 bootstrap *txt
  
  cd ${workdir}/MSMC2/${array}_demography; done 

# Add species msmc file paths to a list that will be used as input for MSMC2 (helper1.txt):
for i in $(find ~+ -type d | sed '1d' | sed 's,\./,,g'); do echo "${i}/*txt" >> \
${workdir}/MSMC2/${array}_demography/helper1.txt; done

# Make MSMC2 output prefixes (helper2.txt): 
sed 's,Cossypha_semirufa_demography/,,g' helper1.txt | sed 's,/bootstrap_,_b,g' | \
sed 's,/\*txt,,g' >> ${workdir}/MSMC2/${array}_demography/helper2.txt 


