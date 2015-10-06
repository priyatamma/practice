### RUN THIS FROM THE TOP LEVEL!!!

# three csv files that are copy and pasted from Distance data viewer
# wtal-observation(axax).csv
# wtal-segment.csv

# Read in data from *.csv & *.txt

wtal.obs<-read.csv("F:/DSM/speciesobsdata/Chital (313989).csv",header=FALSE)
wtal.seg<-read.csv("F:/DSM/wtal-segment.csv",header=FALSE)
wtal.pred <- read.table("F:/DSM/wtal-pred.txt",skip=5)


# centroid of the survey area
lon0 <- 78.547395
lat0 <- 29.76037


# create obsdata
# * ``object`` - object id
# * ``Segment.Label`` - the segment the observation occurred in
# * ``size`` - group size for the observation
# * ``distance`` - perpendicular/radial distance to observation

# get rid of the column titles put there by Distance
obs.tmp <- wtal.obs[6:nrow(wtal.obs),]

obsdata <- data.frame(
                      object=1:nrow(obs.tmp),
                      Sample.Label=as.character(obs.tmp[,13]),
                      size=as.numeric(as.character(obs.tmp[,30])),
                      distance=as.numeric(as.character(obs.tmp[,28])),
                      Effort=1000*as.numeric(as.character(obs.tmp[,14]))
                     )
obsdata$size[is.na(obsdata$size)] <- 0
obsdata$distance[is.na(obsdata$distance)] <- 0

# create segdata
# * ``x`` - centreline of the transect (i.e. "across the transect")
# * ``y`` - centre in the direction of the transect (i.e. "up/down")
# * ``Effort`` - the effort expended
# * ``Transect.Label`` - identifier for the transect this segment is in
# * ``Segment.Label`` - identifier for the segment (unique!)
# * ``esw`` - effective strip width... ?

# top 5 rows are the column titles from Distance
seg.tmp <- wtal.seg[6:nrow(wtal.seg),]

# use lat and long for now
segdata <- data.frame(
                      latitude=as.numeric(as.character(seg.tmp[,15])),
                      longitude=as.numeric(as.character(seg.tmp[,16])),
                      Effort=1000*as.numeric(as.character(seg.tmp[,14])),
                      Transect.Label=as.character(seg.tmp[,9]),
                      Sample.Label=as.character(seg.tmp[,13]),
                      elev=as.double(as.numeric(as.character(seg.tmp[,17]))),
			    rugg=as.double(as.numeric(as.character(seg.tmp[,18]))),
			    ndvi=as.double(as.numeric(as.character(seg.tmp[,19]))),
			    ndCV=as.double(as.numeric(as.character(seg.tmp[,20]))),
			    vegcl=as.double(as.numeric(as.character(seg.tmp[,21]))),
			    drainD=as.double(as.numeric(as.character(seg.tmp[,22]))),
			    agriD=as.double(as.numeric(as.character(seg.tmp[,23]))),
			    deraD=as.double(as.numeric(as.character(seg.tmp[,24]))),
			    hab=as.double(as.numeric(as.character(seg.tmp[,25]))),
			    pa=as.double(as.numeric(as.character(seg.tmp[,26])))			    
                     )
# Convert latitude and longitude to Northings and Eastings

# calculate the northings and eastings
seg.tmp <- latlong2km(segdata$longitude, segdata$latitude, lon0=lon0, lat0=lat0)
segdata <- cbind(segdata, x=1000*seg.tmp$km.e, y=1000*seg.tmp$km.n)
rm(seg.tmp)

### distance data
# create what we want for the mrds analysis
distdata <- obsdata[obsdata$size>0,]
distdata$Sample.Label <- NULL
distdata$detected <- rep(1,nrow(distdata))
head(distdata)
# include the lat/long but just for plotting
distdata$latitude <- as.numeric(as.character(obs.tmp[,15][obsdata$size>0]))
distdata$longitude <- as.numeric(as.character(obs.tmp[,16][obsdata$size>0]))

ds.tmp <- latlong2km(distdata$longitude, distdata$latitude, lon0=lon0, lat0=lat0)
distdata <- cbind(distdata, x=1000*ds.tmp$km.e, y=1000*ds.tmp$km.n)
rm(ds.tmp)


#### prediction data
preddata<-data.frame(latitude=wtal.pred[,7],
                     longitude=wtal.pred[,6],
                     elev=as.double(wtal.pred[,8]),
rugg=as.double(wtal.pred[,9]),
ndvi=as.double(wtal.pred[,10]),
ndCV=as.double(wtal.pred[,11]),
vegcl=as.double(wtal.pred[,12]),
drainD=as.double(wtal.pred[,13]),
agriD=as.double(wtal.pred[,14]),
deraD=as.double(wtal.pred[,15]),
hab=as.double(wtal.pred[,16]),
pa=as.double(wtal.pred[,17]))

pred.tmp <- latlong2km(preddata$longitude, preddata$latitude, lon0=lon0, lat0=lat0)
preddata <- cbind(preddata, x=1000*pred.tmp$km.e, y=1000*pred.tmp$km.n)

# find the width and height of each cell for plotting and finding the offset
lr <- c(preddata$longitude-1/6, preddata$longitude+1/6)
tb <- c(preddata$latitude-1/6, preddata$latitude+1/6)

lr.tmp <- latlong2km(lr, rep(preddata$latitude,2), lon0=lon0, lat0=lat0)
tb.tmp <- latlong2km(rep(preddata$longitude,2), tb, lon0=lon0, lat0=lat0)

preddata$width <- 1000*
(lr.tmp$km.e[(length(preddata$latitude)+1):length(lr.tmp$km.e)]-
lr.tmp$km.e[1:length(preddata$latitude)])
preddata$height <- 1000*
(tb.tmp$km.n[(length(preddata$latitude)+1):length(tb.tmp$km.n)]-
tb.tmp$km.n[1:length(preddata$latitude)])

rm(lr, tb, lr.tmp, tb.tmp, pred.tmp)

obsdata <- obsdata[obsdata$size>0,]

# save everything to file
save(segdata,obsdata,distdata,preddata,file="F:/DSM/speciesdata/chital.RData")

load("F:/DSM/speciesdata/chital.RData")
head(distdata)
head(obsdata)
head(preddata)
head(segdata)
head(seg.tmp)