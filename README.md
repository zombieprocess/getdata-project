getdata-project: README
===============

### Introduction

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject. (maybe HDF5?)

### The plan -
# 1.) Get the data in a frame
#  - Grab subject ID
#  - Column bind the activity
#  - Column bind mean() and std() data
# 2.) Tidy the data
#  - Add colNames
#  - Add Activity factor names

