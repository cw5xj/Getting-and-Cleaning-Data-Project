# Code Book

## Data Set description 
The data set used in this project represents the data collected from the accelerometers from the Samsung Galaxy S smartphone.  A full description is available at the site where the data was obtained, http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. Basically, the experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of 561 features was obtained by calculating variables from the time and frequency domain. 

## Getting and Cleaning Data 
### Task 0: download and unzip the file

The data is programmatically downloaed from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
8 files in the dataset are used for this project: 2 feature data files (./UCI HAR Dataset/train/X_train.txt, ./UCI HAR Dataset/test/X_test.txt), 2 subject files (./UCI HAR Dataset/train/subject_train.txt, UCI HAR Dataset/test/subject_test.txt), 2 activity files (./UCI HAR Dataset/train/y_train.txt, ./UCI HAR Dataset/test/y_test.txt), 1 file listing all features (./UCI HAR Dataset/features.txt), 1 file linking the activity labels with their names (./UCI HAR Dataset/activity_labels.txt)

DataLink<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";

download.file(DataLink,destfile="Data.zip");

unzip(zipfile="Data.zip");   

### Task 1: Merge the training and the test sets to create one data set "DataMerge".

Read the training (./UCI HAR Dataset/train/X_train.txt, subject_train.txt, y_train.txt) and the test data(./UCI HAR Dataset/test/X_test.txt, subject_test.txt, y_test.txt) and concatenate them by rows. Then concatenate all feature/subject/activity data by columns to get the data frame "DataMerge" which consists of 10299 rows and 563 rows. The column names are added based on the information from the file (./UCI HAR Dataset/features.txt), which lists all features. In addition, the last 2 right columns are named "subject" and "activity" respectively.

TrainFeatureData<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE);

TrainSubjectData<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE);

TrainActivityData<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE);

TestFeatureData<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE);

TestSubjectData<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE);

TestActivityData<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE);

FeatureData<-rbind(TrainFeatureData,TestFeatureData);    

SubjectData<-rbind(TrainSubjectData,TestSubjectData);   

ActivityData<-rbind(TrainActivityData,TestActivityData); 

DataMerge<-cbind(FeatureData,SubjectData,ActivityData);

