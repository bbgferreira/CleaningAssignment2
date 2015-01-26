The code in run_anaysis.R starts with 2 data sets: test and train and transforms them in a merge tidy data set. 

1. In step 1, we merge the training and the test data set. Str() function is used to determine to help determin how the data frames will be merged.
2. We use grepl() to produce a vector which will be used select (from the previous data frame) only the variables that include the expressions "mean" or "std".
3. We code the Label column by it's corresponding meaning: "Walking", "Walking_upstairs", etc. The description is defined in activity.txt
4.  We use the dplyr to perform group_by and summarize our final data set, for each activity and subject. 