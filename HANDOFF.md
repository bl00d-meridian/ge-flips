# QUEUE — session close, 2026-08-14 (fourth session: the two retirements + the sleeve landing)

**Read this before starting anything.** Stage 1e + the log-flip landing + the mm bench
are committed and pushed (`8bf841e`). The working tree carries **the two retirements
(dormancy lane) and the sleeve-form landing fix**, uncommitted — the record is
`audits/RETIRE-2026-08-14-dormancy.md`. Suite at close: **PROBE-PASS — 1,061
assertions, BOTH viewports, pairing clean both directions, 376 requirement ids; 15
discriminating seeds this session (S1–S15), all bit, one at a time, restore-green
between.** Deployment: **DEPLOY-OK at 1.0s on a phone-viewport real-network
fresh-profile boot** — both retirement decision-log entries landed on first poll
(`auto: 1, by: "user"`), the frozen divergence ledger took no row, only the gap band
accrued, and every real trip opened under the dormant race carries no `regimes` key.

## THE RETIREMENTS ARE DONE (dormancy lane, ruled at the 1e close, built this session)

- **Regime race dormant** (`REGIME_RACE_RETIRED` pinned, `[R81.1]`): stamping, the
  daily snapshot and divergence evidence/proposals stopped; historical curves, bands
  and ledger render under the dormant banner; freshness reads DORMANT; export stamps
  the era. Era fact: dormant-era trips carry NO `regimes` key (absent ≠ `[]`), carry
  and export preserve it.
- **Slice sampling role dormant** (`SLICE_SAMPLING_RETIRED` pinned, `[R81.2]`): the
  stratified draw/rotation and stratum-ledger accrual stopped; the map is the frozen
  historical ledger. **THE GAP BAND STAYS LIVE** at exactly its ruled
  `floor(SLICE_SHADOW_CAP/2)` share — scope call recorded in the stage report §1: the
  clean-count register is paper-book-wide plumbing (two consumers), the band serves the
  held T3 proposal and the routing question, so triage finding 3500 stays conditional.
- **6 of the 17 EXPIRE-AT-RETIREMENT findings expired** (2481, 5574, 2575, 6127,
  7300, 7317 — expiry record in the triage file); the other 11 wait on cutover-era
  retirements. IMPROVEMENTS 6.7 closed as mooted. Legacy assertions are dormant-gated,
  never deleted (`[R81.4]`) — the un-retire re-arms them by flipping one constant.
- **Sleeve-form landing fixed** (R24.4, seeded): `[data-slvedit]` now lands through
  `navLand`, the one implementation.

# PRIOR SESSION — 2026-08-14 (third session: stage 1e + two directives)

Stage 1d is committed and pushed (`c3fc572`); stage 1e plus the log-flip landing fix
and the mm bench went out in `8bf841e`. Suite state at that close: **PROBE-PASS — 1,073
assertions, BOTH viewports (1200×900 and 390×844), pairing clean both directions; 17
further seeds that session (12 §80, 4 §79, 1 R24.3), all bit, one at a time.**
Deployment: **DEPLOY-OK at 1.0s on a phone-viewport real boot — 744 trips (124 frontier
× 3 × 2, h6/h9.5 split 372/372) — with the Scorer's first screen captured as the
walk-up-test artifact** (stage report §3; it reads as the dictated
sentence-plus-four-lines, and it caught two live copy defects that were fixed and
re-greened).

## STAGE 1e IS DONE — `audits/STAGE1E-2026-08-14-scorer-surface.md` is the record

Trade → Scorer (seventh sub-view, pull-surface class): verdict-first first screen
(question → one sentence → accruing / chart-gates-N-of-7-observed / cannot-rank-yet in
the ruled words / rdiff-day-N), the always-rendering state line, the grid (pooled
average WITH extremes inline + all 24 bands opening, flow + stock, six-gate share, the
canary), econ per (horizon × participation) in structural `[data-hz]` containers with
per-capture-lifecycle figures, concentration on GROSS, the three econ states named,
trips drills with declared truncation; the `analysis-scorer` export (collector class
registered, CLAUDE.md table updated); nine glossary entries same-commit, marked
inline; the weekly review one-liner. **Staged stores:** econ + t1 rows consumed (off
scan 2's re-report list); **rdiff still staged for the cutover gate** (map §2b — the
verdict line's day-count read is informational). Era-fact tripwire still armed (chart
wiring not landed; six-gate 100% renders and stamps).