Featurenames<-(read.table("./UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE))[,2];

names(DataMerge)<-c(Featurenames,"subject","activity"); 

### Task 2: Extract only the measurements on the mean and standard deviation for each measurement from "DataMerge" to the data set "SubDataMerge".

Grep columns with names consisting of "mean()" or "std()" and also keep the last two columns of "Subject" and "Activity". "SubDataMerge" consists of 10299 rows and 68 columns.

SubDataMerge<-DataMerge[,grep("mean\\(\\)|std\\(\\)|^Subject$|^Activity$",names(DataMerge))];


### Task 3: Use descriptive activity names to name the activities in the data set "SubDataMerge".

Factorize the Activity variable with activity lables in "activity_labels.txt" to make the merged data frame "SubDataMerge" more understandable.

Activity<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,stringsAsFactors=FALSE);

SubDataMerge$Activity<-factor(SubDataMerge$Activity,levels=Activity[,1],labels = Activity[,2]);

### Task 4: Appropriately label the data set "SubDataMerge" with descriptive variable names.

Substitute prefix "t" with "time", substitute prefix "f" with "fequency", substitute "[Aa]cc" with "accelerometer", substitute "[Gg]yro" with "gyroscope", substitute "[Mm]ag" with "magnitude", substitute "[Bb]ody[Bb]ody" with "body", and put all names to lower case.

names(SubDataMerge)<-gsub("^t","time",names(SubDataMerge));     
        
names(SubDataMerge)<-gsub("^f","frequency",names(SubDataMerge));    
    
names(SubDataMerge)<-gsub("[Aa]cc","accelerometer",names(SubDataMerge));

names(SubDataMerge)<-gsub("[Gg]yro","gyroscope",names(SubDataMerge));   

names(SubDataMerge)<-gsub("[Mm]ag","magnitude",names(SubDataMerge));   

names(SubDataMerge)<-gsub("[Bb]ody[Bb]ody","body",names(SubDataMerge)); 

names(SubDataMerge)<-tolower(names(SubDataMerge));

### Task 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.

Melt the data frame "SubDataMerge" with id being "subject" and "activity" and all other columns being measured variables Then cast the melted data frame to calculate the average for each activity and each subject.


library(reshape2);

MeltData<-melt(SubDataMerge,id=c("subject","activity"),measure.vars = names(SubDataMerge)[1:66]); 

CastData<-dcast(MeltData,subject+activity~variable,mean);

CastData<-CastData[order(CastData$subject,CastData$activity),];


### Task 6: Output the tidy data set to "Tidy_Average.txt" in the current directory. 180 rows and 68 columns.

write.table(CastData,file="Tidy_Average.txt",row.names=FALSE);

## Identifiers: the left 2 columns
*subject
*activity

## Variables of the dataset: The other 66 columns
*timebodyaccelerometer-mean()-x
*timebodyaccelerometer-mean()-y
*timebodyaccelerometer-mean()-z
*timebodyaccelerometer-std()-x
*timebodyaccelerometer-std()-y
*timebodyaccelerometer-std()-z
*timegravityaccelerometer-mean()-x
*timegravityaccelerometer-mean()-y
*timegravityaccelerometer-mean()-z
*timegravityaccelerometer-std()-x
*timegravityaccelerometer-std()-y               "timegravityaccelerometer-std()-z             
*timebodyaccelerometerjerk-mean()-x             *timebodyaccelerometerjerk-mean()-y            
*timebodyaccelerometerjerk-mean()-z           *timebodyaccelerometerjerk-std()-x        
*timebodyaccelerometerjerk-std()-y            *timebodyaccelerometerjerk-std()-z             
*timebodygyroscope-mean()-x                     *timebodygyroscope-mean()-y                    
*timebodygyroscope-mean()-z                     *timebodygyroscope-std()-x                     
*timebodygyroscope-std()-y                      *timebodygyroscope-std()-z                     
*timebodygyroscopejerk-mean()-x                 *timebodygyroscopejerk-mean()-y                
*timebodygyroscopejerk-mean()-z                 *timebodygyroscopejerk-std()-x                 
*timebodygyroscopejerk-std()-y                  *timebodygyroscopejerk-std()-z                 
*timebodyaccelerometermagnitude-mean()          *timebodyaccelerometermagnitude-std()          
*timegravityaccelerometermagnitude-mean()       *timegravityaccelerometermagnitude-std()       
*timebodyaccelerometerjerkmagnitude-mean()      *timebodyaccelerometerjerkmagnitude-std()      
*timebodygyroscopemagnitude-mean()              *timebodygyroscopemagnitude-std()              
*timebodygyroscopejerkmagnitude-mean()          *timebodygyroscopejerkmagnitude-std()          
*frequencybodyaccelerometer-mean()-x            *frequencybodyaccelerometer-mean()-y           
*frequencybodyaccelerometer-mean()-z            *frequencybodyaccelerometer-std()-x            
*frequencybodyaccelerometer-std()-y             *frequencybodyaccelerometer-std()-z            
*frequencybodyaccelerometerjerk-mean()-x        *frequencybodyaccelerometerjerk-mean()-y       
*frequencybodyaccelerometerjerk-mean()-z        *frequencybodyaccelerometerjerk-std()-x        
*frequencybodyaccelerometerjerk-std()-y        *frequencybodyaccelerometerjerk-std()-z       
*frequencybodygyroscope-mean()-x                "frequencybodygyroscope-mean()-y               
*frequencybodygyroscope-mean()-z                *frequencybodygyroscope-std()-x                
*frequencybodygyroscope-std()-y                 *frequencybodygyroscope-std()-z                
*frequencybodyaccelerometermagnitude-mean()    *frequencybodyaccelerometermagnitude-std()    
*frequencybodyaccelerometerjerkmagnitude-mean() *frequencybodyaccelerometerjerkmagnitude-std() 
*frequencybodygyroscopemagnitude-mean()         *frequencybodygyroscopemagnitude-std()         
*frequencybodygyroscopejerkmagnitude-mean()     *frequencybodygyroscopejerkmagnitude-std()

