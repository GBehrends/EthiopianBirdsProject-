## Generating Q files to be used in Plot_STRUCTURE.R 

# Assuming that you used a dataset with 0 missing data allowed, this code will isolate the Q matrix, and make it tab delimited. 
grep "(0)" <input file> | sed 's/    /\t/g' | sed 's/   /\t/g' | sed 's/  /\t/g' | sed 's/ /\t/g' > <input file>.Q

# If your dataset allowed missing data, use this code instead. 
sed -n '/Label/,/Estimated Allele Frequencies in each cluster/p' <name of file> | head -n <number of individuals +1> | tail -n <number of individuals> | sed 's/    /\t/g' | sed 's/   /\t/g' | sed 's/  /\t/g' | sed 's/ /\t/g' > ${i.%*}.Q

# Add the column of sample IDs to the Q matrix. I already had these in a file in the same order so I pasted it on. 
paste <input file>.Q <location of sample ID list> | sed 's/\t\t/\t/g' > <input file>_2.Q


# Files are now ready to be used in Plot_STRUCTURE.R
