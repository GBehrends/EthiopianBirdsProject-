## Ethiopian Sampling Map ##

library(raster)
library(sf)


# Gather Ethiopia elevation and boundary data 
ETH <- getData(name = "alt", country = "Ethiopia", mask = F)
Boundary <- getData(country = "Ethiopia", level = 0)

# Mask extent for Ethiopia using the boundary data
ETH <- mask(ETH, Boundary)

# Read sample locations for plotting
Sample_Locs <- 
  read.csv("<location of csv with sampling location coordinates", 
           header=FALSE)

# Plot it all and save to PDF

setwd("<location of all map data>")

pdf(file = "EthiopiaSamplesMap.pdf", 
    width = 12, height = 8)
plot(ETH, col = c('#ffffe5','#fff7bc','#fee391','#fec44f','#fe9929','#ec7014'
                  ,'#cc4c02','#993404','#662506'))
lines(Boundary, add = TRUE, lwd = 2)
points(Sample_Locs$V3, Sample_Locs$V2, pch = 17, cex = 3) 
scalebar(300, xy = NULL, type = "line", divs = 1,
         lonlat = NULL)
dev.off()
