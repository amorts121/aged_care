-- Gold layer: reporting-ready aggregate, e.g. for a Power BI dashboard
select
    state,
    subtype_code,
    status,
    count(*) as case_count,
    avg(days_open) as avg_days_open

from {{ ref('int_case_subtype') }}
group by 1, 2, 3

