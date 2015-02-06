# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//R Programming//practice_assignment')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/R Programming/practice_assignment')

# Download and extract the files for this tutorial

dataset_url <- "http://s3.amazonaws.com/practice_assignment/diet_data.zip"
download.file(dataset_url, "diet_data.zip")
unzip("diet_data.zip", exdir = "diet_data")

# list the files we just downloaded
list.files("diet_data")

andy <- read.csv(".//diet_data//Andy.csv")
head(andy)

length(andy$Day) # 30 rows
dim(andy)
str(andy)
summary(andy)
names(andy)

# How do we see Andy's starting weight?
andy[1, "Weight"]
# His final weight?
andy[30, "Weight"]
# Alternatively, could create a subset of the 'Weight' column where 'Day' = 30
andy[which(andy$Day == 30), "Weight"] # or
andy[which(andy[,"Day"] == 30), "Weight"] # or
subset(andy$Weight, andy$Day == 30)

# Let's assign Andy's start and end weight to vectors
andy_start <- andy[1, "Weight"]
andy_end <- andy[30, "Weight"]

# We can find out how much weight he lost by substracting the vectors
andy_loss <- andy_start - andy_end
andy_loss

# Now we want to look at ALL the files to do some analysis
files <- list.files("diet_data")
files
head(read.csv(files[3])) # error

files_full <- list.files("diet_data", full.names=TRUE)
files_full
head(read.csv(files_full[3]))

# Merging two datasets
andy_david <- rbind(andy, read.csv(files_full[2]))
head(andy_david)
tail(andy_david)

# Now creating a subset which gets just the 25th day
day_25 <- andy_david[which(andy_david$Day == 25), ]
day_25

# Now using a loop
for (i in 1:5) {print(i)}

dat <- data.frame()
# Enhanced
for (i in 1:5) {
  dat <- rbind(dat, read.csv(files_full[i]))
}
str(dat)

# Now to find the median of the weight
median(dat$Weight) #NA - there are missing values in here somewhere
dat

# We can use another argument to median which strips the NAs out
median(dat$Weight, na.rm=TRUE)
mean(dat$Weight, na.rm=TRUE)

# So 190 is the median weight. We can find the median weight of day 30 by taking the median of a subset of
# the data where Day=30.
dat_30 <- dat[which(dat[, "Day"] == 30),]
dat_30
<<<<<<< HEAD
median(dat_30$Weight)
=======
median(dat_30$Weight)


>>>>>>> 666b0dbd7e6f3097fc362dfa9b108ec8b4f5672c
