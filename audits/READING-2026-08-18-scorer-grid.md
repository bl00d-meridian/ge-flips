# Reading — 2026-08-18: the four-day grid, the cutover's remaining distance, and three closures

Answers the four-part ruling of 2026-08-18 against `inbox/analysis-scorer-2026-08-18.json`
(1,024 cycles, 30,581 closed trips, 16 cells, 3.9 of 7 observed chart days, capture
ungraded). **No constant moves in this pass.** §1 and §4 are reports and proposals; §2 is
preparation; §3 is the one build, and it shipped.

---

## Conformance stanza (the standing gate, stage 1e+)

**BINDING rules touched, each with its mechanical check**

| Rule | Check |
|---|---|
| A flag means one thing; provenance is its own field | `[R85.1]` — all three closures `auto:1, by:"user"`, seeded S1 (flipped to `"tool"`, one red) |
| Never pool across populations answering different questions | scan 8 over every figure below: **two findings**, §0.2 and §0.3, both reported rather than repaired in copy |
| Every statistic ships with its rows | scan 5 over the export: **one finding**, §5.1 (the carried trip window's selection rule is undeclared) |
| No claim about unobserved periods | rdiff coverage stated as observed/expected (§1.1); archive 851/864 |
| A component reports nothing where it should report it HAS nothing | `[R85.3]` — `scorerConcNote`'s NOT-DERIVABLE state renders as a disclosure, seeded S6 |
| Data nothing reads is a defect (STAGED exception) | scan 2 re-report: **`rdiff` is still STAGED and this is its second re-report** — §1.1 |
| Metric honesty — copy claims exactly what it computes | scan 7 over the export header and the new entries: **one finding**, §5.1 |
| An ordered chain reports position, not cause | not chain-shaped; the grid evaluates every cell independently |
| Assert the term; name the pinning input | `scorerCountPair` / `scorerConcNote` / `scorerCitedCaveat` extracted; assertions call the terms. No clamp sits on any asserted subject here |
| Every new assertion proven by seeding | **8 new assertions, 8 seeds, all discriminating, one at a time, restore-green between** (S1–S8; S4/S6/S7 each aborted once on precondition 1 — the driver refused to run a substitution that had not applied, and the pattern was corrected before any result was read) |

**Detectors shipped in the same commit as the surfaces they watch.** §85 rows and
`[R85.1]`–`[R85.3]` land with `scorerClosuresLog`.

**Schema decisions — the partition question at birth.** No new store. The closures are
`DB.decisionLog` rows in the existing shape; the regime that writes them is the tool
(`auto:1`), the judgment is the user's (`by:"user"`), and a later closure appended to
`SCORER_CLOSURES` reaches a store that already carries the earlier ones because the guard
is **per subject** (`[R85.1]`, seeded S2 against a sentinel guard). **One partition
question IS raised by §4.2 and is unanswered by design** — see there.

**DOCTRINE satisfied by inspection, listed as inspection:** house convention (no strategy
parameter moved); advisory layers stay advisory (nothing here arms anything);
arithmetic-on-the-constants (§0.3 and §4.2 are both instances of it).

**Suite:** `PROBE-PASS — 1,108 assertions, BOTH viewports, pairing clean both directions
(393 tags / 405 rows / 393 cited).` Baseline before the change was 1,100.

**Tree state: uncommitted.** Nothing was committed or pushed — pushing `main` is
publishing, and that is your press.

---

## §0 · What I verified of the stated readings, and two places it needs refining

Every stated reading reproduces. Two need a sharper statement, and both matter to §4.1.

**§0.1 — confirmed exactly.**

- **Control ranks #1 in all nine h6 keys at the proven bound.** Verified; no cell at any
  looser `taxMult` beats it in any h6 horizon × participation × capture combination.
- **h9.5 is the cannot-rank case.** Control ranks #1 in all three `c15` keys and #2 in all
  three `c5` and all three `c30`. Correctly not read as a finding.
- **Concentration runs 6.6–37.2% across all 16 cells × 18 keys.** Nothing approaches the
  0.5 ceiling; no cell is disqualified.

**§0.2 — the taxMult claim is STRONGER than stated; the volume-base claim is NARROWER.**

The `taxMult` ordering `m3 > m2 > m1.5 > m1 > m0.5` holds at **18 of 18 econ keys** — not
just across the three capture points but across both horizons and all three participation
levels. Not one key inverts it. That is the strongest invariance anywhere in this grid.

The volume-base claim needs splitting, and the never-pool rule is what forces it:

| horizon | m3-block ordering by proven net | verdict |
|---|---|---|
| **h6** (9 keys) | `b1000 > b500 > b250` at **all nine** | **stable** — no flip anywhere |
| **h9.5** (9 keys) | `c5`: `b250 > b1000 > b500` · `c15`: `b1000` leads, 2nd/3rd swap by participation · `c30`: `b500 > b1000 > b250` | **unstable** — a different ordering at each capture point |

"Flips at every capture point" is true only when h6 and h9.5 are read as one block — and
they are two stamped populations that must never pool. **Read per horizon, the volume-base
axis is stable at h6 and unstable at h9.5.** This changes the wording §4.1 has to propose:
an axis-stability verdict is not a property of an axis, it is a property of an
(axis × horizon) pair.

**§0.3 — "the economics are indistinguishable from control" is a POOLED reading, and the
decomposition says something else.** The b500 cell's funded set strictly contains the
control's at every cycle (both are `taxMult 3, roi 1.2`; only `volBase` differs, and the
volume floor is monotone in it). I verified the containment on the data: **195 of 195
trips naming the control also name b500, zero violations.** That makes `b500 econ minus
control econ` an exact field-by-field decomposition of the added population. It reads:

