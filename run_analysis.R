library(dplyr); library(plyr); library(reshape2)

##Load Feature List
FeatureList <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ", col.names = c("FeatureID","Feature"))

##Create a Data Frame with the 6 Activities and the associated Codes
ActivityList <- data.frame(ActivityCode = 1:6, ActivityLabel = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

##Import Test Data

  ##Import X_test.txt
  XTest <- read.fwf("./UCI HAR Dataset/test/X_test.txt", widths = as.vector(matrix(16,nrow=561)), header = FALSE, col.names = c(1:561))
  
  ##Assign Row Numbers to use for Join
  XTest$ID <- 1:nrow(XTest)
  
  ##Import y_test.txt
  YTest <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "ActivityCode")
  
  ##Assign Row Numbers to use for Join
  YTest$ID <- 1:nrow(YTest)
  
  ##Import subject_test.txt
  SubjectTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "SubjectCode")
  
  ##Assign Row Numbers to use for Join
  SubjectTest$ID <- 1:nrow(SubjectTest)
  
  ##Merge the Subject and Activity Files using ID
  TestData <- merge(SubjectTest, YTest, by.x = "ID", by.y = "ID")
  
  ##Add the x_test data joining on ID
  TestData <- merge(TestData, XTest, by.x = "ID", by.y = "ID")
  
  ##Convert the data points to rows so that one observation per row
  TestDataUnpivoted <- melt(TestData, id=c("ID","SubjectCode","ActivityCode"))
  
  ##Rename variable column to FeatureID
  names(TestDataUnpivoted)[names(TestDataUnpivoted) == "variable"] <- "FeatureID"
  
  ##Assign Activity Labels
  TestDataUnpivoted <- merge(TestDataUnpivoted, ActivityList, by.x = "ActivityCode", by.y = "ActivityCode")
  
  ##Assign Feature Labels
  ####Remove the X
  TestDataUnpivoted$FeatureID <- gsub("X","", TestDataUnpivoted$FeatureID)
  
  TestDataUnpivoted <- merge(TestDataUnpivoted, FeatureList, by.x = "FeatureID", by.y = "FeatureID")


##Import Train Data

  ##Import X_Train.txt
  XTrain <- read.fwf("./UCI HAR Dataset/Train/X_Train.txt", widths = as.vector(matrix(16,nrow=561)), header = FALSE, col.names = c(1:561))
  
  ##Assign Row Numbers to use for Join
  XTrain$ID <- 1:nrow(XTrain)
  
  ##Import y_Train.txt
  YTrain <- read.csv("./UCI HAR Dataset/Train/y_Train.txt", header = FALSE, col.names = "ActivityCode")
  
  ##Assign Row Numbers to use for Join
  YTrain$ID <- 1:nrow(YTrain)
  
  ##Import subject_Train.txt
  SubjectTrain <- read.csv("./UCI HAR Dataset/Train/subject_Train.txt", header = FALSE, col.names = "SubjectCode")
  
  ##Assign Row Numbers to use for Join
  SubjectTrain$ID <- 1:nrow(SubjectTrain)
  
  ##Merge the Subject and Activity Files using ID
  TrainData <- merge(SubjectTrain, YTrain, by.x = "ID", by.y = "ID")
  
  ##Add the x_Train data joining on ID
  TrainData <- merge(TrainData, XTrain, by.x = "ID", by.y = "ID")
  
  ##Convert the data points to rows so that one observation per row
  TrainDataUnpivoted <- melt(TrainData, id=c("ID","SubjectCode","ActivityCode"))
  
  ##Rename variable column to ReadingNo
  names(TrainDataUnpivoted)[names(TrainDataUnpivoted) == "variable"] <- "FeatureID"
  
  ##Assign Activity Labels
  TrainDataUnpivoted <- merge(TrainDataUnpivoted, ActivityList, by.x = "ActivityCode", by.y = "ActivityCode")
  
  ##Assign Feature Labels
  ####Remove the X
  TrainDataUnpivoted$FeatureID <- gsub("X","", TrainDataUnpivoted$FeatureID)
  
  TrainDataUnpivoted <- merge(TrainDataUnpivoted, FeatureList, by.x = "FeatureID", by.y = "FeatureID")

##Merge the two sets and filter by Features with either mean or Std in the name
  
  ##Merge Two Sets, applying filters on Feature
  MergedData <- rbind(filter(TrainDataUnpivoted, grepl("std(", Feature, fixed = TRUE)),filter(TrainDataUnpivoted, grepl("mean(", Feature, fixed = TRUE)),filter(TestDataUnpivoted, grepl("std(", Feature, fixed = TRUE)),filter(TestDataUnpivoted, grepl("mean(", Feature, fixed = TRUE)))
  
  ##Reorder Columns
  MergedData <- select(MergedData, SubjectCode, ActivityLabel, Feature, value)

##Create Avg for each variable, for each activity and each subject
  AvgData <- aggregate( value~SubjectCode+ActivityLabel+Feature, MergedData, mean)
  
##Write the AvgData to text file
  write.table(AvgData, file = "./data/AvgData.txt", row.name = FALSE)