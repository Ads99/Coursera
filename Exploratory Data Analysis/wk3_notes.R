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

## K-means Clustering
## Useful for summarising high dimensional data

## Can we find things that are close together?

## How do we define close - we need a distance metric, e.g.
## - continuous (euclidean or correlation)
## - binary - manhattan distance
## Pick a distance/similarity that makes sense for your problem

set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

## Demonstrating kmeans()
## Important parameters: x, centers, iter.max, nstart

dataFrame <- data.frame(x, y)
kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
kmeansObj$cluster ## this tells you which points are associated with which cluster

## Plotting the results
par(mar = rep(0.2, 4))
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)

## Another way to visualise
set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1,2), mar = c(2, 4, 0.1, 0.1))
# an image of the original data
image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt = "n") 
# reorganised so clusters are together
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt = "n")
