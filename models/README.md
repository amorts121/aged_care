# ACQSC Demo dbt Project

A synthetic end-to-end dbt project built to demonstrate modern data modelling practices using a fictional aged care regulatory scenario. Used as a teaching resource for the ACQSC Data Modelling Transformation Programme.

---

## Scenario

A fictional aged care regulator manages **provider registrations**. Providers apply to deliver aged care services, go through an assessment workflow, and are assigned a risk rating upon approval.

### Entities
- **Provider** — the organisation applying to deliver aged care services
- **Service** — the specific care service(s) a provider offers (e.g. residential, home care)
- **Registration** — the application and its status workflow (Submitted → Under Review → Approved / Rejected)
- **Risk Assessment** — a risk rating assigned to providers upon registration approval

---

## Project Structure

```
acqsc_demo/
├── seeds/              # Raw synthetic source data (CSV)
├── models/
│   ├── bronze/         # Cleaned, renamed, cast source data (views)
│   ├── silver/         # Subject-area models with business rules (tables)
│   └── gold/           # Consumption-ready reporting models (tables)
├── macros/             # Reusable SQL macros
├── tests/              # Custom data tests
└── docs/               # Supporting documentation
```

---

## Naming Conventions

See [NAMING_CONVENTIONS.md](./docs/NAMING_CONVENTIONS.md) for the full reference.

| Element | Convention | Example |
|---|---|---|
| Primary key | `<entity>_key` (surrogate) | `provider_key` |
| Natural/source key | `<entity>_id` | `provider_id` |
| Foreign key | `<entity>_key` | `provider_key` |
| Date fields | `<event>_date` | `submitted_date` |
| Timestamp fields | `<event>_at` | `created_at` |
| Boolean/flag fields | `is_<condition>` | `is_approved` |
| Source prefix (bronze) | `<source>__<entity>` | `proxydb__provider` |
| Status fields | `<entity>_status` | `registration_status` |

---

## Layers

### Bronze
- Source: `RAW` schema (dbt seeds in this demo)
- Materialisation: views
- Responsibilities: deduplicate, cast data types, rename to conventions, standardise categorical values, basic null handling
- **No business logic**

### Silver
- Source: bronze models
- Materialisation: tables
- Responsibilities: resolve relationships, apply business rules, generate surrogate keys, subject-area structure
- Grain documented in yml for every model

### Gold
- Source: silver models
- Materialisation: tables
- Responsibilities: consumption-ready aggregations and joins for reporting
- Named for the business concept they serve, not the technical structure

---

## Getting Started

1. Clone this repo
2. Set environment variables for your Snowflake connection (see `profiles.yml`)
3. Run `dbt seed` to load synthetic data into your RAW schema
4. Run `dbt run` to build all models
5. Run `dbt test` to validate

---

## Notes

- All data is synthetic and fictional
- Intentional data quality issues exist in the seed files — these are teaching points for the bronze layer
- Cortex Code integration examples are covered separately
