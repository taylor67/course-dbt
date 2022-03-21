### (Part 1) Models 

#### 1. What is our user repeat rate?
%76.15

code:
```
select 
  1.0*count(
    distinct 
      case 
        when lifetime_orders > 1 then user_id
      else null
      end
  ) / count(distinct user_id) 
from dbt_taylor_o.fct_user_orders
```

#### 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this

To answer this question, I would want to pull out more information about the user. Some things we can answer include: 

* User repeat rate by join week cohort. Group users by the week that they had their first purchase, and see if repeat rate goes up or down over time. This would show us if our customer retention is improving over time.
* User repeat rate by first order days_delivered_late. This would show us if users who had their first order deliverd late were more likely to come back. 

```
select 
  is_repeat_customer,
  1.0*count(
    distinct
      case 
        when o.is_first_order and o.was_delivered_late then u.user_id
        else null
      end) --count users with late first orders
  / count(distinct u.user_id) --over count all users
from dbt_taylor_o.fct_user_order_agg u
left join dbt_taylor_o.dim_orders o
  on u.user_id = o.user_id
group by 1
```

Results show that repeat customers have a 45% chance that their first order was late, while non-repeat customers have a 48% chance that their first order was late. Not sure if this is significant. 

#### 3. Explain the marts models you added. Why did you organize the models in the way you did?

Under models, I added > `marts`, which is at the same level as > `schema`. Marts will store tables that are materialized as tables, which will either be `int_`, `dim_`, or `fct_` tables. Within `marts`, I added sub-folders depending on the business unit that has the most pressing use for these models: `core` (cannot be divided to one department, these are the universally useful models), `marketing`, and `product`. 

#### 4. Use the dbt docs to visualize your model DAGs to ensure the model layers make sense. 

* Issue: I created a test `order_delivered_after_created.sql` and I am not sure why it is showing up in my dag. 

![Alt text](https://i.imgur.com/ZcJFNZy.png?raw=true "Title")

### (Part 2) Tests 
#### 5. What assumptions are you making about each model? (i.e. why are you adding each test?)

Assumptions that are tested include: 
* Order created_date must happen before delieved_date. 
* All of the order cost fields (order_cost, order_total, shipping_cost) must be positive
* The promo discount field must be positive
* The order item quantity must be positive

#### 6. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

I found that a test I created was erroneous - I accidentally said that address_id must be unique in orders table and then I caught the mistake when the test failed. 

#### 7. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

We would use the data_freshness test, defined in the source. This sets the warn_after and error_after parameters, so that if the events table and the orders table (the two raw event tables) do not have new values for the fields created_at, an error / warning will appear when you run dbt tests. 