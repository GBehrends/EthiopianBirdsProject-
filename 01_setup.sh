# WARNING #
# DO NOT USE THIS METHOD IF ONE SPECIES HAS MORE THAN 9 SAMPLES #
# If you have more than 9 samples per species, you will have to #
# make directories for subsets of 9 individuals per species, OR #
# manually rename your samples in the fashion presented in the  #
# "EthiopPopMap.txt Example" file, except that you will have to #
# number 1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 2, 20, 21.. #
# etc. IN THAT ORDER. The programs further downstream read      #
# samples in in this way. You can use the PopMap_rename.sh and  #
# edit the names and popmap file accordingly if needed after    #
# running it.                                                   #

# Start an interactive session and wait to be logged in to a compute node
interactive -c 1 -p quanah

# Move to your working directory for this project
cd <working directory>

# Make directories for all species as well as nested 00_fastq directories
mkdir *species name*
mkdir *species name*/00_fastq

#####################################
#####################################
#####################################
##### Transfer your raw data files for this project to their corresponding species 00_fastq directory. Can be either fastq or fastq.gz. 
#####################################
#####################################
#####################################

# Copy the contents of PopMap_rename.sh into a script and then make the script executeable using chmod. 

# Run PopMap_rename.sh.
# This renames samples in each 00_fastq directory in a numbered fashion #
# and generates a map to know what number corresponds to what original  #
# sample name, as well as a list of the sample prefixes for later use.  #

./PopMap_Rename.sh


# Check to see all the files are in their proper place and the numbers and original file names correspond to eachother. 
