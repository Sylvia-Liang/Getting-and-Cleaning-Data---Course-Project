train=read.table("~/UCI HAR Dataset/train/X_train.txt");
test=read.table("~/UCI HAR Dataset/test/X_test.txt");
fulldata = rbind(train,test)


fullfeatures=read.table("features.txt");
features = as.character(fullfeatures$V2);
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

tidyname = vector[num];
tidydata = fulldata[num];
names(tidydata) = tidyname;


rawtrainlabel = read.table("~/UCI HAR Dataset/train/y_train.txt");
rawtestlabel = read.table("~/UCI HAR Dataset/test/y_test.txt");
fulllabel = rbind(rawtrainlabel,rawtestlabel);
activity = read.table("activity_labels.txt");
activitylabel = factor(as.numeric(fulllabel$V1),labels=as.character(activity$V2));

trainsubject = read.table("~/UCI HAR Dataset/train/subject_train.txt");
testsubject = read.table("~/UCI HAR Dataset/test/subject_test.txt");
subject = cbind(t(as.numeric(trainsubject$V1)),t(as.numeric(testsubject$V1)));

newdata = cbind(t(subject),activitylabel,tidydata);
complete=aggregate(tidydata,by=list(t(subject),activitylabel),FUN="mean")
names(complete)[c(1,2)]=c("Subject","Activity");
write.table(complete,"TidyData.txt");