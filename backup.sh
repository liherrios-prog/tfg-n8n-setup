#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create backup directory with timestamp
BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup workflows
echo -e "${BLUE}Backing up workflows...${NC}"
cp -r workflows/* "$BACKUP_DIR/" 2>/dev/null || echo "No workflows to backup"

# Backup database
echo -e "${BLUE}Backing up database...${NC}"
docker cp tfg-n8n:/home/node/.n8n/n8n.sqlite "$BACKUP_DIR/n8n_$(date +%Y%m%d_%H%M%S).sqlite"

# Create backup info
echo "Backup created on $(date)" > "$BACKUP_DIR/backup_info.txt"
echo "n8n version: $(docker exec tfg-n8n n8n --version 2>/dev/null || echo 'Unknown')" >> "$BACKUP_DIR/backup_info.txt"

echo -e "${GREEN}✅ Backup completed!${NC}"
echo -e "${GREEN}Backup saved to: $BACKUP_DIR${NC}"
