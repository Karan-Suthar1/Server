#!/bin/bash

# Set the repository URL (replace with your repository)
REPO_URL="https://github.com/Karan-Suthar1/Server"
CLONE_DIR="Server"

# Clone the repository if it doesn't exist
if [ ! -d "$CLONE_DIR" ]; then
  echo "Cloning the repository..."
  git clone $REPO_URL
  if [ $? -ne 0 ]; then
    echo "Failed to clone repository."
    exit 1
  fi
else
  echo "Repository already exists. Pulling the latest changes..."
  cd $CLONE_DIR && git pull
fi

# Navigate to the cloned directory
cd $CLONE_DIR

# Start Supabase services
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
