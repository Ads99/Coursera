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
## More underlying functions about ggplot (prev lecture was about 'qplot')
## Plots are built up in layers (unlike Lattice)

qplot(displ, hwy, data = mpg, facets = .~drv, geom = c("point", "smooth"), method = "lm")

## Recreated using ggplot framework
g <- ggplot(mpg, aes(displ, hwy)) 
summary(g)

print(g) # there is no plot yet!
p <- g + geom_point()
print(p) # A plot appears
# Alternatively you can auto-print without saving to an object
g + geom_point()

## Lecture 6 -- ggplot2 (part 4)
## Adding More Layers: Smooth
g + geom_point() + geom_smooth() # or
g + geom_point() + geom_smooth(method = "lm") # Linear model

## Adding More Layers: Facets
g + geom_point() + facet_grid(.~drv) + geom_smooth(method = "lm") # Linear model

## Modifying Aesthetics
g + geom_point(color = "steelblue", size = 4, alpha = 1/2) # colour is assigned a constant
g + geom_point(aes(color = drv), size = 4, alpha = 1/2)    # colour is assigned a different colour for each variable

## Modifying Labels
g + geom_point(aes(color = drv), size = 4, alpha = 1/2) + labs(titlew = "Analysis of Displacement vs Hwy by Drive Type") +
    labs(x = expression("log " * PM[2.5]), y = "Hwy") # this is a way to get a small "2.5"

## Customising the Smooth
g + geom_point(aes(color = drv), size = 4, alpha = 1/2) +
    labs(titlew = "Analysis of Displacement vs Hwy by Drive Type") +
    labs(x = expression("log " * PM[2.5]), y = "Hwy") +
    geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE) # se = FALSE - turns off confidence interval

## Changing the Theme
g + geom_point(aes(color = drv)) + theme_bw(base_family = "Times") # theme has changed as well as font ("Times")

## Lecture 7 -- ggplot2 (part 5)
## A Note about Axis Limits

testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50, 2] <- 100 ## Outlier
plot(testdat$x, testdat$y, type = "l", ylim = c(-3, 3)) ## Looks fine, the axes scale to fit excluding outlier

g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line()                                         ## Not so fine, all points are shown

## 2 options
g + geom_line() + ylim(-3, 3)                           ## ggplot subsets the data and the outlier appears to not exist
g + geom_line() + coord_cartesian(ylim = c(-3,3))       ## now this is valid

## More complex example
## As a continuous variable changes, how does the relationship change?
## Need to use the cut() function to categorise the variable

## This is for illustration only - it doesn't really make sense to categorise this
## specific variable, however the idea is to show it is possible

## Calculate the quartiles of the data
cutpoints <- quantile(mpg$cty, seq(0, 1, 0.25), na.rm = TRUE)
## Cut the data at the quartiles and create a new factor variable
str(mpg)
mpg$cty_new <- cut(mpg$cty, cutpoints)
## See the levels of the newly created factor variable
levels(mpg$cty_new)

## Code for Final Plot
## Set up ggplot with data frame
g <- ggplot(mpg, aes(displ, hwy))

## Add layers
g + geom_point(alpha = 1/3) +
    facet_wrap(drv ~ cty_new) +
    geom_smooth(method = "lm", se=FALSE, col="steelblue") +
    theme_bw(base_family = "Avenir", base_size = 10) + 
    labs(x = "displacement") +
    labs(y = "hwy") +
    labs(title = "My fancy graph")