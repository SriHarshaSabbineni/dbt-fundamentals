with payments as (
    select
        orderid as order_id,
        status,
        amount
    from {{source('stripe','payment')}}
)

select * from payments