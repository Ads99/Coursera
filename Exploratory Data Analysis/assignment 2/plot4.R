# Exploratory Data Analysis - Course Assignment 2 - Plot3

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
mergedData = merge(NEI, SCC, by.x="SCC", by.y="SCC", all.x) # all.x includes everything from NEI, but only SCC where it joins
head(mergedData)

## We can now remove the old variables
rm(NEI)
rm(SCC)

## Plot 4 - Across the United States, how have emissions from coal combustion-related sources
##          changed from 1999-2008

## First we need to find emissions related to coal combustion
table(mergedData$Data.Category) ## Not this one
table(mergedData$Short.Name) ## Not this one
table(mergedData$EI.Sector)
'''
this one where values in
c("Fuel Comb - Comm/Institutional - Coal",
  "Fuel Comb - Electric Generation - Coal",
  "Fuel Comb - Industrial Boilers, ICEs - Coal")
'''

## Filter on all coal combustion related sources


## First need to convert the year variable to a factor
NEI[,"year"] = as.factor(NEI[,"year"])
str(NEI)

## Now we need to filter on only fips == 24510
NEI.24510 <- NEI[which(NEI$fips == "24510"),]
str(NEI.24510)

## We can now remove the NEI variable
rm(NEI)

## Now I'll convert the 'type' variable to a factor
NEI.24510[,"type"] = as.factor(NEI.24510[,"type"])
str(NEI.24510)
table(NEI.24510$type)

## Now we need to  summarise the data by year AND type
## using aggregate and creating a new data.frame
NEI.24510_sum_by_year_type <- aggregate(NEI.24510$Emissions, by=list(NEI.24510$year, NEI.24510$type), FUN=sum)
## Now change the field names back to what they should be
colnames(NEI.24510_sum_by_year_type) <- c("year", "type", "emissions_sum")

## Bring in the ggplot2 library and also the reshape2 library
library(ggplot2)

## Set default plotting parameters
par(mar=c(5.1, 4.1, 4.1, 2.1), mgp=c(3, 1, 0), las=0, mfrow = c(1, 1))

## Now we can use the ggplot qplot function to plot separate charts for each type
ggplot(NEI.24510_sum_by_year_type, aes(x = year, y = emissions_sum)) +
    geom_bar(aes(fill = year), position = "dodge", stat = "identity") +
    facet_grid(. ~ type)

dev.copy(png, file = "plot3.png")
dev.off()