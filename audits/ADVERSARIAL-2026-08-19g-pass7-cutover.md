# Pass 7 — the cutover-scoped pass. **17 money-path findings. The gate is not clean.**

**2026-08-19.** The pass the cutover gate was waiting on: scoped to the pool switch, the plan
surface, the operator store, the gates and the scorer. **Not `validateImport`, not the restore
path** — those have their own track.

## The number you asked for, first

| pass | scope | money-path findings |
|---|---|---|
| 4 | cutover-critical assertions | 0 that bite today |
| 5 | `num()` sweep / `validateImport` | 3 |
| 6 | pass 5's repairs / `validateImport` | 8 |
| **7** | **the cutover surface itself** | **17** |

**34 findings. 17 money-path.** 25 went through adversarial refutation; **22 survived, 3 refuted**
— and 2 of the 3 refutations killed money-path claims, so **12 of the 14 reader-filed money-path
findings survived**, plus 3 more from the completeness critic, which ran after verification.

**Almost all of them are LATENT and armed by exactly the flags the ruling would flip.** That is what
a cutover-scoped pass is *for*: the previous four passes could not see these because the population
they concern does not exist until `CUTOVER_POOL` is true.

## Freeze

| file | at launch (20:37:51Z) | at close |
|---|---|---|
| `index.html` | `3cf9a22d321892e5…` | `3cf9a22d321892e5…` |
| `tools/probe/probe-snippet.html` | `e239370cfb042232…` | `e239370cfb042232…` |

**All six agents reporting hashes verified both ends and all six matched.** No edits to either file
between launch and report; the session's other work went to `staging/`, a copy.

## Method and the honest denominator

Five non-overlapping readers — pool switch/qualification/`buildPlan`; the gate chain and the
chart/series/volume gates; the operator store and the plan surface; the scorer; and one whose scope
was a *question* rather than a region (code that does not change at the flip but receives different
values after it). Then per-finding adversarial refutation — verifiers instructed to **refute**, and
to default to refuted where they could not trace it themselves. Then a completeness critic.

**435 reader-minutes · 322 production call sites read in full · 147 assertion bodies read in full**,
plus 72 minutes / 71 sites / 44 assertions for the critic.

**No finding rests on a suite result.** Every one is traced from quoted source to the consumer that
spends it; the agents were forbidden to run the suite at all.

**Verification was capped at 5 findings per reader and 5 findings were therefore not
adversarially verified.** All five are non-money-path; the cap never reached a money-path finding.
They are named at the bottom rather than dropped silently.

---

# The four that decide the ruling

I re-verified each of these against the source myself rather than taking the agents' word.

## 1. The operator store and the watch row have different owners for reading and writing

**Money-path. Armed by `ITEM_OPS` alone. Two readers found it independently; a third found a
narrower version.**

`opsPick` prefers the item store for any field the store row owns (`hasOwnProperty`) and falls back
to the watch row only when the key is absent. `itemOpsMigrate` copies
`["tBuy","tSell","tAt","qty","tierOv","t2Grad"]` off each watch row **once ever** — it opens
`if (DB.itemOpsV1) return 0` — and it has already run on any browser that booted this build.

Of the writers of those six fields, **exactly one branches on the flag**:

```js
7869:  if (ITEM_OPS) opsSet(x.id, { t2Grad: 1 }); else { w.t2Grad = 1; save(); }
```

The four watch-row controls do not:

```js
23880:  delete w.tBuy; delete w.tSell; delete w.tAt; save(); renderWatch();   // clear tested pair
23946:  const next = w.tierOv == null ? 1 : ... ;                             // tier override cycle
24170:  w.tBuy = nb; w.tSell = ns; w.tAt = Date.now();                        // test buy/sell
24230:  if (typed <= 0) w.qty = null; ... w.qty = typed;                      // manual size
```

`opsSet` has three call sites — 7869, 19798, 19812 — and **none of them is a watch-row control.**

**So the moment `ITEM_OPS` flips, every operator edit made since the migration boot is discarded**
and the store answers with the frozen snapshot. Directions, each traced to its consumer:

- **`tierOv`.** A row hand-set to untiered (`w.tierOv = 0`) to keep an item out of the allocator
  still has a migrated `tierOv: 2` in the store, so `itemTier` returns t=2, the untiered bench never
  fires, and the item funds. **A bench applied by hand, removed with no press** — the restraint-lift
  line.
- **`qty`.** A manual size lowered from 2000 to 500 after migration: `planQty` reads
  `opsOf(w.id).qty` = 2000 and the plan sizes 4× what was asked for.
