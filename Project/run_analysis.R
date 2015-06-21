#load and prepare data
  ##IF NECESSARY ./DATA FILE DOES NOT EXIST THEN CREATE IT
  if(!file.exists("./data")){dir.create("./data")}
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./data/Dataset.zip",method="auto")
  unzip(zipfile="./data/Dataset.zip",exdir="./data")
  unlink("./data/Dataset.zip")

#Step 1 Merges the training and the test sets to create one data set.
#Read Data
  trainData <-read.table("./data/UCI HAR Dataset/train/X_train.txt")
  trainLabel <-read.table("./data/UCI HAR Dataset/train/y_train.txt")
  trainSubject <-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
  
  testData <-read.table("./data/UCI HAR Dataset/test/X_test.txt")
  testLabel <-read.table("./data/UCI HAR Dataset/test/y_test.txt")
  testSubject <-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Join Data
  Data <- rbind(trainData, testData)
  Label <- rbind(trainLabel, testLabel)
  Subject <- rbind(trainSubject, testSubject)

#Step 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
  features <- read.table("./data/UCI HAR Dataset/features.txt")
  stdMeanIndex <- grep("mean\\(\\)|std\\(\\)", features[, 2])
  Data <-Data[, stdMeanIndex]
#Step 3 Uses descriptive activity names to name the activities in the data set
  activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
  Label[, 1] <- activity[Label[, 1], 2]
  names(Label) <- "activity"
#Step 4 Appropriately labels the data set with descriptive variable names. 
  names(Data)<-features[stdMeanIndex,2]
  names(Subject) <- "subject"
  cleanedData <- cbind(Subject, Label, Data)
  write.table(cleanedData, "merged_data.txt") 
#Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  aggregatedData <- aggregate(cleanedData[,3:ncol(cleanedData)],by=list(subject = cleanedData$subject, activity = cleanedData$activity),mean)
  write.table(aggregatedData, row.name=FALSE, "aggregated_data.txt") 