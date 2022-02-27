## Steps for Genotyping ##

# Begin with a new working directory with nothing in it

# Run 01_Setup.sh

# Install GATK 4.2.3.0 using the GATK install script @ https://github.com/jdmanthey/installs/blob/main/gatk4.2.3.0

# Run 02_Trim_Align.sh Adapted from https://github.com/jdmanthey/certhia_phylogeography

# Run 03_genotype_scripts.r Adapted from https://github.com/jdmanthey/camponotus_relatedness

# Within each subdirectory in 11_genotype_scripts there will be submission scripts with numbers corresponding 
# to the order in which you run their contents. These scripts will break up your reference assembly scaffolds into smaller 
# pieces for efficiency that will need to be put back together for some analyses that are reliant on the original reference 
# assembly's indexing. 

