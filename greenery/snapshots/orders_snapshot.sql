{% snapshot order_snapshot %}

{{ 
    config(
        unique_key = 'order_id'
        , target_schema = 'dbt_taylor_o'
        , strategy = 'check'
        , check_cols = ["status"]
    )
}}

with orders as {{
    select * from ref('dim_orders')
}}

select * from orders

{% endsnapshot %}