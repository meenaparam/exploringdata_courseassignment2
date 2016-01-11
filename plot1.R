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

## PLOT 1 CODE ##

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# look at the NEI data
head(NEI)

# use dplyr to calculate the total PM2.5 emissions from all sources. Divide the measure by 1,000,000 to convert to millions
totalpm25 <- NEI %>% group_by(year) %>% summarise(totalemissions = sum(Emissions), totalemissions_div_million = (totalemissions / 1000000))

# set 12 point font for the title
par(ps = 12, cex = 1, cex.main = 1)

# open a PNG device
plot.new()
png(filename = "plot1.png", width = 480, height = 480)

# plot the data
with(totalpm25, plot(x = year, y = totalemissions_div_million, type = "l", ylab = "Total PM2.5 Emissions (million tons)", xlab = "Year", xlim = c(1999,2008)))

# add correct year axis labels to x-axis
axis(1,at=seq(1999,2008,1),labels=T)

# add main tile and make the font bold italic
title(main = "Total Emissions from PM2.5 in the United States \n between 1999 and 2008", font.main = 4)

# close the device
dev.off()

# tidy up extra objects
rm(totalpm25)

# Answer: YES. Total emissions from PM2.5 have decreased in the United States between 1999 and 2008.
