# Windows
setwd('C://Users//ABaker//Documents//GitHub//Coursera//R Programming')
# OS X
setwd('/Users/adam_baker_1/GitHub/Coursera/R Programming')

if (!file.exists("data")) {
  dir.create("data")
}

list.files("./data")
list.files("./data/rprog-data-specdata/specdata/")
list.files("./data/rprog-data-specdata/specdata/", full.names=TRUE)

# Part 1
# Creation of a function "pollutantmean" which calculates the mean of a pollutant (sulfate or nitrate)
# across a specified list of monitors.

# old version
pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)

  # Set up an empty character vector to contain the file names
  # we wish to import
  file.names <- vector("character", length = 0)
  
  # Iterate over the 'id' integer vector and add the file names
  # to the previously empty character vector
  for(i in id) {
    if(i < 10) {
      file.names <- c(file.names, paste(directory, "00", as.character(i), ".csv", sep=""))
    }
    else {
      if(i < 100) {
        file.names <- c(file.names, paste(directory, "0", as.character(i), ".csv", sep=""))
      }
      else {
        file.names <- c(file.names, paste(directory, as.character(i), ".csv", sep=""))
      }
    }
  }
  
  # Now we need to iterate over the file names and import these
  # into a dataframe
  
  out.file <- data.frame()
  
  for(i in file.names) {
    file <- read.csv(i, header=TRUE, stringsAsFactors=FALSE)
    out.file <- rbind(out.file, file)
  }
  
  # Now we have all the data together we can calculate an average, excluding NAs
  mean(out.file[[pollutant]], na.rm=TRUE)
  
}

# new version
pollutantmean <- function(directory, pollutant, id = 1:332) {
  full.file.names <- list.files(directory, full.names=TRUE)
  file.names <- list.files(directory)
  
  dat <- data.frame()
  for (i in 1:length(file.names)) {
    dat <- rbind(dat, read.csv(full.file.names[i]))
  }
  
  of.interest <- dat[dat$ID %in% id, ]
  
  mean(of.interest[[pollutant]], na.rm=TRUE)
  
}

pollutantmean("./data/rprog-data-specdata/specdata/", "nitrate", 23:24)

# Part 2
# Creation of a function "complete" which reads a directory full of files and reports
# the number of completely observed cases in each data file.
# A data frame should be returned

complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  
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

complete("specdata", c(1,3,5))

# Part 3
# Creation of a function "corr" which reads a directory full of files and a threshold
# for complete cases and calculates the correlation between sulfate and nitrate for 
# monitor locations where the number of completely observed cases (on all variables)
# is greater than the threshold. The function should return a vector of correlations
# for the monitors that meet the threshold requirement. If no monitors meet the threshold
# requirement, then the function should return a numeric vector of length 0.

corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
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

corr("specdata", 150)

# Testing
cr <- corr("specdata", 150)
head(cr)
summary(cr)

cr <- corr("specdata", 400)
head(cr)
summary(cr)

cr <- corr("specdata", 5000)
summary(cr)
length(cr)

cr <- corr("specdata")
summary(cr)
length(cr)

