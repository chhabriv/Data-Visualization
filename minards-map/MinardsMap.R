#author: Viren Chhabria
#ID: 18301780
#Course: Data Visualization (CS7DS4)
#Assignment: 2, Part B

#libraries
library(ggplot2)
library(scales)
library(gridExtra)
library(readxl)
library(ggmap)
library(ggrepel)
library(dplyr)

#set constants
FILE_DIRECTORY="H:/TCD/Semester 2/DataVisualization/Assignment2"
FILENAME="minard-data.xlsx"
PLOT_TITLE="Minard's Map - Assignment 2 - Viren Chhabria - 18301780"
OUTPUT_FILENAME="VirenChhabria-18301780-MinardsMap.png"

setwd(FILE_DIRECTORY)
minard_data <- read_excel(FILENAME)

#Read data from the excel file
cities=minard_data[1:3]
temp=minard_data[4:8]
troops=minard_data[9:13]
cities=na.omit(cities)
troops=na.omit(troops)

#set points which are not the same as city, so the chart has the number of survivors
troops_plot=filter(troops, !(troops$LONP %in% cities$LONC))
troops_plot=troops_plot[troops_plot$SURV!=175000,]

# set option for displaying number of soldiers without exponenet
options(scipen=10000)

# Reference : https://vincentarelbundock.github.io/Rdatasets/doc/HistData/Minard.temp.html
# plot path of troops, and another layer for city names
plot_troops = ggplot(troops, 
                     aes(troops$LONP, 
                         troops$LATP)) +
  geom_path(aes(size = troops$SURV, 
                colour = troops$DIR, 
                group = troops$DIV),
            lineend = "round", 
            linejoin = "round") +
  geom_point(data = cities, 
             aes(x = cities$LONC, 
                 y = cities$LATC),
             color = "black") +
  geom_text_repel(data = cities, 
                  aes(x = cities$LONC, 
                      y = cities$LATC, 
                      label = cities$CITY),
                  color = "black")+
  geom_text_repel(data = troops_plot, 
                  aes(x = troops_plot$LONP, 
                      y = troops_plot$LATP, 
                      label = troops_plot$SURV), 
                  size=2.5,
                  color = "black",
                  point.padding = NA)+
                  scale_x_continuous(labels = comma)

# Combine these, and add scale information, labels, etc.
# Set the x-axis limits for longitude explicitly, to coincide with those for temperature

# set ranges to use in the legend
breaks = c(0.04,0.5,1,2,2.5,3.4) * 10^5 

plot_minard = plot_troops  +
  scale_size("Survivors", 
             range = c(0, 10), 
             breaks = breaks, 
             labels = scales::comma(breaks)) +
  scale_color_manual("Direction", 
                     values = c("#228B22", "red"), 
                     labels=c("Advance", "Retreat")) +
  coord_cartesian(xlim = c(24, 38)) +
  xlab(NULL) +
  ylab(NULL) +
  ggtitle(PLOT_TITLE) +
  theme_bw() +
  theme(plot.title = element_text(face="bold",hjust = 0.5),
        legend.position=c(.8, .25), 
        legend.box="horizontal",
        legend.title = element_text(face="bold"), 
        legend.box.background = element_rect(color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())
  
temp.nice = temp %>%
  mutate(nice.label = paste0(temp$TEMP, "°, ", temp$MON, ". ", temp$DAY))

#' ## plot temperature vs. longitude, with labels for dates
plot_temp = ggplot(temp.nice, aes(temp$LONT, temp$TEMP)) +
  geom_path(color="blue", size=1.5) +
  geom_point(size=2) +
  geom_label(aes(label = nice.label),
             size = 2.5) +
  labs(x = NULL, y = "° Celsius") +
  coord_cartesian(xlim = c(24, 38)) +
  theme_bw()+
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(), 
        axis.ticks = element_blank(),
        panel.border = element_blank())


# The plot works best if we  re-scale the plot window to an aspect ratio of ~ 2 x 1
windows(width=10, height=5)

# Combine the two plots into one
minards_map=grid.arrange(plot_minard, plot_temp, nrow=2, heights=c(3.1,1.25))
ggsave(filename=OUTPUT_FILENAME,
       plot=minards_map, 
       width = 15, 
       height = 7.5)