| | shared (= control) | **marginal (b500 − control)** |
|---|---|---|
| proven net, all nine h6 keys | −1.3m … +70.5m | **negative at all nine**, −0.46m … −1.06m |
| proven net, h9.5 | | negative at 6 of 9; positive only at all three `c30` |
| trips | 327–401 | **199–253 — 37–39% of b500's trips** |
| gross movement | | **2.7–11.7% of b500's gross** |
| fill rate | 6.7–12.5% (48–66 unfilled) | **10.4–19.1% (28–35 unfilled)** |

The marginal items **fill more often and move four to fourteen times less money per trip,
and their proven-bound net is negative in 15 of 18 keys.** That is the thin-book signature
stated exactly. The cell total looks near-control because the shared population dominates
it, not because the added items behave like the control's.

This does not overturn "under 4% at the cell level" — that figure is correct as a *cell*
figure. It says the cell figure is a pooled one, and the population the proposal is
actually about is the 38% of trips carrying 3–12% of the money at a negative proven net.

---

## §1 · The cutover gate — remaining distance

### §1.1 Reconciliation history: **not explained, and not currently explicable**

**Nothing has ever read an rdiff row.** `t0Keys("rdiff")` reads *keys only* — for the
count and the first bucket. No code path anywhere reads a row's `extra`, `plan`,
`missing` or `planWhy`. The export carries `{rows, firstAt, note}` and no rows. The
scorer surface's named-disagreements window renders `S.scorerRdiffLast`, an in-memory copy
of the **current cycle**, never the store.

So the honest answer to *"is the history explained?"*: **1,017 rows written, 0 rows read,
0 classified, and there is no path by which they can be.** The classification breakdown
you asked for cannot be produced from any artefact that exists. This is the store behaving
exactly as ruled — STAGED, its reader is the cutover gate — but the gate cannot consume
what has no reader. **Scan 2 re-reports it STAGED for the second audit running.**

What IS known, and it is good news for the ledger's quality:

| | |
|---|---|
| rows | **1,017**, first bucket 2026-08-14 18:25Z |
| wall window to export | 95.56 h = **1,147** five-minute buckets |
| **observed coverage** | **88.7%** — 130 buckets (10.8 h) have no row, and are unobserved, not empty |
| observed time recorded | 84.75 h = **3.53 days** of actual observation |
| scorer cycles over the same period | **1,024** — a **7-row gap** against the diff |

