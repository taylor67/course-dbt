with orders as (
    select * from {{ ref('dim_orders') }}
)

select * from orders
where is_valid