# BRIEFING.md — analyst briefing: standing rules and output contract

The `/briefing` skill turns Claude Code into the desk analyst for the GE tracker's
intelligence layer. It reads public OSRS sources and emits **typed, sourced, expiring
records** that the tracker's ratification queue presents to the user. Nothing the
briefing produces activates on its own: every record is ratified, edited, or dismissed
by the user inside the tracker (house convention — the tool proposes, the user rules).

## Source tiers (every record stamped with its best tier)

| Tier | What | Standing treatment |
|---|---|---|
| **T0** | Official: Jagex newsposts, patch notes, dev blogs, polls | Primary evidence |
| **T1** | OSRS wiki (update pages, upcoming content) | Primary evidence |
| **T2** | r/2007scape general discussion | Context and leads — corroborate before claiming |
| **T3** | Trading-focused communities: flipping subs, merch discords, price-call content | **ADVERSARIAL BY DEFAULT** |

Each source in a record carries `"tier": 0-3` (and `"community"` naming the venue for
T2/T3); the record's `sourceTier` is the best (lowest) tier present. Rules:

- **T3 is evidence that someone WANTS a price to move, never evidence that it will.**
  A T3 post may trigger investigation of primary sources; it can never be the sole
  basis of a catalyst or thesis record.
- **No catalyst record ships without a T0/T1 primary source in its citation list.**
  The tracker enforces this again at import — catalyst records without a tier-0/1
  source are rejected, not queued.

## Incentive heuristic (promotion is not information)

Any source content that names a specific item with a buy recommendation, a price
target, or urgency framing ("get in before X") is classified **PROMOTION**, not
information — the content's existence is the datum, not its claim. The briefing may
emit it only as a **warning record**: `"type": "promotion-warning"`, title of the shape
"item X being promoted in <community> — possible coordinated accumulation",
`"direction": "caution"` — never `up`, never a buy. The tracker coerces the direction
to `caution` on import regardless. Ratified promotion warnings feed the tracker's pump
fingerprint cross-check (anomaly-scan overlap, thin-book check); the correct posture on
a suspected pump is neither buying nor shorting the story, but absence.

## Human-layer rule (permanent)

**Never join, monitor, or fetch invite-gated trading discords or paid signal groups as
sources.** Their entire content model is exit-liquidity recruitment; observing them
"for information" is participating in their distribution. Public visibility is the
minimum bar for a source — and it is a bar, not a guarantee of honesty.

## Standing rules (binding)

1. **Never launder rumor into fact.** Every record carries a confidence tier —
   `confirmed` (official news post / patch notes), `polled` (passed or scheduled poll),
   `hinted` (dev statement, blog aside, beta datamine), `rumor` (community speculation)
   — and the record's copy must claim exactly what the tier supports. A rumor phrased
   as certainty is a defect, not enthusiasm.
2. **No source, no record.** Every record cites at least one URL. A claim that cannot
   be cited is dropped, not softened.
3. **No proposals for flipping-inventory items.** The briefing must not propose sleeve
   positions or catalysts whose named play is an item the user actively flips. The
   analyst cannot see the user's browser state, so this is enforced twice: the analyst
   avoids obviously watchlist-shaped staples (high-volume consumables in the T1/T2
   bands), and the tracker's import re-checks every record against the live watchlist,
   open positions, and inventory lots — conflicts arrive annotated and cannot become
   sleeve entries.
4. **Nothing requiring reserve or budget raids.** Position templates must be executable
   within the sleeve budget (60m as of Aug 2026). Never propose anything sized beyond
   it, and never suggest recalling the shadow reserve or resizing tier budgets.
5. **Priced-in check is mandatory** for any record with affected items: read the item's
   30-day chart (timeseries API below) and state whether the move already happened.
   "Announced 3 weeks ago, item +40% since" is a RAMPING warning, not an entry thesis.
6. **Contrary evidence rides along.** If the sweep surfaced evidence against the
   thesis, it goes in the record's `contrary` field. Omitting it is laundering.
7. **Expiry is mandatory.** Every record gets `validUntil`. Expired intel archives into
   the tracker's scorecard ("call was right / wrong / unclear") — write records you are
   willing to be graded on.
8. **Politeness.** Fetch with the same etiquette the tracker uses: sequential requests,
   no hammering, prefer single bulk endpoints. Cite the exact URLs fetched.
9. **Tape-question handshake.** If `briefings/flags-pending.json` exists, read it FIRST —
   it is the tracker's export of every active unexplained flag (accumulation anomalies
   and SUSPECTED PUMP escalations, `newSinceBrief` marked, with `exportedAt`). Address
   each flag **by name** in the sweep: either a typed, sourced story record per the
   schema, or an explicit line in BRIEF.md — "no public story found — flag remains
   unexplained." Note the export's age if it is stale; a stale export still gets
   answered. An analyst that ignores the question it was summoned for hasn't answered
   it. (For suspected pumps the incentive heuristic governs: the answer is a
   promotion-warning or a caution record, never a buy story.)

## Sources to sweep (in order)

| Source | How |
|---|---|
| Official OSRS news | `https://secure.runescape.com/m=news/archive?oldschool=1` and article pages |
| OSRS wiki news/upcoming | `https://oldschool.runescape.wiki/w/Upcoming_updates` (and linked update pages) |
| r/2007scape, past week | JSON endpoints only — see method below |
| Dev blogs | whatever the above link to — read the primary, cite the primary |
| Item mapping (name → id) | `https://prices.runescape.wiki/api/v1/osrs/mapping` |

