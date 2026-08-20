# Adversarial pass — the re-pass queue's own repairs, against a frozen tree

**2026-08-19. Third consecutive pass. 41 findings across four scopes.** Every one of the three
passes has now found a money-path defect inside the previous pass's fixes; this one found the
defect **I introduced while closing the previous pass's money-path finding.**

## Freeze record

| file | at launch (11:09:21Z) | at close |
|---|---|---|
| `index.html` | `f1379af1e8680d58` | `f1379af1e8680d58` |
| `tools/probe/probe-snippet.html` | `2e31e3942668cfb2` | `2e31e3942668cfb2` |
| `REQUIREMENTS.md` | `506644e507ed3330` | `506644e507ed3330` |
| `probe-report.txt` | `480465f3c16279bf` | `480465f3c16279bf` |

**The freeze held.** All four agents verified both hashes unchanged at completion. Suite at freeze:
`PROBE-PASS — 1,228 assertions`. Nothing was written, edited, seeded, run or committed by any agent.

## Shape of the pass

Four read-only agents, one per scope, each required to quote production text (`codeQuote`) and the
exact assertion condition, to state whether a finding BITES today or is latent, and to name the seed
that would prove it. Each returned a CLEARED section so the next run starts from a list.

| scope | findings | assertion bodies read in full | ~min |
|---|---|---|---|
| `hour-weight-and-grouping` | 14 | 11 | 45 |
| `consumer-repairs` | 7 | 6 | 50 |
| `plan-copy-and-era` | 11 | 42 (+ ~120 conditions in a regex census) | 55 |
| `probe-fixtures` | 9 | 47 | 55 |

**41 findings. 1 money-path, 2 live today, the rest latent or coverage-claim.** Two findings were
reported independently by two agents that never saw each other's work (the union-as-universal in
`planPoolFedLine`), which is the strongest signal in the set.

---

## THE MONEY-PATH FINDING — the two history gates stopped being a partition

**Mine, introduced in this session's own queue, while fixing a different defect on the same line.**

Closing re-pass finding 11/17 meant stopping the `no history` bench from firing on a false premise,
so it gained `&& ser.src === "none"`. The **other** gate still suppressed itself with
`!(sp && sp.noData)`. The two used to cover the unknowable states exactly between them; afterwards
the region

> *my own `/timeseries` came back empty · the archive HAS entries · the series is not ready*

benched on **neither**. Every market gate treats a null reading as unknown rather than fail, so
trend, volume trend, momentum and drift all passed unread with nothing standing in front of them —
the precise "unmasking an inert restraint" failure the *previous* pass existed to prevent, one
repair later.

**Latent.** `chartReady()` is false while the h1 archive accrues, so `ser.src` is `"none"` and the
first gate still fires. **It would have armed at 7 observed days — the cutover's own clock**, and
nothing in §101 turns red when that happens.

**Why the block could not see it:** `[R101.1]`'s archive fixture is 168 **finite** points, so
`rdy.allFed` is true and the suppressed gate had nothing to say. That is the same
fixture-prevents-expression shape I had already caught once on `[R101.3]` earlier in the same
session — the second time in one sitting.

**Fixed** by making the suppression clause the *same named term* the first gate fires on
(`const noHist = …`), so the partition cannot drift apart again, and asserted at 20 archive points —
the length where the four consumers genuinely disagree (trend and momentum fed, drift and volume
trend starved), because that asymmetry *is* the hole. Seed **S116** reopens it and reddens the new arm.

---

## LIVE TODAY

**The inert-restraint line and the pool-persistence drill never reached the DOM.** Both were
prepended to `#benchBody` and the bench rows were then written with a plain `=` four lines later, so
both were discarded whole on every render. `poolDrill` is not pool-gated, so that half was broken
now: the persistence badge renders on every funded plan row while the rows behind it were
unreachable — an aggregate on screen that cannot be opened, which is the interrogability rule's own
finding. Fixed by moving the prepend below the assignment.

**`[R101.6]` passed with its own detector deleted.** The assertion written to close finding 30 drove
`S.gateNameOff` by hand (`.add("a gate nobody listed")`), so removing the production line inside
`chk` left every conjunct green: the emptiness check went *vacuously* true because nothing ever
added, and the warning still fired off the manufactured entry. The twelfth face, sitting inside the
assertion written to close a finding. Fixed by splicing a real gate name out of `GATE_CHAIN_ORDER`
(a `const` binding to a mutable array) and requiring the chain to notice. Seed **S119** now reddens it.

---

## THE CLAIM THAT COULD NOT FIRE

**`[R76.9]`'s armed era tripwire does not fire at the transition it names**, and CLAUDE.md's fourth
cutover prerequisite, two code comments and the requirement row all said it does.

Item 9761 is a synthetic probe fixture that is not in the real T0 archive, so `chartPts(9761)`
returns `[]` and `trendPct([])` returns null **whatever `chartReady()` says**. The proof is
historical rather than theoretical: the chart wiring *landed* on Aug 18 and this assertion did not
go red.