## ALSO IN THIS TREE (mid-turn directives, both done)

- **Log-flip landing fixed** (report §7): the press performed no landing at all —
  bare focus-scroll, keyboard/geometry-dependent, never chrome-offset. Now lands on
  the form through the one landing implementation (`navLand`, extracted from navGoto
  unchanged), both focuses preventScroll. `[R24.3]` seeded; real-press artifact on the
  phone viewport shows the form title landing 10px below the chrome. Same-class site
  LISTED, not fixed: the sleeve form's unpadded `scrollIntoView` (#slvFormPanel).
  FRICTION.md had no entry to close.
- **MM mode benched** (report §8): disabled until the scorer stands, not deleted.
  Measurement honest: **cannot attribute** (no mm stamp on flips, no invTarget
  history) — the bench rests on attention cost and the decision log records exactly
  that plus the in-flight snapshot, computed in the user's browser at the benched
  build's first poll. Nothing strands: standing legs resolve, lots sell down (MM
  UNWIND lines), panel states the bench; plan reverts per item as its unwind
  completes. `MM_BENCHED` pinned — the un-bench flips only by ruling (`[R79.1]`, seed
  S1 turned five assertions red). Per-item state persists for the cutover re-key.

## STAGE 1d IS DONE — `audits/STAGE1D-2026-08-14-fill-sim.md` is the record

Built: the fill sim on the frontier (trips per item × participation at the ruled 6h
horizon, shared across cells by birth-stamped membership; three capture LIFECYCLES per
trip — 0.05/0.15/0.30 each run their own legs because capture moves the sell window);
the pure shared core (`fillCredit` with capture/participation as arguments,
`obsAccrual`, `sellBucketEligible`, `sellWindowStart` — both the paper book and the trip
layer route through them); IDB v3 (`t1` closed-trip ledger, 30d, roll-then-prune;
`t1open` boot carry — held-never-dropped at boot, the M154 property seeded in from
birth); econ rollups under four-stamp keys (`h6|p50|c15|fv1` — pooling structurally
impossible); the bl no-trip guarantee (discriminating seed pair vs the canary; mid-trip
blacklisting VOIDS as `vbl`); pump stamps at birth, decomposed, never excluded; the
capture-probe verdict terms (`scorerCaptureVerdict` / `scorerRankGate` /
`scorerCellEconState` — "insufficient calibration to rank" IS the verdict; full fail
sets; concentration ceiling is an ARGUMENT, unruled). All 23 TRANSFER findings
dispositioned with proofs, the 3 in-scope SPLIT halves landed (4447/5908 restated as 1e
obligations). Scan 11 at the boundary: 20 points, 0 findings. M155 recorded (the R47.5
caveat lived in a footnote behind a green whole-panel assertion; live-caught by the
scoped repair, fixed inline).

## THE §6 RULINGS — RULED AND APPLIED SAME DAY (stage report §9)

1. **Horizon set {6h, 9.5h} RATIFIED, participation {25, 50, 100%} confirmed** — built:
   trips per (item × participation × horizon), horizon in the trip key and the econ key;
   the overnight comparison is a stamped population against a stamped population.
   `[R78.16]` demonstrates the set (same tape, 6h closed while 9.5h accrues).
2. **Concentration ceiling RATIFIED at 0.5, measured on GROSS movement** — econ carries
   `gross` (Σ|net|) and `top` (max |net| mover); the rank gate disqualifies at
   top/gross > 0.5, measurable on losing cells, rank-disqualifier only. Seed AG proved
   the ruled and pre-ruling measurements genuinely disagree.
3. **Capture status RATIFIED as the rendered verdict** — `scorerRankReadiness()` says
   **"cannot rank yet"** in the ruled words wherever a ranking would render;
   `SCORER_CAPTURE_GRADED = false` is the pinned era fact (`[R78.17]`) so grading cannot
   arrive without a ruling; the dependency stays named (calibration flips inside the
   tape window). b=100 stays deferred on exactly this.
4. **The three-lifecycle probe design recorded** in the design doc §9 with its causal
   reason, so 1e renders per-lifecycle figures without re-deriving it.
   The rulings are decision-logged in the tool (`auto: 1, by: "user"`, asserted).

