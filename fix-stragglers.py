"""Patch the 2 remaining unclassifiable posts.

1. 2026-01-16-guyanese-horizon-georgetown.md — has empty categories: [].
   Fix: add category "The Guyanese Horizon" (series).

2. daily-brief-2026-01-24.md — no frontmatter, no recognizable filename pattern.
   Fix: synthesize frontmatter, category "Daily Brief".
"""
import os, sys, re

if len(sys.argv) < 2:
    print("Usage: python fix-stragglers.py <repo_path>")
    sys.exit(1)

REPO = sys.argv[1]
POSTS_DIR = os.path.join(REPO, "content", "posts")

# FILE 1: guyanese-horizon — add category to existing frontmatter
f1_path = os.path.join(POSTS_DIR, "2026-01-16-guyanese-horizon-georgetown.md")
if os.path.exists(f1_path):
    with open(f1_path, "r", encoding="utf-8-sig") as f:
        raw = f.read()
    # Replace empty categories: [] with categories: ["The Guyanese Horizon"]
    new_raw = re.sub(
        r'^categories:\s*\[\s*\]',
        'categories: ["The Guyanese Horizon"]',
        raw,
        flags=re.MULTILINE
    )
    # Also add tone/status/product_family if missing
    if not re.search(r'(?m)^tone:', new_raw):
        # Find end of frontmatter
        end = new_raw.find("\n---", 3)
        if end > 0:
            insertion = '\ntone: "commentary"\nstatus: "published"\ncountry: "guyana"\nproduct_family: "series"'
            new_raw = new_raw[:end] + insertion + new_raw[end:]
    
    if new_raw != raw:
        with open(f1_path, "w", encoding="utf-8") as f:
            f.write(new_raw)
        print(f"PATCHED: 2026-01-16-guyanese-horizon-georgetown.md")
    else:
        print(f"UNCHANGED: 2026-01-16-guyanese-horizon-georgetown.md")

# FILE 2: daily-brief-2026-01-24.md — add frontmatter from scratch
f2_path = os.path.join(POSTS_DIR, "daily-brief-2026-01-24.md")
if os.path.exists(f2_path):
    with open(f2_path, "r", encoding="utf-8-sig") as f:
        raw = f.read()
    
    if raw.startswith("---"):
        print(f"SKIP: daily-brief-2026-01-24.md already has frontmatter")
    else:
        # Extract title from first H1
        h1_match = re.search(r'^#\s+(.+)$', raw, re.MULTILINE)
        title = h1_match.group(1).strip() if h1_match else "The Daily Brief — January 24, 2026"
        safe_title = title.replace('"', "'")
        
        fm = f'''---
title: "{safe_title}"
date: 2026-01-24
categories: ["Daily Brief"]
tone: "commentary"
status: "published"
country: "guyana"
product_family: "gdb"
---
'''
        new_raw = fm + raw
        with open(f2_path, "w", encoding="utf-8") as f:
            f.write(new_raw)
        print(f"PATCHED: daily-brief-2026-01-24.md")

print("Done.")
