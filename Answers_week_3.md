
### HW PART 1: 

#### 1. What is our overall conversion rate?

62.45%

Code: 
```
select 
  1.0*count(distinct case when is_converted_session then session_id else null end)
  /
  nullif(count(distinct session_id),0) as conversion_rate
from dbt_taylor_o.fct_sessions s
```

#### 2. What is our conversion rate by product?
Top products: 
e706ab70-b396-4d30-a6b2-a1ccf3625b52 - 89.29%
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 - 89.06%
be49171b-9f72-4fc9-bf7a-9a52e259836b - 87.75%
b66a7143-c18a-43bb-b5dc-06bb5d1d3160 - 87.30%

Code: 
```
select 
  product_id,
  1.0* count(distinct case when is_converted_session then s.session_id else null end)
  /  nullif(count(distinct s.session_id),0) as all_sessions
from dbt_taylor_o.stg_events e
left join dbt_taylor_o.fct_sessions s
  on e.session_id = s.session_id
where e.product_id is not null 
group by 1
order by 2 desc
```

### PART 2:

[Macro definition](https://github.com/taylor67/course-dbt/blob/main/greenery/macros/get_event_types.sql)

[Macro in use](https://github.com/taylor67/course-dbt/blob/main/greenery/models/marts/product/fct_sessions.sql)

### PART 3:
[Created post-hook and on-run-end](https://github.com/taylor67/course-dbt/blob/main/greenery/dbt_project.yml)
* "post-hooks to grant straight away" - [doc](https://discourse.getdbt.com/t/the-exact-grant-statements-we-use-in-a-dbt-project/430)
 - not sure if these two things in combo would make sense like this - what's the value of running grant `select` right when the model is built with the `post-hook`, but not granting `usage` until `on-run-end`? but this is how it's done in that linked doc.

### PART 4:
dbt `group_by` util used in [int_orders](https://github.com/taylor67/course-dbt/blob/main/greenery/models/marts/core/int_orders.sql)