**The 7-row gap must be resolved, not assumed.** The benign explanation (the scorer's
first cycles predate flag 3's first write; both shipped 2026-08-14) is plausible and
untested. The alternative — `rdiffAccrueSafe` is fire-and-forget, so a tab closed between
the score and the IndexedDB write drops the row silently — is equally consistent with the
data and would mean the ledger under-reports at an unknown rate. Seven rows is nothing;
seven rows of *unexplained* is a coverage claim nobody has checked.

**Remaining distance on this limb — four items, in order:**

1. **Build the rdiff reader.** Smallest sufficient form: an `analysis-rdiff` export on the
   existing analysis bus (read-only builder, declared truncation, rows riding with the
   number) plus a drill on the scorer surface. Without it there is no classification pass,
   only an assertion that one happened.
2. **Fix the classification vocabulary before classifying.** Two classes were ruled —
   *extraction defect* and *understood difference*. The data needs a third, and it is
   structural rather than discretionary: the poll runs `scorerCycleSafe()` at one point and
   `accrueBackground()` (which builds the plan and stamps `S.lastPlanPicks`) twenty lines
   later. **Every rdiff row therefore compares the control's pass set at bucket _T_ against
   a plan built at bucket _T−1_.** That affects the `missing` side only — `extra` compares
   against watchlist *membership*, a persisted set, and is unaffected — but it means some
   `missing` rows are neither a defect nor a durable difference; they are one poll of price
   movement. Call it **timing**, and size it before reading the other two, or it inflates
   whichever class it lands in.
3. **Classify, with the plan-side three-state reported first.** `plan: null` rows are
   unobserved, not agreement. The breakdown opens with observed / never-built / stale
   before any disagreement count, or the denominator claims a comparison nobody made.
4. **Then the verdict-level history.** The gate as ruled, and the last step, not the first.

### §1.2 The integration audit: **it can run today, and it is already owed**

The last integration audit was `AUDIT-2026-08-13b` (first run of scans 10 and 11). Five
build sessions landed on 2026-08-14. **Under the standing discipline — run after any week
containing a build session — an integration audit is overdue independently of the
cutover.** It needs nothing it does not have.

What it needs *for the cutover specifically* is the one thing it cannot have yet: **the new
surfaces do not exist.** The gate's audit limb is blocked on the build, not on data or
tooling. Nothing else blocks:

- **Scans 1–13 and 16 can all run now** against the current tree.
- **Scan 14 has never been executed.** It is written into the constitution and has never
  run. It should run **before** the adversarial pass, not after, because it will re-scope
  it: its own founding examples include `[R4.3]` — *"intel cannot touch blacklist / reserve
  / gate constants"*, a universal tested against one record type — and `[R4.3]` sits
  **inside** the cutover-critical set (§1.3, ring B).
- **Scan 2's staged list** must re-report `rdiff` (done, §1.1).
- **Scan 9's clamp enumeration and scan 13's fixture enumeration** both need extending over
  §78 / §80 / §84, which landed after their last runs.

### §1.3 The adversarial pass: scope and count

The `[R7.3]` standard is *prove the guard red before trusting it green* — from `R70.1`,
where the pump guard's own named assertion was pinned by a different conjunct and deleting
`!pump &&` left the whole suite green.

**The seam is one line.** `planCandidates()` is `return DB.watch.map(candidateFor);`. The
cutover replaces `DB.watch` with the control cell's pass set. Everything downstream reads a
candidate built from a watch row. That gives three rings.

**Ring A — the seam itself. Exact: 16 assertions**, enumerable by tag.

| tags | n | what |
|---|---|---|
| `[R74.1]`–`[R74.5b]` | 6 | the one evaluator, its purity, and that the live chain routes through it |
| `[R76.1]` `[R76.2]` `[R76.6]` | 3 | the grid's shape, population identity by config hash, the import re-derivation |
| `[R77.1]` `[R77.1b]` `[R77.2]` `[R77.3]` | 4 | the reconciliation diff, both directions, its three-state plan side |
| `[R84.6]` | 2 | one evaluator owns the comparisons; `marketGateFails` derives |
| `[R84.4]` | 1 | the rdiff line's named disagreements |

**Ring B — the starved overlays. 56 candidates** (45 tagged, 11 untagged, spanning 25
requirement sections), from a stated mechanical rule: **every assertion whose label names a
guard that reads a watch row, the flip log, or operator state** — because those are
precisely the inputs a control-cell item does not have. Thirteen named guards: blacklist ·
proven-loser bench · exception lane and probation · seasoning and qualification streaks ·
the wins waiver on the volume floor · tested prices · tier override and the untiered bench ·
manual qty and sizing · inventory mode and the mm bench · the family rule · the drift bench ·
fill history · the three chart gates plus no-history / chart-still-loading · pump caution ·
cluster caps · exposure and working capital.

**The grep produces candidates; the read is the work** — the same shape as scan 14, and the
enumeration is the deliverable. Every one of these 56 is at risk of exactly what `R70.1`
names: still green after the cutover, on a fixture that supplies a watch row, covering a
path production no longer takes. That is *"a ratification that breaks no test is not
evidence"* with the arrow pointed at a whole ring.

**Total in scope: 72 of 1,108 assertions** — 16 certain, 56 candidates.

### §1.4 The limb that is not in the gate, and should be

**The control cell's verdicts are SIX-GATE verdicts. 9,271 of 9,313 funded item-cycles —
99.5% — carry `fundedNoChart`.** `marketStatsFor` returns `tr: null, vt: null,
moState: null` by construction, because chart inputs need the T0 h1 archive and it stands
at **3.9 of 7 observed days**. Sparks are a per-item `/timeseries` fetch and a
watchlist-scoped resource; there is no universe-wide substitute until the archive matures.

The live plan chain has three chart gates plus two history gates. Switch the pool today and
exactly one of two things happens:

- every scorer-pool item benches on **"chart still loading"** — the plan funds nothing; or
- the chart gates are skipped for pool items — which **widens what the allocator may fund**,
  silently, by three gates. That is deployment-class by the constitution's own definition
  and cannot ride along inside a pool switch.

**So the cutover has a fourth prerequisite, and it is a clock rather than a task: chart
gates at 7 of 7 observed days.** It is listed in the handoff as its own item and is not
currently named as part of the cutover gate. It should be. The pinned era fact
(`marketStatsFor().tr === null` inside `[R76.9]`) goes red when the wiring lands and forces
the accounting — that machinery is correct and armed; what is missing is the statement that
the pool switch depends on it.

### §1.5 Distance, summarised

| limb | state | blocked on |
|---|---|---|
| Reconciliation history explained | **not started; not currently possible** | build the rdiff reader → size the timing class → classify → verdict-level history |
| Integration-audit walk | **can run now for everything except the new surfaces** | the surfaces existing. Scan 14's first run should precede §1.3 |
| Adversarial pass, `[R7.3]` standard | **scoped: 16 exact + 56 candidates of 1,108** | scan 14 (it re-scopes ring B) |
| **Chart gates at 7 of 7** | **3.9 of 7 observed days** | the archive's clock — app-open time only |

**The expansion you name is real and is the largest number here.** The control cell — your
exact current config over the whole universe — funded **9.09 items per cycle** and touched
**292 distinct items** in four days, while the watchlist (43 items at the last state backup)
passes 0. Nothing is wrong with the gates. The gap is admission, and it is larger than any
constant in the grid: no cell at any setting produces a change of that size.

---

## §2 · Volume base 1000 → 500: probation preparation

### §2.1 What the export can and cannot support

**Cannot:** per-item volume, and per-item fill outcomes for the marginal population.

- The export carries `distinctEver` as a **count**; the id stock is not exported. The
  marginal roster is 141 items; trips observe **26 of them (18.4%)**, and names are carried
  for 22 (closed-trip rows carry `id`, not `name`).
- The 500 carried closed-trip rows are drawn from **2026-08-15 00:20Z–04:00Z** — 3.67 h,
  2.2% of the declared 7-day window — and **1,464 of their 1,500 lifecycles (97.6%) are
  `unobserved`**. They are not usable as fill evidence. See §5.1: this is an export defect,
  not a limit of the data.
- Volume is not a field on any trip row.

**Can, and exactly:** the volume *interval*. The two cells differ only in `volBase`, so an
item in one and not the other has min-side 1h volume inside
`[volFloor(500,px), volFloor(1000,px))`, where
`volFloor(base,px) = max(4, round(base · min(1, 2000/px)))`. Exact by construction, not an
estimate.

**Every row below is read from a trip whose own `cells` include `m3/roi1.2/b500`** — the
item's economics at a cycle that cell actually funded it. (My first pass took each item's
first trip regardless of membership and produced wrong prices for four items; what caught
it was `Black d'hide chaps` appearing to fail the `m3` margin gate it was supposedly
inside.)

