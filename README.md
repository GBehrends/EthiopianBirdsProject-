## EthiopianBirdsProject: Analyzing how two lowland barriers have impacted the diversification patterns in six highland songbirds.
Involves population genetic and phylogenetic analyses applied to genomic data. 

- It does not matter what order to go in except that the Genotyping and Filtering directories must be gone through before anything
else can be done (in that order). Also, RAxML has to be done before ASTRAL trees can be made, because RAxML provides the gene 
trees which ASTRAL scripts use.  

- Many of these scripts rely on a file called "specieslist." Before begginning, it would be good to have a text file such as this:

Cossypha_semirufa \n
Melaenornis_chocolatinus \n 
Parophasma_galinieri \n
Serinus_tristriatus \n 
Turdus_abyssinicus \n
Zosterops_poliogastrus \n

.. with one species per line and underscores instead of spaces. 
