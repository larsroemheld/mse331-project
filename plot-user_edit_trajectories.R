data = read.csv("rolling_dataset_sigmas.csv", header=TRUE)

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

# Make sure user_id appears as factor label, not numerical value
data$user_id = as.factor(data$user_id)

theme_set(theme_gray(base_size = 14))
# Plot a hand-selected overview of some rockstar editors
plot_data = data[data$user_id == dt2$user_id[1] | data$user_id == dt2$user_id[5] | data$user_id == dt2$user_id[10] | data$user_id == dt2$user_id[2]]
overview <- qplot(user_age, edits, data=plot_data, color=user_id, geom="line", main="Activity of 4 Rockstar Editors", xlab = "Weeks since registration", ylab="Edits in Week", size=I(1))
overview <- overview + theme(legend.position="none")
overview

# Plot a fancy visualization of \tau - neighborhoods and events
plot_data = data[data$user_id == dt2$user_id[5]]
p <- qplot(user_age, edits, data=plot_data, color=user_id, geom="line", main="Sample: t-Neighborhood & Events", xlab = "Weeks since registration", ylab="Edits in Week", size=I(1))
p <- p + geom_ribbon(data = data[data$user_id == dt2$user_id[5]], aes(ymin=n1_numWeekEdits-std_dev, ymax=n1_numWeekEdits+std_dev), alpha=0.2)

lines = data[data$user_id == dt2$user_id[5]]
lines$changeevent = abs(lines$edits - lines$n1_numWeekEdits) > lines$std_dev
for (l in 1:nrow(lines)) {
  if (lines[l]$changeevent) {
#    p <- p + geom_vline(x = lines[l]$user_age, color = "blue", size = I(1))
    p <- p + geom_point(x = lines[l]$user_age, y = lines[l]$edits, color="#0072B2", size = I(3))
  }
}
p <- p + theme_bw(base_size = 14)
#p <- p + theme_grey() 
p <- p + theme(legend.position="none")
p



lifetime_stats = data[, list(num_edits = sum(edits)), by="user_id"]
nrow(lifetime_stats[num_edits > 1]) / nrow(lifetime_stats)
