#!/bin/bash

# 🌐 Domain & SSL Setup Automation Script
# Run this on your EC2 server after getting a domain name

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - UPDATE THESE WITH YOUR DOMAIN
DOMAIN="yourdomain.tk"  # Replace with your actual domain
EMAIL="your-email@example.com"  # Replace with your email

echo -e "${BLUE}🌐 Starting Domain & SSL Setup...${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ Don't run this script as root!${NC}"
   exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt update

# Install Nginx
if ! command_exists nginx; then
    echo -e "${YELLOW}🌐 Installing Nginx...${NC}"
    sudo apt install nginx -y
    sudo systemctl enable nginx
else
    echo -e "${GREEN}✅ Nginx already installed${NC}"
fi

# Install Certbot
if ! command_exists certbot; then
    echo -e "${YELLOW}🔒 Installing Certbot...${NC}"
    sudo apt install certbot python3-certbot-nginx -y
else
    echo -e "${GREEN}✅ Certbot already installed${NC}"
fi

# Backup existing Nginx config
echo -e "${YELLOW}💾 Backing up Nginx configuration...${NC}"
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup

# Create new Nginx configuration
echo -e "${YELLOW}⚙️ Creating Nginx configuration...${NC}"
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Port \$server_port;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
}
EOF

# Test Nginx configuration
echo -e "${YELLOW}🧪 Testing Nginx configuration...${NC}"
if sudo nginx -t; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration error!${NC}"
    exit 1
fi

# Restart Nginx
echo -e "${YELLOW}🔄 Restarting Nginx...${NC}"
sudo systemctl restart nginx

# Update Docker container to use port 3000
echo -e "${YELLOW}🐳 Updating Docker container port mapping...${NC}"
if docker ps -q -f name=ecommerce-app; then
    docker stop ecommerce-app
    docker rm ecommerce-app
fi

docker run -d -p 3000:80 --name ecommerce-app dilshan019/ecommerce-react-app:latest

# Wait for container to start
sleep 5

# Test if domain resolves to this server
echo -e "${YELLOW}🔍 Testing domain resolution...${NC}"
DOMAIN_IP=$(dig +short ${DOMAIN})
SERVER_IP=$(curl -s http://checkip.amazonaws.com/)

if [ "$DOMAIN_IP" = "$SERVER_IP" ]; then
    echo -e "${GREEN}✅ Domain points to this server correctly${NC}"
    
    # Get SSL certificate
    echo -e "${YELLOW}🔒 Obtaining SSL certificate...${NC}"
    sudo certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --non-interactive --agree-tos --email ${EMAIL}
    
    # Test SSL renewal
    echo -e "${YELLOW}🔄 Testing SSL renewal...${NC}"
    sudo certbot renew --dry-run
    
    echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
    echo -e "${GREEN}✅ Your site is now available at:${NC}"
    echo -e "${GREEN}   https://${DOMAIN}${NC}"
    echo -e "${GREEN}   https://www.${DOMAIN}${NC}"
    
else
    echo -e "${YELLOW}⚠️  Domain doesn't point to this server yet${NC}"
    echo -e "${YELLOW}   Domain IP: ${DOMAIN_IP}${NC}"
    echo -e "${YELLOW}   Server IP: ${SERVER_IP}${NC}"
    echo -e "${YELLOW}   Please update your DNS settings and run this script again${NC}"
    echo -e "${YELLOW}   You can still access via HTTP while waiting for DNS${NC}"
fi

# Setup automatic SSL renewal
echo -e "${YELLOW}⏰ Setting up automatic SSL renewal...${NC}"
sudo systemctl enable certbot.timer

echo -e "${BLUE}🎯 Setup Summary:${NC}"
echo -e "${GREEN}✅ Nginx installed and configured${NC}"
echo -e "${GREEN}✅ Reverse proxy setup for Docker container${NC}"
echo -e "${GREEN}✅ Security headers added${NC}"
echo -e "${GREEN}✅ Docker container updated to port 3000${NC}"
if [ "$DOMAIN_IP" = "$SERVER_IP" ]; then
    echo -e "${GREEN}✅ SSL certificate obtained and configured${NC}"
    echo -e "${GREEN}✅ Automatic SSL renewal enabled${NC}"
fi

echo -e "${BLUE}📋 Next Steps:${NC}"
echo -e "${YELLOW}1. Make sure your domain DNS points to: ${SERVER_IP}${NC}"
echo -e "${YELLOW}2. Wait for DNS propagation (up to 24 hours)${NC}"
echo -e "${YELLOW}3. If SSL wasn't installed, run: sudo certbot --nginx -d ${DOMAIN} -d www.${DOMAIN}${NC}"
echo -e "${YELLOW}4. Test your site at https://${DOMAIN}${NC}"