# Quick Setup Script for GitHub Secrets

# This script helps you format your secrets correctly for GitHub

Write-Host "🔧 GitHub Secrets Setup Helper" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

Write-Host "📋 You need to add these secrets to your GitHub repository:" -ForegroundColor Yellow
Write-Host "   Repository → Settings → Secrets and variables → Actions" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. DOCKER_USERNAME" -ForegroundColor White
Write-Host "   Value: dilshan019" -ForegroundColor Gray
Write-Host ""

Write-Host "2. DOCKER_PASSWORD" -ForegroundColor White
Write-Host "   Value: [Your Docker Hub password or access token]" -ForegroundColor Gray
Write-Host "   💡 Tip: Use Docker Hub access token for better security" -ForegroundColor Yellow
Write-Host ""

Write-Host "3. EC2_HOST" -ForegroundColor White
Write-Host "   Value: 13.51.197.95" -ForegroundColor Gray
Write-Host ""

Write-Host "4. EC2_PRIVATE_KEY" -ForegroundColor White
Write-Host "   Value: [Your EC2 private key (.pem file content)]" -ForegroundColor Gray
Write-Host ""

# Check if private key file exists
$privateKeyPath = Read-Host "Enter path to your EC2 private key file (.pem)"

if (Test-Path $privateKeyPath) {
    Write-Host "✅ Private key file found!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Copy this content for EC2_PRIVATE_KEY secret:" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Get-Content $privateKeyPath | Write-Host -ForegroundColor White
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Make sure to copy the ENTIRE content including BEGIN/END lines" -ForegroundColor Red
} else {
    Write-Host "Private key file not found at: $privateKeyPath" -ForegroundColor Red
    Write-Host "Make sure the path is correct and the file exists" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "After setting up secrets, push code to main branch to trigger deployment!" -ForegroundColor Green
Write-Host ""
Write-Host "Monitor your pipeline at:" -ForegroundColor Yellow
Write-Host "   https://github.com/Dilshan2002104-cpu/E-Commerce-using-react/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your app will be available at:" -ForegroundColor Yellow
Write-Host "   http://13.51.197.95" -ForegroundColor Cyan