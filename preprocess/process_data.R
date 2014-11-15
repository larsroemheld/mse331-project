
Data <- read.csv("user_edits_part1_clean.csv", header=TRUE)
Data2 <- read.csv("user_edits_part2_clean.csv", header=TRUE)

Data3 <- rbind(Data,Data2)

#remove entries with negative days
Data3 <- Data3[Data3$days_since_reg>=0,]
hist(Data3$days_since_reg,30)

#compute variables of interest
library(data.table)
datat <- data.table(Data3)


#edit on first day?
#days to first edit
#days to last edit
#average days since reg
#number of edits in the first 30 days
#max edits per day
#day of max activity

d = datat[, 
          list(first_day_edit              = min(days_since_reg) == 0,
               days_to_first_edit          = min(days_since_reg),
               days_to_last_edit           = max(days_since_reg),
               average_days_since_reg      = sum(days_since_reg) / .N,
               number_of_edits_first_month = .N,
               max_edits_per_day = sort(table(days_since_reg),decreasing=TRUE)[1],
               max_activity_day  = strtoi(names(sort(table(days_since_reg),decreasing=TRUE)[1]))),
          by = 'user_id']

df = data.frame(d)

#remove users with more than 1000 edits
max.edits = 600
df = df[df$number_of_edits_first_month < max.edits,]
hist(df$number_of_edits_first_month, max.edits)



users = read.csv("users_adjusted_clean.csv", header=TRUE)

all = merge(users, df, by="user_id", sort=FALSE)

write.csv(all, file="activity_features.csv", row.names=FALSE)



sentiment <- read.csv("text_features.csv", header=TRUE)

sentiment$comment_date <-paste(sentiment$comment_day,sentiment$comment_month,sentiment$comment_year,sep=".")

all$registration_date <-paste(all$day,all$month,all$year,sep=".")

#add user registration date to sentiment
lookup = all[,c(2,18)]

sentiment2 = merge(sentiment,lookup,by.x="user_to",by.y="user_name", all.x=FALSE, all.y=FALSE, sort=FALSE)



sentiment2$user_to = sapply(sentiment2$user_to, as.character)
sentiment2$user_from = sapply(sentiment2$user_from, as.character)
#remove comments where user_to equals user_from
sentiment2 = sentiment2[sentiment2$user_to != sentiment2$user_from,]
#remove comments of length 0
sentiment2 = sentiment2[sentiment2$word_count != 0,]


#remove comments not within 30 days of registration
sentiment2$diff = round(difftime(strptime(sentiment2$comment_date, format = "%d.%m.%Y"),
                           strptime(sentiment2$registration_date, format = "%d.%m.%Y"),
                           units="days"))
sentiment2 = sentiment2[sentiment2$diff <= 31,]


sentiment2 = data.table(sentiment2)


s = sentiment2[, 
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
          by = 'user_to']


s = data.frame(s)
#add user registration date to sentiment
lookup = all[,c(2,1)]
s2 = merge(s,lookup,by.x="user_to",by.y="user_name", all.x=FALSE, all.y=FALSE, sort=FALSE)

dataset = merge(s2,all,by="user_id",all.x=TRUE, all.y=FALSE, sort=FALSE)

dataset$user_to = NULL

write.csv(dataset, file="dataset.csv", row.names=FALSE)


