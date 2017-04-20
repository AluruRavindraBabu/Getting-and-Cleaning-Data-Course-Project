setwd("D:/coursera/cleaning Data/week4")
fname <- "FUCIHARDataset.zip"

### verify whether the file exists in the working directory or not.

if(!file.exists(fname)){
  furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  ## File url (Copied from assignemnt)
  download.file(url = furl, destfile = fname, method = "curl")
}

if(!file.exists("UCI HAR Dataset")){
  unzip(zipfile = fname)
}

# Load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

featuresrequired <- grep(".*mean.*|.*std.*", features[,2])
featuresrequired.names <- features[featuresrequired,2]
featuresrequired.names = gsub('-mean', 'Mean', featuresrequired.names)
featuresrequired.names = gsub('-std', 'Std', featuresrequired.names)
featuresrequired.names <- gsub('[-()]', '', featuresrequired.names)


## Loading the data: 

## Train data set

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresrequired]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

## Test data set

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresrequired]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)



# 1. Merges the training and the test sets to create one data set.
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresrequired.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)



write.table(allData.mean, "tidydataset.txt", row.names = FALSE, quote = FALSE)



















