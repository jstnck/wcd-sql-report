use reports;

# remove extra days from 2017



CREATE OR REPLACE VIEW daily_revenue2 as
SELECT year, day
FROM daily_revenue
WHERE day <=
    (SELECT max(day)
    FROM daily_revenue
    WHERE year = 2018
    );

create or replace view weekly_revenue2 as
SELECT year, (floor(day / 7)+1) as week,
       sum(data_cost) as data_cost,
       sum(other_cost) as other_cost,
       sum(net_revenue) as net_revenue,
       sum(data_cost) + sum(other_cost) + sum(net_revenue) as gross_revenue
FROM daily_revenue
GROUP BY year, week;

