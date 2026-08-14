# Universe scoring — a costed design and an adversarial verdict

2026-08-14 · **design only. Nothing built, nothing committed, nothing authorized by this
document.** Ordered by the user as a design question with an adversarial test of the
hypothesis *"the tools we have built are the correct pathway, and this task is reachable by
expanding their reach."*

Sources: `index.html` working tree; the 2026-08-13 22:00Z market snapshot still in the
session scratchpad (4,497 items, the interaction-surface census population); measured
funded-set sizes computed from it this session (script `configs.ps1`, single pass, same
schema as the surface audit). The API-layer facts were re-verified against the code at the
cited lines, not recalled.

---

## §0 Three measured facts that shape everything else

**1 — The bulk endpoints already cover the universe, so steady-state scoring costs zero
new API calls.** The app polls `/latest` every 60s (`POLL_MS`, `index.html:1154`) and
`/1h` + `/5m` + `/volumes` together every 5 minutes (`HOUR_MS`, `loadHour()` at `:1987`).
Each response covers **every item in one call** — measured 2026-08-13: `/latest` 341KB /
4,518 items, `/1h` 285KB / 3,174, `/mapping` 862KB / 4,652. The six
mechanically-evaluable gates (ROI, margin, skew, imbalance, volume floor, sizing) read
nothing else. **The only inputs needing per-item calls are the chart gates** — trend,
volume trend, momentum need a 7-day hourly series, today fetched per item by `sparkFor()`
(`/timeseries?id=X&timestep=1h`, `:2031`) behind the circuit breaker. That one fact
determines the design: universe scoring is free at the current politeness budget
**except** the chart dimension, which must be self-accrued rather than fetched.

**2 — Funded sets are NESTED, and the frontier is tiny.** Both loosening axes are
monotone: lowering `taxMult` strictly weakens `marginNeed`, lowering the volume-floor
base strictly weakens `volFloorFor`. So every config's funded set is a subset of the
loosest corner's, and the fill-simulation workload for an entire grid is bounded by ONE
set. Measured on the snapshot (six gates, current `roi=1.2` unless stated):

| config | funded | median volSide/h | funded with volSide < 100/h | median buy |
|---|---:|---:|---:|---:|
| `m=3, b=1000` (today) | **13** | 1,768 | 2 | 790 |
| `m=2, b=1000` (eff. floor 4.26%) | 16 | 1,834 | 3 | 887 |
| `m=1.5, b=1000` (3.16%) | 24 | 1,195 | 11 | 179k |
| `m=1, b=1000` (2.08%) | 33 | 113 | 16 | 96k |
| `m=0.5, b=1000` (1.03% — the stated ROI floor re-binds) | 54 | **29** | 31 | 257k |
| `m=0.5, roi=1.0, b=1000` | 61 | 29 | 35 | 257k |
| `m=3, b=250` | 26 | 378 | 7 | 870 |
| `m=3, b=100` | 51 | 132 | 17 | 1,128 |
| `m=0.5, b=250` | 99 | 102 | 49 | 32k |
| `m=0.5, b=100` (loosest measured) | **147** | 100 | 73 | 10k |

Union across the 15-cell `m×b` grid at `roi=1.2`: **99 distinct items** — exactly the
loosest cell, which is the nesting made visible. **The scoring universe is 4,500; the
simulation frontier is ~100–150.** (Caveats: one snapshot, one time of day; six gates
only, so these are upper bounds net of chart-gate attrition; the sizing gate used the
operator's bank and is argued out below, which would add back the 68 items priced above
one-third of working capital.)

**3 — The newly admitted population is two orders of magnitude thinner.** Median thin-side
volume collapses 1,768/h → 29/h across the taxMult sweep, and at the loose corner half
the funded set trades under 100 units/hour. **The capture (0.15, ungraded) and
participation (50%) constants become the most load-bearing numbers in the instrument
precisely on the population where they have never been observed.** This is the user's
named failure mode, confirmed with numbers, and §5/§6 treat those constants as measured
dimensions rather than inherited truths.

---

## §1 API budget

