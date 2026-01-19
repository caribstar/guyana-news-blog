import jwt
import requests
import time
import os
import re
import json
from datetime import datetime

# Ghost API Configuration
GHOST_URL = "https://guyanadailybrief.com"
ADMIN_API_KEY = "696d7772b68e3f0001f097f6:30f52fd879733048956f7e92ba3926513a348de014efe4ca422030b8bcaf15da"

# Split the key
key_id, key_secret = ADMIN_API_KEY.split(':')

# Create JWT token
iat = int(time.time())
header = {'alg': 'HS256', 'typ': 'JWT', 'kid': key_id}
payload = {
    'iat': iat,
    'exp': iat + 5 * 60,
    'aud': '/admin/'
}

token = jwt.encode(payload, bytes.fromhex(key_secret), algorithm='HS256', headers=header)

# API headers
headers = {
    'Authorization': f'Ghost {token}',
    'Content-Type': 'application/json'
}

def parse_hugo_post(filepath):
    """Parse a Hugo markdown post and extract frontmatter and content."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find frontmatter between first two --- markers
    parts = content.split('---', 2)
    if len(parts) < 3:
        return None
    
    frontmatter = parts[1].strip()
    body = parts[2].strip()
    
    # Extract title - handle both quoted and unquoted
    title_match = re.search(r'title:\s*"([^"]+)"', frontmatter)
    if not title_match:
        title_match = re.search(r"title:\s*'([^']+)'", frontmatter)
    if not title_match:
        title_match = re.search(r'title:\s*(.+)$', frontmatter, re.MULTILINE)
    title = title_match.group(1).strip() if title_match else os.path.basename(filepath)
    
    # Extract date
    date_match = re.search(r'date:\s*(\d{4}-\d{2}-\d{2})', frontmatter)
    date_str = date_match.group(1) if date_match else "2026-01-18"
    
    # Extract categories - handle both list and inline formats
    categories = []
    
    # Try list format first: categories:\n  - "Cat1"\n  - "Cat2"
    cat_match = re.search(r'categories:\s*\n((?:\s+-\s*"?[^"\n]+"?\s*\n?)+)', frontmatter)
    if cat_match:
        categories = re.findall(r'-\s*"?([^"\n]+)"?', cat_match.group(1))
    
    # Try inline format: categories: ["Cat1", "Cat2"]
    if not categories:
        cat_match = re.search(r'categories:\s*\[([^\]]+)\]', frontmatter)
        if cat_match:
            categories = re.findall(r'"([^"]+)"', cat_match.group(1))
    
    # Also get tags as backup
    if not categories:
        tag_match = re.search(r'tags:\s*\[([^\]]+)\]', frontmatter)
        if tag_match:
            categories = re.findall(r'"([^"]+)"', tag_match.group(1))
    
    # Clean up categories
    categories = [c.strip() for c in categories if c.strip()]
    
    return {
        'title': title,
        'date': date_str,
        'body': body,
        'categories': categories,
        'slug': os.path.basename(filepath).replace('.md', '')
    }

def create_ghost_post(post_data):
    """Create a post in Ghost via the Admin API."""
    
    # Convert markdown to mobiledoc format
    mobiledoc = {
        "version": "0.3.1",
        "atoms": [],
        "cards": [["markdown", {"markdown": post_data['body']}]],
        "markups": [],
        "sections": [[10, 0]]
    }
    
    # Prepare post payload
    post = {
        "posts": [{
            "title": post_data['title'],
            "slug": post_data['slug'],
            "mobiledoc": str(mobiledoc).replace("'", '"'),
            "status": "published",
            "published_at": f"{post_data['date']}T12:00:00.000Z",
            "tags": post_data['categories']
        }]
    }
    
    # Make API request
    response = requests.post(
        f"{GHOST_URL}/ghost/api/admin/posts/",
        headers=headers,
        json=post
    )
    
    return response

def main():
    posts_dir = r"C:\Users\Staff\guyana-news-blog-RESTORED\content\posts"
    
    # Get all markdown files
    md_files = [f for f in os.listdir(posts_dir) if f.endswith('.md')]
    md_files.sort()
    
    print(f"Found {len(md_files)} posts to import")
    print("")
    
    success_count = 0
    error_count = 0
    
    for filename in md_files:
        filepath = os.path.join(posts_dir, filename)
        
        # Parse the post
        post_data = parse_hugo_post(filepath)
        if not post_data:
            print(f"[SKIP] Could not parse: {filename}")
            error_count += 1
            continue
        
        # Create in Ghost
        response = create_ghost_post(post_data)
        
        if response.status_code == 201:
            print(f"[OK] Imported: {post_data['title'][:50]}...")
            success_count += 1
        else:
            print(f"[FAIL] {filename} - Status {response.status_code}")
            try:
                error_info = response.json()
                if 'errors' in error_info:
                    print(f"       Error: {error_info['errors'][0].get('message', 'Unknown')}")
            except:
                print(f"       Error: {response.text[:100]}")
            error_count += 1
        
        # Small delay to avoid rate limiting
        time.sleep(0.5)
    
    print("")
    print("=" * 50)
    print("Import complete!")
    print(f"Success: {success_count}")
    print(f"Errors: {error_count}")

if __name__ == "__main__":
    main()
