library(readr)
library(ggmap)
library(geojsonio)
library(dplyr)
library(networkD3)
library(broom)
library(sp)

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
DISTRICT_PEDESTRIAN_COUNT="2017 - Pedestrian Accidents per District in Barcelona"
PREDESTRIAN_CAUSE_COUNT="2017 - Pedestrian Accidents Cause in Barcelona"
INCOME_UNEMPLOYMENT_DISTRICT="2017 - District wise Wealth Vs Unemployment Rate"
DAY_HOUR_COUNT_1="(1) 2017 - Hourly count of accidents per day of the week"
DAY_HOUR_COUNT_2="(2) 2017 - Hourly count of accidents per day of the week"
WEALTH_DISTRIBUTION_HEATMAP="2017 - Wealth Distribution heatmap per Neighborhood in Barcelona"

setwd(PATH)

barcelona_coordinates <- c(left = LEFT,
            bottom = BOTTOM,
            right = RIGHT,
            top = TOP)

barcelona = get_stamenmap(bbox = barcelona_coordinates,zoom=ZOOM,maptype=MAP_TYPE)
barcelona_map=ggmap(barcelona)

#read datasets
barcelona_infrastructure = read_csv(INFRA_PATH)

barcelona_accidents = read_csv(ACCIDENTS)
barcelona_pedestrian_accidents = barcelona_accidents[barcelona_accidents$DescriptionofAccident != "Not pedesterain",]

barcelona_wealth = read_csv(WEALTH)
barcelona_unemployment = read_csv(UNEMPLOYMENT)

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
       device="jpeg",path=PATH,width=12,height = 8)

#getting count of districts
barcelona_pedestrian_accidents['Name of the district'] =lapply(barcelona_pedestrian_accidents['Name of the district'],factor)
count_of_districts=as.data.frame(table(barcelona_pedestrian_accidents$`Name of the district`))
colnames(count_of_districts) <- c("District","Count of Accidents") 
ggplot(data=count_of_districts, aes(District,`Count of Accidents`)) +
  geom_bar(stat = "identity")+
  ggtitle(DISTRICT_PEDESTRIAN_COUNT)
ggsave(filename=paste(DISTRICT_PEDESTRIAN_COUNT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7)

#getting cause of accident
barcelona_pedestrian_accidents['DescriptionofAccident'] = lapply(barcelona_pedestrian_accidents['DescriptionofAccident'],factor)
count_of_cause=as.data.frame(table(barcelona_pedestrian_accidents$DescriptionofAccident))
colnames(count_of_cause) <- c("Cause of Accident","Count of Accidents") 
ggplot(data=count_of_cause, aes(`Cause of Accident`,`Count of Accidents`)) +
  geom_bar(stat = "identity")+
  ggtitle(PREDESTRIAN_CAUSE_COUNT)
ggsave(filename=paste(PREDESTRIAN_CAUSE_COUNT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7)

#Day-Hour accident count
barcelona_pedestrian_accidents['Day'] = lapply(barcelona_pedestrian_accidents['Day'],factor)
count_day_hour=rename(count(barcelona_pedestrian_accidents, 
                            barcelona_pedestrian_accidents$Day,
                            barcelona_pedestrian_accidents$Hour), 
                      Freq = n)
colnames(count_day_hour) <- c("Day","Hour","Count of Accidents")
count_day_hour['Hour']=lapply(count_day_hour['Hour'], factor)

ggplot(data=count_day_hour,aes(x=Day,y=Hour))+
  geom_point(aes(size = `Count of Accidents`))+
  scale_y_discrete(breaks = count_day_hour$Hour)+
  ggtitle(DAY_HOUR_COUNT_1)
ggsave(filename=paste(DAY_HOUR_COUNT_1,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7)

ggplot(data=count_day_hour,aes(x=Hour,y=`Count of Accidents`,col=Day))+
  geom_point(aes(size = `Count of Accidents`))+
  scale_y_continuous(breaks = count_day_hour$`Count of Accidents`)+
  scale_x_discrete(breaks = count_day_hour$Hour)+
  ggtitle(DAY_HOUR_COUNT_2)
ggsave(filename=paste(DAY_HOUR_COUNT_2,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7)

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
  ggtitle(INCOME_UNEMPLOYMENT_DISTRICT)
ggsave(filename=paste(INCOME_UNEMPLOYMENT_DISTRICT,".jpg",sep=""),plot=last_plot(),
       device="jpeg",path=PATH,width=12,height = 7)

#Sankey Diagram Day-> Accidents -> Hour
#Terrororial Wealth heatmap on plolygon coord
barcelona_geojson=geojson_read("https://cdn.rawgit.com/martgnz/bcn-geodata/master/barris/barris_geo.json", 
                               what="sp")
id_lookup=as.data.frame(barcelona_geojson@data)
id_lookup$id=0:(nrow(id_lookup)-1)
barcelona_polygon=fortify(barcelona_geojson)
plot(barcelona_geojson)
barcelona_neighborhood_polygon=merge(barcelona_polygon, 
                                     id_lookup, by.x = "id", by.y = "id")
barcelona_neighborhood_polygon=merge(barcelona_neighborhood_polygon,
                                     barcelona_wealth,
                                     by.x="name", by.y="Neighborhood Name")

barcelona_map+
  stat_density2d(data=barcelona_neighborhood_polygon, 
                 mapping=aes(x=long, y=lat, fill=`Index RFD Barcelona = 100`),
                 alpha=0.3, geom="polygon")


barcelona_polygon=tidy(barcelona_geojson,region="C_Barri")
barcelona_polygon$id=as.numeric(barcelona_polygon$id)
fortified=barcelona_polygon%>%
  left_join(.,barcelona_wealth, by=c("id"="Neighborhood Code"))

barcelona_map +
  geom_polygon(data = fortified, aes(fill = `Index RFD Barcelona = 100`,
                                     x = long, y = lat, group = group),alpha=0.8) +
  theme_void() +
  coord_map()+
  ggtitle(WEALTH_DISTRIBUTION_HEATMAP)

#Check for sankey diag of District->Deaths->Wealth
#Geo Heatmap of airquality and corresponding deaths in Nov 2017