- **`tBuy`/`tSell`/`tAt`.** A margin test recorded this morning is invisible; the migrated pair's
  `tAt` fails the 16h TTL, so the plan reverts to live prices on an item just tested, and
  `provenLoser` reads the same stale stamp so a fresh re-test cannot unbench a proven loser.

**Nothing in the suite can see it.** `[R93.4]`'s fixture writes `DB.itemOps[930010].qty = 42` — the
**store** — never the row, so the row-side divergence cannot express itself. That is a fixture
preventing the defect from expressing itself, on the assertion written to cover this exact function.

**The critic found a second instance of the same shape:** two owners of *"has the operator
margin-tested this item?"* — `calc` and `provenLoser` read it through `opsOf`, while the scout's
two eviction guards read `Number.isFinite(w.tBuy)` straight off the row.

## 2. `CUTOVER_POOL` without `VOL5_UNIVERSE` widens what the allocator may fund

**Money-path. Armed by flipping one flag and not the other — and nothing enforces the pairing.**

```js
4218:  const vol5Population = () => VOL5_UNIVERSE ? S.items.map(it => it.i) : DB.watch.map(w => w.id);
4226:  for (const id of [...S.vol5Low.keys()]) if (!live.has(id)) S.vol5Low.delete(id);
```

A pool item is not in `DB.watch`, so its 5-minute die-off streak is not zero — it is **deleted**.
`volGateFor` reads `S.vol5Low.get(c.id)` as `undefined`, takes the *not counted* branch, and returns
`{ v: c.volSide, bound: "1h" }`. A watch item in the identical market state returns
`{ v: Math.min(c.volSide, c.vol5), bound: "5m" }` — **a strictly smaller number**, because the 5m
binding is a `Math.min` and can only shrink.

So one plan build would contain two populations sized and gated by different rules, and the
difference is not a judgement about the items — it is which list they came from. The direction is
the wrong one: **pool items get sized larger and clear the volume floor more easily than an
identically-placed pin in a collapsing book**, and they are the population with no operator history
behind them. The die-off tag is disarmed for them too — `dieOffTagged` requires
`x.volBound === "5m"`, which a pool item can never reach.

