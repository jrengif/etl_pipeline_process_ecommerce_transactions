{{ 
  config(
    schema=var("analytics_schema", "olap_layer"), 
    materialized='incremental',
    unique_key='date_id'
  ) 
}}


-- models/dim_date.sql

WITH raw_data AS (
    SELECT DISTINCT
        CAST(invoice_date AS DATE) AS date
    FROM  {{ source('staging_layer_db', 'raw_online_retail_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY Date) AS date_id,
    date,
    EXTRACT(YEAR FROM Date) AS year,
    EXTRACT(QUARTER FROM Date) AS quarter,
    EXTRACT(MONTH FROM Date) AS month,
    TO_CHAR(Date, 'Month') AS month_name,
    EXTRACT(DAY FROM Date) AS day,
    TO_CHAR(Date, 'Day') AS weekday,
    CASE WHEN EXTRACT(DOW FROM Date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM raw_data
