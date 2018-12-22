
w <- read.csv(file="/Users/tyler/Code/wind/wsdot-520-all-merged.csv",head=TRUE,sep=",")
raceWindLogic = w$month > 3 & w$month < 11 & w$hod > 16 & w$hod < 22

rhrs             = w$hod[raceWindLogic] - c(0.28)# Get "race wind"
rdir             = ma(ma(w$direction[raceWindLogic],n=10), n=20)# Get race wind direction
rspeed           = w$speed[raceWindLogic]# Get race wind direction
rdirdif          = diffDirection(rdir)
newDay           = diffDelta(rhrs) < 0
rdirdif[newDay]  = rdir[newDay]
rdirdif[1]       = rdir[1] # one isn't marked as a new day, fix the default heading there

dayDirs    = cumsumSplitReset(rdirdif, newDay, FALSE)
dayHrs     = splitAtTrue(rhrs, newDay)
daySpeed   = splitAtTrue(rspeed, newDay)

ymin = 0
ymax = 600
r = sapply(dayDirs, firstWithinRange, ymin, ymax)##region we want to look at between 100 and 200
dayDirs = dayDirs[r]
dayHrs = dayHrs[r]

# draw line for each day. TODO: Fix cross over at 360
##plot(unlist(dayHrs), unlist(dayDirs), pch = 16, cex = 0.1)
plot(unlist(dayHrs), unlist(dayDirs),
     type="n",
     #pch=16, # use dots,
     #cex=unlist(daySpeed)/max(unlist(daySpeed)) * 3,
     col=rgb(0,0,0,0.1),
     ylim=c(ymin - ymin*0.6, ymax + ymax*0.6),
     axes=FALSE,
     xlab="Hour of Day",
     ylab="Direction",
     ##main="Daily wind shifts, Nov 2007 - Jul 2015"
     main="Apr-Oct, Daily Wind Shifts 320°-360° 4pm-10pm, April 2007 - Jul 2015"
     )

xa = seq(16,22,by=0.5)
ya = seq(ymin - ymin*0.6, ymax + ymax*0.6,by=50)
axis(side=1, at=xa)# time
axis(side=2, at=ya)# direction
abline(h=ya, v=rep(0, length(ya)), col=rgb(.4,.4,.8,0.8), lty=3)

## Create a list of 22 colors to use for the lines.
cl <- rainbow(length(dayHrs))
for(i in 1:length(dayHrs)) {
    lines(dayHrs[[i]], dayDirs[[i]], col=rgb(0,0,0,0.05))
}
