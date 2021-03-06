# Exploratory Data Analysis - Course Assignment 2 - Plot4

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
NEI.Coal <- subset(mergedData, EI.Sector %in% c("Fuel Comb - Comm/Institutional - Coal",
                                                "Fuel Comb - Electric Generation - Coal",
                                                "Fuel Comb - Industrial Boilers, ICEs - Coal"))

## We can now remove the mergedData variable
rm(mergedData)

## The pre-subset EI.Sector column levels will still exist in this data frame...
table(NEI.Coal$EI.Sector)
## So we can drop the old levels using the following
NEI.Coal <- droplevels(NEI.Coal)
table(NEI.Coal$EI.Sector)

## We may also want to rename the factor variables to be more concise
## First we need to convert to character
NEI.Coal$EI.Sector <- as.character(NEI.Coal$EI.Sector)
NEI.Coal$EI.Sector[NEI.Coal$EI.Sector == "Fuel Comb - Comm/Institutional - Coal"] <- "Comm/Insitutional"
NEI.Coal$EI.Sector[NEI.Coal$EI.Sector == "Fuel Comb - Electric Generation - Coal"] <- "Electric Generation"
NEI.Coal$EI.Sector[NEI.Coal$EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal"] <- "Industrial Boilers, ICEs"
## Now convert back to a factor
NEI.Coal$EI.Sector <- as.factor(NEI.Coal$EI.Sector)

## Now need to  convert the year variable to a factor
NEI.Coal[,"year"] = as.factor(NEI.Coal[,"year"])
str(NEI.Coal)

## Now we need to  summarise the data by 'year' AND EI.Sector using aggregate and creating a new data.frame
NEI.Coal_sum_by_sector <- aggregate(NEI.Coal$Emissions, by=list(NEI.Coal$year, NEI.Coal$EI.Sector), FUN=sum)
## Now change the field names back to what they should be
colnames(NEI.Coal_sum_by_sector) <- c("year", "sector", "emissions_sum")

## Bring in the ggplot2 library and also the reshape2 library
library(ggplot2)

## Set default plotting parameters
par(mar=c(5.1, 4.1, 4.1, 2.1), mgp=c(3, 1, 0), las=0, mfrow = c(1, 1))

## Now we can use the ggplot qplot function to plot separate charts for each type
ggplot(NEI.Coal_sum_by_sector, aes(x = year, y = emissions_sum)) +
    geom_bar(aes(fill = year), position = "dodge", stat = "identity") +
    facet_grid(. ~ sector)

dev.copy(png, file = "plot4.png")
dev.off()