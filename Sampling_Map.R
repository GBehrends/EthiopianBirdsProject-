###Creating a map of sampling locations in Ethiopia 

#Install the required packages 
install.packages("raster")
install.packages("rgl")
install.packages("sf")
install.packages("rgeos")
install.packages("showtext")
install.packages("col2rgb")


#Load packages 
library(raster)
library(sf)
library(rgdal)
library(rgeos)


#Use raster package to download elevation map 
ETH3 <- getData("alt", country = "ethiopia", mask = TRUE)

#Read in files for water features (st_read table is for easy perusing of contents)
#Make sure that the coordinate reference system is the same between the raster and the shapefiles for download  
Waterways <- readOGR("/Volumes/T7/RScripts/Map_Data/waterways/waterways.shp") #Downloaded From https://mapcruzin.com/free-ethiopia-arcgis-maps-shapefiles.htm
Lakes <- readOGR("/Volumes/T7/RScripts/Map_Data/eth_water_areas_dcw/eth_water_areas_dcw.shp") #Downloaded from http://geoportal.icpac.net/layers/geonode%3Aeth_water_areas_dcw
LakesTable <- st_read("/Volumes/T7/RScripts/Map_Data/eth_water_areas_dcw/eth_water_areas_dcw.shp") 
GRV <- readOGR("/Volumes/T7/RScripts/Map_Data/great_rift_valley_ofb/great_rift_valley_ofb.shp") #Downloaded from http://worldmap.harvard.edu/data/geonode:great_rift_valley_ofb
GRV_ETH <- raster::intersect(GRV, ETH3) #Crop rift valley to size
ETH_Boundries <- readOGR("/Volumes/T7/RScripts/Map_Data/Boundry/ETH_adm0.shp") #Downloaded from https://geodata.lib.berkeley.edu/catalog/stanford-gy496hh6563

#Crop Rift valley shapefile to Ethiopia's boundaries
GRV_ETH <- crop(GRV, ETH_Boundries)

#Make a transparent shade for GRV and other land features by manipulating the alpha value in rgb()
colors() #Lists color names 
col2rgb("darkblue")
GRV_Col <- rgb(171, 171, 171, max = 255, alpha = 100, names = "my_gray")
Tana_col <- rgb(0, 0, 139, max = 255, alpha = 100, names = "tana_col")

#Read in the csv file containing sampling locations 
Sample_Locs <- read.csv("/Volumes/T7/RScripts/Map_Data/locations_map2.csv", header=FALSE)

#Plot the raster map with points, lines, and labels (plot and lines for the lake data must be run separate)  
plot(ETH3) 
lines(Waterways[which(Waterways$name == "Blue Nile"), ], col = Tana_col) 
plot(Lakes[61, ], col = "lightblue", border = Tana_col, add = TRUE) 
lines(Lakes[61, ], col = Tana_col) 
lines(GRV_ETH) 
lines(ETH_Boundries, add = TRUE)
plot(GRV_ETH, col = GRV_Col, add = TRUE)
points(Sample_Locs$V3, Sample_Locs$V2, pch = 17) 


#I decided to create labels for legend and features using adobe illustrator. However, it was possible with the following code added before the plotting stage:

#Use custom font for map with showtext pkg if desired:
font_add("ETH", "/Users/garrettbehrends/Downloads/customfont.otf")
showtext_auto()

#Add this code with the rest of the plot for labels in R
text(Sample_Locs[2,], Sample_Locs$V2, labels = Sample_Locs[2,1], pos = 4, family = "Sans",cex = 1) 
text(Sample_Locs[1,3], Sample_Locs[1,2], labels = "Choke 
  Mountains", pos = 2.5, family = "Sans",cex = 1) 
text(Sample_Locs[4,3], Sample_Locs[4,2], labels = Sample_Locs[4, 1], pos = 2.5, family = "Sans", cex = 1)
text(40.75, 10, labels = "GRV", family = "Sans", cex = 1.5)
text(37.75, 12.2, labels = "Lake Tana", pos = 3, family = "Sans",cex = 1)





