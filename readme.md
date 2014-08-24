This repository cotains the following files:

run_analysis.R
codebook.md
tidyData.csv

The "run_analysis.R" file contains the R code that can be used to achieve the following: 

1) Download the zip file from following url: "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
2) Unzip the file and read train and test datasets.
3) read features and activity labels info
4) merge test and train data
5) assign activity labels
6) merge all datasets to create one datasets
7) extract the data with mean and std in name
8) write the tidy data set with the average of each variable for each activity 

