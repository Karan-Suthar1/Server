#!/bin/bash

# Function to check if a container is running
function check_container {
  container_name=$1
  if ! docker ps --format '{{.Names}}' | grep -q "$container_name"; then
    echo "Error: $container_name container is not running."
    exit 1
  fi
}

# Check if Supabase DB is running
check_container "supabase-db"

# Check if Kong is running (where Supabase exposes its API)
check_container "supabase-kong"

# Create or update the .env file
if [ ! -f .env ]; then
  echo "Creating .env file..."
  touch .env
else
  echo ".env file already exists, updating keys..."
fi

# Extract necessary keys and credentials from the running Supabase services
# These commands assume Supabase stores some credentials in the DB or exposes them via environment variables

# Fetch Postgres Password from the db container
POSTGRES_PASSWORD=$(docker exec supabase-db printenv POSTGRES_PASSWORD)

# Fetch Supabase Anon Key, Service Role Key, JWT Secret from Kong
ANON_KEY=$(docker exec supabase-kong printenv SUPABASE_ANON_KEY)
SERVICE_ROLE_KEY=$(docker exec supabase-kong printenv SUPABASE_SERVICE_KEY)
JWT_SECRET=$(docker exec supabase-kong printenv JWT_SECRET)

# Write the values to the .env file
echo "Writing keys to .env file..."

cat <<EOT > .env
SUPABASE_URL=http://localhost:8000
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ANON_KEY=$ANON_KEY
SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
JWT_SECRET=$JWT_SECRET
EOT

echo "Supabase keys and credentials successfully written to .env"
