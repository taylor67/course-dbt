with products_source as (
    select * from {{ source('src_postgres', 'products')}}
)

, renamed_casted as (
    select 
        product_id,
        name,
        price,
        inventory
    from products_source
)

select * from renamed_casted