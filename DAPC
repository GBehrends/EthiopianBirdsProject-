                                                                   #DAPC#
                                                          

### DAPC will be run to analyze population structure in each species. The code for doing so and plotting the results is presented below. ###
### This process needs to be repeated for each species individually. It uses thinned vcfs as suggested by the authors of DAPC. These     ###
### Thinned VCFs were iutputted in the 10KBP and 20KBP_filtered_vcf directories for each species. Here, both thinning regimes are        ###
### analyzed to assess their effects on the DAPC results. Don't run these scripts on individual scaffolds, concatenate the scaffolds     ###
### together first in the method outlined in the README.txt file.                                                

setwd("<directory on computer with the concatenated vcf files")

install.packages("vcfR")
install.packages("adegenet")

library(vcfR)
library(adegenet)
  
 
# Read in the vcf files 

cossypha_vcf1 <- read.vcfR("Cossypha_semirufa10kbpConcat.vcf")
cossypha_vcf2 <- read.vcfR("Cossypha_semirufa20kbpConcat.vcf")


# Adegenet uses genlight objects for storing vcfs. Make the genlights. 

cossypha_gl1 <- vcfR2genlight(cossypha_vcf1) #10kbp thinned 
cossypha_gl2 <- vcfR2genlight(cossypha_vcf2) #20kbp thinned 



# Run principal components analysis to find the clusters. BIC plots show the optimum number of clusters. Choose the number with the 
# highest score. 

cossypha_grp1 <- find.clusters(cossypha_gl1,max.n.clust=3,n.iter=1e5) #10kbp thinned cossypha_vcf
cossypha_grp2 <- find.clusters(cossypha_gl2,max.n.clust=3,n.iter=1e5) #20kbp thinned cossypha_vcf



# Run the cossypha_pca.

cossypha_pca1 <- glPca(cossypha_gl1) 
cossypha_pca2 <- glPca(cossypha_gl2)



# Assign the sampling locations to each genlight object. This helps with labeling in the plotting step.
# Take care to check that all are correct referencing the PopMap made in the genotyping steps along with the location data from sampling.  

pop(cossypha_gl1)<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Choke_Mountains", 
"Choke_Mountains", "Choke_Mountains")) 
ploidy(cossypha_gl1) <- 2
popNames(cossypha_gl1)

pop(cossypha_gl2)<- as.factor(c("Bale Mountains", "Bale Mountains", "Bale Mountains", "Menagesha", "Menagesha", "Choke_Mountains", 
"Choke_Mountains", "Choke_Mountains")) 
ploidy(cossypha_gl2) <- 2
popNames(cossypha_gl2)



# Run DAPC and plot it (# of PC = 3, DF = 2)
cossypha_dapc1 <- dapc(cossypha_gl1, pop = NULL, cossypha_grp1$cossypha_grp1)# choose 10 pc 1 df
scatter(cossypha_dapc1, scree.da=F, posi.da="bottomleft", offset=0.5, cex=3, pch=17:20, clabel=0, leg=cossypha_gl1$pop)

cossypha_dapc2 <- dapc(cossypha_gl2, pop = NULL, cossypha_grp2$cossypha_grp2)# choose 10 pc 1 df
scatter(cossypha_dapc2, scree.da=F, posi.da="bottomleft", offset=0.5, cex=3, pch=17:22, clabel=0, leg=cossypha_gl2$pop)



                                                               #Fin#
