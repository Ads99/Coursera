# A quick primer on split-apply-combine problems

# The canonical form of the "right" data format in R is a data.frame, with
# each column containing the values to calculate a statistic for and another
# column containing the group to which that value belongs. A good example is
# the InsectSprays data set in R

head(InsectSprays)

"
  count spray
1    10     A
2     7     A
3    20     A
4    14     A
5    14     A
6    12     A
"

# These problems are widely known as split-apply-combine problems after the three
# steps involved in their solution. Let's go through it step by step.

# First, we split the count column by the spray column.

count_by_spray <- with(InsectSprays, split(count, spray))

"
$A
 [1] 10  7 20 14 14 12 10 23 17 20 14 13

$B
 [1] 11 17 21 11 16 14 17 17 19 21  7 13

$C
 [1] 0 1 7 2 3 1 2 1 3 0 1 4

$D
 [1]  3  5 12  6  4  3  5  5  5  5  2  4

$E
 [1] 3 5 3 5 3 6 1 1 3 2 6 4

$F
 [1] 11  9 15 22 15 16 13 10 26 26 24 13
"

# Secondly, we apply the statistic to each element of the list. Lets use the mean here.

mean_by_spray <- lapply(count_by_spray, mean)

"
$A
[1] 14.5

$B
[1] 15.33333

$C
[1] 2.083333

$D
[1] 4.916667

$E
[1] 3.5

$F
[1] 16.66667
"

# Finally, (if possible) we recombine the list as a vector.

unlist(mean_by_spray)

"
A         B         C         D         E         F 
14.500000 15.333333  2.083333  4.916667  3.500000 16.666667 
"

# This procedure is such a common thing that there are many functions to speed up
# the process. sapply and vapply do the last two steps together.

sapply(count_by_spray, mean)

"
        A         B         C         D         E         F 
14.500000 15.333333  2.083333  4.916667  3.500000 16.666667
"

vapply(count_by_spray, mean, numeric(1))

"
        A         B         C         D         E         F 
14.500000 15.333333  2.083333  4.916667  3.500000 16.666667 
"

# We can do even better than that however. tapply, aggregate and by all
# provide a one-function solution to these S-A-C problems.
with(InsectSprays, tapply(count, spray, mean))
with(InsectSprays, by(count, spray, mean))
aggregate(count ~ spray, InsectSprays, mean)

# The plyr package also provides several solutions with a choice of output
# format.
# ddply takes a data frame and returns another data frame, which is what you'll want most of the time.
# dlply takes a data frame and returns the uncombined list, which is useful if you want to do another processing step before combining

library(plyr)

ddply(InsectSprays, .(spray), summarise, mean.count = mean(count))
dlply(InsectSprays, .(spray), summarise, mean.count = mean(count))

class(ddply(InsectSprays, .(spray), summarise, mean.count = mean(count))) # data.frame
class(dlply(InsectSprays, .(spray), summarise, mean.count = mean(count))) # list

# One tiny variation on the problem is when you want the output statistic vector to have the same
# length as the original input vectors. For this, there is the ave function (which provides mean 
# as the default function).

with(InsectSprays, ave(count, spray))
