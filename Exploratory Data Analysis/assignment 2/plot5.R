# Exploratory Data Analysis - Course Assignment 2 - Plot5

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

## Plot 5 - How have emissions from motor vehicle sources changed from 1999-2008
##          in Baltimore City?

## First we need to find emissions related to motor vehicles
table(mergedData$EI.Sector)
'''
this one where values have "Vehicles" at the end
'''

## Filter on all coal combustion related sources
NEI.Vehicles <- subset(mergedData, grepl("Vehicles", mergedData$EI.Sector))
NEI.Vehicles <- droplevels(NEI.Vehicles)
table(NEI.Vehicles$EI.Sector)

## Also filter on only Baltimore City, fips == 24510
NEI.Vehicles.24510 <- NEI.Vehicles[which(NEI.Vehicles$fips == "24510"),]
str(NEI.Vehicles.24510)

## We can now remove the other variables
rm(mergedData)
rm(NEI.Vehicles)

## We may also want to rename the factor variables to be more concise
## First we need to convert to character
NEI.Vehicles.24510$EI.Sector <- as.character(NEI.Vehicles.24510$EI.Sector)
NEI.Vehicles.24510$EI.Sector[NEI.Vehicles.24510$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles"] <- "On-Road Diesel Heavy Duty"
NEI.Vehicles.24510$EI.Sector[NEI.Vehicles.24510$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles"] <- "On-Road Diesel Light Duty"
NEI.Vehicles.24510$EI.Sector[NEI.Vehicles.24510$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles"] <- "On-Road Gas Heavy Duty"
NEI.Vehicles.24510$EI.Sector[NEI.Vehicles.24510$EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles"] <- "On-Road Gas Light Duty"
## Now convert back to a factor
NEI.Vehicles.24510$EI.Sector <- as.factor(NEI.Vehicles.24510$EI.Sector)

## Now need to  convert the year variable to a factor
NEI.Vehicles.24510[,"year"] = as.factor(NEI.Vehicles.24510[,"year"])
str(NEI.Vehicles.24510)

## Now we need to  summarise the data by 'year' AND EI.Sector using aggregate and creating a new data.frame
NEI.Vehicles.24510_agg <- aggregate(NEI.Vehicles.24510$Emissions, by=list(NEI.Vehicles.24510$year, NEI.Vehicles.24510$EI.Sector), FUN=sum)
## Now change the field names back to what they should be
colnames(NEI.Vehicles.24510_agg) <- c("year", "sector", "emissions_sum")

## Bring in the ggplot2 library and also the reshape2 library
library(ggplot2)

## Set default plotting parameters
par(mar=c(5.1, 4.1, 4.1, 2.1), mgp=c(3, 1, 0), las=0, mfrow = c(1, 1))

## Now we can use the ggplot qplot function to plot separate charts for each type
ggplot(NEI.Vehicles.24510_agg, aes(x = year, y = emissions_sum)) +
    geom_bar(aes(fill = year), position = "dodge", stat = "identity") +
    facet_grid(. ~ sector)

dev.copy(png, file = "plot5.png")
dev.off()