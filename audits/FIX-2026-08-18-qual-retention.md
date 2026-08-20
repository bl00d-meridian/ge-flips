# Fix shape — 2026-08-18: `DB.qual`'s retention rule for a pool-fed store

**Report only, per the ruling. No code changed, no plan behaviour changed.** This states
what the store is, why its prune exists, exactly what the cutover breaks, the retention rule
I propose, and the partition question answered at birth. Deployment-class: the store gates
funding, so the fix rides your press.

---

## §1 · The store, its writers, its readers

`DB.qual` is `{ [itemId]: { n, firstAt, lastAt } }` — a **sustained-qualification streak**:
counted full-gate passes, one per touch window, which the seasoning gate reads before an
item may be funded for the first time.

| | |
|---|---|
| **written by** | `updateQualStreaks(all)`, called once per `buildPlan`, which rides the poll |
| **read by** | `qualState(id)` → the seasoning gate in `buildPlan`, the qualifying-pipeline render, and the gate-health ledger's `seasoning` row |
| **carried by** | `validateImport`, which enumerates `{n, firstAt, lastAt}` explicitly and drops anything else |
| **seeded once by** | the `DB.qualV1` migration (Aug 10 2026), which grandfathered every then-current watch item as `{ n: 3, firstAt: now−3h, lastAt: now−1h }` |

Row lifecycle today, in order, inside one call:

1. for each candidate that **failed** — `delete DB.qual[id]` (*consecutive means consecutive*);
2. for each candidate that **passed** — create at `n:1`, or increment if a touch window has
   elapsed **and** the gap is under `QUAL_GAP_MAX` (12h — beyond that the gap is a closed
   tab, not an observation interval, so the clock re-stamps without crediting a pass);
3. **then prune:** `for (const id of Object.keys(DB.qual)) if (!DB.watch.some(w => w.id === +id)) delete DB.qual[id];`

## §2 · The prune's purpose is legitimate; its key is the population, and that is what breaks

**The purpose is bounding.** Today the store can only ever hold watchlist ids — step 2 only
creates rows for members of `all`, and `all` is `DB.watch.map(candidateFor)` — so the prune
is doing one job: **garbage-collecting a row when its item leaves the watchlist.** The store
is bounded at `|watchlist|` ≈ 43. That is correct, cheap, and worth keeping.

**What the cutover does to it.** `all` becomes the control cell's pool. Step 2 creates a row
for each pool item; step 3 deletes every row whose id is not in `DB.watch`. Both happen
**inside one function call**, so the row is created and destroyed before the call returns.
`qualState(poolId)` therefore returns `{ n: 0, qualified: false }` for ever.

**No pool item can ever season. The plan funds nothing, permanently — and the bench line
reads "qualifying" with an ETA, which is a claim about time that will never come true.**
That last part is what makes it worse than a plain bug: it is a surface confidently
reporting a state the machinery cannot reach, which is the unreachable-threshold shape
(*"unreachable is not absent"*) with the reader told the opposite.

## §3 · The rule I propose — **the prune is not wrong, it is UNSCOPED**

Two populations arrive at this store with genuinely different lifecycles, and the retention
rule should follow the lifecycle rather than the store:

> **Membership retention is correct for a hand-curated list, because departure is an
> explicit act with a meaning. Staleness retention is correct for a machine-fed pool,
> because departure there is only churn.**

So: **keep the membership prune, scoped to the rows it was written for, and add
staleness-plus-cap retention for pool rows.**

```
step 3a  (watch rows)  if (src === "watch" && !DB.watch.some(...))       delete   // unchanged
step 3b  (pool rows)   if (src === "pool"  && now - lastAt > QUAL_RET_MS) delete   // new
step 3c  (belt)        if (rows > QUAL_ROW_CAP) evict oldest lastAt first, and SAY SO
```

### Why staleness and not pool membership

The obvious alternative — retarget the same membership test at the pool
(`if (!all.some(x => x.id === +id)) delete`) — reproduces the original defect on a new
surface, and worse. **An item absent from the pool this cycle has not necessarily failed;
it may not have been evaluated at all.** `marketStatsFor` returns null for anything without
a live two-sided book, and such an item never enters the frontier — it is *unobserved*, not
*failing*, and the two mean opposite things. Step 1 already deletes on a real failure; a
membership prune would additionally delete on non-evaluation, and against a frontier that
churns roughly 6× a snapshot it would fire constantly. **Absence of a row is not data of
absence.** Rejected.

Staleness keys the row's retention to the row's own timestamp — the same construction the
T0 archive uses, where the keys present *are* the observation record rather than a second
ledger that can drift from it.

### The window is a STORAGE bound, and must be labelled as one

**`QUAL_RET_MS` must not be read as "seasoning expires after N days."** How long a
qualification survives is a strategy parameter and moves only on your explicit instruction;
this fix must not move it by a side effect. The window is therefore chosen to be **longer
than any plausible in-and-out gap for an item still cycling**, so that on today's book it
never fires at all.

**Proposed: 30 days**, matching two windows already in the product (the `t1` trip ledger's
retention and the reliability window), so no reader is learning a new number. Its comment
should say in as many words: *this is a storage bound; seasoning has no expiry, and giving
it one is a separate ruling.*

### The cap is a belt, and it is behaviour-affecting, so it warns

Staleness alone bounds the store by a market property (how many distinct items the pool
touches in 30 days), not by a design constant. Measured: the control cell touched **292
distinct items in 3.53 observed days**. A naive no-repeat extrapolation gives ~2,500 in 30
days and the true figure is well below that, since stock saturates. `SCORER_ID_CAP` is 3,000
for the *loosest* cell, so a matching **`QUAL_ROW_CAP = 3000`** is consistent and generous
for the tightest one. At ~61 bytes per serialized row that is **~183 KB, 3.6% of the 5 MB
quota** — measured, not assumed.

