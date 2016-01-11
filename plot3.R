## Title: Exploring Data Analysis - Course Project 2
## Author: Meenakshi Parameshwaran
## Date: 11/01/16

## Set the working directory
"/Users/meenaparam/GitHub/exploringdata_courseassignment2"

## Get and load the data
myurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(url = myurl, destfile = "pm25.zip", method = "curl")

unzip(zipfile = "pm25.zip", exdir = "./") # unzips to the current directory

# check the RDS data files are in the current directory
dir()

# read in the two data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# load dplyr package for later data manipulation
if(!require("dplyr")) (install.packages("dplyr"))
library(dplyr)

## PLOT 3 CODE ##

# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# look at the NEI data
head(NEI)

# use dplyr to calculate the total PM2.5 emissions from all sources by type for Baltimore.
baltimore <- filter(NEI, fips == "24510")
totalpm25 <- baltimore %>% group_by(year, type) %>% summarise(totalemissions = sum(Emissions))

# set 12 point font for the title
par(ps = 12, cex = 1, cex.main = 1)

# open a PNG device
plot.new()
png(filename = "plot3.png", width = 480, height = 480)

# load ggplot2 package
library(ggplot2)

# plot the data
ggplot(data = totalpm25, aes(x = year, y = totalemissions, group = type)) + geom_point(aes(color = type)) + geom_line(aes(color = type)) + labs(x = "Year", y = "Total PM2.5 Emissions (tons)") + ggtitle("Total Emissions from PM2.5 in Baltimore \n between 1999 and 2008 by source type of emission") + theme(plot.title = element_text(size=12, face="bold.italic")) + scale_colour_discrete(name = "Source type of Emission", breaks = c("NON-ROAD", "ON-ROAD", "NONPOINT", "POINT")) + scale_x_continuous(breaks = seq(1999,2008,1)) + scale_y_continuous(breaks = seq(0, 2250, 250), limits = c(0,2250)) + theme(legend.position = "bottom")

# close the device
dev.off()

# tidy up
rm(baltimore, totalpm25)

# Answer: Point emissions have increased between 1999 and 2008. The other three types have decreased.
