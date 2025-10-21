# 🆓 Get Free Domain Name - Step by Step

## Option 1: Cloudflare Pages (Recommended - Always Works)

### Step 1: Sign up for Cloudflare
1. **Visit:** https://dash.cloudflare.com/sign-up
2. **Create free account** with your email
3. **Verify email** and login

### Step 2: Create Pages Project
1. **Click:** "Pages" in left sidebar
2. **Click:** "Create a project"
3. **Choose:** "Connect to Git"
4. **Connect GitHub** and select your repository
5. **Project name:** `yourecommerce` (this becomes your domain)
6. **Get domain:** `yourecommerce.pages.dev`

### Step 3: Configure Custom Domain (Optional)
1. **Go to:** "Custom domains" tab
2. **Add:** your own domain if you have one
3. **Or use:** the free `.pages.dev` subdomain

## Option 2: InfinityFree (Free Subdomain)

### Step 1: Sign up
1. **Visit:** https://www.infinityfree.net
2. **Click:** "Sign Up"
3. **Create free account**

### Step 2: Get Free Subdomain
1. **Go to:** "Control Panel"
2. **Click:** "Create Account"
3. **Choose subdomain:** `yourecommerce.rf.gd`
4. **Complete setup**

### Step 3: Point to Your Server
1. **Go to:** "Subdomain Settings"
2. **Add A Record:**
   ```
   Type: A
   Name: @
   Value: 13.51.197.95
   TTL: 3600
   ```

## Option 3: No-IP (Dynamic DNS - Free)

### Step 1: Sign up for Cloudflare
1. **Visit:** https://dash.cloudflare.com/sign-up
2. **Create free account**

### Step 2: Use Cloudflare Pages
1. **Go to:** "Pages" in Cloudflare dashboard
2. **Connect GitHub repository**
3. **Get free subdomain:** `yourecommerce.pages.dev`
4. **Point to your GitHub repo**

## Option 3: GitHub Pages (Free Subdomain)

### Step 1: Sign up
1. **Visit:** https://www.noip.com
2. **Create free account**
3. **Verify email**

### Step 2: Create Hostname
1. **Login** to No-IP dashboard
2. **Click:** "Dynamic DNS"
3. **Click:** "Create Hostname"
4. **Enter:** `yourecommerce`
5. **Choose:** `.ddns.net` or other free options
6. **IP Address:** `13.51.197.95`
7. **Save**

## Quick Comparison:

| Option | Domain Example | SSL | Speed | Reliability |
|--------|---------------|-----|-------|-------------|
| **Cloudflare Pages** | `yourecommerce.pages.dev` | ✅ Auto | ⚡ Fast | 🏆 Best |
| **InfinityFree** | `yourecommerce.rf.gd` | ✅ Free | ⚡ Good | ✅ Good |
| **No-IP** | `yourecommerce.ddns.net` | ❌ Manual | ⚡ Good | ✅ Good |
| **GitHub Pages** | `username.github.io` | ✅ Auto | ⚡ Fast | ✅ Good |

## 🚀 Quick Setup Commands

After getting your domain, run these commands on your EC2:

```bash
# 1. Download the setup script
curl -O https://raw.githubusercontent.com/Dilshan2002104-cpu/E-Commerce-using-react/main/scripts/setup-domain-ssl.sh

# 2. Make it executable
chmod +x setup-domain-ssl.sh

# 3. Edit the script with your domain
nano setup-domain-ssl.sh
# Change: DOMAIN="yourdomain.tk"
# Change: EMAIL="your-email@example.com"

# 4. Run the setup
./setup-domain-ssl.sh
```

## ✅ Verification Steps

### Check DNS Propagation:
```bash
# Check if domain points to your server
nslookup yourdomain.tk

# Should return: 13.51.197.95
```

### Test HTTP Access:
```bash
# Test domain access
curl -I http://yourdomain.tk

# Should return: HTTP/1.1 200 OK
```

### Test HTTPS Access:
```bash
# After SSL setup
curl -I https://yourdomain.tk

# Should return: HTTP/1.1 200 OK with SSL
```

## 🔧 Troubleshooting

### Domain not working?
1. **Wait 24 hours** for DNS propagation
2. **Check DNS settings** at domain registrar
3. **Use different DNS servers** (8.8.8.8, 1.1.1.1)
4. **Clear browser cache**

### SSL not working?
1. **Make sure domain points to server first**
2. **Run certbot manually:**
   ```bash
   sudo certbot --nginx -d yourdomain.tk -d www.yourdomain.tk
   ```
3. **Check Nginx configuration:**
   ```bash
   sudo nginx -t
   ```

## 💡 Pro Tips

1. **Use .tk domains** - Most reliable free option
2. **Set up www subdomain** - Professional look
3. **Enable automatic renewal** - Never worry about SSL expiry
4. **Use Cloudflare** - Additional security and performance
5. **Test on mobile** - Ensure responsive design works

## 📈 Upgrade Path

### When you want to upgrade:
1. **Buy premium domain** (.com, .net, .org)
2. **Use Cloudflare Pro** - Better performance
3. **Add CDN** - Faster global loading
4. **Set up monitoring** - Uptime tracking

## 🎉 Final Result

After setup, you'll have:
- ✅ Professional domain name
- ✅ Free SSL certificate
- ✅ HTTPS redirect
- ✅ Security headers
- ✅ Automatic SSL renewal
- ✅ Production-ready setup

**Total cost: $0.00** 🆓