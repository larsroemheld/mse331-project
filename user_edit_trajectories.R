data = read.csv("rolling_dataset.csv", header=TRUE)
library(data.table)

data = data.table(data)

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
