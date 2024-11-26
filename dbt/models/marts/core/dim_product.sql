{{ 
  config(
    schema=var("analytics_schema", "olap_layer"), 
    materialized='incremental',
    unique_key='product_id'
  ) 
}}


-- models/dim_product.sql

WITH raw_data AS (
    SELECT 
        DISTINCT
        stock_code,
        description
    FROM  {{ source('staging_layer_db', 'raw_online_retail_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY stock_code) AS product_id,
    stock_code,
    description
FROM raw_data
