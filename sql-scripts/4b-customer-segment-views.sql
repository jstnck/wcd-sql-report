use reports;



SELECT dc.customer_id, segment FROM dim_customer as dc
RIGHT JOIN fact_date_customer_campaign
ON fact_date_customer_campaign.customer_id = dc.customer_id;

CREATE OR REPLACE VIEW segment_data as
SELECT fc.date, dc.segment, fc.other_cost, fc.data_cost, fc.net_revenue
FROM fact_date_customer_campaign as fc
LEFT JOIN dim_customer as dc
ON dc.customer_id = fc.customer_id;

CREATE OR REPLACE VIEW daily_revenue2 as
SELECT year, day
FROM daily_revenue
WHERE day <=
    (SELECT max(day)
    FROM daily_revenue
    WHERE year = 2018
    );

CREATE OR REPLACE VIEW seg_daily_revenue as
SELECT year(date) as year, dayofyear(date) as day, segment,
       sum(data_cost) as data_cost,
       sum(other_cost) as other_cost,
       sum(net_revenue) as net_revenue,
       sum(data_cost) + sum(other_cost) + sum(net_revenue) as gross_revenue
FROM segment_data
GROUP BY segment, year, day;


# also removes the extra days in 2017
CREATE OR REPLACE VIEW seg_a_daily as
SELECT year, day, gross_revenue, net_revenue FROM seg_daily_revenue
WHERE segment = "Segment A"
AND day <=
    (SELECT max(day)
    FROM daily_revenue
    WHERE year = 2018
    );



CREATE OR REPLACE VIEW seg_a_weekly as
SELECT year, (floor(day / 7)+1) as week,
       sum(net_revenue) as net_revenue,
       sum(gross_revenue) as gross_revenue
FROM seg_a_daily
GROUP BY year, week;

# table view
CREATE OR REPLACE VIEW growth_report as
SELECT year, week, gross_revenue, net_revenue ,
       net_revenue / gross_revenue as margin,
       (gross_revenue / LAG(gross_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_gross,
       (net_revenue / LAG(net_revenue, 1) OVER (ORDER BY year, week) -1) as week_over_week_net,
       (gross_revenue / LAG(gross_revenue, 39) OVER (ORDER BY year, week) -1) as year_over_year_gross,
       (gross_revenue / LAG(gross_revenue, 39) OVER (ORDER BY year, week) -1) as year_over_year_net
FROM seg_a_weekly;

CREATE OR REPLACE VIEW report_2018 as
SELECT year, week, gross_revenue, net_revenue, margin, week_over_week_gross, week_over_week_net, year_over_year_gross, year_over_year_net
FROM growth_report
WHERE year = 2018;

CREATE OR REPLACE VIEW report_2017 as
SELECT year, week, gross_revenue, net_revenue, margin, week_over_week_gross, week_over_week_net
FROM growth_report
WHERE year = 2017;





# final report output
SELECT  r18.year as `current year`,
       r18.week as week,
       r18.gross_revenue as `gross revenue`,
       r18.net_revenue as `net revenue`,
       r18.margin as margin,
       r18.week_over_week_gross as `week/week gross`,
       r18.week_over_week_net as `week/week net`,
       r18.year_over_year_gross as `year/year gross`,
       r18.year_over_year_net as `year/year net`,
       ' ' as '---------',
       r17.year as `previous year`,
       r17.week as week,
       r17.gross_revenue as `gross revenue`,
       r17.net_revenue as `net revenue`,
       r17.margin as margin,
       r17.week_over_week_gross as `week/week gross`,
       r17.week_over_week_net as `week/week net`
FROM report_2018 as r18
LEFT JOIN report_2017 as r17
ON r17.week = r18.week;





