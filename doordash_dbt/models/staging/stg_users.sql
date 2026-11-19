select 
user_id,
name,
lower(email) email,
try_to_number(age) as age,
gender,
marital_status,
occupation,
monthly_income as income_band,
education,
try_to_number(family_size) family_size
from
{{source ('DOORDASH_RAW' , 'USERS')}}
