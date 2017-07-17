# Project steps:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#setwd("R:/Renne/Coursera/Data_Science/CleaningDataProject")

library(data.table)
library(knitr)
BLANK_SPACE <- " "

test_subject_file_name <- "./UCI HAR Dataset/test/subject_test.txt"
test_set_file_name <- "./UCI HAR Dataset/test/X_test.txt"
test_labels_file_name <- "./UCI HAR Dataset/test/y_test.txt"

training_subject_file_name <- "./UCI HAR Dataset/train/subject_train.txt"
training_set_file_name <- "./UCI HAR Dataset/train/X_train.txt"
training_labels_file_name <- "./UCI HAR Dataset/train/y_train.txt"

# Reading files - Start
test_subject <- fread(test_subject_file_name, sep = BLANK_SPACE)
data_test_subject <- data.table(test_subject)

test_set <- fread(test_set_file_name, sep = BLANK_SPACE)
data_test_set <- data.table(test_set)

test_labels <- fread(test_labels_file_name, sep = BLANK_SPACE)
data_test_labels <- data.table(test_labels)

training_subject <- fread(training_subject_file_name, sep = BLANK_SPACE)
data_training_subject <- data.table(training_subject)
  
training_set <- fread(training_set_file_name, sep = BLANK_SPACE)
data_training_set <- data.table(training_set)

training_labels <- fread(training_labels_file_name, sep = BLANK_SPACE)
data_training_labels <- data.table(training_labels)
# Reading files - End


# 1. Merges the training and the test sets to create one data set.

data_subject <- rbind(data_training_subject, data_test_subject)
# Renaming labels
setnames(data_subject, "V1", "subject")

data_activity <- rbind(data_training_labels, data_test_labels)
# Renaming labels
setnames(data_activity, "V1", "activityNum")

data <- rbind(data_training_set, data_test_set)

data_subject <- cbind(data_subject, data_activity)
data <- cbind(data_subject, data)
setkey(data, subject, activityNum)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features_file_name <- "./UCI HAR Dataset/features.txt"
data_features <- fread(features_file_name)
setnames(data_features, names(data_features), c("feature_number", "feature_name"))
data_features <- data_features[grepl("mean\\(\\)|std\\(\\)", feature_name)]
data_features$featureCode <- data_features[, paste0("V", feature_number)]

column_filter <- c(key(data), data_features$featureCode)
data <- data[, column_filter, with = FALSE]


# 3. Uses descriptive activity names to name the activities in the data set

activity_labels_file_name <- "./UCI HAR Dataset/activity_labels.txt"
data_activity_labels <- fread(activity_labels_file_name)
setnames(data_activity_labels, names(data_activity_labels), c("activityNum", "activityName"))


# 4. Appropriately labels the data set with descriptive variable names.

data <- merge(data, data_activity_labels, by = "activityNum", all.x = TRUE)
setkey(data, subject, activityNum, activityName)
data <- data.table(melt(data, key(data), variable.name="featureCode"))
data <- merge(data, data_features[, list(feature_number, featureCode, feature_name)], by="featureCode", all.x=TRUE)

data$feature <- factor(data$feature_name)
data$activity <- factor(data$activityName)

# Helper function
grep_feature <- function (regex) {
 grepl(regex, data$feature)
}

# Features having one category
data$feature_jerk <- factor(grep_feature("Jerk"), labels = c(NA, "jerk"))
data$feature_magnitude <- factor(grep_feature("Mag"), labels = c(NA, "magnitude"))

# Features having two categories
y <- matrix(seq(1, 2), nrow = 2)
x <- matrix(c(grep_feature("^t"), grep_feature("^f")), ncol = nrow(y))
data$feature_domain <- factor(x %*% y, labels=c("time", "frequency"))

x <- matrix(c(grep_feature("Acc"), grep_feature("Gyro")), ncol = nrow(y))
data$feature_instrument <- factor(x %*% y, labels=c("accelerometer", "gyroscope"))

x <- matrix(c(grep_feature("BodyAcc"), grep_feature("GravityAcc")), ncol = nrow(y))
data$feature_acceleration <- factor(x %*% y, labels=c(NA, "body", "gravity"))

x <- matrix(c(grep_feature("mean()"), grep_feature("std()")), ncol = nrow(y))
data$feature_variable <- factor(x %*% y, labels=c("mean", "sd"))

# Features having three categories
y <- matrix(seq(1, 3), nrow = 3)
x <- matrix(c(grep_feature("-X"), grep_feature("-Y"), grep_feature("-Z")), ncol = nrow(y))
data$feature_axis <- factor(x %*% y, labels = c(NA, "x", "y", "z"))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setkey(data, subject, activity, feature_domain, feature_acceleration, feature_instrument, feature_jerk, feature_magnitude, feature_variable, feature_axis)
tidy_data <- data[, list(count = .N, average = mean(value)), by = key(data)]

tidy_data_file_name <- "./wearable_tidy_data.txt"
write.table(tidy_data, tidy_data_file_name, quote = FALSE, sep = "\t", row.names = FALSE)

knit("create_codebook.Rmd", output = "codebook.md", encoding="ISO8859-1")

