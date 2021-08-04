#Start interactive session on cluster
interactive -p nocona -c 1

# For my project, I have a main project directory with all the data for individual species in separate directories. Within these directories are directories with 
# 10kbp and 20kbp thinned vcfs. They all have the same scaffolds.


# Move to 10kbp thinned directory within a species, containing the vcf scaffolds.  
cd <directory>


# Create List of files to concatenate 
ls > ConcatList.txt

# Go into the new txt file, take note of the first scaffold, then remove it. For mine it was "scaffold_135_arrow_ctg1.recode.vcf". The lists own name
# will be added to the Concatlist.txt file, remove this as well. 

# Copy this new txt file to all folders where you are going to concatenate vcf files. This works for my project, because all species have the same scaffolds
# aligned via the Zebra Finch genome.  


# Move to main project directory.

# Create a list of the species directory names and save it as specieslist in the parent directory to all spceies directories
 
# I started by adding the full scaffold vcf with its header to a concatenated vcf file in all species 20kbp directories. This will serve as the initial 
# scaffold in building the concatenated vcf. 

for i in $(cat specieslist); do more ${i}/20kbp_filtered_vcf/scaffold_135_arrow_ctg1.recode.vcf >> ${i}/20kbp_filtered_vcf/${i}20kbpConcat.vcf; done

# This scaffold was removed from the original Concat.txt file to avoid repeats. 

# Now we can use a nested for loop including the list of the individual species directories and their 20kbp directory vcf scaffolds to concatenate all 
# scaffolds into one in each species. This for loop removes the vcf header by inverse grepping for "#". These headerless vcf scaffolds are added to the 
# initial concatenated vcf file so there is only one header.   

for i in $(cat specieslist); do for x in $(cat ${i}/20kbp_filtered_vcf/ConcatList.txt); do grep -v "#" ${i}/20kbp_filtered_vcf/${x} >> 
${i}/20kbp_filtered_vcf/${i}20kbpConcat.vcf; done; done

# I repeated this for 10kbp vcf scaffolds
# I realize now that it would actually be faster to copy the ConcatList.txt to the parent directory.  

#Export these new vcf files to local computer





