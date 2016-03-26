source('wind-shifts-tacking-angles.r')

tackingAngle   <- 90
distanceToMark <- 100
halfTack       <- tackingAngle / 2

shifts = seq(-25, 25, by=2)# change by to change resolution of line

plot(
  shifts,
  rep(0, length(shifts)), # draw empty plot
  type="l",
  #ylim=c(-0.18,0.12),
  ylim=c(0.12, -0.18),
  #xlim=c(-20,20),
  
  main="Total Sailing Distance  given Wid Shift",
  xlab="Shift Size (degrees)\nNegative = Lift     Posative = Header",
  ylab="Percent difference in Sailing Distaince.   (negative = less distance)",
  sub="Solid lines = 20% up leg      Dashed lines = 90% of leg complete"
)


# add grid
abline(v=seq(-20,20,by=10), col="grey")
abline(h=seq(-0.2,0.12,by=0.01), col="#dddddd")
abline(h=seq(-0.2,0.12,by=0.05), col="#777777")# make darker at 5%s
abline(h=c(0), col="black")#zero black



markBearings <- c(
  tackingAngle * 0.1,# markBearing at 10% of tacking angle is 10% remaining of LONG LEG
  tackingAngle * 0.3,# 2* 0.0% of tacking angle away from middle, on LONG LEG
  tackingAngle * 0.5,# middle of course
  tackingAngle * 0.7,# 20% of tacking angle away from middle, on SHORT LEG
  tackingAngle * 0.9# markBearing at 90% of tacking angle is 90% up SHORT LEG
)

for (i in 1:length(markBearings)){
  mb = markBearings[i]
  
  distances <- sapply(## total sailing distances
    shifts, function(xshift) {
      distanceIncreaseGivenShift(
        distanceToMark,
        mb,
        tackingAngle,
        xshift
      )
    }
  )# end sapply
  
  # Get transparency value for our line
  # further from half tack is more transparent line
  #trans = c(0.3, 1,1,1, 0.3)[i]
  #trans = 1 - abs( ((mb - halfTack) / tackingAngle)) ** 0.5
  #trans = floor(trans * 10) / 10 # fix precision error
  trans = 1
  
  lineType = c(2, 1,1,1, 2)[i]
  # Get a line type
#   if (trans > 0.5){
#     lineType=1
#   } else {
#     lineType=2
#   }
  
  # figure out what color to make the line
  if (mb == halfTack){ # in middle
    red   = 0; blue  = 0; green = 1
  }else if (mb < halfTack){ # long leg
    red = 1; blue = 0; green = 0
  } else { # short leg
    red = 0; blue = 1; green = 0
  }
  
  
  print(mb)
  
  lines(shifts,
        distances,
        col=rgb(red, green, blue, trans),
        lty=lineType
        )
  
}


legend(-8, -0.18, # places a legend at the appropriate place,
       c("Long Leg", "Middle", "Short Leg"), # puts text in the legend
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),
       col=c("red","green", "blue")
) # gives the legend lines the correct color and width