| input | endpoint | coverage | cadence | marginal cost |
|---|---|---|---|---|
| prices, skew | `/latest` | whole universe, 1 call | 60s (existing poll) | **zero** |
| volumes, 1h averages, imbalance | `/1h` | whole universe, 1 call | 5 min (existing) | **zero** |
| 5m tape (fill accrual, vol5 rule) | `/5m` | whole universe, 1 call | 5 min (existing) | **zero** |
| buy limits, exemption | `/mapping` | whole universe, cached | daily (existing) | **zero** |
| 7d hourly series (trend gates) | today: `/timeseries` per item | **per item** | — | **prohibited at 4,500×** |
| 5m backfill (retro fill sim) | `/timeseries` per item | per item | — | spot-check only |

**Honest cycle time: 5 minutes.** Scoring could run every 60s off `/latest`, but volumes —
which decide the volume floor, imbalance, the vol5 binding rule and every fill credit —
arrive on the 5-minute bucket. A 60s scoring cadence would re-score price-only changes
against stale volume and imply a resolution the inputs do not have. Verdict transitions
stamp the poll seq either way, so nothing is lost. The politeness budget is untouched:
**the instrument adds no requests at steady state.**

**The chart gates are the one real problem, and the answer is self-accrual.** Store one
hourly close+volume per item from the `/1h` poll already in hand; after 7 days of
operation the trend and volume-trend gates read the archive instead of `sparkFor`.
**Cold start is declared, not papered over**: for the first 7 days the chart gates are
unknowable at universe scale, verdicts carry a `sixGate` coverage stamp, and unknown is
not failing — the discipline and the copy pattern already exist (`GATE_UNKNOWABLE`,
`chartPending`). Momentum needs 5 hourly points and matures in 4 hours. `sparkFor` stays
for the watchlist surfaces; the scorer never calls it.

**No wholesale `/timeseries`, ever.** 4,500 per-item calls is exactly the bad-neighbour
shape the circuit breaker was built against (`:2007`). Retro backfill is limited to
spot-checks and reconstruction (§4).

---

## §2 Storage — the archive is the ledger

The naive per-item × per-config × per-cycle ledger is not designed around; it is
**replaced by a factoring**. A gate verdict at cycle T is a pure function of (inputs at
T, config). So the raw thing to store is the **inputs**, once — every config present and
future can then be scored over the archived window, and a config added next week can be
evaluated retroactively over it, which no per-verdict ledger can offer. Per-config
storage shrinks to rollups.

| tier | contents | size | retention | what it can still answer |
|---|---|---|---|---|
| **T0 — market archive** | per item per 5m bucket: avgHigh, avgLow, hiVol, loVol (packed, ~16B/cell) + hourly closes | **~21 MB/day**; hourly ~9MB/7d | 36h–7d rolling | any config's verdicts AND honest-fill replay over the window; the whole instrument re-derivable |
| **T1 — trip records** | per (config-cell, item) open/closed trips, shadowBook-lean schema (~150B) | frontier ~150 items × 3 participation levels × turnover ≤ horizon⁻¹ | capped per cell; **rolled into T2 before pruning** (the `strataStat` roll-then-prune pattern, verbatim) | per-trip evidence, drill rows, concentration |
| **T2 — durable rollups** | per config-cell: cycles observed, items funded (distinct), trips, filled/forced/never, net, gross, streaming top-trip share, per-item cumulative net for ever-funded items | ~100B × cells + ~60B × ever-funded item-cells; **hundreds of KB** | indefinite | the ranking question, with concentration and coverage; NOT re-derivable — hence T1 rolls in, never skips |
| **T3 — exports** | the three-tier state as a curated analysis file, header states config hashes, coverage, truncations | on demand | desk | anything, offline |

**The 5MB localStorage bound: outgrown, plainly.** T0 alone is 4× the entire quota per
day, and the quota is shared with the live app's state (~630KB backup today). The
instrument has **not** outgrown the browser: IndexedDB is available in the same
single-file, no-build, client-side model, holds gigabytes, and requires no server. The
boundary crossed is real and should be named in the constitution if built — the app's
statement "localStorage persistence" gains one exception — but it is a storage API, not
an architecture change. The desk alternative (export/sweep files) works for T3 and for
long-horizon T0 retention beyond 7d, and is **optional**, not load-bearing. Bending the
design to fit 5MB would mean discarding T0, which is the tier that makes every other
tier auditable — rejected.

