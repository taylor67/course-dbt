with promos_source as (
    select * from {{ source('src_postgres', 'promos')}}
)

, renamed_casted as (
    select 
        promo_id,
        discount
    from promos_source
    where status = 'active'
)

select * from renamed_casted