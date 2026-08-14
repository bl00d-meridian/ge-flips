# The two retirements — dormancy lane (stage report)

2026-08-14 · fourth session of the day, against the pushed baseline `8bf841e` (1e + the
landing fix + the mm bench, committed by the user after the phone look). Suite at close:
**PROBE-PASS — 1,061 assertions, both viewports (1200×900 and 390×844), pairing clean
both directions, 376 requirement ids.** Deployment: **DEPLOY-OK at 1.0s on a
phone-viewport real-network fresh-profile boot** (§5). Tree uncommitted per standing
practice. This report also carries the **sleeve-form landing fix** (§6), the same-class
site §7 of the 1e report listed.

---

## §1 What was ruled, and what was built

**The regime race and the discovery slice's sampling role retired to the dormancy
lane** — ruled at the 1e close ("unlockable at the scorer's first readable output",
which 1e was), built this session, decision-logged in the tool (`auto: 1, by: "user"`,
once per store, with at-retirement snapshots — asserted by `[R81.3]`, seeded).

- **The race** (`REGIME_RACE_RETIRED = true`, pinned): superseded by the scorer's
  16-cell config grid, on two measured grounds — the comparator was broken by
  construction (R68.6) and the `loose \ current` band is unfeedable while the margin
  gate's effective 6.52% floor stands (arithmetic between two constants; more trading
  cannot feed it). **Stops:** regime stamping on new trips, the daily divergence
  snapshot, divergence evidence and proposals (gated at `shadowRegimeEvidence`, the one
  owner). **Stays:** the historical curves, separator bands and ledger, rendered under a
  dormant banner naming the ruling, the successor and the grounds — every drill still
  opens; the freshness row reads DORMANT, never stale; the vitals tile, one-liner, WHAT
  CHANGED and export state the dormancy wherever the race used to speak.
- **The slice's sampling role** (`SLICE_SAMPLING_RETIRED = true`, pinned): superseded by
  universe coverage — the scorer scores every /mapping item each 5m bucket, so a
  rotating 15-item sample is a strict subset of standing coverage. **Stops:** the
  stratified draw and rotation, new slice paper trips and clean-find lines, new
  stratum-ledger accrual. **Stays — deliberately and by the code's own reading:** the
  **GAP BAND** in full (draw, register, verdict line, paper entries at exactly its ruled
  `floor(SLICE_SHADOW_CAP/2)` share — widening it is a strategy change needing its own
  ruling), the durable per-stratum map as a frozen historical ledger under a dormant
  banner, and every historical slice trip and cohort row.
- **The paper book itself keeps running** — it is the cutover plumb line. Scanner and
  watchlist admission stand until cutover. Nothing was deleted anywhere: dormancy lane,
  per the complexity-governance rule.

**The scope call this session made, recorded because the triage read differently:** the
fill-tier triage filed the gap-band clean-count register (probe 3500 / R53.2) as "slice
machinery". The code reading found the register is paper-book-wide contamination
plumbing with TWO consumers — the gap band's held-proposal bar AND the routing bar —
and the gap band itself serves two still-open ruled questions (the held T3 scanner
proposal; the routing question). So the gap band **stays live**, finding 3500 stays
conditional, and the triage file carries a dated EXPIRY RECORD: **6 of the 17
EXPIRE-AT-RETIREMENT findings expired today** (2481, 5574, 2575, 6127, 7300, 7317),
each with its disposition, including two whose repaired assertions turned out to
OUTLIVE the condemned machinery rather than dying with it.

## §2 The era fact, and the partition answer (schema decision, in writing)

A trip opened under the dormant race carries **NO `regimes` key**. Absent means "not
evaluated (race dormant)"; `[]` keeps meaning "evaluated, nothing computable" (R43.1);
values mean membership. Three states, never collapsed:

