
with int_events as (
    select * from {{ ref('int_events') }}
 ),
session_agg as (
    select 
        session_id,
        order_id, --test ensures this does not make session id non-unique.
        count(distinct event_id) as count_events_in_session,
        min(created_date) as session_start_datetime,
        max(created_date) as session_end_datetime,
        max(event_number) as furthest_event_number,
        -- EVENT COUNTS: This macro creates one column per event with a count of how many times that event occurred
        {%- for event_type in get_event_types() %}
        count(case when event_type = '{{event_type}}' then 1 else null end) as count_{{event_type}}_events
        {%- if not loop.last %},{% endif %}
        {% endfor %}
    from int_events
    group by 1,2
),
final as (
    select 
        session_id,
        order_id,
        order_id is not null as is_converted_session,
        count_events_in_session,
        session_start_datetime,
        session_end_datetime,
        case 
            when furthest_event_number = 1 then 'page_view'
            when furthest_event_number = 2 then 'add_to_cart'
            when furthest_event_number = 3 then 'checkout'
            when furthest_event_number = 4 then 'package_shipped'
        end as furthest_event,
        -- This macro simply references the EVENT COUNTS to get those columns in this CTE
        {%- for event_type in get_event_types() %}
        count_{{event_type}}_events
        {%- if not loop.last %},{% endif %}
        {%- endfor %},
        -- This macro creates booleans for whether each EVENT COUNT is >0
        {%- for event_type in get_event_types() %}
        count_{{event_type}}_events > 0 as has_{{event_type}}_event
        {%- if not loop.last %},{% endif %}
        {%- endfor %},
        DATE_PART('minute', session_end_datetime - session_start_datetime) as session_length_minutes
    from session_agg
)

select * from final