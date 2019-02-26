library(ggplot2)
library(scales)
library(gridExtra)
#install.packages("ggrepel")
library(readxl)
library(ggmap)
library(ggrepel)
setwd("H:/TCD/Semester 2/DataVisualization/Assignment2")
minard_data <- read_excel("minard-data.xlsx")
#View(minard_data)

cities=minard_data[1:3]
temp=minard_data[4:8]
troops=minard_data[9:13]
cities=na.omit(cities)
troops=na.omit(troops)

#' ## plot path of troops, and another layer for city names
plot_troops <- ggplot(troops, aes(troops$LONP, troops$LATP)) +
  geom_path(aes(size = troops$SURV, colour = troops$DIR, group = troops$DIV),
            lineend = "round", linejoin = "round")+
  #geom_point(data = troops, aes(x = troops$LONP, y = troops$LATP),
  #           color = "black")+
  #geom_text_repel(data = troops, aes(x = troops$LONP, y = troops$LATP, 
  #                                  label = troops$SURV),
  #                color = "black")
  geom_point(data = cities, aes(x = cities$LONC, y = cities$LATC),
             color = "black")+
  geom_text_repel(data = cities, aes(x = cities$LONC, y = cities$LATC, 
                                     label = cities$CITY),
                  color = "black") #, family = "Open Sans Condensed Bold"
                  
#plot_cities <- geom_text(aes(label = cities$CITY), size = 4, data = cities)

#' ## Combine these, and add scale information, labels, etc.
#' Set the x-axis limits for longitude explicitly, to coincide with those for temperature

breaks <- c(0.04,0.5,1,2,2.5,3,3.4) * 10^5 
plot_minard <- plot_troops  +
  scale_size("Survivors", range = c(0, 10), 
             breaks = breaks, labels = scales::comma(breaks)) +
  scale_color_manual("Direction", 
                     values = c("#228B22", "red"), 
                     labels=c("Advance", "Retreat")) +
  coord_cartesian(xlim = c(24, 38)) +
  xlab(NULL) +
  ylab(NULL) +
  #ylab("Latitude") + 
  ggtitle("Minard's Map - Assignment 2 - Viren Chhabria - 18301780") +
  theme_bw() +
  theme(plot.title = element_text(face="bold",hjust = 0.5),
        legend.position=c(.8, .25), legend.box="horizontal",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())
  

library(dplyr)
temp.nice <- temp %>%
  mutate(nice.label = paste0(temp$TEMP, "°, ", temp$MON, ". ", temp$DAY))

#' ## plot temperature vs. longitude, with labels for dates
plot_temp <- ggplot(temp.nice, aes(temp$LONT, temp$TEMP)) +
  geom_path(color="grey", size=1.5) +
  geom_point(size=2) +
  geom_label(aes(label = nice.label),
             #family = "Calibri",
             size = 2) +
  labs(x = NULL, y = "° Celsius") +
  #xlab("Longitude") + ylab("Temperature") +
  coord_cartesian(xlim = c(24, 38)) + 
  theme_bw()+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())


#' The plot works best if we  re-scale the plot window to an aspect ratio of ~ 2 x 1
windows(width=10, height=5)

#' Combine the two plots into one
grid.arrange(plot_minard, plot_temp, nrow=2, heights=c(3,1))
