# Summarizing Data

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("./data")) {
  dir.create("./data")
}

fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/Restaurants.csv",method="curl")
restData <- read.csv("./data/Restaurants.csv")

head(restData,n=3)
tail(restData,n=3)
summary(restData)
str(restData)

# Quantiles of quantitative variables
quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.7,0.9))

# Make table - use this command to make a table of a single variable
table(restData$zipCode,useNA="ifany")
# What the useNA="ifany" command does is to indicate how many NA values there are and add them to the 
#end of the table. By default the command doesn't tell you

# Make table - create a two dimensional table
table(restData$councilDistrict,restData$zipCode)

# Check for missin values
sum(is.na(restData$councilDistrict)) # 0 - there are no NA values in this variable
any(is.na(restData$councilDistrict)) # FALSE - similar to above
all(restData$zipCode > 0) # FALSE - one of the values is less than 0

# Row and column sums
colSums(is.na(restData))
#name         zipCode    neighborhood councilDistrict  policeDistrict      Location.1 
#0               0               0               0               0               0 
all(colSums(is.na(restData))==0)

# Values with specific characteristics
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))

# Now we can look for values in the table with only the required zip codes
restData[restData$zipCode %in% c("21212","21213"),]

# Cross tabs
data(UCBAdmissions)
DF <- as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit,data=DF)
xt

# Crosstabs for a larger number of variables are often hard to see, so we 
#can use warpbreaks
data(warpbreaks)
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks)
xt

# Flat tables summarize the data in a much more compact way
ftable(xt)

# Size of a data set
fakeData = rnorm(1e5)
object.size(fakeData) # 800040 bytes
print(object.size(fakeData),units="Mb") # 0.8 Mb