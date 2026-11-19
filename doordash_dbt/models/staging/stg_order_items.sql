{{ config(materialized='view') }}

select 
order_item_id,
order_id,
r_id as restaurant_id,
f_id as food_id,
quantity,
try_to_decimal(line_amount) as total_amount
from {{source ('DOORDASH_RAW', 'ORDER_ITEMS')}}
