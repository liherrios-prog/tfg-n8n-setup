#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is installed
echo -e "${BLUE}Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
    echo "Download from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose is not installed.${NC}"
    echo "Please install Docker Compose first."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed.${NC}"
    echo "Please install Git first."
    exit 1
fi

# Create necessary directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p workflows data backup

# Copy .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file...${NC}"
    cp .env.example .env
    echo -e "${GREEN}.env file created. Please edit it with your configuration.${NC}"
    echo "Set N8N_PASSWORD to a secure password"
fi

# Check if container is already running
if docker ps | grep -q "tfg-n8n"; then
    echo -e "${YELLOW}Container is already running.${NC}"
    echo -e "${GREEN}Access n8n at: http://localhost:5678${NC}"
    exit 0
fi

# Pull the latest image
echo -e "${BLUE}Pulling latest n8n image...${NC}"
docker-compose pull

# Start the container
echo -e "${BLUE}Starting n8n container...${NC}"
docker-compose up -d

# Wait for container to be healthy
echo -e "${BLUE}Waiting for n8n to be ready...${NC}"
sleep 10

# Check if container is running
if docker ps | grep -q "tfg-n8n"; then
    echo -e "${GREEN}✅ n8n is running!${NC}"
    echo -e "${GREEN}Access n8n at: http://localhost:5678${NC}"
    echo -e "${GREEN}Default username: admin${NC}"
    echo -e "${GREEN}Password: $(grep N8N_PASSWORD .env | cut -d'=' -f2)${NC}"
    echo -e "${YELLOW}Important: Change the default password in the n8n web interface.${NC}"
else
    echo -e "${RED}❌ Failed to start n8n container.${NC}"
    echo "Check the logs with: docker-compose logs -f"
    exit 1
fi

# Show health status
echo -e "${BLUE}Health check:${NC}"
docker-compose ps
