#!/bin/sh
#SBATCH --job-name=RAxML_Filt 
#SBATCH --nodes=1 
#SBATCH --ntasks=4
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-<number of total reference assembly scaffolds>


. ~/conda/etc/profile.d/conda.sh
conda activate vcftools

# Filter gVCFs for RAxML phylogenies using a list of all scaffolds in analysis
array=$( head -n${SLURM_ARRAY_TASK_ID} <scaffold list> | tail -n1 )

for i in $(cat <list of subdirectories you want to do filtering in>); do
workdir=<absolute path to parent directory>/${i} 

# run vcftools with SNP output for RAxML. Include invariant sites by omitting --min-alleles. 
# GATK 4.2.3.0 does not give quality scores for genotype calls, so the min quality filters were also omitted to allow the inclusion of more invariant sites.
# Allow for up to 20% of individuals missing calls at any given position.
vcftools --vcf ${workdir}/${array}.g.vcf  --max-missing 0.8  --minDP 6 --max-meanDP 50  --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/${array}; 

# Now run these recoded VCFs through bgzip to compress them for later tabix indexing.
bgzip -c ${workdir}/${array}.recode.vcf > ${workdir}/${array}.recode.vcf.gz

# Index with tabix
tabix -p vcf ${workdir}/${array}.recode.vcf.gz



