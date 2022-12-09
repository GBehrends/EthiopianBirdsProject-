# Start an interactive session. 
interactive -c 1 -p nocona 


# Prior to install of fastSTRUCTURE, make a directory in the main project directory for it. In addition, make a directory for the

# files with a Thin directory with this one

cd <Main project directory>
mkdir fastSTRUCTURE
cd fastSTRUCTURE
mkdir files
cd files
mkdir Thin

# Male a list of the desired ped files I wanted to convert to bed format and then removed the .ped extension for the conversion
# process.This is because fastSTRUCTURE uses bed format. Ped files have already been made in the ADMIXTURE directory

cd ADMIXTURE 
ls | grep "kbp2.ped" | grep -v "log" | sed 's/.ped//g' > ped2bed.txt

# Put this list into a for loop to make the bed files from all the desired ped files and move them to the fastSTRUCTURE Thin directory  
for i in $(cat ped2bed.txt); do plink --file ${i} --makebed --allow-extra-chr --out ../fastSTRUCTURE/files/Thin/${i}; done 

# Create an envirnoment running Python 2. This is the version you need to run fastStructure. 
conda create py27 python=2.7
conda activate python 2.7

# Install fastStructure from the bioconda channel 
conda install --channel bioconda faststructure

# Locate what directory fastStructure was installed in, and make a note of its path. This path will need to be placed into the 
# fastStructure.sh script before it is submitted. Also, the script will need to be modified for wahtever species you are analyzing. 




