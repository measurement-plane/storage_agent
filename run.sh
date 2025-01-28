#!/bin/bash

# ========== CONFIGURABLE PARAMETERS ==========
# Container and image configuration
CONTAINER_NAME="storage_agent_container"
IMAGE_NAME="amlabdr/storage_agent:latest"

# Environment variables for the application
BROKER_URL="amqp://localhost:5672/"
ENDPOINT="TT_storage_agent"
REMOTE_STORAGE_USER= "admin"
REMOTE_STORAGE_PASSWORD="admin"
REMOTE_STORAGE_DIR="~"
# Stop and remove any running container with the same name
echo "Stopping and removing existing container (if any)..."
docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true

# Attempt to pull the latest image
echo "Attempting to pull the latest image..."
if docker pull "$IMAGE_NAME"; then
    echo "Successfully pulled the latest image."
else
    echo "Warning: Failed to pull the image. Using the existing local image, if available."
fi

# Prepare the run command
echo "Starting the container..."
DOCKER_CMD="docker run --name \"$CONTAINER_NAME\""

# Add environment variables
DOCKER_CMD+=" -e BROKER_URL=\"$BROKER_URL\""
DOCKER_CMD+=" -e ENDPOINT=\"$ENDPOINT\""
DOCKER_CMD+=" -e REMOTE_STORAGE_USER=\"$REMOTE_STORAGE_USER\""
DOCKER_CMD+=" -e REMOTE_STORAGE_PASSWORD=\"$REMOTE_STORAGE_PASSWORD\""
DOCKER_CMD+=" -e REMOTE_STORAGE_DIR=\"$REMOTE_STORAGE_DIR\""

# Add the image name
DOCKER_CMD+=" \"$IMAGE_NAME\""

# Execute the run command
if ! eval $DOCKER_CMD; then
    echo "Error: Failed to start the container."
    exit 1
fi
