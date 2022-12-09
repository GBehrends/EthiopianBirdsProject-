# Code for plotting Zosterops poliogastrus tsv files containing the ADMIXTURE results. 

setwd("*tsv directory*")

Zosterops_admixture <- read.delim("Zosterops_Labeled.3.tsv", header = FALSE)

Zosterops_Sample <- c(Zosterops_admixture$V1, Zosterops_admixture$V1, Zosterops_admixture$V1)
Zosterops_AdmixtureProb <- c(Zosterops_admixture$V2, Zosterops_admixture$V3, Zosterops_admixture$V4)
Zosterops_locations <- c("Bale Mountains", "Menagesha", "Menagesha", "Menagesha", "Bale Mountains", "Choke_Mountains", "Choke_Mountains", "Choke_Mountains")
Zosterops_location <- c(Zosterops_locations, Zosterops_locations, Zosterops_locations)
Zosterops_PopGroup <- (c(1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3))

Zosterops_admixture_plot <- cbind.data.frame(Zosterops_Sample, Zosterops_PopGroup, Zosterops_AdmixtureProb, Zosterops_locations)
colnames(Zosterops_admixture_plot) <- c("Sample", "K","Assignment Probability", "Location")

#library(ggplot2)
#install.packages("forcats")
#install.packages("ggthemes")
#install.packages("patchwork") 

#library(forcats)
#library(ggthemes)
#library(patchwork)

# Code to make plot adapted from orginal code authored by Luis D. Verde Arregoitia on GitHub @ https://luisdva.github.io/rstats/model-cluster-plots/
zost_addplot <-
  ggplot(Zosterops_admixture_plot, aes(factor(Zosterops_Sample), Zosterops_AdmixtureProb, fill = factor(Zosterops_PopGroup))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Zosterops_location), switch = "x", scales = "free", space = "free") +
  theme_minimal() + labs(x = "Samples", title = "Zosterops poliogastrus: K=3", y = "Ancestry") +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expand_scale(add = 1)) +
  theme(
    panel.spacing.x = unit(0.05, "lines"),
    axis.text.x = element_blank(),
    panel.grid = element_blank()
  ) +
  scale_fill_gdocs(guide = FALSE)
zost_addplot

# Repeat for all species being careful to change: 1) The number of repeats in the PopGroup for varying sample sizes and 
#                                                 2) The locations to match the original locations each sample was taken from. 
