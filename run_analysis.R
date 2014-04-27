require(plyr)
library('plyr')

get_data <- function(which_data = 'test'){
  w <- which_data
  folder_name <- "UCI HAR Dataset/"
  
  ##get path of the measurement file
  X_path <- paste0(folder_name, w, "/X_", w, ".txt")
  
  #get path of the activity label
  y_path <- paste0(folder_name, w, "/Y_", w, ".txt")
  
  #get users identification
  user_path <- paste0(folder_name, w, "/subject_", w, ".txt")
  user <- read.table(user_path, header=F, sep=" ")
  colnames(user) <- 'subject'
  
  X <- read.table(X_path, header=F)
  y <- read.table(y_path, header=F, sep=" ")
  
  
  x_colnames <- read.csv2(paste0(folder_name, "features.txt"), sep=" ", header=F)
  colnames(X) <- x_colnames[,2]
  colnames(y) <- 'y'
  
  data.frame(y=y, subject=user, X)
}

test_set <- get_data("test")
train_set <- get_data("train")
df <- rbind(test_set, train_set)
print(df[1:6, 1:4])

idx <- grep('mean[^F]|std', colnames(df), ignore.case=T)

df2 <- df[, c(1, 2, idx)]

### 3) and 4) 
### Transform y label 
activity <- read.csv('UCI HAR Dataset/activity_labels.txt',
                     sep = ' ', header = F)
df2$y <- activity[df2$y, 2]
colnames(df2)[1] <- 'activity'

### 5) 

df3 <- ddply(df2, .(subject, activity), colwise(function(x) mean(x, na.rm=T)))


write.csv(df3, file = 'tidydata.csv')