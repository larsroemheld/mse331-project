select * 
from user 
where year(user_registration) = 2013
and user_editcount >= 1

limit 10