source('wind-shifts-tacking-angles.r')

tackingAngle   <- 90
markBearing    <- 25  # zero means you're on the line, 90 means you're at the corner
distanceToMark <- 100

tas  = rep(tackingAngle, 100)
dtms = rep(distanceToMark, 100)
mbs  = seq(0, 100, by=5) # change by here to chnage resolution of the line

tds80  = sapply(## total distances
  mbs,
  function(xmb) totalDistance(distanceToMark, xmb, 80)
) / distanceToMark

tds90  = sapply(## total distances
  mbs,
  function(xmb) totalDistance(distanceToMark, xmb, 90)
) / distanceToMark

tds100  = sapply(## total distances
  mbs,
  function(xmb) totalDistance(distanceToMark, xmb, 100)
)  / distanceToMark

# This the distance you have to travel
# for each bearing of the mark between
# zero, you being on the layline, to 
# 90, meaning you're at the corner
plot(
  mbs,
  tds100,
  xlab="Mark Bearing",
  ylab="Sailing Distance Multiplier for Distance to Mark",
  type="l",
  main="Sailing Distance given Tacking Angle & Mark Bearing",
  # turn off axis
  xaxt="n",
  yaxt="n"
)


xax = seq(0, tackingAngle, by = 15)
yax = seq(0, 10, by = 0.1)
axis(1, at = xax, las=2)
axis(2, at = yax, las=2)
abline(v=xax, col="grey")
abline(h=yax, col="#DCDCDC")

lines(mbs, tds80, col="blue")
lines(mbs, tds90, col="green")
lines(mbs, tds100, col="red")

legend(0,1.55, # places a legend at the appropriate place,
       c("100°", "90°", "80°"), # puts text in the legend
       title="Tacking Angle",
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),
       col=c("red","green", "blue")
) # gives the legend lines the correct color and width


