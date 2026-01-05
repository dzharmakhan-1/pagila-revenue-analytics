CREATE TABLE analytics.dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    day INT,
    month INT,
    month_name TEXT,
    quarter INT,
    year INT
);

INSERT INTO analytics.dim_date (full_date, day, month, month_name, quarter, year)
SELECT DISTINCT
    payment_date::date,
    EXTRACT(DAY FROM payment_date),
    EXTRACT(MONTH FROM payment_date),
    TO_CHAR(payment_date, 'Month'),
    EXTRACT(QUARTER FROM payment_date),
    EXTRACT(YEAR FROM payment_date)
FROM staging.payment;
