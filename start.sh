#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}.env file not found. Creating from example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}.env file created. Please edit it with your configuration.${NC}"
    exit 1
fi

# Start the container
echo -e "${BLUE}Starting n8n container...${NC}"
docker-compose up -d

# Check status
if docker ps | grep -q "tfg-n8n"; then
    echo -e "${GREEN}✅ n8n is running!${NC}"
    echo -e "${GREEN}Access n8n at: http://localhost:5678${NC}"
else
    echo -e "${RED}❌ Failed to start n8n container.${NC}"
    echo "Check the logs with: docker-compose logs -f"
fi
