# Getting and Cleaning Data - Course Assignment

# You should create one R script called run_analysis.R that does the following:
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement.
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names.
# - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Remove everything from the workspace
rm(list = ls())

# Windows
#setwd('C://Users//ABaker//Documents//GitHub//Coursera//Getting and Cleaning Data//assignment')
# OS X
#setwd('/Users/adam_baker_1/GitHub/Coursera/Getting and Cleaning Data/assignment')

# download the file
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./UCI HAR Dataset.zip")) {download.file(Url, destfile = "./UCI HAR Dataset.zip")}
# unzip file
unzip("./UCI HAR Dataset.zip",exdir = ".")

# Read in the "features.txt" file which contains column headers for each of the test_X and train_X data sets
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, col.names=c("Feature.ID", "Feature.Name"))
str(features)
head(features)

# Now we can read in all the data. For the large files we use col.names parameter to bring in
# the column names we imported above

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject_id'), header = FALSE)
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$Feature.Name, header = FALSE)
test_y = read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity_id'), header = FALSE)
train_subject = read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject_id'), header = FALSE)
train_X = read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$Feature.Name, header = FALSE)
train_y = read.table("./UCI HAR Dataset/train/y_train.txt",  col.names = c('activity_id'), header = FALSE)

str(test_subject)
summary(test_subject)
str(train_subject)
summary(train_subject)
table(test_subject)
table(train_subject)
str(test_y)
summary(test_y)
str(train_y)
summary(train_y)
str(test_X)
str(train_X)

# Identifies the number of rows in each data set
nrow(test_subject)    # 2947
nrow(test_X)          # 2947
nrow(test_y)          # 2947
nrow(train_subject)   # 7351
nrow(train_X)         # 7351
nrow(train_y)         # 7351

names(test_subject)
names(test_X)
names(test_y)

# Now I need to extract the columns relating to mean and standard deviation
# Create a vector with the column names for mean() and stddev() columns only
desired_col_names <- grep(".*mean\\(\\)|.*std\\(\\)", features$Feature.Name)
str(desired_col_names) # 66 columns

# Now we can restrict the '_X' data sets to only those columns we require
test_X <- test_X[, desired_col_names]
train_X <- train_X[, desired_col_names]
head(test_X)

# Now combining the subjects and labels data sets with the main observational data:
# 2947 test observations
# 7352 train_observations
test_X <- cbind(data_type = c('test'), test_subject, test_y, test_X)
train_X <- cbind(data_type = c('train'), train_subject, train_y, train_X)
nrow(test_X)    # 2947
nrow(train_X)   # 7352

# Now I need to append one data set to the other. I merge both training
# and test data sets to create one data set
X.data <- rbind(test_X, train_X)
names(X.data)
head(X.data)
nrow(X.data)    # 10299

# Now remove the data_type field
X.data <- X.data[,2:ncol(X.data)]
head(X.data)

# Now I need to provide descriptive activity names for the activity_id column
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c('activity_id', 'activity_label'), header = FALSE)
activity.labels
# factor
activity.labels$activity_label <- as.factor(activity.labels$activity_label)

# 4. Appropriately labels the data set with descriptive activity names: 
# WALKING; WALKING_UPSTAIRS; WALKING_DOWNSTAIRS; SITTING; STANDING; LAYING            
X.data$activity_id <- factor(X.data$activity_id, levels = 1:6, labels = activity.labels$activity_label)
head(X.data)
names(X.data)

# Transform all the column name to readable name. Shorten the variable name for
# easier reading; appropriately labels the data set with readable name
column.names <- colnames(X.data)
# Get rid of the .
column.names <- gsub("\\.+mean\\.+", column.names, replacement="Mean")
column.names <- gsub("\\.+std\\.+", column.names, replacement="Std")
# Give short name a full explaination
column.names <- gsub("Mag", column.names, replacement="Magnitude")
column.names <- gsub("Acc", column.names, replacement="Accelerometer")
column.names <- gsub("Gyro", column.names, replacement="Gyroscope")
column.names
# Put back to X. file
colnames(X.data) <- column.names

# 5. Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject
library(reshape2)

#head(X.data)

meltdata <- melt(X.data, id.vars = c("activity_id", "subject_id"))
tidydata <- dcast(meltdata, activity_id + subject_id ~ variable, mean)

# Get 180 (=30*6) observations of 30 subjects' 6 activities.
# Each subject has 6 activities. Each activity has 66 features.
head(tidydata)
nrow(tidydata)
table(tidydata$Subject.ID)
# 5.1 Save tidy data set
write.table(tidydata, "tidydata.txt", row.names = FALSE)

# To read the data back in use the function
import.tidydata <- read.table("tidydata.txt", header = TRUE)
head(import.tidydata)