SELECT
    d.year,
    d.month,
    g.country,
    c.category_name,
    SUM(f.amount) AS revenue
FROM analytics.fact_revenue f
JOIN analytics.dim_date d ON f.date_key = d.date_key
JOIN analytics.dim_geography g ON f.geography_key = g.geography_key
JOIN analytics.dim_category c ON f.category_key = c.category_key
GROUP BY 1,2,3,4
ORDER BY revenue DESC;
