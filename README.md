# EthiopianBirdsProject-
An analysis of a potential barrier to gene flow 

#Initial vcf pipeline adapted from pipeline by Joseph D. Manthey
1. Perform all steps in 01_setup.sh interactively.
2. Modify the 02_trim_align.sh script as necessary for your directory, put it in your 10_align_script directory, and submit the script for running.
3. Run an interactive job on the cluster.
    a. Move to your main working directory
    b. Load the module for R (module load R) and start R (R)
    c. Run the commands in 03_create_genotype_scripts.r
    d. This creates three nested directories of scripts (11_genotype_scripts) to run in three steps.
4. Run shell script in 11_genotype_scripts/01_gatk_split
    a. Once step e finishes, run the shell script in 11_genotype_scripts/02b_gatk_database
    b. Once step f finishes, run the shell script in 11_genotype_scripts/03b_group_genotype_database
5. Do everything in the 04_setup2.sh script interactively.
6. Run the 05_filter_vcf.sh script

#Continued pipeline by me
7. Concatenate filtered ".recode.vcf" scaffold files into one genome-wide file then separate by sample using the 06_concatenate.sh script 
8. Export the concatenated sample .vcf files to local computer for further analysis. 
