data = read.csv("dataset.csv", header=TRUE)

data$high_activity = data$adjusted_user_editcount - data$number_of_edits_first_month > 0
sum(data$high_activity) / nrow(data)

set.seed(1)

num.test.examples = 87

in.test <- sample(seq_len(nrow(data)), size = num.test.examples)


train <- data[-in.test,]
test <- data[in.test,]


formula = as.formula(high_activity ~ 
                       first_day_edit + 
                       days_to_first_edit +
                       days_to_last_edit +
                       average_days_since_reg +
                       number_of_edits_first_month +
                       max_edits_per_day +
                       max_activity_day +
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


radial.svm.model = svm(formula, data = train,  kernel="radial")
radial.svm.train.predictions = predict(radial.svm.model)
radial.svm.test.predictions = predict(radial.svm.model,test)
radial.svm.train.error = sum(radial.svm.train.predictions != train$high_activity) / nrow(train)
radial.svm.test.error = sum(radial.svm.test.predictions != test$high_activity) / nrow(test)



########################################################3
library(gbm)
train <- data[-in.test,]
test <- data[in.test,]
train$first_day_edit = as.factor(train$first_day_edit)
test$first_day_edit = as.factor(test$first_day_edit)

train$high_activity = as.integer(train$high_activity)
test$high_activity  = as.integer(test$high_activity)

gbm_model = gbm(formula,
                data = train,
                distribution = "adaboost",
                n.trees = 1500,
                interaction.depth = 15,
                n.minobsinnode = 1,
                shrinkage = 0.01,
                bag.fraction = 0.9,
                cv.folds = 0,
                n.cores = 4,
                train.fraction = 1.0,
                verbose = TRUE)



#predict the holdout data set
gbm.train.predictions = predict(gbm_model,n.trees = 1000 ,type="response")
gbm.test.predictions = predict(gbm_model,test, n.trees = 1000 ,type="response")


gbm.train.error = sum((gbm.train.predictions > 0.5) != train$high_activity) / nrow(train)
gbm.test.error = sum((gbm.test.predictions > 0.5) != test$high_activity) / nrow(test)


AUC.test <- gbm.roc.area(test$high_activity, gbm.test.predictions)

summary(gbm_model)
