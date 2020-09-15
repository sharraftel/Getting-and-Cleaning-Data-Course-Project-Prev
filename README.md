# Getting-and-Cleaning-Data-Course-Project-Prev

## introduction 
This script is written as part of the online data science course.
The purpose for it is to collect and clean a data set and restructure is into a text file in a tidy readable manner with prober labeling.

## How it works:

The first part is of course downloading and unzipping the data, this is done through these commands:
```
filename <- "Coursera_DS3_Final.zip"
#getting the files installed and unziped
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
```
It first checks if the data is downloaded or not and then download and unzips if its there.
Then it associates each table with a data frame.
```
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
```
now in this data set we notice that there is two x data frames and two Y data frames, these need to be merged 
##Part1 - merges train and test data in one dataset (full dataset at the end)
```
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)
```
getting features indeces which contain mean() and std() in their name
```
index<-grep("mean\\(\\)|std\\(\\)", features[,2]) 
length(index) ## count of features
X<-X[,index] ## getting only variables with mean/stdev
dim(X) ## checking dim of subset 
```
replacing numeric values with lookup value from activity.txt; won't reorder Y set
```
Y[,1]<-activity[Y[,1],2] 
head(Y) #to check if they got replaced
```
getting names for variables
```
names<-features[index,2] ## getting names for variables
```
updating colNames for new dataset
```
names(X)<-names ## updating colNames for new dataset
names(Subject)<-"SubjectID"
names(Y)<-"Activity"
CleanedData<-cbind(Subject, Y, X)
head(CleanedData[,c(1:4)]) 
```

and now finally writting the output text file
```
CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity'] ## features average by Subject and by activity
dim(TidyData)
write.table(TidyData, file = "data_tidy.txt", row.names = FALSE)
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],12) 
```
