{{
  config(
    materialized='table'
  )
}}

with promos_source as (
    select * from {{ source('src_postgres', 'promos')}}
)

, renamed_casted as (
    select 
        promo_id,
        discount,
        status
    from promos_source
)

select * from renamed_casted