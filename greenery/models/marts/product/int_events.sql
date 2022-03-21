with events as (
    select * from {{ ref('stg_events') }}
),
final as (
    select 
        event_id,
        case 
            when event = 'page_view' then 1
            when event = 'add_to_cart' then 2
            when event = 'checkout' then 3
            when event = 'package_shipped' then 4
        end as event_number
)
select * from final