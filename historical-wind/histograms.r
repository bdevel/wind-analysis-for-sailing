

raceWindSelector = aw$hod > 18 & aw$hod < 22 & aw$month > 3 & aw$month < 11 & aw$speed < 30
hist(aw$speed[raceWindSelector], breaks=73)

