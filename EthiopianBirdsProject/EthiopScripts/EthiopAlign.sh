#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=align 
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=2-43

module load intel java bwa samtools

workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject

#Define where SLURM_ARRAY is derived from; have script read through line by line with the head and tail commands 

input_array=$(head -n${SLURM_ARRAY_TASK_ID} HalfArrayID.txt | tail -n1)

#Reading in Reference Genome 

refgenome=/lustre/scratch/gbehrend/EthiopianBirdsProject/bTaeGut1.pri.cur.20181023.fasta.gz

#Move to Working Directory 

cd /lustre/scratch/gbehrend/EthiopianBirdsProject/

#Run Burrows-Wheeler ALigner Against Zebra Finch Reference Genome 
bwa mem -t 12 ${refgenome} ${workdir}/01_cleaned/${input_array}_R1.fastq.gz ${workdir}/01_cleaned/${input_array}_R2.fastq.gz > ${workdir}/02_bam_files/${input_array}.sam

# convert sam to bam
samtools  view -b -S -o ${workdir}/02_bam_files/${input_array}.bam ${workdir}/02_bam_files/${input_array}.sam

# remove sam
rm ${workdir}/02_bam_files/${input_array}.sam

# clean up the bam file
/lustre/work/jmanthey/gatk-4.1.0.0/gatk CleanSam -I ${workdir}/02_bam_files/${input_array}.bam -O ${workdir}/02_bam_files/${input_array}_cleaned.bam

# remove the raw bam
rm ${workdir}/02_bam_files/${input_array}.bam

# sort the cleaned bam file
/lustre/work/jmanthey/gatk-4.1.0.0/gatk SortSam -I ${workdir}/02_bam_files/${input_array}_cleaned.bam -O ${workdir}/02_bam_files/${input_array}_cleaned_sorted.bam --SORT_ORDER coordinate

# remove the cleaned bam file
rm ${workdir}/02_bam_files/${input_array}_cleaned.bam

# add read groups to sorted and cleaned bam file
/lustre/work/jmanthey/gatk-4.1.0.0/gatk AddOrReplaceReadGroups -I ${workdir}/02_bam_files/${input_array}_cleaned_sorted.bam -O ${workdir}/02_bam_files/${input_array}_cleaned_sorted_rg.bam --RGLB 1 --RGPL illumina --RGPU unit1 --RGSM ${input_array}

# remove cleaned and sorted bam file
rm ${workdir}/02_bam_files/${input_array}_cleaned_sorted.bam

# remove duplicates to sorted, cleaned, and read grouped bam file (creates final bam file)
/lustre/work/jmanthey/gatk-4.1.0.0/gatk MarkDuplicates --REMOVE_DUPLICATES true --MAX_FILE_HANDLES_FOR_READ_ENDS_MAP 100 -M ${workdir}/02_bam_files/${input_array}_markdups_metric_file.txt -I ${workdir}/02_bam_files/${input_array}_cleaned_sorted_rg.bam -O ${workdir}/02_bam_files/${input_array}_final.bam

# remove sorted, cleaned, and read grouped bam file
rm ${workdir}/02_bam_files/${input_array}_cleaned_sorted_rg.bam

# index the final bam file
samtools index ${workdir}/02_bam_files/${input_array}_final.bam
