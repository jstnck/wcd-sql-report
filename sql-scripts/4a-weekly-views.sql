use reports;

SELECT campaign_id, SUM(revenue) FROM fact_date_customer_campaign
GROUP BY campaign_id;


SELECT customer_id, date, YEAR(date) as year
FROM fact_date_customer_campaign;

CREATE OR REPLACE VIEW daily_revenue as
SELECT year(date) as year, dayofyear(date) as day,
       sum(data_cost) as data_cost,
       sum(other_cost) as other_cost,
       sum(net_revenue) as net_revenue,
       sum(data_cost) + sum(other_cost) + sum(net_revenue) as gross_revenue
FROM fact_date_customer_campaign
GROUP BY year, day;




create or replace view weekly_revenue as
SELECT year, (floor(day / 7)+1) as week,
       sum(data_cost) as data_cost,
       sum(other_cost) as other_cost,
       sum(net_revenue) as net_revenue,
       sum(gross_revenue) as gross_revenue
FROM daily_revenue
GROUP BY year, week;





# weekly lag
SELECT year, week, gross_revenue, LAG(gross_revenue, 1) OVER (ORDER BY year, week) as lag_gross_revenue
FROM weekly_revenue;

# annual lag
SELECT year, week, gross_revenue,
        (gross_revenue / LAG(gross_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week,
       (gross_revenue / LAG(gross_revenue, 53) OVER (ORDER BY year, week) -1) as year_over_year
FROM weekly_revenue;

# table view
SELECT * ,
       net_revenue / gross_revenue as margin,
       (gross_revenue / LAG(gross_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_gross,
       (net_revenue / LAG(net_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_net,
       (gross_revenue / LAG(gross_revenue, 53) OVER (ORDER BY year, week) -1) as year_over_year_gross,
       (gross_revenue / LAG(gross_revenue, 53) OVER (ORDER BY year, week) -1) as year_over_year_net
FROM weekly_revenue;

