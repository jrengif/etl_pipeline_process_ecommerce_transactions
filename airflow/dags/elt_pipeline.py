import os
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from ucimlrepo import fetch_ucirepo
import pandas as pd
from sqlalchemy import create_engine, inspect
from sqlalchemy.exc import SQLAlchemyError
import logging

# Enable SQLAlchemy logging to see the executed SQL queries
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def extract_and_upload_data(**kwargs):
    # Fetch dataset from UCI repository
    online_retail = fetch_ucirepo(id=352)

    # Extracting the 'ids' and 'features' DataFrames
    ids_df = online_retail['data']['ids']
    features_df = online_retail['data']['features']

    # Merging the two DataFrames on the index (InvoiceNo, StockCode)
    data = pd.merge(ids_df, features_df, left_index=True, right_index=True)
    
    rename_columns_dict = {
        "InvoiceNo": "invoice_no",
        "StockCode": "stock_code",
        "Description": "description",
        "Quantity": "quantity",
        "InvoiceDate": "invoice_date",
        "UnitPrice": "unit_price",
        "CustomerID": "customer_id",
        "Country": "country"
    }
    data = data.rename(columns=rename_columns_dict)

    # Access environment variables directly
    POSTGRES_STAGING_USER = os.getenv("POSTGRES_STAGING_USER")
    POSTGRES_STAGING_PASSWORD = os.getenv("POSTGRES_STAGING_PASSWORD")
    POSTGRES_STAGING_HOST = os.getenv("POSTGRES_STAGING_HOST")
    POSTGRES_STAGING_PORT = os.getenv("POSTGRES_STAGING_PORT")
    POSTGRES_STAGING_DB = os.getenv("POSTGRES_STAGING_DB")
    POSTGRES_STAGING_SCHEMA = os.getenv("POSTGRES_STAGING_SCHEMA", "public")
    POSTGRES_STAGING_RAW_TABLE = os.getenv("POSTGRES_STAGING_RAW_TABLE", "raw_online_retail_data")

    try:
        # Create SQLAlchemy engine
        engine = create_engine(
            f'postgresql://{POSTGRES_STAGING_USER}:{POSTGRES_STAGING_PASSWORD}@{POSTGRES_STAGING_HOST}:{POSTGRES_STAGING_PORT}/{POSTGRES_STAGING_DB}'
        )

        # Connect to the database and check for table existence
        with engine.connect() as connection:
            inspector = inspect(connection)
            if not inspector.has_table(POSTGRES_STAGING_RAW_TABLE, schema=POSTGRES_STAGING_SCHEMA):
                logger.info(f"Table {POSTGRES_STAGING_RAW_TABLE} does not exist. Creating table...")

                # Create the table schema in PostgreSQL based on the DataFrame structure
                data.head(0).to_sql(
                    POSTGRES_STAGING_RAW_TABLE,
                    con=engine,
                    schema=POSTGRES_STAGING_SCHEMA,
                    if_exists='replace',
                    index=False
                )
                logger.info(f"Table {POSTGRES_STAGING_RAW_TABLE} created successfully.")
            
            # Insert data into the table in chunks
            logger.info(f"Inserting data into {POSTGRES_STAGING_SCHEMA}.{POSTGRES_STAGING_RAW_TABLE}...")
            data.to_sql(
                POSTGRES_STAGING_RAW_TABLE,
                con=engine,
                schema=POSTGRES_STAGING_SCHEMA,
                if_exists='append',
                index=False,
                chunksize=1000  # Insert data in chunks of 1000 rows
            )
            logger.info(f"Data successfully inserted into {POSTGRES_STAGING_SCHEMA}.{POSTGRES_STAGING_RAW_TABLE}.")

    except SQLAlchemyError as e:
        logger.error(f"Error occurred: {e}")
        
# Define the DAG
with DAG(
    'dbt_python_operator_dag',
    description='A simple DAG with PythonOperator and DbtRunOperator',
    schedule_interval=None,
    start_date=datetime(2024, 11, 23),
    catchup=False,  # Avoid running DAGs for past dates
) as dag:

    iniciar_proceso = EmptyOperator(
        task_id='initiate_process',
    )

    finalizar_proceso = EmptyOperator(
        task_id='end_process',
    )

    # Define the PythonOperator for extracting data and uploading it
    extract_and_load_task = PythonOperator(
        task_id='extract_and_upload',
        python_callable=extract_and_upload_data,
        provide_context=True
    )

    # BashOperator to execute DBT inside the DBT container
    run_dbt = BashOperator(
        task_id='run_dbt_task',
        bash_command='docker exec dbt-container dbt run'
    )

    # Set task dependencies
    iniciar_proceso >> extract_and_load_task >> run_dbt >>  finalizar_proceso # python_task will run before dbt_task
    #iniciar_proceso >> extract_and_load_task >> finalizar_proceso
