# Machine Learning Assignment



## Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

##Data

The training data for this project are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

## Loading required libraries and setting seed


```r
library(caret)
library(dplyr)
library(randomForest)

set.seed(77)
```

## Reading training data


```r
trainningData <- read.csv("./pml-training.csv", na.strings = c("NA", "", "#DIV/0!"))
```

## Cleaning training data


```r
naValues <- colSums(is.na(trainningData)) / nrow(trainningData)
mostlyNAs <- names(naValues[naValues > 0.75])
mostlyNACols <- which(naValues > 0.75)

subTrainSet <- trainningData %>% tbl_df %>% sample_n(size = 1000)
# Removing NAs
subTrainSet <- subTrainSet[, -mostlyNACols]

# Removing useless data for prediction
subTrainSet <- subTrainSet[, -grep("cvtd_timestamp",names(subTrainSet))]
subTrainSet <- subTrainSet[, -grep("X|user_name",names(subTrainSet))]
subTrainSet <- subTrainSet[, -nearZeroVar(subTrainSet)]
```


## Listing possible predictors


```r
modelVars <- names(subTrainSet)
modelVarsClasse <- modelVars[-grep("classe", modelVars)]
# Printing
modelVarsClasse
```

```
##  [1] "raw_timestamp_part_1" "raw_timestamp_part_2" "num_window"          
##  [4] "roll_belt"            "pitch_belt"           "yaw_belt"            
##  [7] "total_accel_belt"     "gyros_belt_x"         "gyros_belt_y"        
## [10] "gyros_belt_z"         "accel_belt_x"         "accel_belt_y"        
## [13] "accel_belt_z"         "magnet_belt_x"        "magnet_belt_y"       
## [16] "magnet_belt_z"        "roll_arm"             "pitch_arm"           
## [19] "yaw_arm"              "total_accel_arm"      "gyros_arm_x"         
## [22] "gyros_arm_y"          "gyros_arm_z"          "accel_arm_x"         
## [25] "accel_arm_y"          "accel_arm_z"          "magnet_arm_x"        
## [28] "magnet_arm_y"         "magnet_arm_z"         "roll_dumbbell"       
## [31] "pitch_dumbbell"       "yaw_dumbbell"         "total_accel_dumbbell"
## [34] "gyros_dumbbell_x"     "gyros_dumbbell_y"     "gyros_dumbbell_z"    
## [37] "accel_dumbbell_x"     "accel_dumbbell_y"     "accel_dumbbell_z"    
## [40] "magnet_dumbbell_x"    "magnet_dumbbell_y"    "magnet_dumbbell_z"   
## [43] "roll_forearm"         "pitch_forearm"        "yaw_forearm"         
## [46] "total_accel_forearm"  "gyros_forearm_x"      "gyros_forearm_y"     
## [49] "gyros_forearm_z"      "accel_forearm_x"      "accel_forearm_y"     
## [52] "accel_forearm_z"      "magnet_forearm_x"     "magnet_forearm_y"    
## [55] "magnet_forearm_z"
```

## Building a Random Forest model


```r
cleanedTrainningData <- trainningData[, modelVars]
modelFit <- randomForest(classe ~., data = cleanedTrainningData, type = "class")
```

## Getting Error Estimates


```r
predTrainning <- predict(modelFit, newdata = trainningData)
confusionMatrix(predTrainning, trainningData$classe)$table
```

```
##           Reference
## Prediction    A    B    C    D    E
##          A 5580    0    0    0    0
##          B    0 3797    0    0    0
##          C    0    0 3422    0    0
##          D    0    0    0 3216    0
##          E    0    0    0    0 3607
```

# Predicting using the Test data


```r
# Loading test data
testingSet <- read.csv("./pml-testing.csv", na.strings=c("NA", "", "#DIV/0!"))

# Running predictor
predictionResult <- predict(modelFit, newdata = testingSet, type = "class")

# Printing prediction result
print(predictionResult)
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

## Conclusion

Random forests worked very well when handling large number of inputs, especially when the interactions between variables are unknown. Also, Confusion Matrix achieved near 100% of accuracy.
