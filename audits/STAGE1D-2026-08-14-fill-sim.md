# Stage 1d — the fill sim on the frontier

2026-08-14 · build session. Suite at close (post-rulings, §9): **PROBE-PASS — 1,055
assertions, 357 requirement ids asserted, pairing clean both directions.** Deployment
check (post-rulings): **DEPLOY-OK — 804 trips (134 frontier items × 3 participation × 2
ruled horizons) opened on the first real bucket, 1 second after a real boot.** Tree
uncommitted per standing practice.

> **§6's proposals were RULED the same day — see §9 for the ratifications, what they
> changed, the ratification-red evidence, and the five further seeds (AF–AJ).** §6 is
> kept as written because it is what the rulings ruled on.

---

## §1 What was built

**The trip layer.** Trips per (item × participation {25, 50, 100%}) at the ruled 6h
horizon, opened at the funded edge — every item at least one grid cell funds this cycle —
and shared across cells by a `cells` membership array stamped at birth (a cell that
starts funding an item mid-trip joins at the next reopen: its own simulated placement
could only have happened at the cycle it first funded). One rolling cycle per (item,
participation): close, then reopen if still funded.

**The capture probe is three lifecycles per trip, not three readings of one.** Capture
moves how fast the buy completes; buy completion anchors the sell window; the sell
window decides the outcome. So each capture point {0.05, 0.15, 0.30} runs its own legs
(`vars`) against the same tape, and within each lifecycle the three reach readings
accrue as bounds (proven / operative / possible — the paper book's bracket, unchanged).

**The shared fill core, extracted pure.** `fillCredit(px, mine, vol, side, touched,
capture, part)` is the credit arithmetic with capture and participation as ARGUMENTS —
the 1a purity surgery applied to the fill tier; `reachCredit` is the paper book's
binding of it (one implementation, N configurations). `obsAccrual`, `sellBucketEligible`
and `sellWindowStart` are the other named terms both sides now route through; each is
asserted at the term, where no clamp exists to absorb it.

**What transfers unchanged:** the causality rules (a bucket credits only if it began at
or after the leg was placed; deferred credit on bucket roll; once per bucket per leg per
lifecycle; no resolution in the opening cycle), the observation discipline (capped
accrual; the observed-share floor's three named states — counted / insufficient
observation / unobserved hole — with `SHADOW_MIN_OBS` as the one shared constant),
forced exits priced at the horizon (the last observed bucket value, readable only within
the observation cap — the same ±2-bucket tolerance `seriesPxAt` applies), and the
provenance stamps. **What deliberately does not:** cohorts, cooldowns, open caps,
eviction, schedule horizons, operator sizing — sampling rules for a capped book; an
exhaustive instrument does not sample (design §6).

**Storage.** DB v3 adds two IDB stores inside the constitution's named exception ("the
archive, **its trip ledger**, and the reconciliation-diff ledger"): `t1` — closed trips,
numeric keys, 30-day retention, **rolled into econ before pruning**; `t1open` — the open
map as one carry record, written per tick, read once at boot, so a reload resumes open
trips instead of silently discarding their observations. A frontier arriving before the
carry loads is HELD and run on load (`t1RunPending`); a held pass does not consume its
bucket — the M154 property built in from birth on this layer's own guard, and seeded.

**Econ rollups.** Per cell, keyed `h6|p50|c15|fv1` — horizon, participation, capture and
fill-model version all in the key, so pooling across any stamp is structurally
impossible. `n` counts only observed, counted trips; `insuf`/`unobs`/`vbl` sit beside it,
never inside; nets at all three bounds (`net`/`netS`/`netL`, never averaged — the schema
is asserted as an exact key set); streaming top-trip net for concentration; pump and
chart-coverage decompositions. The import carry sanitizes econ and drops any key missing
a stamp.

**Blacklist vs pump — opposite treatments, both ruled.** No trips on blacklisted items,
ever: the frontier assembly is the single owner of the promise, and blacklisting an item
MID-trip voids its open trips at that cycle (`voided-bl`, no nets, counted per cell as
`vbl`). Pump flags: stamped at birth (`pump: 1`), never excluded, decomposed in every
econ bucket (`pumpN`/`pumpNet`) — the calibration-tripwire pattern's raw material for 1e.

**The capture probe's verdict terms** (`scorerCaptureVerdict`, `scorerRankGate`,
`scorerCellEconState`) are read-time pure functions over the econ buckets, STAGED for
1e's surfaces (named consumers: the cell verdict line and the ranking panel) and
asserted directly meanwhile. If rankings flip across the capture points the verdict IS
**"insufficient calibration to rank"** — rendered as the verdict, never a caveat.
Ranking requires all three disqualifiers clear: beats the control at the PROVEN bound at
every capture point (full fail set — one reason per failing point, seeded against the
first-fail regression), concentration, and capture-stability. ~~Top-trip share withheld
where net is not positive; the ceiling an unruled argument~~ — **superseded same day by
the §9 rulings: the ceiling is RULED at 0.5 and measured as the top mover's share of
GROSS movement, measurable on losing cells; a readiness disqualifier ("cannot rank
yet") precedes everything until capture is graded.** This paragraph is kept as the
pre-ruling record; §9 is the current state.

**Chart wiring did NOT land this stage** (HANDOFF said "here or later"; later). The
pinned era fact — `marketStatsFor().tr === null` inside `[R76.9]` — is still green and
still armed; every trip stamps `noChart: 1` today, so when the wiring lands, the
transition decomposes at both the cell layer (`fundedNoChart`) and the trip layer
(`ncN`), and the tripwire will force that stanza. **Reconstruction from T0 is deferred
with its reason on record:** the archive accrues only while the app is open, so a
closed-browser gap has no archive to replay — the honest treatment of such a gap is an
unobserved hole, which forward accrual already produces; T0 replay's real use is
retroactive evaluation of a config added later, which lands with 1e's read paths.

---

## §2 Conformance stanza (deltas against the ratified map)

- **BINDING touched:**
  - *Never pool* → econ keys carry all four stamps (`[R78.6]`, `[R78.13]` seeded); pump
    and coverage decomposed per bucket (`[R78.9]` seeded both halves); the capture
    verdict never mixes points (`[R78.11]`, seed K1).
  - *No trips on the veto* (row 23c) → `[R78.2]`/`[R78.2b]`, the discriminating
    extension of the R76.10/10b pair: seed A turned R78.2 red **with both canary
    assertions green**, which is the two-detector separation the row demanded; the
    mid-trip void seeded separately (seed B).
  - *Simulation information horizon* → scan 11 run at this boundary, §4 below: 20
    points enumerated, 0 findings, 1 stated approximation.
  - *Correct parts do not compose* → the boot carry's hold (`[R78.12]`, seed L is the
    R76.11 seed shape on this layer's own guard); `obsAccrual`/`sellBucketEligible`
    wiring asserted into BOTH ticks by source scan; the deployment check crossed the
    whole seam on the real network.
  - *A component reports nothing where it should report it HAS nothing* →
    `scorerCellEconState`'s three named states (`[R78.11]`, seed K3); the three
    exclusion states rolled under their own names (`[R78.7]`, seed H); `t1FailNote`
    names unobserved trip time (`[R78.14]`, seed O); carry-load failure warns
    immediately as UNRECORDED holes; the freshness panel carries the layer's own
    scheduled stream.
  - *An ordered chain reports position* → `scorerRankGate` emits full fail sets from
    birth (seed K2 proved the first-fail regression bites); first-fail nowhere in the
    schema.
  - *Metric honesty / claims-vs-computation* → the R47.5 caveat moved inline where the
    bound is read (M155 — a live catch, §5); the neither-fits copy now names the band
    that actually decided (`relBand`, not the retired constant); the transition report's
    false "not doing any harm" claim is structurally gone (direction flip, §3).
  - *Data nothing reads* → `t1open` is written and consumed (boot); `t1` rows and the
    econ buckets are **STAGED** for 1e (named consumers: the drill's trip rows; the cell
    verdict/ranking surfaces), reported per the amended scan-2 rule and to be re-reported
    every audit until consumed.
- **Detectors same commit:** every surface this stage added (trip layer, econ, carry,
  verdict terms, freshness stream, R47.5 inline line, discriminator repairs) landed with
  its assertions in the same tree; REQUIREMENTS §78 rows and the probe block ride the
  same commit; the partition register gained six rows in the same tree (map §2).
- **Seeds: 26, all discriminating, log complete, no unknown-status entries** (§5).
- **Scans at the boundary** (§4): information horizon (11) with its enumeration; pooling
  (8); silent-state (2) with the staged-store report; claims-vs-computation (7);
  interrogability (5) obligations named for 1e; scan 14 over the new labels; scan 16
  semantics on the one new chain-shaped thing.
- **DOCTRINE by inspection:** staging practice — accrual ships ahead of its 1e readers
  with the clock's fine print stated (trips accrue only while the app is open; econ
  outlives the t1 rows and the difference is declared at read time); zero-based
  complexity — no new surface, one freshness row in an existing panel, zero walk-up
  cost; superseded machinery untouched (the paper book stands, still unretired, now
  sharing the extracted core the way the live chain shares the gate core).

