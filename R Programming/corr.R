corr <- function(directory, threshold = 0) {
  # First we use the existing "complete" function to get a data.frame of all the
  # files and their complete cases
  file.comp.cases <- complete(directory)
  
  # Now loop through each file in the data frame to get a list of the files
  # which have complete cases > threshold
  id_list <- file.comp.cases[which(file.comp.cases$nobs >= threshold), 1]
  
  # Create an empty vector to store the values of the cor function for each 
  # valid file
  cor.values <- vector("numeric", length = 0)
  for(i in id_list) {
    
    # Open each file
    if(i < 10) {
      file.val <- read.csv(paste(directory, "/00", as.character(i), ".csv", sep=""))
      comp.file.val <- file.val[complete.cases(file.val),]
      cor.values <- c(cor.values, cor(comp.file.val$sulfate, comp.file.val$nitrate))
    }
    else {
      if(i < 100) {
        file.val <- read.csv(paste(directory, "/0", as.character(i), ".csv", sep=""))
        comp.file.val <- file.val[complete.cases(file.val),]
        cor.values <- c(cor.values, cor(comp.file.val$sulfate, comp.file.val$nitrate))
      }
      else {
        file.val <- read.csv(paste(directory, "/", as.character(i), ".csv", sep=""))
        comp.file.val <-file.val[complete.cases(file.val),]
        cor.values <- c(cor.values, cor(comp.file.val$sulfate, comp.file.val$nitrate))
      }
    }
  }
  
  cor.values
}