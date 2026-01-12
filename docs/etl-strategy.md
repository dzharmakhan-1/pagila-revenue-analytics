## Strategy
SQL implements a basic ETL (Extract, Transform, Load) process to move data from the Pagila public schema (source) to analytics (target). 
Here's a structured strategy based on your commands, with best practices:

## Extract

    1. Copy raw data into staging schema using CREATE TABLE ... AS SELECT * FROM public.<table>.
    2. Why Staging? Acts as a buffer—isolates source from analytics, allows validation/cleaning without affecting production data. In Pagila, this is simple since it's a sample DB, but in real scenarios, use tools like Apache Airflow or dbt for scheduling.
    3. Potential improvements: Add timestamps (e.g., loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP) to track loads. Handle increments (e.g., only new data via WHERE clauses) for ongoing ETL.

## Transform

    1. Dimensions: Use DISTINCT to denormalize and create hierarchies (e.g., date parts in dim_date). Joins for dim_geography and dim_store enrich with related attributes.
    2. Fact: Heavy joins across staging tables to link payment → rental → inventory → film_category → customer geography → store. Filter/transform as needed (e.g., casting dates).

## Load

    1. INSERT into analytics tables post-transform.
    2. Strategy: Full load (truncate and reload) works for small data like Pagila. For larger, use UPSERT (ON CONFLICT) or incremental loads (e.g., based on max date_key).
    3. Dependencies: Load dimensions first (your order is good: dates, categories, geography, stores, then fact).
    4. Error Handling: Wrap in transactions; log failures.

## Overall pipeline

    1. Frequency: Daily/weekly, based on data freshness needs.
    2. Monitoring: Add views or queries to compare row counts (source vs. target).
    3. Automation: Script in Bash/Python, or use ETL tools. Example flow: Extract → Validate (row counts, sums) → Transform → Load → Test (run sample queries).
    4. Security: Use schemas for access control (e.g., read-only on staging).
