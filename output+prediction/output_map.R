library(ggmap)

final_loc = read.csv('output/final_loc.csv')
map <- qmap('Porto',zoom=13,maptype='hybrid')
map + geom_point(data=final_loc,aes(x=LONGITUDE,y=LATITUDE),color="red",size=3,alpha=0.5)
