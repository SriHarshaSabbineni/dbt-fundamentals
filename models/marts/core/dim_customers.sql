{{ config (
    materialized="table"
)}}

with customers as(
    select * from {{ref('stg_customers')}}
),

orders as(
    select * from {{ref('stg_orders')}}
),

fct_orders as(
    select * from {{ref('fct_orders')}}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

totals as(
    select
        customer_id,
        sum(case when status = 'success' then amount end) as lifetime_value
    from fct_orders
    group by customer_id
),

dim_cust as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

),

final as(
    select
        dim_cust.customer_id,
        dim_cust.first_name,
        dim_cust.last_name,
        dim_cust.first_order_date,
        dim_cust.most_recent_order_date,
        dim_cust.number_of_orders,
        totals.lifetime_value

    from dim_cust

    inner join totals using (customer_id)
)

select * from final