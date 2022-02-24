#!/bin/bash 
#SBATCH --job-name=PCA_Plink
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=4


. ~/conda/etc/profile.d/conda.sh
conda activate plink

for i in $(ls *vcf); do 

plink --vcf ${i} --allow-extra-chr --double-id --set-missing-var-ids @:# --pca --out plink_out/${i%.*}; done 




