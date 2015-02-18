## Week 3 - Lecture Notes

## Hierarchical clustering - example
set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

## Hierarchical clustering - dist
dataFrame <- data.frame(x = x, y = x)
dist(dataFrame) # Calculates all pairwise distances - defaults to Euclidean distance

## Hierarchical clustering - hclust
distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
par(mar = c(5, 5, 5, 5))
plot(hClustering)

## Prettier dendrograms
setwd("C:/Users/ABaker/Documents/GitHub/Coursera/Exploratory Data Analysis")
source("myplclust.R")
myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))

## Heatmap function - good for visualising matrix data
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
heatmap(dataMatrix)