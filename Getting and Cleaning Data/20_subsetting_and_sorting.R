# Subsetting and Sorting

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C:/Users/ABaker/Documents/GitHub/Coursera/Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

set.seed(13435)
X <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
# scramble the variables
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA
X

# Subsetting - quick revew
X[,1]                           # Only the first column
X[,"var1"]                      # Only the column named "var1"
X[1:2, "var2"]                  # first two rows for second column

# Logical ands and ors
X[(X$var1 <= 3 & X$var3 > 11),] # return only rows were var1 <=3 AND var3 > 11
X[(X$var1 <= 3 | X$var3 > 15),] # return only rows were var1 <=3 OR var3 > 15

# Dealing with missing values - subsetting will not return rows
X[which(X$var2 > 8),]   # doesn't return the NAs
# compared to this
X[(X$var2 > 8),]        # returns the NAs

# Sorting
sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE)

# Ordering (a data frame)
X[order(X$var1),]
X[order(X$var1,X$var3),]

# Ordering with plyr
library(plyr)
arrange(X,var1)
arrange(X,desc(var1))

# Adding rows and columns
X$var4 <- rnorm(5)
X

Y <- cbind(X,rnorm(5))
Y
