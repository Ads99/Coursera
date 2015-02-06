setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

library(RMySQL)

ucscDb <- dbConnect(MySQL(),user="genome", 
                    host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb)