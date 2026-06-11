with providers as (
    select * from {{ ref('brz_raw_provider') }}
),

services as (
    select * from {{ ref('brz_raw_service') }}
),

registrations as (
    select * from {{ ref('brz_raw_registration') }}
),

-- aggregate service and registration counts per provider
provider_stats as (
    select
        p.provider_id,
        count(distinct s.service_id)                            as total_services,
        count(distinct r.registration_id)                       as total_registrations,
        sum(case when r.registration_status = 'Approved'
            then 1 else 0 end)                                  as approved_registrations,
        sum(case when r.registration_status = 'Rejected'
            then 1 else 0 end)                                  as rejected_registrations,
        max(s.capacity)                                         as max_service_capacity
    from providers p
    left join services s on p.provider_id = s.provider_id
    left join registrations r on p.provider_id = r.provider_id
    group by p.provider_id
),

final as (
    select
        {{ generate_surrogate_key(['p.provider_id']) }}         as provider_key,
        p.provider_id,
        p.provider_name,
        p.abn,
        p.state,
        p.phone,
        p.email,
        p.created_date,
        ps.total_services,
        ps.total_registrations,
        ps.approved_registrations,
        ps.rejected_registrations,
        ps.max_service_capacity,
        case when ps.approved_registrations > 0
            then true else false end                            as is_active_provider,
        p._loaded_date
    from providers p
    left join provider_stats ps on p.provider_id = ps.provider_id
)

select * from final
