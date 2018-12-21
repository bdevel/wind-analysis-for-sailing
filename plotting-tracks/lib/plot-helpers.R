
## nautical miles
earth.dist <- function (long1, lat1, long2, lat2) {
  rad <- pi/180
  a1 <- lat1 * rad
  a2 <- long1 * rad
  b1 <- lat2 * rad
  b2 <- long2 * rad
  dlon <- b2 - a2
  dlat <- b1 - a1
  a <- (sin(dlat/2))^2 + cos(a1) * cos(b1) * (sin(dlon/2))^2
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  R <- 6378.145
  d <- R * c
  d = d * 0.539957 # to nautical miles
  return(d)
}

## aspect ratio isn't 1x1 since earth is round - the longitude per degree changes. In Seattle it's 40nm instad of 60nm
locationAspectRatio <- function(data){
  ## http://www.nhc.noaa.gov/gccalc.shtml
  ## http://www.r-bloggers.com/r-functions-for-earth-geographic-coordinate-calculations/
  lonDist = earth.dist(median(data$lon, na.rm=TRUE), median(data$lat, na.rm=TRUE), median(data$lon, na.rm=TRUE) + 1, median(data$lat, na.rm=TRUE) )
  latDist = earth.dist(median(data$lon, na.rm=TRUE), median(data$lat, na.rm=TRUE), median(data$lon, na.rm=TRUE), median(data$lat, na.rm=TRUE) + 1)
  return(latDist / lonDist)
}





loadRaceDataFiles <- function(sensorFile, windFile){
  ## selector = head(is.na(t$lat) == FALSE & is.na(t$lon) == FALSE) # filter out na lat/lon records
  tracks <- read.csv(file=sensorFile, head=TRUE, sep=";")
  wind <- read.csv(file=windFile, head=TRUE, sep=",")
  
  ## Setup the wind
  ##wind$hod = wind$hod - c(12) # Make 12 hour
  wind$speed = wind$speed * c(0.86) # MPH to knots
  wind$speed = sma(sma(wind$speed,10), 2) # smooth speed
  wind$dirfixed = sma(sma(wind$dirfixed, 10), 2) # Smooth the direction
  
  ## parse the time - set HOD
  h = as.POSIXlt(tracks$datetime)$hour
  m = as.POSIXlt(tracks$datetime)$min / 60.0
  s = as.POSIXlt(tracks$datetime)$sec / 60.0 / 60
  ## TODO: add miliseconds
  tracks$hod = h + m + s
  
  windSpeeds = c()
  windDirs   = c()
  airTemps   = c()
  for(i in 1:length(tracks$hod)) {
    hod = tracks$hod[i]
    ## Note, if you have data for 5:00 and 10:00, if you ask for 6PM it'll give
    ## you 10PM data sinces it's greater than. Would be nice get the actuall
    ## nearest or smooth between the two.
    windDir = wind$direction[wind$hod >= hod][1]
    windSpeed = wind$speed[wind$hod >= hod][1]
    airTemp = wind$temp[wind$hod >= hod][1]
    windDirs   = c(windDirs, windDir)
    windSpeeds = c(windSpeeds, windSpeed)
    airTemps = c(airTemps, airTemp)
  }
  
  tracks$windSpeed     = windSpeeds
  tracks$windDirection = windDirs
  tracks$airTemps = airTemps
  
  return(tracks)
}



addTrackLabels <- function(data){
  raceMinVelocity  = min(data$windSpeed)
  raceMaxVelocity  = max(data$windSpeed)
  
  # Adds wind arrows
  for(i in seq(1, length(data$hod), by=(60))   ) {
    hod = data$hod[i]
    lon = data$lon[i]
    lat = data$lat[i]
    windDir = data$windDirection[i]
    windSpeed = data$windSpeed[i]
    
    ## Figure out which color to use for wind speed.
    velColorCount = 100
    velColors <- colorRampPalette(c('mintcream','midnightblue'))##'lightblue1','dodgerblue3'))  
    velocityColorValue = linMap(c(windSpeed, raceMaxVelocity, raceMinVelocity), 1, velColorCount)[1]
    col = velColors(100)[velocityColorValue]
    
    ## Draw ladder rungs.
    ## Draw half to right of wind
    
    ## Draw the wind direction line plus color by velocity
    offset = 0##.00007
    line_length = 40
    lineData = wind.directionLineFromLocation(lon - offset, lat + offset, line_length, windDir)
    lines(lineData$x, lineData$y, col=col, lwd=2)
    
    # ladder rungs
    if (FALSE) {        
      rungLength = 100
      rungColor  = rgb(0,0,0, 0.2)
      lineData = wind.directionLineFromLocation(lon, lat, rungLength, windDir + 90)
      lines(lineData$x, lineData$y, col=rungColor, lwd=1)
      ## Draw half to left of wind
      lineData = wind.directionLineFromLocation(lon, lat, rungLength, windDir - 90)
      lines(lineData$x, lineData$y, col=rungColor, lwd=1)
    }
    
    h = floor(hod)
    m = floor((hod - h) * 60)
    h = h - 12
    time = paste(c(h, ":", m), collapse = "")
    boatSpeed = round(data$speed_kmh[i] * 0.539957, 2) # knots
    
    #label = paste(c(time, " (",round(windDir),"/",round(windSpeed,1),"k)"), collapse = "")
    label = paste(c(time #, "\n",
                    #boatSpeed, "kn\n",
                    #round(windSpeed,1), "kn"
                    ),
                  collapse = "")
    xOffset = -0.001
    yOffset = 0.0004
    text(lon + xOffset, lat + yOffset, labels=label, cex=0.6, col=rgb(0,0,0,0.5))
  }
}


createTracksPlot <- function(mainTitle, data){
  
  
  rbPal <- colorRampPalette(c('blue','red'))
  colorCount = 100
  speedColors = as.numeric(
    ##cut(linMap(t$speed_kmh[!is.na(t$speed_kmh)], 1, colorCount),
    cut(linMap(data$speed_kmh, 1, colorCount),
        seq(1,colorCount)
    ))
  myc = rbPal(colorCount)[speedColors]
  
  plot(data$lon,
       data$lat,
       asp = locationAspectRatio(data),
       col=myc, pch=16,  cex=0.4,
       xlab="Longitude",
       ylab="Latitude",
       main=mainTitle
  )
  addTrackLabels(data)
}



