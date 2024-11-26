# Execution demonstration

## Docker destktop

Once the ```make up ``` command is executed all the 5 containers must look like this.

<img src="example-docker-up.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## Airflow running

When you access through th airflow webserver the DAG execution must look like this.

<img src="example-airflow-running.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## DBT Run command

when the dbt run command is executed all 5 5 tables of the olap model must be processed succesfully

<img src="example_dbt_run.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## Ingestion in staging layer

Raw data must look like this in a DB client like DBeaver

<img src="example-ingesta-data-stagin-layer.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## Ingestion in olap layer

OLAP data must look like this in a DB client like DBeaver

<img src="exmaple-ingested-data-olap-layer.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## Airflow logs in local

Logs for airflow can be checked through local folder

<img src="ariflow-logs.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">

## DBT logs in local

Logs for DBT can be checked through local folder

<img src="dbt-logs.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 70%;">
