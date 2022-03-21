with orders as (
  select * from {{ ref('stg_orders') }}
),

int_orders as (
  select * from {{ ref('int_orders') }}
),

promos as (
  select * from {{ ref('stg_promos') }}
)

select 
    o.order_id, 
    o.user_id,
    o.promo_id,
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
    delivered_date is not null as was_delivered
from orders as o
left join int_orders as io
    on o.order_id = io.order_id
left join promos as p
    on o.promo_id = p.promo_id