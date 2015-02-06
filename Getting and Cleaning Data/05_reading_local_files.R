setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

# Loading flat files - read.table()
# This is the main function for reading data into R
# Flexible and robust but requires more parameters
# Reads the data into RAM - big data can cause problems
# Important parameters file, header, sep, row.names, nrows
# Related: read.csv(), read.csv2()

cameraData <- read.table("./data/cameras.csv")

# Error in scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  : 
# line 1 did not have 13 elements

# The reason is that the read.table() method expects the file to be tab delimited,
# We need to specify that the file is comma delimited

cameraData <- read.table("./data/cameras.csv", sep = ",", header = TRUE)
head(cameraData)

# Or we could use read.csv() which has the above two arguments as default
cameraData <- read.csv("./data/cameras.csv")
head(cameraData)

# Some more important parameters
# quote - you can tell R whether there are any quoted values quote="" means no quotes.
# na.strings - set the character that represents a missing value.
# nrows - how many rows to read of the file (e.g. nrows=10 reads 10 lines).
# skip - number of lines to skip before starting to read

# In my experience, the biggest trouble with reading flat files are quotation marks ` or " placed in data
# values, setting quote="" often resolves these

