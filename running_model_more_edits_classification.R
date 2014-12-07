
data = read.csv("rolling_dataset.csv", header=TRUE)

data$user_id = NULL
data$edits_num = data$edits
data$edits = as.factor(data$edits - data$n1_numWeekEdits > 0)
# LR: > 0 implies "is it greater". Replace with sigma for threshold analysis.


#normalize sentiment scores
data$n1_liu_positive_score     = data$n1_liu_positive_score / data$n1_word_count
data$n1_liu_negative_score     = data$n1_liu_negative_score / data$n1_word_count
data$n1_nrc_anger_score        = data$n1_nrc_anger_score / data$n1_word_count
data$n1_nrc_anticipation_score = data$n1_nrc_anticipation_score / data$n1_word_count
data$n1_nrc_disgust_score      = data$n1_nrc_disgust_score / data$n1_word_count
data$n1_nrc_fear_score         = data$n1_nrc_fear_score / data$n1_word_count
data$n1_nrc_joy_score          = data$n1_nrc_joy_score / data$n1_word_count
data$n1_nrc_negative_score     = data$n1_nrc_negative_score / data$n1_word_count
data$n1_nrc_positive_score     = data$n1_nrc_positive_score / data$n1_word_count
data$n1_nrc_sadness_score      = data$n1_nrc_sadness_score / data$n1_word_count
data$n1_nrc_surprise_score     = data$n1_nrc_surprise_score / data$n1_word_count
data$n1_nrc_trust_score        = data$n1_nrc_trust_score / data$n1_word_count

data$n2_liu_positive_score     = data$n2_liu_positive_score / data$n2_word_count
data$n2_liu_negative_score     = data$n2_liu_negative_score / data$n2_word_count
data$n2_nrc_anger_score        = data$n2_nrc_anger_score / data$n2_word_count
data$n2_nrc_anticipation_score = data$n2_nrc_anticipation_score / data$n2_word_count
data$n2_nrc_disgust_score      = data$n2_nrc_disgust_score / data$n2_word_count
data$n2_nrc_fear_score         = data$n2_nrc_fear_score / data$n2_word_count
data$n2_nrc_joy_score          = data$n2_nrc_joy_score / data$n2_word_count
data$n2_nrc_negative_score     = data$n2_nrc_negative_score / data$n2_word_count
data$n2_nrc_positive_score     = data$n2_nrc_positive_score / data$n2_word_count
data$n2_nrc_sadness_score      = data$n2_nrc_sadness_score / data$n2_word_count
data$n2_nrc_surprise_score     = data$n2_nrc_surprise_score / data$n2_word_count
data$n2_nrc_trust_score        = data$n2_nrc_trust_score / data$n2_word_count

data[is.na(data)] = 0

#remove observations with more than 1000 edits
#data = data[data$edits <= 1000,]

# LR: display how often edits is TRUE (i.e. greater than sigma/0)
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
                       user_age + 
                       ###########################
                     n1_numWeekEdits + 
                       n1_numWeekThanks + 
                       n1_word_count +
                       n1_number_of_comments +
                       n1_liu_positive_score +
                       n1_liu_negative_score +
                       n1_nrc_anger_score +
                       n1_nrc_anticipation_score +
                       n1_nrc_disgust_score +
                       n1_nrc_fear_score +
                       n1_nrc_joy_score +
                       n1_nrc_negative_score +
                       n1_nrc_positive_score +
                       n1_nrc_sadness_score +
                       n1_nrc_surprise_score +
                       n1_nrc_trust_score + 
                       ############################
                     n2_numWeekEdits + 
                       n2_numWeekThanks + 
                       n2_word_count +
                       n2_number_of_comments +
                       n2_liu_positive_score +
                       n2_liu_negative_score +
                       n2_nrc_anger_score +
                       n2_nrc_anticipation_score +
                       n2_nrc_disgust_score +
                       n2_nrc_fear_score +
                       n2_nrc_joy_score +
                       n2_nrc_negative_score +
                       n2_nrc_positive_score +
                       n2_nrc_sadness_score +
                       n2_nrc_surprise_score +
                       n2_nrc_trust_score)


###############################################
glm.model = glm(formula, 
                data = train, 
                family = binomial)

glm.train.predictions = as.factor(predict(glm.model) > 0)
glm.test.predictions = as.factor(predict(glm.model,test) >0)

