with users_source as (
    select * from {{ source('src_postgres', 'users')}}
)

, renamed_casted as (
    select 
        * 
    from users_source
)

select * from renamed_casted