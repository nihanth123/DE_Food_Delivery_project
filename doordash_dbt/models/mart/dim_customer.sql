{{ config(materialized='table') }}


select 
user_id as customer_id,
name,
email,
(case when age < 18 then '<=18'
when age>=18 and age <=35 then '19-35'
when age>35 and age <=50 then '36-50'
when age>50 and age<=65 then '51-65'
when age>65 then '>65' end) age_bucket,
gender,
marital_status,
occupation,
income_band,
education,
family_size
from {{ ref('stg_users') }}