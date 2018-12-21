

# degrees sin
dsin <- function(deg)  {
 r = deg * pi / 180
 sin(r)
}

dcos <- function(deg)  {
  r = deg * pi / 180
  cos(r)
}

d2r <- function(d){
  return(d * pi / 180)
}

# radian to degrees
r2d <- function(rad) {(rad * 180) / (pi)}


appWindVel <- function (tws, twa, boat_speed) {
  # works for 0-180 degree. need other trig function for > 180. or do 360 - twa?
  # https://en.wikipedia.org/wiki/Apparent_wind#Calculating_apparent_velocity_and_angle
  sqrt(
    tws ^ 2        +
      boat_speed ^ 2 +
      2 * tws * boat_speed * dcos(twa)
  )
}

appWindAngle <- function(tws, twa, boat_speed){
  awv = appWindVel(tws, twa, boat_speed)
  w = (tws * dcos(twa) + boat_speed) / awv
  w = round(w, 3)# fixes NaN for the acos
  r2d(acos(w))
}

# Reciprocal of tacking angle.
rta <- function(ta) { 180 - ta }

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
  total = t1 + t2
  #return(total)
  # have the dtm be the minimum returned.
  # Otherwize, If ta and mb are zero, this funciton returns zero
  # because the triangle has no sides. Kinda odd..
  total[total < dtm] = dtm
  #if (out == Inf) {
  #  out = NA
  #}
  return(total)
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




