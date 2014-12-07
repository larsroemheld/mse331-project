sentiment <- read.csv("text_features_with_userid.csv", header=TRUE)
u1 = length(unique(sentiment$user_to))

sentiment2 <- sentiment
#only keep comments from 2013
sentiment2 = sentiment2[sentiment2$comment_year == 2013,]

#convert comment date to weeks since registration
#1. convert registartion date to week number
wiki.date.format = "%Y%m%d%H%M%S"
sentiment2$user_registration <- as.Date(as.character(sentiment2$user_registration), format=wiki.date.format)
#convert the registration date to a week number
sentiment2$user_registration_week <- as.numeric(strftime(sentiment2$user_registration,format="%W"))

#2. convert comment date to week number
sentiment2$comment_date <- sentiment2$comment_year * 10000 + sentiment2$comment_month * 100 + sentiment2$comment_day
utp.date.format = "%Y%m%d"
sentiment2$comment_date <- as.Date(as.character(sentiment2$comment_date), format=utp.date.format)
#convert the registration date to a week number
sentiment2$comment_week <- as.numeric(strftime(sentiment2$comment_date,format="%W"))

#3. do week_number_since_registration = comment_week - registration_week
sentiment2$week_number_since_registration = sentiment2$comment_week - sentiment2$user_registration_week

#drop anomalies (users who received messages before their registration date)
sentiment2 = sentiment2[sentiment2$week_number_since_registration >= 0,]


#drop columns that we don't care about
sentiment2$user_to = NULL
sentiment2$user_from = NULL
sentiment2$comment_year = NULL
sentiment2$comment_month = NULL
sentiment2$comment_day = NULL
sentiment2$user_registration = NULL
sentiment2$user_registration_week = NULL
sentiment2$comment_date = NULL
sentiment2$comment_week = NULL

library(data.table)
sentiment2 = data.table(sentiment2)
sentiment2 = sentiment2[, 
               list(word_count = sum(word_count),
                    number_of_comments = .N,
                    liu_positive_score     = sum(liu_positive_score),
                    liu_negative_score     = sum(liu_negative_score),
                    nrc_anger_score        = sum(nrc_anger_score),
                    nrc_anticipation_score = sum(nrc_anticipation_score),
                    nrc_disgust_score      = sum(nrc_disgust_score),
                    nrc_fear_score         = sum(nrc_fear_score),
                    nrc_joy_score          = sum(nrc_joy_score),
                    nrc_negative_score     = sum(nrc_negative_score),
                    nrc_positive_score     = sum(nrc_positive_score),
                    nrc_sadness_score      = sum(nrc_sadness_score),
                    nrc_surprise_score     = sum(nrc_surprise_score),
                    nrc_trust_score        = sum(nrc_trust_score)),
               by = c('user_id','week_number_since_registration')]

sentiment2 = data.frame(sentiment2)

users = unique(sentiment2$user_id)

data = read.csv("users-thanks-edits-concise.csv", header=TRUE)

#remove all entries for users not present in sentiment2
data = data[!is.na(match(data$user_id,users)),]

#merge sentiment and data by user_id and week_number_since_registration
all = merge(data, sentiment2, by=c("user_id","week_number_since_registration"), sort=TRUE, all.x=TRUE)

all <- all[order('user_id', 'week_number_since_registration'),]
#fill N/A's with zeros
all[is.na(all)] = 0

write.csv(all, file="merged_weekly.csv", row.names=FALSE)
