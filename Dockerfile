# Step 1: Use the official Airflow image as the base
FROM apache/airflow:2.9.0-python3.9

# Step 2: Switch to root to install system dependencies
USER root

# Step 3: Install PostgreSQL client and build tools
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    gcc \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Switch to airflow user for all subsequent steps
USER airflow

# Step 5: Install DBT and other Python dependencies
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Step 6: Set Airflow environment variables (optional)
ENV AIRFLOW_HOME=/opt/airflow
