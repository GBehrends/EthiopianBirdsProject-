#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Concat_ALL
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

# Concatenate all scaffolds     

for i in $(cat ../specieslist); do
more ${i}/scaffold_135_arrow_ctg1.recode.vcf > Concat/${i}_Concat_6DP.vcf
for x in $(cat ConcatList.txt); do grep -v "#" ${i}/${x} >> Concat/${i}_Concat_6DP.vcf; done
sed -i '1d;2d;3d' Concat/${i}_Concat_6DP.vcf
; done