### §2.2 The marginal items — 26 observed of 141

`margin` and `ROI` are gate-side (`sell − buy − tax`, over `buy`); `need m3` is
`max(3·tax, 15)`, the floor these items clear; `headroom` is margin ÷ need. Volume interval
is 1h min-side.

**Two bounds on the columns below, stated because the headroom column would otherwise
read as exact.**

- **`margin` is the LIVE margin; the gate judged on `eMargin = min(live, 1h-sustained)`.**
  The export carries the trip's stamped `bid`/`ask` and no 1h pair, so my figure is an
  **upper bound** on what the gate saw, and the headroom column is an upper bound with it.
  Ordering by headroom is therefore approximate rather than exact — it is good enough to
  separate 3.5× from 1.1× and not good enough to separate 1.2× from 1.3×.
- **Tax exemption is unknown for the four unnamed ids** (closed-trip rows carry `id`, not
  `name`, and exemption is matched on name). For an exempt item the true margin is higher
  by the whole tax and the floor collapses to the halved tick floor. All four sit well
  clear of their floor either way, and **none of the five probation candidates is
  unnamed**, so the recommendation does not turn on it.

| item | id | buy | sell | margin | ROI | need m3 | headroom | limit | vol/h | tier | sim states |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Opal bolts | 879 | 20 | 39 | 19 | 95.00% | 15 | 1.3× | 11,000 | [500,1000) | below 400 min | open |
| Seaweed spore | 21490 | 100 | 177 | 74 | 74.00% | 15 | 4.9× | 600 | [500,1000) | below 400 min | open / unobs |
| *(id 34017)* | 34017 | 150 | 214 | 60 | 40.00% | 15 | 4.0× | 1 | [500,1000) | below 400 min | unobserved |
| Echo ahrim's ornament kit | 30451 | 160,000 | 215,574 | 51,263 | 32.04% | 12,933 | 4.0× | 1 | [6,13) | **untiered** | open |
| *(id 32366)* | 32366 | 910 | 1,194 | 261 | 28.68% | 69 | 3.8× | 250 | [500,1000) | T1 | unobserved |
| **Dwarf weed seed** | **5303** | **691** | **888** | **180** | **26.05%** | **51** | **3.5×** | **200** | **[500,1000)** | **T1** | unobserved |
| **Bananas(5)** | **5416** | **677** | **848** | **155** | **22.90%** | **48** | **3.2×** | **600** | **[500,1000)** | **T1** | open |
| Tyrannical ring | 12603 | 147,162 | 184,153 | 33,308 | 22.63% | 11,049 | 3.0× | 8 | [7,14) | **untiered** | unobserved |
| Piscatoris teleport | 12408 | 3,000 | 3,680 | 607 | 20.23% | 219 | 2.8× | 10,000 | [333,667) | T1 | open |
| **Warrior ring** | **6735** | **48,201** | **58,000** | **8,639** | **17.92%** | **3,480** | **2.5×** | **8** | **[21,41)** | **T2** | unobserved |
| **Black d'hide chaps** | **2497** | **3,307** | **3,871** | **487** | **14.73%** | **231** | **2.1×** | **70** | **[302,605)** | **T1** | unobserved |
| Bloodbark helm | 25413 | 116,001 | 134,995 | 16,295 | 14.05% | 8,097 | 2.0× | 1 | [9,17) | **untiered** | open |
| *(id 2317)* | 2317 | 300 | 348 | 42 | 14.00% | 18 | 2.3× | 13,000 | [500,1000) | below 400 min | unobserved |
| Antipoison(4) | 2446 | 415 | 479 | 55 | 13.25% | 27 | 2.0× | 2,000 | [500,1000) | T1 | open |
| **Quetzal feed** | **29307** | **2,999** | **3,400** | **333** | **11.10%** | **204** | **1.6×** | **100** | **[333,667)** | **T1** | open |
| Granite shield | 3122 | 34,021 | 37,971 | 3,191 | 9.38% | 2,277 | 1.4× | 70 | [29,59) | T2 | open |
| Anguish ornament kit | 22246 | 177,397 | 197,491 | 16,145 | 9.10% | 11,847 | 1.4× | 4 | [6,11) | **untiered** | open |
| Zamorak chaps | 10372 | 157,267 | 174,521 | 13,764 | 8.75% | 10,470 | 1.3× | 8 | [6,13) | **untiered** | open |
| *(id 19936)* | 19936 | 168,141 | 185,379 | 13,531 | 8.05% | 11,121 | 1.2× | 8 | [6,12) | **untiered** | unobserved |
| Oranges(5) | 5396 | 1,270 | 1,399 | 102 | 8.03% | 81 | 1.3× | 600 | [500,1000) | T1 | open |
| Cannon furnace | 12 | 189,627 | 209,000 | 15,193 | 8.01% | 12,540 | 1.2× | 70 | [5,11) | **untiered** | open |
| Divine super combat potion(2) | 23691 | 9,009 | 9,899 | 693 | 7.69% | 591 | 1.2× | 2,000 | [111,222) | T2 | open |
| Guthix chaps | 10380 | 136,288 | 149,737 | 10,455 | 7.67% | 8,982 | 1.2× | 8 | [7,15) | **untiered** | open |
| Amethyst arrow(p++) | 21336 | 691 | 758 | 52 | 7.53% | 45 | 1.2× | 11,000 | [500,1000) | T1 | open |
| Arctic pine logs | 10810 | 655 | 717 | 48 | 7.33% | 42 | 1.1× | 11,000 | [500,1000) | T1 | open |
| Watermelon seed | 5321 | 267 | 289 | 17 | 6.37% | 15 | 1.1× | 200 | [500,1000) | below 400 min | open / unobs |

