# Handoff Document — Tradewinds Brief Session

**Date**: 2026-04-27
**Purpose**: Drop into next Claude instance to continue work without context loss

---

## Active project

**Tradewinds Brief** (tradewindsbrief.com) — Hugo satirical news site, Caribbean + Africa coverage. Continuation of P0/P1 homepage cleanup work.

## Critical environment (LOCKED — do not change)

- **Repo**: `C:\Users\Staff\guyana-news-blog-RESTORED`
- **GitHub**: `caribstar/guyana-news-blog` (NOT `guyana-news-blog`)
- **Hugo**: v0.142.0-extended on Windows (do NOT upgrade — `.Site.Social` deprecation is known non-fatal)
- **Site**: tradewindsbrief.com (not GDB — that's the old name; transition in progress)
- **PowerShell scripts**: always paste in chat, never deliver as files
- **public/** is tracked in git → CRLF warnings on every deploy are NOISE, not errors. Push always succeeds.

## Pen names (LOCKED — Memory #30 reflects this)

- **Tradewinds Brief published byline**: "Christopher Matthias" (public-facing only)
- **Albert Massay**: real/legal name, backend/Cloudflare/WHOIS only
- **NEVER** use "Ajay Messiah", "Ajay Massay", or "Albert Massay" as published Tradewinds byline

## Status of current work

### Just completed this session ✅

1. **P0-3 Byline consolidation** verified live (commit `d78413f2d`) — TWB Editorial alias rendering correctly
2. **Pen name swap** Ajay Messiah → Christopher Matthias on 7 posts (commit `5fb3de310`)
3. **P1-4 Part A: Homepage deprioritization of "Man Says X" formula posts** — DEPLOYED in two commits:
   - `fa1debaa4` — added `homepage_hide: true` to 37 post front-matters
   - `39c85936a` — patched `layouts\index.html` `$all` definition to filter on `homepage_hide`

### Pending verification (BLOCKING next step)

User needs to hard-refresh tradewindsbrief.com (Ctrl+F5) and confirm "Man Says/Reaches/Explains/Orders..." headlines no longer appear on homepage hero, Latest, Africa cards, or Caribbean cards. Direct URLs and tag pages should still show them.

- **If verified clean** → proceed to Part B below.
- **If leaking** → patch wherever leaking; the 37 posts have `homepage_hide: true` flag set, so any feed still showing them is using a different `$all`-equivalent that needs the same filter wrapped around it.

### Next: P1-4 Part B (NOT STARTED)

**Style guide lockdown for going-forward enforcement.** Two pieces:

**1. Memory edit** — add a memory entry locking the headline rule:

> Tradewinds Brief headline rule (LOCKED): Every headline must have (a) a specific subject — who/where, and (b) a concrete situation OR a punchline outcome. NEVER open a headline with "Man Says/Reaches/Explains/Orders/Negotiates/etc." Mix formulas — let writer choose, just ban the "Man Says" opener.

**2. STYLE-HEADLINES.md reference file** — drop in repo root or `/docs/`. Should contain:

- The rule above
- Banned openers list: "Man Says", "Man Reaches", "Man Explains", "Man Orders", "Man Negotiates", "Man Returns", "Man Stuck", "Man Claims", "Man Brings", "Man Stands", "Man Calculates"
- 5-10 good headline examples (specific subject + concrete situation/punchline)
- 5-10 bad headline examples for contrast
- Note that `homepage_hide: true` is the deprecation primitive for any future bulk soft-removals

Deliver via single PowerShell paste-in-chat: create file → git add → commit → push.

## Locked fix list (post Part B)

- **P1-5**: Image-first card grid leveraging country-pool images
- **P1-6**: Brand lane separation (🟥 SATIRE / 🟦 COMMENTARY / 🟨 FEATURES / 🟩 KIDS color/badge system)
- **P2-7**: Content cadence
- **P2-8**: Africa cadence tightening
- **P2-9**: Stickiness ("Most Read This Week" easiest)
- **P3-10**: Empty/thin footer pages audit
- **P3-11**: Monetization readiness
- **P3-12**: `.gitignore public/` cleanup (will silence CRLF noise)

## Hard rules going into next session

- **Workflow Canon**: every sprint = write → save .md to `/mnt/user-data/outputs` → `present_files` → next sprint. Never work >5 min without delivering a file. No plans/summaries — write and deliver.
- Never deliver PowerShell as a file. Always paste in chat.
- For folder paths with parens: use `$src = "C:\path (N)"` then `Copy-Item "$src\file.md" $dst -Force`
- **IO Fix** when `/mnt/user-data/outputs` gives I/O error: `fd=os.open(dst,os.O_WRONLY|os.O_CREAT|os.O_TRUNC,0o644); os.write(fd,open(src,'rb').read()); os.close(fd)` — `cp`/`shutil`/`tee` all fail.
- **Safety protocol**: target policies/situations only; named individuals only if already named across multiple national news agencies on same story. Apply proactively as first filter.
- **Privacy**: never expose user's home address, family, or daughter's name.

## First message to new instance

Paste this handoff doc, then say something like:

> "Continuation from previous session. Did you verify the homepage cleanup? If yes, run Part B. If no, here's what I'm seeing: [details]."

## Recent transcripts (chronological)

- `/mnt/transcripts/2026-04-26-19-24-00-tradewinds-todays-clash-p01.txt`
- `/mnt/transcripts/2026-04-26-19-51-02-tradewinds-todays-clash-p02.txt`
- `/mnt/transcripts/2026-04-26-20-42-07-tradewinds-dedup-p03.txt`
- `/mnt/transcripts/2026-04-27-00-00-50-tradewinds-homepage-fixes-p04.txt`
- `/mnt/transcripts/2026-04-27-00-17-05-tradewinds-homepage-fixes-p05.txt` (this session)
