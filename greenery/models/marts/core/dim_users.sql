with users as (
    select * from {{ ref('stg_users') }}
),

final as (
  select 
    *,
    concat(first_name, ' ', last_name) as full_name
  from users
)

select * from final