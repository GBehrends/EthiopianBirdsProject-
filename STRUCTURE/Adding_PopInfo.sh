# Adding location information to the STRUCTURE file for use in the LOCPRIOR model
interactive -p nocona -c 1

# Create a list of sampling locations so that they occur twice to correspond to each row 
# of each individuals genotype info in the STRUCTURE files like so: 

# 1
# 1
# 2
# 2 
# ..etc

# Name this as the LocationList.txt

# Now you can insert that into the STRUCTURE file. 
cut -f1 <structure file> > Beginning.txt 
cut -f1 --complement <structure file> > Ending.txt
paste Beginning.txt LocationList.txt Ending.txt > <new structure file name>
rm <structure file>
