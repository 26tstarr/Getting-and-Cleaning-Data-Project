# Getting-and-Cleaning-Data-Project
Week 4 Project Assignment

Start by Loading the Activity and Feature names into data frames

Import the test data, including X_Test.txt (561-feature Vector), y_test.txt (the Activity Codes), subject_test.txt (the list of Subjects).

Assuming that these are all in the same order (with no IDs or Keys seems the only reasonable assumption) use merge to add the Subject and Activity Keys to the 561-feature Vector

Merge in the Activity descriptions and use melt to 'unpivot' the 561 columns into rows so that there's only one observation per row.

Assign the Feature Descriptions

Repeat the previous 3 steps for Train data

Use rbind to combine the Train and Test data, filtering out only Features with either "mean" or "std" in the name

Reorder the columns for presentation

Generate averages in AvgData
