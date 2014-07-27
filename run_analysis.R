#extract data from text file
train=read.table("~/UCI HAR Dataset/train/X_train.txt");
test=read.table("~/UCI HAR Dataset/test/X_test.txt");
#Merges the training and the test sets to create one data set
fulldata = rbind(train,test)

#extract features from text file
fullfeatures=read.table("features.txt");
features = as.character(fullfeatures$V2);

#Extracts only the measurements on the mean and standard deviation for each measurement
no = 0;
num = numeric();
colnum = 1;
for (colnum in 1:length(vector)){
    #split = unlist(strsplit(vector[colnum],"-")); 
    #temp = sum(split == "mean()") + sum(split == "std()");
    if (!is.na(grep("mean()",vector[colnum],fixed=T)||grep("std()",vector[colnum],fixed=T))){
        no = no + 1;
        num[no] = colnum;
    }
    colnum = colnum + 1;
    
}
#Appropriately labels the data set with descriptive variable names
tidyname = vector[num];
tidydata = fulldata[num];
names(tidydata) = tidyname;

#extract and match the activity label
#Uses descriptive activity names to name the activities in the data set
rawtrainlabel = read.table("~/UCI HAR Dataset/train/y_train.txt");
rawtestlabel = read.table("~/UCI HAR Dataset/test/y_test.txt");
fulllabel = rbind(rawtrainlabel,rawtestlabel);
activity = read.table("activity_labels.txt");
activitylabel = factor(as.numeric(fulllabel$V1),labels=as.character(activity$V2));

#extract and match the identifier of subject
trainsubject = read.table("~/UCI HAR Dataset/train/subject_train.txt");
testsubject = read.table("~/UCI HAR Dataset/test/subject_test.txt");
subject = cbind(t(as.numeric(trainsubject$V1)),t(as.numeric(testsubject$V1)));

#Creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject
newdata = cbind(t(subject),activitylabel,tidydata);
complete=aggregate(tidydata,by=list(t(subject),activitylabel),FUN="mean")
names(complete)[c(1,2)]=c("Subject","Activity");
write.table(complete,"TidyData.txt");