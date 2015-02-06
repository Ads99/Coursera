# Merging data

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("./data")) {
  dir.create("./data")
}

fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv")
download.file(fileUrl2,destfile="./data/solutions.csv")
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)

# Merging data - merge()
# merges data frames
# important parameters: x,y,by,by.x,by.y,all
names(reviews)
names(solutions)

mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE) # all=TRUE includes NAs like a full outer join
head(mergedData)

# Default - merge all common column names - will try to merge on the 4 variables below
intersect(names(solutions),names(reviews))
# [1] "id"        "start"     "stop"      "time_left"

mergedData2 = merge(reviews,solutions,all=TRUE)
head(mergedData2)

# Using join in the plyr package (bit faster than merge, but less full-featured)
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
head(df1); head(df2)
arrange(join(df1,df2),id)

# If you have multiple data frames (harder with "merge", more straighforward with the join_all command)

df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)