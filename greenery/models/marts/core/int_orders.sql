with orders as (
  select * from {{ ref('stg_orders') }}
),

order_items as (
  select * from {{ ref('stg_order_items') }}
),

promos as (
    select * from {{ ref('stg_promos') }}
)

select 
    o.order_id,
    count(oi.quantity) as items_in_order
from orders as o
left join order_items as oi
    on o.order_id = oi.order_id
{{ dbt_utils.group_by(n=1) }}
