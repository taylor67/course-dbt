# Analytics engineering with dbt

Template repository for the projects and environment of the course: Analytics engineering with dbt

> Please note that this sets some environment variables so if you create some new terminals please load them again.

## License

Apache 2.0


### Week 1: 

How many users do we have?
A: 130
Code:

On average, how many orders do we receive per hour?
A:	
    If we define "per hour" as hour independent of date: 7.52
    If we define "per hour" as per hour per date: 15.042
Code:
<!-- with orders_by_hour as (
  select 
    extract(hour from created_at),
    count(*) as order_count
  from dbt."dbt_taylor_o".stg_orders 
  group by 1
),

orders_by_date_hour as (
  select
    date(created_at),
    extract(hour from created_at),
    count(*) as order_count
    from dbt."dbt_taylor_o".stg_orders 
    group by 1,2
    order by 1,2
)

select 
  avg(orders_by_hour.order_count) as avg_hourly_orders,
  avg(orders_by_date_hour.order_count) as avg_daily_hourly_orders
from orders_by_hour
left join orders_by_date_hour on 1=1 -->