**Sim fill outcomes: there are effectively none.** Of the 26, thirteen show only
`unobserved` lifecycles (the app was closed across their horizon) and the rest show only
`open` — the export's open trips were placed 2026-08-17 23:36Z to 2026-08-18 17:58Z and
have not resolved. **Not one marginal item has a `filled` outcome in a bucket the
instrument watched.** The sim cannot adjudicate this population, which is exactly your
ruling: real fills, never the sim alone.

**The tier filter is the finding nobody asked for.** Of the 26, **five sit below the 400gp
minimum unit price** and **eight are untiered above the 100k T2 ceiling**. Only **13 of 26
would reach the allocator at all** under today's bands. Any breadth figure quoted for this
notch — 141 items, +48% — is a *scoring* population, not a *fundable* one, and roughly half
of it is outside the allocator by construction.

### §2.3 Concentration, and the split of the v500 net

**Marginal share of b500's proven net:** the population is net-**negative** at the proven
bound in all nine h6 keys (−0.46m to −1.06m) and in six of nine h9.5 keys; it is positive
only at h9.5 `c30`, all three participation levels. It is **37–39% of b500's trips** and
**2.7–11.7% of its gross movement**. Per-key table in §0.3.

**Concentration for the marginal population: NOT DERIVABLE, and stated rather than
omitted.** `top` is a maximum and does not subtract. b500's `top` equals the control's at
**all 18 econ keys**, so the top mover is in the *shared* population — which tells us the
marginal population does not contain the grid's biggest trip, and nothing more. The bound
`marginal top ≤ min(b500 top, marginal gross)` collapses to `marginal gross`, i.e. 100%,
which is no bound at all.

