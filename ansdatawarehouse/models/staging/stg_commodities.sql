-- import o schema

with source as (
    select
        "Date",
        "Close",
        "simbolo"
    from 
        {{ source ('dbt_database', 'commodities') }}
),

--- comecanda a usar jinja para renomear as colunas
renamed as (

    select
        cast("Date" as date) as data,
        "Close" as valor_fechamento,
        simbolo
    from
        source
)

select * from renamed