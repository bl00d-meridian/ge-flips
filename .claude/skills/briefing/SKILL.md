---
name: briefing
description: Run the analyst briefing — sweep official OSRS news, the wiki's upcoming-content pages, r/2007scape (past week), and linked dev blogs; emit typed, sourced intelligence.json records plus a dated human-readable BRIEF.md into briefings/. Use when the user says "run the briefing" or asks for market/update intelligence for the GE tracker.
---

# /briefing — analyst briefing run

Read **BRIEFING.md at the repo root first** — it is the binding contract: standing
rules (never launder rumor into fact; no source, no record; no proposals for
flipping-inventory items; nothing requiring reserve/budget raids; mandatory priced-in
check, contrary evidence, and expiry; the tape-question handshake), the source list,
the exact `intelligence.json` record schema, and the run procedure.

Then execute its "Run procedure" section end to end:

1. Read `briefings/flags-pending.json` if it exists — the tracker's exported unexplained
   flags (anomalies, suspected pumps). Each must be addressed **by name** this run:
   a sourced record, or an explicit "no public story found — flag remains unexplained"
   line in the BRIEF's mandatory **Flags addressed** section.
2. Determine the window: date of the newest file in `briefings/` (default: last 7 days).
   **Lookback floor:** when flags are pending, extend context back to the oldest active
   flag's firstSeen **minus 14 days** and check the game-updates history across that
   whole span — a hearing whose context starts after the likely cause finds only
   silence (the Jul 22 Summer Sweep-Up miss is the named incident).
3. Sweep the sources via WebFetch/WebSearch, politely, citing every URL you rely on.
4. Draft typed records; enforce every standing rule; resolve item ids via the mapping
   endpoint; run the 30-day priced-in check per record.
5. Reconcile against the current `intelligence.json` and the catalyst names in previous
   briefs — emit `catalyst-update` records for known events, never duplicates.
6. Write `intelligence.json` (repo root) and `briefings/BRIEF-<today>.md` (header must
   state the covered date range).
7. Report to the user: counts by type and confidence tier, anything checked but not
   emitted (and why), and remind them to press **Import briefing** on the tracker's
   Sleeve tab — nothing activates until they ratify it there.

Do not commit or push unless the user asks.
