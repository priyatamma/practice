###############################
########                #######
########   Load DSM     #######
########                #######
###############################

library(dsm)


# plotting options
gg.opts <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
    panel.background = element_blank())

# make the results reproducable
set.seed(11123)

survey.area <- read.csv("/DSM/4. Data/surveyarea.csv")

load("G:/DSM/4. Data/2014Oricoast_F.RData")


p <- qplot(data = survey.area, x = longitude, y = latitude, geom = "polygon", 
    fill = I("lightblue"), ylab = "Latitude", xlab = "Longitude", alpha = I(0.7))
p <- p + coord_equal()
p <- p + gg.opts

p <- p + geom_line(aes(longitude, latitude, group = Transect.Label), data = segdata)

print(p)

# save graphics options
o <- par("mfrow")
par(mfrow = c(2, 2))

# histograms
hist(distdata$distance, main = "", xlab = "Distance (m)")
hist(distdata$size, main = "", xlab = "Group size")

# plots of distance vs. size
plot(distdata$distance, distdata$size, main = "", xlab = "Distance (m)", ylab = "Group size", 
    pch = 19, cex = 0.5, col = rgb(0.74, 0.74, 0.74, 0.7))

# lm fit
l.dat <- data.frame(distance = seq(0, 8000, len = 1000))
lo <- lm(size ~ distance, data = distdata)
lines(l.dat$distance, as.vector(predict(lo, l.dat)))

plot(distdata$distance, distdata$beaufort, main = "", xlab = "Distance (m)", 
    ylab = "Beaufort sea state", pch = 19, cex = 0.5, col = rgb(0.74, 0.74, 
        0.74, 0.7))

# restore graphics options
par(o)

## NULL

p <- qplot(data = survey.area, x = x, y = y, geom = "polygon", ylab = "y", xlab = "x", 
    alpha = I(0.7), fill = I("lightblue"))
p <- p + gg.opts
p <- p + coord_equal()
p <- p + labs(size = "Group size")
p <- p + geom_line(aes(x, y, group = Transect.Label), data = segdata)
p <- p + geom_point(aes(x, y, size = size), data = distdata, colour = "red", 
    alpha = I(0.7))
print(p)

p <- ggplot(preddata)
p <- p + gg.opts
p <- p + coord_equal()
p <- p + labs(fill = "Depth", x = "x", y = "y")
p <- p + geom_tile(aes(x = x, y = y, fill = depth, width = width, height = height))
print(p)

p <- ggplot(preddata)
p <- p + gg.opts
p <- p + coord_equal()
p <- p + labs(fill = "Depth", x = "x", y = "y", size = "Group size")
p <- p + geom_tile(aes(x = x, y = y, fill = depth, width = width, height = height))
p <- p + geom_line(aes(x, y, group = Transect.Label), data = segdata)
p <- p + geom_point(aes(x, y, size = size), data = distdata, colour = "red", 
    alpha = I(0.7))
print(p)

library(Distance)


hr.model <- ds(distdata, max(distdata$distance), key = "hr", adjustment = NULL)


## Fitting hazard-rate key function
## AIC= 841.253
## No survey area information supplied, only estimating detection function.
summary(hr.model)


plot(hr.model)

