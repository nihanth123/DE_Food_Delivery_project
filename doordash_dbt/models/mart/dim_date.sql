{{ config(materialized='table') }}


with spine as (
    select
        dateadd(day, row_number() over (order by seq4()) - 1, '2024-01-01'::date) as date_day
    from table(generator(rowcount => 3000))
)

select
    date_day,
    year(date_day)                       as year_num,
    quarter(date_day)                    as quarter_num,
    month(date_day)                      as month_num,
    monthname(date_day)                  as month_name,
    day(date_day)                        as day_of_month,
    weekofyear(date_day)                 as week_of_year,
    dayname(date_day)                    as day_name,
    dayofweekiso(date_day)               as day_of_week_num,
    dayofweekiso(date_day) >= 6          as is_weekend
from spine
where date_day <= '2026-12-31'::date