| layer | treatment |
|---|---|
| the writers (`shadowScan`'s `add()`, `scannerShadowScan`) | stamp only when `!REGIME_RACE_RETIRED` — the key is omitted, not emptied |
| the import carry | `hasOwnProperty` guard (R68.5's absent-is-not-null) — the old line collapsed absent to `[]` on every restore, proven by seed S6 |
| the export (`analysisTrip`) | absent exports as `null` with the distinction documented; `[]` exports as `[]` |
| the readers | historical surfaces read old trips' values; `regimeFedN` and the never-fed notes are superseded by the dormant banner, whose cause is the true one |

No re-stamping pass exists to get wrong; the two eras partition by key presence, and
`[R81.1]`'s carry assertion plus the `[R18.1]` dormant form pin both sides.

## §3 Conformance stanza (deltas against the ratified map)

- **BINDING touched:**
  - *Restraint/deployment* — the retirement arms nothing and lifts no restraint: it
    stops measurement machinery. The un-retire (which would re-arm proposal machinery)
    is the user's ruling, pinned by `[R81.1]`/`[R81.2]` — seeds S1/S2 prove a silent
    flip turns the suite red.
  - *Every automated decision states its reason inline* — the dormant banners, the
    prospect verdict, the cohort ledger's dormant rows, the freshness notes and both
    decision-log entries all name the ruling, the date, the successor and the grounds
    (`[R43.1]`-dormant, `[R29.3]`-dormant, `[R81.1–3]`, seeds S5/S13).
  - *A component reports nothing where it should report it HAS nothing* — dormant,
    never-fed, unreachable and quiet are now FOUR distinct readings on these surfaces:
    the banner supersedes the never-fed notes exactly where their own predicates are
    true (S5's fixture proves the note's predicate holds and the banner is the stated
    cause); the cohort ledger's slice rows say "dormant — historical" instead of
    promising accrual that cannot come; the freshness rows read DORMANT, not stale and
    not silent.
  - *Data nothing reads is a defect* — the divergence snapshot writer, the
    `homeSnap.div` writer and the regime stampers are gated WITH their readers, so no
    write-only stream survives the retirement; `shadowDivLog` and the non-gap
    `strataStats` become read-only historical stores with live readers (drills,
    exports, freshness), which is a reader, not an orphan.
  - *Never pool* — the frozen series stay decomposed everywhere they render; the export
    stamps the retired era (`retired`/`retiredAt`/note, seed S12) so a file reader
    cannot pool dormant with never-fed; era populations partition by key presence.
  - *Metric honesty / claims-vs-computation* — the capacity report's rotating-cohort
    term now computes the gap's share alone (S14); "the regime race keeps running"
    (R27.3), "leading regime vs baseline" (R20.3), the panel h2, both tab tooltips, the
    one-liners and the beyond-net summary were all reworded to claim the dormant truth;
    the stale "plus 5" gap-band tooltip (GAP_BAND_N has been 10 since Aug 12) was fixed
    in passing and R29.2's row annotated.
  - *Scan 13 (reachable fixtures)* — direct-call tests of machinery with no production
    caller while dormant (`regimesFor`, `paperDivLead`, `currentStratum`/
    `beyondNetSample`) are gated behind the same flags production reads, never left
    holding dead code alive; `deltaVs` stays live as the general sanctioned renderer.
- **Detectors same commit:** the flags, gates, dormant surfaces, decision logs, §81 +
  R24.4 rows, dormant-gated assertions, glossary marks, CLAUDE.md surface map,
  IMPROVEMENTS closure and the triage expiry record all ride this one tree.
- **Seeds: 15, all bit, one at a time, restore-green between each.**
  | # | seed | red (and only these) |
  |---|---|---|
  | S1 | `REGIME_RACE_RETIRED` → false | R81.1, R81.3 |
  | S2 | `SLICE_SAMPLING_RETIRED` → false | R81.2, R81.3 |
  | S3 | divergence snapshot writer un-gated | R20.5 (frozen-ledger), R37.4 (dormant) |
  | S4 | slice draw dispatcher un-gated | R25.5 (dormant), R29.5 (dormant) |
  | S5 | render's slice arm un-gated | R29.1 (dormant) |
  | S6 | race dormant banner deleted | R43.1 (dormant banner) |
  | S7 | sanitizer collapses absent → [] | R81.1 (carry) |
  | S8 | sleeve landing retargeted at the positions panel | R24.4 (both halves: target not landed, wrong panel landed) |
  | S9 | regimes re-stamped in `add()` | R18.1 (dormant) |
  | S10 | race log's `by: "user"` dropped | R81.3 |
  | S11 | evidence source's gate removed | R18.4 (dormant), R27.3 (dormant) |
  | S12 | export's `retired` stamp falsified | R43.1 (export retirement) |
  | S13 | prospecting dormant banner deleted | R29.3 (dormant) |
  | S14 | capacity term reverted to the full cap | R57.2, R81.2 |
  | S15 | vitals tile's divergence lead un-gated | R65.1 (dormant) |
  Multi-target seeds (S3, S11, S14) each seed ONE gate that two assertions watch from
  different surfaces — recorded as one owner, two intended targets, not as cascades.
  S1/S2's green remainder is itself evidence: the gated LIVE forms re-armed and passed,
  which is R81.4's re-arm claim demonstrated live.
  **Re-scoped, not new (no seed, with the reason):** the `[R11.2]`/`[R22.6]` dormant
  forms and the `[R37.4]` map fixture assert unchanged production behaviour (the gap
  rows' tags and +watch; the exclusion drill) through relocated fixtures — their
  properties were proven when first written and the production paths did not change;
  `[R33.2]`'s pattern was widened to accept either era's honest empty copy; `[R61.3]`
  became dual-era; `[R62.1]`'s fixture constructs its plan input (the R18.1 fixture
  shape) so the generator is exercised in both eras.
- **Scans at the boundary:**
  - *Scan 2 (orphan / silent-state):* enumerated above under BINDING; no store is
    write-only and no state renders unexplained. The staged-store list is untouched
    (`rdiff` still staged for the cutover gate; nothing new staged).
  - *Scan 5 (interrogability):* every historical aggregate still opens through the
    shared drill primitive — the retirement changed no drill; the exports carry their
    rows plus the era notes.
  - *Scan 7:* every reworded claim checked against its computation (the list under
    metric honesty).
  - *Scan 8:* nothing new pools; the one pooled average (the grid's, from 1e) is
    untouched.
  - *Scan 14 over the new labels:* the universals are exercised at their strongest
    available cases — "opens NO stratum counterfactuals" against a pinned, POPULATED
    stratum with gate-clearing items; "takes no daily snapshot at all" with a
    regime-stamped trip present; "never an empty set" with all three key states in one
    fixture; "exactly its ruled share" by value. One limb is ARGUED rather than
    exercised and is recorded as such: "never stale" in `[R81.1]`'s label rests on the
    freshness panel's own predicate (`stale` requires `kind === "scheduled"`, and the
    row's kind is asserted `"dormant"`) — the mechanism is asserted, its consequence is
    derivation.
  - *Scan 16:* no new chain.
- **DOCTRINE by inspection:** the dormancy lane is the complexity-governance demotion
  rule applied at feature grain (collapse/gate, never delete); zero-based budget — this
  stage removes rendered weight (the vitals tile's regime clause, the one-liner's
  evidence clause) and adds only banners on existing surfaces; the staging practice's
  fourth rule (pin the era fact) gets its fourth and fifth uses.

## §4 What did not happen, said plainly

- **The gap band did not retire** — scope call recorded in §1.
- **Nothing was deleted**: every function, store and surface stands; accrual and
  proposals are gated, historical data renders.
- **No strategy parameter moved**: the gap's per-cycle share, every gate constant and
  the cadence are untouched.
- **The rdiff store stays staged** for the cutover gate; the era-fact tripwire for
  chart wiring (`marketStatsFor().tr === null`) stays armed, untouched.
- **Nothing was committed**; committing and pushing are the user's.

## §5 The deployment artifact (M154's lesson: one real boot proves the deployment)

Real network, fresh profile, phone viewport (390×844). First poll at **1.0s**; the
state extracted after the first scan cycle, verbatim from the beacon:

- flags `{ race: true, slice: true }`; **both decision-log entries present** with
  `auto: 1, by: "user"` — written by the tool on first poll, decided by the user.
- `divLogRows: 0` — the frozen ledger took no row on a real scored day.
- `strataKeys: ["gap"]`, `sliceTrips: 0`, `gapTrips: 4`, `bookTrips: 7`,
  `newTripsWithRegimesKey: 0` — only the gap band accrues, and **every real trip opened
  under the dormant race carries no regimes key** (the era fact, live).
- freshness: "Regime ledger (divergence)" `kind: dormant, stale: false`; "Stratum
  samples" scheduled with the gap-band-only note.
- the dormant banner and frozen-ledger footer render; the prospect verdict leads with
  "The universe scorer holds this question now"; the beyond-net header reads "discovery
  slice dormant (retired Aug 14 2026 …) · gap band 250k–1m: 10 of 93"; the paper tile
  reads "7 open · 0 closed (30d, simulated)" with no divergence clause; the one-liner
  states the dormancy.

## §6 The sleeve-form landing (the listed same-class site, fixed)

`[data-slvedit]`'s bare `scrollIntoView({behavior:"smooth"})` — no measured chrome pad,
no flash, no rAF deferral — now routes through `navLand`, the one landing
implementation. `slvFormFill` performs no focus call, so nothing fights the landing.
Row **R24.4**; asserted structurally per R24.3's shape through the real delegated click
handler; **seed S8** turned it red on both halves (target not landed AND the wrong
panel landed). No FRICTION.md entry existed to close.

## §7 Suite and ledger

PROBE-PASS **1,061** assertions (from 1,073 at the 1e close: the dormant-gated live
forms net out slightly smaller than their dormant replacements), **376 requirement ids**
(from 372), pairing clean both directions, both viewports. New rows: §81.1–.4, R24.4;
marked rows: R11.2, R18.1, R18.4, R20.3, R20.5, R22.6, R25.5, R27.3, R29.1, R29.2
(drift annotation), R29.3, R29.5, R29.6, R37.4, R43.1, R44.4 (citation fix), R57.2,
R65.1. Docs in the same tree: CLAUDE.md surface map, IMPROVEMENTS.md 6.7 closed as
mooted, the triage EXPIRY RECORD, glossary marks (paper-regime, prosp-slice,
prosp-stratum dormant per the `paper-shape` precedent; paper-book / paper-cohort /
gov-neverfed / the prospecting group note amended).

## §8 Rulings pending from this stage

None. Both retirements were ruled at the 1e close; this stage applied them. The
un-retires are future rulings, pinned. The gap-band scope call (§1) is recorded as an
applied reading of the ruling's own words — "the discovery slice's sampling role" — and
is reversible by ruling if the user meant the gap band too.
