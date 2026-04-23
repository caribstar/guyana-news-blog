"""
Retrofit all posts with schema fields, migrate ghost categories, fix mojibake.

Usage: python retrofit_posts.py <path_to_repo>

Rules:
- NEVER overwrites existing frontmatter fields, only ADDS missing ones
- Adds tone, status, country, product_family based on categories
- Migrates Jamaica Brief -> Yard Brief
- Fixes common mojibake sequences
- Preserves all existing tags, author, series, description, body
"""
import os, sys, re, io

if len(sys.argv) < 2:
    print("Usage: python retrofit_posts.py <repo_path>")
    sys.exit(1)

REPO = sys.argv[1]
POSTS_DIR = os.path.join(REPO, "content", "posts")
if not os.path.isdir(POSTS_DIR):
    print(f"ERROR: {POSTS_DIR} not found")
    sys.exit(1)

# Category -> product family + tone mapping
COUNTRY_NETWORK = {
    "Guyana Brief":  ("guyana",       "satire"),
    "Yard Brief":    ("jamaica",      "satire"),
    "Trini Brief":   ("trinidad",     "satire"),
    "Bajan Brief":   ("barbados",     "satire"),
    "Ghana Brief":   ("ghana",        "satire"),
    "Naija Brief":   ("nigeria",      "satire"),
    "Kenya Brief":   ("kenya",        "satire"),
    "SA Brief":      ("south-africa", "satire"),
}
GDB_FAMILY = {
    "Daily Brief":     ("guyana", "commentary"),
    "Uncle Ramesh":    ("guyana", "commentary"),
    "Caribbean Brief": (None,     "commentary"),
    "News":            ("guyana", "commentary"),  # GDB daily brief posts
}
SERIES_FAMILY = {
    "Speedeet & Wilar":     ("guyana", "commentary"),
    "Speedeet and Wilar":   ("guyana", "commentary"),
    "De Boys Seh":          ("guyana", "commentary"),
    "Patriots Portfolio":   ("guyana", "commentary"),
    "YouTube Scripts":      (None,     "commentary"),
    "Progress Report":      ("guyana", "commentary"),
    "DJ Roadblock":         ("guyana", "commentary"),
    "Back-a-Truck":         ("guyana", "commentary"),
    "Bounty Board":         ("guyana", "commentary"),
    "Bam-Bam Sally":        ("guyana", "commentary"),
    "The Rumor Mill":       ("guyana", "commentary"),
    "The Rumour Mill":      ("guyana", "commentary"),
    "Rumor Mill":           ("guyana", "commentary"),
    "Rumour Mill":          ("guyana", "commentary"),
    "Traffic Report":       ("guyana", "commentary"),
    "The Guyanese Horizon": ("guyana", "commentary"),
    "Caribbean Daily Brief": (None,    "commentary"),
    "Indo-Caribbean Brief": (None,     "commentary"),
    "Response":             ("guyana", "commentary"),
    "Announcements":        (None,     "commentary"),
    "Daily Laugh":          ("guyana", "commentary"),
    "Opinion":              ("guyana", "commentary"),
    "Ramesh":               ("guyana", "commentary"),
    "Ramesh Sees It Differently": ("guyana", "commentary"),
    "YouTube":              (None,     "commentary"),
    "Nigeria Brief":        ("nigeria","satire"),  # legacy, if any slipped through
    "South Africa Brief":   ("south-africa","satire"),
}

# Mojibake repair: common UTF-8 bytes misread as CP1252 then re-encoded
MOJIBAKE_FIXES = [
    # em/en dashes
    ("\u00e2\u20ac\u201d", "\u2014"),  # —
    ("\u00e2\u20ac\u201c", "\u2013"),  # –
    ("\u00e2\u20ac\u2122", "\u2019"),  # ’
    ("\u00e2\u20ac\u02dc", "\u2018"),  # ‘
    ("\u00e2\u20ac\u0153", "\u201c"),  # “
    ("\u00e2\u20ac\u009d", "\u201d"),  # ”
    ("\u00e2\u20ac\u00a6", "\u2026"),  # …
    ("\u00e2\u20ac\u00a2", "\u2022"),  # •
    ("\u00c3\u00a9", "\u00e9"),         # é
    ("\u00c3\u00a8", "\u00e8"),         # è
    ("\u00c3\u00a0", "\u00e0"),         # à
    ("\u00c3\u00b1", "\u00f1"),         # ñ
    ("\u00c3\u00ad", "\u00ed"),         # í
    ("\u00c3\u00b3", "\u00f3"),         # ó
    ("\u00c3\u00ba", "\u00fa"),         # ú
    ("\u00c2\u00a0", " "),              # nbsp
    ("\u00c2\u00ab", "\u00ab"),         # «
    ("\u00c2\u00bb", "\u00bb"),         # »
    # Common bare em dash in ascii stream
    ("\u00e2\u20ac", "\u2014"),  # fallback any unresolved â€
]

