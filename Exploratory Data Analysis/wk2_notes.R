## Week 2 - Lecture Notes

## Lecture 1 - Lattice Plotting System (part 1)
library(lattice)
library(datasets)

## Simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)

## Slightly more complicated scatterplot
str(airquality)
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1))

## Lattice behaviour
p <- xyplot(Ozone ~ Wind, data = airquality) ## Nothing happens
print(p) # Only then will the plot appear
xyplot(Ozone ~ Wind, data = airquality) ## Auto-printing

## Lecture 2 - Lattice Plotting System (part 2)

# My dick around
"""
par(mfrow = c(3, 1))
set.seed(10)
hist(rnorm(100))
set.seed(10)
hist(rnorm(100, sd = 0.5))
set.seed(10)
hist(rnorm(100, sd = 1))
"""

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
# test <- rep(factor(c("Group 1", "Group 2")), each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2,1)) ## Plot with 2 panels

# Lattice panel functions
xyplot(y ~ x | f, panel = function(x, y, ...) {
    panel.xyplot(x, y, ...) ## First call the default panel function for 'xyplot'
    panel.abline(h = median(y), lty = 2) ## Add a horizontal line at the median
})

# Lattice panel functions: Regression line
xyplot(y ~ x | f, panel = function(x, y, ...) {
    panel.xyplot(x, y, ...) ## First call default panel function
    panel.lmline(x, y, col = 2) ## Overlay a simple linear regression line
})

## Lecture 4 -- ggplot2 (part 2)
library(ggplot2)
str(mpg)

## The "Hello World" plot
qplot(displ, hwy, data = mpg)

## Modifying aesthetics
qplot(displ, hwy, data = mpg, color = drv)

## Adding a geom
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))

## Histograms
qplot(hwy, data = mpg)
qplot(hwy, data = mpg, fill = drv) # fill with different colours based on drv variable

## Facets - these are like panels in Lattice
## The '~' indicates separation of variables with variables either side
## LHS indicates columns
## RHS indicates rows
## In this instance there is only one row
qplot(displ, hwy, data = mpg, facets = .~drv)

## This example shows three charts stacked column-wise, split by 'drv' variable
qplot(hwy, data = mpg, facets = drv~., binwidth = 2)

## More complicated plot, using linear regression for two variables
qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"), method = "lm")

## Alternatively we could split this out with facets
qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"), method = "lm", facets = .~drv)

## Lecture 5 -- ggplot2 (part 3)

