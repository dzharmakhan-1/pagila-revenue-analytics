## Design Overview:
This setup uses a classic star schema in the analytics schema, which is well-suited for analytical reporting (OLAP). This design separates dimensional data (who, what, where, when) from factual measures (revenue amounts), enabling efficient aggregations and queries. The ERD (from the screenshot) visually confirms this:

    1. Central Fact Table: fact_revenue holds the measurable data (revenue amounts) and foreign keys linking to dimensions.
    2. Dimension Tables: dim_date (time), dim_category (film categories), dim_geography (customer locations), dim_store (store details). These provide context for slicing and dicing the data.

This structure aligns directly with the business question: Revenue per time unit and geography based on film category. 
It allows grouping revenue by time hierarchies (e.g., day, month, quarter, year), 
geographic attributes (city, country from customers), film categories, and even store details for deeper analysis.

## Why This Design?

Efficiency for Analytics: Star schemas optimize for read-heavy workloads. Joins are simple (fact to dimensions), and aggregations (e.g., SUM(amount)) perform well without complex nested queries. 
In contrast, the normalized Pagila public schema is better for OLTP (transactional inserts/updates) but slower for reporting.

**Dimensional Modeling:**

    1. Time is handled via dim_date for hierarchical breakdowns (day/month/quarter/year), avoiding repeated date extractions in queries.
    2. Geography focuses on customer location (city/country), which makes sense for revenue attribution—revenue is tied to where customers are, not just stores.
    3. Categories are straightforward for film-based segmentation.
    4.Stores add an extra layer (e.g., manager, location), useful if you want to analyze performance by store alongside customer geography.

**Scalability and Maintainability:**

Dimensions are populated with DISTINCT values, reducing redundancy. 
The fact table stores detailed transactions, allowing both granular views and aggregated reports. 
If data volume grows, this supports tools like indexes or partitioning.

**Business Alignment:** 

It directly supports roll-ups (e.g., total revenue by year and country) and drill-downs (e.g., from country to city). 
Without this, answering business question would require ad-hoc joins across 10+ public tables, which is error-prone and slow.

## Potential improvements:

    1. The dim_geography uses city/country pairs as unique, assuming no duplicate city names across countries (valid in Pagila's small dataset but not globally). 
    Consider adding a city_id or country_id for stricter uniqueness.
    2. The INSERT into fact_revenue has a subquery in the JOIN for geography (ON a.city_id IN (SELECT ... WHERE city = g.city)), 
    which works but could be inefficient; a direct JOIN on city and country would be better.

## Granularity:
**Fact Table Granularity:** 
The fact_revenue table is at the transactional level, specifically per individual payment (which in Pagila corresponds 1:1 with rentals, as each rental has one payment). 
Each row represents a single revenue event:

    1. Identified by rental_id (unique per row).
    2. Measure: amount (the payment value for that rental).
    3. Additivity: Fully additive (you can SUM(amount) across any dimensions without issues).

This is the lowest level of detail, allowing queries from individual rentals up to high-level aggregates (e.g., yearly totals).

Time unit: Down to daily (via date_key linking to full_date).

Geography: Per customer city/country.

Category: Per film category.

Not aggregated yet—aggregation happens in reports/queries.

**Why This Level?**

It preserves flexibility. If you need per-rental details (e.g., auditing), it's there; for summaries, just GROUP BY.
