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
#setwd('/Users/adam_baker_1/GitHub/Coursera/Exploratory Data Analysis/assignment 1')

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

################################################################################
## Exploratory Graphs
################################################################################

# Simple Boxplot
boxplot(features$Global_active_power, col="blue")

# Simple Histogram with rug
hist(features$Global_active_power, col = "green")
rug(features$Global_active_power)

# Simple Histogram with rug. Extra breaks argument
hist(features$Global_active_power, col = "green", breaks = 100)
rug(features$Global_active_power)

# Simple Boxplot with absolute (horizontal) line
boxplot(features$Global_active_power, col = "blue")
abline(h = 4)

# Simple Histogram with absolute (vertical) line specified arbitrarily and also to the median
hist(features$Global_active_power, col = "green")
abline(v = 4, lwd = 2)
abline(v = median(features$Global_active_power), col = "magenta", lwd = 4)

# Simple Barplot showing a category (have to convert using 'table')
barplot(table(features$Date), col = "wheat", main = "Number of responses by Date")

# Multiple Boxplots
boxplot(Global_active_power ~ Date, data = features, col = "red")

# Multiple Histograms
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1)) # first argument sets number of cols/rows for charts, second arg is margins
hist(subset(features, Date == "2007-02-01")$Global_active_power, col = "green")
hist(subset(features, Date == "2007-02-02")$Global_active_power, col = "green")

# Scatterplot
with(features, plot(Global_active_power, Global_reactive_power))
abline(h = 0.2, lwd = 2, lty = 2)

# Scatterplot - Using colour
with(features, plot(Global_active_power, Global_reactive_power, col = Date))
abline(h = 0.2, lwd = 2, lty = 2)

# Multiple Scatterplots
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(features, Date = "2007-02-01"), plot(Sub_metering_1, Sub_metering_2, main = "2007-02-01"))
with(subset(features, Date = "2007-02-02"), plot(Sub_metering_1, Sub_metering_2, main = "2007-02-02"))

################################################################################
## Plotting Systems in R
################################################################################

# Base Plotting System
# - "Artist's pallette" model
# - Start with blank canvas and build up from there. Start with plot function or similar
# - Use annotations to add/modify (text, lines, points, axis)

library(datasets)
data(cars)
with(cars, plot(speed, dist))

# The Lattice System
# - Plots created with a single function call (xyplot, bwplot, etc.)
# - Most useful for conditioning types of plots: look at how y changes with x across levels of z
# - Things like margins/spacing set automatically because entire plot is specified at once
# - Good for putting many, many plots on a screen

library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4, 1))

# The ggplot2 System
# - Splits the difference between base and lattice in a number of ways
# - Automatically deals with spacings, text, titles, but also allows annotation
# - Superficial similarity to lattice but generally easier/more inuitive
# - Default mode makes choices for you (but still customisable)

library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)

################################################################################
## Base Plotting System in R
################################################################################

library(datasets)
hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone))
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")

# Some base graphics parameters
# pch: the plotting symbol (default is open circle)
# lty: the line type (default is solid line), can be dashed, dotted, etc.
# lwd: the line width, specified as an integer multiple
# col: the plotting color, specified as a number, string, or hex code; the colors() function gives you a vector of colors by name
# xlab: character string for the x-axis label
# ylab: character string for the y-axis label

# Base plotting functions
# plot: make a scatterplot, or other type of plot depending on the class of the object being plotted
# lines: add lines to a plot, given a vector x values and a corresponding vector of y values (or a 2-
#                         column matrix); this function just connects the dots
# points: add points to a plot
# text: add text labels to a plot using specified x, y coordinates
# title: add annotations to x, y axis labels, title, subtitle, outer margin
# mtext: add arbitrary text to the margins (inner or outer) of the plot
# axis: adding axis ticks/labels

with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City") ## Add a title

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City",
                      type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))

# Base plot with regression line
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", pch = 20))
model <- lm(Ozone ~ Wind, airquality)
abline(model, lwd = 2)

# Multiple Base Plots
par(mfrow = c(1, 2))
with(airquality, {
    plot(Wind, Ozone, main = "Ozone and Wind")
    plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})

# Multiple Base Plots 2
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
    plot(Wind, Ozone, main = "Ozone and Wind")
    plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
    plot(Temp, Ozone, main = "Ozone and Temperature")
    mtext("Ozone and Weather in New York City", outer = TRUE)
})

################################################################################
## Graphics Devices in R
################################################################################

# 1. Explicitly launch a graphics device
# 2. Call a plotting function to make a plot (Note: if you are using a file
#    device, no plot will appear on the screen)
# 3. Annotate plot if necessary
# 4. Explicitly close graphics device with dev.off() (this is very important!)

pdf(file = "myplot.pdf") ## Open PDF device; create 'myplot.pdf' in my working directory
## Create plot and send to a file (no plot appears on screen)
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser data") ## Annotate plot; still nothing on screen
dev.off() ## Close the PDF file device
## Now you can view the file 'myplot.pdf' on your computer

# Vector formats:
# pdf: useful for line-type graphics, resizes well, usually portable, not
#      efficient if a plot has many objects/points
# svg: XML-based scalable vector graphics; supports animation and interactivity,
#      potentially useful for web-based plots
# win.metafile: Windows metafile format (only on Windows)
# postscript: older format, also resizes well, usually portable, can be used to
#             create encapsulated postscript files; Windows systems often don't
#             have a postscript viewer

# Bitmap formats:
# png:  bitmapped format, good for line drawings or images with solid colors.
#       Lossless, good for plotting many many many points, does not resize well
# jpeg: good for photographs or natural scenes. Lossy compression, good for
#       plotting many many many points, does not resize well
# tiff: Creates bitmap files in the TIFF format; supports lossless compression
# bmp:  a native Windows bitmapped format

# Copying plots
# Copying a plot to another device can be useful because some plots require a lot of code and it can
# be a pain to type all that in again for a different device.

# dev.copy: copy a plot from one device to another
# dev.copy2pdf: specifically copy a plot to a PDF file

library(datasets)
with(faithful, plot(eruptions, waiting)) ## Create plot on screen device
title(main = "Old Faithful Geyser data") ## Add a main title
dev.copy(png, file = "geyserplot.png") ## Copy my plot to a PNG file
dev.off() ## Don't forget to close the PNG device!