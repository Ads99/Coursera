setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

# Downloading data from the Web
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

# download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
# Using method = "curl" doesn't seem to work
download.file(fileUrl, destfile = "./data/cameras.csv")

list.files("./data")
# [1] "cameras.csv"

dateDownloaded <- date()
dateDownloaded
# "Fri Oct 10 17:56:01 2014"

# Some notes about download.file()
# If the url starts with http you can use download.file()
# If the url starts with https on Windows you may be ok
# If the url starts with https on Mac you may need to set method="curl"
# If the file is big, this might take a while
# Be sure to record when you downloaded.