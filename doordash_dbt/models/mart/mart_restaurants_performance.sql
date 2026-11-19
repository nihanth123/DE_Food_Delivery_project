{{ config(materialized='table') }}

select 
r.restaurant_id,r.restaurant_name,
count(o.order_id) total_orders ,
sum(o.sales_amount) total_sales_amount ,
round(avg(o.delivery_time_min),2) avg_delivery_time ,
round(AVG(CAST(NULLIF(TRIM(o.customer_rating), '') AS DECIMAL(10, 2))),2) avg_rating
from {{ ref('dim_restaurants') }} r
left join {{ ref('fact_orders') }} o
on r.restaurant_id = o.restaurant_id
where o.order_status = 'Delivered'
group by 1,2
order by 3 desc