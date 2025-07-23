#!/bin/bash

# Check if port argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Port number is required as argument${NC}"
    echo "Usage: $0 <port_number>"
    exit 1
fi

# Get the port from command line argument
PORT=$1

# Generate a random UUID for the container and image names
UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')
IMAGE_NAME="react-app-$UUID"
CONTAINER_NAME="react-container-$UUID"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Docker build and run process...${NC}"
echo -e "${YELLOW}Image name: $IMAGE_NAME${NC}"
echo -e "${YELLOW}Container name: $CONTAINER_NAME${NC}"
echo -e "${YELLOW}Using port: $PORT${NC}"

# Build the Docker image
echo -e "\n${BLUE}📦 Building Docker image...${NC}"
if docker build -t "$IMAGE_NAME" .; then
    echo -e "${GREEN}✅ Docker image built successfully!${NC}"
else
    echo -e "${RED}❌ Docker build failed!${NC}"
    exit 1
fi

# Run the Docker container
echo -e "\n${BLUE}🏃 Running Docker container...${NC}"
if docker run -d --name "$CONTAINER_NAME" -p "$PORT:3000" "$IMAGE_NAME"; then
    echo -e "${GREEN}✅ Docker container started successfully!${NC}"
    echo -e "${GREEN}🌐 Application is running at: http://localhost:$PORT${NC}"
    echo -e "${YELLOW}📋 Container name: $CONTAINER_NAME${NC}"
    echo -e "${YELLOW}🏷️  Image name: $IMAGE_NAME${NC}"
    
    # Show container status
    echo -e "\n${BLUE}📊 Container status:${NC}"
    docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo -e "\n${BLUE}💡 Useful commands:${NC}"
    echo -e "  Stop container: ${YELLOW}docker stop $CONTAINER_NAME${NC}"
    echo -e "  Remove container: ${YELLOW}docker rm $CONTAINER_NAME${NC}"
    echo -e "  Remove image: ${YELLOW}docker rmi $IMAGE_NAME${NC}"
    echo -e "  View logs: ${YELLOW}docker logs $CONTAINER_NAME${NC}"
    echo -e "  Follow logs: ${YELLOW}docker logs -f $CONTAINER_NAME${NC}"
    
else
    echo -e "${RED}❌ Failed to start Docker container!${NC}"
    exit 1
fi