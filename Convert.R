load("F:/DSM/Chital/chital.RData")
head(segdata)
head(obsdata)
head(distdata)
head(preddata)
write.csv(segdata, "F:/DSM/Chital/cnv/segdata.csv")
write.csv(distdata, "F:/DSM/Chital/cnv/distdata.csv")
write.csv(preddata, "F:/DSM/Chital/cnv/preddata.csv")
write.csv(obsdata, "F:/DSM/Chital/cnv/obsdata.csv")

segdata <-read.csv("F:/DSM/Chital/cnv/segdata.csv")
obsdata <-read.csv("F:/DSM/Chital/cnv/obsdata.csv")
distdata <- read.csv("F:/DSM/Chital/cnv/distdata.csv")
preddata <- read.csv("F:/DSM/Chital/cnv/preddata2.csv")

head(segdata)
head(obsdata)
head(distdata)
head(preddata)

# save everything to file
save(segdata,obsdata,distdata,preddata,file="F:/DSM/Chital/chital.RData")
