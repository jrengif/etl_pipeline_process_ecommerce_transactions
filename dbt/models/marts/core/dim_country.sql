{{ 
  config(
    schema=var("analytics_schema", "olap_layer"), 
    materialized='incremental',
    unique_key='country_id'
  ) 
}}

-- models/dim_country.sql

WITH raw_data AS (
    SELECT 
        DISTINCT country
    FROM {{ source('staging_layer_db', 'raw_online_retail_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS country_id,
    country AS country_name
FROM raw_data
