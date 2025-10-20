#!/bin/bash

# EC2 Deployment Script for E-Commerce React App
# Upload this script to your EC2 and run it

set -e

echo "🚀 Deploying E-Commerce React App on EC2..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOCKER_IMAGE="dilshan019/ecommerce-react-app:latest"
CONTAINER_NAME="ecommerce-app"
PORT="80"

echo -e "${BLUE}📦 Updating system packages...${NC}"
sudo apt update

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}🐳 Installing Docker...${NC}"
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
    echo -e "${GREEN}✅ Docker installed successfully!${NC}"
    echo -e "${YELLOW}⚠️  Please logout and login again, then re-run this script${NC}"
    exit 0
else
    echo -e "${GREEN}✅ Docker is already installed${NC}"
fi

# Check if user is in docker group
if ! groups $USER | grep &>/dev/null '\bdocker\b'; then
    echo -e "${YELLOW}⚠️  Adding user to docker group...${NC}"
    sudo usermod -aG docker ubuntu
    echo -e "${YELLOW}⚠️  Please logout and login again, then re-run this script${NC}"
    exit 0
fi

echo -e "${BLUE}📥 Pulling latest image from Docker Hub...${NC}"
docker pull $DOCKER_IMAGE

echo -e "${BLUE}🛑 Stopping existing container (if any)...${NC}"
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo -e "${BLUE}🚀 Starting new container...${NC}"
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p $PORT:80 \
  $DOCKER_IMAGE

# Wait a moment for container to start
echo -e "${YELLOW}⏳ Waiting for container to start...${NC}"
sleep 5

# Check if container is running
if docker ps | grep -q $CONTAINER_NAME; then
    echo -e "${GREEN}✅ Container is running successfully!${NC}"
    
    # Get public IP
    PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
    
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${BLUE}🌐 Your application is accessible at:${NC}"
    echo -e "${GREEN}   http://$PUBLIC_IP${NC}"
    echo ""
    echo -e "${BLUE}📋 Container Information:${NC}"
    docker ps | grep $CONTAINER_NAME
    echo ""
    echo -e "${BLUE}📋 Useful commands:${NC}"
    echo -e "   View logs:     ${YELLOW}docker logs $CONTAINER_NAME${NC}"
    echo -e "   Follow logs:   ${YELLOW}docker logs -f $CONTAINER_NAME${NC}"
    echo -e "   Restart app:   ${YELLOW}docker restart $CONTAINER_NAME${NC}"
    echo -e "   Stop app:      ${YELLOW}docker stop $CONTAINER_NAME${NC}"
    echo -e "   Update app:    ${YELLOW}./deploy-ec2.sh${NC} (run this script again)"
    
    # Test the application
    echo -e "${BLUE}🧪 Testing application...${NC}"
    if curl -s http://localhost > /dev/null; then
        echo -e "${GREEN}✅ Application is responding!${NC}"
    else
        echo -e "${RED}❌ Application might not be responding${NC}"
        echo -e "${YELLOW}📋 Check logs: docker logs $CONTAINER_NAME${NC}"
    fi
else
    echo -e "${RED}❌ Container failed to start${NC}"
    echo -e "${YELLOW}📋 Check logs: docker logs $CONTAINER_NAME${NC}"
    docker logs $CONTAINER_NAME
    exit 1
fi