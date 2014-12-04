# Assumed text_features.tsv exists. Will join user id to that file
# Based on user_to username.

setwd('/Users/lars/Documents/OfficeFiles/Uni/2014F_MS&E 331 Computational Social Science/project');
textfeatures = read.delim("text_features_new.tsv", sep="\t", header=TRUE)

users = read.delim("all-users-2013.tsv", sep="\t", header=TRUE)

total <- merge(textfeatures, users, by.x="user_to", by.y="user_name")

write.csv(total, file="text_features_with_userid.csv", row.names=FALSE)