**Cheap fix, proposed:** the econ bucket stores `top` as a magnitude. **Store the top
mover's item id beside it.** One field. Then any subtraction-derived population can be
tested for whether the top belongs to it, and this disclosure stops being structural.

### §2.4 Proposed probation lane: five items, chosen to SPAN the axis

**Selection principle, stated because it changes what the lane can conclude: these are not
the five best.** A lane picked for expected profit answers "is the top of the marginal set
profitable", which is not the question. The question is whether the fill model holds on
thin books — so the five span **thinness (21/h to 1000/h)** and **margin headroom over the
m3 floor (1.6× to 3.5×)**, and all five sit inside an allocator band.

| # | item | why this one | vol/h | headroom | notional at full limit |
|---|---|---|---|---|---|
| 1 | **Dwarf weed seed** (5303) | best headroom and highest ROI in the reachable set; smallest notional | [500,1000) | 3.5× | 138k |
| 2 | **Bananas(5)** (5416) | second-best headroom, at the thick end of the marginal band | [500,1000) | 3.2× | 406k |
| 3 | **Warrior ring** (6735) | **the adverse case, included deliberately** — thinnest of the five and the only T2 | [21,41) | 2.5× | 386k |
| 4 | **Black d'hide chaps** (2497) | the mid-thinness case; familiar item, largest limit that still sizes cleanly | [302,605) | 2.1× | 231k |
| 5 | **Quetzal feed** (29307) | **the near-the-gate case** — lowest headroom of the five | [333,667) | 1.6× | 300k |

Excluded and why: **Piscatoris teleport** and **Divine super combat potion(2)** (notional
30m and 18m — the one-third-of-working-capital clamp would pin them, and a clamped position
cannot test a fill model); **Granite shield** (2.38m, same reason, and 1.4× headroom);
**Amethyst arrow(p++)**, **Arctic pine logs**, **Oranges(5)** (1.1–1.3× headroom — a
rounding of the tax moves them across the gate, so a loss would not be attributable to
thinness); everything untiered or under the 400 minimum.

**Enrollment terms, per the ruling and the standing bounded-experiment rule:** half size, a
separable population stamp so the trips can be lifted out, success criteria written
*before* the first trade, automatic revert. **No constant moves.** The lane opens when the
cutover lands, not before — until then these items have no admission path.

**What would withdraw a candidate before enrollment:** any of the five showing a `filled`
sim outcome that is net-negative at the proven bound once real observation exists. That is
the sim finally saying something, and it should be heard before capital is.

---

## §3 · The three closures — SHIPPED

`scorerClosuresLog()` writes three `DB.decisionLog` rows, once per store, guarded **per
subject**, each `auto: 1, by: "user"` — written by the tool, decided by you.

1. **taxMult loosening — CLOSED, monotone worse at every measured point.** Basis frozen at
   the 2026-08-18 export: the ordering holds at 18 of 18 econ keys; the b1000 ladder runs
   401 trips across 292 distinct items at m3 to 2,338 across 768 at m0.5 while proven net
   at `h6|p50|c15` runs −108k, −5.75m, −22.8m, −49.1m, −194.3m. **The blacklist canary is a
   second, money-independent reading pointing the same way:** would-fund blacklisted
   item-cycles rise monotonically with the loosening — 290, 344, 365, 375, 379 at b1000,
   the same two ids throughout (Rune brutal, Tarromin). A config that would fund more
   known-bad items is evidence against the config; that is what row 23 built the canary for.