def fix_mojibake(text):
    fixed = text
    for bad, good in MOJIBAKE_FIXES:
        if bad in fixed:
            fixed = fixed.replace(bad, good)
    return fixed

def parse_frontmatter(raw):
    """Split a markdown file into frontmatter and body."""
    if not raw.startswith("---"):
        return None, raw
    end = raw.find("\n---", 3)
    if end == -1:
        return None, raw
    fm = raw[3:end].strip()
    body_start = end + 4
    # Skip next newline
    if body_start < len(raw) and raw[body_start] == "\n":
        body_start += 1
    body = raw[body_start:]
    return fm, body

def get_categories(fm):
    """Extract category list from frontmatter."""
    m = re.search(r'^categories:\s*\[(.*?)\]', fm, re.MULTILINE | re.DOTALL)
    if not m:
        return []
    inner = m.group(1)
    cats = re.findall(r'"([^"]+)"', inner)
    return cats

def has_field(fm, field):
    return bool(re.search(r'^' + re.escape(field) + r':', fm, re.MULTILINE))

def classify(categories, filename=""):
    """Return (country, tone, product_family) based on category list.
    
    Priority:
      1. Country Network category (satire wins)
      2. GDB family category
      3. Series family category
      4. Filename heuristic (if no categories)
      5. Unknown -> flagged, not defaulted silently
    """
    # Priority: Country Network wins (satire product)
    for cat in categories:
        if cat in COUNTRY_NETWORK:
            country, tone = COUNTRY_NETWORK[cat]
            return country, tone, "country-network"
    # Then GDB family
    for cat in categories:
        if cat in GDB_FAMILY:
            country, tone = GDB_FAMILY[cat]
            return country, tone, "gdb"
    # Then Series
    for cat in categories:
        if cat in SERIES_FAMILY:
            country, tone = SERIES_FAMILY[cat]
            return country, tone, "series"
    # Filename heuristic for no-category posts
    fn = filename.lower()
    if fn:
        # GDB daily briefs
        if any(day in fn for day in ["monday-brief", "tuesday-brief", "wednesday-brief",
                                      "thursday-brief", "friday-brief", "saturday-brief",
                                      "sunday-brief", "-brief.md"]):
            return "guyana", "commentary", "gdb"
        # Uncle Ramesh
        if "uncle-ramesh" in fn or "ramesh-take" in fn:
            return "guyana", "commentary", "gdb"
        # Series
        if "youtube-scripts" in fn or "youtube" in fn:
            return None, "commentary", "series"
        if "speedeet" in fn or "wilar" in fn:
            return "guyana", "commentary", "series"
        if "de-boys" in fn or "boys-seh" in fn:
            return "guyana", "commentary", "series"
        if "patriots" in fn:
            return "guyana", "commentary", "series"
        if "bam-bam" in fn or "sally" in fn:
            return "guyana", "commentary", "series"
        if "dj-roadblock" in fn or "roadblock" in fn:
            return "guyana", "commentary", "series"
        if "back-a-truck" in fn:
            return "guyana", "commentary", "series"
        if "bounty-board" in fn:
            return "guyana", "commentary", "series"
        if "progress-report" in fn:
            return "guyana", "commentary", "series"
        if "traffic-report" in fn:
            return "guyana", "commentary", "series"
        if "rumor-mill" in fn or "rumour-mill" in fn:
            return "guyana", "commentary", "series"
        if "caribbean" in fn:
            return None, "commentary", "gdb"
    # Unclassifiable — flag it, don't silently default
    return None, None, "unknown"

def migrate_category(fm):
    """Migrate Jamaica Brief -> Yard Brief in categories list."""
    # Also merge Rumor Mill variants
    changed = False
    # Pattern: find the categories line and rewrite it
    def replace_cats(m):
        nonlocal changed
        inner = m.group(1)
        cats = re.findall(r'"([^"]+)"', inner)
        new_cats = []
        for c in cats:
            if c == "Jamaica Brief":
                c = "Yard Brief"
                changed = True
            elif c in ("The Rumor Mill", "Rumor Mill", "Rumour Mill"):
                c = "The Rumour Mill"
                changed = True
            elif c == "Speedeet and Wilar":
                c = "Speedeet & Wilar"
                changed = True
            new_cats.append(c)
        # Dedupe while preserving order
        seen = set()
        dedup = []
        for c in new_cats:
            if c not in seen:
                seen.add(c)
                dedup.append(c)
        return 'categories: [' + ', '.join(f'"{c}"' for c in dedup) + ']'
    
    new_fm = re.sub(r'categories:\s*\[(.*?)\]', replace_cats, fm, flags=re.DOTALL)
    return new_fm, changed

def add_schema_fields(fm, country, tone, product_family):
    """Add tone/status/country/product_family fields if missing. Never overwrite."""
    to_add = []
    if not has_field(fm, "tone"):
        to_add.append(f'tone: "{tone}"')
    if not has_field(fm, "status"):
        to_add.append('status: "published"')
    if country and not has_field(fm, "country"):
        to_add.append(f'country: "{country}"')
    if not has_field(fm, "product_family"):
        to_add.append(f'product_family: "{product_family}"')
    
    if not to_add:
        return fm, False
    
    # Append to end of frontmatter
    new_fm = fm.rstrip() + "\n" + "\n".join(to_add)
    return new_fm, True

