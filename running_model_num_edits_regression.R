rmse <- function(a, b) {
  return (sqrt( mean( (a-b)^2 , na.rm = TRUE ) ))
}


rsquared <- function(val, pred) {
  tot = sum((val-rep(mean(val),length(val)))^2)
  res = sum((val-pred)^2)
  return(1 - res/tot)
}

data = read.csv("rolling_dataset.csv", header=TRUE)


#normalize sentiment scores
data$rel_n1_liu_positive_score     = data$n1_liu_positive_score / data$n1_word_count
data$rel_n1_liu_negative_score     = data$n1_liu_negative_score / data$n1_word_count
data$rel_n1_nrc_anger_score        = data$n1_nrc_anger_score / data$n1_word_count
data$rel_n1_nrc_anticipation_score = data$n1_nrc_anticipation_score / data$n1_word_count
data$rel_n1_nrc_disgust_score      = data$n1_nrc_disgust_score / data$n1_word_count
data$rel_n1_nrc_fear_score         = data$n1_nrc_fear_score / data$n1_word_count
data$rel_n1_nrc_joy_score          = data$n1_nrc_joy_score / data$n1_word_count
data$rel_n1_nrc_negative_score     = data$n1_nrc_negative_score / data$n1_word_count
data$rel_n1_nrc_positive_score     = data$n1_nrc_positive_score / data$n1_word_count
data$rel_n1_nrc_sadness_score      = data$n1_nrc_sadness_score / data$n1_word_count
data$rel_n1_nrc_surprise_score     = data$n1_nrc_surprise_score / data$n1_word_count
data$rel_n1_nrc_trust_score        = data$n1_nrc_trust_score / data$n1_word_count

data$rel_n2_liu_positive_score     = data$n2_liu_positive_score / data$n2_word_count
data$rel_n2_liu_negative_score     = data$n2_liu_negative_score / data$n2_word_count
data$rel_n2_nrc_anger_score        = data$n2_nrc_anger_score / data$n2_word_count
data$rel_n2_nrc_anticipation_score = data$n2_nrc_anticipation_score / data$n2_word_count
data$rel_n2_nrc_disgust_score      = data$n2_nrc_disgust_score / data$n2_word_count
data$rel_n2_nrc_fear_score         = data$n2_nrc_fear_score / data$n2_word_count
data$rel_n2_nrc_joy_score          = data$n2_nrc_joy_score / data$n2_word_count
data$rel_n2_nrc_negative_score     = data$n2_nrc_negative_score / data$n2_word_count
data$rel_n2_nrc_positive_score     = data$n2_nrc_positive_score / data$n2_word_count
data$rel_n2_nrc_sadness_score      = data$n2_nrc_sadness_score / data$n2_word_count
data$rel_n2_nrc_surprise_score     = data$n2_nrc_surprise_score / data$n2_word_count
data$rel_n2_nrc_trust_score        = data$n2_nrc_trust_score / data$n2_word_count

data[is.na(data)] = 0

#remove observations with more than 1000 edits
data = data[data$edits <= 1000,]

sum(data$edits > 0) / nrow(data)



#split dataset into train and test sets
set.seed(1)
############balance the classes by discarding some examples with zero edits
#pos.examples = data[data$edits > 0 ,]
#neg.examples = data[data$edits == 0 ,]
#keep <- sample(seq_len(nrow(neg.examples)), size = nrow(pos.examples))
#data = rbind(pos.examples,neg.examples[keep,])
################################
num.test.examples = ceiling(nrow(data) * 0.2)
in.test <- sample(seq_len(nrow(data)), size = num.test.examples)
train <- data[-in.test,]
test <- data[in.test,]




sum(train$edits > 0) / nrow(train)
sum(test$edits > 0) / nrow(test)

formula = as.formula(edits ~ 
                       (user_age + 
                       ###########################
                       n1_numWeekEdits + 
                       n1_numWeekThanks + 
                       n1_word_count +
                       n1_number_of_comments)^2)
#                        n1_liu_positive_score +
#                        n1_liu_negative_score +
#                        n1_nrc_anger_score +
#                        n1_nrc_anticipation_score +
#                        n1_nrc_disgust_score +
#                        n1_nrc_fear_score +
#                        n1_nrc_joy_score +
#                        n1_nrc_negative_score +
#                        n1_nrc_positive_score +
#                        n1_nrc_sadness_score +
#                        n1_nrc_surprise_score +
#                        rel_n1_liu_positive_score +
#                        rel_n1_liu_negative_score +
#                        rel_n1_nrc_anger_score +
#                        rel_n1_nrc_anticipation_score +
#                        rel_n1_nrc_disgust_score +
#                        rel_n1_nrc_fear_score +
#                        rel_n1_nrc_joy_score +
#                        rel_n1_nrc_negative_score +
#                        rel_n1_nrc_positive_score +
#                        rel_n1_nrc_sadness_score +
#                        rel_n1_nrc_surprise_score +
#                        rel_n1_nrc_trust_score + 
                       ############################
