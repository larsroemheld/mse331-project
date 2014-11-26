# Get a list of all user talk edits in 2013 for eligible users, with weeknumbers
# 
# Created: Lars Roemheld, 11/25/14
#
#Notes:#
# Inner joins are used, i.e. user/week combinations without user talk in a particular week will not appear in result
#
# Query structure:
# ([week numbers in 0...52] x users_to) join (usertalk pages) join revisions join users_from join user_group_from
#

select weekno, usersfrom.user_id as user_from, ug_group as user_group_from, 
	case when ug_group in ('sysop', 'bureaucrat') then 'admin' else 'non-admin' end as user_group_from_is_admin, 
	usersto.user_id as user_to, rev_page as usertalk_page, rev_id, rev_timestamp from 
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
cross join user as usersto

inner join (
	select page_id, page_title from page where page_namespace=3 #User talk pages only
	) as userstalk on page_title = usersto.user_name
inner join (
	select rev_id, rev_user, rev_page, rev_timestamp from revision_userindex 
	where rev_timestamp >= 20130101000000 and rev_timestamp < 20140101000000
		and rev_deleted = 0
	) as userstalk_revisions on rev_page = userstalk.page_id and week(rev_timestamp) = weekno 
inner join user as usersfrom on rev_user = usersfrom.user_id

left join user_groups on ug_user = usersfrom.user_id

where usersto.user_registration >= 20130101000000 and usersto.user_registration < 20140101000000
and usersto.user_editcount >= 1
