{{ config(materialized='view') }}

select 
id as restaurant_id,
name as restaurant_name,
trim(coalesce(regexp_substr(city, '[^,]+$'), city)) as city,
try_to_decimal(rating, 3, 1) AS rating,
try_to_number(regexp_substr(rating_count, '[0-9]+')) as rating_count,
try_to_number(regexp_replace(cost, '[^0-9]', '')) as cost_for_two,
cuisine,
(case when lic_no <> 'license' then lic_no else null end) as license_no
 from {{ source('DOORDASH_RAW', 'RESTAURANT') }}
 