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