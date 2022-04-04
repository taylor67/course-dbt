with orders as (
  select * from {{ ref('orders_snapshot') }}
),

int_orders as (
  select * from {{ ref('int_orders') }}
),

promos as (
  select * from {{ ref('stg_promos') }}
),

user_window_functions as (
  select
      order_id,
      rank() over (partition by user_id order by created_date) as user_order_rank,
      date_part('day', 
        created_date -    --this row's order date... minus
        lag(created_date) over (partition by user_id order by created_date) --last users' order date
      ) as days_since_last_order
  from orders
),

order_details as (
  select 
    o.order_id, 
    o.user_id,
    o.promo_id,
    o.promo_id is not null as used_promo,
    o.address_id,
    o.created_date,
    o.order_cost, 
    o.shipping_cost,
    o.order_total,
    o.order_total - p.discount as order_total_with_promo,
    o.tracking_id,
    o.shipping_service,
    o.estimated_delivery_date,
    o.delivered_date,
    o.status, 
    io.items_in_order,
    date_part('day', delivered_date - created_date) as days_to_delivery,
    date_part('day', delivered_date - estimated_delivery_date) as days_delivered_late,
    delivered_date is not null as was_delivered,
    uwf.user_order_rank,
    uwf.days_since_last_order,
    dbt_valid_from,
    dbt_valid_to,
    dbt_valid_to is null as is_valid
  from orders as o
  left join int_orders as io
    on o.order_id = io.order_id
  left join promos as p
    on o.promo_id = p.promo_id
  left join user_window_functions uwf
    on o.order_id = uwf.order_id
),

final as (
  select 
    *, 
    user_order_rank = 1 as is_first_order,
    days_delivered_late > 0 as was_delivered_late
  from order_details
)

select * from final