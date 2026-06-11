with source as (
    select * from {{ ref('raw_service') }}
),

cleaned as (
    select
        SERVICE_ID                                          as service_id,
        PROVIDER_ID                                         as provider_id,
        initcap(trim(SERVICE_NAME))                         as service_name,
        initcap(nullif(trim(SERVICE_TYPE), ''))             as service_type,
        upper(trim(STATE))                                  as state,
        CAPACITY                                            as capacity,
        START_DATE                                          as start_date,
        current_date()                                      as _loaded_date,
        'RAW.RAW_SERVICE'                                   as _source
    from source
)

select * from cleaned