**Eviction costs an item its streak, so it is a plan-behaviour event, not housekeeping.** It
must therefore be rare by construction and must never be silent: a `capped` flag on the
store and a `warn()` naming what was evicted, in the `SCORER_ID_CAP` declared-truncation
pattern. An eviction nobody sees is the cold-cache-eviction shape of the silent-failure rule.

### One behaviour difference, named rather than absorbed

Under the scoped form above there is **none for today's book**: every watch row is touched
every cycle, step 3a is unchanged, and step 3b cannot fire on a `"watch"` row. Behaviour is
bit-identical for the current population.

Had I replaced the membership prune with staleness outright — the tempting one-line fix —
there would have been one: **an item removed from the watchlist and re-added inside 30 days
would keep its streak instead of re-seasoning.** That is arguably an improvement and it is
still a change, and it is exactly the kind that rides along unnoticed inside a "retention
fix". Scoping the prune avoids it. If you want that behaviour, it is its own small ruling.

---

## §4 · The partition question, answered at birth

**What regime writes a row.** Three, and two of them already exist:

| regime | what a row from it means |
|---|---|
| **`"watch"`** | counted passes of the live chain, evaluated as a watchlist candidate — with the operator overlays (tested prices, tier override, wins waiver, the flip-log gates) in force |
| **`"pool"`** *(arrives at cutover)* | counted passes evaluated as a control-cell pool candidate — no operator overlays, and, until chart gates reach 7 of 7, six-gate verdicts |
| **`"grandfathered"`** *(legacy, Aug 10 2026)* | **no observation at all.** The `DB.qualV1` migration wrote `n: 3` for every then-current watch item so the gate's arrival would not bench the whole book |

**What field records it: today, nothing.** A row carries no source, so all three regimes are
already pooled in one store and a grandfathered row is indistinguishable from three real
passes. That is a pre-existing pooling defect, not one the cutover creates — but the cutover
is what makes it load-bearing, because the third regime's rows would then sit beside pool
rows in a store that gates funding.

**Proposed field: `src` on every row**, one of `"watch"` / `"pool"` / `"grandfathered"`.
**Absent reads as *predates the field*** — the third state, never a default to either side.

**Where the stamp comes from, and this is the part that matters:** `planCandidates()` marks
each candidate with its provenance and `updateQualStreaks` reads it off the candidate.
**Provenance must be a property of the candidate, evaluated once centrally — never a label
individual entry paths remember to attach**, which is the standing rule from the regime
race, where four of six entry paths hardcoded an empty set and nothing said so.

**On regime change: rows are not restamped.** The cutover stamps new rows `"pool"`; existing
`"watch"` rows keep their stamp and keep working, because a pinned item is still evaluated
as a watchlist candidate after the cutover. Any reader that reports seasoning statistics
decomposes by `src` rather than pooling.

**The import carry must take `src` in the same commit.** `validateImport` enumerates
`{n, firstAt, lastAt}` and silently drops everything else — the R68.9 shape. A partition
field that dies on restore is *worse than no field*: restored rows would read as
*predates the field* when they do not, so the third state would start lying. Extending the
sanitizer is part of this fix, not a follow-up.

---

## §5 · What the fix is not

- **No gate constant moves.** `QUAL_PASSES`, `QUAL_GAP_MS`, `QUAL_GAP_MAX`, `qualSpanned`'s
  calendar-day rule: all untouched.
- **No plan output changes for any item in the book today** (§3).
- **It does not answer whether seasoning is the right rule for pool items** — your item 6,
  correctly separated. This fix makes seasoning *reachable* for pool items; whether a
  one-calendar-day floor against a 6×-churning frontier is the right bar is a different
  question and a strategy parameter.

## §6 · The detector that ships with it

Four assertions, and the third is the one that would have caught the original:

1. **A pool row survives a cycle in which it is not in `DB.watch`** — the defect itself,
   seeded by restoring the unscoped prune, which must turn it red.
2. **A watch row still dies on watchlist departure** — the preserved behaviour, seeded by
   dropping step 3a, which must turn *this* one red and leave (1) green. The discriminating
   pair: a fix that deletes the prune passes (1) and fails (2).
3. **A pool row that has not been touched inside the window is pruned, and one inside it is
   not** — asserted at the term with the window injected, never through the live constant,
   so the assertion cannot be pinned by the constant's size.
4. **`src` survives the import carry in all three states**, absent staying absent — the
   R68.9 / `[R83.4]` shape.

Plus one **pinned era fact**, per the staging practice's fourth rule: an assertion pinning
that **no row in a fresh store carries `src: "pool"`** while the cutover has not landed. It
goes red the moment the pool starts feeding the store, which forces the stanza that accounts
for the second era rather than permitting it.

---

## §7 · A second finding, separate from the fix

**The grandfathered rows are a third regime that has never been distinguishable, and they
have a latent inconsistency.** The migration wrote `firstAt: now−3h, lastAt: now−1h` — a 2h
span, which satisfied `qualSpanned`'s *then*-current 2h duration test. The cadence ruling of
Aug 11 2026 changed `qualSpanned` under a live schedule to a **calendar-day rollover**,
which those synthetic timestamps do not satisfy unless they happened to straddle midnight.

The rows self-heal — the first real pass moves `lastAt` to today, and `firstAt` (the seed
date) then spans many calendar days — so this is **not a live defect** and I am not
proposing a change to it. It is recorded because it is the clearest available example of why
`src` is worth having: a store whose rows have three different provenances and no field to
tell them apart cannot answer the question this section just asked without reading a
migration's source.
