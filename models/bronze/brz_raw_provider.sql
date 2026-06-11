with source as (
    select * from {{ ref('raw_provider') }}
),

deduplicated as (
    select *,
        row_number() over (
            partition by PROVIDER_ID
            order by CREATED_DATE asc
        ) as row_num
    from source
),

cleaned as (
    select
        PROVIDER_ID                                         as provider_id,
        initcap(trim(PROVIDER_NAME))                        as provider_name,
        nullif(trim(ABN), '')                               as abn,
        upper(trim(STATE))                                  as state,
        nullif(trim(PHONE), '')                             as phone,
        lower(trim(EMAIL))                                  as email,
        CREATED_DATE                                        as created_date,
        current_date()                                      as _loaded_date,
        'RAW.RAW_PROVIDER'                                  as _source
    from deduplicated
    where row_num = 1
)

select * from cleaned
