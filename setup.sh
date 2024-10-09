#!/bin/bash

# Clone the GitHub repository
git clone https://github.com/Karan-Suthar1/Server.git
cd Server

# Load environment variables from .env file
if [ -f ".env" ]; then
  echo "Loading environment variables..."
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found! Exiting..."
  exit 1
fi

# Run Docker Compose to build and start the services
echo "Starting services with Docker Compose..."
docker-compose up --build -d

# Check if the services started successfully
if [ $? -eq 0 ]; then
  echo "Services started successfully!"
else
  echo "Failed to start services. Check the logs for errors."
  exit 1
fi
