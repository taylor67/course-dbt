with sessions as (
    select * from {{ ref('fct_sessions') }}
)

select 
    'all_sessions' as funnel_stage,
    1 as funnel_stage_number,
    date(session_start_datetime) as session_date,
    count(*) as count_sessions
from sessions
{{ dbt_utils.group_by(n=3) }}

union all

select 
    'add_to_cart' as funnel_stage,
    2 as funnel_stage_number,
    date(session_start_datetime) as session_date,
    count(*) as count_sessions
from sessions
where has_add_to_cart_event
{{ dbt_utils.group_by(n=3) }}

union all

select 
    'checkout' as funnel_stage,
    3 as funnel_stage_number,
    date(session_start_datetime) as session_date,
    count(*) as count_sessions
from sessions
where has_checkout_event
{{ dbt_utils.group_by(n=3) }}