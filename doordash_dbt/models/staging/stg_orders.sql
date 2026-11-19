{{ config(materialized='view') }}

select 
order_id,
order_date,
user_id,
r_id as restaurant_id,
trim(coalesce(regexp_substr(restaurant_city, '[^,]+$'), restaurant_city)) as city,
cuisine,
items_count,
sales_qty,
subtotal,
try_to_decimal(discount) as discount,
try_to_decimal(delivery_fee) as delivery_fee,
gst,
sales_amount,
currency,
payment_method,
order_status,
(order_status='Delivered') as is_delivered,
customer_rating,
delivery_time_min
from
{{source ('DOORDASH_RAW' , 'ORDERS')}}
