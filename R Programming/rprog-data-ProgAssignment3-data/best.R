best <- function(state, outcome) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with lowest 30-day death
    
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.string = c("Not Available"))
    dat.state <- subset(dat, State == state, select = c(2, 7, 11, 17, 23))
    
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