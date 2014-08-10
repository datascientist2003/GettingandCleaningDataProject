# 1. Merge training and test sets to create one data set

features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("activityID", "activityType")

x_train <- read.table("./train/X_train.txt")
colnames(x_train) <- features[,2]
subject_train <- read.table("./train/subject_train.txt")
colnames(subject_train) <- "SubjectID"
y_train <- read.table("./train/y_train.txt")
colnames(y_train) <- "activityType"
train <- cbind(subject_train, y_train, x_train)

x_test <- read.table("./test/X_test.txt")
colnames(x_test) <- features[,2]
subject_test <- read.table("./test/subject_test.txt")
colnames(subject_test) <- "SubjectID"
y_test <- read.table("./test/y_test.txt")
colnames(y_test) <- "activityType"
test <- cbind(subject_test, y_test, x_test)

data <- rbind(train, test)

# 2. Extract only measurements on mean and standard deviation for each measurement

colnamesdata <- colnames(data)
selected_feat <- grep("mean\\(\\)|std\\(\\)", colnamesdata)
selected_data <- data[,c(1,2,selected_feat)]
colnames(selected_data) <- gsub("\\(\\)", "", colnames(selected_data))

# 3. Use descriptive activity names to name the activities in the data set

selected_data$activityType <- activity_labels[selected_data$activityType,]$activityType

# 4. Appropriately labels the data set with descriptive variable names
# Already done in step 1 and 2

# 5. Create an independent tidy data set with the average of each variable for each activity and each subject

selected_data$SubjectID <- as.factor(selected_data$SubjectID)
tidy_data <- aggregate(selected_data[,3:68], by=list(selected_data$activityType, selected_data$SubjectID), FUN=mean)
colnames(tidy_data)[1] <- "activityType"
colnames(tidy_data)[2] <- "SubjectID"
write.csv(tidy_data, "tidy.csv", row.names=F)
