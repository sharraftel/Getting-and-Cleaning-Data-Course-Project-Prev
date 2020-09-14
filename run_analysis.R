library(dplyr)
library(data.table)
filename <- "Coursera_DS3_Final.zip"

# getting the files installed and unziped
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## test data:
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

##Part1 - merges train and test data in one dataset (full dataset at the end)
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)

index<-grep("mean\\(\\)|std\\(\\)", features[,2]) ##getting features indeces which contain mean() and std() in their name
length(index) ## count of features
X<-X[,index] ## getting only variables with mean/stdev
dim(X) ## checking dim of subset 

Y[,1]<-activity[Y[,1],2] ## replacing numeric values with lookup value from activity.txt; won't reorder Y set
head(Y) #to check if they got replaced

names<-features[index,2] ## getting names for variables

names(X)<-names ## updating colNames for new dataset
names(Subject)<-"SubjectID"
names(Y)<-"Activity"

CleanedData<-cbind(Subject, Y, X)
head(CleanedData[,c(1:4)]) ## first 5 columns


###################writeing the file
CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] ## features average by Subject and by activity
dim(TidyData)
write.table(TidyData, file = "data_tidy.txt", row.names = FALSE)
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],12) 