**The era-fact tripwire:** not tripped. `marketStatsFor().tr === null` is asserted green
inside `[R76.9]`; `fundedNoChart === fundedItemCycles` still holds on every cycle; the
stanza that clears the red belongs to whichever stage lands the chart wiring.

---

## §3 The 23 TRANSFER dispositions (+ the 5 SPLIT halves)

Each census finding, what landed, and its proof. "Term" = extracted named function
asserted directly.

| census | disposition | proof |
|---|---|---|
| 2505 obs-accrual cap | `obsAccrual` term, both ticks route (source-checked); asserted against the CONSTANT at a 30-min gap | seed Q — term red while the old tick assertion stayed GREEN over the missing cap, the census's blindness shown live |
| 2519 capture-capped credit | label narrowed to what the clamped reading can see; the volume-weighted claim rests at the term | rides seed R family |
| 6052 bracket at binding scale | bracket asserted at the term at v=1e6 — the term has no qty input, nothing absorbs it | seed R |
| 3701 at-bid brackets | relationship on the SAME call's return (`oper = floor(lenient×part)`), scaling, floors named non-binding; fixture expectations now from production calls | seed R |
| 5976 same, second site | scaling companion for the operative term | seed R |
| 4994 no-data bucket | mixed-series fixture (2 data + 2 empty buckets, qty unclampable): credit only from data buckets, span covered; empty-series case renamed to what it tests. **The census's proposed production change was found unnecessary** — the `v>0`/`px!=null` guards already deliver the property; only the probe was blind | seed V (both guards dropped as one seed for one property — red alone) |
| 4963 dead state guard | deleted; `shadowRecover`'s open-filter owns the promise, stated there; census confirmed no probe caller passes closed trips (scan 13) | deletion of dead code — no behaviour to seed; the ownership comment is the record |
| 4991 impossible fixture | hzH 9.5 (a real schedule gap), realistic bid/ask — the trip stays open for reachable reasons | fixture repair; assertion unchanged, still green |
| 5461 three readings by value | `buyQStrict` stamped in the fixture; VALUE asserted; absent counter exports null, never 0 | seed Y — red alone; the old `in`-test provably could not see it |
| 5649 once-per-bucket behind the clamp | no-duplicate-bucket-timestamp assertion at the pre-clamp trace | seed AB — red alone while the clamped `buyQ === 10` stayed green over a double-write |
| 2543 sell eligibility unreachable guard | `sellBucketEligible` term, both ticks route; five states asserted at the term | seed AC — term red alone while the tick-driven assertion stayed green (the ordering delivers it there), exactly as the census predicted |
| 6536 sell-window anchor | `sellWindowStart` named term; credits-nothing-before driven by a reachable pre-anchor print | seed T — anchor moved to `buyAt` → red, with real cascade across the sell-leg family |
| 6716 stale: dilution w/o spread | spread passed as production sends it; `relBandPct`/`spreadPct` by value; NaN and zero-spread claims forbidden in the why-copy | seed U1 |
| 6749 stale: sustain bar | sustain isolated at low spread; proportionality shown at high spread | seed U1 |
| 6753 stale: neither-fits | spread passed; **production fix**: the unclassified why-copy now names the band that DECIDED (`relBand`), not the retired constant; the no-spread call named as the fallback path in its own assertion | seed U1 |
| 6812 stale: frozen threshold | freeze asserted on the LIVE spread-relative band (does not track `GATE.roi`); absolute constant checked as the named fallback | seed U2 — red alone; the old form provably could not see the live band |
| 6827 tautological report | **direction flipped with the ratification**: `sellShapeReport` compares live vs the classifier's own `absCls` (the retired band — the transition ledger); `sellRelClassOf` deleted (the second implementation); export fields renamed (`classUnderRetiredAbsoluteBand`, `retiredAbsoluteBandWouldDiffer`); cases reach the report only through the classifier | seed U3 recreated the exact tautology — both re-pointed assertions (R59.6, R66.3) caught it |
| 2528 pre-clamp trace | the divergence half: on an ambiguous bucket `credited` carries the operative reading and `full` the lenient one — the one bucket class where they differ | seed AE — red **alone**; every other trace assertion sat on the beyond branch where the readings agree |
| 6838 pooled split | negative match forbidding a combined cross-population count | seed AA — red alone; old positive-only form would have passed (tenth-face discrimination). Full container-scoped absence deferred to 1e's drill rework, stated |
| 7181 unreachable window inputs | census disposition (a) taken: the standing scan-13 note IS the record; the reachable half is exercised; no change | on record here |
| 7461 bounds pair midpoint | absence half added: no averaged field in the return, no midpoint copy on the surface | seed AD — red alone |
| 4928 per-row stamps | row-scoped match via each row's own drill key; the fixture's v1/v2 rows are each other's decoys; property also lands as trip birth stamps (`[R78.1]`) | seed X — a stray badge in every row turned ONLY the scoped form red; the old whole-section form passes over it |
| 6511 caveat in a footnote | teach-stripped container; **production fix**: the load-bearing sentence renders inline beside the bounds table | **live catch** — the scoped form went red on the real panel in run 1, green after the fix (M155); per the seed-artifact ruling the run-1 report is the bite's proof |

