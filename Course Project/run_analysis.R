library(dplyr)

## Get working directory
dir <- getwd()
features <- read.table("features.txt")
features <- features$V2

## Navigate to train folder & load data
dir_train <- paste(dir, "train", sep = "/")
setwd(dir_train)

x <- read.table("X_train.txt")
y <- read.table("y_train.txt")
subject <- read.table("subject_train.txt")

## Navigate to test folder & load data
dir_test <- paste(dir, "test", sep = "/")
setwd(dir_test)

x <- rbind(x, read.table("X_test.txt"))
y <- rbind(y, read.table("y_test.txt"))
subject <- rbind(subject, read.table("subject_test.txt"))

## Assemble data
data <- cbind(x, subject, y)
names(data) <- features
colnames(data)[562] <- "subject"
colnames(data)[563] <- "activity"

###########################################################
## Format column names
data2 <- data[, c(grep("mean", features), grep("std", features), 562, 563)]
names(data2) <- gsub("-", ".", names(data2))

###########################################################
## Translate activity code to names
data2[grep("1", data2$activity), "activity"] <- "Walking"
data2[grep("2", data2$activity), "activity"] <- "Walking Upstairs"
data2[grep("3", data2$activity), "activity"] <- "Walking Downstairs"
data2[grep("4", data2$activity), "activity"] <- "Sitting"
data2[grep("5", data2$activity), "activity"] <- "Standing"
data2[grep("6", data2$activity), "activity"] <- "Laying"

###########################################################
## Format labels
names(data2) <- gsub("()", "", names(data2), fixed = TRUE)
names(data2) <- gsub("tBody", "time.body", names(data2))
names(data2) <- gsub("fBody", "fft.body", names(data2))
names(data2) <- gsub("Acc", ".acceleration", names(data2))
names(data2) <- gsub("tGravity", "time.gravity", names(data2))
names(data2) <- gsub("Jerk", ".jerk", names(data2))
names(data2) <- gsub("bodyGyro", "body.gyro", names(data2))
names(data2) <- gsub("Mag", ".magnitude", names(data2))
names(data2) <- gsub("Freq", ".frequency", names(data2))
names(data2) <- gsub("Body", ".body", names(data2))
names(data2) <- gsub("Gyro", ".gyro", names(data2))

###########################################################
## Display average
data3 <- group_by(data2, subject, activity)
data3 <- summarise_each(data3, funs(mean))
write.table(data3, file = "tidy.txt", row.names=FALSE)