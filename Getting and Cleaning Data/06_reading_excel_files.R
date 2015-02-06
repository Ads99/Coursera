setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

#fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
fileUrl <- "http://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
#download.file(fileUrl,destfile="./data/cameras.xlsx",method="curl")
download.file(fileUrl,destfile="./data/cameras.xlsx")
dateDownloaded <- date()
dateDownloaded
# "Fri Oct 10 18:15:59 2014"

library(xlsx)
cameraData <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
head(cameraData)

# N.B. DOWNLOADING FROM THE URL SEEMS TO RESULT IN A CORRUPT FILE, I DOWNLOADED MANUALLY

colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,
                              colIndex=colIndex,rowIndex=rowIndex)
cameraDataSubset

# Further notes
# The write.xlsx function will write out an Excel file with similar arguments.
# read.xlsx2 is much faster than read.xlsx but for reading subsets of rows may be slightly unstable.
# The XLConnect package has more options for writing and manipulating Excel files
# The XLConnect vignette is a good place to start for that package
# In general it is advised to store your data in either a database or in comma separated files (.csv) or tab separated files (.tab/.txt) as they are easier to distribute.