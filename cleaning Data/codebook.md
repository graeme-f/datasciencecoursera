---
title: "codebook.md"
output: html_document
---

The script run_analysis.R will extract the required data from the **UCI HAR** Dataset which can be found at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

Running the code
----------------
The script just needs to be run.

If you have already downloaded the zip file and it is in the same directory as the script then the files will be extracted from the zip archive. If the zip file doesn't exist then the script will attept to download the file for you, obviously this action will require access to the internet.

Should you want the data to be held in a directiry different to the current working directory, then uncomment the zipDir line found on line 12: ```##zipDir <- "zipData" # uncoment this if the data is stored in a directory other than the working directory```

The variables
-------------
In total 66 variables are extracted from the original dataset:

Name           Details                      Filter
-------------  ---------------------------- ---------------
tBodyAcc       Body Acceleration            Time & FFT
tGravityAcc    Gravitational Acceleration   Time
tBodyAccJerk   Body jerk                    Time & FFT
tBodyGyro      Angular Velocity             Time & FFT
tBodyGyroJerk  Angular Jerk                 Time & FFT - Mag part only for FFT

For each feature the X, Y, Z and Mag part were extracted and the mean and std summary details were kept. This is five time and three FFT features for each of the four measurements (X, Y, Z & Mag) giving a total of 32, plus fBodyBodyGyroJerkMag, making a total of 33. Only the mean and std calculations are retained for each of these features.

The 66 features are further broken down into the six activities:

ID   Activity
---  -------------------
1    WALKING
2    WALKING_UPSTAIRS
3    WALKING_DOWNSTAIRS
4    SITTING
5    STANDING
6    LAYING

The test file consists of 2,947 rows and the train file consists of 7,352 making a total of 10,299 data rows.

The output
----------
The data is then arranged into subject and activity and for each feature the mean is calculated. So with 30 subjects, 6 activities and 66 features, the mean is calcualted for 11880 rows. This data is then saved to the tidydata.txt file.