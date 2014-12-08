data = read.csv("rolling_dataset.csv", header=TRUE)
library(data.table)

data = data.table(data)


dt = data[,
          list(user_count = .N,
               num_edits = mean(edits),
               num_thanks = mean(thanks),
               word_count = mean(n1_word_count),
               liu_positive_score     = mean(n1_liu_positive_score),
               liu_negative_score     = mean(n1_liu_negative_score),
               nrc_anger_score        = mean(n1_nrc_anger_score),
               nrc_anticipation_score = mean(n1_nrc_anticipation_score),
               nrc_disgust_score      = mean(n1_nrc_disgust_score),
               nrc_fear_score         = mean(n1_nrc_fear_score),
               nrc_joy_score          = mean(n1_nrc_joy_score),
               nrc_negative_score     = mean(n1_nrc_negative_score),
               nrc_positive_score     = mean(n1_nrc_positive_score),
               nrc_sadness_score      = mean(n1_nrc_sadness_score),
               nrc_surprise_score     = mean(n1_nrc_surprise_score),
               nrc_trust_score        = mean(n1_nrc_trust_score)),
          by="user_age"]


dt2 = data[,
           list(user_count = .N,
                num_edits = mean(edits),
                variation = var(edits)),
           by="user_id"]
dt2 = dt2[order(-num_edits)]

for (i in seq(1,20,1)) {
  #####png(paste('user',i,'.png', sep=""))
  data3 = data[data$user_id == dt2$user_id[i],]
  plot(data3$user_age, data3$edits, type='o',ylim=c(0,max(max(data3$edits),max(data3$n1_word_count))))
  lines(data3$user_age-1, data3$n1_word_count, type='o', col='red')
  #####dev.off()
}
