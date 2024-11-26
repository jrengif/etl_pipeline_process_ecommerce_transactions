{{ 
  config(
    schema=var("analytics_schema", "olap_layer"), 
    materialized='incremental',
    unique_key='transaction_id'
  ) 
}}

-- models/fact_transactions.sql
WITH transaction_data AS (
    SELECT 
        invoice_no,
        CAST(invoice_date AS DATE) AS invoice_date,
        customer_id,
        stock_code,
        country,
        quantity,
        unit_price,
        quantity * unit_price AS total_amount
    FROM  {{ source('staging_layer_db', 'raw_online_retail_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY t.invoice_no, t.stock_code) AS transaction_id,
    t.invoice_no,
    d.date_id AS invoice_date,
    c.customer_id AS customer_id,
    p.product_id AS product_id,
    co.country_id AS country_id,
    t.quantity,
    t.unit_price,
    t.total_amount
FROM transaction_data t
JOIN {{ ref('dim_date') }} d ON d.date = t.invoice_date
JOIN {{ ref('dim_customer') }} c ON c.customer_natural_id = t.customer_id
JOIN {{ ref('dim_product') }} p ON p.stock_code = t.stock_code
JOIN {{ ref('dim_country') }} co ON co.country_name = t.country