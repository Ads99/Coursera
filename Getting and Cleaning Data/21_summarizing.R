# Summarizing Data

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C:/Users/ABaker/Documents/GitHub/Coursera/Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/restaurants.csv")
restData <- read.csv("./data/restaurants.csv")

head(restData,n=3)
tail(restData,n=3)
summary(restData)
str(restData)

quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))

table(restData$zipCode,useNA="ifany") # ifany - if any missing values a new col will be added to summary results

# 2 dimensional table
table(restData$councilDistrict,restData$zipCode)

# Check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)

# Row and column sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

# Values with specific characteristics
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))

# then use this to subset
restData[restData$zipCode %in% c("21212","21213"),]

# Cross tabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit,data=DF)
xt

# Flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~.,data=warpbreaks)
xt

ftable(xt)

# Size of a data set
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")

