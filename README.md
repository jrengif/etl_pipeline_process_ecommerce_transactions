# E-Commerce Transaction Processing Project

## Architecture Overview


<img src="project_documentation\architechture_documentation\solution_architechture.png" alt="OLAP Star Model" style="display: block; margin-left: auto; margin-right: auto; width: 80%;">



## Relevant commands

Docker commands

```bash
docker ps #
docker ps -a # Check container status
docker-compose up --build
docker-compose up --build -d # Compose in Detached Mode
docker-compose down -v #
docker exec -it airflow airflow dags list # list dags in airflow
docker exec -it airflow_webserver airflow dags list-import-errors # list dags errors
```