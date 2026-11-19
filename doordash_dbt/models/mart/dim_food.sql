{{ config(materialized='table') }}


select food_id,
food_name,
type
 from {{ ref('stg_food') }}