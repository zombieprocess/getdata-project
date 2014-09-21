setwd("~/sandbox/getdata-project")

# Load any needed libraries
library(plyr)

## Assignment ##
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.


# container function preparing a new dataset extration
prep <- function() {
  # Create a data directory if it doesn't exist
  if (!file.exists("data")) {
    dir.create("data")
  }

  # If the file is not downloaded, grab it, and unzip it
  if(!file.exists("./data/UCI HAR Dataset")) {
    tempFile <-tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = tempFile, method = "curl")
    dateDownloaded <- date()
    unz(tempFile,"./data/UCI HAR Dataset")
    unlink(tempFile)
    #list.files("./data")
  }
}

# Primary driver, works with the two datasets test and train, merges them in a tidy way, 
# then performs a summary analysis with tidy data producing the average of each variable 
# for each activity and each subject.
run_analysis <- function() {
  
  # Generate a merged data frame to work with
  dataSet <- merge_data()
 
  # Use ddply() to summarize the average(mean) data across each Subject, broken down by activity.
  dataTest <- ddply(dataSet,.variables=c("subjectID","activity"),.fun=numcolwise(mean))
  
  # Return the analysis data set
  dataSet
}

# Function to assist at writing output to a text file, just pass in the data
write_analysis <- function(data) {
  
  # Create a data directory if it doesn't exist
  if (!file.exists("data")) {
    dir.create("data")
  }
  
  # Write data set as a txt file created with write.table() using row.name=FALSE, w/ tab seporators
  write.table(data,file="data/UCI-HAR-analysis.txt",sep="\t",row.name=FALSE)
}

# Merge data both sets of data. [test&train]
merge_data <- function() {
  # Seems a bit easy, and probably not worth creating a function, but here it is anyway.
  rbind(load_set("test"),load_set("train"))
}

# Pass a directory and return a dataframe with the desired information
load_set <- function(target) {
  ## Assumptions ##
  #PATH: data/UCI HAR Dataset
  #PATTERN: test | train
  #FILES: X_test.txt, subject_test.txt, y_test.txt
  
  # target: “test” or “train”
  if(!(target == "test" |
       target == "train")) {
    stop("invalid target")
  }
  
  dataPath <- paste("data/UCI HAR Dataset/",target,sep="")
  
  ## Start construction of our data frame
  data <- NULL
  
  ## Read subject ID
  data <- read.table(paste(dataPath,"/subject_",target,".txt",sep=""),col.name="subjectID")
    
  ## Read y_<target>.txt, describing the activity as a factor
  data <- cbind(data, read.table(paste(dataPath,"/y_",target,".txt",sep=""),colClasses="factor",col.name="activity"))
    
  # Load the features names and indexes we care about - mean() and std()
  # Cleanup, could make this a cached data, so it only reads once, for all sets
  dataFeatures <- data_grep()
  
  ## Read X_<target.txt, only keeping the data we care about - mean() & std()
  #  Taking advantage of colClasses feature in read.table to create a filter for what columns to skip.
  dataFeaturesFilter <- rep("NULL",561)
  dataFeaturesFilter[unlist(dataFeatures[1],use.names=FALSE)] <- "numeric"
  data <- cbind(data, read.table(paste(dataPath,"/X_",target,".txt",sep=""), colClasses = dataFeaturesFilter))
  
  ## Tidy the data on the way out ##
  
  # Make nice column names for the remaining data
  colnames(data)[3:68] <- as.character(unlist(dataFeatures[2],use.names=FALSE))

  # Add labels to the activity factor column
  data$activity <- factor(data$activity, 
                          levels = c(1,2,3,4,5,6), 
                          labels = c("WALKING", 
                                    "WALKING_UPSTAIRS",
                                    "WALKING_DOWNSTAIRS",
                                    "SITTING",
                                    "STANDING",
                                    "LAYING"))
  
  # Return our nice formatted dataframe for this set
  data
}


# Build an index for mean() and std() related variables in features.txt
data_grep <- function() {
  
  # Use grep 'mean()\|std()' features.txt 
  # Got 66 items to work with, which is much less than the original 561 variables
  # In R it is - grep("mean\\(\\)|std\\(\\)",xDataFeatures$feature)
  # Subset of what I care about - xDataFeatures[grep("mean\\(\\)|std\\(\\)",xDataFeatures$feature),]
  # Tidy step - purge what I don't care about - xDataFeatures <- xDataFeatures[grep("mean\\(\\)|std\\(\\)",xDataFeatures$feature),]
  
  data <- read.table("data/UCI HAR Dataset/features.txt",col.name=c("index","feature"))
  data <- data[grep("mean\\(\\)|std\\(\\)",data$feature),]
  
  # Return a subset list of features we want to look at, and their indexes
  data
}