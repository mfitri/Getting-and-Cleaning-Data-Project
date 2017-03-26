## Set Working Directory to the location where the UCI HAR Dataset was unzipped
setwd("C:/Users/user/Documents/Data Science/GettingandCleaningData/UCI HAR Dataset")

## 1. Merges the training and the test sets to create one data set:
# Load and read in the data from files
X_train <- read.table("./train/X_train.txt", header = FALSE)
X_test <- read.table("./test/X_test.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
subject_test <- read.table("./test/subject_test.txt", header = FALSE)

# Combines data table by rows
x <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subj <- rbind(subject_train, subject_test)

## 2. Extract only the measurements on the mean and standard deviation for each measurement
# Load: data column names
features <- read.table("features.txt")
# Extract only the measurements on the mean and standard deviation
extract_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x <- x[, extract_features]
names(x) <- features[extract_features, 2]
names(x) <- gsub("\\(|\\)", "", names(x))

## 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", as.character(activities[, 2]))
y[, 1] = activities[y[, 1], 2]
names(y) <- "Activity"

## 4. Appropriately labels the data set with descriptive activity names.
names(subj) <- "Subject"
# Bind data
cleanedData <- cbind(subj, y, x)
# Cleaning up the variable names
names(cleanedData)<-gsub("^t", "time", names(cleanedData))
names(cleanedData)<-gsub("^f", "frequency", names(cleanedData))
names(cleanedData)<-gsub("Acc", "Accelerometer", names(cleanedData))
names(cleanedData)<-gsub("Gyro", "Gyroscope", names(cleanedData))
names(cleanedData)<-gsub("Mag", "Magnitude", names(cleanedData))
names(cleanedData)<-gsub("BodyBody", "Body", names(cleanedData))
write.table(cleanedData, "merged_clean_data.txt")

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Create a new table, finalData
finalData = cleanedData[,names(cleanedData)];
# Summarizing the finalDataN table to include just the mean of each variable for each activity and each subject
tidyData= aggregate(finalData[,names(finalData) != c('Subject','Activity')],by=list(Activity=finalData$Activity, Subject = finalData$Subject),mean);
# Export the tidyData set 
write.table(tidyData, './tidy.txt',row.names=TRUE,sep='\t')