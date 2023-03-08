#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=b00t_list
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition=quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

# Establish working directory 
workdir=?

for i in $(cat ../specieslist); do 
  cd ${i}_demography;
  find ~+ -type -f | grep "scaf" >> ${workdir}/MSMC2/bootsrapslist.txt;
  cd ../; done 


