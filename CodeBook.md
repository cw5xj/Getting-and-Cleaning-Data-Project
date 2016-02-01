# Code Book

## Data Set description 
The data set used in this project represents the data collected from the accelerometers from the Samsung Galaxy S smartphone.  A full description is available at the site where the data was obtained, http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. Basically, the experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of 561 features was obtained by calculating variables from the time and frequency domain. 

## Task 0: download and unzip the file

The data is programmatically downloaed from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
8 files in the dataset are used for this project: 2 feature data files (./UCI HAR Dataset/train/X_train.txt, ./UCI HAR Dataset/test/X_test.txt), 2 subject files (./UCI HAR Dataset/train/subject_train.txt, UCI HAR Dataset/test/subject_test.txt), 2 activity files (./UCI HAR Dataset/train/y_train.txt, ./UCI HAR Dataset/test/y_test.txt), 1 file listing all features (./UCI HAR Dataset/features.txt), 1 file linking the activity labels with their names (./UCI HAR Dataset/activity_labels.txt)

## Task 1: Merge the training and the test sets to create one data set "DataMerge".

Read the training (./UCI HAR Dataset/train/X_train.txt, subject_train.txt, y_train.txt) and the test data(./UCI HAR Dataset/test/X_test.txt, subject_test.txt, y_test.txt) and concatenate them by rows. Then concatenate all feature/subject/activity data by columns to get the data frame "DataMerge" which consists of 10299 rows and 563 rows. The column names are added based on the information from the file (./UCI HAR Dataset/features.txt), which lists all features. In addition, the last 2 right columns are named "subject" and "activity" respectively.

## Task 2: Extract only the measurements on the mean and standard deviation for each measurement from "DataMerge" to the data set "SubDataMerge".

Grep columns with names consisting of "mean()" or "std()" and also keep the last two columns of "Subject" and "Activity". "SubDataMerge" consists of 10299 rows and 68 columns.


## Task 3: Use descriptive activity names to name the activities in the data set "SubDataMerge".

Factorize the Activity variable with activity lables in "activity_labels.txt" to make the merged data frame "SubDataMerge" more understandable.

Activity<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
SubDataMerge$Activity<-factor(SubDataMerge$Activity,levels=Activity[,1],labels = Activity[,2])

## Task 4: Appropriately label the data set "SubDataMerge" with descriptive variable names.

Substitute prefix "t" with "time", substitute prefix "f" with "fequency", substitute "[Aa]cc" with "accelerometer", substitute "[Gg]yro" with "gyroscope", substitute "[Mm]ag" with "magnitude", substitute "[Bb]ody[Bb]ody" with "body", and put all names to lower case.

names(SubDataMerge)<-gsub("^t","time",names(SubDataMerge))             
names(SubDataMerge)<-gsub("^f","frequency",names(SubDataMerge))        
names(SubDataMerge)<-gsub("[Aa]cc","accelerometer",names(SubDataMerge))
names(SubDataMerge)<-gsub("[Gg]yro","gyroscope",names(SubDataMerge))   
names(SubDataMerge)<-gsub("[Mm]ag","magnitude",names(SubDataMerge))   
names(SubDataMerge)<-gsub("[Bb]ody[Bb]ody","body",names(SubDataMerge)) 
names(SubDataMerge)<-tolower(names(SubDataMerge))

## Task 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.

Melt the data frame "SubDataMerge" with id being "subject" and "activity" and all other columns being measured variables Then cast the melted data frame to calculate the average.


library(reshape2)
MeltData<-melt(SubDataMerge,id=c("subject","activity"),measure.vars = names(SubDataMerge)[1:66]) 
CastData<-dcast(MeltData,subject+activity~variable,mean)
CastData<-CastData[order(CastData$subject,CastData$activity),]
