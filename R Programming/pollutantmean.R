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