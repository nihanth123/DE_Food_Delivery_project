{{ config(materialized='table') }}


{{
  config(
    materialized = 'incremental',
    unique_key = 'order_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns'
    )
}}

select 
*
from {{ ref('stg_orders') }}

{% if is_incremental() %}
where order_date >= (
    select dateadd(day, -3, max(order_date)) from {{ this }}
)
{% endif %}