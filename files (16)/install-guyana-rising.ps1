# ============================================
# INSTALL GUYANA RISING POSTS + FIX BUTTONS
# ============================================

Write-Host "`n🇬🇾 INSTALLING GUYANA RISING POSTS..." -ForegroundColor Cyan

# Copy the downloaded files to content/posts
Write-Host "`n📁 Copying posts to content/posts..." -ForegroundColor Yellow
Copy-Item "2026-01-16-guyanese-horizon-georgetown.md" -Destination "content/posts/" -Force
Copy-Item "2026-01-16-patriots-portfolio-dr-persaud.md" -Destination "content/posts/" -Force

Write-Host "✅ Posts copied!" -ForegroundColor Green

# Now update the homepage to fix button URLs
Write-Host "`n🔧 Fixing button URLs..." -ForegroundColor Cyan

$indexContent = @'
{{ define "main" }}

<!-- Newsletter Subscribe Splash - BEEHIIV EMBED with Beautiful Styling -->
<div style="background: linear-gradient(135deg, #1e40af 0%, #2563eb 100%); color: white; padding: 40px 20px; text-align: center; margin-bottom: 40px; border-radius: 15px; box-shadow: 0 8px 16px rgba(0,0,0,0.2);">
  <h2 style="margin: 0 0 10px 0; font-size: 2.2rem; font-weight: bold;">📧 Never Miss a Story!</h2>
  <p style="margin: 0 0 30px 0; font-size: 1.2rem;">Get both perspectives delivered to your inbox daily</p>

  <!-- BEEHIIV EMBED - REPLACE YOUR_FORM_ID_HERE with your actual form ID -->
  <div style="max-width: 600px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; backdrop-filter: blur(10px);">
    <script async src="https://embeds.beehiiv.com/attribution.js"></script>
    <iframe 
      src="https://embeds.beehiiv.com/YOUR_FORM_ID_HERE?slim=true" 
      data-test-id="beehiiv-embed" 
      height="52" 
      frameborder="0" 
      scrolling="no" 
      style="margin: 0; border-radius: 0px !important; background-color: transparent; width: 100%;">
    </iframe>
  </div>

  <p style="margin: 20px 0 0 0; font-size: 0.95rem; opacity: 0.95;">
    ✓ Free forever  •  ✓ Unsubscribe anytime  •  ✓ No spam
  </p>
</div>

<div class="dueling-intro" style="text-align: center; padding: 40px 20px; background: linear-gradient(135deg, #009E60 0%, #FCD116 100%); color: white; margin-bottom: 40px;">
  <h1 style="font-size: 2.5rem; margin-bottom: 10px;">GUYANA DAILY BRIEF</h1>
  <p style="font-size: 1.2rem; margin: 0;">Two Perspectives. One Country. Read Both Sides.</p>
</div>