#                        n2_numWeekEdits + 
#                        n2_numWeekThanks + 
#                        n2_word_count +
#                        n2_number_of_comments +
#                        n2_liu_positive_score +
#                        n2_liu_negative_score +
#                        n2_nrc_anger_score +
#                        n2_nrc_anticipation_score +
#                        n2_nrc_disgust_score +
#                        n2_nrc_fear_score +
#                        n2_nrc_joy_score +
#                        n2_nrc_negative_score +
#                        n2_nrc_positive_score +
#                        n2_nrc_sadness_score +
#                        n2_nrc_surprise_score +
#                        n2_nrc_trust_score + 
#                        rel_n2_liu_positive_score +
#                        rel_n2_liu_negative_score +
#                        rel_n2_nrc_anger_score +
#                        rel_n2_nrc_anticipation_score +
#                        rel_n2_nrc_disgust_score +
#                        rel_n2_nrc_fear_score +
#                        rel_n2_nrc_joy_score +
#                        rel_n2_nrc_negative_score +
#                        rel_n2_nrc_positive_score +
#                        rel_n2_nrc_sadness_score +
#                        rel_n2_nrc_surprise_score +
#                        rel_n2_nrc_trust_score)
  
                       



###############################################
glm.model = glm(formula, 
                data = train, 
                family = gaussian)

glm.train.predictions = predict(glm.model)
glm.test.predictions = predict(glm.model,test)

glm.train.error = rmse(train$edits, glm.train.predictions)
glm.test.error = rmse(test$edits, glm.test.predictions)

glm.train.rsquared = rsquared(train$edits, glm.train.predictions)
glm.test.rsquared = rsquared(test$edits, glm.test.predictions)

plot(test$edits, glm.test.predictions, xlim=c(0,1000),ylim=c(0,1000))
abline(0,1)

#################################################################
library(randomForest)

rf.model = randomForest(formula, data=train, ntree=100)

rf.train.predictions = predict(rf.model,train)
rf.test.predictions = predict(rf.model,test)

rf.train.error = rmse(train$edits, rf.train.predictions)
rf.test.error = rmse(test$edits, rf.test.predictions)

rf.train.rsquared = rsquared(train$edits, rf.train.predictions)
rf.test.rsquared = rsquared(test$edits, rf.test.predictions)

plot(test$edits, rf.test.predictions, xlim=c(0,1000),ylim=c(0,1000))
abline(0,1)

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
#train <- data[-in.test,]
#test <- data[in.test,]

set.seed(1345677)
gbm.n.trees = 500
gbm_model = gbm(formula,
                data = train,
                distribution = "gaussian",
                n.trees = gbm.n.trees,
                interaction.depth = 7,
                n.minobsinnode = 1,
                shrinkage = 0.1,
                bag.fraction = 0.75,
                cv.folds = 0,
                n.cores = 4,
                train.fraction = 1.0,
                verbose = TRUE)



#predict the holdout data set
gbm.train.predictions = predict(gbm_model, n.trees = gbm.n.trees ,type="response")
gbm.test.predictions = predict(gbm_model,test, n.trees = gbm.n.trees ,type="response")


gbm.train.error = rmse(train$edits, gbm.train.predictions)
gbm.test.error = rmse(test$edits, gbm.test.predictions)

#AUC.test <- gbm.roc.area(test$high_activity, gbm.test.predictions)

gbm.train.rsquared = rsquared(train$edits, gbm.train.predictions)
gbm.test.rsquared = rsquared(test$edits, gbm.test.predictions)

summary(gbm_model)

plot(test$edits, gbm.test.predictions, xlim=c(0,1000),ylim=c(0,1000))
abline(0,1)


#################################
baseline.train.predictions = (train$n1_numWeekEdits + train$n2_numWeekEdits) * 0.5
baseline.test.predictions = (test$n1_numWeekEdits + test$n2_numWeekEdits) * 0.5
baseline.train.error = rmse(train$edits, baseline.train.predictions)
baseline.test.error = rmse(test$edits, baseline.test.predictions)
baseline.train.rsquared = rsquared(train$edits, baseline.train.predictions)
baseline.test.rsquared = rsquared(test$edits, baseline.test.predictions)
plot(test$edits, baseline.test.predictions, xlim=c(0,1000),ylim=c(0,1000))
abline(0,1)


test.df = data.frame(test$edits, 
                     baseline.test.predictions,
                     glm.test.predictions,
                     rf.test.predictions,
                     gbm.test.predictions)

train.df = data.frame(train$edits, 
                     baseline.train.predictions,
                     glm.train.predictions,
                     rf.train.predictions,
                     gbm.train.predictions)


write.csv(test.df, file="test.regmodel.csv", row.names=FALSE)
write.csv(train.df, file="train.regmodel.csv", row.names=FALSE)
