# Tradewinds Brief — Headline Style Guide

**Status**: LOCKED canon. Apply to every new post going forward.
**Last updated**: 2026-04-27

---

## The Rule

Every headline must have **both**:

1. **A specific subject** — who and/or where (named person if public-record, named place, named institution, named character)
2. **A concrete situation OR a punchline outcome** — something happened, something is happening, or the joke lands in the headline itself

Headlines that pass either of these tests work. Headlines that fail both don't.

---

## Banned Openers

Do **not** open a headline with any of the following:

- Man Says
- Man Reaches
- Man Explains
- Man Orders
- Man Negotiates
- Man Returns
- Man Stuck
- Man Claims
- Man Brings
- Man Stands
- Man Calculates

The pattern is the problem: generic-subject ("Man") + speech-act verb ("Says/Explains/Claims") = no specificity, no punchline, just the shape of news without any news in it. These are placeholder headlines that drifted into being final headlines.

The ban applies to "Woman [verb]" and "Local [verb]" constructions on the same logic. Mix formulas. Let the writer choose. Just don't open with this one.

---

## Good Examples (specific subject + concrete situation/punchline)

1. *Sluice Gate at Pln. Better Hope Stuck Open Since Tuesday, Ministry Calls It "Working as Designed"*
2. *Auntie Cheryl Confirms Chaguanas Has Always Been the Capital, Awaits PM Apology*
3. *Cousin Leroy Discovers Kingston Has Hills, Demands Investigation*
4. *Accra Almanac: Power Cut Schedule Now Includes a Schedule for the Schedule*
5. *Bam-Bam Sally Wins Saturday's Domino Tournament by Forfeit, Three Other Tables Filed Police Reports*
6. *DJ Roadblock Plays Same Soca Song Four Times, Vendor Sells Out of Mauby*
7. *Cape Chronicles: Eskom Announces Stage 6, Stage 7, and Whatever Comes After Stage 7*
8. *Bajan Bugle: Roundabout in Warrens Now on Its Fourth Configuration This Year*
9. *Naija Lookbook: Lagos Tailor Finishes Wedding Suit on Time, Family Suspects Witchcraft*
10. *Brother Winston Reads Walter Rodney at Stabroek Market, Crowd Asks If He Selling*

What works in each: a named place, a named character, or a named system — paired with a specific event, an absurd detail, or the joke itself sitting in the headline.

---

## Bad Examples (for contrast)

1. *Man Says Government Should Do Better* — no subject, no situation, no joke
2. *Man Reaches Halfway Point on Long Drive* — generic subject, non-event, no punchline
3. *Man Explains Why He Chose This Bank* — speech-act with no payload
4. *Local Resident Discusses Neighborhood Changes* — same problem in "Local" clothing
5. *Woman Orders Lunch, Receives Lunch* — joke shape without the joke
6. *Man Negotiates Price of Tomatoes* — situation present but generic; no character, no punchline
7. *Man Returns Library Book Within Reasonable Window* — every word is filler
8. *Man Brings Umbrella, Uses Umbrella* — circular, no surprise
9. *Man Stuck in Traffic for an Hour* — common event, no comic angle
10. *Man Calculates Cost of Groceries* — speech-act/cognitive verb with no result

The pattern across all of these: the headline could be the headline of any story by any author about any anonymous person on any day. That's the failure mode.

---

## Operational Note: `homepage_hide: true`

When a batch of older posts needs to be soft-removed from the homepage without deleting URLs or breaking tag pages, use the front-matter flag:

```yaml
homepage_hide: true
```

The `layouts\index.html` `$all` definition filters on this flag. Direct URLs and category/tag pages still surface the content; only the homepage hero, Latest, Africa cards, and Caribbean cards skip it.

This is the deprecation primitive for any future bulk style-cleanup pass. Don't delete posts to fix headlines — flag them and write better ones going forward.

---

## TL;DR

- Specific subject + concrete situation/punchline = ship it
- "Man [verb]..." opener = rewrite it
- Use `homepage_hide: true` for bulk soft-removal, never `git rm`
