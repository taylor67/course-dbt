with events as (
    select * from {{ ref('stg_events') }}
),
final as (
    select 
        event_id,
        session_id,
        --this makes it so order_id appears in every row, rather than just order_shipped/order_delivered event. 
        first_value(order_id) over (
            partition by session_id 
            -- solution to postgres not supporting 'ignore nulls' in window functions
            order by case when order_id is not null then 0 else 1 end ASC 
            ) as order_id,
        created_date,
        event_type,
        case 
            when event_type = 'page_view' then 1
            when event_type = 'add_to_cart' then 2
            when event_type = 'checkout' then 3
            when event_type = 'package_shipped' then 4
        end as event_number
    from events
)
select * from final