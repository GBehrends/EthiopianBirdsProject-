# Running STRUCTURE on the command line 


### STEP 1 - 
01_SimplifyForStructure.sh
Simplify VCF files so that they can be more easily converted to STRUCTURE file format. 

### STEP 2 - 
02_VCFtoSTRUCTURE.R
Convert the simplified VCF to STRUCTURE format. 

### STEP 3 - 
03_Adding_PopInfo.sh
Add population information or sampling location information for each individual to the structure file if needed.

### STEP 4 - 
Create mainparams and extraparams like those in the 04_RunSTRUCT_extraparams and 04_RunSTRUCT_mainparams files. 
Be sure to place these in the same directory yourun STRUCTURE from. 

### STEP 5 - 
Run STRUCTURE using the 05_RunSTRUCT.sh script. 

### STEP 6 - 
This step is concerned with likelihoods of each run and convergence of the program on asomewhat unified outcome for 
ancestry assignment probabilities. 

a) 06_Likelihood_Scores extracts the likelihood information for each f file outputted by STRUCTURE. These likelihoods
are used to determine which run had the final highest support. 

b) 06_Make_Convergence_Table produces a table to plot the changes in likelihood through time of a run. 

c) 06_Plot_Likelihood_MCMC.R plots each run's likelihood scores over the course of the MCMC proccess. These plots are compared
visually against other runs' plots to see if they all converged on a similar likelihoods through the MCMC process.

### STEP 7 - 
a) 07_Make_Q.r extracts the Q matrices from the STRUCTURE output f files containing the k-cluster assignment probabilities per individual.

b) 07_Plot_STRUCTURE.sh plots all of the replicate runs together in a single facet wrap. The colors will not be held consistent between 
plots, but this doesn't matter as it is only important that the porbabilities themselves stayed somewhat constant between runs. 

c) Use 08_final_plot.r to plot the run that had the highest likelihood output in step 7a. 




