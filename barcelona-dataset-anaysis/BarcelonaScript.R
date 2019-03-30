library(readr)
library(ggmap)

LEFT=2.11
RIGHT=2.22
TOP=41.45
BOTTOM=41.35
ZOOM=15
MAP_TYPE="toner"
PATH="~/code/DataVisualization/Assignments/Assignment4"
INFRA_PATH="Infraestructures_Inventari_Pas_Vianants.csv"
ACCIDENTS="2017_accidents_gu_bcn.csv"
ACCIDENT_VS_PEDESTRIAN_TITLE="2017 - Pedestrian Accidents vs Pedestrian Crossings in Barcelona"
DISTRICT_PEDESTRIAN_COUNT="2017 - Pedestrian Accidents per District in Barcelona"
PREDESTRIAN_CAUSE_COUNT="2017 - Pedestrian Accidents Cause in Barcelona"

setwd(PATH)
barcelona_coordinates <- c(left = LEFT,
            bottom = BOTTOM,
            right = RIGHT,
            top = TOP)

barcelona <- get_stamenmap(bbox = barcelona_coordinates,zoom=ZOOM,maptype=MAP_TYPE)
barcelona_map=ggmap(barcelona)

barcelona_infrastructure <- read_csv(INFRA_PATH)
barcelona_accidents <- read_csv(ACCIDENTS)
barcelona_pedestrian_accidents <- barcelona_accidents[barcelona_accidents$DescriptionofAccident != "Not pedesterain",]

crossing_plot=barcelona_map+
              geom_point(data=barcelona_infrastructure, 
                         aes(x=barcelona_infrastructure$Longitud, y=barcelona_infrastructure$Latitud,color="crossing_color"),
                         size=0.5)+
              geom_point(data=barcelona_pedestrian_accidents, 
                         aes(x=barcelona_pedestrian_accidents$Longitude, y=barcelona_pedestrian_accidents$Latitude,color="accident_color"),
                         size=0.5)+
              ggtitle(ACCIDENT_VS_PEDESTRIAN_TITLE)+
              scale_color_manual("Representation", 
                     values = c(crossing_color="blue", accident_color="red"), 
                     labels=c("Pedestrian Deaths","Pedestrian Crossings"))+
  theme(plot.title = element_text(face="bold",hjust = 0.5),
        legend.position="right", 
        legend.box="horizontal",
        legend.title = element_text(face="bold"), 
        legend.box.background = element_rect(color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())
crossing_plot

#getting count of districts
barcelona_pedestrian_accidents[, barcelona_pedestrian_accidents$`Name of the district`] <- as.factor(barcelona_pedestrian_accidents$`Name of the district`)
count_of_districts=as.data.frame(table(barcelona_pedestrian_accidents$`Name of the district`))
colnames(count_of_districts) <- c("District","Count of Accidents") 
ggplot(data=count_of_districts, aes(District,`Count of Accidents`)) +
  geom_bar(stat = "identity")+
  ggtitle(DISTRICT_PEDESTRIAN_COUNT)

#getting cause of accident
barcelona_pedestrian_accidents[, barcelona_pedestrian_accidents$DescriptionofAccident] <- as.factor(barcelona_pedestrian_accidents$DescriptionofAccident)
count_of_cause=as.data.frame(table(barcelona_pedestrian_accidents$DescriptionofAccident))
colnames(count_of_cause) <- c("Cause of Accident","Count of Accidents") 
ggplot(data=count_of_cause, aes(`Cause of Accident`,`Count of Accidents`)) +
  geom_bar(stat = "identity")+
  ggtitle(PREDESTRIAN_CAUSE_COUNT)

#Day-Hour accident count
barcelona_pedestrian_accidents[, barcelona_pedestrian_accidents$Day] <- as.factor(barcelona_pedestrian_accidents$Day)
count_day_hour=as.data.frame(table(barcelona_pedestrian_accidents$Day, barcelona_pedestrian_accidents$Hour))
colnames(count_of_cause) <- c("Day","Hour","Count of Accidents") 
