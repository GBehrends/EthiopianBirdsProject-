#Start interactive session on cluster
interactive -p nocona -c 1


#Move to working directory 
cd <working directory>


#Concatenate all scaffold .recode.vcf files into one 
bcftools concat 20kbp_filtered_vcf/*.recode.vcf > 20kbpfiltered.recode.vcf
bcftools concat 10kbp_filtered_vcf/*.recode.vcf > 10kbpfiltered.recode.vcf


#Export these new vcf.gz files to local computer
