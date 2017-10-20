# Leverage Machine Learning Tools to Properly Classify Normal vs Murmur Heart Sounds

library(e1071)
library(plyr)
library(caret)

# Machine Learning using KNN...

#Create training and test set using knn
library(class)
set.seed(3465)
ind <- sample(2, nrow(hbeat), replace=TRUE, prob=c(0.65,0.35))
# use the array, ind, to define the training and test sets
hbTrain <- hbeat[ind==1, c(1:27)]
hbTest <- hbeat[ind==2, c(1:27)]
hbTrain <- as.data.frame(hbTrain)
hbTest <- as.data.frame(hbTest)
hbTrainLabels <- hbeat[ind==1, 28]
hbTestLabels <- hbeat[ind==2,28]
hbeat_pred <- knn(train = hbTrain, test = hbTest, cl = hbTrainLabels, k=3)

###KNN using zX (no. of zero crossings) and sh (Shannon Entropy)
library (gmodels)
KNN_xtab <- CrossTable(x=hbTestLabels, y=hbeat_pred, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)

####Optimize knn with caret.

library(caret)
ctrl <- trainControl(method="repeatedcv",repeats = 3)
knnFit <- train(y = hbTrainLabels, x = hbTrain, method = "knn", trControl = ctrl, tuneLength = 15)
plot(knnFit)
knnFit
PredCaret <- predict(knnFit, newdata = hbTest)
CrossTable(x=hbTestLabels, y=PredCaret, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)


####SVM
#Create New Train and Test Sets
#Drop the label column from the data set, keeping label2. Drop non-parametric columns
#AllTrn <-  hbeat[ind==1,c(1:2,7:10,12:13,22,24:25,27,28)]
#AllTest <- hbeat[ind==2,c(1:2,7:10,12:13,22,24:25,27,28)]
AllTrn <-  hbeat[ind==1,c(1:28)]
AllTest <- hbeat[ind==2,c(1:28)]


#Determine gamma and cost... first by guessing 
set.seed(3465)
ctrlSVM <- tune.control(cross = 10)
SVMopt <- tune(svm, label2 ~ ., data = AllTrn, kernel = "radial", ranges = list(cost = c(1,10,100,1000), gamma = c(0.00001,.0001, 0.1, 1)),tunecontrol = ctrlSVM, type = "C-classification")
plot(SVMopt)
SVMopt

#Run with cost=1000 gamma=0.0001
SVM <- svm(label2 ~ ., data = AllTrn, kernel = "radial", gamma = 0.0001, cost = 1000, type = "C-classification")
PredSVM <- predict(SVM, newdata = AllTest)
CrossTable(x=AllTest$label2, y=PredSVM, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)

PredSVM
plot(SVMopt)

#Tried lower values of cost and gamma

SVMopt2 <- tune(svm, label2 ~ ., data = AllTrn, kernel = "radial", ranges = list(cost = c(1,10,100), gamma = c(0.00001,.0001, 0.1)),
                tunecontrol = ctrlSVM, type = "C-classification")
SVMopt2
plot(SVMopt2)

#cost = 10, gamma  0.1
SVM2 <- svm(label2 ~ ., data = AllTrn, kernel = "radial", gamma = .1, cost = 10, type = "C-classification")
PredSVM2 <- predict(SVM2, newdata = AllTest)
CrossTable(x=AllTest$label2, y=PredSVM2, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)


#Search to full range of cost and gamma tried so far. "best performance" (Misclassification rate?) is down to 0.17
SVMopt3 <- tune(svm, label2 ~ ., data = AllTrn, kernel = "radial", ranges = list(cost = c(0.1, 0.5,1, 10, 100), gamma = c(0.001, 0.005, 0.01, 0.1, 1)),tunecontrol = ctrlSVM, type = "C-classification")
SVMopt3
plot(SVMopt3)

#cost = 100, gamma = .001
SVM3 <- svm(label2 ~ ., data = AllTrn, kernel = "radial", gamma =.001, cost = 100, type = "C-classification")
PredSVM3 <- predict(SVM3, newdata = AllTest)
CrossTable(x=AllTest$label2, y=PredSVM3, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)


####RandomForest with all parameters
#Drop the label column from the data set, keeping label2
set.seed(3465)
#Create New Train and Test Sets
#Drop the label column from the data set, keeping label2. Drop non-parametric columns

library(randomForest)
RForest <- randomForest(label2 ~ ., data = AllTrn, importance = TRUE)
RforPred <- predict(RForest, newdata = AllTest)
CrossTable(x=AllTest$label2, y=RforPred, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)
RForest$importance

####Optimize RandomForest using caret.

#The number of parameters used per tree doesn't much matter.
AllTrnX  <- AllTrn [,1:27]
AllTrnY  <- AllTrn [,28]
AllTestX  <- AllTest [,1:27]
AllTestY  <- AllTest [,28]
ctrl <- trainControl(method="repeatedcv",repeats = 4)
RForFit <- train(y = AllTrnY , x = AllTrnX , method = "rf", trControl = ctrl, tuneLength = 15)
plot(RForFit)
RForFitB
PredCaret <- predict(RForFit, newdata = AllTestX)
CrossTable(x=AllTestY, y=PredCaret, prop.chisq=F, prop.r=F, prop.c=F, prop.t=F)
