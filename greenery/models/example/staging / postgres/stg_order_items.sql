{{
  config(
    materialized='table'
  )
}}

with order_items_source as (
    select * from {{ source('src_postgres', 'order_items')}}
)

, renamed_casted as (
    select 
        order_id,
        product_id,
        quantity,
        concat(order_id, product_id) as pk
    from order_items_source
)

select * from renamed_casted