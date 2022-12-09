#Move to the directory with complete filtered vcfs 
cd EthiopianBirdsProject/ConcatVcf

# Make a chromosome-map consisting of 2 columns, each containing a list of all chromosomes. An example can be seen in the main project folder. 
# Since the chromosome map is the same for all species, it need only be made once. 


grep -v "#" <species+filter>.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map.txt

# Submit the vcf_to_plink.sh script to convert the vcfs to plink format

# Intiate interactive session. 
# Since admixture uses the outputted .ped files, I used a list of these files to run an admixture for loop to avoid running admixture 60 times individuals.

ls | grep "ped" | grep "kbp2" > AdmixtureList.txt

# Run Admixture using a for loop on the input AdmixtureList file. 

 for i in $(cat AdmixtureList.txt); do for K in 1 2 3 4 5; do admixture --cv ${i} $K | tee log_${i}_$K.out; done; done
 
 # This will output 60 admixture runs, 5 for each of the 12 ped files.
 # To compare between results between the two filtering schemes, and between species, I placed all of the CV outputs used to indicate the likely number 
 # of populations into one file with the appropriate header. 
 
 # I started by generating a list of the unique log output files then ran this in a for loop that put all the cv outputs for each k for each species
 # into one file with the appropriate species header. An example is shown in EthiopianBirdsProject directory as CV.txt. 
 
 ls | grep "ped_" | sed 's/_/\t/g' | cut -f 1,2,3 | sed 's/\t/_/g' | uniq > logList.txt
 
 for i in $(cat logList.txt); do more logList.txt | grep ${i} >> CV.txt; grep -h CV ${i}_*.out >> CV.txt; done
 
 
## Convert output Q files into tab delimited format for plotting in R with list of target Q files 

for q in $(cat QtoTSVList.txt); do sed 's/ /\t/g' ${q}Q > ${q}tsv; done

# In R, it will be useful to have each row of the tsv file labeled with its proper SampleID. For this I used a sampleID list derived from the first
# column of the PopMap files in the 00fastq directories for each species directory. I pasted the Sample IDs to the tsv file for each species in the Admixture 
# directory that housed my tsv files and named the new files with a labeled designation.  

# Starting from parent directory

cd Turdus_abyssinicus/00fastq 
paste -d "\," SampleID.txt ../../Admixture/Turdus_10kbp2.3.tsv | sed 's/,/\t/g' > ../../Admixture/Turuds_Labeled.3.tsv

#Repeat this for all species and thinning filters. 


# Export these to computer for plotting
