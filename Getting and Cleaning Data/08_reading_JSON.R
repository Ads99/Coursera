setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")

names(jsonData)
names(jsonData$owner)
jsonData$owner$login

# Writing data frames to JSON
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)

# Back to dataframe (?)
iris2 <- fromJSON(myjson)
head(iris2)