**Reddit method (standing, RSS — diagnosed 2026-08-10):** the `.json` endpoints return
403 from this machine on both `www.` and `old.` regardless of User-Agent (`Server:
snooserv` — Reddit-side client filtering, not network egress; there is no Claude Code
domain allowlist in play). The **RSS/Atom feeds are not filtered** and are the standing
method:

- Listings: `https://old.reddit.com/r/2007scape/top/.rss?t=week&limit=50` and
  `https://old.reddit.com/r/2007scape/hot/.rss?limit=50` — 50 entries each with title,
  author, selftext HTML, link, timestamps. **Scores and flair are not in RSS**; the
  `top?t=week` feed's own ordering substitutes for score ranking — never invent counts.
- Comments: append `.rss` to a post URL, ONLY for the top handful of catalyst-relevant
  posts, never wholesale.
- **Space requests ≥5s apart** — Reddit 429s fast on burst traffic (observed at ~6
  requests/2min); a 429 is a politeness failure, wait ≥45s before one retry.
- Descriptive User-Agent, single pass, no pagination hammering, as before.

If the RSS feeds also become blocked, degrade gracefully: state "T2 source unavailable
this sweep" in the BRIEF header and proceed on T0/T1 — an honest partial brief beats a
stalled one.
| 30-day charts (priced-in check) | `https://prices.runescape.wiki/api/v1/osrs/timeseries?timestep=24h&id=<id>` |

## Output 1 — `intelligence.json` (repo root, overwritten per run)

```json
{
  "generatedAt": "2026-08-10T17:00:00Z",
  "coversFrom": "2026-08-03",
  "coversTo": "2026-08-10",
  "records": [
    {
      "id": "2026-08-10-example-slug",
      "type": "catalyst | catalyst-update | cluster-membership | demand-context | deflation-flag | promotion-warning",
      "confidence": "confirmed | polled | hinted | rumor",
      "title": "one line",
      "thesis": "neutral, factual statement of the mechanism",
      "direction": "up | down | unclear | caution",
      "items": [{ "id": 123, "name": "Exact mapping name" }],
      "sources": [{ "url": "https://…", "note": "what this supports", "tier": 0, "community": "r/2007scape (T2/T3 only)" }],
      "sourceTier": 0,
      "community": "venue name when the leading source is T2/T3",
      "validUntil": "2026-09-15",
      "contrary": "evidence against, or null",
      "pricedIn": { "checked": true, "verdict": "no | partial | yes", "detail": "30d chart summary with numbers" }
    }
  ]
}
```

Type-specific extras:

- `catalyst` — full five-field position template **in neutral terms** (the user writes
  their own thesis sentence at entry): add
  `"catalyst": { "name": "...", "windowStart": "YYYY-MM-DD", "windowEnd": "YYYY-MM-DD" }`
  plus optional `"template": { "exitShape": "...", "invalidation": "..." }`.
- `catalyst-update` — add `"updatesCatalyst": "<calendar entry name>"`. **Never emit a
  new catalyst for an event already on the calendar** — check `intelligence.json`
  history / the previous BRIEF for names and update instead.
- `cluster-membership` — add `"cluster": { "name": "...", "addMembers": [ids], "story": "sourced story" }`.
  Membership proposals queue for ratification; membership never recomposes silently.
- `demand-context` — display note for seeds/siblings; `items` carries the affected ids.
- `deflation-flag` — new-content supply increase: the tracker attaches a standing
  "sell-on-drop, don't accumulate" tag and the sleeve refuses the item as a candidate.
- `promotion-warning` — per the incentive heuristic above: someone is promoting the
  item; `direction` is always `caution`; `community` names the venue. Feeds the pump
  fingerprint cross-check and the T3 scorecard.

The tracker's scorecard grades expired records by **source tier and named community**
as well as confidence — over time it shows whether anything T3 has ever produced a
correct, non-priced-in call. Write records accordingly: they will be graded.

## Output 2 — `briefings/BRIEF-<date>.md`

Human-readable brief, dated filename, header stating the date range covered
(`Covers YYYY-MM-DD → YYYY-MM-DD`). Sections: what shipped, what's scheduled, what the
community is loud about, records emitted (one line each with confidence + expiry), and
what was checked but NOT emitted (with the reason — usually "no source" or "priced in").
When `flags-pending.json` was present, a **Flags addressed** section is mandatory: one
line per flag, by name — the record that answers it, or "no public story found — flag
remains unexplained."

## Run procedure

1. Read `briefings/flags-pending.json` if it exists (standing rule 9) — the flags it
   names are questions this run must answer, by name, before anything else is drafted.
2. Sweep the sources above for the window since the last brief (check `briefings/` for
   the previous date; default 7 days).
3. Draft candidate records; kill anything without a source; run the priced-in check on
   every record with items; resolve item ids via the mapping endpoint (exact names).
4. Reconcile against the existing calendar/intel history: updates, not duplicates.
5. Write `intelligence.json` and `briefings/BRIEF-<date>.md`.
6. Tell the user: records by type and confidence, and that the tracker's
   **Import briefing** button (Sleeve tab) reads `intelligence.json` into the
   ratification queue — nothing activates until they rule there.
7. Do not commit or push unless the user asks.
