# This script plots a map of the trips in the test set

library(ggmap)
library(readr)
library(rjson)

test <- read_csv("test.csv")
map  <- readRDS("testmap.rds")

positions <- function(row) 
                as.data.frame(do.call(rbind, fromJSON(row$POLYLINE)))

coordinates <- data.frame(Trip_Id=c(), 
                          Ordinal=c(), 
                          Status=c(), 
                          EndPoint=c(), 
                          Latitude=c(), 
                          Longitude=c())

for (i in 1:nrow(test)) 
{
  pos <- positions(test[i,])
  if (nrow(pos)==1) 
  {
    status <- c("Start Point of the Trip")
  } 
  else 
  {
    status <- c("Start Point of the Trip", 
            rep("Position of Taxi During Trip", 
            nrow(pos)-2), 
            "Last coordinates in the trajectory")
  }
  coordinates <- rbind(coordinates, data.frame(Trip_Id=test$TRIP_ID[i],
                                               Ordinal=1:nrow(pos),
                                               Status = status,
                                               Endpoint = status != "Position of Taxi During Trip",
                                               Latitude = pos$V2,
                                               Longitude = pos$V1))
}
coordinates$Status <- factor(coordinates$Status, 
                    levels <- c("Start Point of the Trip", 
                                "Position of Taxi During Trip", 
                                "Last coordinates in the trajectory"))

p <- ggmap(map) +
     geom_point(data=coordinates, aes(x=Longitude, y=Latitude, color=Status)) +
     ggtitle("Initial Trajectory of Taxi travel in the Test dataset") +
     scale_color_manual(values=c("#377EB8", "#3DAF4F", "#E41A1C")) +
     scale_size_manual(values=c(1.5, 3))
ggsave("test_trips_map.png", p, width=12, height=10, units="in")
