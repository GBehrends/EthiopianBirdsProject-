#!/bin/sh
#SBATCH --job-name=filter
#SBATCH --nodes=1 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=2
#SBATCh -o %x.%j.out
#SBATCH -e %x.%j.err

workdir=/lustre/scratch/gbehrend/EthiopianBirdsProject

#Define where SLURM_ARRAY is derived from; have script read through line by line with the head and tail commands 

input_array=$(head -n${SLURM_ARRAY_TASK_ID} HalfArrayID.txt | tail -n1)
input_array2=$(head -n${SLURM_ARRAY_TASK_ID} HalfArrayID.txt | tail -n 1) 

#Run BBDUK

/lustre/work/jmanthey/bbmap/bbduk.sh in1=${workdir}/00_fastq/${input_array}_R1.fastq.gz in2=${workdir}/00_fastq/${input_array}_R2.fastq.gz out1=${workdir}/01_cleaned/${input_array}_R1.fastq.gz out2=${workdir}/01_cleaned/${input_array}_R2.fastq.gz minlen=50 ftl=10 qtrim=rl trimq=10 ktrim=r k=25 mink=7 ref=/lustre/work/jmanthey/bbmap/resources/adapters.fa hdist=1 tbo tpe 


