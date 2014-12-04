# Do a comparison of number of edits 30 days before and after official 
# introduction of "thanks" feature (05/30/2013)
#
# Group 1: thanks received in month after launch, activity before launch => exists, timestamp < 05/30
# Group 2: thanks received in month after launch, activity after launch => exists, timestamp > 05/30
# Group 3: no thanks received in month after launch, activity before launch => not exists, timestamp < 05/30
# Group 4: no thanks received in month after launch, activity after launch => not exists, timestamp > 05/30
# 
# Created: Lars Roemheld, 12/03/14
#

select user_id, count(rev_id) as num_edits
from 
user
left join (
		select rev_id, rev_user from revision_userindex 
		where rev_timestamp >= 20130530000000 and rev_timestamp < 20130630000000
			and rev_deleted = 0
		) as temp_revs
on rev_user = user_id

where exists (select * from logging_logindex 
		where log_timestamp >= 20130530000000 and log_timestamp < 20130630000000
			and log_type='thanks'
			and log_deleted = 0
			and log_title = user_name
		) 
and user_editcount >= 1

group by user_id