**Population stamps are part of the schema, not a rendering nicety.** Every T1/T2 row
carries `configHash` (the full constant vector, hashed) and `FILL_MODEL_V`. An edited
config is a NEW hash and a new population — never a continuation. This is `fillModelV`
partitioning applied at 45× scale, and the pooling scan reads it.

---

## §3 Compute

Factor once, compare cheaply. Per 5m cycle:

- **Sufficient statistics, once per item**: eMargin, eRoi, tax, tick floor, volSide,
  vol5, imbalance, skew, price — ~30 ops × 4,500 = 135K ops. Already computed today by
  `calc()` for watch items; this widens the loop.
- **Per-config verdicts**: with statistics in hand each config is ~12 threshold
  comparisons; 4,500 × 45 cells ≈ **2.4M comparisons ≈ single-digit milliseconds**.
  (The monotone structure would even allow storing each item's critical vector — the
  loosest constant at which each gate still passes — making N configs free at read time;
  an optimization, not a requirement.)
- **Fill accrual**: bounded by the frontier, not the universe — ~150 items × 3
  participation levels × ~20 ops per 5m bucket. Negligible.

**Where it runs**: chunked inside the existing 5-minute `loadHour` path, yielding via
`requestIdleCallback` between item blocks; a Blob-URL worker (no build step needed) is
the fallback if profiling shows jank, not the default. The 60s `/latest` poll is
untouched. Startup replay of a 36h archive window (~430 buckets × frontier) is the
heaviest single operation and still sub-second-class; run it chunked with a visible
"replaying archive — N of M buckets" state line, because a scorer that is busy must not
be mistaken for a scorer that is stalled (the generator-renders-its-own-state rule).

---

## §4 Fill simulation — the funnel

**Score everything; simulate the frontier.** The nesting fact makes this exact rather
than heuristic: simulate the loosest config's funded set and every tighter config's
funded set is a subset of trips already being simulated. Per-config differences in the
fill model itself are confined to **participation**, so trips are simulated once per
(item, participation-level) — 3 levels — and config cells map onto them. Bids are
item-level (`c.buy + 1`), shared.

- **Forward accrual is primary, and it is the same machinery the paper book uses**: credit
  from the live `/5m` bucket under the causality rules (`bt ≥ p.t`, once-per-bucket,
  `openSeq` stamps), observation credit as series coverage, proven/possible bounds per
  trip. This transfers unchanged (§6).
- **Forward-only is LAW here, not thrift.** A trip may be opened only at a cycle the
  scorer actually ran, and filled only by tape after it. Retroactive evaluation over the
  T0 archive is *reconstruction* — permitted, replayed under the same rules, stamped
  `grade: reconstructed`, and an aggregate resting only on reconstructed evidence says so.
  This is the paper book's own backstop rule, inherited verbatim.
- **Trip lifecycle at universe scale**: one rolling cycle per (config-cell, item) — open
  at the funded edge, accrue to horizon or exit, close, reopen if still funded. No family
  cooldown, no open cap, no eviction: those were *sampling* rules for a budgeted book, and
  an exhaustive instrument does not sample (§6). Turnover is bounded by the horizon: at a
  fixed 6h measurement horizon, ≤4 trips/item/day → worst case ~150 × 3 × 4 = **1,800
  trips/day** across the whole grid, rolled into T2 as they close.
- **The horizon is a config constant, not my schedule.** A fixed measurement horizon per
  grid (6h default, an overnight 9.5h variant if ruled) replaces `hzH`-from-touch-schedule.
  Measuring rule sets under *my* touch cadence would re-import operator modelling; the
  question "what would this rule set find" is answered at a stated, fixed horizon, and the
  answer is labelled with it.

---

## §5 The config grid

Shaped by the domination finding, not uniform. `taxMult` **is** the effective ROI floor
(`effRoiFloorPct()`), so it is the primary axis, and the grid crosses the boundary where
the stated ROI floor re-emerges:

