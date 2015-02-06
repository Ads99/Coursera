# Reshaping data

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("./data")) {
  dir.create("./data")
}

# Tidy data
# 1) Each variable forms a column
# 2) Each observation forms a row
# 3) Each table/file stores data about one kind of observation

library(reshape2)
head(mtcars)

# Melting data frames
# Defines which of the variables are id variables, and which are measures
# Essentially reshapes the data set to make a tall, skinny dataset
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)

# Casting data frames - reformatting the data shapes into different shapes
cylData <- dcast(carMelt, cyl ~ variable) # By default does this by length
cylData

cylData <- dcast(carMelt, cyl ~ variable,mean)
cylData

# Averaging values
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum) # apply to count, along the index spray, the function sum

# Another way - split
spIns = split(InsectSprays$count,InsectSprays$spray)
spIns

# then use apply
sprCount = lapply(spIns,sum)
sprCount

# Another way - combine
unlist(sprCount)
sapply(spIns,sum)

# Another way - plyr package
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count))

# Creating a new variable
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
head(spraySums)