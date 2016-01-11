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

## PLOT 4 CODE ##

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# look at the SCC data, which holds source codes
head(SCC)

# find a field holding coal combustion
names(SCC)
table(SCC$EI.Sector) # a bit vague but seems to hold coal details

# select rows in SCC that have coal in the EI.Sector variable
coalsccs <- filter(SCC, grepl("Coal|coal", EI.Sector))

# get the SCC codes from the coalsccs dataframe
coalscccodes <- unique(coalsccs$SCC)

# now select rows in NEI that have a value in the SCC field that is one of the coal scc codes I have stored in the vector above
coalneis <- subset(NEI, SCC %in% coalscccodes)

# use dplyr to calculate the total PM2.5 emissions from all coal-related sources for the US
totalpm25 <- coalneis %>% group_by(year) %>% summarise(totalemissions = sum(Emissions))

# set 12 point font for the title
par(ps = 12, cex = 1, cex.main = 1)

# open a PNG device
plot.new()
png(filename = "plot4.png", width = 480, height = 480)

# load ggplot2 package
if(!require("ggplot2")) (install.packages("ggplot2"))
library(ggplot2)

# load the scales package to allow commas in the tick labels
if(!require("scales")) (install.packages("scales"))
library(scales)

# plot the data
ggplot(data = totalpm25, aes(x = year, y = totalemissions)) + geom_point() + geom_line() + labs(x = "Year", y = "Total PM2.5 emissions (tons)") + ggtitle("Total Emissions of PM2.5 from coal combusation-related sources  \n in the United States between 1999 and 2008") + theme(plot.title = element_text(size=12, face="bold.italic")) + scale_x_continuous(breaks = seq(1999,2008,1)) + scale_y_continuous(limits = c(0, 600000), breaks = seq(0, 600000, 100000), labels = comma)

# close the device
dev.off()

# tidy up
rm(coalneis, coalsccs, totalpm25, coalscccodes)

# Answer: Coal combustion-related emissions of PM2.5 have decreased between 1999 and 2008.