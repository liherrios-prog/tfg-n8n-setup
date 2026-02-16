#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if backup directory is provided
if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./restore.sh <backup_directory>${NC}"
    echo -e "${YELLOW}Available backups:${NC}"
    ls -d backup/*/ 2>/dev/null | sed 's|backup/||g' | sed 's|/||g'
    exit 1
fi

BACKUP_DIR="backup/$1"

# Check if backup exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

# Stop the container
echo -e "${YELLOW}Stopping n8n container...${NC}"
docker-compose down

# Restore workflows
echo -e "${BLUE}Restoring workflows...${NC}"
cp -r "$BACKUP_DIR/"* workflows/ 2>/dev/null || echo "No workflows to restore"

# Restore database
echo -e "${BLUE}Restoring database...${NC}"
docker cp "$BACKUP_DIR/"*.sqlite tfg-n8n:/home/node/.n8n/n8n.sqlite 2>/dev/null || echo "No database backup found"

# Start the container
echo -e "${BLUE}Starting n8n container...${NC}"
docker-compose up -d

# Verify it's running
if docker ps | grep -q "tfg-n8n"; then
    echo -e "${GREEN}✅ Restore completed!${NC}"
    echo -e "${GREEN}n8n is running at: http://localhost:5678${NC}"
else
    echo -e "${RED}❌ Failed to start n8n container after restore.${NC}"
fi
