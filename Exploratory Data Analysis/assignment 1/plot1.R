# Exploratory Data Analysis - Course Assignment 1

# Dataset: Electric power consumption [20Mb]
# Description: Measurements of electric power consumption in one household with a one-minute sampling rate over 4 years.
#              Different electrical quantities and some sub-metering values are available.
# Variables:
#   Date: Date in format dd/mm/yyyy
#   Time: time in format hh:mm:ss
#   Global_active_power: household global minute-averaged active power (in kilowatt)
#   Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#   Voltage: minute-averaged voltage (in volt)
#   Global_intensity: household global minute-averaged current intensity (in ampere)
#   Sub_metering_1: (in watt-hour of active energy). Corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#   Sub_metering_2: (in watt-hour of active energy). Corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#   Sub_metering_3: (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

# We will only be using data from the dates 2007-02-01 and 2007-02-02
# You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
# Note that in this dataset missing values are coded as ?.

# Remove everything from the workspace
rm(list = ls())

# Reading in part of a data set

# Windows
#setwd('C://Users//ABaker//Documents//GitHub//Coursera//Exploratory Data Analysis//assignment 1')
# OS X
#setwd('/Users/adam_baker_1/Coursera/Exploratory Data Analysis/assignment 1')

# Read in the "features.txt" file which contains column headers for each of the test_X and train_X data sets
features <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
str(features)
head(features)

# Convert 'Time' field to proper time
x <- paste(features[, "Date"], features[,"Time"])
x <- strptime(x, "%d/%m/%Y %H:%M:%S")
# Add a new field which is "DateTime"
features[,"DateTime"] = as.POSIXct(x)

# Now convert 'Date' field to proper Date (just because)
features[,"Date"] = as.Date(features[,"Date"], format="%d/%m/%Y")

# Check everything looks ok
str(features)

# Now subset on only the rows we care about: 2007-02-01 and 2007-02-02
features <- features[ which(features$Date == "2007-02-01" | features$Date == "2007-02-02"),]
table(features$Date)
summary(features)

# Remove variables not required
rm(x)

str(features)

# Plot 1 - Histogram with red bars. Global Active Power (kw) by Frequency
hist(features$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, file = "plot1.png")
dev.off()