# Getting-and-Cleaning-Data-Project
This is a repo built for the Getting and Cleaning Data course project to demonstrate my ability to collect, work with, and clean a data set. 
In this repo, The R script "run_analysis.R" is prepared to create a tidy dataset named "Tidy_Average.txt" which consists of 180 rows and 68 columns:
* Download the dataset from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" and unzip it in the current directory
* Read the training and the test sets and merge them to create one data set by concatenating "train" (X_train.txt) and "test" (X_test.txt) data by rows and add two columns of "subject" and "activity" based on the information in subject_train.txt, subject_test.txt, y_train.txt, and y_test.txt. The merged data frame "DataMerge" consists of 10299 rows and 563 rows.
* Extract only the measurements on the mean and standard deviation for each measurement by grepping columns with names consisting of "mean()" or "std()" and keeping the last two columns of "subject" and "activity". The subset data fram "SubDataMerge" consists of 10299 rows and 68 columns.
* Use descriptive activity names to name the activities in the data set by factorizing the activity variable with activity lables obtained from "activity_labels.txt" to make "SubDataMerge" more understandable.
* Appropriately label the data set "SubDataMerge" with descriptive variable names: substitute prefix "t" with "time", substitute prefix "f" with "fequency", substitute "[Aa]cc" with "accelerometer", substitute "[Gg]yro" with "gyroscope", substitute "[Mm]ag" with "magnitude", substitute "[Bb]ody[Bb]ody" with "body", and put all names to lower case.
* Create a second, independent tidy data set with the average of each variable for each activity and each subject.

### Note
The data is downloaded in a programmatically way. If the data has been downloaded manually or already exsists. you can comment the codes at the top marked by "Task 0".
