with providers as (
    select * from {{ ref('brz_raw_provider') }}
),

final as (
    select
        {{ generate_surrogate_key(['provider_id']) }}         as provider_key,
        provider_id,
        provider_name,
        abn,
        state,
        phone,
        email,
        created_date,
        _loaded_date
    from providers
)

select * from final