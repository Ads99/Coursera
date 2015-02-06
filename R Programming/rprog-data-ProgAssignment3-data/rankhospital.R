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