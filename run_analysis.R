# Task 0
# download and unzip the file
DataLink<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(DataLink,destfile="Data.zip")
unzip(zipfile="Data.zip")   #unzipping under the current directory

# Task 1
# Merge the training and the test sets to create one data set
##################################################################################################
# Read "train" data from "train" subdirectory
TrainFeatureData<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
TrainSubjectData<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
TrainActivityData<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)

# Read "test" data from "test" subdirectory
TestFeatureData<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
TestSubjectData<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
TestActivityData<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)

# Concatenate "train" and "test" data by rows
FeatureData<-rbind(TrainFeatureData,TestFeatureData)    #concatenate feature data
SubjectData<-rbind(TrainSubjectData,TestSubjectData)    #concatenate subject data
ActivityData<-rbind(TrainActivityData,TestActivityData) #concatenate activity data

# Concatenate all feature/subject/activity data by columns to get the data frame "DataMerge"
DataMerge<-cbind(FeatureData,SubjectData,ActivityData)

# Read names of feature variables from "feature.txt"
Featurenames<-(read.table("./UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE))[,2]
names(DataMerge)<-c(Featurenames,"subject","activity") #Assign column names for "DataMerge"


# Task 2
# Extract only the measurements on the mean and standard deviation for each measurement
##################################################################################################
# Grep columns with names consisting of "mean()" or "std()" and also keep the last two columns of
# "Subject" and "Activity". Totally 68 columns.
SubDataMerge<-DataMerge[,grep("mean\\(\\)|std\\(\\)|^subject$|^activity$",names(DataMerge))]


# Task 3
# Use descriptive activity names to name the activities in the data set
##################################################################################################
# Factorize the Activity variable with activity lables in "activity_labels.txt" 
# to make the merged data frame "SubDataMerge" more understandable
Activity<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
SubDataMerge$activity<-factor(SubDataMerge$activity,levels=Activity[,1],labels = Activity[,2])

# Task 4
# Appropriately label the data set "SubDataMerge" with descriptive variable names
##################################################################################################
names(SubDataMerge)<-gsub("^t","time",names(SubDataMerge))             # Substitute prefix "t" with "time"
names(SubDataMerge)<-gsub("^f","frequency",names(SubDataMerge))        # Substitute prefix "f" with "fequency"
names(SubDataMerge)<-gsub("[Aa]cc","accelerometer",names(SubDataMerge))# Substitute "[Aa]cc" with "accelerometer"
names(SubDataMerge)<-gsub("[Gg]yro","gyroscope",names(SubDataMerge))   # Substitute "[Gg]yro" with "gyroscope"
names(SubDataMerge)<-gsub("[Mm]ag","magnitude",names(SubDataMerge))    # Substitute "[Mm]ag" with "magnitude"
names(SubDataMerge)<-gsub("[Bb]ody[Bb]ody","body",names(SubDataMerge)) # Substitute "[Bb]ody[Bb]ody" with "body"
names(SubDataMerge)<-tolower(names(SubDataMerge))                      # Put all names to lower case

# Task 5
# Create a second, independent tidy data set with the average of each variable for each activity 
# and each subject
##################################################################################################
# Melt the data frame "SubDataMerge" with id being "subject" and "activity" and all other columns being measured variables
# Then cast the melted data frame to calculate the average
library(reshape2)
MeltData<-melt(SubDataMerge,id=c("subject","activity"),measure.vars = names(SubDataMerge)[1:66]) 
CastData<-dcast(MeltData,subject+activity~variable,mean)
CastData<-CastData[order(CastData$subject,CastData$activity),]

# Task 6
# Output the tidy data set to "Tidy_Average.txt" in the current directory
write.table(CastData,file="Tidy_Average.txt",row.names=FALSE)

