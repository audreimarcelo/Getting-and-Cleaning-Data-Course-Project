## 0. Downloading and unzipping dataset

# Downloading dataset (Baixar o arquivo para a pasta criada)
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory (Extrair o arquivo zipado)
unzip(zipfile="./data/Dataset.zip",exdir="./data")


## 1. Merges the training and the test sets to create one data set
# Lendo os arquivos, atribuindo nomes para variáveis e mesclando os arquivos.
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c("activityId","activityType")

merge_train <- cbind(x_train, y_train, subject_train)
merge_test <- cbind(x_test, y_test, subject_test)
AllData <- rbind(merge_train, merge_test)


## 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement. (Extrair somente média e desvio padrão)

colNames <- colnames(AllData)

mean_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                )

AllMeanStd <- AllData[ , mean_std == TRUE]

  
## 3. Uses descriptive activity names to name the activities in the data set.
# (Utilizar nomes de atividades descritivos nos nomes das atividades)
AllActivityNames <- merge(AllMeanStd, activityLabels,
                                  by='activityId',
                                  all.x=TRUE)
 

##### 4. Appropriately labels the data set with descriptive variable names.
# Done (Colocar rótulos apropriados nos dados com nomes descritivos. Feito 1,2,3)

## 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
# (Criar uma segunda e independente série de dados com a média de cada variável)

TidyData <- aggregate(. ~subjectId + activityId, AllActivityNames, mean)
TidyData <- TidyData[order(TidyData$subjectId, TidyData$activityId),]
write.table(TidyData, "TidyData.txt", row.name=FALSE)


  
  
  
