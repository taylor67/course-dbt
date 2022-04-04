
conversion percentages:
* add_to_cart_pct_of_all_sessions: 80.8%
* checkout_pct_of_all_sessions: 62.46%

drop off points: 
* page_view -> add_to_cart: 19% drop off 
* add_to_cart -> checkout: 18% drop off

Code: 
```
select 
  add_to_cart_pct_of_all_sessions,
  checkout_pct_of_all_sessions,
  1.0-add_to_cart_pct_of_all_sessions as add_to_cart_dropoff_from_prior_stage,
  add_to_cart_pct_of_all_sessions-checkout_pct_of_all_sessions as checkout_dropoff_from_prior_stage
from dbt_taylor_o.fct_funnel_agg
```