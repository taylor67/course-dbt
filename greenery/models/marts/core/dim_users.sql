with users as (
    select * from {{ ref('stg_users') }}
)

select 
  u.user_id, 
  u.first_name,
  u.last_name,
  concat(u.first_name, ' ', u.last_name) as full_name,
  u.email,
  u.phone_number,
  u.created_at,
  u.updated_at,
  u.address_id

from users as u