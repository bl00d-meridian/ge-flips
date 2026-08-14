# Stage 0 — the frontier re-measured under the instrument's own gates

2026-08-14 · one script, no build, per the staging ruling. Sizes T1 and the fill budget
for stages 1b–1d of `audits/DESIGN-2026-08-14-universe-scoring.md`.

## Method

Two full-universe snapshots, instrument gate set only — **ROI floor, margin floor, book
skew, flow imbalance, volume floor; no sizing gate, no wins waiver, no tested-price
overrides, no operator gates** (§6 surgery list, applied before the build rather than
after). Chart gates unmeasurable from bulk snapshots; all figures are upper bounds net of
chart-gate attrition, as before.

| snapshot | 1h bucket | items | note |
|---|---|---:|---|
| A | 2026-08-13 **22:00Z** | 4,497 | US evening — the census snapshot, re-scored |
| B | 2026-08-14 **10:00Z** | 4,497 | UK/EU morning, US night |

Two times of day, not three — a third (US midday) needs a fetch this session could not
wait for; the churn figure below is therefore a **lower bound** on weekly churn.

## Results

Funded counts per grid cell (A / B):

| cell | A | B | | cell | A | B |
|---|---:|---:|---|---|---:|---:|
| m=3 b=1000 (today's config) | **13** | **5** | | m=1 b=1000 | 33 | 21 |
| m=3 b=500 | 16 | 13 | | m=1 b=500 | 50 | 38 |
| m=3 b=250 | 26 | 19 | | m=1 b=250 | 68 | 56 |
| m=2 b=1000 | 16 | 5 | | m=0.5 b=1000 | 54 | 37 |
| m=2 b=500 | 22 | 16 | | m=0.5 b=500 | 77 | 58 |
| m=2 b=250 | 36 | 25 | | m=0.5 b=250 | 99 | 82 |
| m=1.5 b=1000 | 24 | 8 | | **m=0.5 roi=1.0 b=250 (loosest ruled)** | **109** | **89** |

**The loosest ruled corner** (`m=0.5, roi=1.0, b=250` — b=100 stays deferred):

| A | B | union | intersection | A-only | B-only |
|---:|---:|---:|---:|---:|---:|
| 109 | 89 | **171** | **27** | 82 | 62 |

## The three numbers that size the build

1. **The frontier is a FLOW, not a list.** Only 27 of 171 items are in the frontier at
   both times of day. "Which items does this rule set fund" is a distribution over time,
   and per-cell rollups must count **distinct items ever funded** and **cycles funded**
   as first-class figures — a snapshot count understates the T1 population by 6× across
   just two observations. T1 sizing: plan for the union to keep growing (weekly union
   plausibly several hundred at the loose corner); the roll-then-prune cap is the
   protection, and **the instrument's own first week measures its own churn** at 5-minute
   granularity — a number no snapshot pair can give.
2. **Concurrent simulation load is the SNAPSHOT count, not the union**: ~90–110 open
   trips per participation level at the loosest corner (~330 total across three levels),
   well inside the compute budget. Churn raises trip *turnover*, not concurrency.
3. **Dropping the sizing gate added nothing at the loosest corner** — zero frontier items
   are priced above one-third of working capital. The design's "+68" parenthetical
   measured the sizing gate's headline count at the *current* config; at the loose corner
   every one of those items fails something else too. The instrument's frontier and the
   operator's fundable set differ by rule, not by population, today.

**Thinness, re-confirmed on the honest population**: union median volSide **43/h**, and
97 of 171 under 100/h. The capture probe (§5 of the design, ratified as gating the right
to rank) is not optional machinery — more than half the frontier lives where the fill
model has never been observed.

**Time-of-day is a real dimension**: today's config funds 13 at 22:00Z and **5** at
10:00Z. Any per-cell reading that pools across hours pools populations that answer
different questions; cell rollups carry an hour-band split from birth (the same lesson as
the overnight/daytime case law, inherited at design time instead of discovered later).
