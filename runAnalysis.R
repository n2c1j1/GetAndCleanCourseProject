##############################################################################
# This script named runAnalysis.R, is available in the githib repository at:
# https://github.com/n2c1j1/GetAndCleanCourseProject.
#
# The purpose of the script is to transform a raw data set into a tidy data set 
# comprising the averages of a set of measurements per participating humand and activity.
#
# A full description is available in the accompanying README file.
#
# The source of the data used for this project is:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# A description of the experimental design and the original dataset is available here:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# I would like to thank the authors of this work for sharing their work and results.
#
# Citation:
# Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity
# Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International
# Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
#
#########################################################################################################


runAnalysis<- function() {
  fitzip = "fitness.zip"
  #if data file has not yet been downloaded, fetch it
  if (!file.exists(fitzip)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile=fitzip,method="curl")
    unzip(fitzip)
    file.rename("UCI\ HAR\ Dataset","ucihardataset")
  }
  #read measurement names
  rmeasnames <- read.table("ucihardataset/features.txt")
  rmeasnames$V2 <- gsub("-","",rmeasnames$V2)
  rmeasnames$V2 <- gsub("\\(\\)","",rmeasnames$V2)
  rmeasnames$V2 <- gsub("BodyBody","body",rmeasnames$V2)
  
  # find all the names with mean and std
  meanl <- grepl("mean", rmeasnames$V2 )
  stdl <- grepl("std", rmeasnames$V2 )
  meanandstdl <- meanl |stdl
  lessnames <- rmeasnames$V2[meanandstdl]
  
  # remove all "meanFreq names
  mfreq <- grepl("meanFreq",lessnames)
  mynames <- lessnames[!mfreq]
  
  #--------------------------------------------------------------------------
  # read raw test data
  rtestdat <- read.table("ucihardataset/test/X_test.txt")
  rtraindat <- read.table("ucihardataset/train/X_train.txt")
  # add column names
  names(rtestdat) <- rmeasnames$V2
  names(rtraindat) <- rmeasnames$V2
  
  #just keep the columns regarding mean and std deviation
  filtestdat <- rtestdat[,c(mynames)]
  filtraindat <-rtraindat[,c(mynames)]
  
  #concatenate the two sets of data
  totdat <- rbind(filtestdat,filtraindat)
  names(totdat) <- tolower(names(totdat))
  
   # read raw subject data
  rtestsub <- read.table("ucihardataset/test/subject_test.txt")
  rtrainsub <- read.table("ucihardataset/train/subject_train.txt")
  
  #concatenate the test and training subjects
  subjects <- rbind(rtestsub,rtrainsub)
  
  # read raw activity data
  rtestact <- read.table("ucihardataset/test/y_test.txt")
  rtrainact <- read.table("ucihardataset/train/y_train.txt")
  
  #concatenate the test and training activities
  acts <- rbind(rtestact,rtrainact)
  acts$V1 <- factor(acts$V1)
  
  #convert activity from digits to meaningful descriptions
  activities = read.table("ucihardataset/activity_labels.txt")
  activities$V2 <- tolower(activities$V2)
  gsub("_","",activities$V2)
  
  levels(acts$V1) <- activities$V2
 
  
  # now we need to add the subject and activity columns to the measurement data
  
  subdata <- cbind(subjects,acts)
  names(subdata) <- c("subject","activity")
  combdata <- cbind(subdata,totdat)
 
  #sort the combined data set by subject and activity
  sortdata <- combdata[order(combdata$subject,combdata$activity),]
  
  #for each subject, for each activity, subset the df of measurements
  #get average of each column
  # store in vector...subject activity, averages
  #add vector to averages data frame
  
  results_df = NULL
  subject = NULL
  activity = NULL
  
  for (subj in 1:30){
    for (act in activities$V2) {
      subject = append(subject,subj)
      activity <- append(activity,act)
      mydata <- subset(sortdata,sortdata$subject == subj & 
                         sortdata$activity == act)
      avdata <- apply(mydata[3:ncol(mydata)],2,mean)
      results_df <- rbind(results_df,avdata)       
    }
  }
  
  tmp1 <- cbind(subject,activity)
  final_df <- cbind(tmp1,results_df)
  
  names(final_df) <- names(sortdata)
  
  # write final data set to a file
  write.table(final_df,file="tidyproject.txt",row.names=FALSE)

}

