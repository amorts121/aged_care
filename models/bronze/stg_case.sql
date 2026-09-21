-- Bronze layer: light typing/renaming only, no business logic
with source as (

    select * from {{ ref('raw_case') }}

)

select
    case_id,
    provider_id,
    subtype_code,
    status,
    created_date::date as created_date,
    last_updated_date::date as last_updated_date

from source