| axis | values | rationale |
|---|---|---|
| `taxMult` | **3, 2, 1.5, 1, 0.5** | effective floors 6.52 / 4.26 / 3.16 / 2.08 / 1.03% — the sweep crosses the domination boundary at ~0.55, below which `roi` binds again |
| `roi` | **1.2** everywhere; **{1.2, 1.0}** at `taxMult=0.5` only | varying it where it is inert (measured: identical funded sets) would burn cells to learn nothing; at 0.5 it finally has a marginal population — measured 54 → 61 — and the original loosening question becomes testable at last |
| volume-floor base | **1000, 500, 250** | secondary axis; the 100 corner is deferred until capture calibration exists, because 73 of its 147 funded items trade under 100/h and the fill model has no evidence there |
| participation | **25%, 50%, 100%** | fill-model dimension, not a gate — multiplies simulation only |
| capture | **0.05, 0.15, 0.30** | *sensitivity probe, not a scored dimension*: run the frontier's fills at three captures; if config RANKINGS flip across them, the instrument's honest output is "insufficient calibration to rank", stated as a verdict, not a footnote |

Grid: 16 gate-cells × 3 participation = **48 scored cells** (scoring is free; simulation
shares trips per §4). Two structural rules:

- **The current config is a control cell**, always present, so every reading is "against
  today" rather than absolute.
- **Adjacent-cell deltas are the deliverable.** The marginal population between two
  adjacent cells is exactly the "band" the regime race was built to see and structurally
  never could. Every delta population is feedable here *by construction* — there is no
  admission gate to starve it. Each delta opens to its items.

`minExpectGp` is **not** a config dimension: it is an allocator constant about my
attention, not a gate about the market. Per-trip expected gp is stored anyway, so any
minExpect reads as a filter over decomposed rows at report time.

---

## §6 The hypothesis, tested adversarially

> *"The tools we have built are the correct pathway… ideally by scaling up what exists
> rather than building new."*

Per component, both sides argued, verdict landed.

### Gate chain — TRANSFERS WITH SURGERY

**For scaling as-is:** the ENABLER refactor already made every gate independent and
collect all failures; leave-one-out fell out of it for free; `failProfile` is the shared
definition; the arithmetic is exactly what config scoring runs.
**Against:** `candidateFor(w)` is not a pure function of the market. It reads the
module-global `GATE` (parameterizing it means plumbing a config object through, and scan
10's seam discipline applies — one constant read by two mechanisms was already a named
defect class); and it leaks **operator state** in at least eight places: tested-price
overrides (`w.tBuy`/`w.tSell` replace live prices — my margin tests would contaminate a
market measurement), `planQty`/bank sizing, `provenLoser`, `itemWins` waivers,
`fillHistory`, the drift bench (my walk-up gap), the blacklist, and the
hour/stability/reliability score weights.
**Verdict:** extract the market gates into a pure `(stats, config) → fails` function —
the `strataCount`/`calibWindow` extraction pattern, done for testability reasons before —
and leave every operator gate out of the instrument. The operator gates are not defects;
they measure me, and this instrument measures rules. The surgery is real but bounded, and
the probe suite can then seed config isolation directly against the pure function.

### Fill model — TRANSFERS WITH MODIFICATION, one constant promoted to measured

**For:** the causality rules, once-per-bucket credit, `openSeq` stamps, proven/possible
bounds, observed-time discipline, and forced-exit-at-horizon pricing are precisely a
measurement instrument's evidence rules. Nothing about them is watchlist-specific.
**Against:** capture 0.15 is ungraded (the app says so on its own surface) and
participation 50% was chosen for a book of watchlist-class items. §0 fact 3: the loose
frontier is 60× thinner. An untuned constant applied to a new population is the
calibration problem again — the user's first named failure mode.
**Verdict:** the *rules* transfer as-is; the *constants* transfer as dimensions. Capture
runs as a three-point sensitivity probe whose disagreement gates the instrument's own
right to rank (§5). Until a capture calibration exists on thin items, cells whose funded
sets are majority-thin render their verdicts with the calibration caveat inline — the
approximate-machinery tripwire pattern, already ruled.

### Paper-book ledger machinery — SPLITS CLEANLY IN TWO

**Transfers as-is:** `FILL_MODEL_V` partitioning (extended with `configHash`), epoch
stamps, evidence grades (live/reconstructed/mixed), the roll-then-prune durable-counter
pattern, the stall line (a scorer renders its own state), the truncation-declared drill
discipline.
**Left behind, and this is the load-bearing half of the whole verdict:** family
cooldowns, `SHADOW_MAX_OPEN`, scanner eviction, slice budgets, touch anchoring,
`hzH`-from-schedule, cohort labels. Every one exists to model *my trading* under *my
attention budget* — they are sampling rules for a capped book. An exhaustive instrument
has no sampling problem, so they are not simplified away; **their purpose is absent.**
Carrying them would be the user's second named failure mode: operator-modelling machinery
inside a measurement instrument, distorting exactly the way the admission gate distorted
the regime race.

