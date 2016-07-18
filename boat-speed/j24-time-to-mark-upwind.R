
library(splines) ## ns
setwd("~/Code/wind-analysis-for-sailing/boat-speed")
source('load-j24-data.R')
source('../lifts-and-headers/wind-shifts-tacking-angles.r', echo=TRUE)

# Distance to mark
distance_to_mark = 1


# pick a wind speed and zoom in on ttm < 50
global_match <- j24$twa < 60 #j24$time_to_mark < 100000

plot(j24$twa[global_match],
     j24$time_to_mark[global_match],
     type="n",
     xlab="True Wind Angle",
     main="J24 Time To Mark, 1nm, Given Polars, Upwind",
     ylab="Hrs. Time To Mark",
     ylim=c(0.2,0.5),
    # xlim=c(0, 90),
     cex=0.4)

abline(v=seq(45, 180, by=15), col="lightgray")# horizon
abline(h=seq(0, 1, by=0.025), col="lightgray")#verticla

# Vars we'll use to make the legend later
legend_colors = c() # place holder so we don't add dupe text
min_twas = c()

for (i in 1:length(unique(j24$tws))) {
  print(i)
  tws   = unique(j24$tws)[i]
  trans = 1 - tws / max(j24$tws) 
  
  #print(tws)
  #print(rgb(0, 0, 0.4, trans))
  item_match = global_match & j24$tws == tws
  x_data_twa = j24$twa[item_match]
  y_data_ttm = j24$time_to_mark[item_match]
  z_data_bs  = j24$boat_speed[item_match]
  
  lcolor = rgb(trans,trans,trans)
  legend_colors = c(legend_colors, lcolor)
  
  # Draw speed line
  lines(
    x_data_twa,
    y_data_ttm,
    col=lcolor,
    type="l" #,
    #cex=0.4,
    #lwd=0.1
  )
  
  # Put a dot for the minimum TTM per wind speed
  min_ttm = y_data_ttm == min(y_data_ttm)
  min_bs = z_data_bs == max(z_data_bs)
  min_twas = c(min_twas, x_data_twa[min_ttm][1])
  
  points(
    x_data_twa[min_ttm],
    y_data_ttm[min_ttm]
  )
  
}

legend(
  #125, 0.6,
  "top",
  paste(unique(j24$tws), " kn   -  min TTM ", min_twas, "°", sep=""),
  lty=c(1),# type of symbo, 1 = line
  box.lwd=0,# no border
  col=unique(legend_colors),# line color
  title.col="black",
  text.col=unique(legend_colors),# texts color
  title="Wind Speed",
  bg=rgb(1,1,1, 0.5)
)
