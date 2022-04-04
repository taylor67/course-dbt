with funnel as (
    select * from {{ ref('fct_funnel') }}
),

-- transforming long table to wide so that aggregating funnel percentages is easier for end users
funnel_agg_sums as (
    select 
        sum(case when funnel_stage = 'all_sessions' then count_sessions else null end) as count_all_sessions,
        sum(case when funnel_stage = 'add_to_cart' then count_sessions else null end) as count_add_to_cart_sessions,
        sum(case when funnel_stage = 'checkout' then count_sessions else null end) as count_checkout_sessions
    from funnel
),

funnel_agg_percentages as (
    select 
        1.0*count_add_to_cart_sessions / nullif(count_all_sessions,0) as add_to_cart_pct_of_all_sessions,
        1.0*count_checkout_sessions / nullif(count_all_sessions,0) as checkout_pct_of_all_sessions
    from funnel_agg_sums
)

select * from funnel_agg_percentages