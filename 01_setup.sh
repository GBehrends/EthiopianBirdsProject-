# start an interactive session and wait to be logged in to a compute node
interactive -c 1 -p quanah

# move to your working directory for this project
cd <working directory>

# make directories for organization during analyses
mkdir 00_fastq
mkdir 01_cleaned
mkdir 01_mtDNA
mkdir 01_bam_files
mkdir 02_vcf
mkdir 03_vcf
mkdir 10kbp_filtered_vcf
mkdir 20kbp_filtered_vcf
mkdir 06_related_files
mkdir 10_align_script
mkdir 12_filter_scripts
mkdir 13_convert_scripts

#####################################
#####################################
#####################################
##### transfer your raw data files for this project to the directory 00_fastq
#####################################
#####################################
#####################################

#####################################
#####################################
#####################################
##### make a file map in the style (and same name) of the file "rename_samples.txt" for your samples
##### and put it in your 00_fastq directory
#####################################
#####################################
#####################################

#####################################
#####################################
#####################################
##### make a sample name file in the style (and same name) of the file "camp_popmap.txt" for your samples
##### and put it in the main working directory
##### This file is essentially just the names of the samples in your study.
##### Make sure the names and numbers are in the same order as the file map you just created.
##### The names in the first column should be in the format "C-###"
##### If the sample number is less than 3 digits, add the appropriate number of preceding zeros to make it three digits.
#####################################
#####################################
#####################################

#####################################
#####################################
#####################################
##### make a mtDNA name conversion file in the style (and same name) of the file "camp_mtdna_name.txt" for your samples
##### and put it in the 01_mtDNA directory
##### Make sure the names and numbers are in the same order as the file map you created.
##### The names in the first column should be in the format "C-###__mtDNA.fastq.gz"
#####################################
#####################################
#####################################

# move to the fastq directory
cd <working directory>/00_fastq/

# rename the files in a numbered fashion
while read -r name1 name2; do
	mv $name1 $name2
done < rename_samples.txt

# move to your main working directory, obtain reference for later alignment and variant calling, and make an index (.fai) file for your fasta reference 
cd *working directory*
wget <url of fasta reference genome>
samtools faidx <fasta file>