with source as (
    select * from {{ ref('raw_registration') }}
),

cleaned as (
    select
        REGISTRATION_ID                                     as registration_id,
        PROVIDER_ID                                         as provider_id,
        SERVICE_ID                                          as service_id,
        SUBMITTED_DATE                                      as submitted_date,
        initcap(nullif(trim(STATUS), ''))                   as registration_status,
        STATUS_DATE                                         as status_date,
        nullif(trim(ASSESSED_BY), '')                       as assessed_by,
        nullif(trim(NOTES), '')                             as notes,
        current_date()                                      as _loaded_date,
        'RAW.RAW_REGISTRATION'                              as _source
    from source
)

select * from cleaned
