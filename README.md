getdata-project: README
===============

### Summary of assignment

Quoting, nearly directly, this is the assignment --

> You should create one R script called run_analysis.R that does the following. 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names. 
> 5. From the data set in step 4, creates a second, independent tidy data set with the average 
>    of each variable for each activity and each subject.

The plan I set out with initiall before coding was -
 1. Get the data in a frame
  - Grab subject ID
  - Column bind the activity
  - Column bind mean() and std() data
 2. Tidy the data
  - Add colNames
  - Add Activity factor names

### Assumptions
 - You have downloaded the UCI HAR dataset and have it uncompressed in a subdirectory `data` from your working directory. The full path is `data/UCI HAR Dataset/`.
 - The output file and location for run_analysis is in the `data` subdirectory. The full output dataset will be written into `data/HCI-HAR-analysis.txt`.
 
### Libraries used
You need to load the `plyr` library before `run_analysis()` will operate correctly. `library(plyr)`

### Function details
In order of importance.

| Function | Usage | Description/Purpose |
|------------:|:-----------|:-----------|
| run_analysis()   | No arguments, returns a tidy data object.    | This is where you start. It is the Primary driver, works with the two datasets test and train, merges them in a tidy way, then performs a summary analysis with tidy data producing the average of each variable for each activity and each subject.       |
| write_analysis(data) | Argument - `data frame`. | Function to assist at writing output to a text file, just pass in the data, writes file to `data/UCI-HAR-analysis.txt`, using tab seporators for easier reading. | 
| load_set(target) | Argument `name` where name is either 'test' or 'train'. Returns a dataframe. | # Pass a directory name and return a dataframe with the desired imported dataset, clean and tidy for use. |
| merge_data() | No arguments. Returns merged data set. | # Merge data both sets of data `test` `train`, returning the clean tidy data frame. |
| data_grep() | No arguments, returns a dataframe | # Builds an index for mean() and std() related variables from `features.txt`. Used `grep()` in R to create the index I need. Pretty awesome.  |
 # Build an index for mean() and std() related variables in features.txt
| prep()         | No arguments    | Attempts to download the zip data file, uncompresses using `unz()` into a `data` subdirectory in your current working directory. Assumes you have a working internet connection. |

### Data set summary

Please see `CodeBook.md`
