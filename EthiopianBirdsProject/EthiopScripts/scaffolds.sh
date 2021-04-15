#!/bin/sh 
#SBATCH --job-name=scaffold 
#SBATCH --nodes=1 --ntasks=1 
#SBATCH --partition quanah 
#SBATCH -o %x.%j.out 
#SBATCH -e %x.%j.err


# For Loop to Generate Scaffolds

for i in { 0001..0135 };

do

printf ’Scaffold_${i}”| printf {1..6};

done; 
