#turn vod raster data to spatial points DF

library(dplyr)
library(magrittr)
library(raster)
library(rgdal)
library(tiff)
library(WriteXLS)
library("xlsx")


str_name <-'/Users/student/Documents/VOD_Project/vod_summer_geotiff/vod_august_2017_1.tiff'

imported_raster = raster(str_name)

Lake <- read.csv("/Users/student/Documents/VOD_Project/Lake.csv", header=TRUE)
coords = data.frame(lat=Lake[,2],long=Lake[,3])
coordinates(coords)=c("long","lat")

VOD = extract(x=imported_raster,y=coords)

VOD_Extract = as.data.frame(VOD,row.names='august_2017_1')


wb = createWorkbook()

sheet = createSheet(wb, "VOD_Data")

addDataFrame(VOD_Extract, sheet=sheet, row.names=TRUE, startRow=1)


for (x in 1:30) {
  
  
  
  str_name <-'/Users/student/Documents/VOD_Project/vod_summer_geotiff/vod_august_2017'
  str_name <- paste(str_name, x, sep = "_")
  str_name <- paste(str_name, "tiff", sep = ".")
  
  imported_raster = raster(str_name)
  
  Lake <- read.csv("/Users/student/Documents/VOD_Project/Lake.csv", header=TRUE)
  
  coords = data.frame(lat=Lake[,2],long=Lake[,3])
  coordinates(coords)=c("long","lat")
  
  VOD = extract(x=imported_raster,y=coords)
  
  str_name2 <- 'august_2017'
  
  str_name2 <- paste(str_name2, x, sep = "_")
  
  VOD_Extract = as.data.frame(VOD,row.names=str_name2)
  
  
  addDataFrame(VOD_Extract, sheet=sheet, row.names=TRUE, col.names=FALSE, 
               startRow=x+1, showNA = TRUE, characterNA = "NA")
  
  
}

saveWorkbook(wb, "VOD_Lake_August_Test.xlsx")

# close geotiff

