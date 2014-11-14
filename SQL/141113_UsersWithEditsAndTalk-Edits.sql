select user_name, user_id, user_registration, user_editcount, count_talkrevisions, rev_id, rev_timestamp, rev_page, rev_text_id
from (
	select user_name, user_id, user_registration, user_editcount, page_counter, count(*) as count_talkrevisions
	from user 
	join page on page_title = user_name
	left join revision_userindex on rev_page = page_id
	where user_registration >= 20130101000000 and user_registration < 20140101000000
	and user_editcount >= 1
	and page_namespace=3 # User talk pages
	group by user_name, user_registration, user_editcount, page_counter
) as eligible_users
left join revision_userindex on rev_user = user_id
where datediff(rev_timestamp, user_registration) <= 30