This matters because it is the designated forcing function for a **deployment-class** prerequisite —
the constitution's own words are that skipping the chart gates for pool items "widens what the
allocator may fund, by three gates, silently."

**Two repairs, and the second is the more important one.** The assertion now asserts *both*
directions — the same id seeded into a ready cache must read a real trend — so the null is
attributable to the gate rather than to the fixture, and a code change feeding `tr` unconditionally
turns it red. And the **claim** is corrected everywhere it appears: no in-page assertion can observe
a runtime coverage transition, because that is a clock and not a code shape. A tripwire that cannot
fire is the same defect class as a rule with no detector, and stating the limit is the fix.

---

## EVERYTHING ELSE, BY WHAT IT WAS

### Quantifier defects — a union rendered as a universal (4)

`planPoolFedLine` and `planHeldHeader` each unioned the unfed weights across their population and
rendered the result as a claim about every row; `planInertLine` chose its clause list with `some()`
and its count with `pool.length`, so one thin item spoke for forty, and its combined
momentum-and-drift clause fired when item A lacked momentum and item B lacked drift — true of
neither. All three now count per reading (`momentum on 1 of 3`). The fixtures were single-row or
uniform, which is exactly why none of them could express it: **one row can never separate a union
from a universal.** Mixed fixtures added.

### Absence merged with absence (3)

`hw.fed === false` was three different facts wearing one answer — no spark at all (a tool state), a
`/timeseries` that answered and had nothing (a fact about the item), and an all-zero profile (a
measurement that it does not trade) — and the held header narrated all three as a *failed fetch*.
`byHourSrc` said `"spark"` for an all-zero array the spark did not supply. `planInertLine` guarded
`x.mo`/`x.stw` and left `x.tr`/`x.vt` unguarded, so `candidateFor`'s no-live-price stub — which does
reach that line through `P.bench` stamped as a pool row — was credited with two absent readings and
silently denied the other two. All three now say which absence, and a dead price feed gets its own
sentence rather than being blamed on a thin archive.

### The residual anti-tripwire (1)

`planInertLine`'s **frame** was still unconditional. In the fully-fed era the only surviving clause
is the 5m die-off streak, which is gated on a *ruling* and not on the archive — so the sentence read
*"restraints the archive cannot feed yet … they return when the archive does"* beside *"at 7 of 7
observed days"*. And my own `[R92.5]` fed-era assertion **required** that clause, pinning the false
frame in place. The anti-tripwire I removed, surviving one clause deeper. The 5m streak now has its
own sentence naming its own trigger.

### Two clocks reported as one (1)

The chart gate read an **8-day** coverage window; every operator-facing *"N of 7 observed days"* read
a **7-day** one. The archive accrues only while the app is open, so buckets age out of the narrower
read while the gate still counts them — the gate could be READY while the figure the operator
watches for it said it was not, at the one moment anybody reads that figure. One named constant now,
`CHART_COV_WINDOW_MS`.

### Repairs whose branch nothing could reach (3)

`chartedNow` inverted for `noData` items (permanently unevictable, and they never refresh `lastPass`
because they bench, so they accumulate against the watch cap) and would have gone near-universal
once the archive matured, because `pts.length` counts NaNs. `scoutEvictable`'s call site carried an
**inversion** with nothing asserting it — dropping the `!` would have deleted every row the guard
exists to protect. `excStanding` was a **third** reader of the free-form `benchedBy` string and
announced *"clears every clause"* for an item the grant writer refuses, including on the
constitutional veto. All three fixed and asserted; `scoutEvictSplit` was extracted so the polarity
has one owner.

### Assertions that could not fail (5)

`[R89.2]`'s six `every()` calls over an unguarded array (vacuous on an empty pool, with the length
asserted in a *different* `ok()`); `[R7.3]`'s per-CATEGORY label, which a seeded **per-plan** cap
passed — fixed with a second caution category, and seed **S121** now reddens it; `[R98.5]`'s gateLog
length check comparing an array to itself after `DB.gateLog = k98.gateLog` made them one object;
`[R100.6]`'s absence limb, which would have passed on a plan that rendered nothing; and the held
block's stated **sort**, rendered as a claim on screen and asserted nowhere.

### Fixture fragility (3)

§89's new `mk89` wrote fifteen cache cells and tore them down with a blind key-delete — the one block
this session did not bring to the standard it applied to §95, §97 and §98. §98 captured
`S.lastPlanPicks` and not `S.lastPlanAt`, splitting a pair whose single reader uses both. §91's
momentum pair silently depended on §74 leaking `S.latest[9741]`/`S.hour[9741]` and never restoring
them, so cleaning §74 would have reddened it for a reason unrelated to momentum. All three fixed.

### Records that outlived what they described (5)

