{{ 
  config(
    schema=var("analytics_schema", "olap_layer"), 
    materialized='incremental',
    unique_key='customer_id'
  ) 
}}


-- models/dim_customer.sql

WITH raw_data AS (
    SELECT 
        DISTINCT
        customer_id,
        CAST(customer_id AS INT) AS customer_natural_id
    FROM  {{ source('staging_layer_db', 'raw_online_retail_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_id,
    customer_natural_id
FROM raw_data
