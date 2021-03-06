# Exploratory Data Analysis - Course Assignment 2 - Plot1

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
# SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
# str(SCC)

## We need to combine the two data sets based on the SCC code
# mergedData = merge(NEI, SCC, by.x="SCC", by.y="SCC", all = TRUE) # all=TRUE includes NAs like a full outer join
# head(mergedData)

## We can now remove the old variables
# rm(NEI)
# rm(SCC)

## Plot 1 - Have total emissions from PM2.5 decreased in the United States from
##          1999 to 2008? Using the base plotting system, make a plot showing the
##          total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## First need to convert the year variable to a factor
NEI[,"year"] = as.factor(NEI[,"year"])
str(NEI)

## I'll also convert Pollutant to a factor just to check the values
## mergedData[,"Pollutant"] = as.factor(mergedData[,"Pollutant"])
## str(mergedData$Pollutant)

## Now we need to  summarise the data by year. We can do this one of two ways

## using aggregate and creating a new data.frame
NEI_sum_by_year_1 <- aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum)

## using tapply
NEI_sum_by_year_2 <- data.frame(
    year = levels(as.factor(NEI$year)),
    sumEmissions = tapply(NEI$Emissions, NEI$year, sum))

## Set default plotting parameters
par(mar=c(5.1, 4.1, 4.1, 2.1), mgp=c(3, 1, 0), las=0, mfrow = c(1, 1))

## Now we can use the barplot function to plot by year the sum of emissions
barplot(NEI_sum_by_year_1$x, names = NEI_sum_by_year_1$Group.1, xlab = "Year",
        ylab = expression("Total Emissions (tonnes) " * PM[2.5]),
        main = "Total Emissions (tonnes) by Year",
        col = "wheat")
dev.copy(png, file = "plot1.png")
dev.off()