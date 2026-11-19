{{ config(materialized='table') }}


{{
  config(
    materialized = 'incremental',
    unique_key = 'order_item_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns'
  )
}}

select
    oi.order_item_id,
    oi.order_id,
    oi.restaurant_id,
    r.restaurant_name,
    oi.food_id,
    f.food_name,
    o.order_date
from {{ ref('stg_order_items') }} oi
left join {{ ref('stg_orders') }} o
    on oi.order_id = o.order_id
left join {{ ref('stg_food') }} f
    on oi.food_id = f.food_id
left join {{ ref('stg_restaurants') }} r
    on oi.restaurant_id = r.restaurant_id

{% if is_incremental() %}
where o.order_date >= (
    select dateadd(day, -3, max(order_date)) from {{ this }}
)
{% endif %}