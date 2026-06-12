with providers as (
    select * from {{ ref('slv_provider_dim') }}
),

services as (
    select * from {{ ref('brz_raw_service') }}
),

registrations as (
    select * from {{ ref('slv_provider_registration') }}
),

-- aggregations are calculated here in gold, not in silver
provider_stats as (
    select
        provider_id,
        count(distinct service_id)                              as total_services,
        count(distinct registration_id)                         as total_registrations,
        sum(case when is_approved then 1 else 0 end)            as approved_registrations,
        sum(case when is_rejected then 1 else 0 end)            as rejected_registrations
    from registrations
    group by provider_id
),

service_stats as (
    select
        provider_id,
        max(capacity)                                           as max_service_capacity
    from services
    group by provider_id
),

final as (
    select
        p.provider_key,
        p.provider_id,
        p.provider_name,
        p.abn,
        p.state,
        p.phone,
        p.email,
        p.created_date,

        coalesce(ps.total_services, 0)                          as total_services,
        coalesce(ps.total_registrations, 0)                     as total_registrations,
        coalesce(ps.approved_registrations, 0)                  as approved_registrations,
        coalesce(ps.rejected_registrations, 0)                  as rejected_registrations,
        ss.max_service_capacity,

        case when coalesce(ps.approved_registrations, 0) > 0
            then true else false end                            as is_active_provider,

        p._loaded_date
    from providers p
    left join provider_stats ps on p.provider_id = ps.provider_id
    left join service_stats ss on p.provider_id = ss.provider_id
)

select * from final