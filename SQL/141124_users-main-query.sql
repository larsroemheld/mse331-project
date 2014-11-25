# Get a list of all users registered in 2013, with a weekly overview of activity
# 
# Created: Lars Roemheld, 11/24/14
#
#Notes:#
#Superusers: sysop and bureaucrat; https://en.wikipedia.org/wiki/Wikipedia:User_access_levels
# How are reverts defined in the data? IRC Ironholds claimed we need to compare SHA-1 of (n-1) and (n+1), but this defied tree logic of revisions
# We count all revisions, including all pages. This is a potential issue, since revisions on user talk pages etc. are counted as well; however, getting only article edits would further complicate the query and we believe the count of all revisions to be a good indicator of overall activity.

## Query structure: two very similar queries are joined
## Query 1 counts the number of edits (revision) per user and week
## Query 2 counts the number of thanks received per user and week

select edits.user_id, edits.user_registration, edits.user_lifetime_editcount, edits.weekno as week_number, numWeekEdits, numWeekThanks from 

(
	select user_id, user_registration, user_editcount as user_lifetime_editcount, weekno, count(rev_id) as numWeekEdits from 
	(
	select 0 as weekno
	union select 1
	union select 2
	union select 3
	union select 4
	union select 5
	union select 6
	union select 7
	union select 8
	union select 9
	union select 10
	union select 11
	union select 12
	union select 13
	union select 14
	union select 15
	union select 16
	union select 17
	union select 18
	union select 19
	union select 20
	union select 21
	union select 22
	union select 23
	union select 24
	union select 25
	union select 26
	union select 27
	union select 28
	union select 29
	union select 30
	union select 31
	union select 32
	union select 33
	union select 34
	union select 35
	union select 36
	union select 37
	union select 38
	union select 39
	union select 40
	union select 41
	union select 42
	union select 43
	union select 44
	union select 45
	union select 46
	union select 47
	union select 48
	union select 49
	union select 50
	union select 51
	union select 52
	union select 53
	) as weeknos
	cross join user
	left join (
		select rev_id, rev_user, rev_timestamp from revision_userindex 
		where 	rev_timestamp >= 20130101000000 and rev_timestamp < 20140101000000
			and rev_deleted = 0
		) as temp_revs
	on rev_user = user_id and week(rev_timestamp) = weekno 

	where user_registration >= 20130101000000 and user_registration < 20140101000000
	and user_editcount >= 1

	group by user_id, weekno
) as edits

join

(
	select user_id, weekno, count(log_id) as numWeekThanks from 
	(
	select 0 as weekno
	union select 1
	union select 2
	union select 3
	union select 4
	union select 5
	union select 6
	union select 7
	union select 8
	union select 9
	union select 10
	union select 11
	union select 12
	union select 13
	union select 14
	union select 15
	union select 16
	union select 17
	union select 18
	union select 19
	union select 20
	union select 21
	union select 22
	union select 23
	union select 24
	union select 25
	union select 26
	union select 27
	union select 28
	union select 29
	union select 30
	union select 31
	union select 32
	union select 33
	union select 34
	union select 35
	union select 36
	union select 37
	union select 38
	union select 39
	union select 40
	union select 41
	union select 42
	union select 43
	union select 44
	union select 45
	union select 46
	union select 47
	union select 48
	union select 49
	union select 50
	union select 51
	union select 52
	union select 53
	) as weeknos
	cross join user
	left join (
		select log_id, log_title, log_timestamp from logging_logindex 
		where log_timestamp >= 20130101000000 and log_timestamp < 20140101000000
			and log_type='thanks'
			and log_deleted = 0
		) as temp_thanks
	on log_title = user_name and week(log_timestamp) = weekno

	where user_registration >= 20130101000000 and user_registration < 20140101000000
	and user_editcount >= 1

	group by user_id, weekno
) as thanks

on edits.user_id = thanks.user_id and edits.weekno = thanks.weekno

