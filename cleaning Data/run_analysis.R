library("data.table")
library(plyr)
library(reshape2)

## This srcipt will get and clean data from the data set on Human Activity Recognition Using Smartphones.
## PART 1 : This will get the data from the web, if required
##          and then extract the data from the zip file.
## PART 2 : This will open each of the required data files
##          and merge them into a single data table.
## PART 3 : This will calculate the mean of grouped data.
##          for each subject the mean is calculated
##          for each activity the mean is calculated


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipDir <- ""
##zipDir <- "zipData" # uncoment this if the data is stored in a directory other than the working directory
zipName <- file.path(".", zipDir, "projectData.zip")

## ------------------ ##
## ***** PART 1 ***** ##
## ------------------ ##

print ("Getting the original data, it will be downloaded, if necessary")
# Create the data directory if it doesn't exist
if (!file.exists(zipDir)){
    dir.create(zipDir)
}

# Download the zip file if it doesn't exist locally
if (!file.exists(zipName)){
    print ("Downloading the file...")
    download.file(fileURL, destfile=zipName, mode="wb") # Use mode = "wb" for Windows
    dateDownload <- date()
    print(dateDownload)
    print ("... completed.")
}


# Extract the files if they have not already been extracted
if (file.exists(zipName)){
    print ("Extracting the files from the zip archive...")
    fileList  <- unzip(zipName, list=TRUE)
    
    extract <- function (zipFile){
        # This function will extract the given zipfile from the archive
        # if it doesn't already exist. This check is much quicker than
        # setting overwrite to FALSE and then extract the whole archive.
        #
        # 'zipfile' is the name of the file to be extracted from the archive.
        # return a one line message indicating the action taken.
        if (!file.exists(zipFile)){
            unzip(zipName, files=zipFile)
            paste ("Extracted: ", zipFile)
        }
        paste ("Ignored: ", zipFile)
    } ## end of function extract()
    
    extractResult <- lapply(fileList$Name, function(x) extract(x))
    print ("... completed.")
}

## ------------------ ##
## ***** PART 2 ***** ##
## ------------------ ##
features_file = "data/UCI HAR Dataset/features.txt"
if (file.exists(features_file)){
    # The required features are described in the codebook
    reqFeatures <- c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543)
    # Now get a list of the features
    labels <- read.table(features_file)
    labels <- labels[reqFeatures,2]
}

activity_file = "data/UCI HAR Dataset/activity_labels.txt"
if (file.exists(activity_file)){
    activity <- read.table(activity_file)
}

X_test_file = "data/UCI HAR Dataset/test/X_test.txt"
if (file.exists(X_test_file)){
    print ("Loading data from the test file...")
    # Process the test data
    # Read in the test data
    raw_data <- read.table(X_test_file)
    # Extract the required features
    data <- raw_data[,reqFeatures]
    # Extract the activity id and convert the id to a meaningful name
    activity_test_file = "data/UCI HAR Dataset/test/y_test.txt"
    raw_activity <- read.table(activity_test_file)
    activity_label <- lapply(raw_activity, function (x) as.character(activity$V2[x]))
    # Extract the subject id
    subject_test_file = "data/UCI HAR Dataset/test/subject_test.txt"
    subject_id <- read.table(subject_test_file)
    # Merge the data together
    data <- cbind(subject_id, activity_label, data)
    print (paste("... ", as.character(nrow(data)), " rows loaded."))
}
    
X_train_file = "data/UCI HAR Dataset/train/X_train.txt"
if (file.exists(X_train_file)){
    print ("Loading data from the train file...")
    # Process the train data
    # Read in the test data
    raw_data <- read.table(X_train_file)
    # Extract the required features and merge the two data sets together
    data2 <- raw_data[,reqFeatures]
    activity_test_file = "data/UCI HAR Dataset/train/y_train.txt"
    raw_activity <- read.table(activity_test_file)
    activity_label <- lapply(raw_activity, function (x) as.character(activity$V2[x]))
    # Extract the subject id
    subject_train_file = "data/UCI HAR Dataset/train/subject_train.txt"
    subject_id <- read.table(subject_train_file)
    # Merge the data together
    data2 <- cbind(subject_id, activity_label, data2)
    data <- rbind(data,data2)
    print (paste("... ", as.character(nrow(data2)), " rows loaded."))
    print (paste("giving a total of ", as.character(nrow(data)), " rows."))
}

names(data) <- c("Subject", "Feature", as.character(labels))
##data$Subject <- sapply(data$Subject, function(x) paste("Subject", x))


## ------------------ ##
## ***** PART 3 ***** ##
## ------------------ ##

## To get the mean for each variable the dataframe will need to be melted

melted <- melt(data, id.vars=c("Subject", "Feature"))
tidy <- ddply(melted, c("Subject", "Feature", "variable"), summarise, mean = mean(value))
tidy <- tidy[order(tidy$Subject, tidy$Feature, tidy$variable),]

write.table(tidy, "tidydata.txt", row.name=FALSE)
