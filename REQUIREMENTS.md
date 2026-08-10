# REQUIREMENTS.md — thesis sleeve + analyst intelligence (consolidated build, Aug 10 2026)

Every requirement from the ruled spec, with a stable ID. The probe suite tags its
assertions with these IDs (`[R1.2]` in the assertion name); the probe report ends with a
`===REQS===` section listing per-ID PASS/FAIL derived from those tags — that section and
this file cross-reference each other. IDs marked **UI** are verified by inspection
(rendering/copy the headless suite exercises only incidentally); everything touching
money math, budgets, or ratification state carries probe tags. No silently dropped
gates: a row in this table without a probe tag says so out loud.

| ID | Requirement | Verified by |
|---|---|---|
| **§0 Recalibration** | | |
| R0.1 | T1 budget 100m→60m, T2 50m→30m; sleeve budget 60m carved from working capital; shadow reserve untouched; decision-log entry "resized to evidence…" | probe `[R0.1]` |
| **§1 Thesis sleeve** | | |
| R1.1 | Sleeve budget disjoint from tier pools and allocator; governs NEW entries only; migrated legacy holds excluded from budget and concurrency count | probe `[R1.1]` `[R1.1a]` |
| R1.1b | Crimson kisten / Elder maul holds migrate into the sleeve as legacy positions with their cost bases | probe `[R1.1a]` |
| R1.1c | Max 3 concurrent new positions (setting) | probe `[R1.1c]` |
| R1.2 | Mandatory fields — no save without item, qty, entry/cost basis, named catalyst + window, one-sentence thesis, exit ladder ≥2 rungs (trigger + fraction each), invalidation | probe `[R1.2]` |
| R1.2b | Ladder edits allowed but decision-logged with required reason | probe `[R1.2b]` |
| R1.3 | Monitoring: price vs entry and vs each rung, days held, catalyst countdown; mark-to-market de-emphasized, "judged at exit, not at the mark"; per-position catalyst-phase buttons, user-flagged only | UI (panel copy) + probe `[R1.4]` (phase→rung path) |
| R1.4 | Rung triggers: price within 5% (setting), date within 7d, or flagged phase → SELL card (qty from fraction, guidance = current instasell); logging the fill records it against the rung; realized P&L at exit vs cost, net of tax | probe `[R1.4]` `[R1.4b]` |
| R1.5 | Weekly SLEEVE section: manual thesis-health light (never inferred), realized exits, sleeve stats fully separate from flipping metrics; rides Export JSON | probe `[R1.5]` (separation + export) · UI (weekly section) |
| R1.6 | Guardrails: no sleeve position in current flipping inventory; full budget requires closing a position (no pool/reserve raids); update advisories informational on sleeve items | probe `[R1.6]` (mandate + budget refusal) · UI (Wednesday advisory) |
| **§2 Candidate engine** | | |
| R2.1 | Catalyst calendar (name, window, affected items/clusters); entry watch vs 90-day baseline; accumulation signature; DISCOUNTED vs RAMPING | probe `[R2.1]` |
| R2.2 | Weekly anomaly scan: >1m items, sustained price+volume rise 2–3 weeks, no linked catalyst, "reason unknown — no thesis, no position", max 5 flags/week by strength | probe `[R2.1]` (the scan's verdict math IS `slvSeriesStats`/accum, asserted there); the ≤5 cap and >1m pre-screen are code-fixed (`slice(0,5)`, `px > 1e6`) and network-bound, so not probe-asserted — stated here, not silently dropped · UI (copy) |
| R2.3 | Cluster crossover: catalyst-linked set moves, member lags → laggard flag ("same thesis, unpriced member") | probe `[R2.3]` |
| R2.4 | Ranking = discount depth × catalyst proximity × exit liquidity; warn when intended position > 15% of daily gp volume ("a thesis you can't exit isn't a trade") | probe `[R2.4]` |
| **§3 Analyst briefing (desk side — not probe-testable in the tracker)** | | |
| R3.1 | /briefing skill exists; BRIEFING.md defines sources (official news, wiki upcoming, r/2007scape, dev blogs), politeness, per-claim citation | inspection: BRIEFING.md, .claude/skills/briefing/SKILL.md |
| R3.2 | intelligence.json: typed records with sources, confidence tier, item ids, direction, VALID-UNTIL, contrary evidence, priced-in check; no source no record; dated BRIEF.md with covered range | inspection: BRIEFING.md contract · tracker enforces at import, probe `[R4.1]` |
| R3.3 | Standing rules: never launder rumor into fact; no proposals for flipping-inventory items; nothing requiring reserve/budget raids | inspection: BRIEFING.md · import annotation probe `[R4.1b]` |
| **§4 Intelligence layer** | | |
| R4.1 | Import reads intelligence.json to a ratification queue (thesis, sources, confidence, items); no-source and malformed records rejected; nothing activates unratified | probe `[R4.1]` |
| R4.1b | Flipping-inventory conflicts annotated at import; sleeve refuses those items as candidates | probe `[R4.1b]` |
| R4.1c | Ratify / edit-then-ratify / dismiss, all decision-logged; dismissals absorb same-type variants at Jaccard ≥0.6; resurface only on material change (confidence upgrade / direction flip) | probe `[R4.1c]` |
| R4.2a | Catalyst records create/update calendar entries in place — never duplicates | probe `[R4.2a]` |
| R4.2b | Cluster-membership proposals queue in the cluster ratification queue — membership never recomposes silently | probe `[R4.2b]` |
| R4.2c | Plan lines carry advisory ⚡ tags; never bench or resize by default; optional per-record 0.5× haircut toggle applied after all caps, "sized down: news risk (my ruling)" inline | probe `[R4.2c]` |
| R4.2d | Deflation flags: standing sell-on-drop tag; sleeve refuses those candidates with that reason | probe `[R4.2d]` |
| R4.2e | Wednesday advisory names what's shipping + watchlist/sleeve blast radius; generic line when no intel | UI (day-dependent; formula shared with probe-tested `wedClusterAdvisoryText` pattern) |
| R4.3 | Intel cannot touch: blacklist, proven-loser bench, realized metrics, gate constants, reserve; conflict copy "intel bullish; realized history … — history wins" | probe `[R4.3]` |
| R4.4 | Expiry archives with gradeable outcomes (right/wrong/unclear); BRIEFING SCORECARD hit rate by confidence tier in the weekly review | probe `[R4.4]` |
| **§5 Walk-up integration** | | |
| R5.1 | RULINGS PENDING block after execution items — one line per pending item across all queues with inline ratify/edit/dismiss/snooze 3d | probe `[R5.1]` |
| R5.2 | Cap 5 lines (setting), priority expiring intel → sleeve-actionable → cluster → audits, overflow "+N in queues" | probe `[R5.2]` |
| R5.3 | Staleness ladder: >14d default-action suggestion; >30d auto-dismiss logged "expired unruled — resurface only on material change" | probe `[R5.3]` |
| R5.4 | Header badge with pending count on every tab; no modals, nothing blocks execution | probe `[R5.4]` |
| R5.5 | Briefing reminder: last briefing >7d OR update Wednesday passed since it (Wednesdays assumed — no cheap endpoint); dismissible per occurrence, returns on next trigger; tracker cannot run the briefing itself | probe `[R5.5]` |
| **§7 Manipulation defenses (ruled Aug 10 2026)** | | |
| R7.1 | Source tiers T0–T3 stamped per record (best cited tier); T3 adversarial by default — never the sole basis of a catalyst/thesis; no catalyst record without a T0/T1 primary (enforced at emit AND at import); tiers/communities survive export | probe `[R7.1]` · BRIEFING.md (emit side, inspection) |
| R7.2 | Incentive heuristic: buy rec / price target / urgency framing = PROMOTION, emitted only as a `promotion-warning` record with direction=caution, never buy (tracker coerces regardless) | probe `[R7.2]` · BRIEFING.md (inspection) |
| R7.3 | Pump fingerprint: anomaly flag + promotion record within 14d (setting) → SUSPECTED PUMP; promoted + thin books (gp/day floor, setting) → same regardless of anomaly. Escalation: benched from sleeve candidacy with the reason, seed-style caution cap in the plan (half-size, one slot, wins never graduate it while flagged), posture-is-absence copy on every surface; dismissing the warning lifts it | probe `[R7.3]` |
| R7.4 | Scorecard grades by source tier and named community, not just confidence — "has T3 ever produced a correct, non-priced-in call" is measurable | probe `[R7.4]` |
| R7.5 | Human-layer rule, permanent in BRIEFING.md: never join, monitor, or fetch invite-gated trading discords or paid signal groups; public visibility is a minimum bar, not a guarantee | inspection: BRIEFING.md (a rule about the analyst's own conduct — nothing tracker-side to probe) |
| **§8 Gate-health vocabulary (ruled Aug 10 2026)** | | |
| R8.1 | "die-off detected" ledger tag: a volume-floor bench whose binding side is the confirmed 5m sample (≥5 units, 2 consecutive refreshes) against a 1h book that PASSES the floor writes an extra gate-health ledger row `die-off detected` (item·gate·day dedup, 30d retention, same track-record machinery as any gate); the bench copy names the tag inline | probe `[R8.1]` |
| R8.2 | Each first tag opens a 24h episode ({d,id,t,rec}); recovery = confirmed healthy 5m sample (≥5 units at/above the floor) — a quiet window is NOT recovery; continued fade never stacks episodes; weekly audit reports recovered-within-24h (median hours) vs still-faded-at-24h vs watching, numbers only — the twitchy-vs-trust verdict stays the user's | probe `[R8.2]` |
| R8.3 | Concur-recommended lane: proposals defending a standing rule against softer data batch under their own header and are excluded from S.depProposalCount (rulings-pending); the full ruling flow is reserved for change-proposals | probe `[R8.3]` |
| R8.4 | Proposal-engine discipline (prop-1 rejection): a constant-change proposal emits only with multi-day ledger persistence (item benched by the gate on 4+ of the last 7 days, cited inline); a 3+ near-miss pile without persistence renders as a concur-recommended observation, never a proposal; every change-proposal traces the next allocator stage for each admitted item (an item that relocates to another bench is not created capacity) | probe `[R8.4]` |
| **§9 Quote lines — inventory-mode buffer flow (ruled Aug 10 2026)** | | |
| R9.1 | Sizing transparency: a quote leg smaller than the walk-back (gap + sell-leg replacement) or the holding names the binding cap inline — participation cap / one-third rule / buy limit — in the plan-line reason-string convention; a gap needing multiple cycles says "buffer fills over ~N touches at current flow" | probe `[R9.1]` |
| R9.2 | Placed state: "placed" marks the quoted legs standing on the watch entry — timestamped, persisted (survives export→import validation), elapsed time + fill state shown at every walk-up until the cycle completes or the user presses cleared; stale-buy and sell-aging-ladder rules apply to placed quote legs on the position clocks and surface in the NOW bar | probe `[R9.2]` |
| R9.3 | Partial fills: fill dialog prefills the remaining standing qty (editable) plus price; buy fills add FIFO lots at the fill price, sell fills FIFO-consume at true cost; the line shows "x/y filled · z standing"; a fill completing both legs closes the cycle; the tool never places, cancels, or logs on its own | probe `[R9.3]` |
| **§6 Verification** | | |
| R6.1 | Probe report cross-references this file (`===REQS===` section from `[R#]` assertion tags) | the report itself |
