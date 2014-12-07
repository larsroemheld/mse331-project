library(data.table)
library(ggplot2)
library(reshape)


data <- read.table('users-thanks-edits.tsv', header=TRUE, sep="\t")

wiki.date.format = "%Y%m%d%H%M%S"
data$user_registration <- as.Date(as.character(data$user_registration), format=wiki.date.format)
#convert the registration date to a week number
data$user_registration_week <- as.numeric(strftime(data$user_registration,format="%W"))

#there are 4 users with invalid registration dates
data = data[!is.na(data$user_registration_week),]


edits = sum(data$numWeekEdits)
thanks = sum(data$numWeekThanks)

data$week_number_since_registration = data$week_number - data$user_registration_week


#remove all rows with week_number = 53 (2013 only had 52 weeks)
data = data[data$week_number != 53,]
edits3 = sum(data$numWeekEdits)
thanks3 = sum(data$numWeekThanks)


#remove all rows with negative weeks since registration
data = data[data$week_number_since_registration >= 0,]
edits2 = sum(data$numWeekEdits)
thanks2 = sum(data$numWeekThanks)



write.csv(data, file="users-thanks-edits-concise.csv", row.names=FALSE)


# qplot(, binwidth=1, origin = -0.5, right=FALSE) + 
#   xlab("Registration week number") +
#   ylab("Number of users") + 
#   ggtitle("Histogram of tip percentage")


