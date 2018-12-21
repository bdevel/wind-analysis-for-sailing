library(splines) ## ns
source('load-j24-data.R')
source('../lifts-and-headers/wind-shifts-tacking-angles.r')

# Distance to mark
distance_to_mark = 1

global_match <- j24$twa > 105

plot(j24$awa[global_match],
     j24$time_to_mark[global_match],
     type="n",
     xlab="Apparent Wind Angle",
     main="J24 Time To Mark, 1nm, Downwind, Given Polars",
     ylab="Hrs. To Mark",
     ylim=c(0.1,0.6),
    # xlim=c(0, 90),
     cex=0.4)

abline(v=seq(45, 180, by=15), col="lightgray")# horizon
abline(h=seq(0, 1, by=0.025), col="lightgray")#verticla

# Vars we'll use to make the legend later
legend_colors = c() # place holder so we don't add dupe text
min_wind_angles = c()

for (i in 1:length(unique(j24$tws))) {
  tws   = unique(j24$tws)[i]
  trans = 1 - tws / max(j24$tws) 
  
  item_match = global_match & j24$tws == tws
  x_data_wind = j24$awa[item_match]
  y_data_ttm = j24$time_to_mark[item_match]
  
  lcolor = rgb(trans, trans, trans)
  legend_colors = c(legend_colors, lcolor)
  
  # Draw speed line
  lines(
    x_data_wind,
    y_data_ttm,
    col=lcolor,
    type="l"
  )
  
  # Put a dot for the minimum TTM per wind speed
  min_ttm = y_data_ttm == min(y_data_ttm)
  min_wind_angles = c(min_wind_angles, x_data_wind[min_ttm][1])
  
  points(
    x_data_wind[min_ttm],
    y_data_ttm[min_ttm]
  )
  
}

legend(
  #125, 0.6,
  "top",
  paste(unique(j24$tws), " kn   -  min TTM ", round(min_wind_angles), "°", sep=""),
  lty=c(1),# type of symbo, 1 = line
  box.lwd=0,# no border
  col=unique(legend_colors),# line color
  title.col="black",
  text.col=unique(legend_colors),# texts color
  title="Wind Speed",
  bg=rgb(1,1,1, 0.5)
)
