#!/bin/bash

# Ensure all necessary environment variables are set
if [[ -z "$POSTGRES_ANALYTICS_USER" || -z "$POSTGRES_ANALYTICS_PASSWORD" || -z "$POSTGRES_ANALYTICS_DB" ]]; then
  echo "Required environment variables are not set."
  exit 1
fi

# Replace placeholders in init.sql.template with actual environment variable values
envsubst < /docker-entrypoint-initdb.d/init.sql.template > /docker-entrypoint-initdb.d/init.sql

if [[ $? -ne 0 ]]; then
  echo "Error occurred during SQL file processing."
  exit 1
fi

echo "SQL file has been processed and is ready for use."

# Execute the SQL file using psql
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/init.sql

if [[ $? -ne 0 ]]; then
  echo "Error occurred while executing the SQL file."
  exit 1
fi

echo "SQL execution completed successfully."