### Regime machinery — ACTIVELY MISLEADS; SUPERSEDED, with its lessons kept

**For scaling it:** it is the only existing attempt at this exact question, and its
central-stamping fix (membership as a property of the candidate) is the right pattern.
**Against:** it is the *cautionary tale*: its comparator was arithmetically incapable of
returning anything but "identical" until yesterday, its population was unfeedable by
construction, and both stood green for an epoch inside the machinery built to detect
never-fed aggregates. Three regimes are a 3-cell grid with an admission gate; this
instrument is the same question without the crippling part.
**Verdict:** superseded. The universe scorer **replaces** the regime race; the race's
retirement into it is a future ruling (dormancy/consolidation lane), not part of this
design. Its lessons — central stamping, named bands not orderings, eligibility computed
from constants — are already law and the design cites them as constraints, not code.

### Verification apparatus — TRANSFERS AS-IS, and is a precondition

Seeding discipline, the scans (2, 8, 10, 11, 16 apply directly), the pairing check, and
the probe pattern all transfer. The pure-function extraction makes the scoring core
testable headless with synthetic data, which is how the suite already runs. New
detectors the instrument must ship with (§8) are instances of existing scan families,
not new inventions.

### API layer — TRANSFERS AS-IS

Politeness budget, backoff, the mapping cache, the `/timeseries` circuit breaker, and the
volume index all transfer unchanged. The volume index matters *more* at universe scale: a
feed methodology change (the Jul 24 artifact) would move every config's funded set at
once, and the index is the only thing that can say "the ruler changed, not the market."
Zero new steady-state calls is the headline (§1).

---

## §7 Verdict: **SCALE WITH SURGERY**

The hypothesis is **mostly right, with one inversion**. The *evidential core* — gate
arithmetic, fill-model rules, provenance stamps, ledger patterns, verification
discipline, API layer — is correct, already parameterization-shaped (the ENABLER
refactor did the hard part a week ago without knowing it), and transfers. The *admission
and operator-modelling machinery* — which is most of `shadowScan`, `scannerShadowScan`,
the slice plumbing, cohorts, cooldowns, caps, eviction, touch anchoring — does not
transfer and must not: it is the part the entanglement finding convicted. **The surgery
takes the paper book's best parts and leaves most of its machinery.** That is the less
satisfying answer the prompt pre-authorized, and it is the honest one.

**Transfers (extract or reuse):** the six-gate arithmetic + `effMargin` + `volGateFor` as
a pure `(stats, config)` function; `marginNeedFor` / `effRoiFloorPct` / `bandUnreachable`;
the fill accrual loop with its causality rules and bounds; reconstruction with grade
stamps; `FILL_MODEL_V`→`configHash` partitioning; roll-then-prune; the stall line; the
drill primitive; the volume index; the whole verification apparatus.

