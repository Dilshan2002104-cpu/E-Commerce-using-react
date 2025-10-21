# 🌐 Free Domain & SSL Setup Guide

## 🎯 Complete Professional Setup (100% Free)

### Step 1: Get Free Domain Name

#### Option A: Freenom (Completely Free)
1. **Go to:** https://www.freenom.com
2. **Search for domain:** Enter your desired name (e.g., "myecommerce")
3. **Choose extension:** `.tk`, `.ml`, `.ga`, or `.cf` (all free)
4. **Register:** Create account and get domain for 12 months free
5. **Renew:** Can renew for free before expiration

#### Option B: Free Subdomain (Instant)
1. **Cloudflare Pages:** `yourecommerce.pages.dev`
2. **Netlify:** `yourecommerce.netlify.app`
3. **GitHub Pages:** `username.github.io`

### Step 2: Point Domain to Your EC2 Server

#### Configure DNS (A Record)
```bash
# Your current setup:
Domain: yourdomain.tk
EC2 IP: 13.51.197.95

# DNS Configuration:
Type: A
Name: @ (root domain)
Value: 13.51.197.95
TTL: 300

# For www subdomain:
Type: CNAME
Name: www
Value: yourdomain.tk
TTL: 300
```

### Step 3: Install Free SSL Certificate (Let's Encrypt)

#### Method 1: Using Certbot (Recommended)
```bash
# On your EC2 server:
sudo apt update
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate:
sudo certbot --nginx -d yourdomain.tk -d www.yourdomain.tk

# Automatic renewal:
sudo systemctl enable certbot.timer
```

#### Method 2: Using Cloudflare (Easiest)
```bash
# Steps:
1. Sign up for free Cloudflare account
2. Add your domain to Cloudflare
3. Change nameservers at domain registrar
4. Enable "Always Use HTTPS" in Cloudflare
5. Get free SSL automatically!
```

### Step 4: Update Nginx Configuration

```nginx
# /etc/nginx/sites-available/default
server {
    listen 80;
    server_name yourdomain.tk www.yourdomain.tk;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.tk www.yourdomain.tk;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.tk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.tk/privkey.pem;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    location / {
        proxy_pass http://localhost:3000;  # Your Docker container
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Step 5: Update Docker Configuration

```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  web:
    image: dilshan019/ecommerce-react-app:latest
    ports:
      - "3000:80"  # Changed from 80:80 to avoid conflict with Nginx
    restart: unless-stopped
    environment:
      - NODE_ENV=production
```

### Step 6: Automate SSL Renewal

```bash
# Create renewal script
sudo nano /etc/cron.d/certbot-renew

# Add this content:
0 12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew --nginx
```

## 🚀 Quick Setup Commands

### For Ubuntu EC2 Server:
```bash
# 1. Install Nginx
sudo apt update
sudo apt install nginx -y

# 2. Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# 3. Configure Nginx (replace yourdomain.tk with your domain)
sudo nano /etc/nginx/sites-available/default

# 4. Test Nginx configuration
sudo nginx -t

# 5. Restart Nginx
sudo systemctl restart nginx

# 6. Get SSL certificate (replace with your domain)
sudo certbot --nginx -d yourdomain.tk -d www.yourdomain.tk

# 7. Update Docker container to use port 3000
docker stop ecommerce-app
docker rm ecommerce-app
docker run -d -p 3000:80 --name ecommerce-app dilshan019/ecommerce-react-app:latest
```

## 🔧 Complete Nginx Configuration

```nginx
server {
    listen 80;
    server_name yourdomain.tk www.yourdomain.tk;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.tk www.yourdomain.tk;
    
    # SSL Configuration (Certbot will add these)
    ssl_certificate /etc/letsencrypt/live/yourdomain.tk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.tk/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Proxy to Docker container
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
    }
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 10240;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/x-javascript
        application/xml+rss
        application/javascript
        application/json;
}
```

## 📋 Step-by-Step Checklist

### Domain Setup:
- [ ] Register free domain at Freenom
- [ ] Configure A record to point to 13.51.197.95
- [ ] Configure CNAME for www subdomain
- [ ] Wait for DNS propagation (up to 24 hours)

### SSL Setup:
- [ ] Install Nginx on EC2
- [ ] Install Certbot
- [ ] Configure Nginx reverse proxy
- [ ] Run Certbot to get SSL certificate
- [ ] Test HTTPS access
- [ ] Setup automatic renewal

### Docker Update:
- [ ] Change Docker port mapping to 3000:80
- [ ] Update deployment script
- [ ] Test application access through Nginx

## 🎉 Final Result

After setup, your site will be accessible at:
- ✅ `https://yourdomain.tk` (SSL secured)
- ✅ `https://www.yourdomain.tk` (SSL secured)
- ✅ `http://yourdomain.tk` (redirects to HTTPS)

## 🔒 Security Features Added

- ✅ Free SSL Certificate (Let's Encrypt)
- ✅ HTTPS Redirect
- ✅ Security Headers
- ✅ Automatic SSL Renewal
- ✅ Gzip Compression
- ✅ Reverse Proxy Setup

## 💰 Total Cost: $0.00

Everything in this guide is completely free!

## 🆘 Troubleshooting

### Common Issues:
1. **DNS not propagating:** Wait 24 hours or use different DNS servers
2. **Certbot fails:** Make sure domain points to your server first
3. **Nginx errors:** Check configuration with `sudo nginx -t`
4. **Port conflicts:** Make sure only Nginx uses port 80/443

### Test Commands:
```bash
# Test domain resolution
nslookup yourdomain.tk

# Test SSL certificate
openssl s_client -connect yourdomain.tk:443

# Check Nginx status
sudo systemctl status nginx

# View SSL certificate details
sudo certbot certificates
```