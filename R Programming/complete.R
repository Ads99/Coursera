complete <- function(directory, id = 1:332) {
  # Set up an empty character vector to contain the file names
  # we wish to import
  file.names <- vector("character", length = 0)
  
  # Iterate over the 'id' integer vector and add the file names
  # to the previously empty character vector
  for(i in id) {
    if(i < 10) {
      file.names <- c(file.names, paste(directory, "/00", as.character(i), ".csv", sep=""))
    }
    else {
      if(i < 100) {
        file.names <- c(file.names, paste(directory, "/0", as.character(i), ".csv", sep=""))
      }
      else {
        file.names <- c(file.names, paste(directory, "/", as.character(i), ".csv", sep=""))
      }
    }
  }
  
  dat <- data.frame(id = integer(0), nobs = integer(0))
  for (i in 1:length(file.names)) {
    file <- read.csv(file.names[i])
    temp_dat <- data.frame(id = id[i], nobs = nrow(file[complete.cases(file),]))
    dat <- rbind(dat, temp_dat)
  }
  
  dat
  
}