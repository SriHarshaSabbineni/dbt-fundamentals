with payments as (
    select
        orderid as order_id,
        status,
        amount
    from raw.stripe.payment
)

select * from payments