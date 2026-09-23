-- Bronze layer: light typing/renaming only, no business logic
with source as (

    select * from {{ ref('raw_provider') }}

)

select
    provider_id,
    provider_name,
    state,
    is_active 

from source