2. **ROI floor 1.2 → 1.0 at m0.5/b250 — CLOSED, the worst cell in the grid.** Last by
   proven net at **18 of 18** econ keys. The notch buys 30 further distinct items (+2.7%)
   and 8,265 further funded item-cycles for **−237.4m** of proven net at `h6|p50|c15`.
   Recorded as retroactively vindicating the ROI-loosening bench: the loosening was benched
   on the arithmetic that it admits nothing while the tax limb stands above it, and the one
   measured regime where it *does* admit items is the worst cell measured.
3. **Volume base 1000 → 50 — STAYS DENIED; this reading supersedes nothing.** The entry
   says so explicitly and never argues the denial from the grid: 50 is twenty times looser
   than the loosest cell measured and no cell speaks to it. The nearest tested evidence is
   recorded only so the proposal is not re-argued from breadth alone.

Each entry carries a distinct-item count beside every trip count, a concentration figure
(including the not-derivable disclosure), and the capture-grading status — §4.3.

---

## §4 · Still standing

### §4.1 Axis-level stability — proposed wording and test (build only on your ruling)

**The refinement §0.2 forces: the verdict is per (axis × horizon), never per axis.** The
volume-base axis is stable at h6 and unstable at h9.5 — one axis, two answers. A verdict
keyed to the axis alone would have to pick one, and would be pooling two stamped
populations to do it. This is the never-pool rule reaching the readiness machinery itself.

**Proposed term** — `axisStability(axis, horizon)`, three states:

| state | rendered as | means |
|---|---|---|
| `stable` | **"ordering stable across capture — N levels, monotone"** | the ordering of that axis's cells by proven net is identical at all three capture points, at every participation level, for this horizon |
| `unstable` | **"ordering unstable across capture — flips at c5 / c15 / c30"** | at least two capture points disagree; the disagreeing points are named |
| `cannot say` | **"cannot say — M of N cells carry no counted evidence at this horizon"** | any cell on the axis lacks econ at any key the comparison needs |

**Proposed copy for the two live cases, exactly:**

> **taxMult · h6 — ordering stable across capture. 5 levels, monotone (m3 > m2 > m1.5 > m1 > m0.5). Magnitudes remain ungraded.**
>
> **volume base · h9.5 — ordering unstable across capture: b250 leads at c5, b1000 at c15, b500 at c30. No ordering claim is available at this horizon.**

**What a `stable` verdict licenses, and what it does not.** It licenses an **ordering
claim** — *"tighter is better on this axis at this horizon, at every capture point we can
model"*. It does **not** license a magnitude, a ranking across axes, or a constant change.
`scorerRankReadiness()` is untouched; this sits beside it as a second, narrower verdict, and
"cannot rank yet" still stands wherever a ranking would render. **Why a stable axis may
carry an ordering claim while magnitudes stay gated:** capture is a monotone knob on how
much of a bucket a leg takes, so it scales what every cell earns; an ordering that survives
all three settings is not a fact about the capture constant. A magnitude is.

**Proposed test — four assertions, and the fourth is the one that matters:**

1. `axisStability` returns `stable` on a fixture whose orderings agree at all three capture
   points, and `unstable` the moment one point is permuted. *(the discriminating pair)*
2. It returns `cannot say` — not `stable` — when any cell on the axis has an empty econ
   bucket. A vacuous agreement is not agreement. *(the never-fed shape)*
3. The verdict is computed **per horizon**, and a fixture where h6 is stable and h9.5 is not
   renders **two verdicts in two containers**, with no combined verdict anywhere — asserted
   by absence, in the `[R80.4]` shape. *(the §0.2 finding as a detector)*
4. **The rendered copy of a `stable` verdict contains no ranking language and no magnitude,
   and forbids the contradicting claim** — the eleventh face: require "ordering" *and*
   forbid "best" / "wins" / "ranks". Seeded by rewriting the first half of the sentence to
   claim a ranking while leaving "ordering" in the second half.

**Cost:** one term, one render slot inside the existing horizon-grouped containers, four
assertions. No new store, no persisted field. **Walk-up budget untouched** — the scorer is a
pull surface and presents no rulings.

### §4.2 Bracket the grid tighter — m4 and m5 at volBase {1000, 500}

**Costed first, as asked. Compute and storage are near-free; the real cost is a
denominator.**

| | |
|---|---|
| **Frontier growth** | **exactly zero, structurally.** `marginNeed = max(taxMult·tax, tickFloor)` is monotone in `taxMult`, so `fundedSet(m4,b) ⊆ fundedSet(m3,b)`. The frontier is the union over all cells and is already set by the loosest corner. **Tighter cells cannot enlarge it.** |
| **Fill-sim load** | **zero.** Trips are keyed on the frontier. No new items → no new trips → no new observation load. This is the expensive part of the system and it does not move. |
| **Scoring work** | 16 cells × ~4,497 items = 71,952 gate evaluations per 5m bucket today. **+4 cells = +17,988, +25%.** Pure arithmetic on a cached stats object, once per bucket. |
| **localStorage** | 16 cells ≈ **144.3 KB** measured (2.8% of the 5MB quota). Each new cell is **at most** its m3 counterpart's size, because its id stock is a subset: **≤ 27.0 KB added, ≤ 0.53% of quota.** |
| **Econ roll** | four more birth cells to credit per closed trip. Negligible. |

