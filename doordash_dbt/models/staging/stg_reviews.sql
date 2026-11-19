select 
rev.review_id,
rev.order_id,
rev.user_id,
rev.restaurant_id,
rev.rating, 
rev.comment,
rev.review_date,
r.city
from
{{source ('DOORDASH_RAW' , 'REVIEWS')}} rev
left join {{ ref('stg_restaurants') }} r 
on r.restaurant_id =  rev.restaurant_id