## WHAT 1e'S CLOSE UNLOCKS, AND WHAT STILL WAITS

- ~~**The retirements HELD "until the scorer's first readable output" are now
  unlockable**~~ — **DONE, fourth session of Aug 14 2026** (the block at the top of
  this file; `audits/RETIRE-2026-08-14-dormancy.md`). Ruled, built in the dormancy
  lane, seeded, deployed; 6 of the 17 triage findings expired with their surfaces.
- **1e residual obligations, small:** the 4447/5908 SPLIT halves were restated for 1e
  and remain open — excluded counts opening to their trips on the SCORER surface
  (partially covered by the econ exclusions rendering; the drill-through for excluded
  trips specifically is not built), and the 100%-rate zero-counterexample claim
  belongs to whatever surface first renders a fill RATE (none does yet — econ renders
  censuses, not rates). Carry both into the next surface work.
- **b=100 deferred** until capture calibration (ruled; restated in the export).
- **Chart wiring** still pending; the era tripwire forces its stanza when it lands. **Chart wiring still pending** ("here or later" — later): the
pinned era fact `marketStatsFor().tr === null` in `[R76.9]` stays armed; when the wiring
lands, `fundedNoChart` (cells) and `ncN` (econ) decompose the transition and the stanza
accounts for it.

**First thing on next app-open (user-profile self-check):** the freshness panel now has
FOUR scorer-class streams — market archive, universe scorer, reconciliation diff, **fill
sim (frontier trips)** — all should show a first bucket within one poll.

**Then:** the cutover gate behind reconciliation history (the `rdiff` ledger should be
the longest-observed number in the instrument by cutover day — heaviest gate:
verdict-level reconciliation, integration-audit walk, adversarial pass on
cutover-critical assertions, `[R7.3]` standard); ~~retirements HELD~~ **retirements
DONE (fourth session, dormancy lane — top of this file)**; **sleeve addendum
stages after capture calibration**, conformance gate applying identically,
conviction-boundary detector with the first planner surface.

## THE UNIVERSE SCORER — build ruled Aug 14 2026, staged

Design ratified as plan of record: `audits/DESIGN-2026-08-14-universe-scoring.md`, with
the six rulings recorded there and below. Stage status:

