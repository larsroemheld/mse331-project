setwd('/Users/lars/Documents/OfficeFiles/Uni/2014F_MS&E 331 Computational Social Science/project');

thanks = read.delim("141125_users-thanks-edits.tsv", sep="\t", quote="", header=TRUE)

library(data.table)
datat <- data.table(thanks)

datat = datat[, lifetimethanks := sum(numWeekThanks), by="user_id"]
datat = datat[datat$week_number <= 26, firstmonththanks := sum(numWeekThanks), by="user_id"]
datat = datat[, month := floor(week_number/4)+1,]

thanked_before_life = sum(datat$numWeekEdits[datat$lifetimethanks > 0 & datat$week_number >= 18 & datat$week_number <= 22 ])
unthanked_before_life = sum(datat$numWeekEdits[datat$lifetimethanks == 0 & datat$week_number >= 18 & datat$week_number <= 22 ])
thanked_after_life = sum(datat$numWeekEdits[datat$lifetimethanks > 0 & datat$week_number >= 22 & datat$week_number <= 26 ])
unthanked_after_life = sum(datat$numWeekEdits[datat$lifetimethanks == 0 & datat$week_number >= 22 & datat$week_number <= 26 ])

thanked_before_firstmonth = sum(datat$numWeekEdits[datat$firstmonththanks > 0 & datat$week_number >= 18 & datat$week_number <= 22 ])
unthanked_before_firstmonth = sum(datat$numWeekEdits[datat$firstmonththanks == 0 & datat$week_number >= 18 & datat$week_number <= 22 ])
thanked_after_firstmonth = sum(datat$numWeekEdits[datat$firstmonththanks > 0 & datat$week_number >= 22 & datat$week_number <= 26 ])
unthanked_after_firstmonth = sum(datat$numWeekEdits[datat$firstmonththanks == 0 & datat$week_number >= 22 & datat$week_number <= 26 ])

life_thanked = thanked_after_life / thanked_before_life
life_unthanked = unthanked_after_life / unthanked_before_life

first_thanked = thanked_after_firstmonth / thanked_before_firstmonth
first_unthanked = unthanked_after_firstmonth / unthanked_before_firstmonth

edits = array()
edits[1] = sum(datat$numWeekEdits[datat$month == 1])
edits[2] = sum(datat$numWeekEdits[datat$month == 2])
edits[3] = sum(datat$numWeekEdits[datat$month == 3])
edits[4] = sum(datat$numWeekEdits[datat$month == 4])
edits[5] = sum(datat$numWeekEdits[datat$month == 5])
edits[6] = sum(datat$numWeekEdits[datat$month == 6])
edits[7] = sum(datat$numWeekEdits[datat$month == 7])
edits[8] = sum(datat$numWeekEdits[datat$month == 8])
edits[9] = sum(datat$numWeekEdits[datat$month == 9])
edits[10] = sum(datat$numWeekEdits[datat$month == 10])
edits[11] = sum(datat$numWeekEdits[datat$month == 11])
edits[12] = sum(datat$numWeekEdits[datat$month == 12])
edits[13] = sum(datat$numWeekEdits[datat$month == 13])

plot(edits)

editsgrowth = array()
for (i in 2:13) {
  editsgrowth[i] = edits[i] / edits[i-1]
}
  
plot(editsgrowth)

monthlyedits_sd = sd(edits) / mean(edits)
monthlygrowth_sd = sd(editsgrowth)
