with events_source as (
    select * from {{ source('src_postgres', 'events')}}
)

, renamed_casted as (
    select 
        event_id,
        session_id,
        user_id,
        page_url,
        created_at as created_date,
        event_type,
        order_id,
        product_id
    from events_source

)

select * from renamed_casted