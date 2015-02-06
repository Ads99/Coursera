# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//R Programming//rprog-data-ProgAssignment3-data')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/R Programming/rprog-data-ProgAssignment3-data')

list.files()
# list.files("./data/rprog-data-specdata/specdata/", full.names=TRUE)

# Part 1 - Plot the 30-day mortality rates for heart attack

outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)
str(outcome)
ncol(outcome) # 46 columns
nrow(outcome) # 4706 rows
names(outcome)

# Make a simple histogram of the 30-day death rates from heart attack
outcome[, 11] <- as.numeric(outcome[, 11]) # Because we originally read the data in as character (colClasses = "character")
hist(outcome[, 11])

# Part 2 - Finding the best hospital in a state
# Write a function called best that take two arguments: the 2-character abbreviated name of a state and an outcome name.
# The function reads the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital
# that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state. The hospital name is the
# name provided in the Hospital.Name variable. The outcomes can be one of: "heart attack", "heart failure", or "pneumonia".
# Hospitals that do not have data on a particular outcome should be excluded from the set of hospitals when deciding the rankings.

best <- function(state, outcome) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with lowest 30-day death
    
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.string = c("Not Available"))
    dat.state <- subset(dat, State == state, select = c(2, 7, 11, 17, 23))
    #dat.state <- subset(dat, State == "BB", select = c(2, 7, 11, 17, 23))
    
    if(nrow(dat.state) == 0) stop("invalid state")
    
    # Now we want to know which field to sort by depending on what was entered
    # in the outcome field
    colID <- numeric()
    if (outcome == "heart attack") {
        colID = 3
    } else if (outcome == "heart failure") {
        colID = 4
    } else if (outcome == "pneumonia") {
        colID = 5
    } else {
        stop("invalid outcome")
    }

    sorted.dat.state <- dat.state[order(as.numeric(dat.state[,colID]), dat.state[,1]),]
    sorted.dat.state[1,1]
}

best("TX", "heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")
best("BB", "heart attack")
best("NY", "hert attack")


# Part 3 - Ranking hospitals by outcome in a state
# Write a function called rankhospital that takes three arguments: the 2-character abbreviated name of a
# state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
# The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
# of the hospital that has the ranking specified by the num argument

rankhospital <- function(state, outcome, num = "best") {
    # Read outcome data    
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.string = c("Not Available"))
    dat.state <- subset(dat, State == state, select = c(2, 7, 11, 17, 23))
    #dat.state <- subset(dat, State == "TX", select = c(2, 7, 11, 17, 23))
    
    # Check that state and outcome are valid
    if(nrow(dat.state) == 0) stop("invalid state")
    
    colID <- numeric()
    if (outcome == "heart attack") {
        colID = 3
    } else if (outcome == "heart failure") {
        colID = 4
    } else if (outcome == "pneumonia") {
        colID = 5
    } else {
        stop("invalid outcome")
    }
    
    # Return hospital name in that state with the given rank
    # 30-day death rate
    sorted.dat.state <- dat.state[order(as.numeric(dat.state[,colID]), dat.state[,1]),]
    sorted.dat.state.noNAs <- sorted.dat.state[!(is.na(sorted.dat.state[,colID])),]
    
    x <- character()
    if(num == "best") {
        x <- sorted.dat.state.noNAs[1,1]
    }
    if(num == "worst") {
        x <- sorted.dat.state.noNAs[nrow(sorted.dat.state.noNAs),1]
    }
    else {
        x <- sorted.dat.state.noNAs[num,1]
    }
    
    x    
}

rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", "5000")


# Part 4 - Ranking hospitals in all states
# Write a function called rankall that takes two arguments: an outcome name (outcome) and a hospital ranking
# (num). The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame
# containing the hospital in each state that has the ranking specified in num. For example the function call
# rankall("heart attack", "best") would return a data frame containing the names of the hospitals that
# are the best in their respective states for 30-day heart attack death rates. The function should return a value
# for every state (some may be NA). The first column in the data frame is named hospital, which contains
# the hospital name, and the second column is named state, which contains the 2-character abbreviation for
# the state name. Hospitals that do not have data on a particular outcome should be excluded from the set of
# hospitals when deciding the rankings

rankall <- function(outcome, num = "best") {
    # Read outcome data    
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.string = c("Not Available"))
    dat <- subset(dat, select = c(2, 7, 11, 17, 23))
    
    # Check that outcome is valid
    colID <- numeric()
    if (outcome == "heart attack") {
        colID = 3
    } else if (outcome == "heart failure") {
        colID = 4
    } else if (outcome == "pneumonia") {
        colID = 5
    } else {
        stop("invalid outcome")
    }
    
    # Get a unique list of States from the data frame for use later
    states.list <- unique(dat$State)
    
    # Now reduce the data set to only the column we need based on outcome
    # and remove NAs
    dat.filtered <- dat[!is.na(dat[,colID]),c(1,2,colID)]
    # Change the column type of "Count" to be numeric
    dat.filtered[,3] <- as.numeric(dat.filtered[,3])    
    
    # Now we can move this into a data.table
    library(data.table)
    dat.table <- data.table(dat.filtered)
    # Renaming a column so we can access it easier
    setnames(dat.table, 1, "hospital")
    setnames(dat.table, 2, "state")
    setnames(dat.table, 3, "Count")
    
    # Now we can set a key and additional column called Rank based on the State
    setkey(dat.table, state, Count, hospital)
    dat.table[, Rank :=1:.N, by = state]
    dat.table[, RevRank :=.N:1, by = state]
    
    # Now define what "best" and "worst" mean in context of Rank
    x <- integer()
    if(num == "best") {
        setkey(dat.table, state, Rank)
        x <- 1
    }
    if(num == "worst") {
        setkey(dat.table, state, RevRank)
        x <- 1
    }
    else {
        setkey(dat.table, state, Rank)
        x <- num
    }
    
    dat.table[.(states.list, x), .(hospital, state)]
    
}

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure", 20), 10)

rankall("heart attack", 10)
rankall("heart failure", 10)
