import frontmatter
from pathlib import Path

root = Path("content/posts")

parody_column_authors = {
    "Uncle Ramesh",
    "Ramesh",
}

satire_authors = {
    "Auntie Cheryl",
    "Back-a-Truck",
    "Bajan Bugle",
    "Bam-Bam Sally",
    "Bounty Board",
    "Cape Chronicles",
    "Cousin Leroy",
    "De Boys",
    "De Comedy Crew",
    "DJ Roadblock",
    "Finance Ferrari",
    "Miss Violet",
    "Naija Lookbook",
    "Patriots Portfolio",
    "Speedeet & Wilar",
    "Speedeet and Wilar",
    "The Accra Almanac",
    "The Bajan Bugle",
    "The Nairobi Dispatch",
    "The Trini Dispatch",
    "The Yard Report",
    "Trini Dispatch",
    "Yard Report",
}

news_authors = {
    "Ajay Messiah",
    "Andre Clarke",
    "Andre Wallace",
    "Caribbean Brief",
    "Caribbean Daily Brief",
    "Daily Brief",
    "Editorial Team",
    "GDB Desk",
    "GDB Regional Desk",
    "GDB Staff",
    "Georgetown Ledger",
    "Progress Report",
    "The Daily Brief",
    "The Guyana Daily Brief",
}

analysis_categories = {"Magazine", "Analysis"}
news_categories = {"Daily Brief", "Caribbean Brief", "Africa Brief", "Guyana Brief"}

updated = 0
skipped = 0

for file in sorted(root.glob("*.md")):
    try:
        post = frontmatter.load(file)
    except Exception as e:
        print(f"SKIP {file.name}: {e}")
        skipped += 1
        continue

    if "content_type" in post:
        skipped += 1
        continue

    author = post.get("author")
    authors = post.get("authors", [])
    categories = set(post.get("categories", []))
    tone = post.get("tone")

    ctype = None

    all_authors = []
    if author:
        all_authors.append(author)
    if isinstance(authors, list):
        all_authors.extend(authors)

    for a in all_authors:
        if a in parody_column_authors:
            ctype = "parody_column"
            break

    if ctype is None:
        for a in all_authors:
            if a in satire_authors:
                ctype = "satire"
                break

    if ctype is None:
        for a in all_authors:
            if a in news_authors:
                ctype = "news"
                break

    if ctype is None and categories & analysis_categories:
        ctype = "analysis"

    if ctype is None and categories & news_categories:
        ctype = "news"

    if ctype is None:
        if tone == "satire":
            ctype = "satire"
        elif tone == "commentary":
            ctype = "commentary"
        else:
            ctype = "news"

    post["content_type"] = ctype

    if ctype in {"satire", "parody_column"}:
        post["fictional_character"] = True

    output = frontmatter.dumps(post)

    with open(file, "w", encoding="utf-8", newline="\n") as f:
        f.write(output)

    updated += 1

print(f"Updated {updated} posts")
print(f"Skipped {skipped} posts")
