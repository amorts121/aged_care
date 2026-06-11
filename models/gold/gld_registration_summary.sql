with registrations as (
    select * from {{ ref('slv_provider_registration') }}
),

final as (
    select
        -- keys
        registration_key,
        provider_key,
        service_key,
        registration_id,

        -- provider details
        provider_id,
        provider_name,
        abn,
        provider_state,

        -- service details
        service_name,
        service_type,
        service_state,
        capacity,

        -- registration details
        submitted_date,
        registration_status,
        status_date,
        assessed_by,

        -- risk details
        risk_rating,
        risk_score,
        assessment_date,
        next_review_date,

        -- flags
        is_approved,
        is_rejected,
        is_high_risk,
        is_review_overdue,

        -- derived reporting columns
        datediff('day', submitted_date, coalesce(status_date, current_date()))  as days_to_decision,
        case
            when is_approved and is_high_risk then 'Approved - High Risk'
            when is_approved and risk_rating = 'Medium' then 'Approved - Medium Risk'
            when is_approved and risk_rating = 'Low' then 'Approved - Low Risk'
            when is_approved and risk_rating is null then 'Approved - Pending Assessment'
            when is_rejected then 'Rejected'
            when registration_status = 'Under Review' then 'Under Review'
            else 'Submitted'
        end                                                                     as registration_summary_status,

        _loaded_date
    from registrations
)

select * from final
