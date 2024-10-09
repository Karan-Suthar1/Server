#!/bin/bash

# Start only Supabase-related services from Docker Compose
docker-compose up -d db kong studio

# Wait for Supabase to be ready (check if the database is accepting connections)
echo "Waiting for Supabase to be ready..."
until docker exec supabase-db pg_isready -U postgres; do
  sleep 2
  echo "Waiting for Supabase database..."
done

echo "Supabase services are up and running!"
