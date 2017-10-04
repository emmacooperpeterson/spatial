library(readr)
library(lubridate)
library(dplyr)
library(foreign)

setwd("~/Desktop/Repositories/spatial/")

vehicles <- read_csv("311_Service_Requests_-_Abandoned_Vehicles.csv")

#reformat date
vehicles$create_date <- as.Date(vehicles$"Creation Date","%m/%d/%Y")

#create year and month variables
vehicles$year <- year(vehicles$create_date)
vehicles$month <- month(vehicles$create_date)

#filter for september 2015
vehicles <- filter(vehicles, year == 2015 & month == 9)

#select desired variables
variables <- c("year","month","create_date","Ward","Police District",
               "Community Area","Latitude","Longitude")

vehicles <- vehicles[variables]

#write new csv
write.csv(vehicles,"vehicles2015_9.csv",row.names=FALSE)

##### working in geoda #####

#read data back in from geoda
vpoints <- read.dbf("shape files/vehicles.dbf")

#calculate point count by community area
pcounts <- table(vpoints$comm_area)
pcframe <- as.data.frame(pcounts)

#we are missing community areas 47 and 54. need to add rows with 0 count.
nnf <- pcframe$Var1 #get factor levels
nnn <- as.numeric(levels(nnf)) #convert factor levels to numeric

#initialize a vector of length 77 to 0
#extract the Freq column from the pcframe data frame 
#and assign it to the row numbers that correspond to nnn.
narea <- max(vpoints$comm_area)
vc <- vector(mode="numeric",length=narea)
vc[nnn] <- pcframe$Freq

nid <- (1:narea)
vcframe <- data.frame(as.integer(nid),as.integer(vc))


