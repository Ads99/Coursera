# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C:/Users/ABaker/Documents/GitHub/Coursera/Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

# Question 1 - The American Community Survey distributes downloadable data about
# United States communities. Load the data in a data frame. Create a logical
# vector that identifies the households on greater than 10 acres who sold more
# than $10,000 worth of agriculture products. Assign that logical vector to the
# variable agricultureLogical. Apply the which() function like this to identify 
# the rows of the data frame where the logical vector is TRUE.
# which(agricultureLogical) What are the first 3 values that result?

# download the file
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
if(!file.exists("./data/acs_wk3.csv")) {download.file(Url, destfile = "./data/acs_wk3.csv")}

# Read in the "acs_wk3" file
acs <- read.csv("./data/acs_wk3.csv")
str(acs)
head(acs)

table(acs$ACR)
table(acs$AGS)

agricultureLogical <- acs$ACR == 3 & acs$AGS == 6
which(agricultureLogical) # First three values = 125, 238, 262


# Question 2 - Using the jpeg package read in the following picture of your
# instructor into R. Use the parameter native=TRUE. What are the 30th and 80th
# quantiles of the resulting data?

library(jpeg)

url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
if(!file.exists("./data/q2_wk3.jpg")) {download.file(url2, destfile = "./data/q2_wk3.jpg", mode="wb")}

img <- readJPEG("./data/q2_wk3.jpg", native = TRUE)
head(img)
str(img)

quantile(img, c(0.3, 0.8))
#30%       80% 
#-15259150 -10575416

# Question 3
#   - Load the Gross Domestic Product data for the 190 ranked countries
#   - Load the educational data.
#   - Match the data based on the country shortcode. How many of the IDs match?
#   - Sort the data frame in descending order by GDP rank (so United States is last).
#   - What is the 13th country in the resulting data frame?

url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

if(!file.exists("./data/wk3_GDP.csv")) {download.file(url3, destfile = "./data/wk3_GDP.csv")}
if(!file.exists("./data/wk3_Country.csv")) {download.file(url4, destfile = "./data/wk3_Country.csv")}

gdp <- read.csv("./data/wk3_GDP.csv", header = FALSE, skip = 5,
                col.names = c("Country.Code", "Rank", "V1", "Country.Name",
                              "GDP", "V2", "V3", "V4", "V5", "V6"))

gdp
table(gdp$Rank)
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))


head(gdp)
tail(gdp)
str(gdp)
summary(gdp)
# Get the columns we require from the messy data
gdp <- gdp[1:190,c(1,2,4,5)]
# Convert numerical values to numbeical data types
gdp[,gdp$Rank] = as.numeric(gdp$Rank)

country <- read.csv("./data/wk3_Country.csv")
head(country)

mergedData = merge(gdp, country, by.x="Country.Code", by.y="CountryCode")
head(mergedData)
nrow(mergedData) # 189

head(mergedData[with(mergedData, order(Rank)), ])