REQUIREMENTS R92.3 still specified the exact copy the assertion now **forbids**; R92.5 described the
unconditional line; R91.1 cited a wiring assertion that was deleted as *"a grep, not an assertion"*;
R101.6 claimed *"every plan build"* for a warning that sat below two early returns; and R100.5's
label claimed the chain had *"silently lost a fed weight"* — it never did. All corrected.

**And the one that is worth its own line:** routing `hourWeight` through the resolver, the ruling's
headline, is a **behavioural identity today.** `itemSeries` derives `byHour` from `sp` on every
branch before choosing one and never returns null, so the routed and unrouted forms are the same
function of the same array, and **no assertion can distinguish them** until something other than the
spark feeds a profile. The routing is prospectively right and structurally better; the report and the
label claimed more than that, and now say exactly what is pinned and what cannot be.

---

## What the agents CLEARED, so the next run starts from a list

- **The score's operand order is byte-identical to HEAD.** No reassociation, no reordering; `wFed` is
  a sibling key and does not enter the product.
- **No money path touches the new grouping.** `planGroups` has one caller, on already-funded picks;
  `wFed`'s only production readers are three render helpers. Funding and sizing are untouched.
- **Both new money-path assertions are arithmetically sound**, re-derived independently:
  `familyKey`'s ten-step replace chain really does put *Probe seeds* and *Zephyr seeds* in different
  families while `cautionCat` puts them in one category; `tierFromPrice(20000)` is tier 2 for all
  four T2 fixtures and `t2Live` counts distinct ids; `[R95.2]`'s winner arm is net-positive **after
  tax** and its two-loss arm is short for the **count** reason and not an incidental one.
- **`[R91.1]`'s eight boundary cases are all correct** against the shipped constants, with the live
  buy price confirmed as 100 for both readers, and case 7 sitting exactly on the flat guard's strict `<`.
- **`[R40.4]`'s noon anchor is right in both DST directions**, and it exercises the calendar-day
  branch rather than the 2h fallback — which would have flipped the 6h arm's verdict.
- **`opsPick`'s hasOwnProperty form changes no stored row's meaning**: every writer of `DB.itemOps`
  was enumerated, and `opsSet(id, {tierOv: next})` is the only path that writes `null`.
- **`S.gateNameOff` costs nothing** — `candidateFor` runs over the watchlist and the scout's twelve
  per tier, not the 4,497-item sweep — and `S` is never serialized.
- **Every era flag has a live pin** (`CUTOVER_POOL`, `ITEM_OPS`, `VOL5_UNIVERSE`,
  `SCORER_CAPTURE_GRADED`, `MM_BENCHED`, `REGIME_RACE_RETIRED`, `SLICE_SAMPLING_RETIRED`).
- **The anti-tripwire enumeration** — 40 distinct copy-bearing subjects read from constants or
  zero-argument functions, each traced to whether its section injects the state it reads. One
  confirmed anti-tripwire (the frame, fixed), one inverted (`[R76.9]`, fixed), one stale-in-waiting
  with nothing holding it (`sc-sixgate`'s glossary text). Everything else clean.

---

## Still owed

- **The teardown assertions cannot discriminate set-or-delete from a blind key-delete.** The probe
  runs with DNS dead, so `/mapping` never loads and every captured cache cell is `undefined` in
  every run — the conditional's set branch is unreachable. They detect a *missing* restore, which is
  real but narrower than their labels claim. The remedy is the tenth-face decoy the project already
  uses for `blendFrag`: have each block plant a sentinel on its own ids before the capture, so the
  set branch executes, with a standing assertion holding the fixture to carrying it.
- **`chartWireState`'s could-not-check branch is unreachable from production** — `t0Coverage` always
  returns a finite `observed`, and the real producer is the surrounding `catch`, which carries a
  *second copy of the copy*. `[R94.1]` asserts the unreachable one. One owner, one string, and the
  assertion pointed at the reachable producer.
- **The `sc-sixgate` glossary entry** says `marketStatsFor` carries no chart inputs yet; after step C
  it does, gated. A stale constant with no landing path and nothing pinning it.
- **`planInertLine`'s empty-return is still structurally unreachable** while `VOL5_UNIVERSE` is
  false, since the 5m sentence always renders for a non-empty pool. Flagged so nobody tries to prove
  it with a seed that cannot bite.
- **Redundant conjuncts** in `[R95.1]`, `[R98.6]` and `[R89.2]` — implied by their neighbours,
  harmless, recorded.

---

## Suite

`PROBE-PASS — 1,234 assertions, BOTH viewports, pairing clean both directions
(462 tags / 474 rows / 462 cited)`. **Seeds S116–S122, one at a time, restore-green between**, each
isolated to its own assertion. Two of them — **S119** (the gate-name detector) and **S121** (the
per-plan cap) — redden assertions that passed with the defect fully seeded before this pass's repairs.
