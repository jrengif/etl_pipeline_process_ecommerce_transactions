#!/bin/bash

# Ensure all necessary environment variables are set
if [[ -z "$POSTGRES_STAGING_USER" || -z "$POSTGRES_STAGING_PASSWORD" || -z "$POSTGRES_STAGING_DB" ]]; then
  echo "Required environment variables are not set."
  exit 1
fi

# Replace placeholders in init.sql with actual environment variable values
envsubst < /docker-entrypoint-initdb.d/init.sql.template > /docker-entrypoint-initdb.d/init.sql

echo "SQL file has been processed and is ready for use."
