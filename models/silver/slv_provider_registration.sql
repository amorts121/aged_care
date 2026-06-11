with providers as (
    select * from {{ ref('brz_raw_provider') }}
),

services as (
    select * from {{ ref('brz_raw_service') }}
),

registrations as (
    select * from {{ ref('brz_raw_registration') }}
),

risk_assessments as (
    select * from {{ ref('brz_raw_risk_assessment') }}
),

joined as (
    select
        -- surrogate keys
        {{ generate_surrogate_key(['r.registration_id']) }}     as registration_key,
        {{ generate_surrogate_key(['p.provider_id']) }}         as provider_key,
        {{ generate_surrogate_key(['s.service_id']) }}          as service_key,

        -- registration natural key
        r.registration_id,

        -- provider attributes
        p.provider_id,
        p.provider_name,
        p.abn,
        p.state                                                 as provider_state,

        -- service attributes
        s.service_id,
        s.service_name,
        s.service_type,
        s.state                                                 as service_state,
        s.capacity,

        -- registration attributes
        r.submitted_date,
        r.registration_status,
        r.status_date,
        r.assessed_by,

        -- risk assessment attributes (null for non-approved registrations)
        ra.assessment_id,
        ra.risk_rating,
        ra.risk_score,
        ra.assessment_date,
        ra.next_review_date,

        -- derived flags
        case when r.registration_status = 'Approved' then true else false end   as is_approved,
        case when r.registration_status = 'Rejected' then true else false end   as is_rejected,
        case when ra.risk_rating = 'High' then true else false end               as is_high_risk,
        case
            when ra.next_review_date is not null
            and ra.next_review_date < current_date()
            then true else false
        end                                                                      as is_review_overdue,

        -- audit
        r._loaded_date

    from registrations r
    inner join providers p
        on r.provider_id = p.provider_id
    inner join services s
        on r.service_id = s.service_id
    left join risk_assessments ra
        on r.registration_id = ra.registration_id
)

select * from joined
