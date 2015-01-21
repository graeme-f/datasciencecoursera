---
title: "README"
output: html_document
---

The script run_analysis.R will extract the required data from the **UCI HAR** Dataset which can be found at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

Running the code
----------------
The script just needs to be run.

If you have already downloaded the zip file and it is in the same directory as the script then the files will be extracted from the zip archive. If the zip file doesn't exist then the script will attept to download the file for you, obviously this action will require access to the internet.

Should you want the data to be held in a directiry different to the current working directory, then uncomment the zipDir line found on line 12: ```##zipDir <- "zipData" # uncoment this if the data is stored in a directory other than the working directory```
