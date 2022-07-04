# R code for rainfall data extraction at single/multiple locations from SM2RAIN nc files

Sys.setenv(TZ="UTC")                                                             #Set TZ according your location
setwd("C:/SM2RAIN/")                                                             #Set Path to nc files
model <- "ASCAT"                                                                 #Set this to ASCAT, GPM or CCI

stations <- data.frame(matrix(nrow=0, ncol=2))
stations$Longitude <- c(-2,-1,1,2)                                               #Set x longitudes
stations$Latitude <- c(14,13.5,13,12.5)                                          #Set y latitudes

#Memory-friendly: define bounding box to cut a smaller portion of the nc files
bbox_lon_min <- -6
bbox_lon_max <- 3
bbox_lat_min <- 8
bbox_lat_max <- 16

date.origin <- list(CCI = c(1,1,1900), GPM=c(1,1,2000), ASCAT=c(1,1,2000))
num_stations <- dim(stations)[[1]]
slat <- stations$Latitude
slon <- stations$Longitude

library(ncdf4)
library(chron)
library(dplyr)
library(subsetnc)


files <- list.files(path = "", pattern = "nc")                                  #List all nc files in the working directory

df <- data.frame(matrix(nrow=0, ncol=num_stations+1))

for (fname in files){
  
  print(paste("Processing >>", fname))
  ncfile <- nc_open(fname)                                                      #List all nc files in the working directory
  
  nc_lon <- ncvar_get(ncfile,"Longitude")
  nc_lat <- ncvar_get(ncfile, "Latitude")
  
  xmin <- nc_lon[which.min(abs(nc_lon - bbox_lon_min))]
  xmax <- nc_lon[which.min(abs(nc_lon - bbox_lon_max))+1]
  ymin <- nc_lat[which.min(abs(nc_lat - bbox_lat_min))]
  ymax <- nc_lat[which.min(abs(nc_lat - bbox_lat_max))+1]
  
  nc_sub <- ncfile %>% nc_subset(Longitude %in% xmin:xmax,
                                 Latitude %in% ymin:ymax)
  nc_close(ncfile)
  
  nc_lon <- ncvar_get(nc_sub,"Longitude")
  nc_lat <- ncvar_get(nc_sub, "Latitude")  
  pr <- ncvar_get(nc_sub, "Rainfall")
  time <- ncvar_get(nc_sub,"Time")
  
  sm2rain <- data.frame(chron(time, origin = date.origin[[model]]))
  
  for (i in 1:num_stations) {
    print(paste("Reading station",stations$Name[i]))
    lon_index <- which.min(abs(nc_lon - slon[i]))
    lat_index <- which.min(abs(nc_lat - slat[i]))
    spr <- pr[,lon_index,lat_index]
    spr[is.na(spr)] <- 0
    sm2rain <- cbind(sm2rain, spr)
  }
  
  rm(pr)
  nc_close(nc_sub)
  
  names(sm2rain) <- c("Date", stations$Name)
  sm2rain$Date <- as.Date(sm2rain$Date)
  
  colnames(df) <- colnames(sm2rain)
  for (i in 1:nrow(sm2rain)) df[nrow(df)+1,] <- sm2rain[i,]
}

df$Date <- as.Date(df$Date, 
                   origin = as.Date(paste(rev(date.origin[[model]]),
                                          collapse="-")))

write.table(df, file=paste0(model,"_SM2RAIN.csv"), sep = ",",                   #CSV output
            row.names = FALSE, col.names = T)

print("Finished.")