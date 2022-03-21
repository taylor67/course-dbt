with users as (
    select * from {{ ref('stg_users') }}
),

orders as (
  select * from {{ ref('fct_orders') }}
)

select 
  u.user_id,
  count(o.order_id) as lifetime_orders,
  sum(order_total) as lifetime_spend,
  sum(order_total_with_promo) as lifetime_spend_with_promos,
  min(o.created_date) as first_order_date,
  max(o.created_date) as last_order_date
from users u
left join orders o 
  on u.user_id = o.user_id
group by 1

