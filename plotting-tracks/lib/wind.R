library(ggmap)
library(geosphere)

## This only works with a flat aspect ratio.
## wind.directionLineFromLocation <- function(startX, startY, length, degrees) {
##     rads = degrees * pi / 180
##     endX = startX + sin(rads) * length 
##     endY = startY + cos(rads) * length
##     out = data.frame(x = c(startX, endX), y = c(startY, endY) )
##     return(out)
## }


## Get a diff for a 360 compass heading
wind.diffDirection <- function(data){
  d = diffDelta(data)
  d[ d < -180] = d[ d < -180] + 360 # fix when going 300 somethign over zero
  d[ d > 180] = d[ d > 180] - 360 # fix when going zero to 300 something
  return(d)
}


## Length in meteres
wind.directionLineFromLocation <- function(lon, lat, length, degrees) {
    ## X is longitude, which has an aspect ratio that shrinks the closer you get to the poles
    tmp = destPoint(c(lon, lat), degrees, length)
    
    out = data.frame(x = c(lon, tmp[1]), y = c(lat, tmp[2]) )
    return(out)
}


wind.smoothSpeed = function(data){
    levelOne = 7
    levelTwo = 2
    data = sma(sma(data, levelOne), levelTwo)
    return(data)
    ## manipulate(
    ##     plot(sma(sma(data, levelOne), levelTwo), type="l"),
    ##     levelOne = slider(0, 40,  step=1, initial=10),
    ##     levelTwo = slider(0, 40,  step=1, initial=10)
    ## )
}

# 
# wind.selectRaceWeather <- function(w) {
#     raceWindLogic = w$month > 3 & w$month < 11 & w$hod > 18 & w$hod < 22
#     
#     rhrs             = w$hod[raceWindLogic]# Get "race wind"
#     rdir             = w$direction[raceWindLogic]# Get race wind direction
#     rspeed           = w$speed[raceWindLogic]# Get race wind direction
#     rdirdif          = diffDirection(rdir)
#     newDay           = diffDelta(rhrs) < 0
#     rdirdif[newDay]  = rdir[newDay]
#     rdirdif[1]       = rdir[1] # one isn't marked as a new day, fix the default heading there
#     
#     dayDirs    = cumsumSplitReset(rdirdif, newDay, FALSE)
#     dayHrs     = splitAtTrue(rhrs, newDay)
#     daySpeed   = splitAtTrue(rspeed, newDay)
#     
#     ymin = 320
#     ymax = 360
#     r = sapply(dayDirs, firstWithinRange, ymin, ymax)##region we want to look at between 100 and 200
#     dayDirs = dayDirs[r]
#     dayHrs = dayHrs[r]
#     return(data.frame(hod=dayHrs))
# }
