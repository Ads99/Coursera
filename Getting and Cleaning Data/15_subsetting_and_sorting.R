# Subsetting and Sorting

# Remove everything from the workspace
rm(list = ls())

# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X

# Subsetting
X[,1] # Selects all rows, only the first column
X[,"var1"] # As above
X[1:2,"var2"] # Selects the first two rows and the second column only

# Logicals ands and ors
X[X$var1 <= 3 & X$var3 > 11,] # Only pick rows where var1 <= 3 AND var3 > 11
X[X$var1 <= 3 | X$var3 > 15,] # Only rows where var1 <= 3 OR var3 > 15

X[which(X$var2 > 8),]
X[X$var2 > 8,]
X
?which

# Sorting
sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE)

# Ordering the data frame by varianble
X[order(X$var1,X$var3),]

# Ordering with dplyr
library(dplyr)
arrange(X,var1)
arrange(X,desc(var1))

# Adding rows and columns
X$var4 <- rnorm(5) # The 5 value has to be the number of rows in the data set
X$varAB <- rnorm(nrow(X)) # This could work equally well

# Another way to do this is to use cbind (column bind)
Y <- cbind(X,rnorm(5))
Z <- cbind(rnorm(5),Y)

