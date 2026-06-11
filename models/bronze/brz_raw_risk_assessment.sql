with source as (
    select * from {{ ref('raw_risk_assessment') }}
),

cleaned as (
    select
        ASSESSMENT_ID                                       as assessment_id,
        REGISTRATION_ID                                     as registration_id,
        PROVIDER_ID                                         as provider_id,
        ASSESSMENT_DATE                                     as assessment_date,
        initcap(nullif(trim(RISK_RATING), ''))              as risk_rating,
        RISK_SCORE                                          as risk_score,
        nullif(trim(ASSESSOR), '')                          as assessor,
        NEXT_REVIEW_DATE                                    as next_review_date,
        current_date()                                      as _loaded_date,
        'RAW.RAW_RISK_ASSESSMENT'                           as _source
    from source
)

select * from cleaned
