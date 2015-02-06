# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

# Question 1 - How many properties are worth $1,000,000 or more?

# Downloading data from the Web
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

# Using method = "curl" doesn't seem to work on Windows
download.file(fileUrl, destfile = "./data/ac_survey.csv")

# Using method = "curl" on OS X works
download.file(fileUrl, destfile = "./data/ac_survey.csv", method = "curl")

list.files("./data")

acSurveyData <- read.csv("./data/ac_survey.csv")
head(acSurveyData)

library(data.table)

DF = data.frame(acSurveyData)
DT = data.table(acSurveyData)
head(DT)
nrow(DT) # 6496

nrow(DT[DT$VAL==24]) # Answer = 53

# Question 2 - Consider the variable FES in the code book. Which of the "tidy data" principles does this variable violate?

head(DT$FES)
DT$FES # Tidy data has one variable per column

# Question 3 - What is the value of: sum(dat$Zip*dat$Ext,na.rm=T) 

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl,destfile="./data/gas_program.xlsx",method="curl")

library(xlsx)

colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./data/gas_program.xlsx",sheetIndex=1,
                              colIndex=colIndex,rowIndex=rowIndex)

dat
sum(dat$Zip*dat$Ext,na.rm=T) # 36534720

# Question 4 - How many restaurants have zipcode 21231?

library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)

# Directly access parts of the XML document
rootNode[[1]]
rootNode[[1]][[1]]

# Programatically extract parts of the file
xmlSApply(rootNode,xmlValue)

# XPath
# /node - Top level node
# //node - Node at any level
# node[@attr-name] - Node with an attribute name
# node[@attr-name='bob'] - Node with attribute name attr-name='bob'

# Get the zipcodes
DTzips = data.table(xpathSApply(rootNode,"//zipcode",xmlValue))
nrow(DTzips[DTzips$V1==21231]) # Answer = 127

# Question 5 - using the fread() command load the data into an R object "DT". Which of the following is the fastest way
#              to calculate the average value of the variable "pwgtp15"?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
# Windows
download.file(fileUrl, destfile = "./data/ac_survey2.csv")
# OS X
download.file(fileUrl, destfile = "./data/ac_survey2.csv", method = "curl")

list.files("./data")

DT <- fread("./data/ac_survey2.csv")
head(DT)

# 1) rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]) # Not this one

# 2) tapply(DT$pwgtp15,DT$SEX,mean)
system.time(replicate(10000, tapply(DT$pwgtp15,DT$SEX,mean)))
#user  system elapsed 
#13.30    0.00   13.41

# 3) mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
system.time(replicate(10000, mean(DT[DT$SEX==1,]$pwgtp15)))
[1] 99.80667
[1] 96.66534
#user  system elapsed 
#13.85    0.06   14.56 

# 4) mean(DT$pwgtp15,by=DT$SEX)
# Not this one

# 5) sapply(split(DT$pwgtp15,DT$SEX),mean)
system.time(replicate(10000, sapply(split(DT$pwgtp15,DT$SEX),mean)))
# user  system elapsed 
# 8.12    0.03    8.30

# 6) DT[,mean(pwgtp15),by=SEX]
system.time(replicate(10000, DT[,mean(pwgtp15),by=SEX]))
#user  system elapsed 
#12.20    0.00   12.39


# Answer number 5)


