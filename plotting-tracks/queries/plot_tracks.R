# NOTE set working directory to plotting-tracks

source('lib/general.R')
source('lib/wind.R')
source('lib/plot-helpers.R')

# install.packages("manipulate")
library(manipulate)

t = loadRaceDataFiles(
  "data/Sensor_record_20150728_211517_AndroSensor.csv",
  "data/tuesday-july-28-2015.csv")


## 2015-08-25-tracks-race1.png
mainTitle = "2015-08-25 J24 Race"

manipulate(
  createTracksPlot(mainTitle, t[(t$hod > startAt & t$hod < endAt), ]),
  startAt = slider(16.0, 22.0, initial=18.4,step=(1.0/60)),
  endAt = slider(16.0, 22.0, initial=19.45,step=(1.0/60))
)
