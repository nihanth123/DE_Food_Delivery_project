{{ config(materialized='view') }}

select 
f_id as food_id,
item as food_name,
initcap(veg_or_non_veg) as type
from {{source ('DOORDASH_RAW', 'FOOD')}}

