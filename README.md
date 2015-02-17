INTRODUCTION

This repository contains scripts to merge and clean data as part of the Coursera "Getting and Cleaning data" course project. The data represent measures collected from the accelerometers from the Samsung Galaxy S smartphone.

INTRUCTIONS

Steps
1. Clone the present repository
git clone https://github.com/abmoul/Course-Project
2. Change the working directory
cd courseproject
3. Download the data file 
4. Unzip the data file
unzip getdata-projectfiles-UCI\ HAR\ Dataset.zip
5. Run Run_Analysis.R

OUTPUTS

run_analysis.R returns two csv format datasets:

- tidy_dataset.txt: Contains mean and standard deviation for each observation reakted to the training and the testing data;
- tidy_dataset2.txt: Contains tidy data set with the average of each variable for each activity and each subject present in the input.

DESCRIPTION
Run_Analysis.R tests if the input zip file ("UCI HAR Dataset.zip") is present in the current working directory, and if no downloads it using the data source location. The script tries first to download the zip file using the download.file() function, and if it fails uses the 'wget' method.

The codebook describing the dataset can be found here (add link)

