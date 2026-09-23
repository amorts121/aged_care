-- Silver layer: business logic applied — this mirrors the Case Subtype pattern
-- used as the SQL DBM anchor model earlier in the programme
with cases as (

    select * from {{ ref('stg_case') }}

),

providers as (

    select * from {{ ref('stg_provider') }}

)

select
    c.provider_id,
    p.provider_name,
    p.state,
    c.subtype_code,
    c.status,
    c.created_date,
    c.last_updated_date,
    datediff('day', c.created_date, coalesce(c.last_updated_date, current_date())) as days_open

from cases c
left join providers p
    on c.provider_id = p.provider_id
