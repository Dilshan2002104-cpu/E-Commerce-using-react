# EC2 Deployment Troubleshooting Guide

## 🚨 Common Issues and Solutions

### Issue 1: Cannot connect to EC2
**Problem:** `ssh: connect to host x.x.x.x port 22: Connection refused`

**Solutions:**
- Check security group allows SSH (port 22) from your IP
- Verify you're using the correct key file and IP address
- Ensure EC2 instance is running

```bash
# Correct SSH command format:
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### Issue 2: Permission denied when using Docker
**Problem:** `permission denied while trying to connect to the Docker daemon`

**Solution:**
```bash
# Add user to docker group and apply changes
sudo usermod -aG docker ubuntu
newgrp docker

# Or logout and login again
exit
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

### Issue 3: Port 80 not accessible from browser
**Problem:** Container running but can't access from browser

**Solutions:**
1. **Check Security Group:**
   - AWS Console → EC2 → Security Groups
   - Add inbound rule: HTTP, Port 80, Source: 0.0.0.0/0

2. **Check if container is running:**
   ```bash
   docker ps
   ```

3. **Check application logs:**
   ```bash
   docker logs ecommerce-app
   ```

4. **Test locally on server:**
   ```bash
   curl http://localhost
   ```

### Issue 4: Container keeps restarting
**Problem:** Container starts but keeps crashing

**Solutions:**
```bash
# Check logs for errors
docker logs ecommerce-app

# Check if port is already in use
sudo netstat -tulpn | grep :80

# Remove and recreate container
docker stop ecommerce-app
docker rm ecommerce-app
docker run -d --name ecommerce-app --restart unless-stopped -p 80:80 dilshan019/ecommerce-react-app:latest
```

### Issue 5: Out of disk space
**Problem:** `no space left on device`

**Solutions:**
```bash
# Check disk usage
df -h

# Clean up Docker
docker system prune -a -f

# Remove unused images
docker image prune -a -f
```

### Issue 6: Cannot pull image from Docker Hub
**Problem:** `Error response from daemon: pull access denied`

**Solutions:**
```bash
# Make sure image name is correct
docker pull dilshan019/ecommerce-react-app:latest

# Check if image exists on Docker Hub
# Visit: https://hub.docker.com/r/dilshan019/ecommerce-react-app
```

## 🔧 Useful Commands

### Container Management
```bash
# Check running containers
docker ps

# Check all containers (including stopped)
docker ps -a

# View container logs
docker logs ecommerce-app

# Follow logs in real-time
docker logs -f ecommerce-app

# Access container shell
docker exec -it ecommerce-app sh

# Restart container
docker restart ecommerce-app

# Stop container
docker stop ecommerce-app

# Remove container
docker rm ecommerce-app
```

### System Information
```bash
# Check system resources
free -h
df -h
top

# Check network
sudo netstat -tulpn | grep :80

# Get public IP
curl http://checkip.amazonaws.com

# Check Docker status
sudo systemctl status docker
```

### Update Deployment
```bash
# Pull latest image
docker pull dilshan019/ecommerce-react-app:latest

# Stop and remove current container
docker stop ecommerce-app
docker rm ecommerce-app

# Run new container
docker run -d --name ecommerce-app --restart unless-stopped -p 80:80 dilshan019/ecommerce-react-app:latest
```

## 🎯 Quick Health Check

Run these commands to verify everything is working:

```bash
# 1. Check if Docker is running
docker --version

# 2. Check if container is running
docker ps | grep ecommerce-app

# 3. Check application logs
docker logs --tail=20 ecommerce-app

# 4. Test application locally
curl -I http://localhost

# 5. Get public IP
curl http://checkip.amazonaws.com
```

## 📞 Still Having Issues?

If you're still having problems:

1. Run the health check commands above
2. Check the specific error messages
3. Verify your AWS security group settings
4. Ensure your EC2 instance has enough resources (CPU, memory, disk)
5. Check if your Docker image is public on Docker Hub