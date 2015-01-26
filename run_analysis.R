# Step1. Merges the training and the test sets to create one data set. It also includes Step 4.
trainingData<-read.table("./data/train/X_train.txt")
str(trainingData)# 7352 obd. of 561 variables
trainingLabels<-read.table("./data/train/Y_train.txt")
str(trainingLabels)#7352 obs. of 1 variable
names(trainingLabels)<-"Label"
trainingSubjects<-read.table("./data/train/subject_train.txt")
str(trainingSubjects)#7352obs. of 1 variable
names(trainingSubjects)<-"Subject"

testData<-read.table("./data/test/X_test.txt")
str(testData)# 7352 obd. of 561 variables
testLabels<-read.table("./data/test/Y_test.txt")
str(testLabels)#7352 obs. of 1 variable
names(testLabels)<-"Label"
testSubjects<-read.table("./data/test/subject_test.txt")
str(testSubjects)#7352obs. of 1 variable
names(testSubjects)<-"Subject"

joinData<-rbind(testData,trainingData)
features<-read.table("./data/features.txt") # step 4!
names(joinData)<-features$V2 # step 4 - Appropriately labels the data set with descriptive variable names. 
joinLabel<-rbind(testLabels,trainingLabels)
joinSubjects<-rbind(testSubjects,trainingSubjects)
dataset<-cbind(joinSubjects,joinLabel,joinData)
write.table(dataset, "merged_data.txt")
## Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 

meanVector<-grepl("mean", names(dataset), ignore.case = T)
stdVector<- grepl("std", names(dataset), ignore.case = T)
rawSelector<- meanVector + stdVector #vector that has a 1 if the corresponding index in names(dataset) contains "mean or "std"
rawSelectorIndex<-unlist(as.matrix(sort.int(rawSelector, index.return=TRUE))[2])# expression that returns the ordered indexes of the vector http://joelgranados.com/2011/03/01/r-finding-the-ordering-index-vector/
numberOfzeros<-length(rawSelector)-sum(rawSelector)
finalSelector<-rawSelectorIndex[(numberOfzeros+1):length(rawSelectorIndex)] #filters indexes for elements = 1 
fy<-subset(dataset,select = finalSelector) # subsets columns with "std" or "mean" in their variable names

# Step3. Uses descriptive activity names to name the activities in 
# the data set

fun<- function (x){
  if (x==1) {
return ("WALKING")}
 else if (x==2) {
  return("WALKING_UPSTAIRS")}
 else if (x==3) {
  return("WALKING_DOWNSTAIRS")}
 else if (x==4) {
  return("SITTING")}
 else if (x==5) {
  return("STANDING")}
 else if (x==6) {
  return("LAYING")}
}
dataLabelDescription<-sapply(fy$Label, fun)
fy$Label <- dataLabelDescription
fy$Subject <-dataset$Subject

# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
library(dplyr)
d<-fy %>% group_by(Subject,Label) %>% summarise_each(funs(mean)) %>% arrange(Subject)
write.table(fy, "data_with_means.txt")
