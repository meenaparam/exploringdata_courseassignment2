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

## PLOT 6 CODE ##

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen greater changes over time in motor vehicle emissions?

# look at the SCC data, which holds source codes
head(SCC)

# find a field holding motor vehicle combustion
names(SCC)
table(SCC$EI.Sector)

# select rows in SCC that have vehicle in the EI.Sector variable
vehiclesccs <- filter(SCC, grepl("Vehicle|vehicle", EI.Sector))

# get the SCC codes from the vehiclessccs dataframe
vehiclescccodes <- unique(vehiclesccs$SCC)

# now select rows in NEI that have a value in the SCC field that is one of the vehicle scc codes I have stored in the vector above and where Baltimore or LA are the cities
vehicle_neis <- subset(NEI, SCC %in% vehiclescccodes & fips %in% c("24510","06037"))

# use dplyr to calculate the total PM2.5 emissions from all vehicle-related sources for Baltimore
totalpm25 <- vehicle_neis %>% group_by(year,fips) %>% summarise(totalemissions = sum(Emissions))

# add a variable to hold the names of the cities
totalpm25$city <- factor(totalpm25$fips, levels = c("24510", "06037"), labels = c("Baltimore City", "Los Angeles County"))

# set 12 point font for the title
par(ps = 12, cex = 1, cex.main = 1)

# open a PNG device
plot.new()
png(filename = "plot6.png", width = 480, height = 480)

# load ggplot2 package
if(!require("ggplot2")) (install.packages("ggplot2"))
library(ggplot2)

# load the scales package to allow commas in the tick labels
if(!require("scales")) (install.packages("scales"))
library(scales)

# plot the data
ggplot(data = totalpm25, aes(x = year, y = totalemissions, group = city)) + geom_point(aes(color = city)) + geom_line(aes(color = city)) + labs(x = "Year", y = "Total PM2.5 emissions (tons)") + ggtitle("Total Emissions of PM2.5 from motor vehicle-related sources \n in Baltimore City and Los Angeles County \n between 1999 and 2008") + theme(plot.title = element_text(size=12, face="bold.italic")) + scale_x_continuous(breaks = seq(1999,2008,1)) + scale_y_continuous(limits = c(0, 5000), breaks = seq(0, 5000, 500), labels = comma) + theme(legend.position = "bottom", legend.title = element_blank())

# close the device
dev.off()

# tidy up
rm(vehicle_neis, vehiclesccs, totalpm25, vehiclescccodes)

# Answer: Motor vehicle-related emissions of PM2.5 have decreased in Baltimore between 1999 and 2008.