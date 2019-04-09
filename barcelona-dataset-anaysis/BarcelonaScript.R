library(readr)
library(ggmap)
library(geojsonio)
library(dplyr)
library(broom)
library(sp)
library(viridis)
library(reshape2)

LEFT=2.11
RIGHT=2.22
TOP=41.45
BOTTOM=41.35
ZOOM=15
MAP_TYPE="toner"
#PATH="~/code/DataVisualization/Assignments/Assignment4"
PATH="H:/TCD/Semester 2/DataVisualization/Assignment4/Data-Visualization/barcelona-dataset-anaysis"
INFRA_PATH="barcelona-pedestrian-crossing-2017.csv"
ACCIDENTS="barcelona-accidents-2017.csv"
WEALTH="barcelona-terretorial-income-2017.csv"
UNEMPLOYMENT="barcelona-unemployment-2017.csv"
ACCIDENT_VS_PEDESTRIAN_TITLE="2017 - Pedestrian Accidents vs Pedestrian Crossings in Barcelona"
DISTRICT_PEDESTRIAN_COUNT="2017 - Number of Pedestrian Accidents and Crossings per District in Barcelona"
PREDESTRIAN_CAUSE_COUNT="2017 - Pedestrian Accidents Cause in Barcelona"
INCOME_UNEMPLOYMENT_DISTRICT="2017 - District wise Wealth Vs Unemployment Rate"
DAY_HOUR_COUNT="2017 - Hourly count of accidents per day of the week"
WEALTH_DISTRIBUTION_HEATMAP="2017 - Wealth Distribution in Barcelona - Neighborhood Heatmap"
WEALTH_DISTRIBUTION_ACCIDENT_HEATMAP="2017 - Territorial Income Vs Number of Pedestrian Accidents"
setwd(PATH)

barcelona_coordinates <- c(left = LEFT,
            bottom = BOTTOM,
            right = RIGHT,
            top = TOP)

barcelona = get_stamenmap(bbox = barcelona_coordinates,zoom=ZOOM,maptype=MAP_TYPE)
barcelona_map=ggmap(barcelona)

#read datasets
barcelona_infrastructure = read_csv(INFRA_PATH)
barcelona_infrastructure=na.omit(barcelona_infrastructure)
barcelona_accidents = read_csv(ACCIDENTS)
barcelona_pedestrian_accidents = barcelona_accidents[barcelona_accidents$DescriptionofAccident != "Not pedesterain",]

barcelona_wealth = read_csv(WEALTH)
barcelona_unemployment = read_csv(UNEMPLOYMENT)