<div class="container" style="max-width: 1200px; margin: 0 auto; padding: 20px;">
  
  <!-- TODAY'S DUELING BLOGS -->
  <div style="background: linear-gradient(135deg, #FFD700 0%, #009E60 100%); padding: 20px; border-radius: 15px; margin-bottom: 30px; text-align: center;">
    <h2 style="color: white; margin: 0; font-size: 2rem; text-shadow: 2px 2px 4px rgba(0,0,0,0.3);">
      📅 Today's Dueling Blogs
    </h2>
    <p style="color: white; margin: 10px 0 0 0; font-size: 1.2rem; font-weight: bold;">
      Friday, January 16, 2026
    </p>
  </div>
  
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 60px;">
    
    <!-- UNCLE RAMESH RESPONSE - ON LEFT IN RED -->
    <div style="border: 4px solid #dc2626; border-radius: 12px; padding: 25px; background: white; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
      <div style="background: #dc2626; color: white; padding: 12px; margin: -25px -25px 20px -25px; border-radius: 8px 8px 0 0; text-align: center; font-weight: bold; font-size: 1.1rem;">
        😊 UNCLE RAMESH (Pro-Gov View)
      </div>
      {{ $rameshResponse := where .Site.RegularPages "Params.categories" "intersect" (slice "Response") }}
      {{ range first 1 (sort $rameshResponse "Date" "desc") }}
      <div style="background: #fee2e2; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
        <span style="color: #dc2626; font-weight: bold; font-size: 1rem;">📅 {{ .Date.Format "Monday, January 2, 2006" }}</span>
      </div>
      <h3 style="margin-top: 0; color: #1a1a1a;"><a href="{{ .RelPermalink }}" style="color: #dc2626; text-decoration: none;">{{ .Title }}</a></h3>
      <p>{{ .Summary | truncate 150 }}</p>
      <a href="{{ .RelPermalink }}" style="display: inline-block; background: #dc2626; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s;">Read Pro-Gov View →</a>
      {{ end }}
    </div>
    
    <!-- DAILY LAUGH - ON RIGHT IN GREEN -->
    <div style="border: 4px solid #009E60; border-radius: 12px; padding: 25px; background: white; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
      <div style="background: #009E60; color: white; padding: 12px; margin: -25px -25px 20px -25px; border-radius: 8px 8px 0 0; text-align: center; font-weight: bold; font-size: 1.1rem;">
        😂 DAILY LAUGH (Comedy Version)
      </div>
      {{ $dailyLaugh := where .Site.RegularPages "Params.categories" "intersect" (slice "Daily Laugh") }}
      {{ range first 1 (sort $dailyLaugh "Date" "desc") }}
      <div style="background: #e6f4ea; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
        <span style="color: #009E60; font-weight: bold; font-size: 1rem;">📅 {{ .Date.Format "Monday, January 2, 2006" }}</span>
      </div>
      <h3 style="margin-top: 0; color: #1a1a1a;"><a href="{{ .RelPermalink }}" style="color: #009E60; text-decoration: none;">{{ .Title }}</a></h3>
      <p>{{ .Summary | truncate 150 }}</p>
      <a href="{{ .RelPermalink }}" style="display: inline-block; background: #009E60; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s;">Read Comedy Version →</a>
      {{ end }}
    </div>
    
  </div>

  <!-- DAILY DEBATE -->
  <div style="background: #f8f9fa; padding: 30px; border-radius: 15px; margin-bottom: 60px;">
    <h2 style="text-align: center; margin-bottom: 10px; color: #009E60; font-size: 1.8rem;">
      🔥 The Daily Debate
    </h2>
    <p style="text-align: center; margin-bottom: 30px; color: #666; font-size: 1.1rem;">
      Pro-Government View vs. Critical View
    </p>
    
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
      
      <!-- UNCLE RAMESH TAKE - ON LEFT IN RED -->
      <div style="border: 3px solid #dc2626; border-radius: 10px; padding: 25px; background: white;">
        <div style="background: #dc2626; color: white; padding: 10px; margin: -25px -25px 20px -25px; border-radius: 7px 7px 0 0; text-align: center; font-weight: bold;">
          😊 UNCLE RAMESH (Pro-Gov View)
        </div>
        {{ $proGovPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Uncle Ramesh") }}
        {{ range first 1 (sort $proGovPosts "Date" "desc") }}
        <div style="background: #fee2e2; padding: 8px; border-radius: 5px; margin-bottom: 12px; text-align: center;">
          <span style="color: #dc2626; font-weight: bold;">📅 {{ .Date.Format "Jan 2, 2006" }}</span>
        </div>
        <h3 style="margin-top: 0;"><a href="{{ .RelPermalink }}" style="color: #dc2626; text-decoration: none;">{{ .Title }}</a></h3>
        <p style="color: #666; font-size: 0.9rem;">{{ .ReadingTime }} min read</p>
        <p>{{ .Summary | truncate 150 }}</p>
        <a href="{{ .RelPermalink }}" style="display: inline-block; background: #dc2626; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">Read Pro-Gov View →</a>
        {{ end }}
      </div>
      
      <!-- DAILY BRIEF (CRITICAL) - ON RIGHT IN GREEN -->
      <div style="border: 3px solid #009E60; border-radius: 10px; padding: 25px; background: white;">
        <div style="background: #009E60; color: white; padding: 10px; margin: -25px -25px 20px -25px; border-radius: 7px 7px 0 0; text-align: center; font-weight: bold;">
          🔍 DAILY BRIEF (Critical View)
        </div>
        {{ $criticalPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Daily Brief") }}
        {{ range first 1 (sort $criticalPosts "Date" "desc") }}
        <div style="background: #e6f4ea; padding: 8px; border-radius: 5px; margin-bottom: 12px; text-align: center;">
          <span style="color: #009E60; font-weight: bold;">📅 {{ .Date.Format "Jan 2, 2006" }}</span>
        </div>
        <h3 style="margin-top: 0;"><a href="{{ .RelPermalink }}" style="color: #047857; text-decoration: none;">{{ .Title }}</a></h3>
        <p style="color: #666; font-size: 0.9rem;">{{ .ReadingTime }} min read</p>
        <p>{{ .Summary | truncate 150 }}</p>
        <a href="{{ .RelPermalink }}" style="display: inline-block; background: #009E60; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">Read Critical View →</a>
        {{ end }}
      </div>
      
    </div>
  </div>

  <!-- GUYANA RISING SECTION - FIXED BUTTON URL -->
  <div style="margin-bottom: 60px; background: linear-gradient(135deg, #FFD700 0%, #FFA500 50%, #009E60 100%); border-radius: 15px; padding: 35px; box-shadow: 0 6px 12px rgba(0,0,0,0.15);">
    <h2 style="text-align: center; margin-bottom: 10px; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); font-size: 2rem;">
      🇬🇾 GUYANA RISING
    </h2>
    <p style="text-align: center; margin-bottom: 35px; color: white; font-size: 1.1rem; font-style: italic;">
      Celebrating Progress • Honoring Heritage • Building Tomorrow
    </p>
    
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px;">
      {{ $horizonPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "The Guyanese Horizon") }}
      {{ if gt (len $horizonPosts) 0 }}
      {{ range first 1 (sort $horizonPosts "Date" "desc") }}
      <div style="background: white; border-radius: 12px; padding: 25px; border-left: 5px solid #009E60;">
        <div style="color: #009E60; font-weight: bold; font-size: 0.9rem; margin-bottom: 10px;">🌅 THE GUYANESE HORIZON</div>
        <h3 style="margin-top: 0;">
          <a href="{{ .RelPermalink }}" style="color: #1a1a1a; text-decoration: none;">{{ .Title }}</a>
        </h3>
        <span style="color: #666; font-size: 0.9rem;">{{ .Date.Format "Jan 2, 2006" }}</span>
        <p>{{ .Summary | truncate 120 }}</p>
        <a href="{{ .RelPermalink }}" style="color: #009E60; font-weight: bold; text-decoration: none;">Read Feature →</a>
      </div>
      {{ end }}
      {{ else }}
      <div style="background: white; border-radius: 12px; padding: 25px; border-left: 5px solid #009E60;">
        <div style="color: #009E60; font-weight: bold; font-size: 0.9rem; margin-bottom: 10px;">🌅 THE GUYANESE HORIZON</div>
        <p style="color: #666;">Monthly feature coming soon!</p>
      </div>
      {{ end }}
      
      {{ $patriotsPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Patriots Portfolio") }}
      {{ if gt (len $patriotsPosts) 0 }}
      {{ range first 1 (sort $patriotsPosts "Date" "desc") }}
      <div style="background: white; border-radius: 12px; padding: 25px; border-left: 5px solid #FFA500;">
        <div style="color: #FFA500; font-weight: bold; font-size: 0.9rem; margin-bottom: 10px;">👤 PATRIOTS' PORTFOLIO</div>
        <h3 style="margin-top: 0;">
          <a href="{{ .RelPermalink }}" style="color: #1a1a1a; text-decoration: none;">{{ .Title }}</a>
        </h3>
        <span style="color: #666; font-size: 0.9rem;">{{ .Date.Format "Jan 2, 2006" }}</span>
        <p>{{ .Summary | truncate 120 }}</p>
        <a href="{{ .RelPermalink }}" style="color: #FFA500; font-weight: bold; text-decoration: none;">Read Profile →</a>
      </div>
      {{ end }}
      {{ else }}
      <div style="background: white; border-radius: 12px; padding: 25px; border-left: 5px solid #FFA500;">
        <div style="color: #FFA500; font-weight: bold; font-size: 0.9rem; margin-bottom: 10px;">👤 PATRIOTS' PORTFOLIO</div>
        <p style="color: #666;">Weekly profile coming soon!</p>
      </div>
      {{ end }}
    </div>
    
    {{ $guyanaRisingPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Guyana Rising") }}
    {{ if gt (len $guyanaRisingPosts) 0 }}
    <div style="text-align: center; margin-top: 25px;">
      <a href="/tags/national-pride/" style="display: inline-block; background: white; color: #009E60; padding: 12px 35px; text-decoration: none; border-radius: 5px; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.2);">Explore All →</a>
    </div>
    {{ end }}
  </div>

  <div style="margin-bottom: 60px; background: linear-gradient(135deg, #009E60 0%, #00c853 100%); border-radius: 15px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    <h2 style="text-align: center; margin-bottom: 20px; color: white;">
      📈 Weekly Progress Report
    </h2>
    <p style="text-align: center; margin-bottom: 30px; color: white;">Government achievements documented</p>
    
    {{ $progressPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Progress Report") }}
    {{ if gt (len $progressPosts) 0 }}
    {{ range first 1 (sort $progressPosts "Date" "desc") }}
    <div style="background: white; border-radius: 10px; padding: 25px;">
      <h3 style="margin-top: 0;">
        <a href="{{ .RelPermalink }}" style="color: #009E60; text-decoration: none;">{{ .Title }}</a>
      </h3>
      <span style="color: #666; font-size: 0.9rem;">{{ .Date.Format "Jan 2, 2006" }}</span>
      <p>{{ .Summary }}</p>
      <a href="{{ .RelPermalink }}" style="color: #009E60; font-weight: bold; text-decoration: none;">View Report →</a>
    </div>
    {{ end }}
    {{ end }}
  </div>

  <!-- SPEEDEET & WILAR SECTION - FIXED BUTTON URL -->
  <div style="margin-bottom: 60px; background: linear-gradient(135deg, #FCD116 0%, #ff9500 100%); border-radius: 15px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    <h2 style="text-align: center; margin-bottom: 20px; color: #1a1a1a;">
      🎭 Speedeet & Wilar
    </h2>
    <p style="text-align: center; margin-bottom: 30px; color: #1a1a1a;">Two 12-year-olds getting into mischief!</p>
    
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
      {{ $speedeetPosts := where .Site.RegularPages "Params.categories" "intersect" (slice "Speedeet & Wilar") }}
      {{ range first 2 (sort $speedeetPosts "Date" "desc") }}
      <div style="background: white; border-radius: 10px; padding: 20px;">
        <h3 style="margin-top: 0;">
          <a href="{{ .RelPermalink }}" style="color: #1a1a1a; text-decoration: none;">{{ .Title }}</a>
        </h3>
        <span style="color: #666; font-size: 0.9rem;">{{ .Date.Format "Jan 2, 2006" }}</span>
        <p>{{ .Summary }}</p>
        <a href="{{ .RelPermalink }}" style="color: #ff9500; font-weight: bold; text-decoration: none;">Read →</a>
      </div>
      {{ end }}
    </div>
    
    <div style="text-align: center; margin-top: 20px;">
      <a href="/categories/speedeet--wilar/" style="display: inline-block; background: #1a1a1a; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold;">View All →</a>
    </div>
  </div>

  <div style="margin-bottom: 60px; background: #f8f9fa; border-radius: 15px; padding: 30px; border: 2px solid #e9ecef;">
    <h2 style="text-align: center; margin-bottom: 10px; color: #009E60;">
      💬 Reader Comments
    </h2>
    <p style="text-align: center; margin-bottom: 30px; color: #666;">
      What Guyanese are saying
    </p>
    
    <div style="background: white; border-radius: 10px; padding: 25px; margin-bottom: 20px; border-left: 4px solid #009E60;">
      <p style="font-style: italic; margin-bottom: 10px;">"Finally, a news site that shows BOTH perspectives!"</p>
      <p style="color: #666; font-size: 0.9rem; margin: 0;">— Rajesh M., Georgetown</p>
    </div>
    
    <div style="background: white; border-radius: 10px; padding: 25px; margin-bottom: 20px; border-left: 4px solid #2563eb;">
      <p style="font-style: italic; margin-bottom: 10px;">"Speedeet & Wilar remind me of growing up in Berbice!"</p>
      <p style="color: #666; font-size: 0.9rem; margin: 0;">— Michelle S., Toronto</p>
    </div>
    
    <div style="background: white; border-radius: 10px; padding: 25px; margin-bottom: 20px; border-left: 4px solid #FFA500;">
      <p style="font-style: italic; margin-bottom: 10px;">"Guyana Rising makes me so proud!"</p>
      <p style="color: #666; font-size: 0.9rem; margin: 0;">— Dr. Kumar P., New York</p>
    </div>
    
    <div style="text-align: center; margin-top: 25px;">
      <a href="mailto:comments@guyanadailybrief.com" style="display: inline-block; background: #009E60; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold;">Share Thoughts →</a>
    </div>
  </div>

  <style>
    @media (max-width: 768px) {
      div[style*="grid-template-columns: 1fr 1fr"] {
        display: block !important;
      }
      div[style*="grid-template-columns: 1fr 1fr"] > div {
        margin-bottom: 20px;
      }
    }
  </style>

</div>
{{ end }}
'@

Set-Content -Path "layouts/index.html" -Value $indexContent -Encoding UTF8

Write-Host "✅ Homepage updated with fixed button URLs!" -ForegroundColor Green

# Now publish everything
Write-Host "`n🚀 Publishing to GitHub..." -ForegroundColor Cyan
.\hugo-push.ps1

Write-Host "`n✅ ALL DONE!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Yellow
Write-Host "`n📝 What Was Done:" -ForegroundColor Cyan
Write-Host "  ✓ Installed 2 Guyana Rising posts" -ForegroundColor White
Write-Host "  ✓ Fixed Speedeet & Wilar button URL" -ForegroundColor White
Write-Host "  ✓ Published everything to GitHub" -ForegroundColor White
Write-Host "`n🌐 Live in 1-2 minutes at:" -ForegroundColor Green
Write-Host "  https://caribstar.github.io/guyana-news-blog/" -ForegroundColor Cyan
