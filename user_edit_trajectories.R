data = read.csv("rolling_dataset.csv", header=TRUE)

users = read.delim("all-users-2013.tsv", sep="\t", quote="", header=TRUE)
data <- merge(data, users, by.x="user_id", by.y="user_id", all.x=TRUE)

library(data.table)
library(ggplot2)

data = data.table(data)

dt2 = data[user_registration < 20130201000000,
           list(user_count = .N,
                num_edits = mean(edits),
                variation = var(edits)),
           by="user_id"]
dt2 = dt2[order(-num_edits)]

data$user_id = as.factor(data$user_id)

plot_data = data[data$user_id == dt2$user_id[1] | data$user_id == dt2$user_id[6] | data$user_id == dt2$user_id[3] | data$user_id == dt2$user_id[4] | data$user_id == dt2$user_id[5]]
qplot(user_age, edits, data=plot_data, color=user_id, geom="line", main="Activity of Rockstar Editors", size=I(1))


for (i in seq(1,20,1)) {
  #####png(paste('user',i,'.png', sep=""))
  data3 = data[data$user_id == dt2$user_id[1],]
  data4 = data[data$user_id == dt2$user_id[2000],]
  
  p1 <- qplot(data3$user_age, data3$edits, geom="line")
  p2 <- qplot(data4$user_age, data4$edits, geom="line")
  
  #  lines(data3$user_age-1, data3$n1_word_count, type='o', col='red')
  #####dev.off()
}
