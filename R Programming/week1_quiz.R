# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//R Programming')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/R Programming')

if (!file.exists("data")) {
  dir.create("data")
}

list.files("./data")

hw1_data <- read.csv("./data/hw1_data.csv")
head(hw1_data)

hw1_data[1:2,]

nrow(hw1_data) # 153

tail(hw1_data)

hw1_data[47,]

summary(hw1_data)

hw1_no_NAs <- hw1_data[!is.na(hw1_data$Ozone),]
mean(hw1_no_NAs$Ozone)

hw1_subset <- subset(hw1_data, Ozone > 31 & Temp > 90)
mean(hw1_subset$Solar.R)

mean(subset(hw1_data, Month == 6)$Temp)

hw1_subset2 <- subset(hw1_data[!is.na(hw1_data$Ozone),], Month == 5)
max(hw1_subset2$Ozone)