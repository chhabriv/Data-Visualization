library(readr)

LEFT=2.11
RIGHT=2.22
TOP=41.45
BOTTOM=41.35
ZOOM=14
MAP_TYPE="toner"
PATH="~/code/DataVisualization/Assignments/Assignment4"
INFRA_PATH="Infraestructures_Inventari_Pas_Vianants.csv"
ACCIDENTS="2017_accidents_gu_bcn.csv"

setwd(PATH)
barcelona_coordinates <- c(left = LEFT,
            bottom = BOTTOM,
            right = RIGHT,
            top = TOP)

barcelona <- get_stamenmap(bbox = barcelona_coordinates,zoom=ZOOM,maptype=MAP_TYPE)
barcelona_map=ggmap(barcelona)

barcelona_infrastructure <- read_csv(INFRA_PATH)
barcelona_accidents <- read_csv(ACCIDENTS)


crossing_plot=barcelona_map+geom_point(data=barcelona_infrastructure, aes(x=barcelona_infrastructure$Longitud, 
                                                                      y=barcelona_infrastructure$Latitud),
                                          color='blue', size=0.1)+
  geom_point(data=barcelona_accidents, aes(x=barcelona_accidents$Longitud, 
                                                y=barcelona_accidents$Latitud),
             color='red', size=0.1)
crossing_plot