The code states the third state honestly in its own comment ("the streak is kept for watchlist
members only"). What is missing is that **three independent `const`s mean either ruling can land
alone**, and only this ordering is dangerous — `VOL5_UNIVERSE` alone is inert, because watch items
were already counted.

**The critic added the mechanical half:** `VOL5_UNIVERSE` is the one cutover flag whose **armed
branch is unreachable from any test.** `planCandidates(armed)` and `opsOf(id, armed)` both took an
injection parameter for exactly this reason; `vol5Population()` did not. `[R94.3]` pins the const
and nothing exercises the branch it guards.

## 3. The plan's two-group split is applied *after* funding

**Money-path. Armed by `CUTOVER_POOL` plus the 7-of-7 coverage clock.**

The design comment at 5820 makes the argument in its own words:

> *"Four of the plan score's six terms are operator-history terms … each DEFAULTS TO A NEUTRAL 1.0
> when its input is absent. A watchlist item with history spans roughly 0.34x to 2.91x on those
> four; a pool item is pinned at exactly 1.0x on all of them. So one ranked list places every pool
> item in the MIDDLE of the tenured ones — not because the evidence says middling but because there
> is no evidence and the default renders as average. That is the never-fed-aggregate rule inside a
> sort comparator."*

The repair built for that argument is `planGroups`, and **`planGroups` is called exactly once, at
8004, on `picks`** — the set `buildPlan` has already chosen and sized. The sort that decides which
candidates get the seven slots and the per-slot budget is at 6718 and is **one list**:

```js
pass.sort((a,b) => (rank(a) - rank(b)) || (groupOf(a) - groupOf(b)) || (b.score - a.score));
```

**This was scoped deliberately** — the same comment ends *"The split is a RENDERING decision and
stays display-only … Merging them, or adding a scorer term to either, is deployment-class and is not
done here."* So this is not an oversight. It is a **decision the ruling has to make**, and it is
already one of the ruling's three items ("the plan surface as approved"). What the pass adds is that
the argument the split rests on applies with full force to the funding order, which was left as the
thing the argument calls wrong.

**The second half is cleaner and is a claim defect on a surface read daily.** `planGroups` is never
applied to `nextUp`, whose header reads:

> *"When slots or budget free up, these fund AUTOMATICALLY at the next recompute — no press
> required; promote only jumps the ORDER."*

That queue is the automatic funding order for everything the slots did not reach, it mixes both
populations, and it carries neither group header. **The render shows a separation the money never
had, on the one surface where the separation is claimed.**

## 4. The seasoning streak's reset cannot see a pool item's market-gate failure

**Money-path. Armed by `CUTOVER_POOL` alone.**

The seasoning rule is *"any failed evaluation resets the streak"*, and its only implementation is:

```js
6569:  if (x.failed){
6570:    if (DB.qual[x.id]){ delete DB.qual[x.id]; dirty = true; }   // consecutive means consecutive
```

A **watch** item is in `all` on every snapshot, failed or not, so any gate failure deletes its row.
A **pool** item is in `all` only when its id is in `S.scorerCtlPass`, which `scorerCycle` builds
from items whose `marketGateFails` came back **empty**. When a pool item fails the ROI floor, the
margin floor, book skew, flow imbalance, the volume floor, trend, volume trend or momentum, it is
simply **absent** — so line 6570 never runs on it and its streak survives.

Worked on the default schedule: a pool item passing at 07:00, failing all morning, passing at 17:00
and again at 12:00 the next day reaches n=3 and seasons. A watch item with byte-identical market
data is reset on the first failing minute and never reaches n=2. **Three passes out of ~576
five-minute buckets seasons a pool item; the same behaviour never seasons a pin.**

The design comment that sanctions the current retention rule says *"Step 1 already deletes on a real
failure"* — step 1 **is** line 6570, and for the pool population a real failure produces absence
rather than a failed candidate. **Absence and data-of-absence, at the line whose comment separates
them.**

**Seed result: nothing — uncovered.** Deleting the reset body entirely turns no assertion red. The
suite calls `updateQualStreaks` four times and never passes a candidate carrying a truthy `failed`,
so *"consecutive means consecutive"* has no detector at all.

---

# Every finding

**M = money-path.** Line numbers are `index.html` unless stated.

| # | M | armed by | finding | line |
|---|---|---|---|---|
| 1 | ● | `ITEM_OPS` | the item store shadows the watch row; four controls still write the row | 6072 |
| 2 | ● | `ITEM_OPS` | three of the six migrated fields still written to the row (narrower form of 1) | 6072 |
| 3 | ● | `ITEM_OPS` today | four watch-row controls vs every reader switching to the store | 23947 |
| 4 | ● | `CUTOVER_POOL` + `!VOL5_UNIVERSE` | pool items sized on the 1h book in a dying market | 4192 |
| 5 | ● | `CUTOVER_POOL` | the seasoning reset cannot see a pool item's market-gate failure | 6569 |
| 6 | ● | `CUTOVER_POOL` | `cutoverPoolRows` spends `S.scorerCtlPass` with no no-cycle state and no bucket age | 6352 |
| 7 | ● | `CUTOVER_POOL` | `applyFamilyRule` picks the family winner across pooled populations and benches the loser | 6407 |
| 8 | ● | `ITEM_OPS` + `CUTOVER_POOL` | pool operator controls render only on FUNDED lines — the untiered 66% cannot reach the override | 8028 |
| 9 | ● | `CUTOVER_POOL` | the tier override is named as the only re-admission path and renders only on funded picks | 6709 |
| 10 | ● | the coverage clock | the archive-derived series breaks both of `sitRisk`'s assumptions | 3987 |
| 11 | ● | the coverage clock | econ nets pool six-gate and full-chain trips on screen | 9986 |
| 12 | ● | today (verdict) | `scorerRanking`'s comment claims trip-level exclusions that are per-capture-lifecycle | 10062 |
| 13 | ● | `CUTOVER_POOL` + clock | **the two-group split is applied after funding; NEXT UP is not split at all** *(critic)* | 6718 |
| 14 | ● | `ITEM_OPS` | two owners of "has the operator margin-tested this item?" *(critic)* | — |
| 15 | ● | today (coverage hole) | `VOL5_UNIVERSE`'s armed branch is unreachable from any test *(critic)* | 4218 |
| 16 | ○ | today | the closed-trip window reads the OLDEST 500 rows, not the newest | 10173 |
| 17 | ○ | today | the gate ledger names the gate by regex over the bench sentence while the funnel reads `fails[0].g` | 6945 |
| 18 | ○ | today | `capReason` attributes the buy-limit window count to `DB.horizonH`, which does not produce it | 3676 |
| 19 | ○ | today | the trend gate's falling limb reports `need = GATE.falling` while passing requires `GATE.trendSoft` | 5713 |
| 20 | ○ | today | the sizing bench names a remedy the arithmetic forbids and blames a cause that did not fire | 5725 |
| 21 | ○ | today | `src: "migrated"` is written and read by nothing | 6174 |
| 22 | ○ | today | `[R38.2]`'s gate-name filter reads as an exclusion and excludes nothing | probe:12 |
| 23 | ○ | today | the qualifying ETA uses two constants the seasoning gate stopped using | 6554 |
| 24 | ○ | `ITEM_OPS` | `opsSet` acquires an automated writer at cutover, against its own stated contract and R93.5 | 7869 |
| 25 | ○ | `CUTOVER_POOL` | `gateLog`'s `src` stamp has no reader that partitions on it | 8310 |
| 26 | ○ | `CUTOVER_POOL` | the three cutover regime stamps have no partitioning reader; the register names a field the writer never emits | 6310 |
| 27 | ○ | `CUTOVER_POOL` | two plan-surface lines still name the watchlist as the population and the scanner as the remedy | 8194 |
| 28 | ○ | rdiff cap | the coverage verdict differences a CAPPED read against a lifetime counter | 2621 |
| 29 | ○ | the coverage clock | `scorerNoChart` stamps the six-gate era off ONE of three chart gates | 2326 |
| 30 | ○ | the coverage clock | the scorer's chart-gate line makes three claims that all stop being true as the clock crosses | 10276 |
| 31 | ○ | `VOL5_UNIVERSE` | `volGateFor`'s uncounted-streak copy names the watchlist as the reason *(critic)* | 4192 |

## The three refuted, and what survived each

**Refutation is a result, not a failure** — these are recorded because a pass that reports only its
survivors is reporting a filtered population.

1. **"A pool that has never been scored is indistinguishable from a pool that passed nothing"**
   (money-path, high) — **refuted.** `planCandidates` builds `watch` on *both* branches and the
   armed branch is `watch.concat(pool)`, so the watchlist is always a subset of `all` and
   *"Nothing benched — every watchlist item passed"* stays **true** post-flip; it is
   under-inclusive, not false. The verifier also refuted the claim that the scanner and `watchCap`
   stop working after the flip — nothing gates the scout on `CUTOVER_POOL`.
2. **"`Math.min(qty, …)` pins every capture lifecycle on small-quantity trips"** (money-path,
   medium) — **refuted.** `scorerTripRoll`'s `if (share < SHADOW_MIN_OBS) { e.insuf++; continue; }`
   excludes the fast-closing population the finding leans on, and `scorerRankGate` has **no
   production caller at all** — it is called only from the probe.
3. **"A pool item benched as untiered is told to fix it on a watch row it does not have"**
   (non-money, high) — **refuted on mechanism and timing**, and the verifier named what does
   survive: `REQUIREMENTS` R93.7 claims the controls live on *"its plan line, which every pool item
   has"* — true only of every **funded** pool item.

## The five that were not adversarially verified

Named rather than dropped silently. All non-money-path, all lowest-ranked within their reader:
#23 (qualifying ETA), #25 (`gateLog`'s `src`), #27 (two plan-surface lines), #29 (`scorerNoChart`),
#30 (the scorer's chart-gate line). Findings 13–15 and 31 come from the critic, which ran after
verification, so they are unrefuted rather than verified.

---

# What this means for the gate

**The cutover gate's fourth prerequisite was a clock. It now has a second blocker that is work.**

Three of the four ruled requirements were already done (reconciliation history, the integration
audit, the label scan). The adversarial pass was the fourth and it has now run — and it did not come
back clean. **The position is not "one clean pass away"; it is "these findings triaged and the
money-path ones closed, then a pass over the repairs".** Passes 2, 3, 5 and 6 each found a defect
inside the previous pass's repairs, so budget for that.

Three things are decisions rather than repairs and belong in the ruling itself:

- **Whether the funding sort splits the two populations** (#13). The display split was ruled
  display-only on record; extending it to the money is deployment-class and is exactly the "plan
  surface as approved" item.
- **Whether `CUTOVER_POOL` may flip without `VOL5_UNIVERSE`** (#4). On the evidence it may not, and
  nothing in the file enforces the pairing.
- **Whether a pool item seasons on the same rule as a pin** (#5). Today it cannot, because the
  reset never sees its failures — so the flip would change the seasoning rule for a whole
  population as a side effect.

**Nothing was fixed in this pass and nothing was flipped.** Under the staged-repair rule the repairs
belong in `staging/` and land after a cold review, and the three items above belong to the user.

Full per-finding reasoning, every quoted line, every verifier's refutation attempt:
`.claude/…/subagents/workflows/wf_c2fd1082-884/journal.jsonl`.
