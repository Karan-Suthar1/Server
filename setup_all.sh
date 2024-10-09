#!/bin/bash

# Start Supabase
echo "Starting Supabase services..."
./start_supabase.sh
if [ $? -ne 0 ]; then
  echo "Failed to start Supabase services."
  exit 1
fi
echo "Supabase started successfully."

# Extract values from Supabase
echo "Extracting keys and secrets from Supabase..."
./extract_supabase_values.sh
if [ $? -ne 0 ]; then
  echo "Failed to extract values from Supabase."
  exit 1
fi
echo "Keys and secrets extracted successfully."

# Start Langflow with Supabase integration
echo "Starting Langflow with Supabase integration..."
./run_langflow.sh
if [ $? -ne 0 ]; then
  echo "Failed to start Langflow with Supabase integration."
  exit 1
fi

echo "All services started successfully!"
