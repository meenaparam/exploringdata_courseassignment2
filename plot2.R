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

## PLOT 2 CODE ##

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# look at the NEI data
head(NEI)

# use dplyr to calculate the total PM2.5 emissions from all sources for Baltimore.
baltimore <- filter(NEI, fips == "24510")
totalpm25 <- baltimore %>% group_by(year) %>% summarise(totalemissions = sum(Emissions))

# set 12 point font for the title
par(ps = 12, cex = 1, cex.main = 1)

# open a PNG device
png(filenalot.new()
pme = "plot2.png", width = 480, height = 480)

# plot the data
with(totalpm25, plot(x = year, y = totalemissions, type = "l", ylab = "Total PM2.5 Emissions (tons)", xlab = "Year", ylim = c(0, 3500), xlim = c(1999,2008)))

# add correct year axis labels to x-axis
axis(1,at=seq(1999,2008,1),labels=T)

# add main title and make the font bold italic
title(main = "Total Emissions from PM2.5 in Baltimore \n between 1999 and 2008", font.main = 4)

# close the device
dev.off()

# remove extra objects
rm(baltimore, totalpm25)

# Answer:YES. TotaNOmissions from PM2.5 have decreasednot consistently  in the United States between 1999 and 2008.
