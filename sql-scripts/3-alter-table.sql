use reports;

ALTER TABLE fact_date_customer_campaign
RENAME COLUMN cost TO other_cost;

ALTER TABLE fact_date_customer_campaign
RENAME COLUMN datacost TO data_cost;

ALTER TABLE fact_date_customer_campaign
RENAME COLUMN revenue TO net_revenue;



