#!/bin/bash

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Stop the container
echo -e "${YELLOW}Stopping n8n container...${NC}"
docker-compose down

# Verify it's stopped
if ! docker ps | grep -q "tfg-n8n"; then
    echo -e "${GREEN}✅ n8n container stopped.${NC}"
else
    echo -e "${RED}❌ Failed to stop n8n container.${NC}"
fi
