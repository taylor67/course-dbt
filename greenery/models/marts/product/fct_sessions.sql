with events as (
    select * from {{ ref('stg_events') }}
),
int_events as (
    select * from {{ ref('int_events') }}
 ),
session_agg as (
    select 
        session_id,
        count(*) as count_events_in_session,
        min(created_date) as session_start_datetime,
        max(created_date) as session_end_datetime,
        max(event_number) as furthest_event_number
    from events
    group by 1
    order by 2 desc
),
final as (
    select 
        session_id,
        count_events_in_session,
        session_start_datetime,
        session_end_datetime,
        case 
            when furthest_event_number = 1 then 'page_view'
            when furthest_event_number = 2 then 'add_to_cart'
            when furthest_event_number = 3 then 'checkout'
            when furthest_event_number = 4 then 'package_shipped'
        end as furthest_event,
        DATE_PART('minute', session_end_datetime - session_start_datetime) as session_length_minutes
    from session_agg
)

select * from final