with events as (
    select * from {{ ref('stg_events') }}
),
final as (
    select 
        event_id,
        session_id,
        created_date,
        case 
            when event_type = 'page_view' then 1
            when event_type = 'add_to_cart' then 2
            when event_type = 'checkout' then 3
            when event_type = 'package_shipped' then 4
        end as event_number
    from events
)
select * from final