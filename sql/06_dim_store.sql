CREATE TABLE analytics.dim_store (
    store_key SERIAL PRIMARY KEY,
    store_id INT,
    manager_name TEXT,
    city TEXT,
    country TEXT
);

INSERT INTO analytics.dim_store (store_id, manager_name, city, country)
SELECT
    s.store_id,
    st.first_name || ' ' || st.last_name,
    ci.city,
    co.country
FROM staging.store s
JOIN staging.staff st ON s.manager_staff_id = st.staff_id
JOIN staging.address a ON s.address_id = a.address_id
JOIN staging.city ci ON a.city_id = ci.city_id
JOIN staging.country co ON ci.country_id = co.country_id;
