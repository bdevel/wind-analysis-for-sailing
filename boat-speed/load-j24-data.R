setwd("~/Code/wind-analysis-for-sailing/boat-speed")
j24 = read.csv('j24-polars-knots.csv',header=TRUE)


# tws, twa, boat_speed
j24$awa = appWindAngle(j24$tws, j24$twa, j24$boat_speed)


#   Make the total_distance
# ========================
# tacking angle is twice the wind angle. IE, 30 degree off wind, then 60 degree tacking angle
# If the tacking angle is over 180, then we are going down wind and don't need to go more than
# 180 degrees, we can just jibe and go the shorter way around the compass.
j24$ta = j24$twa * 2
j24$ta[j24$ta > 180] = 360 - j24$ta[j24$ta > 180]

# (dtm, mb, ta) # mark bearing is half tacking angle to put us in the middle
j24$total_distance = totalDistance(distance_to_mark, j24$ta/2, j24$ta)



# ========================
#   Make the time_to_mark
# ========================
# Time will be distance / speed.

j24$time_to_mark = j24$total_distance / j24$boat_speed

