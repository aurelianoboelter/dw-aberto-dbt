-- models/datamart/dm_commodities.sql

with commodities as (
    select
        data,
        simbolo,
        valor_fechamento
    from 
        {{ ref ('stg_commodities') }}
),

movimentacao as (
    select
        date,
        symbol,
        action,
        quantity
    from 
        {{ ref ('movimentacao_commodities') }}
),

joined as (
    select
        c.data,
        c.simbolo,
        c.valor_fechamento,
        m.action,
        m.quantity,
        (m.quantity * c.valor_fechamento) as valor,
        case
            when m.action = 'sell' then (m.quantity * c.valor_fechamento)
            else -(m.quantity * c.valor_fechamento)
        end as ganho
    from
        commodities c
    inner join
        movimentacao m
    on
        c.data = m.date
        and c.simbolo = m.symbol
),

last_day as (
    select
        max(data) as max_date
    from
        joined
),

filtrados as (
    select
        *
    from
        joined
    where
        data = (select max_date from last_day)
)

select
    data,
    simbolo,
    valor_fechamento,
    action,
    quantity,
    valor,
    ganho
from
    filtrados