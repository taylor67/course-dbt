{% snapshot orders_snapshot %}

{{ 
    config(
        unique_key = 'order_id'
        , target_schema = 'dbt_taylor_o'
        , strategy = 'check'
        , check_cols = ["status"]
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
)

select * from orders

{% endsnapshot %}