**The 5 SPLIT property halves:** 4411 → the three named exclusion states at the trip
layer (`[R78.7]`, `SHADOW_MIN_OBS` shared — one home for the constant). 4479 → the
capture probe's verdict is the property generalized: thin evidence can never argue
(exclusions never enter `n`; unstable rankings void the instrument's right to rank,
`[R78.11]`). 7402 → `sellVerdictOf` extracted and branch-driven (seed U4 — under which
the OLD whole-panel form would have stayed green off the boilerplate span). 4447 (excluded
counts open to trips) and 5908 (a 100% rate renders its zero-counterexample claim) are
**1e obligations, restated here so 1e's gate re-checks them.**

---

## §4 Scans at the boundary

**Scan 11 — information horizon (the stage's own scan). 20 points enumerated, 0
findings, 1 stated approximation.**

Credit paths (7): paper tick buy · paper tick sell · reconReplay buy/sell ·
calibReplaySell · calibWindow/calibRowFor buy · **trip-tick buy per capture lifecycle** ·
**trip-tick sell per lifecycle**. Each: read bounded by the modelled moment (wall-open /
per-lifecycle `buyDone` / named window term), each bucket consumed once (guards seeded),
and the 5m-average-as-interval approximation carried as the proven/possible bracket with
Fault A on the contamination register — the interval statistic is never read as the
interval; it is bracketed, which is the ruled treatment.

Replay windows (3): shadowRecover's clamped window (≥ `reconWindowStart`, beyond-retention
unobservable by construction) · calibReplaySell's `[sellWindowStart, +H]` · **the trip
layer's absence of one** — no reconstruction path exists at 1d, and the deferral is
itself the honest horizon statement: no read happens (reason in §1).

