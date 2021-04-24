#Start interactive session on cluster
interactive -p nocona -c 1


#Move to working directory 
cd *working directory*


#Concatenate all scaffold .recode.vcf files into one 
bcftools concat 20kbp_filtered_vcf/*.recode.vcf > 20kbpfiltered.recode.vcf
bcftools concat 10kbp_filtered_vcf/*.recode.vcf > 10kbpfiltered.recode.vcf

#Separate the new combined vcf file into vcf files corresponding to each sample 
for file in 20kbpfiltered.recode.vcf; do
  for sample in `bcftools query -l $file`; do
    bcftools view -c1 -Oz -s $sample -o ${file/.vcf*/.$sample.vcf.gz} $file
  done
done

for file in 10kbpfiltered.recode.vcf; do
  for sample in `bcftools query -l $file`; do
    bcftools view -c1 -Oz -s $sample -o ${file/.vcf*/.$sample.vcf.gz} $file
  done
done

#Export these new vcf.gz files to local computer