crossing_plot=barcelona_map+
              geom_point(data=barcelona_infrastructure, 
                         aes(x=barcelona_infrastructure$Longitud, 
                             y=barcelona_infrastructure$Latitud,
                             color="crossing_color"),
                         size=1,alpha=0.3)+
              geom_point(data=barcelona_pedestrian_accidents, 
                         aes(x=barcelona_pedestrian_accidents$Longitude, 
                             y=barcelona_pedestrian_accidents$Latitude,
                             color="accident_color"),
                         size=1)+
              ggtitle(ACCIDENT_VS_PEDESTRIAN_TITLE)+
              scale_color_manual("Representation", 
                     values = c(crossing_color="blue", accident_color="red"), 
                     labels=c("Pedestrian Accidents","Pedestrian Crossings"))+
  xlab(NULL)+
  ylab(NULL)+
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
ggsave(filename=paste(ACCIDENT_VS_PEDESTRIAN_TITLE,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 8,dpi=300)

#getting count of districts
barcelona_pedestrian_accidents['Name of the district'] =lapply(barcelona_pedestrian_accidents['Name of the district'],factor)
count_of_districts=as.data.frame(table(barcelona_pedestrian_accidents$`Name of the district`))
count_of_districts_crossings=as.data.frame(table(barcelona_infrastructure$Nom_Districte))

colnames(count_of_districts) <- c("District","Count of Accidents") 
colnames(count_of_districts_crossings) <- c("District","Count of Crossings") 
accidents_crossings=merge(count_of_districts, count_of_districts_crossings,
                          by="District")
accidents_crossings_melt <- melt(accidents_crossings,id.vars = 1)
ggplot(accidents_crossings_melt,aes(x = District,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge")+
  facet_wrap(~variable,scales = "free")+
  scale_fill_manual(values = alpha(c("red", "blue"),c(1,0.8)))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        plot.title = element_text(hjust = 0.5))+
  ggtitle(DISTRICT_PEDESTRIAN_COUNT)
  
# ggplot(data=count_of_districts, aes(District,`Count of Accidents`)) +
#   geom_bar(stat = "identity")+
#   ggtitle(DISTRICT_PEDESTRIAN_COUNT)
ggsave(filename=paste(DISTRICT_PEDESTRIAN_COUNT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi=300)

#getting cause of accident
barcelona_pedestrian_accidents['DescriptionofAccident'] = lapply(barcelona_pedestrian_accidents['DescriptionofAccident'],factor)
count_of_cause=as.data.frame(table(barcelona_pedestrian_accidents$DescriptionofAccident))
colnames(count_of_cause) <- c("Cause of Accident","Count of Accidents") 

ggplot(data=count_of_cause, 
       aes(reorder(`Cause of Accident`,`Count of Accidents`),
           `Count of Accidents`)) +
  geom_bar(stat = "identity",width=0.5, fill="#619CFF")+
  xlab("Cause of Accidents")+
  ylab("Count of Accidents")+
  theme(plot.title = element_text(hjust = 0.5))+
    ggtitle(PREDESTRIAN_CAUSE_COUNT)
ggsave(filename=paste(PREDESTRIAN_CAUSE_COUNT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi=300)

#Day-Hour accident count
barcelona_pedestrian_accidents['Day'] = lapply(barcelona_pedestrian_accidents['Day'],factor)
count_day_hour=rename(count(barcelona_pedestrian_accidents, 
                            barcelona_pedestrian_accidents$Day,
                            barcelona_pedestrian_accidents$Hour), 
                      Freq = n)
colnames(count_day_hour) <- c("Day","Hour","Count of Accidents")
count_day_hour['Hour']=lapply(count_day_hour['Hour'], factor)

ggplot(data=count_day_hour,aes(x=reorder(Day),y=Hour))+
  geom_point(aes(size = `Count of Accidents`))+
  scale_y_discrete(breaks = count_day_hour$Hour)+
  theme(plot.title = element_text(hjust = 0.5))+
  ggtitle(DAY_HOUR_COUNT)
ggsave(filename=paste(DAY_HOUR_COUNT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi=300)

#Wealth per district
barcelona_wealth['District Name'] = lapply(barcelona_wealth['District Name'],factor)
mean_district_wealth = barcelona_wealth%>% 
          group_by("District Name"=`District Name`) %>% 
          summarise("Population"=sum(Population),"Mean Wealth"=mean(`Index RFD Barcelona = 100`))

#Wealth vs Unemployment per district
cols=c(2,4:8)
barcelona_unemployment[cols] = lapply(barcelona_unemployment[cols], factor)

mean_district_unemployment = barcelona_unemployment%>% 
                             filter(`Employment Demand`=="Registered Unemployed")%>%
                             group_by("District Name"=`District Name`) %>% 
                             summarise("District Unemployment"=sum(Number))

district_wealth_unemployment <- merge(mean_district_wealth, mean_district_unemployment, by.x = "District Name", by.y = "District Name")
district_wealth_unemployment["Unemployment Rate"]=round(district_wealth_unemployment["District Unemployment"]/district_wealth_unemployment["Population"]*100,2)

ggplot(data=district_wealth_unemployment,aes(x=`District Name`,y=`Mean Wealth`,col = ifelse(`Mean Wealth` < 100,"below_average","above_average")))+
  geom_point(aes(size = `Unemployment Rate`))+
  scale_color_manual('Income Per Captia Index Comparison to Average', 
                   values = c(below_average="red", above_average="green"), 
                   labels=c("Above Average","Below Average"))+
  ylab("Income Per Captia Index with Average=100")+
  geom_hline(yintercept = 100, colour="black", linetype="dashed")+
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle(INCOME_UNEMPLOYMENT_DISTRICT)
ggsave(filename=paste(INCOME_UNEMPLOYMENT_DISTRICT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi = 300)

#Terrororial Wealth heatmap on plolygon coord
barcelona_geojson=geojson_read("https://cdn.rawgit.com/martgnz/bcn-geodata/master/barris/barris_geo.json", 
                               what="sp")
id_lookup=as.data.frame(barcelona_geojson@data)
id_lookup$id=0:(nrow(id_lookup)-1)
barcelona_polygon=fortify(barcelona_geojson)
#plot(barcelona_geojson)
barcelona_neighborhood_polygon=merge(barcelona_polygon, 
                                     id_lookup, by.x = "id", by.y = "id")
barcelona_neighborhood_polygon=merge(barcelona_neighborhood_polygon,
                                     barcelona_wealth,
                                     by.x="name", by.y="Neighborhood Name")

barcelona_polygon=tidy(barcelona_geojson,region="C_Barri")
barcelona_polygon$id=as.numeric(barcelona_polygon$id)
fortified=barcelona_polygon%>%
  left_join(.,barcelona_wealth, by=c("id"="Neighborhood Code"))

ggplot()+
  geom_polygon(data = fortified, aes(fill = `Index RFD Barcelona = 100`,
                                     x = long, y = lat, group = group),alpha=0.8) +
  theme_void() +
  scale_fill_viridis(trans = "log", breaks=c(50,75,100,125,150,175,200,225), 
                     name="Income Per Captia Index", 
                     guide = guide_legend( keyheight = unit(3, units = "mm"), 
                                           keywidth=unit(12, units = "mm"), 
                                           label.position = "bottom", 
                                           title.position = 'top', nrow=1) ) +
  theme(
    text = element_text(color = "#22211d"), 
    plot.background = element_rect(fill = "#f5f5f2", color = NA), 
    panel.background = element_rect(fill = "#f5f5f2", color = NA), 
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    
    legend.position = "bottom"
  ) +
  coord_map()+
  ggtitle(WEALTH_DISTRIBUTION_HEATMAP)

ggsave(filename=paste(WEALTH_DISTRIBUTION_HEATMAP,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi = 300)

barcelona_map +
  geom_polygon(data = fortified, aes(fill = `Index RFD Barcelona = 100`,
                                     x = long, y = lat, group = group),alpha=0.8) +
  geom_point(data=barcelona_pedestrian_accidents, 
             aes(x=barcelona_pedestrian_accidents$Longitude, 
                 y=barcelona_pedestrian_accidents$Latitude),color="red",
             size=1)+
  theme_void() +
  scale_fill_viridis(trans = "log", breaks=c(50,75,100,125,150,175,200,225), 
                     name="Income Per Captia Index", 
                     guide = guide_legend( keyheight = unit(3, units = "mm"), 
                                           keywidth=unit(12, units = "mm"), 
                                           label.position = "bottom", 
                                           title.position = 'top', nrow=1) ) +
  theme(
    text = element_text(color = "#22211d"), 
    plot.title = element_text(hjust = 0.5),
    #plot.background = element_rect(fill = "#f5f5f2", color = NA), 
    panel.background = element_rect(fill = "#f5f5f2", color = NA), 
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    
    legend.position = "bottom"
  ) +
  coord_map()+
  ggtitle(WEALTH_DISTRIBUTION_ACCIDENT_HEATMAP)
ggsave(filename=paste(WEALTH_DISTRIBUTION_ACCIDENT_HEATMAP,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7,dpi = 300)