Anchors, exits, attribution (10): paper forced exit and partial at `seriesPxAt(hzAt)` ·
**trip-variant partial/forced exit at the last observed bucket value, readable only
within `SCORER_OBS_CAP` of the horizon** — the stated approximation: equivalent to
seriesPxAt's own ±2-bucket tolerance, coincident with it on a perfect host, stamped
`exitApprox` on spot fallback · **the filled lifecycle's proven-remainder mark at the
last observed value at close** · calibration's self-comparison anchor (now inline, M155)
· `stampPrediction`'s open-time facts · **the funded-edge open: the bucket that fed the
decision can never credit the fill (`bkt ≥ p.t` with wall-clock `t`)** · **hour
attribution to the open BUCKET's hour** (R76.5 inherited) · **cell membership at birth**
(a late-funding cell joins at the next reopen) · rdiff's three-state plan side · **the
verdict terms read no clock at all**.

**Scan 8 — pooling.** Econ keys carry all four stamps; pump/coverage decomposed; the
capture verdict never mixes points; nets at stated bounds only. One deliberate
within-key pooling: an econ bucket sums across HOUR BANDS. The decomposition source is
the t1 rows (each trip carries `hour`), and **1e's drill must open a cell's econ to its
trips with the hour split available and the beyond-retention truncation declared** — a
named 1e obligation, not a current render (nothing renders econ at 1d).

