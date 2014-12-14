library(reshape2)

ProjectZipFile<-"DataSet.zip"
ProjectDataDir<-"UCI HAR DataSet"
testData<-"UCI HAR DataSet/test"
trainData<-"UCI HAR DataSet/train"

#check if Project data dir exists if not than extract the zip files to create direcotry
if (!file.exists(ProjectDataDir)){
  #check if zip files exists if not than download the project zip file
  if(!file.exists(ProjectZipFile)){
    zipFileURL<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zipFileURL,ProjectZipFile)
  }
  #extract the downloaded project zip file
  unzip(ProjectZipFile)
}

#read datasets into R from text files
#load test data
subject_test<-read.table(paste0(testData,"/subject_test.txt"))
x_test<-read.table(paste0(testData,"/X_test.txt"))
y_test<-read.table(paste0(testData,"/Y_test.txt"))

#load train data
subject_train<-read.table(paste0(trainData,"/subject_train.txt"))
x_train<-read.table(paste0(trainData,"/X_train.txt"))
y_train<-read.table(paste0(trainData,"/Y_train.txt"))

#load features and labels data
features<-read.table(paste0(ProjectDataDir,"/features.txt"))
activity_labels<-read.table(paste0(ProjectDataDir,"/activity_labels.txt"))
names(activity_labels)<-c("activity_id","activity_labels")

#merge subject test and train data
subject_data <- rbind(subject_test, subject_train)
names(subject_data) <- "subject"

#merge x test and train data
x_data <- rbind(x_test, x_train)
names(x_data) <- features[, 2]

#merge y test and train data
y_data <- rbind(y_test,y_train)
names(y_data)<-"activity_id"


#merge x,y and subject datasets to create one dataset
data <- cbind(subject_data, y_data, x_data)
#apply activity labels to the activity id 
data<-suppressWarnings(merge(data,activity_labels,by.data="activity_id",by.activity_labels="activity_id"))
subject<-as.data.frame(data$subject)
activity<-as.data.frame(data$activity_label)
names(subject)<-"subject"
names(activity)<-"activity"
data<-cbind(subject,activity,data[,3:(ncol(data)-1)])

#find the names with mean and std for extraction
matched <- grep("-mean|-std", names(data))
data_extract <- data[, c(1, 2, matched)]

#use reshaped package to melt down data set by subject, activity and column values for summarizing 
reshaped = melt(data_extract, id = c("subject", "activity"))

#create tidy dataset and write .csv file
tidy_data = dcast(reshaped , subject + activity ~ variable, mean)
write.table(tidy_data, file="tidy_data.txt")