# 🚀 CI/CD Pipeline Setup Guide

This guide will help you set up a complete CI/CD pipeline for your React e-commerce application using GitHub Actions, Docker Hub, and AWS EC2.

## 🎯 Pipeline Overview

Our CI/CD pipeline automatically:
1. **Tests & Lints** your code on every push/PR
2. **Builds & Pushes** Docker image to Docker Hub (main branch only)
3. **Deploys** to your AWS EC2 server (main branch only)

## 📋 Prerequisites

- ✅ GitHub repository: https://github.com/Dilshan2002104-cpu/E-Commerce-using-react.git
- ✅ Docker Hub account: dilshan019
- ✅ AWS EC2 server: 13.51.197.95
- ✅ SSH access to EC2 server

## 🔧 Setup Instructions

### Step 1: Configure GitHub Repository Secrets

You need to add the following secrets to your GitHub repository:

1. **Go to your GitHub repository**
2. **Click Settings** → **Secrets and variables** → **Actions**
3. **Click "New repository secret"** and add these secrets:

#### Required Secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `DOCKER_USERNAME` | Your Docker Hub username | `dilshan019` |
| `DOCKER_PASSWORD` | Your Docker Hub password/token | `your-docker-hub-password` |
| `EC2_HOST` | Your EC2 public IP address | `13.51.197.95` |
| `EC2_PRIVATE_KEY` | Your EC2 private key (.pem file content) | `-----BEGIN RSA PRIVATE KEY-----\n...` |

### Step 2: Create Docker Hub Access Token (Recommended)

Instead of using your Docker Hub password, create an access token:

1. **Go to Docker Hub** → **Account Settings** → **Security**
2. **Click "New Access Token"**
3. **Name it** "GitHub Actions"
4. **Copy the token** and use it as `DOCKER_PASSWORD` secret

### Step 3: Prepare EC2 Private Key

1. **Open your .pem file** in a text editor
2. **Copy the entire content** (including `-----BEGIN` and `-----END` lines)
3. **Paste it as the value** for `EC2_PRIVATE_KEY` secret

⚠️ **Important:** Make sure to copy the exact content with proper line breaks.

### Step 4: Verify EC2 Security Group

Ensure your EC2 security group allows:
- **SSH (port 22)** from GitHub Actions runners
- **HTTP (port 80)** from anywhere

## 🚀 How the Pipeline Works

### Trigger Events:
- **Push to main branch** → Full pipeline (test, build, deploy)
- **Push to develop branch** → Test and build only
- **Pull request to main** → Test only

### Pipeline Stages:

#### 1. 🧪 Test & Lint
- Installs dependencies
- Runs ESLint
- Tests build process

#### 2. 🐳 Build & Push (main branch only)
- Builds Docker image
- Pushes to Docker Hub with tags:
  - `latest`
  - `<commit-sha>`

#### 3. 🚀 Deploy (main branch only)
- Connects to EC2 via SSH
- Pulls latest image
- Stops old container
- Starts new container
- Verifies deployment

## 📂 Files Created

```
.github/
└── workflows/
    └── ci-cd.yml          # Main CI/CD pipeline

scripts/
└── deploy.sh              # Deployment script for EC2
```

## 🧪 Testing the Pipeline

### Test 1: Push to develop branch
```bash
git checkout -b develop
git push origin develop
```
**Expected:** Only test and build jobs run

### Test 2: Create pull request
```bash
git checkout -b feature/test-cicd
echo "# Test change" >> README.md
git add README.md
git commit -m "Test CI/CD pipeline"
git push origin feature/test-cicd
```
**Expected:** Only test job runs

### Test 3: Push to main branch
```bash
git checkout main
git merge feature/test-cicd
git push origin main
```
**Expected:** All jobs run (test, build, deploy)

## 📊 Monitoring the Pipeline

### View Pipeline Status:
1. **Go to your GitHub repository**
2. **Click "Actions" tab**
3. **Click on a workflow run** to see details

### Check Deployment:
- **Application URL:** http://13.51.197.95
- **SSH to EC2:** `ssh -i your-key.pem ubuntu@13.51.197.95`
- **Check container:** `docker ps`
- **View logs:** `docker logs ecommerce-app`

## 🔧 Troubleshooting

### Common Issues:

#### 1. SSH Connection Failed
**Error:** `Permission denied (publickey)`
**Solution:** 
- Verify `EC2_PRIVATE_KEY` secret contains the full .pem file content
- Check EC2 security group allows SSH from 0.0.0.0/0

#### 2. Docker Hub Push Failed
**Error:** `unauthorized: authentication required`
**Solution:**
- Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
- Use Docker Hub access token instead of password

#### 3. Deployment Failed
**Error:** `Container failed to start`
**Solution:**
- Check EC2 has enough resources
- View container logs: `docker logs ecommerce-app`
- Ensure port 80 is not used by other services

#### 4. Lint Errors
**Error:** `npm run lint` fails
**Solution:**
- Fix ESLint errors in your code
- Run `npm run lint` locally first

### Debug Commands:

```bash
# On your local machine - test Docker build
docker build -t test-image .
docker run -p 3000:80 test-image

# On EC2 server - check deployment
ssh -i your-key.pem ubuntu@13.51.197.95
docker ps
docker logs ecommerce-app
curl http://localhost
```

## 🔄 Updating Your Application

### Normal Development Workflow:

1. **Make code changes**
2. **Commit and push to main branch:**
   ```bash
   git add .
   git commit -m "Your changes"
   git push origin main
   ```
3. **Watch the pipeline run** in GitHub Actions
4. **Verify deployment** at http://13.51.197.95

### The pipeline will automatically:
- ✅ Test your code
- ✅ Build new Docker image
- ✅ Push to Docker Hub
- ✅ Deploy to EC2
- ✅ Verify the deployment

## 🔒 Security Best Practices

1. **Use Docker Hub access tokens** instead of passwords
2. **Rotate secrets regularly**
3. **Limit EC2 security group** to specific IPs when possible
4. **Monitor GitHub Actions logs** for any suspicious activity
5. **Keep EC2 system updated:** `sudo apt update && sudo apt upgrade`

## 📈 Advanced Features

### Branch Protection Rules:
1. **Go to repository Settings** → **Branches**
2. **Add rule for main branch**
3. **Require status checks:** Select "Test & Lint"
4. **Require pull request reviews**

### Environments:
1. **Go to repository Settings** → **Environments**
2. **Create "production" environment**
3. **Add protection rules and secrets**

### Monitoring:
- Set up AWS CloudWatch for EC2 monitoring
- Add Slack/Discord notifications to workflow
- Implement health checks and rollback procedures

---

## 🎉 Congratulations!

Your CI/CD pipeline is now set up! Every time you push code to the main branch, it will automatically deploy to your EC2 server.

**Next Steps:**
1. Set up the GitHub secrets
2. Push code and watch the magic happen! ✨