**Scan 2 — orphans and silent state.** `t1open`: written and consumed. `t1` rows and
`scorerT2.econ`: **STAGED** — readers are 1e's drill and verdict surfaces, named in the
schema register; per the amended rule these re-report on every audit until consumed. The
generator renders its own state (freshness stream + fail notes); never-fed vs
only-excluded vs counted named at the term (seeded); carry-load failure warns
immediately, naming the loss unrecordable.

**Scan 7 — claims vs computation.** New copy checked against what the code computes: the
fail note (unobserved trip time — seeded in both directions), the freshness row's label
("blacklisted items get none by rule" — the seeded guarantee), the R47.5 inline line
(at-price count computed in place), the verdict strings (computed from the flips/fail
sets), the neither-fits band copy (production fix, asserted with a negative match).

**Scan 14 — new assertion labels.** Swept the §78 labels and the repaired ones for the
four strong-claim classes. Universals backed by enumerated states: "no trip … ever"
(seeded end-to-end), "never inside n" (all three exclusion states rolled), "ONCE into
every birth cell" (16-cell equality + re-roll check), "admits no unstamped or averaged
figure" (exact-key-set assertion), "held, never dropped" (both halves driven). One
honest narrowing to note: `[R78.9]`'s "never excluded" is exercised through one of
`suspectedPump`'s three firing legs (thin-flow); the stamp reads the function's return,
so the claim is about the stamp semantics, not path coverage of the flag itself — the
flag's own legs are covered by its own §70 assertions.

**Scan 16.** One new chain-shaped thing: `scorerRankGate`'s disqualifiers. Full fail
set from birth; seed K2 proved the first-fail regression turns it red. No positional
attribution exists in the schema.

**Scan 5 — interrogability.** No new render this stage. Obligations named for 1e's
gate: cells → econ buckets → t1 trip rows (with the 30d-retention truncation declared
and the beyond-retention re-derivation path through T0 replay stated); the export side
gains econ with its rows when 1e's exports land.

---

## §5 Seeding log — 26 seeds, complete, no unknown-status entries

