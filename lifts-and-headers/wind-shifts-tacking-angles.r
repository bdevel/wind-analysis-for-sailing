

# degrees sin
dsin <- function(deg)  {
 r = deg * pi / 180
 s = sin(r)
 return(s)
}

d2r <- function(d){
  return(d * pi / 180)
}

# Reciprocal of tacking angle.
rta <- function(ta) {
  return(180 - ta)
}

# First tack
firstLeg <- function (dtm, mb, ta){
  # Find the third angle of our triangle
  q <- 180 - mb - rta(ta)
  # A / sin(a) == B / sin(b) to solve
  out = (dtm * dsin(q) ) / dsin(rta(ta))
  return(out)
}

# Second tack
secondLeg <- function (dtm, mb, ta){
  # A / sin(a) == B / sin(b) to solve
  out = (dtm * dsin(mb) ) / dsin(rta(ta))
  return(out)
}

totalDistance <- function(dtm, mb, ta) {
  t1 = firstLeg(dtm, mb, ta)
  t2 = secondLeg(dtm, mb, ta)
  return(t1 + t2)
}

distanceIncreaseGivenShift <- function(dtm, mb, ta, shift){
  
  # If the bearing increases, that means a heard.
  # If it decreased, that means a lift.
  bearingAfterShift = mb + shift
  before = totalDistance(dtm, mb, ta) / dtm
  after  = totalDistance(dtm, bearingAfterShift, ta) / dtm
  
  distanceDiff = (after - before)
  gainedRatioToBefore = distanceDiff / before
  
  return(gainedRatioToBefore )
}




