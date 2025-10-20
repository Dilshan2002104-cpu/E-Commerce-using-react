#!/bin/bash

# CI/CD Deployment Script for EC2
# This script is executed by GitHub Actions on the EC2 server

set -e

# Configuration
DOCKER_IMAGE="dilshan019/ecommerce-react-app:latest"
CONTAINER_NAME="ecommerce-app"
PORT="80"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting CI/CD deployment...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if not present
if ! command_exists docker; then
    echo -e "${YELLOW}🐳 Installing Docker...${NC}"
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${GREEN}✅ Docker is already installed${NC}"
fi

# Ensure user is in docker group
if ! groups ubuntu | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}⚙️ Adding user to docker group...${NC}"
    sudo usermod -aG docker ubuntu
    # Note: Group changes require logout/login, but we'll use sudo for this session
fi

# Pull the latest image
echo -e "${BLUE}📥 Pulling latest Docker image...${NC}"
sudo docker pull $DOCKER_IMAGE

# Check if container exists and stop it
if sudo docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}🛑 Stopping existing container...${NC}"
    sudo docker stop $CONTAINER_NAME || true
    sudo docker rm $CONTAINER_NAME || true
else
    echo -e "${BLUE}ℹ️ No existing container found${NC}"
fi

# Start new container
echo -e "${BLUE}🚀 Starting new container...${NC}"
sudo docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p $PORT:80 \
    $DOCKER_IMAGE

# Wait for container to start
echo -e "${YELLOW}⏳ Waiting for container to start...${NC}"
sleep 5

# Verify container is running
if sudo docker ps --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${GREEN}✅ Container started successfully!${NC}"
    
    # Show container status
    echo -e "${BLUE}📊 Container status:${NC}"
    sudo docker ps --filter name=$CONTAINER_NAME --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}"
    
    # Test application
    echo -e "${BLUE}🧪 Testing application...${NC}"
    if curl -f -s http://localhost > /dev/null; then
        echo -e "${GREEN}✅ Application is responding!${NC}"
    else
        echo -e "${RED}❌ Application test failed${NC}"
        echo -e "${YELLOW}📋 Container logs:${NC}"
        sudo docker logs --tail=20 $CONTAINER_NAME
        exit 1
    fi
    
    # Clean up old images to save space
    echo -e "${BLUE}🧹 Cleaning up old images...${NC}"
    sudo docker image prune -f
    
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${BLUE}🌐 Application should be accessible at the server's public IP${NC}"
    
else
    echo -e "${RED}❌ Container failed to start${NC}"
    echo -e "${YELLOW}📋 Container logs:${NC}"
    sudo docker logs $CONTAINER_NAME || true
    exit 1
fi