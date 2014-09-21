##Code book for perparing tidy data set

###Data source information:
Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
Original description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


The attached R script (run_analysis.R) performs the following to clean up the data:

* run_analysis.R file use package "reshape2" for summarizing data
* Following 4 variables are used in code for assign data source name and path:
	* ProjectZipFile: Archive data file name
	* ProjectDataDir: Extracted data source directory
	* testData: Test data directory path
	* trainData: Train data directory path
	
<li> Download zipped data from original data source: </li>
	* First code checks if data source directory is already available in current working directory
	* if data source directory is not available then code checks if original data source zip file is already exists in working directory
	* if zip file doesn't exists then code downloads the file from original data source url
	* if extracted data is not available then exracts the archived data.

###R code for step 1
if (!file.exists(ProjectDataDir)){
  if(!file.exists(ProjectZipFile)){
    zipFileURL<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zipFileURL,ProjectZipFile)
  }
  unzip(ProjectZipFile)
}
	
<li> Second step of code import downloaded text files to data frames and create following data frames: </li>
	* Subject_test: read subject_test.txt file to subject_test data frame. This data frame contains subject_id of test data set.
	* x_test: read X_test.txt file to x_test data frame. This data frame contains test data set. Test data sets 2947 rows and 561 columns.
	* y_test: read Y_test.txt file to y_test data frame.This data frame contains activity_id of subjects in test data set.
	* Subject_train: read subject_train.txt file to subject_train data frame. This data frame contains subject_id of training data set.
	* x_train: read X_train.txt file to x_train data frame. This data frame contains training data set. Train data set contains 7352 rows and 561 columns.
	* y_train: read Y_train.txt file to y_train data frame. This data frame contains activity_id of subjects in training data set
	* features: read features.txt file to features data frame. This data frame contains variable labels for x_test and x_train data frames.
	* activity_labels: read activity_labels.txt file to activity_labels data frame. This data frame contains activity labels for activity_id. this data set contains 6 rows of activity labels.

###R code for step 2
subject_test<-read.table(paste0(testData,"/subject_test.txt"))
x_test<-read.table(paste0(testData,"/X_test.txt"))
y_test<-read.table(paste0(testData,"/Y_test.txt"))

subject_train<-read.table(paste0(trainData,"/subject_train.txt"))
x_train<-read.table(paste0(trainData,"/X_train.txt"))
y_train<-read.table(paste0(trainData,"/Y_train.txt"))

features<-read.table(paste0(ProjectDataDir,"/features.txt"))
activity_labels<-read.table(paste0(ProjectDataDir,"/activity_labels.txt"))
names(activity_labels)<-c("activity_id","activity_labels")


<li> Merge training and test datasets. Merged training data test data set contains 10299 rows and 561 columns </li>

### R code for step 3
subject_data <- rbind(subject_test, subject_train)
names(subject_data) <- "subject"

x_data <- rbind(x_test, x_train)
names(x_data) <- features[, 2]

y_data <- rbind(y_test,y_train)
names(y_data)<-"activity_id"

data <- cbind(subject_data, y_data, x_data)

<ul>
<li> apply activity labels to activity id and subject id </li>

### R Code for step 4
data<-suppressWarnings(merge(data,activity_labels,by.data="activity_id",by.activity_labels="activity_id"))
subject<-as.data.frame(data$subject)
activity<-as.data.frame(data$activity_label)
names(subject)<-"subject"
names(activity)<-"activity"
data<-cbind(subject,activity,data[,3:(ncol(data)-1)])
 
<li> search mean and standard deviation (std) in variable names and create data set only for these variables. Final dataset contains 10299 rows and 81 columns </li>

### R Code for step 5
matched <- grep("-mean|-std", names(data))
data_extract <- data[, c(1, 2, matched)]

<li> use reshape2 package for melting data set and create data set with subject_id, activity_label and all variable values in one column </li>
reshaped = melt(data_extract, id = c("subject", "activity"))

<li> Create summarized datasets tidy_data with 180 rows and 81 columns using following R code: </li>
tidy_data = dcast(reshaped , subject + activity ~ variable, mean)

<li> Write tidy_data data frame to tidy_data.txt file using following R Code </li>
write.table(tidy_data, file="tidy_data.txt")

</ul>