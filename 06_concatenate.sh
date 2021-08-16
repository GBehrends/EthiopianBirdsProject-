#Start interactive session on cluster
interactive -p nocona -c 1

# For my project, I have a main project directory with all the data for individual species in separate directories. Within these directories are 
# directories with 10kbp and 20kbp thinned vcfs. They all have the same scaffolds.


# Move to 10kbp thinned directory within a species, containing the vcf scaffolds.  
cd <directory>


# Create List of files to concatenate 
ls > ConcatList.txt

# Go into the new txt file, take note of the first scaffold, then remove it. For mine it was "scaffold_135_arrow_ctg1.recode.vcf". The lists own name
# will be added to the Concatlist.txt file, remove this as well. 

# Move this ConcatList.txt file to the main project directory to use for all species and filtering regimes. This works for my 
# project, because all species have the same scaffolds aligned via the Zebra Finch genome.  
mv ConcatList.txt ../../EthiopianBirdsProject

# Move to main project directory.
cd ../../EthiopianBirdsProject
 
# I started by adding the full scaffold vcf that was removed from ConcatList.txt to a concatenated vcf file in all species 20kbp_filtered, 
# 10kbp_filtered, and NoTin_Vcf directories. This will serve as the initial scaffold in building the concatenated vcf. 

for i in $(cat specieslist); do more ${i}/10kbp_filtered_vcf/scaffold_135_arrow_ctg1.recode.vcf >> ${i}/10kbp_filtered_vcf/${i}10kbpConcat.vcf; done
for i in $(cat specieslist); do more ${i}/20kbp_filtered_vcf/scaffold_135_arrow_ctg1.recode.vcf >> ${i}/20kbp_filtered_vcf/${i}20kbpConcat.vcf; done
for i in $(cat specieslist); do more ${i}/NoThin_Vcf/scaffold_135_arrow_ctg1.recode.vcf >> ${i}/NoThin_Vcf/${i}NoThinConcat.vcf; done

# Now we can use a nested for loop including the list of the individual species directories and their 20kbp directory vcf scaffolds to concatenate all 
# scaffolds into one in each species. This for loop removes the vcf header by inverse grepping for "#". These headerless vcf scaffolds are added to the 
# initial concatenated vcf file so there is only one header.   

for i in $(cat specieslist); do for x in $(cat ConcatList.txt); do grep -v "#" ${i}/10kbp_filtered_vcf/${x} >> 
${i}/10kbp_filtered_vcf/${i}10kbpConcat.vcf; done; done


for i in $(cat specieslist); do for x in $(cat ConcatList.txt); do grep -v "#" ${i}/20kbp_filtered_vcf/${x} >> 
${i}/20kbp_filtered_vcf/${i}20kbpConcat.vcf; done; done


for i in $(cat specieslist); do for x in $(cat ConcatList.txt); do grep -v "#" ${i}/10kbp_filtered_vcf/${x} >> 
${i}/NoThin_Vcfcf/${i}NoThinConcat.vcf; done; done

# Export these new vcf files to local computer

# Make Concatenated vcf directories in main project directory. 
mkdir ConcatVcf
mkdir ConcatVcf/NoThin

# Move your concatenated files to their respective directories 
mv <species directory>/<filtering directory>/<filter>Concat.vcf ConcatVcf
mv <species directory>/<filtering directory>/NoThinConcat.vcf ConcatVcf/NoThin




