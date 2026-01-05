CREATE TABLE analytics.fact_revenue (
    revenue_id SERIAL PRIMARY KEY,
    date_key INT REFERENCES analytics.dim_date(date_key),
    category_key INT REFERENCES analytics.dim_category(category_key),
    geography_key INT REFERENCES analytics.dim_geography(geography_key),
    store_key INT REFERENCES analytics.dim_store(store_key),
    amount NUMERIC(5,2),
    rental_id INT
);

INSERT INTO analytics.fact_revenue (
    date_key,
    category_key,
    geography_key,
    store_key,
    amount,
    rental_id
)
SELECT
    d.date_key,
    c.category_key,
    g.geography_key,
    s.store_key,
    p.amount,
    p.rental_id
FROM staging.payment p
JOIN staging.rental r ON p.rental_id = r.rental_id
JOIN staging.inventory i ON r.inventory_id = i.inventory_id
JOIN staging.film_category fc ON i.film_id = fc.film_id
JOIN analytics.dim_category c ON fc.category_id = c.category_id
JOIN analytics.dim_date d ON p.payment_date::date = d.full_date
JOIN staging.customer cu ON p.customer_id = cu.customer_id
JOIN staging.address a ON cu.address_id = a.address_id
JOIN analytics.dim_geography g ON a.city_id IN (
    SELECT city_id FROM staging.city WHERE city = g.city
)
JOIN staging.store st ON i.store_id = st.store_id
JOIN analytics.dim_store s ON st.store_id = s.store_id;
