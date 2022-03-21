with orders_source as (
    select * from {{ source('src_postgres', 'orders')}}
)

, renamed_casted as (
    select 
        order_id,
        user_id,
        promo_id,
        address_id,
        created_at as created_date,
        order_cost, 
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        estimated_delivery_at as estimated_delivery_date,
        delivered_at as delivered_date,
        status
    from orders_source
)

select * from renamed_casted