
 The purpose of this document is to describe the script used to process a raw set of fitness data
 and create from it a tidy data set.

 The source of the data is:
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 A description of the experimental design and the original dataset is available here:
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

 I would like to thank the authors of this work for sharing their work and results.

 Citation:
 Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity 
 Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International
 Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


 The data was prepared using a script named runAnalysis.R, available in the githib repository at:
 https://github.com/n2c1j1/GetAndCleanCourseProject.

 The processing details are as follows:

 The raw data was retrieved into a zipped file fitness.zip and unpacked into a directory 
 "UCI HAR Dataset". This directory name was simplified to ucihardataset for ease of manipulation. This
 raw data fetch is only necessary the first time the script is run. Thereafter the script can simply 
 use the data in the ucihardataset directory.

 The contents of the ucihardataset directory are as follows:

 RAW DATA ORGANIZATION

 ucihardataset
  _____|_______________________________________________________________________________
 |		|			|	|			|		|	
 README.txt	activity_labels.txt	test	features_info.txt	features.txt	train
                 			|						|
 ______________________________________|		________________________________|	
 |		|	   |	|			|		|	  |	|
 X_test.txt	y_test.txt |	subject_test.txt	X_test.txt	y_test.txt|	subject_test.txt
			   Inertial Signals					  Inertial Signals

 README.txt			a description of the experiment

 activity_labels.txt		an integer to text conversion for the 6 basic activity types under
				consideration: 
				1 WALKING
				2 WALKING_UPSTAIRS
				3 WALKING_DOWNSTAIRS
				4 SITTING
				5 STANDING
				6 LAYING

 features.txt			List of all the raw and derived measurements recorded for each 
				subject+activity observation.
 features_info.txt		More information about the variables in the feature list

 test				directory containing observations for the test subjects
 train				directory containing observations for the training subjects

				The subjects were randomly divided into the test and training groups.
				The measurements were gathered in the same way for each group, so the
				division is arbitrary

 Within the test and train directories:

 X_test.txt			561 columns(as listed in features.txt) of measurements.
 y_test.txt			The activity number corresponding to each row in X_test.txt.
 subject_test.txt		The subject number corresponding to each row in X_test.txt

 TASK SUMMARY

 The task at hand can be summarized this:

 Make a data frame containing the subject column, activity column (as text not numeric) and 
 measurements for each of the test and training datasets.

 Keep only the measurement columns of interest (mean and standard deveiation).
 Combine the test and training data sets
 Calculate averages for each subject, activity and measurement type and output these to a tidy dataset.


 IMPLEMENTATION DETAILS
 1.	Read the measurement names from features.txt
	Eliminate special characters from the measurement names and convert to lower case
	Reduce the curious "BodyBody" strings to simply "body" 
	Filter out names which do not represent "mean" or "std", including meanFreq
 2.	Read the training data (X_test.txt)
	Read the test data
	Keep only the columns corersponding to the chosen mean and std measurement set.
	Concatenate the two sets of data
 3.	Read the raw subject data (subject_test.txt) for both the test and training sets
 	Concatenate these sets in the same order as the measurement data was concatenated
 4.	Read the raw activity data (y_test.txt) for both the test and training sets.
	Concatenate in the same order as the measurement and subject data was concatenated.
	Read the activity labels and convert the activity data frm numerics to readable text.
	Ensure the actvity factor consists of lower case only, no special characters.
 5.	Add the subject and activity data to the left of the measurement dataframe
	Sort the data by subject and activity
 6.	For each subject and activity, calculate the average of each measurement.
	Write a tidy data set file containing these summarized results (tidyproject.txt)





