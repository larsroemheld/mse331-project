select log_user as user_from, user_id as user_to, log_timestamp, weekno from 
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
inner join (
	select log_id, log_user, log_title, log_timestamp from logging_logindex 
	where log_type='thanks'
		and log_deleted = 0
	) as temp_thanks
on log_title = user_name and week(log_timestamp) = weekno