| seed | target | result |
|---|---|---|
| A — bl items leak into the frontier | R78.2 | **RED with R76.10/10b GREEN** — the trip-layer detector discriminates from the funding-layer pair; R78.2b/R78.7 propagation recorded |
| B — mid-trip blacklisting no longer voids | R78.2b ×2 | RED; R78.3/78.7 propagation (stale trips survive) |
| C — hour stamp dropped at birth | R78.1 | RED alone |
| D — once-per-bucket guard removed | R78.3 | RED; R78.7 propagation |
| E — pre-open buckets observed | R78.3 (pend causality) | RED; R78.7 propagation |
| F — sale tax dropped from the sold leg | R78.4 | RED alone |
| G — lifecycles collapsed to the reference capture | R78.6 | RED; R78.3/78.4 propagation |
| H — unwatched expiry files as "would not have filled" | R78.7 ×2 | RED alone — the hole-vs-data distinction is exactly what fails |
| I — pump stamp never applied | R78.9 ×2 | RED alone |
| J — a `netMid` field slips into the econ schema | R78.10 | RED alone — the exact-key-set catches an averaged figure |
| K1 — capture disagreement never voids the ranking | R78.11 (flip) | RED with the stable case green — the pair discriminates |
| K2 — rank gate reports only the first failing capture | R78.11 (fail set) | RED alone |
| K3 — only-excluded reads as never-fed | R78.11 (states) | RED alone |
| L — a held pass consumes its bucket | R78.12 | RED; 12b propagation (nothing opened to carry) |
| M — the carry is read and silently discarded | R78.12b | RED alone — discriminates from L |
| N — the econ import carry dies on restore | R78.13 | RED alone |
| O — the fail note claims "no fills" | R78.14 | RED alone |
| P — the t1 fixture clear skipped | R78.15 | RED alone (a probe-hygiene subject, seeded in the probe) |
| Q — obsAccrual cap dropped | R18.2 term | **RED while the old tick assertion stayed GREEN** — census 2505's blindness demonstrated live |
| R — ambiguous haircut dropped from the term | R18.5/R44.1 term + bracket | RED across the haircut family (term + existing tick assertions — real cascade) |
| S — the wrapper stops threading participation | R18.2 wrapper identity | RED (plus real family cascade) — the at-price identity fixture is what made it visible |
| T — sell window re-anchored at buyAt | R48.1 anchor | RED + real sell-leg cascade |
| U1 — the relative band becomes the whole spread | R59.1 ×3 | RED (R66.3/66.4 real cascade) — the repaired assertions read the band by value; the old ones never saw a spread |
| U2 — the live band tracks GATE.roi | R59.5 | RED alone |
| U3 — the transition comparison collapses to live-vs-itself | R59.6 + R66.3 | RED — the exact 6827 tautology, recreated and caught by both re-pointed assertions |
| U4 — the FALSIFIED verdict branch dies | R66.2 | RED alone — the old whole-panel form would have stayed green off the boilerplate span |
| AA — a pooled combined count renders | R59.4 | RED alone (old positive-only form passes — tenth-face discrimination) |
| AB — the same bucket written twice into the trace | R43.2 (pre-clamp) | RED alone while the clamped reading stayed green — census 5649 shown |
| AC — the completing-bucket exclusion dropped | R43.2 (term) | RED alone while the tick assertion stayed green — census 2543 shown |
| AD — the bounds pair grows a midpoint | R67.1 (absence) | RED alone |
| AE — trace `credited`/`full` swapped | R59.7 (divergence) | RED alone — every other trace fixture sits where the readings agree |

*(A–AE with K1–K3 and U1–U4 = 26 runs, one seed per run, restore-green verified between
each; final run PROBE-PASS 1,052.)* **Plus one live catch counted separately:** the
R47.5 scoped repair failed on real production output in this stage's first suite run and
greened only after the production fix — per the seed-artifact ruling, that run's report
is the proof (M155).

---

## §6 Proposals — for ruling, nothing applied

### 6a. The horizon set, ruled together with participation

**What stands:** one measurement horizon, 6h, transferred from the paper book. **What is
proposed: add a 9.5h variant** — trips per (item × participation × horizon), a new `h9.5`
econ key by construction (no pooling possible).

Measured backing available today:
- **Stage 0 (two snapshots):** the control config funds **13 at 22:00Z vs 5 at 10:00Z**
  — funded sets concentrate in the evening; frontier churn 109/89 with intersection 27.
