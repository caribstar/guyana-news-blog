# 🇬🇾 GUYANA DAILY BRIEF - COMPLETE REBUILD GUIDE

## Backup Date: 2026-01-15_16-08

---

## 📋 WHAT'S INCLUDED

This backup contains everything needed to rebuild the Guyana Daily Brief website:

- ✅ All blog posts and content
- ✅ Custom layouts and templates
- ✅ Static files (images, CSS)
- ✅ Hugo theme (PaperMod)
- ✅ Configuration (hugo.toml)
- ✅ Automation script (hugo-push.ps1)
- ✅ This rebuild guide

---

## 🚀 QUICK REBUILD (10 Minutes)

### Prerequisites

1. **Install Hugo Extended** (v0.140.0 or newer)
   - Windows: `choco install hugo-extended` or download from https://gohugo.io/installation/
   - Mac: `brew install hugo`
   - Linux: `sudo snap install hugo`

2. **Install Git**
   - Windows: https://git-scm.com/download/win
   - Mac: `brew install git`
   - Linux: `sudo apt install git`

### Step 1: Extract Backup

Extract this backup folder to your desired location
Example: C:\Projects\guyana-news-blog

### Step 2: Test Locally
```powershell
cd guyana-news-blog
hugo server -D
# Visit: http://localhost:1313/
```

### Step 3: Deploy with Automation
```powershell
.\hugo-push.ps1
```

---

## 📁 FILE STRUCTURE
```
guyana-news-blog/
├── content/           # All blog posts
│   ├── posts/        # Daily content
│   ├── magazine/     # Long-form
│   └── roundup/      # Summaries
├── layouts/           # Templates
│   └── index.html    # Homepage with Beehiiv
├── static/            # Images, CSS, JS
├── themes/            # PaperMod theme
├── hugo.toml         # Configuration
└── hugo-push.ps1     # Auto-deploy
```

---

## 🎨 KEY FEATURES

### 1. Dueling Perspectives
   - Uncle Ramesh (Pro-Government)
   - Daily Brief (Opposition Watch)

### 2. Guyana Rising
   - The Guyanese Horizon
   - Patriots' Portfolio

### 3. Entertainment
   - Speedeet & Wilar
   - Daily Laugh

### 4. Newsletter
   - Beehiiv API integrated in layouts/index.html

---

## 🌐 DEPLOYMENT OPTIONS

### GitHub Pages (Free)
1. Push to GitHub
2. Enable Pages in settings
3. Done!

### Netlify (Free)
1. Connect GitHub repo
2. Build: `hugo --gc --minify`
3. Publish: `public`

### Vercel (Free)
1. Import repo
2. Framework: Hugo
3. Auto-configured

---

## 🔄 DAILY WORKFLOW
```powershell
# Create new post
hugo new posts/2026-01-16-daily-brief.md

# Edit, then publish
.\hugo-push.ps1
```

---

## 🆘 TROUBLESHOOTING

**Hugo build fails?**
```powershell
hugo version  # Should be v0.140.0+ extended
```

**Newsletter not working?**
Check layouts/index.html for Beehiiv API endpoint

**Git push fails?**
```powershell
git remote remove origin
git remote add origin https://github.com/USER/REPO.git
git push -u origin main
```

---

## ✅ VERIFICATION CHECKLIST

- [ ] Homepage loads
- [ ] Dueling Blogs visible
- [ ] Newsletter works
- [ ] All categories accessible
- [ ] Search works
- [ ] Mobile responsive
- [ ] Automation script runs

---

*One People, One Nation, One Destiny* 🇬🇾

**Backup Date:** 2026-01-15_16-08
