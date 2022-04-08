with orders as(
    select * from {{ref('stg_orders')}}
),

payments as(
    select * from {{ref('stg_payments')}}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        payments.amount,
        payments.status
    from orders
    inner join payments using (order_id)
)

select * from final