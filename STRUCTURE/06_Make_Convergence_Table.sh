## Generating a table to plot likelihood fluctuations through MCMC iterations of structure. 
sed -n '/BURNIN completed/,/MCMC completed/p' <input file> | sed  's/Rep#:    Alpha      F1    F2    F3      r        Ln Like//g' | sed 's/    /\t/g' | sed 's/  /\t/g' | sed 's/ /\t/g' | sed 's/\t\t/\t/g' | sed 's/Est//g' | grep -v "P(D)" > <output file>

# This file will be used in the Plot_Convergence.R script 
