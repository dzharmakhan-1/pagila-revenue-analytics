CREATE TABLE analytics.dim_category (
    category_key SERIAL PRIMARY KEY,
    category_id INT,
    category_name TEXT
);

INSERT INTO analytics.dim_category (category_id, category_name)
SELECT DISTINCT category_id, name
FROM staging.category;
