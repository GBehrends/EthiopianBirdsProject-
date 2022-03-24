# Using the same output prefix from the RunSTRUCTURE.sh script, run this for loop that will gather all the ln likelihood scores from all replicates to chose the best Q file to use. 

for i in $(ls <output>* ); do grep "Estimated Ln Prob of Data   =" ${i} /dev/null | sed 's/:/\t/g' | sed 's/Estimated  Ln  Prob  of  Data  =  //g' | cut -f2 >> <output>_Runs.tsv; done 

# It may be prudent to save all of these in a table somewhere. 