**Left behind (with the reason, so deletion is principled):** near-miss admission (the
convicted part); cohorts and the slice (sampling — an exhaustive instrument doesn't);
family cooldown, open caps, eviction (budget rules for a capped book); touch anchoring
and schedule horizons (my cadence, not the market's); operator gates and score weights
(measure me); tested-price overrides (my experiments); the regime bands (superseded);
`minExpect` and the allocator (attention, applied at read time).

**Not in the browser:** nothing, except long-horizon archive retention, which is optional
desk storage via the existing export/sweep pattern. The instrument fits the no-build
single-file model with one named boundary crossing: **IndexedDB for T0/T1**, because 5MB
of localStorage cannot hold one day of the archive that makes the instrument auditable.

**What it replaces, per the zero-based complexity budget:** the regime race (three cells
of this grid, admission-crippled) and the discovery slice's sampling role (a random draw
over the universe is pointless once the universe is scored). Both retirements are
rulings for the day the instrument exists, listed here as the price-tag answer, not
enacted.

**Walk-up cost: zero by construction.** This is a pull surface in the Paper
Book/Prospecting/Gate Health class — read, not worked; it presents no rulings; its
findings reach the desk through the existing proposal lanes, and nothing it produces
moves a constant without a ruling.

---

## §8 The instrument's own detectors (constraints that survive, made mechanical)

- **Never pool across configs or model versions**: `configHash` + `FILL_MODEL_V` on every
  T1/T2 row; the pooling scan (8) reads the exports; a hash mismatch inside one aggregate
  is a finding.
- **Every aggregate decomposes**: per-cell rollups open through the drill primitive to T1
  trips; where T1 has rolled and pruned, the cell says how many trips it summarizes that
  are no longer openable — declared truncation, not silent.
- **Unobserved is unknown**: T0 coverage is stamped per day (observed 5m buckets / 288);
  every cell verdict renders its coverage; a closed-browser gap is a gap, and
  reconstruction over it is graded, never silently blended (`live`/`reconstructed`/
  `mixed` counts per cell).
- **The scorer renders its own state** whether or not anything is wrong: last cycle, items
  scored, frontier size, archive coverage, breaker states — computed from the same values
  it gates on.
- **Concentration before conclusions**: streaming top-trip share per cell; a cell whose
  top contributor exceeds the callout share reports that before its net (n-is-not-sample-
  size, mechanical).
- **The calibration tripwire**: any proposal citing a cell whose funded set is
  majority-thin (volSide < 100/h) or whose ranking flips across the capture probe carries
  the ungraded-capture caveat inline — the approximate-machinery pattern, applied at birth
  rather than retrofitted.
- **Interaction-surface at birth (scan 16)**: the config grid's own gates are the same
  ordered chain; per-cell attribution inside the instrument reports full fail sets from
  day one — first-fail never enters the schema, so the funnel problem cannot recur at
  4,500×.

---

## §9 Stage-1d ratifications (user rulings, Aug 14 2026 — recorded here so 1e renders without re-deriving the reasons)

- **The capture probe is THREE LIFECYCLES per trip, ratified as an improvement over the
  ruled minimum, for the causal reason:** §5 specified capture as a sensitivity probe
  over the fills; the build implemented it as three independent lifecycles per trip
  (`vars`), because **capture moves how fast the buy completes, buy completion anchors
  the sell window, and the sell window decides the outcome** — a shared lifecycle with
  three capture readings would have re-used one sell window for three buy speeds, which
  is an information-horizon violation in miniature. 1e's surfaces render per-lifecycle
  figures; nobody re-derives why three lifecycles exist — this paragraph is the reason.
- **The horizon set is {6h, 9.5h}** (supersedes §4's "6h default, an overnight 9.5h
  variant if ruled" — now ruled). Trips per (item × participation × horizon); horizon is
  in the trip key and the econ key, so the overnight comparison that inverted twice
  under duration thresholds is a stamped population against a stamped population.
  Participation stays {25, 50, 100%}. Measured occupancy at ratification: 804 concurrent
  trips (134 frontier items × 6), trivial.
- **The concentration ceiling is 0.5, measured as the top mover's share of the cell's
  GROSS movement** (|net| terms — a share of a negative net is not a proportion, and the
  gross denominator keeps the reading on losing cells, where concentration matters
  most). Rank-disqualifier only, never a data exclusion. Grounded in the 103% case law:
  every retracted finding in this project was carried by one or two trips.
- **Capture status is the rendered verdict:** the probe detects rank-instability from
  birth; it validates no capture point until real flips exist on frontier-class items,
  and until then the instrument says **"cannot rank yet"**, in those words, wherever a
  ranking would render (`scorerRankReadiness()`, pinned by `[R78.17]` so the grading era
  cannot arrive without a ruling). The dependency stays named: the operator's
  calibration flips inside the tape window.

## Verification status

The API facts are read from the code at cited lines this session. The funded-set table
was computed once from the 2026-08-13 snapshot (six gates; upper bounds net of chart
gates; single time-of-day; the sizing gate applied with the operator's bank, which §6
argues out — that would grow the loose cells modestly). The nesting argument is algebra
(monotone thresholds), not measurement, and holds regardless of snapshot. Storage and
compute figures are arithmetic from measured response sizes and stated schemas; none has
been validated by a running implementation, because nothing was built.
