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

#merge subject test and train data
subject_data <- rbind(subject_test, subject_train)
names(subject_data) <- "subject"

#merge x test and train data
x_data <- rbind(x_test, x_train)
names(x_data) <- features[, 2]

#merge y test and train data
y_data <- rbind(y_test,y_train)

#assign activity labels to activity id in y data
y_data <- merge(y_data, activity_labels, by = 1)[, 2]

#merge x,y and subject datasets to create one dataset
data <- cbind(subject_data, y_data, x_data)
names(data)[2] <- "activity"

#find the names with mean and std for extraction
matched <- grep("-mean|-std", names(data))
data_extract <- data[, c(1, 2, matched)]

reshaped = melt(data_extract, id = c("subject", "activity"))
tidy_data = dcast(reshaped , subject + activity ~ variable, mean)
write.table(tidy_data, file="tidy_data.txt")










