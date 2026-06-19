-- =============================================================
-- SANDBOX MODEL: Registrations Under Review
-- =============================================================
-- Purpose: Quick prototype to validate a business requirement
-- before committing to full silver/gold modelling.
--
-- Business question: "How many registrations are currently
-- under review and how long have they been waiting?"
--
-- This model reads directly from bronze — no silver dependency.
-- It is a view, costs nothing to run, and can be shared with
-- the business immediately for requirement validation.
--
-- Once validated, the logic here informs the silver model
-- design. This file is then retired.
-- =============================================================

with registrations as (
    select * from {{ ref('brz_raw_registration') }}
),

providers as (
    select * from {{ ref('brz_raw_provider') }}
),

under_review as (
    select
        r.registration_id,
        p.provider_name,
        p.state,
        r.service_id,
        r.submitted_date,
        r.registration_status,
        r.assessed_by,
        datediff('day', r.submitted_date, current_date())       as days_waiting,
        case
            when datediff('day', r.submitted_date, current_date()) > 30
            then true else false
        end                                                     as is_waiting_over_30_days
    from registrations r
    inner join providers p
        on r.provider_id = p.provider_id
    where r.registration_status = 'Under Review'
)

select * from under_review
