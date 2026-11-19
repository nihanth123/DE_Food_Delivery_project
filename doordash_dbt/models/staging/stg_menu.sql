{{ config(materialized='view') }}

with dedup as (select 
menu_id,
try_to_number(r_id) as restaurant_id,
f_id as food_id,
cuisine,
try_to_decimal(price) as price,
ROW_NUMBER() OVER (PARTITION BY menu_id ORDER BY menu_id ASC ) AS row_num

 from {{source ('DOORDASH_RAW', 'MENU')}} 
)
select * from dedup 
where row_num = '1'

 