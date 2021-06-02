#!/bin/sh

#Make list of directories

ls -d -- */ > SpeciesList

#Make for loop for all folders corresponding to species 

for s in $(cat SpeciesList); do 

cd ${s}

mkdir 01_cleaned
mkdir 01_bam_files
mkdir 02_vcf
mkdir 03_vcf
mkdir 04_filtered_vcf_100kbp
mkdir 05_filtered_vcf_50kbp
mkdir 06_related_files
mkdir 10_align_script
mkdir 12_filter_scripts
mkdir 13_convert_scripts

cd ..; 

done

#Make maps to show what samples correspond to what number 

for s in $(cat SpeciesList); do

cd  ${s}/00fastq
  
expr $(ls | wc -w) / 2 > words

for ((i=1; i<=$(cat words); i++)); do echo ${i}; done > Numbers

cat Numbers Numbers | sort -n > Numbers2

rm Numbers words 

ls | grep "fastq" | sort -n > samples

paste samples Numbers2 > PopMap

rm samples 

#Make List of what to rename the files to 

ls | grep "fastq" | sed 's/_/\t/g' | cut -f 4 > R1R2

paste Numbers2 R1R2 | sed 's/\t/_/g' > NewNames 

cut -f 1 PopMap > samples

paste samples NewNames > rename_list.txt
rm Numbers2 samples R1R2 NewNames 

#Renaming 

while read -r name1 name2; do
	mv $name1 $name2
done < rename_list.txt


#Make a sample list
more rename_list.txt | cut -f 1,1 | sed 's/_/\t/g' | cut -f 1,2,3 | sed 's/\t/_/g' > sample_list 

cd ../..;

done

#Save the script and make it executeable 
