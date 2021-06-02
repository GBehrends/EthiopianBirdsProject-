# start an interactive session and wait to be logged in to a compute node
interactive -c 1 -p quanah

# move to your working directory for this project
cd <working directory>

#Make directories for all species as well as nested 00_fastq directories
mkdir *species name*
mkdir *species name*/00_fastq

#####################################
#####################################
#####################################
##### Transfer your raw data files for this project to their corresponding species 00_fastq directory. Can be either fastq or fastq.gz. 
#####################################
#####################################
#####################################


#Run Pop_Map.sh. This renames samples in each 00_fastq directory in a numbered fashion and generates a map to know what number corresponds to what original sample name, as well as a list of the sample prefixes for later use. 
./PopMap_Rename.sh


#Check to see all the files are in their proper place and the numbers and original file names correspond to eachother. 
