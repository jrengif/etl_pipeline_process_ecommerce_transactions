# Start from the official Airflow image with Python 3.9
FROM apache/airflow:2.9.0-python3.9

# Switch to root to perform administrative tasks
USER root

# Install PostgreSQL client and other dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    gcc \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# OPTIONAL: If you really need the airflow user to be in the docker group (not usually needed):
# Create a docker group and add the airflow user to it (optional, depending on your use case)
# RUN groupadd -g 999 docker && usermod -aG docker airflow

# Switch back to the airflow user to continue with the image setup
USER airflow

# Install Python dependencies from requirements.txt
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Set the AIRFLOW_HOME environment variable (optional)
ENV AIRFLOW_HOME=/opt/airflow

# Command to start the Airflow webserver or scheduler (depending on the service)


