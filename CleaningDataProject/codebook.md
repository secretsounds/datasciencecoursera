Codebook Variables:

----------------------------------------------------------------------------------------------------------------------
| Variable name        | Description                                                                                 |
|----------------------|----------------------------------------------------------------------------------------------
|subject               | Subject ID (Persion who performed the activity.) Range is from 1 to 30.                     |
|activity              | Activity name.                                                                              |
|feature_domain        | Time domain signal or frequency domain signal (time or freq).                               |
|feature_instrument    | Instrument (accelerometer or gyroscope).                                                    |
|feature_acceleration  | Acceleration signal type (body or gravity).                                                 |
|feature_variable      | Variable (mean or sd).                                                                      |
|feature_jerk          | Jerk signal.                                                                                |
|feature_magnitude     | Magnitude of the signals calculated using the Euclidean norm.                               |
|feature_axis          | 3-axial signals in the X, Y and Z directions (X, Y, or Z).                                  |
|count                 | Data points Count to compute `average`.                                                     |
|average               | Average of each variable for each activity and each subject.                                |
----------------------------------------------------------------------------------------------------------------------

Dataset Structure:
  

```r
str(tidy_data)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity            : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_domain      : Factor w/ 2 levels "time","frequency": 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_acceleration: Factor w/ 3 levels NA,"body","gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_instrument  : Factor w/ 2 levels "accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ feature_jerk        : Factor w/ 2 levels NA,"jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ feature_magnitude   : Factor w/ 2 levels NA,"magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ feature_variable    : Factor w/ 2 levels "mean","sd": 1 1 1 2 2 2 1 2 1 1 ...
##  $ feature_axis        : Factor w/ 4 levels NA,"x","y","z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count               : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average             : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "feature_domain" "feature_acceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```
