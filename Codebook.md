# CodeBook for _Getting and Cleaning Data_ assignment

This is the CodeBook explaining the steps of the _run\_analysis.R_ file from the programming assignment given by the Coursera course _Getting and Cleaning Data_.

## Prerequisites

1. The dataset must be unzipped in the work directory.

2. The package *plyr* need to be installed. 

```r
require(plyr)
```

```
## Loading required package: plyr
```

```r
library("plyr")
```



## R Setup

The *get\_data* function avoids duplication of code when loading the data in *R*, and it can be used both for loading test and training data. 


```r
get_data <- function(which_data = "test") {
    w <- which_data
    folder_name <- "UCI HAR Dataset/"
    
    ## get path of the measurement file
    X_path <- paste0(folder_name, w, "/X_", w, ".txt")
    
    # get path of the activity label
    y_path <- paste0(folder_name, w, "/Y_", w, ".txt")
    
    # get users identification
    user_path <- paste0(folder_name, w, "/subject_", w, ".txt")
    user <- read.table(user_path, header = F, sep = " ")
    colnames(user) <- "subject"
    
    X <- read.table(X_path, header = F)
    y <- read.table(y_path, header = F, sep = " ")
    
    
    x_colnames <- read.csv2(paste0(folder_name, "features.txt"), sep = " ", 
        header = F)
    colnames(X) <- x_colnames[, 2]
    colnames(y) <- "y"
    
    data.frame(y = y, subject = user, X)
}
```



## Assignment

### Point 1)
Thanks to the above function, appending the test and train sets are three lines. 


```r
test_set <- get_data("test")
train_set <- get_data("train")
df <- rbind(test_set, train_set)
print(df[1:6, 1:4])
```

```
##   y subject tBodyAcc.mean...X tBodyAcc.mean...Y
## 1 5       2            0.2572          -0.02329
## 2 5       2            0.2860          -0.01316
## 3 5       2            0.2755          -0.02605
## 4 5       2            0.2703          -0.03261
## 5 5       2            0.2748          -0.02785
## 6 5       2            0.2792          -0.01862
```

```r

```



### Point 2)
We extract only the mean and standard deviation for each feature. In order to do that we use the *grep* function, filtering away data about frequencies:



```r
idx <- grep("mean[^F]|std", colnames(df), ignore.case = T)
df2 <- df[, c(1, 2, idx)]
```


### Point 3) and 4)
We rename the response label.


```r
activity <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", header = F)
df2$y <- activity[df2$y, 2]
colnames(df2)[1] <- "activity"
```


### Point 5) 

Using the *ddply* function,  we split the data set with the two variables *subject, activity*  and apply the mean function to each column of the splitted _data.frame_.



```r
df3 <- ddply(df2, .(subject, activity), colwise(function(x) mean(x, na.rm = T)))
```


#### Saving the file
We save the data set into the file with the following command.


```r
write.csv(df3, file = "tidydata.csv")
```



