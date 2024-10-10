#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Navigate to the directory containing the .env file
cd "$(dirname "$0")"

# Define the log file to capture the output
LOG_FILE="docker_logs.txt"

# Get logs from the running Supabase containers
echo "Extracting logs from Supabase containers..."
docker-compose logs > $LOG_FILE

# Define a function to extract environment variable values from logs
extract_env_value() {
    local key=$1
    # Use grep to find the line containing the key, then cut to get the value
    value=$(grep -oP "$key=\K[^ ]+" $LOG_FILE | head -n 1)
    echo "$value"
}

# Read environment variables from logs and update the .env file
{
    echo "Updating .env file with extracted values..."
    echo "POSTGRES_PASSWORD=$(extract_env_value 'POSTGRES_PASSWORD')" >> .env
    echo "POSTGRES_DB=$(extract_env_value 'POSTGRES_DB')" >> .env
    echo "SUPABASE_PUBLIC_URL=$(extract_env_value 'SUPABASE_PUBLIC_URL')" >> .env
    echo "PGRST_JWT_SECRET=$(extract_env_value 'PGRST_JWT_SECRET')" >> .env
    echo "SUPABASE_ANON_KEY=$(extract_env_value 'SUPABASE_ANON_KEY')" >> .env
} > .env

# Cleanup
rm -f $LOG_FILE

echo ".env file updated successfully."
