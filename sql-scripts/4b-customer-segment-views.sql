use reports;


# add the customer segment data to the fact table
CREATE OR REPLACE VIEW segment_data as
SELECT fc.date, dc.segment, fc.other_cost, fc.data_cost, fc.net_revenue
FROM fact_date_customer_campaign as fc
LEFT JOIN dim_customer as dc
ON dc.customer_id = fc.customer_id;

# aggregate the daily data together
CREATE OR REPLACE VIEW seg_daily_revenue as
SELECT year(date) as year, dayofyear(date) as day, segment,
       sum(data_cost) as data_cost,
       sum(other_cost) as other_cost,
       sum(net_revenue) as net_revenue,
       sum(data_cost) + sum(other_cost) + sum(net_revenue) as gross_revenue
FROM segment_data
GROUP BY segment, year, day;


# also removes the extra days in 2017, drop the cost data as its not needed in final report
CREATE OR REPLACE VIEW seg_a_daily as
SELECT year, day, gross_revenue, net_revenue
FROM seg_daily_revenue
WHERE segment = "Segment A"
AND day <=
    (SELECT max(day)
    FROM daily_revenue
    WHERE year = 2018
    );

# sum the daily data into weekly data
CREATE OR REPLACE VIEW seg_a_weekly as
SELECT year, (floor(day / 7)+1) as week,
       sum(net_revenue) as net_revenue,
       sum(gross_revenue) as gross_revenue
FROM seg_a_daily
GROUP BY year, week;

# calculate the margin and growth rates
CREATE OR REPLACE VIEW growth_report as
SELECT year, week, gross_revenue, net_revenue ,
       net_revenue / gross_revenue as margin,
       (gross_revenue / LAG(gross_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_gross,
       (net_revenue / LAG(net_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_net,
       (gross_revenue / LAG(gross_revenue, 39) OVER (ORDER BY year, week) -1) as year_over_year_gross,
       (net_revenue / LAG(net_revenue, 39) OVER (ORDER BY year, week) -1) as year_over_year_net
FROM seg_a_weekly;

# create helper views for 2017 and 2018, so its easier to create the final report table
CREATE OR REPLACE VIEW report_2018 as
SELECT year, week, gross_revenue, net_revenue, margin, week_over_week_gross, week_over_week_net, year_over_year_gross, year_over_year_net
FROM growth_report
WHERE year = 2018;

CREATE OR REPLACE VIEW report_2017 as
SELECT year, week, gross_revenue, net_revenue, margin, week_over_week_gross, week_over_week_net
FROM growth_report
WHERE year = 2017;








