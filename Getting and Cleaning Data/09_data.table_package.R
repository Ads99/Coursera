setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data')

if (!file.exists("data")) {
  dir.create("data")
}

library(data.table)
DF = data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)
#           x y          z
# 1 2.4585350 a  0.4706585
# 2 0.8895277 a -1.3256243
# 3 0.9521663 a  0.5716154

DT = data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)
#             x y           z
# 1:  0.5063465 a -0.43832062
# 2:  0.1840228 a -0.09899511
# 3: -0.5055259 a  0.89008851

# See all the data tables in memory
tables()

# Subsetting rows
DT[2,] # Just show row 2

DT[DT$y=="a",] # Just show rows where y=="a"

DT[c(2,3)] # Just show rows 2 and 3
DT[c(2,1)] # Just show rows 2 and 1

# Subsetting columns?! This doesn't work
DT[,c(2,3)]

# The subsetting function is modified for data.table
# The argument you pass after the comma is called an "expression"
# In R an expression is a collection of statements enclosed in curley brackets

{
  x = 1
  y = 2
}
k = {print(10); 5}

print(k)

# Calculating values for variables with expressions
DT[,list(mean(x),sum(z))]

DT[,table(y)]

# Adding new columns
DT[,w:=z^2]

DT2 <- DT
DT[, y:= 2] # DT2 has changed as well

# Multiple operations
DT[,m:= {tmp <- (x+z); log2(tmp+5)}]

# plyr like operations
DT[,a:=x>0]
DT[,b:= mean(x+w),by=a]

# Special variables
# .N An integer, length 1, containing the numbe r

set.seed(123);
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x]

# Keys
DT <- data.table(x=rep(c("a","b","c"),each=100), y=rnorm(300))
setkey(DT, x)
DT['a']

# Joins
DT1 <- data.table(x=c('a', 'a', 'b', 'dt1'), y=1:4)
DT2 <- data.table(x=c('a', 'b', 'dt2'), z=5:7)
setkey(DT1, x); setkey(DT2, x)
merge(DT1, DT2)

# Fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))
# user  system elapsed 
# 1.61    0.02    1.63 

system.time(read.table(file, header=TRUE, sep="\t"))
# user  system elapsed 
# 10.64    0.09   10.79 