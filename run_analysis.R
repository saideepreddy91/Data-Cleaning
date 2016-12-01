rm(list=ls(all=TRUE))
# Read all data required----
train_x=read.table("train/X_train.txt",header=F)
train_y=read.table("train/y_train.txt",header=F)


test_x=read.table("test/X_test.txt",header=F)
test_y=read.table("test/y_test.txt",header=F)

features=read.table("features.txt",header=F)
activity_labels=read.table("activity_labels.txt",header=F)
subject_train=read.table("train/subject_train.txt",header=F)
subject_test=read.table("test/subject_test.txt",header=F)


trainset=train_x
testset=test_x
trainset$label=train_y
testset$label=test_y


mergelabel=rbind(train_y,test_y)


#duprows <- rownames(trainset) %in% rownames(testset)
# Descriptive activity names----
train_y$V1[train_y$V1=="1"]="WALKING"
train_y$V1[train_y$V1=="2"]="WALKING_UPSTAIRS"
train_y$V1[train_y$V1=="3"]="WALKING_DOWNSTAIRS"
train_y$V1[train_y$V1=="4"]="SITTING"
train_y$V1[train_y$V1=="5"]="STANDING"
train_y$V1[train_y$V1=="6"]="LAYING"

test_y$V1[test_y$V1=="1"]="WALKING"
test_y$V1[test_y$V1=="2"]="WALKING_UPSTAIRS"
test_y$V1[test_y$V1=="3"]="WALKING_DOWNSTAIRS"
test_y$V1[test_y$V1=="4"]="SITTING"
test_y$V1[test_y$V1=="5"]="STANDING"
test_y$V1[test_y$V1=="6"]="LAYING"

# Descriptive variable names-----

merge_label_descriptive=rbind(train_y,test_y)
names(merge_label_descriptive)="label_descriptive"

mergedata=rbind(train_x,test_x)
names(mergedata)=features$V2

#mergelabel=rbind(train_y,test_y)
step1data=mergedata

step1data$label=merge_label_descriptive
# Extract those with mean and std------

step2data_mean=mergedata[ , grepl( "mean" , names( mergedata ) ) ]
step2data_std=mergedata[ , grepl( "std" , names( mergedata ) ) ]

step2data=cbind(step2data_mean,step2data_std)

# Tidy data--------

step2data=cbind(step2data,merge_label_descriptive)

subject_merge=rbind(subject_train,subject_test)
names(subject_merge)="subject"

step2data=cbind(step2data,subject_merge)

tidydata=step2data

final_data=aggregate(tidydata[, 1:79], list(tidydata$subject,tidydata$label_descriptive), mean)