- **Live (this stage's deployment check, 17:25Z):** control funds 5; frontier 115; the
  loosest cell funds exactly the frontier (the nesting made visible on real data).
- **The routing case law's own finding:** the gap band's +399k/−219k sign flip was a
  HORIZON finding. A fixed 6h horizon cannot see what a 9.5h sit finds, and the items
  the evening concentration funds are precisely the ones a 6h window measures least
  fairly.
- **Occupancy cost, measured:** 345 concurrent trips today (115 × 3). The variant
  doubles that to ~690 trip objects (memory-trivial), doubles econ keys per cell (9 →
  18; tens of KB), and adds no walk-up cost (nothing renders rulings). The real cost is
  interpretive: the same tape read under two horizons is correlated evidence, and 1e's
  surfaces must group by horizon, never pool (already structural in the key).
- **What I could not measure from the desk:** the accrued hour-band data in `scorerT2`
  lives in your browser's localStorage; it will be readable at 1e (or via export). The
  proposal does not depend on it, but the ruling could wait for it if you prefer
  bands-first evidence.

**Participation:** propose keeping {25, 50, 100%} as ruled. One honest observation for
the ruling: participation differentiates credit only on AMBIGUOUS buckets (at-price or
live-touched), so on beyond-heavy tape the three levels will read identically — that is
the model being honest about where participation matters, not a defect; the levels cost
three trips per item and are the only handle the probe has on the queue-position
question.

### 6b. Capture calibration status — stated plainly

**The instrument cannot validate any capture point yet, and nothing implies otherwise.**
What the three-point probe CAN do from birth: detect whether cell rankings depend on the
ungraded constant — and when they do, the verdict is "insufficient calibration to rank",
rendered as the verdict. What it CANNOT do until real flips exist inside the tape window
on frontier-class items: say that 0.15 (or any point) is right. The calibration harness
grades capture only against your own realized flips, which are watchlist-class; the
frontier's thin items have zero realized evidence, so **their absolute nets are
unobtainable (Q3) and the instrument's output is comparisons at stated bounds, ranked
only when rank survives the probe.** The b=100 corner stays deferred on exactly this
(ruled), and the first realized flip on a frontier-class item remains the only path to
grading capture there.

### 6c. The concentration ceiling — a constant that needs a ruling

`scorerRankGate` takes the ceiling as an argument; no value exists in code. **Proposed:
0.5** — a cell whose top trip exceeds half its net has effectively measured one trip
(the gap-band incident's 103% top-share is the founding case; at 50% the top trip
outweighs everything else combined). Applies at 1e's render only after your ruling.

---

## §7 The deployment artifact (M154's lesson — one real artifact from the real schedule)

Real network, fresh headless profile, the real boot path. **DEPLOY-OK at 1 second:**
the first real bucket (17:20Z) was archived (T0), scored (16 cells), diffed (rdiff) and
**trip-opened (t1) in the same pass** — the boot catch-up chain proven end-to-end
through the new layer. The artifact:

- **345 open trips = 115 frontier items × 3 participation levels**, all persisted to the
  `t1open` carry (`carryN: 345`).
- Sample trip, fully stamped at birth: item 4708, part 0.25, `hzH 6, fv 1, v 1, sz
  "lim1"`, open bucket 17:20Z (`hour: 17`), 4 funding cells, qty 15 (its buy limit),
  bid 403,655 / ask 421,424, `pump 0, noChart 1, grade "live"`, three capture
  lifecycles `[0.05, 0.15, 0.3]` all open.
- Per-cell funded counts at 17:25Z: control 5 → loosest 115, monotone with the grid —
  the nesting argument visible on live data; `blFunded 0` on every cell (fresh profile,
  empty blacklist — reported plainly, not as evidence).
- **Fills: none yet, correctly** — the first creditable bucket for a trip is the first
  that starts after its wall placement, so credit begins one to two buckets after boot.
  The check's scope was the ruled artifact: a trip simulated on a real bucket after a
  real boot. The check ran in its own headless profile; **your browser verifies itself
  on next open via the freshness panel, which should show FOUR streams with a first
  bucket within one poll** (archive, scorer, reconciliation diff, fill sim).

---

## §8 What did not happen, said plainly

- **Chart wiring did not land**; the era tripwire stands armed (§1, §2).
- **Reconstruction from T0 for the trip layer did not land**; deferral reasoned in §1,
  enumerated as scan 11's point of honest absence.
- **No surface renders any of this** — 1e's scope, on purpose; the staged stores are on
  the scan-2 re-report list until then.
- **Nothing was committed**; the tree carries the session per standing practice.
- **The concentration ceiling, the horizon set and the participation confirmation await
  your ruling** (§6); nothing in the code applies any of them.

---

## §9 RULINGS APPLIED (user rulings, Aug 14 2026 — same day, after §6)

All four §6 items were ruled; the last bullet of §8 is superseded by this section.

**1. Horizon set {6h, 9.5h} RATIFIED, participation {25, 50, 100%} confirmed.** Built:
`SCORER_HORIZONS = [6, 9.5]`; the trip key is now (item | participation | horizon), one
rolling cycle per key; the boot carry re-keys resumed trips by their own `hzH` (all
pre-ruling trips carry `hzH: 6`, so the eras cannot mix). The overnight comparison is
now a stamped population against a stamped population — `[R78.16]` demonstrates it: six
hours past the same open on the same tape, the 6h lifecycle has closed while the 9.5h
one is still accruing, and their econ can only land under different keys.

**2. Concentration ceiling RATIFIED at 0.5, measurement as specified.** Econ buckets
gained `gross` (Σ|net| terms) and `top` became the largest single MOVER (max |net|);
the rank gate disqualifies at top/gross > 0.5 with the share named in the reason.
Measurable on losing cells — the fixture proves a spread LOSING cell now CLEARS
concentration where the pre-ruling form withheld it, and seed AG showed the two
measurements genuinely disagree on the same winning cell (30% of gross vs 60% of signed
net). Rank-disqualifier only; nothing excludes data. The import carry and the exact-
key-set schema assertion carry `gross`.

**3. Capture status RATIFIED as the rendered verdict.** `scorerRankReadiness()` carries
the ruled words — **"cannot rank yet"**, the frontier-class dependency, the
calibration-flips-inside-the-tape-window condition — and the rank gate emits it first,
so an otherwise-clean cell under a stable ordering carries exactly that one reason.
`SCORER_CAPTURE_GRADED = false` is the pinned era fact (`[R78.17]`, staging practice's
fourth rule): the grading era cannot arrive without turning it red and forcing the
accounting.

**4. The three-lifecycle probe design recorded** in the design doc (§9 there) with the
causal reason — capture moves buy completion, buy completion anchors the sell window —
so 1e renders per-lifecycle figures without re-deriving why three lifecycles exist.

**The rulings are decision-logged in the tool** (`SCORER_1D_RULINGS_KEY`, once per
store, `auto: 1, by: "user"` — written by the tool, decided by the user; asserted).

**Ratification-red evidence (the standing practice):** applying the rulings before any
fixture updates turned FOUR assertions red — R78.1 (trip count 3→6), R78.2 (map size),
R78.2b (voided count), and the §78 block failed at the old key shape — so the behaviour
change was covered, not unobserved. Fixtures were then updated to the ruled behaviour
and the suite restored to green.

**Five further seeds, one at a time, restore-green between:**

| seed | target | result |
|---|---|---|
| AF — the 9.5h variant dropped from the set | R78.16 | R78.1/78.2/78.2b RED on counts and the block fails at the 9.5h fixture line (R78.16's subject gone) |
| AG — concentration regressed to the pre-ruling signed form | R78.11 | both R78.11 assertions RED — the same cell reads 30% of gross vs 60% of signed net, so the measurements demonstrably differ |
| AH — `SCORER_CAPTURE_GRADED` flipped true without a ruling | R78.17 | R78.17 + R78.11 RED — the era tripwire fires; grading cannot arrive silently |
| AI — the readiness state in words other than the ruled ones | R78.17 + R78.11 | RED — the "in those words" clause is enforced |
| AJ — the ruling decision-logged without provenance | R78.17 (log) | RED alone |

**Deployment re-run under the ruled set: DEPLOY-OK at 1.0s** — 804 open trips = 134
frontier items × 3 participation × 2 horizons, split exactly (h6: 402 / h9.5: 402;
p25/p50/p100: 268 each), all in the carry; the frontier read 134 at 18:00Z against 115
at 17:25Z — the churn visible across two real boots. Suite at close: **PROBE-PASS,
1,055 assertions, 357 requirement ids, pairing clean.** REQUIREMENTS gained R78.16 and
R78.17; the partition register and the design doc carry the ratifications.