# Run
stats = {
    "total": 0,
    "mojibake_fixed": 0,
    "category_migrated": 0,
    "schema_added": 0,
    "no_frontmatter": 0,
    "errors": 0,
}

for fname in sorted(os.listdir(POSTS_DIR)):
    if not fname.endswith(".md"):
        continue
    fpath = os.path.join(POSTS_DIR, fname)
    stats["total"] += 1
    
    try:
        with open(fpath, "r", encoding="utf-8-sig") as f:
            raw = f.read()
    except Exception as e:
        print(f"  ERROR reading {fname}: {e}")
        stats["errors"] += 1
        continue
    
    original = raw
    
    # 1. Fix mojibake in whole file
    fixed = fix_mojibake(raw)
    if fixed != raw:
        stats["mojibake_fixed"] += 1
        raw = fixed
    
    # 2. Parse frontmatter
    fm, body = parse_frontmatter(raw)
    if fm is None:
        # Try to synthesize frontmatter from filename + first H1
        # Only do this for files that clearly need it (no existing metadata)
        country, tone, product_family = classify([], filename=fname)
        if tone is None:
            stats["no_frontmatter"] += 1
            stats["unclassified"] = stats.get("unclassified", 0) + 1
            print(f"  NO FRONTMATTER + UNCLASSIFIED: {fname}")
            continue
        
        # Derive title from filename or first H1 in body
        title = None
        h1_match = re.search(r'^#\s+(.+)$', raw, re.MULTILINE)
        if h1_match:
            title = h1_match.group(1).strip()
        if not title:
            # fallback: derive from filename
            title = fname.replace(".md", "").replace("-", " ").title()
        
        # Derive date from filename if possible (YYYY-MM-DD pattern)
        date_match = re.search(r'(\d{4}-\d{2}-\d{2})', fname)
        post_date = date_match.group(1) if date_match else "2026-01-01"
        
        # Choose a category based on product_family classification
        if product_family == "series":
            # Guess series category from filename
            if "youtube" in fname.lower():
                category = "YouTube Scripts"
            elif "speedeet" in fname.lower() or "wilar" in fname.lower():
                category = "Speedeet & Wilar"
            elif "de-boys" in fname.lower() or "boys-seh" in fname.lower():
                category = "De Boys Seh"
            elif "caribbean" in fname.lower():
                category = "Caribbean Brief"
            else:
                category = "Daily Brief"
        elif "ramesh" in fname.lower():
            category = "Uncle Ramesh"
        elif "caribbean" in fname.lower():
            category = "Caribbean Brief"
        else:
            category = "Daily Brief"
        
        # Synthesize minimal frontmatter
        safe_title = title.replace('"', "'")
        generated_fm_parts = [
            f'title: "{safe_title}"',
            f'date: {post_date}',
            f'categories: ["{category}"]',
            f'tone: "{tone}"',
            'status: "published"',
            f'product_family: "{product_family}"',
        ]
        if country:
            generated_fm_parts.append(f'country: "{country}"')
        
        generated_fm = "\n".join(generated_fm_parts)
        new_raw = "---\n" + generated_fm + "\n---\n" + raw  # whole original becomes body
        with open(fpath, "w", encoding="utf-8") as f:
            f.write(new_raw)
        stats["no_frontmatter_patched"] = stats.get("no_frontmatter_patched", 0) + 1
        print(f"  FRONTMATTER GENERATED: {fname} -> {category}")
        continue
    
    # 3. Migrate categories
    fm, migrated = migrate_category(fm)
    if migrated:
        stats["category_migrated"] += 1
    
    # 4. Get classification (filename used as fallback for no-category posts)
    cats = get_categories(fm)
    country, tone, product_family = classify(cats, filename=fname)
    
    # If unclassifiable, skip schema write but log + still persist mojibake/category fixes
    if tone is None:
        stats["unclassified"] = stats.get("unclassified", 0) + 1
        print(f"  UNCLASSIFIED: {fname} (cats={cats})")
        # Reassemble with whatever mojibake/category fixes we did
        new_raw = "---\n" + fm + "\n---\n" + body
        if new_raw != original:
            with open(fpath, "w", encoding="utf-8") as f:
                f.write(new_raw)
        continue
    
    # 5. Add schema fields
    fm, added = add_schema_fields(fm, country, tone, product_family)
    if added:
        stats["schema_added"] += 1
    
    # 6. Reassemble
    new_raw = "---\n" + fm + "\n---\n" + body
    
    if new_raw != original:
        with open(fpath, "w", encoding="utf-8") as f:
            f.write(new_raw)

print()
print("=" * 50)
print("RETROFIT COMPLETE")
print("=" * 50)
for k, v in stats.items():
    print(f"  {k:25s}: {v}")
