# Exploratory Data Analysis - Course Assignment 2

# Dataset:
#  PM2.5 Emissions Data:
#   summarySCC_PM25:            data frame with all of the PM2.5 emissions data for
#                               1999, 2002, 2005, and 2008. For each year, the table
#                               contains number of tons of PM2.5 emitted from a specific
#                               type of source for the entire year.
#
#   Source_Classification_Code: mapping from the SCC digit strings in the Emissions table
#                               to the actual name of the PM2.5 source.

# Remove everything from the workspace
rm(list = ls())

## Set the working directory
## setwd('C:/Users/ABaker/Documents/GitHub/Coursera/Exploratory Data Analysis/assignment 2')

list.files("exdata-data-NEI_data")

## Read in both data files
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

## We need to combine the two data sets based on the SCC code
mergedData = merge(NEI, SCC, by.x="SCC", by.y="SCC", all = TRUE) # all=TRUE includes NAs like a full outer join
head(mergedData)

## We can now remove the old variables
rm(NEI)
rm(SCC)

## Plot 1 - Have total emissions from PM2.5 decreased in the United States from
##          1999 to 2008? Using the base plotting system, make a plot showing the
##          total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## First need to convert the year variable to a factor
mergedData[,"year"] = as.factor(mergedData[,"year"])
str(mergedData)

## I'll also convert Pollutant to a factor just to check the values
mergedData[,"Pollutant"] = as.factor(mergedData[,"Pollutant"])
str(mergedData$Pollutant)

## Now to plot all Emissions for the periods
table(mergedData$Emissions)
barplot(table(features$Date), col = "wheat", main = "Number of responses by Date")

""
# Plot 1 - Histogram with red bars. Global Active Power (kw) by Frequency
hist(features$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, file = "plot1.png")
dev.off()