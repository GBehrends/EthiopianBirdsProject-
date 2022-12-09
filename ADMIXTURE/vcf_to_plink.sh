#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=plink_convert
#SBATCH --nodes=1 --ntasks=4
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

module load vcftools plink

#Convert concatenated vcf files to plink format for ADMIXTURE
vcftools --vcf Turdus_abyssinicus10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Turdus_10kbp
vcftools --vcf Turdus_abyssinicus20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Turdus_20kbp
vcftools --vcf Serinus_tristriatus10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Serinus_10kbp
vcftools --vcf Serinus_tristriatus20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Serinus_20kbp
vcftools --vcf Zosterops_poliogastrus10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Zosterops_10kbp
vcftools --vcf Zosterops_poliogastrus20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Zosterops_20kbp
vcftools --vcf Melaenornis_chocolatinus10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Melaenornis_10kbp
vcftools --vcf Melaenornis_chocolatinus20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Melaenornis_20kbp
vcftools --vcf Parophasma_galinieri10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Parophasma_10kbp
vcftools --vcf Parophasma_galinieri20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Parophasma_20kbp
vcftools --vcf Cossypha_semirufa10kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Cossypha_10kbp
vcftools --vcf Cossypha_semirufa20kbpConcat.vcf --plink --chrom-map chrom_map.txt --out Cossypha_20kbp


plink --file Turdus_10kbp --recode 12 --allow-extra-chr --out Turdus_10kbp2 --noweb
plink --file Turdus_20kbp --recode 12 --allow-extra-chr --out Turdus_20kbp2 --noweb
plink --file Serinus_10kbp --recode 12 --allow-extra-chr --out Serinus_10kbp2 --noweb
plink --file Serinus_20kbp --recode 12 --allow-extra-chr --out Serinus_20kbp2 --noweb
plink --file Zosterops_10kbp --recode 12 --allow-extra-chr --out Zosterops_10kbp2 --noweb
plink --file Zosterops_20kbp --recode 12 --allow-extra-chr --out Zosterops_20kbp2 --noweb
plink --file Melaenornis_10kbp --recode 12 --allow-extra-chr --out Melaenornis_10kbp2 --noweb
plink --file Melaenornis_20kbp --recode 12 --allow-extra-chr --out Melaenornis_20kbp2 --noweb
plink --file Parophasma_10kbp --recode 12 --allow-extra-chr --out Parophasma_10kbp2 --noweb
plink --file Parophasma_20kbp --recode 12 --allow-extra-chr --out Parophasma_20kbp2 --noweb
plink --file Cossypha_10kbp --recode 12 --allow-extra-chr --out Cossypha_10kbp2 --noweb
plink --file Cossypha_20kbp --recode 12 --allow-extra-chr --out Cossypha_20kbp2 --noweb
