# Estimating Historic NE Trajectories using MSMC2

Step 1: Run 01_MSMC_Species.sh. This script will generate the msmc2 scaffolds and all 
their bootstraps for each species and its samples.  

Step 2: Concatenate all species helper1 and helper2 files into a helper1.txt file and 
helper2.txt file into main working directory where 02_MSMC.sh will be run. Run 02_MSMC.sh
