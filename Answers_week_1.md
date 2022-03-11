#### 1. How many users do we have?
A: 130

Code:
```
select 
  count(distinct user_id)
from dbt."dbt_taylor_o".stg_users
```

#### 2. On average, how many orders do we receive per hour?
A: daily_hourly: 7.52, hourly: 15.04
* daily_hourly is per hour per day, where hourly is agnostic to date. 

Code:
``` 
with hourly_orders as (
  select 
    extract(hour from created_at),
    count(*) as count_orders
  from dbt."dbt_taylor_o".stg_orders
  group by 1
),

daily_hourly_orders as (
  select 
    date(created_at),
    extract(hour from created_at),
    count(*) as count_orders
  from dbt."dbt_taylor_o".stg_orders
  group by 1,2
)

select 
  avg(hourly_orders.count_orders) as avg_hourly_orders,
  avg(daily_hourly_orders.count_orders) as avg_daily_hourly_orders
from hourly_orders
left join daily_hourly_orders on 1=1
```

#### 3. On average, how long does an order take from being placed to being delivered?
A: 3.89 days

Code: 
```
select 
  avg(DATE_PART('day', delivered_at - created_at))
from dbt."dbt_taylor_o".stg_orders
```

#### 4. How many users have only made one purchase? Two purchases? Three+ purchases?
A: 1:25, 2:28, 3+:71

Code: 
```
with user_lifetime_orders as (
  select 
    user_id, 
    count(*) as lifetime_orders
  from dbt."dbt_taylor_o".stg_orders
  group by 1
)

select 
  case 
    when lifetime_orders = 1 then '1'
    when lifetime_orders = 2 then '2'
    when lifetime_orders >= 3 then '3+'
    else 'other'
  end as lifetime_orders_tier,
  count(*)
from user_lifetime_orders
group by 1
```

#### 5. On average, how many unique sessions do we have per hour?
A: 16.33

Code:
```
with daily_hourly_sessions as (
  select 
    date(created_at),
    extract(hour from created_at),
    count(distinct session_id) as count_sessions
  from dbt."dbt_taylor_o".stg_events
  group by 1,2
)

select 
  avg(count_sessions) as avg_daily_hourly_sesions
from daily_hourly_sessions
```