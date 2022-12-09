# Calculating Reich's Fst and Plotting the Results 

Step 1: FST_Filter.sh - Filters VCF files from GATK using VCFTools and removes troublesome neosex chromosomes in Passerines
that could bias genome-wide estimates.  

Step 2: Concat_Filtered.sh - Concatenates into single VCFs. 

Step 3: Run Calculate_Plot_FST.r. 
This script will have to be heavily modified for other projects. The function to calculate Reich and Colleague's FST 
was taken from Jessica Rick's GitHub @ https://github.com/jessicarick/reich-fst