glm.test.TP = sum(glm.test.predictions == TRUE & test$edits == TRUE)
glm.test.TN = sum(glm.test.predictions == FALSE & test$edits == FALSE)
glm.test.FP = sum(glm.test.predictions == TRUE & test$edits == FALSE)
glm.test.FN = sum(glm.test.predictions == FALSE & test$edits == TRUE)
glm.test.sens = glm.test.TP / (glm.test.TP + glm.test.FN)
glm.test.spec = glm.test.TN / (glm.test.FP + glm.test.TN)

#################################################################
library(randomForest)

rf.model = randomForest(formula, data=train, ntree=100)

rf.train.predictions = predict(rf.model,train)
rf.test.predictions = predict(rf.model,test)

rf.train.error = rmse(train$edits, rf.train.predictions)
rf.test.error = rmse(test$edits, rf.test.predictions)

rf.train.rsquared = rsquared(train$edits, rf.train.predictions)
rf.test.rsquared = rsquared(test$edits, rf.test.predictions)

#################################################################
library(e1071)

train <- data[-in.test,]
test <- data[in.test,]

linear.svm.model = svm(formula, data = train,  kernel="linear")
linear.svm.train.predictions = predict(linear.svm.model)
linear.svm.test.predictions = predict(linear.svm.model,test)
linear.svm.test.TP = sum(linear.svm.test.predictions == TRUE & test$edits == TRUE)
linear.svm.test.TN = sum(linear.svm.test.predictions == FALSE & test$edits == FALSE)
linear.svm.test.FP = sum(linear.svm.test.predictions == TRUE & test$edits == FALSE)
linear.svm.test.FN = sum(linear.svm.test.predictions == FALSE & test$edits == TRUE)
linear.svm.test.sens = linear.svm.test.TP / (linear.svm.test.TP + linear.svm.test.FN)
linear.svm.test.spec = linear.svm.test.TN / (linear.svm.test.FP + linear.svm.test.TN)


radial.svm.model = svm(formula, data = train,  kernel="radial")
radial.svm.train.predictions = predict(radial.svm.model)
radial.svm.test.predictions = predict(radial.svm.model,test)
radial.svm.test.TP = sum(radial.svm.test.predictions == TRUE & test$edits == TRUE)
radial.svm.test.TN = sum(radial.svm.test.predictions == FALSE & test$edits == FALSE)
radial.svm.test.FP = sum(radial.svm.test.predictions == TRUE & test$edits == FALSE)
radial.svm.test.FN = sum(radial.svm.test.predictions == FALSE & test$edits == TRUE)
radial.svm.test.sens = radial.svm.test.TP / (radial.svm.test.TP + radial.svm.test.FN)
radial.svm.test.spec = radial.svm.test.TN / (radial.svm.test.FP + radial.svm.test.TN)



########################################################3
library(gbm)
train <- data[-in.test,]
test <- data[in.test,]
train$edits = as.integer(train$edits) - 1
test$edits  = as.integer(test$edits) - 1

set.seed(1345677)
gbm.n.trees = 500
gbm_model = gbm(formula,
                data = train,
                distribution = "bernoulli",
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




gbm.train.error = sum(gbm.train.predictions != train$high_activity) / nrow(train)
gbm.test.error = sum(gbm.test.predictions != test$high_activity) / nrow(test)

gbm.test.TP = sum(gbm.test.predictions > 0.5 & test$edits == 1)
gbm.test.TN = sum(gbm.test.predictions < 0.5 & test$edits == 0)
gbm.test.FP = sum(gbm.test.predictions > 0.5 & test$edits == 0)
gbm.test.FN = sum(gbm.test.predictions < 0.5 & test$edits == 1)
gbm.test.sens = gbm.test.TP / (gbm.test.TP + gbm.test.FN)
gbm.test.spec = gbm.test.TN / (gbm.test.FP + gbm.test.TN)

summary(gbm_model)



#################################
baseline.train.predictions = (train$n1_numWeekEdits + train$n2_numWeekEdits) * 0.5
baseline.test.predictions = (test$n1_numWeekEdits + test$n2_numWeekEdits) * 0.5
baseline.train.error = rmse(train$edits, baseline.train.predictions)
baseline.test.error = rmse(test$edits, baseline.test.predictions)
baseline.train.rsquared = rsquared(train$edits, baseline.train.predictions)
baseline.test.rsquared = rsquared(test$edits, baseline.test.predictions)
plot(test$edits, baseline.test.predictions, xlim=c(0,1000),ylim=c(0,1000))
abline(0,1)
