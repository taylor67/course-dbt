SELECT *
FROM {{ ref('dim_orders') }}
WHERE delivered_date < created_date 
/* checking if there are any instances where the delivery date is before the date the order was placed which wouldn't make sense logically and indicate some sort of data issue */