select user_name, user_registration, user_editcount, page_counter, count(*) as count_talkrevisions
from user 
join page on page_title = user_name
left join revision_userindex on rev_page = page_id

where year(user_registration) = 2013
and user_editcount >= 1
and page_namespace=3 # User talk pages
group by user_name, user_registration, user_editcount, page_counter
order by count_talkrevisions desc

limit 100