| stage | status | where |
|---|---|---|
| 0 — frontier re-measured under the instrument's own gates | **DONE** | `audits/STAGE0-2026-08-14-frontier.md` — the frontier CHURNS (109/89 at two times of day, intersection 27, union 171); concurrent sim load ~90–110/participation level; sizing gate added zero; thinness confirmed (median 43/h) |
| 1a — pure gate core `(stats, config) → fails` | **DONE** | `marketGateFails` / `marginNeedCfg` / `volFloorCfg` / `liveMarketConfig` / `marketStatsFor` in `index.html`; the live chain routes through the core; §74 (R74.1–R74.5b), six discriminating seeds; operator leaks excluded one by one |
| 1b — T0 archive accrual | **DONE, and the 7-day clock is RUNNING once the app is next opened** | `t0*` in `index.html`, riding `loadHour`; IndexedDB `geflips-t0` (m5 72h / h1 8d retention); coverage = keys-present as a pair; failure surfaced on `warn()`; §75 (R75.1–R75.5b), six seeds incl. the wiring; **CLAUDE.md carries the named localStorage exception in the same tree** |
| 1c — scoring + T2 rollups | **DONE** | §76 (R76.1–R76.7), seven discriminating seeds. The core emits **config-free keys** (`MARKET_GATE_KEYS`; display names are persisted ledger keys in `MARKET_GATE_LABEL` and do not move — the "3×" stands only in the live chain's own label, whose taxMult IS 3; the copy sweep derived every other rendered instance from `GATE.taxMult`/`effRoiFloorPct()`). 16-cell grid + live control deduped by hash; **one pass per 5m bucket**; per-cell flow (`cycles`/`fundedItemCycles`) and stock (`ids`/`distinct`, capped at `SCORER_ID_CAP=3000` sized from the union flow) first-class; 24 UTC hour-bands keyed to the BUCKET's hour; `DB.scorerT2` with an explicit `validateImport` carry that **re-derives the hash from the sanitized config**; failure surfaced via `scorerFailNote` |
| **conformance gate** — standing, every stage from 1d | **IN FORCE, mapping RATIFIED** | `audits/CONFORMANCE-2026-08-14-scorer-map.md`: 23 rows — row 12's widening ratified WITH the scan-2 re-report addition; row 15 pre-ruled (stamp, don't exclude); **row 23 added** (the blacklist canary, amended form); partition register ratified including the deliberate non-answer on ids stock; pinned-era-fact ratified as standing practice. Stages check deltas; stanza per report |
| **row 23 + flag 3** (consolidated rulings) | **DONE, seeded, deployed** | The canary pair `blFunded`/`blIds` (`[R76.10]`/`[R76.10b]` — discriminating seeds both directions, B proven on the crashed run's own 09:06 report); the reconciliation diff in IDB `rdiff` (DB v2, 90d, `[R77.1–3]`); the boot race found by the deployment check and fixed (`[R76.11]`, **M154**); **DEPLOY-OK — first bucket archived, scored and diffed 2s after boot on the real API** |
| **fill-tier triage** (mid-session order) | **DONE** | `audits/TRIAGE-2026-08-14-fill-tier.md`: the census's 45 fill-tier findings (the surviving superset of the 32-CONFIRMED roster, which died with the syntheses — M149): **23 TRANSFER** (fold into 1d), **17 EXPIRE-AT-RETIREMENT** (reason per finding; unfixed by design until the retirement ruling), **5 SPLIT** (property re-lands in 1d/1e, assertion dies with its surface) |
| 1d — fill sim on the frontier + capture probe | **DONE** | `audits/STAGE1D-2026-08-14-fill-sim.md` — §78 (R78.1–R78.15), 26 discriminating seeds + 1 live catch (M155); trip layer + pure shared core + IDB v3 (`t1`/`t1open`) + four-stamp econ keys + verdict terms; 23 TRANSFERs dispositioned; scan 11 clean (20 points); DEPLOY-OK at 1s (804 trips on the first real bucket post-rulings); **the §6 rulings ruled and applied same day** (report §9: horizon set {6, 9.5}, gross-movement ceiling 0.5, cannot-rank-yet readiness pinned, three-lifecycle rationale recorded) |
| 1e — surfaces + exports, drill-decomposable | **DONE** | `audits/STAGE1E-2026-08-14-scorer-surface.md` — §80 (R80.1–R80.11), 12 discriminating seeds; Trade → Scorer with the verdict-first first screen (the walk-up test's artifact captured on a phone-viewport real boot), the state line, horizon-grouped per-lifecycle econ on gross concentration, drills with declared truncation, the `analysis-scorer` export + collector class, nine same-commit glossary entries, the weekly one-liner; econ + t1 consumed off the staged list, **rdiff still staged for cutover**; the R38.6 scan and the deployment artifact each caught a live copy defect, both fixed and re-greened |

**The clock's fine print:** T0 accrues only while the app is open. The 7-day chart-gate
cold start counts OBSERVED coverage, not wall days — `t0Coverage` reports the pair, and a
closed browser is an unobserved gap from the moment it starts (warn fires only on accrual
*failures*, not on absence — absence is the observed-time rule's territory).

**Standing sub-rulings:** first-fail never enters the instrument's schema (full fail sets
from birth); retirements (regime race, discovery slice's sampling role) ~~HELD~~ **DONE
Aug 14 2026, fourth session — dormancy lane** (top of this file); minExpect at read
time, never a dimension.

## Ruled and NOT yet done (pre-scorer queue — nothing here jumps ahead)

| # | Item | Why it waits |
|---|---|---|
| 1 | **The fill-tier findings — TRIAGED 2026-08-14**, dispositions in `audits/TRIAGE-2026-08-14-fill-tier.md`. The two-agent 32-CONFIRMED roster is not re-derivable (died with the syntheses, M149); the triage covers the census's 45-finding superset: 23 TRANSFER → folded into 1d's scope, 17 EXPIRE-AT-RETIREMENT with reasons recorded, 5 SPLIT (property re-lands, assertion expires with its surface) | dispositions applied; transfers ride 1d |
| 2 | **The 82 gates/other findings** — SINGLE-AGENT, no adversarial pass ever ran (11 verifiers died at a session limit). **Ruled: no fixes off them, counted separately in every report, never folded in with verified findings** | needs its own adversarial pass first |
| 3 | **Scan 14's first run** (label-claim scan, written into CLAUDE.md) — never executed | new |
| 4 | **The production-anchor schema change** — every future census carries a `codeQuote` for production citations, not just probe ones | applies to the next census, not retroactively |
| 5–8 | **CLOSED 2026-08-13** — see the section below. Numbers retained, never reused | — |
| 9 | **THE 12 REMAINING AFFECTED SURFACES ARE MARKED, NOT REPAIRED** (user ruling, Aug 13 2026). Each declares itself *headline gate, not binding gate*; the surfaces reading the full fail set deliberately carry no mark, and `[R73.6]` asserts that absence because a mark on everything distinguishes nothing. **The 13th — the deployment funnel — was repaired on 2026-08-13** and is done: leave-one-out leads, first-fail is demoted and labelled, the ⚑ flag is gone (`[R73.10]`). The repair-or-retire decision for the other twelve is **still open**; the appendix to `audits/SURFACE-2026-08-13-gate-interaction.md` costs the options | open, deliberately |
| 10 | **FULL-FAIL-SET LEDGER RECORDING — HELD** (user ruling, Aug 13 2026). `DB.gateLog` would write one row per failing gate instead of `fails[0]`: ~4 lines at `index.html`'s writer, **~3.5× the rows** (648 → ~2,300 over four observed days, order of 20k at 30-day retention), and a **migration partition** — pre-change rows are headline-only and must be reported as their own population until they age out, never merged. **Held because the causal number turned out to be available without it:** the funnel's leave-one-out ranking ships today from `failProfile()`, so this buys *historical* attribution rather than *current*, and a migration is not worth that alone. **What would revive it:** a question that needs per-gate history — most likely the persistence bar, which still promotes proposals on headline day-counts, or a retrospective asking what was binding last month rather than now | held, logged |

## Rows 5–8 — CLOSED 2026-08-13 by user ruling

Rows 5 and 6 are **dead, not benched**; rows 7 and 8 are **measured and acted on**. Kept
here as a record of what was closed and why, so neither is re-proposed without meeting the
arithmetic that killed it. Both closures are written to the in-tool decision log
(`ROI_EXP_CLOSED_KEY`, `PAPER_POP_CLOSED_KEY`, once per store, not stamped `auto`).

- **Row 5 — the ROI-floor loosening experiment: DEAD.** Loosening `GATE.roi` 1.2% → 1.0%
  admits **0 of the 41 live band items**, because the margin gate's tax limb enforces an
  effective 6.52% floor. **The gate choice it rested on is struck**: the "74% of all sole
  blocks" figure is 0% by construction. Neither constant moved.
- **Row 6 — the paper-book population fix: DEAD, same reason.** The `loose \ current` band
  cannot be fed while the entry condition is `pass || nearMiss` and every band item carries
  two failures. **The reserved-scanner-slot carve-out stays recorded as sound but moot** —
  the right protection for a change no longer worth making.
- **Row 7 — the margin/ROI entanglement: MEASURED.** `audits/SURFACE-2026-08-13-gate-interaction.md`.
  The queue's arithmetic was right and understated: the domination is not "above ~250gp",
  it is total, because below 250 the tick limb takes over from the tax limb with no gap.
- **Row 8 — the gate ledger records `fails[0]` only: CONFIRMED and now law.** BINDING in
  CLAUDE.md, detector scan 16, incidents M150–M151.

## For the NEXT session

**Nothing is queued from the gate-surface work except row 9's open decision.** The
measurement is complete, the rulings are applied, the suite is green at 306 requirement
ids, and §9 of the surface audit lists three adjacent findings that were deliberately not
pursued (the `strataCount` residual-bucket label, the marginal-gate attribution's three
buckets not summing to their population, and the tax-cap regime above a 250m sale price).

## Done this session, so it does NOT belong in the queue

The gate-ledger `v` field and its three round-trip states; the regime-race pairing fix
(named bands, `loose \ current` computed at last) and `shadowRegimeEvidence`'s tie-vs-
never-fed split; the paper-trip carry (21 dropped fields restored, `pend` deliberately
dropped); the `fillModelV` pooling note; the falsy-zero fixes (`f.bh` skip reason, both
`spreadPct` erasures, the band selector); the pump-guard extraction `[R70.x]`; the intel
sacred-set coverage `[R71.x]`; the horizon-term split `[R72.x]`; `probe:116`'s rename;
scan 14 written; the clamp rule's binding-vs-present qualification; MISTAKES M147–M149.

## Standing facts worth not rediscovering

- **`planCap` has zero direct probe coverage** (M147) and is the clamp scan 9 names first.
  It defeated `shadowHorizonUnits`, `probe:111`'s seed and `probe:116`'s label.
- **The first 622 probe lines run on `DB.touchWindows = []`**, a constant 4h fallback, so
  allocator sizing, quote participation caps and die-off voiding are never asserted against
  the product's default four-window schedule (M148).
- **A cached workflow replay is not free** — resuming a 51-agent run cost 13 agents and
  killed both syntheses (M149).
- **Freeze the tree during any background analysis**, and prove it by content hash at both
  ends of every agent's work. The method is recorded and it worked: 9 agents, one
  fingerprint at start and one at end.

---

# HANDOFF — 2026-08-12

State that lives only in a conversation and would be lost with it. Everything
else is in [CLAUDE.md](CLAUDE.md) (rulings and case law),
[REQUIREMENTS.md](REQUIREMENTS.md) (ruled requirements, `[R#]`-tagged to probe
assertions), [IMPROVEMENTS.md](IMPROVEMENTS.md), [FRICTION.md](FRICTION.md) and
`audits/`.

Written at commit `f1a8de3`, after a build session covering the Jul 24 volume
artifact, the paper-book defect fixes, the fill model's causality and
reachability rules, the calibration harness, and a constitutional scope audit.

---

## 1. Open questions, and what would settle each

### 1a. Is "1 of 43 trips filled" a market finding or a model artifact?

**Where it stands.** Re-run at both reachability bounds after the causality and
partial-outcome fixes:

| | filled | forced-exit | partial | never |
|---|---|---|---|---|
| proven (lower) | 1 | 8 | 21 | 13 |
| possible (upper) | 1 | 9 | 21 | 12 |

Only **2 of 43** differ between the bounds, so this is *not* a
strict-comparison artifact — unlike calibration, where the comparison price is
the trader's own realized fill and self-comparison depresses the lower bound
hard. The paper book compares against a simulated bid that never traded, so
there is no self-comparison to correct for. The two constructs are distinct and
must not be read against each other.

**What would settle it.** The sell-leg calibration (§2). Nine of the ten
failures are on the sell leg; if the model says never-sold for sells that
really completed in minutes, the 1-of-43 means nothing.

### 1b. Does the ~1.3× optimistic lean survive as a correctable constant?

**Answered, negatively — do not go looking for it.** The 1.32× came from an
oracle variant that divided by *in-window* flow, which is future information.
With the shipped input (reaching flow, median of six hours) the median
observed/predicted is **0.70×**, i.e. slightly pessimistic, and with the mean
variant 0.78×. There is no stable offset worth correcting; **the residual is
spread, not bias.**

### 1c. The fill-horizon band treatment

**Deferred by ruling until the corrected input is regraded on fresh data.** But
one finding already constrains the design, and it inverts the priority:

> All three input variants false-bench **the same 4 of 10** completed trips.

Fixing the input shrank the error magnitude enormously (Varrock teleport
tablets: predicted 49.8h → 2.0h) without removing a single false bench, because
all four are near-misses against the horizon — predicted 1.5–2.4h, horizons
1–1.77h, actually filled in 0.66–1.5h. **The band is not polish; it is the part
that fixes the harm.** The evidence supports an optimistic end at roughly
`predicted × 0.33`.

**What would settle the width.** A regrade of the corrected input on a sample
that is not the corrupted epoch — so, after the reset.

### 1d. Capture (0.15) is ungraded, not validated

It cannot be tested against paper trips: those fills were generated using it,
so measuring it there is circular. Stated as ungraded in the calibration panel
and the export honesty lines rather than left to look implicitly confirmed.

**What would settle it.** Realized flips, once the replayable sample is large
enough to separate capture from the reach and drift effects around it. The
harness is scoped for it; the sample is not there yet.

### 1e. Does the partial-fill picture survive on a larger sample?

Median buy credited, by cohort, across the 43:

| cohort | n | median credited |
|---|---|---|
| watchlist | 8 | **100%** |
| scanner T1 | 9 | 37% |
| scanner T2 | 6 | 36.8% |
| slice | 20 | 8.3% |

The pooled "median 37% of intended size" was four populations averaged. The
cohort closest to fundable fills completely. **On this sample it is evidence
for the gates, not against sizing.**

**Caveats a fresh session must carry.** None of the 43 was a clean gate-passer,
so "funded shape" has n=0 in the strict sense — watchlist is a proxy, and it is
8 trips. **What would settle it:** the same decomposition on a post-reset epoch
with clean passers in it.

### 1f. Should the gap band be routed exclusively to the evening touch?

**Raised Aug 13 2026, open, and deliberately not answered.** The band's two
horizons disagree in sign: **+399k on 3 overnight trips against −219k on 16
daytime ones.** Placed only at the evening touch, the band's trips get the
~9.5h sit; placed in the daytime they get ~5h, and on this evidence that is
where the losses are.

**This is not the scanner question and must not be read as it.** The held T3
scanner proposal asks whether the band deserves more coverage. Routing asks
when its trips should be placed. Different change, different cost, different
bar — see the routing-is-not-coverage case law in CLAUDE.md. **The scanner
proposal stays held on its own bar** (5 clean post-fix closed trips; the line
on Prospecting reports the standing count).

**What would settle it.** Five clean post-fix closed trips in the *overnight
cell*, with a concentration reading that is not one trip. Neither half is met:

| | n | notional | net (sim) | top-trip share |
|---|---|---|---|---|
| gap band · overnight | 3 | ~10.9m | **+399k** | **103%** |
| gap band · daytime | 16 | — | **−219k** | none — net is negative |

The overnight cell is **one 10.6m-notional trip** plus two that offset it: 103%
of the cell's net is the single top trip, so the effective sample size is one,
and three trips would not have been enough regardless. Read the cell as an
anecdote until it has trips that stand without that one.

**Where to look.** Trade → Paper Book → **Overnight vs daytime**, which renders
every cohort at both horizons with n, notional, net and concentration per cell,
and opens each to its trips. The analysis export carries the same as
`perCohortHorizonRollup`.

---

## 2. Pending on Mike

Nothing below can be done from the desk; each needs the browser or a ruling.

1. **Run the sell-leg calibration while flips are fresh.** Trade → Paper Book →
   ▸ run calibration. The 5m tape retains ~36h, so this is a *rolling* test —
   run it soon after a batch of flips completes, not at review time. The one
   run so far (2-of-4) is **VOID**: it predates the window-anchor fix in
   `1f61df5`. If `DB.calib` still holds those numbers, they are wrong.
2. **Re-run the anomaly scan after Aug 14**, on a fully post-break baseline.
   Until then every 2–3-week baseline straddles 2026-07-24 and the volume term
   is suppressed by design.
3. **Paper-book epoch reset — queued behind calibration**, deliberately. The
   corrupted epoch is the fixture for the fill-model work; resetting before the
   model settles would force a second reset.
4. **Rule on the constitutional scope audit.** Eleven proposed widenings, five
   rules found adequately stated, five flagged as preferences sitting in the
   constitution looking enforceable, and one genuine conflict (below). Nothing
   applied — the findings are in the conversation only, which is the one item
   in this file with no other home. Re-request the table if it is gone.
5. **Press Import briefing** if `intelligence.json` has not been imported: 22
   records, of which one is the first `measured`-tier record and three carry
   `disposition` dismissals (Bandos chestplate, Bandos tassets, Golem Crafting
   gems) that apply on import and decision-log themselves.
6. **Poll #270 (Jeweller's chisel) is unresolved.** It closed 2026-08-12 with
   `POLL_STATE_RUNNING` still showing at ~11:55 UTC. The wiki's poll page
   renders an unpopulated results template — a "2 votes, 50/50 tie" — which is
   placeholder data, **not** the outcome. The next briefing must read the real
   result. The Bronzeman / A Ruff Situation poll opens Aug 14.

---

## 3. Interim states that must not become permanent by inertia

### The fill-horizon gate is a SOFT TAG, not a hard bench

**Ruled 2026-08-12, effective now, interim.** The gate queues candidates as
NEXT UP with "predicted fill ~Xh — estimator under repair, input error known to
be large" instead of benching them.

**Reason:** graded against 43 replayed trips, observed/predicted spanned
0.025×–13.17× — a **518× range** — and the gate would have benched 4 of the 10
trips that actually completed. A hard gate on an input that noisy costs more in
real candidates than the noise it admits.

**Reversion condition:** returns to a hard bench when the corrected input is
regraded on a post-reset sample and a band width is ruled.

Both the downgrade and its reversion are written to the decision log
(`FILL_GATE_SOFT_KEY`, logged once per store, with the 518× figure and the
reversion clause in the reason). Probe `[R50.2]` asserts the reversion clause
is present, so deleting it fails the suite. **This is the mechanism that stops
the interim becoming permanent — do not remove it when reverting; log the
reversion instead.**

---

## 4. Everything else a fresh session would need and not otherwise find

### The hard boundary on the flip log — read this before offering to help

**The flip log never leaves the browser, and nothing in this repo may contain
trading data.** This is why the calibration harness is an in-browser surface
rather than an analysis the agent performs: the natural move is to ask for an
export and replay it at the desk, and that move is wrong. The calibration
export (`⭳ export calibration`) exists so the *measurement* can leave without
the record: prices only as percentages against the trader's own fill, no gp,
no wall-clock times.

One deliberate deviation from the brief, still open for overrule: the export
carries the bucket-vs-fill comparison as a **percentage only**, not the
"delta and percentage" that was asked for, because carrying both is invertible
— `fill = delta ÷ (pct/100)` recovers the absolute price exactly.

### Where the numbers in this file came from

Three analysis exports sit in the user's Downloads:
`analysis-paper-2026-08-12.json` (272 closed trips),
`analysis-gates-2026-08-12.json`, `analysis-prospecting-2026-08-12.json`.
Every figure quoted above was computed from those plus 5m tape fetched at
~13:00 UTC. **They are a snapshot of the corrupted epoch, pre-fix.** After the
reset they become historical curiosities, not baselines. The 5m tape cache was
in a session scratchpad and is gone.

### Mean vs median on the fill-forecast window

The ruling specified the **median** of the last six hourly readings, and that
is what shipped. Measured on the same 43, the mean over the window is tighter
on spread (15.5× vs 24.6×) while the median is better on wrongly-promised fits
(9 vs 13). Neither differs on false benches — both are 4. Worth an overrule if
spread matters more than false fits; not worth revisiting otherwise.

### A seventh face of the test-suite failure, not yet in case law

The case-law entry states the root as "a green result can mean the test never
ran". That does not bind an assertion which **runs, exercises the right code,
and passes for the wrong reason** — e.g. `[R49.2]` matches
`/watchlist 100% of 2/` against whole-page HTML, which any other blend on that
page would satisfy. Surfaced in the scope audit; **pending a ruling**, so it is
deliberately not in CLAUDE.md yet.

### One live conflict between two rulings

**"Advisory layers stay advisory"** and **"Membership bookkeeping applies
itself"** cannot both be read literally. The membership ruling supersedes the
first in one place and does not say so. Flagged in the audit; pending.

### Probe discipline, from four instances in one week

The reimplementation trap fired four times in this session, twice in code
written immediately after documenting it. The operative discipline is not the
rule but the check: **no assertion counts as proven until its seeded defect has
been seen to fail it.** Two further failure shapes, both now in case law: a
seed landing on unreachable code proves nothing and looks identical to real
proof, and two defects seeded together can hide each other — so seed one at a
time, and re-run anything that did not fail in isolation.

### Things that are fine and might look alarming

- **`shadow*` identifiers are the paper book**, except `shadowReserve`,
  `shadowItem` and `renderShadow`, which are the Shadow Fund. Persisted keys
  were deliberately not renamed.
- **The regime curves may read zero.** If no trip carries a regime the surface
  says "has never been fed" rather than showing zeros — that copy is the
  detector working, not a bug.
- **Ancestral, prayer scrolls and the CoX complex moved hard on 2026-08-12.**
  That is the shipped reweighting, front-run since the 22 July proposal, and it
  is fully written up in `briefings/BRIEF-2026-08-12.md`.
