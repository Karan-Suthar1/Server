#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Navigate to the directory containing the docker-compose.yml file
cd "$(dirname "$0")"

# Function to create or update the .env file
update_env_file() {
    echo "Updating .env file with default values if not already set..."

    # Check if .env exists; if not, create it
    if [ ! -f .env ]; then
        touch .env
    fi

    # Check each variable and update if not already set
    {
        # Only add defaults if not already in the .env file
        if ! grep -q "POSTGRES_PASSWORD" .env; then
            echo "POSTGRES_PASSWORD=your_postgres_password" >> .env
        fi
        if ! grep -q "POSTGRES_DB" .env; then
            echo "POSTGRES_DB=your_postgres_db" >> .env
        fi
        if ! grep -q "SUPABASE_PUBLIC_URL" .env; then
            echo "SUPABASE_PUBLIC_URL=http://localhost:5432" >> .env
        fi
        if ! grep -q "GOTRUE_JWT_SECRET" .env; then
            echo "GOTRUE_JWT_SECRET=your_jwt_secret" >> .env
        fi
        if ! grep -q "PGRST_JWT_SECRET" .env; then
            echo "PGRST_JWT_SECRET=your_jwt_secret" >> .env
        fi
        echo "# Add other environment variables here" >> .env
    } >> .env
}

# Pull the latest images to ensure they are up to date
echo "Pulling latest Docker images..."
docker-compose pull

# Build and start the Docker containers
echo "Starting Langflow and Supabase services..."
docker-compose up -d --build

# Wait for the services to initialize (optional)
echo "Waiting for services to initialize..."
sleep 15

# Check the status of the containers
echo "Checking the status of containers..."
docker-compose ps

# Run the extract_env.sh script to update .env with environment variable values from Supabase logs
echo "Extracting environment variables from Supabase logs..."
./extract_env.sh

# Update .env with default values directly from Supabase logs
update_env_file

echo "Langflow and Supabase services started successfully."
