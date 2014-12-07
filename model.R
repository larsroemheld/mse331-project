setwd('/Users/lars/Documents/OfficeFiles/Uni/2014F_MS&E 331 Computational Social Science/project');

data = read.csv("dataset.csv", header=TRUE)

data$high_activity = data$adjusted_user_editcount - data$number_of_edits_first_month > 0
sum(data$high_activity) / nrow(data)

# Normalize all sentiment scores:
# input: count of sentimental words
# output: share of sentimental words in total wordcount
data$liu_positive_score = data$liu_positive_score / data$word_count
data$liu_negative_score = data$liu_negative_score / data$word_count
data$nrc_anger_score = data$nrc_anger_score / data$word_count
data$nrc_anticipation_score = data$nrc_anticipation_score / data$word_count
data$nrc_disgust_score = data$nrc_disgust_score / data$word_count
data$nrc_fear_score = data$nrc_fear_score / data$word_count
data$nrc_joy_score = data$nrc_joy_score / data$word_count
data$nrc_negative_score = data$nrc_negative_score / data$word_count
data$nrc_positive_score = data$nrc_positive_score / data$word_count
data$nrc_sadness_score = data$nrc_sadness_score / data$word_count
data$nrc_surprise_score = data$nrc_surprise_score / data$word_count
data$nrc_trust_score = data$nrc_trust_score / data$word_count


set.seed(1)

num.test.examples = floor(nrow(data) * 0.1);

in.test <- sample(seq_len(nrow(data)), size = num.test.examples)

train <- data[-in.test,]
test <- data[in.test,]


formula = as.formula(high_activity ~ 
                       number_of_edits_first_month +
                       max_edits_per_day +
                       month +
                       #################SENTIMENT FEATURES
                       word_count +
                       number_of_comments +
                       liu_positive_score +
                       liu_negative_score +
                       nrc_anger_score +
                       nrc_anticipation_score +
                       nrc_disgust_score +
                       nrc_fear_score +
                       nrc_joy_score +
                       nrc_negative_score +
                       nrc_positive_score +
                       nrc_sadness_score +
                       nrc_surprise_score +
                       nrc_trust_score)


###############################################
glm.model = glm(formula, 
                data = train, 
                family = binomial)

glm.train.predictions = predict(glm.model) > 0
glm.test.predictions = predict(glm.model,test) > 0

glm.train.error = sum(glm.train.predictions != train$high_activity) / nrow(train)
glm.test.error = sum(glm.test.predictions != test$high_activity) / nrow(test)

glm.test.TP = sum(glm.test.predictions == TRUE & test$high_activity == TRUE)
glm.test.TN = sum(glm.test.predictions == FALSE & test$high_activity == FALSE)
glm.test.FP = sum(glm.test.predictions == TRUE & test$high_activity == FALSE)
glm.test.FN = sum(glm.test.predictions == FALSE & test$high_activity == TRUE)
glm.test.sens = glm.test.TP / (glm.test.TP + glm.test.FN)
glm.test.spec = glm.test.TN / (glm.test.FP + glm.test.TN)


#glm.train.error = sqrt(sum((glm.train.predictions - train$high_activity)^2) / nrow(train))
#glm.test.error = sqrt(sum((glm.test.predictions - test$high_activity)^2) / nrow(test))
#plot(glm.train.predictions, train$high_activity)
#plot(glm.test.predictions, test$high_activity)

#################################################################
library(e1071)

train <- data[-in.test,]
test <- data[in.test,]
train$high_activity = as.factor(train$high_activity)
test$high_activity  = as.factor(test$high_activity)

linear.svm.model = svm(formula, data = train,  kernel="linear")
linear.svm.train.predictions = predict(linear.svm.model)
linear.svm.test.predictions = predict(linear.svm.model,test)
linear.svm.train.error = sum(linear.svm.train.predictions != train$high_activity) / nrow(train)
linear.svm.test.error = sum(linear.svm.test.predictions != test$high_activity) / nrow(test)

linear.svm.test.TP = sum(linear.svm.test.predictions == TRUE & test$high_activity == TRUE)
linear.svm.test.TN = sum(linear.svm.test.predictions == FALSE & test$high_activity == FALSE)
linear.svm.test.FP = sum(linear.svm.test.predictions == TRUE & test$high_activity == FALSE)
linear.svm.test.FN = sum(linear.svm.test.predictions == FALSE & test$high_activity == TRUE)
linear.svm.test.sens = linear.svm.test.TP / (linear.svm.test.TP + linear.svm.test.FN)
linear.svm.test.spec = linear.svm.test.TN / (linear.svm.test.FP + linear.svm.test.TN)



radial.svm.model = svm(formula, data = train,  kernel="radial")
radial.svm.train.predictions = predict(radial.svm.model)
radial.svm.test.predictions = predict(radial.svm.model,test)
radial.svm.train.error = sum(radial.svm.train.predictions != train$high_activity) / nrow(train)
radial.svm.test.error = sum(radial.svm.test.predictions != test$high_activity) / nrow(test)

radial.svm.test.TP = sum(radial.svm.test.predictions == TRUE & test$high_activity == TRUE)
radial.svm.test.TN = sum(radial.svm.test.predictions == FALSE & test$high_activity == FALSE)
radial.svm.test.FP = sum(radial.svm.test.predictions == TRUE & test$high_activity == FALSE)
radial.svm.test.FN = sum(radial.svm.test.predictions == FALSE & test$high_activity == TRUE)
radial.svm.test.sens = radial.svm.test.TP / (radial.svm.test.TP + radial.svm.test.FN)
radial.svm.test.spec = radial.svm.test.TN / (radial.svm.test.FP + radial.svm.test.TN)





########################################################3
library(gbm)
train <- data[-in.test,]
test <- data[in.test,]
train$first_day_edit = as.factor(train$first_day_edit)
test$first_day_edit = as.factor(test$first_day_edit)

train$high_activity = as.integer(train$high_activity)
test$high_activity  = as.integer(test$high_activity)


set.seed(1345677)
gbm_model = gbm(formula,
                data = train,
                distribution = "adaboost",
                n.trees = 1500,
                interaction.depth = 15,
                n.minobsinnode = 1,
                shrinkage = 0.01,
                bag.fraction = 0.75,
                cv.folds = 0,
                n.cores = 4,
                train.fraction = 1.0,
                verbose = TRUE)



#predict the holdout data set
gbm.train.predictions = predict(gbm_model,n.trees = 1000 ,type="response")
gbm.test.predictions = predict(gbm_model,test, n.trees = 1000 ,type="response")


gbm.train.error = sum((gbm.train.predictions > 0.5) != train$high_activity) / nrow(train)
gbm.test.error = sum((gbm.test.predictions > 0.5) != test$high_activity) / nrow(test)

gbm.test.TP = sum(gbm.test.predictions > 0.5 & test$high_activity == 1)
gbm.test.TN = sum(gbm.test.predictions < 0.5 & test$high_activity == 0)
gbm.test.FP = sum(gbm.test.predictions > 0.5 & test$high_activity == 0)
gbm.test.FN = sum(gbm.test.predictions < 0.5 & test$high_activity == 1)
gbm.test.sens = gbm.test.TP / (gbm.test.TP + gbm.test.FN)
gbm.test.spec = gbm.test.TN / (gbm.test.FP + gbm.test.TN)




AUC.test <- gbm.roc.area(test$high_activity, gbm.test.predictions)

summary(gbm_model)
