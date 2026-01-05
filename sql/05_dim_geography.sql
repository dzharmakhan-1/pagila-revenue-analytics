CREATE TABLE analytics.dim_geography (
    geography_key SERIAL PRIMARY KEY,
    city TEXT,
    country TEXT
);

INSERT INTO analytics.dim_geography (city, country)
SELECT DISTINCT
    ci.city,
    co.country
FROM staging.customer cu
JOIN staging.address a ON cu.address_id = a.address_id
JOIN staging.city ci ON a.city_id = ci.city_id
JOIN staging.country co ON ci.country_id = co.country_id;
