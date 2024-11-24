import os
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

from ucimlrepo import fetch_ucirepo
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime

# Python function for PythonOperator
def print_hello_world():
    print("Hello, world! Running the PythonOperator task!")

# Function to extract data from CSV and upload to PostgreSQL
def extract_and_upload_data(**kwargs):
    # Fetch dataset from UCI repository
    online_retail = fetch_ucirepo(id=352)
    X = online_retail.data.features
    y = online_retail.data.targets

    # Combine features and targets to create a complete dataset
    data = pd.DataFrame(X, columns=online_retail.data.feature_names)
    data['target'] = y  # Add target column to data
    
    # Access environment variables directly
    postgres_user = os.getenv("POSTGRES_STAGING_USER")
    postgres_password = os.getenv("POSTGRES_STAGING_PASSWORD")
    postgres_host = os.getenv("POSTGRES_STAGING_HOST")
    postgres_port = os.getenv("POSTGRES_STAGING_PORT")
    postgres_db = os.getenv("POSTGRES_STAGING_DB")
    
    # Create SQLAlchemy engine with direct connection details
    engine = create_engine(f'postgresql://{postgres_user}:{postgres_password}@{postgres_host}:{postgres_port}/{postgres_db}')
    
    # Upload the DataFrame to PostgreSQL - Replace 'your_table_name' with your actual table name
    data.to_sql('online_retail_data', con=engine, if_exists='replace', index=False)
    print(f"Uploaded {len(data)} records to the PostgreSQL staging database.")


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
    extract_and_upload_task = PythonOperator(
        task_id='extract_and_upload',
        python_callable=extract_and_upload_data,
        provide_context=True
    )

    """
    # DockerOperator to run dbt commands inside DBT container
    dbt_run = DockerOperator(
        task_id='dbt_run',
        image='dbt_image:latest',  # DBT container image, replace with the actual image name
        api_version='auto',
        auto_remove=True,
        command='dbt run',  # Replace with the dbt command you want to run, e.g., dbt run, dbt test, etc.
        network_mode='bridge',  # Adjust based on how containers are networked
        dag=dag
    )"""

    # Set task dependencies
    #iniciar_proceso >> python_task >> dbt_run >>  finalizar_proceso # python_task will run before dbt_task
    iniciar_proceso >> extract_and_upload_task >> finalizar_proceso