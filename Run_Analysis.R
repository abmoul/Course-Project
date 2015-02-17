# This script downloads datasets from the location 
#"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# and returns two tidy datasets: tidy_dataset, containing means and standard deviations for each activity # and subject; and tidy_dataset2 containing the average of each feature for each activity and subject

Run_Analysis <- function(){

  if('reshape2' %in% installed.packages() == F){
    install.packages('reshape2')
}
library(reshape2)  
    
    #This function downloads the data to a temp file, and returns the handle.
    downloadData <- function(){
        Dest_File <- 'UCI HAR Dataset.zip'
        
        if(!file.exists('UCI HAR Dataset.zip')){
            #download the zip file. Tries default method first, then tries wget.
            tryCatch(
                download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile=Dest_File)
                , error = function(e){
                    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile=Dest_File, method='wget')
                }
            )
        }
        
        Dest_File
    } 
	# Load data from the zip file into data frames
	loadData <- function(file) {
	    x_train <- read.table(unz(file, 'UCI HAR Dataset/train/X_train.txt'))
        x_test <- read.table(unz(file, 'UCI HAR Dataset/test/X_test.txt'))
        
        y_train <- read.table(unz(file, 'UCI HAR Dataset/train/y_train.txt'))
        y_test <- read.table(unz(file, 'UCI HAR Dataset/test/y_test.txt'))
        
        subject_train <- read.table(unz(file, 'UCI HAR Dataset/train/subject_train.txt'))
        subject_test <- read.table(unz(file, 'UCI HAR Dataset/test/subject_test.txt'))
        
        features <- read.table(unz(file, "UCI HAR Dataset/features.txt"), header=F, colClasses="character")
        activities <- read.table(unz(file, "UCI HAR Dataset/activity_labels.txt"), header=F, colClasses="character")
		# Return a list of extracted datasets
		list(x_train = x_train, x_test = x_test, 
             y_train = y_train, y_test = y_test, 
             subject_train = subject_train, subject_test = subject_test,
             features = features,
             activities = activities)
		}
		
		# Merge the datasets
		mergeData <- function(l) {
        list(X = rbind(l$x_train, l$x_test), Y = rbind(l$y_train, l$y_test), S = rbind(l$subject_train, l$subject_test))
    }
	
	# Extract the mean and std features
	
	mean_std_features = function(X, features) {
        target_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
        X <- X[, target_features]
        names(X) <- features[target_features, 2]
        names(X) <- gsub("\\(|\\)", "", names(X))
        names(X) <- tolower(names(X))
        #return filtered frame
        X
    }
	
	# Replace the activities with their respective names
	
    activity_names <- function(x, activities){
        activities[, 2] <- gsub("_", "", tolower(activities[, 2]))
        x[,1] <- activities[x[,1], 2]
        names(x) <- "activity"
        x
    }
	
	# download the data
	f <- downloadData()
    d <- loadData(f)
	
	# Merge the data
	
	m <- mergeData(d)
    d <- d[-1:-6]
	
	# add the features and features names
	
	m$X <- mean_std_features(m$X, d$features)    
    m$Y <- activity_names(m$Y, d$activities)
	
	d <- NULL
	names(m$S) <- "subject"
	
	# Merge the columns to have the tidy_dataset
	
	tidy_dataset <- cbind(m$S, m$Y, m$X)
    #write out the csv file. 
    write.csv(tidy_dataset, "tidy_dataset.txt", row.names=F)
	
	# Create the second tidy_dataset2
	
	melted <- melt(tidy_dataset, 1:2)
    tidy_dataset2 <- dcast(melted, subject + activity ~ variable, mean)
    write.csv(tidy_dataset2, "tidy_dataset2.txt", row.names=F)
}
	
