# 🚀 MathQuiz - Deployment Guide

This guide explains how to deploy MathQuiz online so it's accessible via your website.

---

## 🌐 Deployment Options

### Option 1: ShinyApps.io (RECOMMENDED)

**Pros:**
- ✅ Free tier available (25 active hours/month)
- ✅ Easy deployment
- ✅ Automatic scaling
- ✅ HTTPS included
- ✅ No server management

**Cons:**
- ⚠️ Limited free hours
- ⚠️ App sleeps after inactivity (15-20s wake time)

---

## 📋 Step-by-Step: Deploy to ShinyApps.io

### 1. Create a ShinyApps.io Account

1. Go to [https://www.shinyapps.io/](https://www.shinyapps.io/)
2. Click **"Sign Up"** (free tier)
3. Choose **"Sign up with GitHub"** or email
4. Complete registration

### 2. Get Your Authentication Token

1. Log in to ShinyApps.io
2. Click your username → **Account → Tokens**
3. Click **"Show"** button
4. Click **"Show Secret"** button
5. Copy the token and secret (you'll need these)

### 3. Configure rsconnect in R

Open R/RStudio and run:

```r
# Install rsconnect if needed
install.packages("rsconnect")

# Configure with your credentials
rsconnect::setAccountInfo(
  name = "YOUR_USERNAME",      # Your ShinyApps.io username
  token = "YOUR_TOKEN",         # From step 2
  secret = "YOUR_SECRET"        # From step 2
)
```

### 4. Deploy the Application

```r
# Navigate to your app directory
setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")

# Deploy using the automated script
source("deploy_to_shinyapps.R")
```

**OR manually:**

```r
library(rsconnect)

rsconnect::deployApp(
  appDir = ".",
  appName = "mathquiz",
  appTitle = "MathQuiz - Interactive Math Learning",
  forceUpdate = TRUE
)
```

**Deployment takes 2-5 minutes.** You'll see progress in the console.

### 5. Get Your App URL

After deployment, your app will be live at:
```
https://YOUR_USERNAME.shinyapps.io/mathquiz/
```

For example: `https://alexis.shinyapps.io/mathquiz/`

---

## 🔗 Add Link to Your Website

### Option A: Direct Link

Add a link in your website's navigation:

```html
<a href="https://YOUR_USERNAME.shinyapps.io/mathquiz/">MathQuiz</a>
```

### Option B: Redirect Page (Cleaner URL)

1. Copy `mathquiz.html` to the root of your GitHub Pages repository
2. Edit the file and replace `YOUR_USERNAME` with your ShinyApps.io username
3. Commit and push to GitHub
4. Your app will be accessible at: `https://aladasic.github.io/mathquiz.html`

Update `mathquiz.html`:
```html
<meta http-equiv="refresh" content="0; url=https://YOUR_USERNAME.shinyapps.io/mathquiz/">
```

### Option C: Embed in iFrame (Advanced)

Add to any page on your site:

```html
<iframe
  src="https://YOUR_USERNAME.shinyapps.io/mathquiz/"
  width="100%"
  height="800px"
  style="border: none; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1);">
</iframe>
```

---

## ⚙️ ShinyApps.io Settings

### Increase Instance Size (if needed)

1. Go to ShinyApps.io dashboard
2. Click on **mathquiz** app
3. Go to **Settings → General**
4. Adjust:
   - **Instance Size**: Small (default) or Medium
   - **Max Worker Processes**: 1 (free tier)
   - **Connection Timeout**: 60 seconds

### Set Idle Timeout

**Settings → Advanced:**
- **Instance Idle Timeout**: 15 minutes (app sleeps if no activity)

---

## 📊 Monitor Usage

**Dashboard → mathquiz → Metrics:**
- Active hours used (25/month free)
- Number of visits
- Response times

**Upgrade if needed:**
- Starter: $9/month (100 hours)
- Basic: $39/month (500 hours)
- Standard: $99/month (2000 hours)

---

## 🐛 Troubleshooting Deployment

### Error: "Account not configured"

**Solution:**
```r
rsconnect::accounts()  # Check configured accounts

# If empty, run setAccountInfo again
rsconnect::setAccountInfo(name = "...", token = "...", secret = "...")
```

### Error: "Application failed to start"

**Causes:**
1. Missing `questions_bank.rds` file
2. Missing packages on server
3. Incorrect file paths

**Solution:**
```r
# Ensure question bank exists
source("build_question_bank.R")

# Check dependencies
source("install_dependencies.R")

# Redeploy
source("deploy_to_shinyapps.R")
```

### Error: "Exceeded active hours"

**Solution:**
- Wait until next month (free tier resets)
- Upgrade plan
- Reduce usage by setting longer idle timeout

### App is Slow to Wake Up

**Normal behavior** for free tier:
- Apps sleep after 15 min of inactivity
- Takes 15-20 seconds to wake up
- Upgrade to paid tier for always-on apps

---

## 🔄 Update Your Deployed App

After making changes to your app:

```r
setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")

# Rebuild question bank if LaTeX files changed
source("build_question_bank.R")

# Redeploy
source("deploy_to_shinyapps.R")
```

---

## 🔐 Security Best Practices

### Protect Your Tokens

**NEVER commit** `rsconnect/` folder to public GitHub:

Add to `.gitignore`:
```
rsconnect/
*.dcf
```

### Environment Variables (for tokens)

Store secrets in `.Renviron`:
```r
# ~/.Renviron
SHINYAPPS_TOKEN=your_token_here
SHINYAPPS_SECRET=your_secret_here
```

Then in R:
```r
rsconnect::setAccountInfo(
  name = "username",
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)
```

---

## 🎯 Alternative Hosting Options

### Option 2: Shiny Server (Self-Hosted)

**Pros:**
- Full control
- No usage limits
- Faster (no cold starts)

**Cons:**
- Requires Linux server
- More complex setup
- Need to manage updates

**Setup:** See [Shiny Server documentation](https://www.rstudio.com/products/shiny/shiny-server/)

### Option 3: RStudio Connect

**Pros:**
- Enterprise features
- Advanced security
- Better performance

**Cons:**
- Expensive ($995/year)
- Overkill for personal projects

### Option 4: Hugging Face Spaces

**Pros:**
- Free tier
- GPU support
- Good for ML apps

**Cons:**
- Requires Docker knowledge
- Not optimized for Shiny

---

## 📝 Deployment Checklist

Before deploying:

- [ ] Question bank generated (`data/questions_bank.rds` exists)
- [ ] All packages installed
- [ ] App tested locally (`shiny::runApp("app.R")`)
- [ ] ShinyApps.io account created
- [ ] Authentication configured (`rsconnect::setAccountInfo()`)
- [ ] `.gitignore` updated to exclude `rsconnect/`
- [ ] Deployment script run (`deploy_to_shinyapps.R`)
- [ ] App URL tested in browser
- [ ] Link added to your website

---

## 🆘 Need Help?

**ShinyApps.io Documentation:**
- [Getting Started](https://docs.rstudio.com/shinyapps.io/getting-started.html)
- [Account Management](https://docs.rstudio.com/shinyapps.io/account-management.html)
- [Troubleshooting](https://docs.rstudio.com/shinyapps.io/troubleshooting.html)

**Community Support:**
- [RStudio Community](https://community.rstudio.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/shiny)

---

## 🎉 Success!

Once deployed, your MathQuiz app will be accessible worldwide at your custom URL!

**Example:** `https://aladasic.github.io/mathquiz.html` → redirects to → `https://alexis.shinyapps.io/mathquiz/`

Share it with classmates, add it to your portfolio, and enjoy interactive math practice anytime, anywhere! 📐✨
