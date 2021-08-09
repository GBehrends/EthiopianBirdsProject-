# EthiopianBirdsProject-
An analysis of a potential barrier to gene flow 

# Initial genoytping pipeline adapted from pipeline by Joseph D. Manthey @ https://github.com/jdmanthey/camponotus_relatedness
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

# Continued pipeline by me
7. Concatenate filtered ".recode.vcf" scaffold files into one genome-wide file then separate by species. Instructions are found in 06_concatenate.sh. 

# Discriminate Analysis of Principal Components (DAPC) 
8. Export the concatenated sample .vcf files to local computer for further analysis in R using DAPC. 
9. Run DAPC script in R using the DAPC script. 

# ADMIXTURE Analysis
11. Run the ADMIXTURE script step by step on an interactive session. 
12. Export the final labeled tsv files to local computer.
13. Plot the ADMIXTURE results using the Plot Admixture script in R.  