**The cost that is not free — and it is the partition question, unanswered:**

**The grid's cell count is a rendered denominator.** `scorerBreadth` renders
`f.cells.length + " of " + cellsAll.length`, and the ruled structure metric (`[R84.2]`,
glossed as `sc-breadth`) is *funded-by M of the grid*. **"12 of 16" and "12 of 20" are
different claims about the same item**, and the second is strictly weaker. The denominator
is computed live and will follow the grid correctly, so nothing renders a wrong number —
but:

- The **glossary entry hardcodes it**: `sc-breadth` carries `aka: "funded by M of 16
  cells"`. That is a live copy defect the moment m4/m5 land, and fixing it in the same
  commit is the same-commit glossary rule.
- **Breadth today is session-scoped** (`S.scorerItemHist`, labelled "this session"), so
  nothing persisted pools. **But the plan-surface design proposes breadth as a row-level
  badge**, and the moment breadth is persisted or carried into a ledger the 16→20
  transition needs the `fundedNoChart` treatment: a stamp that lets the two eras decompose.
  **Answer the partition question before the grid grows, not after** — the register's own
  rule, and this is the instance it applies to.

**Recommendation: propose ADDING the four cells and NOT growing the grid until the breadth
denominator is stamped.** The two are one ruling, not two. The reason to want m4/m5 stands
exactly as you put it — the control sits at the tight end of a swept range, so the grid
bounds the optimum from one side only, and every reading in §0.2 is consistent with the
optimum being tighter than m3 rather than at it. **The data cannot currently distinguish
"m3 is best" from "m3 is the tightest thing we tried."**

### §4.3 The three-things rule — complied with here; the machinery is still owed

Every aggregate cited in this report and in all three decision-log entries ships:

- a **distinct-item count beside every trip count** — `scorerCountPair`, so there is no way
  to write one without the other (seeded S5);
- a **concentration figure**, including the **NOT-DERIVABLE** state rendered as a disclosure
  with its reason (`scorerConcNote`, seeded S6);
- the **capture-grading status**, from one extracted term (`scorerCitedCaveat`, seeded S7).

`[R85.3]` asserts all three over **every** entry the writer produces, not one sampled string
— seeded S8 by stripping the concentration from a single entry, which turned the whole-list
assertion red while the three term-level assertions stayed green.

**What is NOT built, and the requirement row says so rather than letting a narrow detector
read as a wide one: the machinery that REFUSES to render a proposal without the three.**
That is a general guard across every proposal surface, it is a separate ruling, and this
writer complying is not it. It remains owed.

---

## §5 · Raised in passing

**§5.1 — the export's carried trip rows are the wrong 500, and the copy does not say
which.** `scorerSurfLoad` calls
`getAll(IDBKeyRange.lowerBound((now − 7d)·1000), SCORER_SURF_TRIPS)`. IndexedDB `getAll`
with a count returns the **first** N in key order, and the key is `closedAt·1000 + seq`. So
the drill and the export carry the **oldest** 500 rows in the window — not a sample of it,
and not the newest. In this file that is **3.67 h of a 168 h window (2.2%), and 97.6% of the
carried lifecycles are `unobserved` holes.**

The header declares the truncation — *"rows from the last 7 days of the 30-day t1 ledger,
capped at 500 — 500 carried of 30581 total"* — and that sentence reads as a sample of the
last 7 days. It is a **claims-vs-computation finding (scan 7)** and an **interrogability
finding (scan 5)**: an expansion showing a subset without saying which subset. The rows a
reader is handed are systematically the least informative ones available, and the disclosure
that would tell them so is missing.

Two fixes, independent of each other: **(a)** state the selection rule in the truncation
note and render the carried window's actual span and its unobserved share; **(b)** take the
**newest** 500 rather than the oldest, which is almost certainly what "capped at 500" was
meant to mean. (a) is required whatever (b) does.

**§5.2 — the 7-row gap between `cycles` (1,024) and rdiff rows (1,017).** Named in §1.1.
Not assumed benign.

**§5.3 — `sc-breadth`'s glossary `aka` hardcodes "16".** Named in §4.2. Not a defect today;
a defect the moment §4.2 ships.
