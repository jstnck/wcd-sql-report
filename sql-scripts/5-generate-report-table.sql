use reports;


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
