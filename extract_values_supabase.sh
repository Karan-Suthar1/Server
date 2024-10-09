#!/bin/bash

# Check if Supabase services are running
if [ "$(docker inspect -f '{{.State.Running}}' supabase-studio)" != "true" ]; then
  echo "Supabase services are not running! Please start Supabase first."
  exit 1
fi

# Extract keys from Supabase services (replace with your method)
echo "Extracting keys and secrets from Supabase..."

# Fetch anon key and service role key from Supabase (adjust paths as necessary)
ANON_KEY=$(docker exec supabase-kong cat /path/to/anon_key_file)
SERVICE_ROLE_KEY=$(docker exec supabase-kong cat /path/to/service_role_key_file)
JWT_SECRET=$(docker exec supabase-kong cat /path/to/jwt_secret_file)

# Write these values into the .env file for Langflow
cat <<EOL >> .env
ANON_KEY=$ANON_KEY
SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
JWT_SECRET=$JWT_SECRET
EOL

echo "Keys and secrets have been saved to .env for Langflow."
