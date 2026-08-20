# Pass 8 — the nine staged repairs, read cold and then read adversarially

**Scope:** the nine repairs in `staging/`, which have NOT landed. **Frozen at both ends** —
`staging/index.html` `17a3b4d4756c2eea…`, `staging/probe-snippet.html` `3718f7b31b695484…`,
`index.html` (the tree) `3cf9a22d321892e5…`, unchanged from launch to report.
**Seven non-overlapping readers**, each given one subsystem and told to argue from quoted source.
**No finding rests on a suite result** — the suite was not run during the pass.

**Money-path count: 25.** Thirteen of those I traced end to end myself against the frozen file; the
other twelve I read and found sound but did not independently re-derive, and they are marked accordingly. Twelve
further findings are about the new assertions rather than the product, of which eight are confirmed.

---

## The headline, and it is not the one that was hoped for

**The chain did not break.** Every adversarial pass since the second has found defects inside the
previous pass's repairs, and this one — the first set to go through staging and cold review — is no
exception. Three of the nine repairs contain a money-path defect *of the same class the repair was
written to fix*:

- **Repair 2** was written because a migration snapshot and a live write path had drifted apart.
  Its reconciliation runs at boot on this build, and the write path it ships beside re-opens the
  same gap the moment the reconciliation finishes.
- **Repair 3** implements *one question, one term*. Its guard reads the `vol5` flag off an injected
  set while the mechanism that flag governs reads the const — two owners, inside the repair for two
  owners.
- **Repair 8** was written because the membership of a rule had been drawn from where the keys live
  rather than from what the keys do. Its own membership was drawn from where the keys live.

**What DID change is the order of discovery.** Repair 8's class miss was found by the cold review,
before the pass ran, from the diff alone and without the finding. That is the mechanism working as
designed. It is also the only one of the three the review caught — the other two needed a reader
with the whole subsystem in front of it.

---

## Money-path findings, by repair

Sites are anchored by quoted text. **[T]** = traced end to end by me against the frozen file;
**[R]** = the reader's argument, read and found sound but not independently re-derived.

### Repair 1 — the leg placement horizon

**1.1 [T] MONEY · NEW REGRESSION. `trackExistingOffer` now stamps an unfloored gap, and the path it
stamps can land a position directly at `stage: "selling"`.**
Before this repair the record had no `hzH`, so `legHorizonH` fell back to
`Math.max(1, DB.fillHorizonH || 4)` — **a one-hour floor**. `placementHzH()` has none:
`gapHoursAt` returns `Math.min(24, (n.at - ts) / 3600e3)` and the one-hour output floor was
deliberately removed on Aug 13. A repair done at 11:56 against a 12:00 touch stamps `hzH = 0.07`.
The path sets `p.stage = "selling"` with no `stageAt`, and `sellAgeInfo` ages from
`p.stageAt || p.placedAt` — so rung 1 at four minutes, rung 2 at eight, and `nextMove()` names the
position for **UNDERCUT & EXIT**, which relists one tick under the instabuy and forfeits the whole
quoted spread. Walking up a few minutes early is at least as likely as a few minutes late.
The floor's removal was justified in the source on the grounds that the degenerate case *"is now
handled where it arises, by coalescing sessions at `SESSION_COALESCE_MIN`"*. That constant appears
only inside `walkUpSessions()` and its copy; it has no path to `gapHoursAt`. **The stated
replacement guard does not reach this consumer**, and `placementHzH` is a new kind of consumer
anyway — the old readers used the unfloored gap transiently for sizing; this one freezes it onto a
record that is never re-derived.
*The cold review recorded a divergence here and withdrew in the repairer's favour. The withdrawal
was wrong, for a reason neither naming stated: the fallback has a floor and the stamp does not.*

**1.2 [R] MONEY · PRE-EXISTING. The sell leg is aged against the buy placement's horizon, and there
are three sell-creation moments that restart the clock without restamping the ruler.**
`p.stage = "selling"; p.ask = ask; p.stageAt = Date.now();` and `repriceSell`'s
`p.ask = ask; p.stageAt = Date.now();` both start a new in-game offer at a new moment;
`sellAgeInfo` measures it against `legHorizonH(p)`, which is the *buy*'s stamp. On the default
schedule: buy placed at the 17:00 touch (`hzH = 4.5`), fills at 20:30, listed at 21:35 into the
9.5h overnight sit — rung 2 fires at 06:35, on a leg doing exactly what the schedule priced it for.
PASS.md raised the first of these for a ruling; the re-list case is new.

**1.3 [R] MONEY (narrow) · PRE-EXISTING. "Absence stays absence" is true of the record and false of
the value.** `legHorizonH`'s fallback reads the live `DB.fillHorizonH` slider, so dragging that
setting from 4h to 1h flips every open stampless leg past 2h to rung 2 — a horizon change
retro-applied to open legs, arriving through the fallback rather than through the stamp.

### Repair 2 — the operator-state store

**2.1 [T] MONEY · NEW. The reconciliation closes a window and the write path re-opens it
immediately, with no third generation.**
`itemOpsReconcile` is latched by `if (DB.itemOpsV2) return 0;` and runs at boot on **this** build,
where `const ITEM_OPS = false;`. `opsWrite`'s off-flag branch writes the watch row. So from this
build's first boot until the ruled flip, every press on the tier cycle, the test buttons and the
quantity box goes to the row while the store holds a snapshot frozen at that boot — and at the flip
`opsPick` prefers the store for any key it owns. An operator who cycles an item to **untiered (0)**
after the V2 boot has set a bench; at the flip the store answers with the pre-V2 `tierOv: 2` and
the item draws from the T2 budget again. **A bench removed with no press** — verbatim the defect
the function's own header says it exists to fix, one generation later. Nothing clears
`DB.itemOpsV2` anywhere in the file.

**2.2 [T] MONEY · NEW. The 90-day prune lapses an override onto the stale row, and its own comment
forbids exactly that.** `ITEM_OPS_RET_MS` is annotated *"An override does NOT expire — an override
lapsing on a timer would be a restraint lifting with no press, which is the constitutional line"*,
and `itemOpsPrune` does `delete s[id]`. Once armed, `opsWrite` writes **only** the store, so the
watch row keeps whatever it held before the flip, forever. Deleting the store row does not return
the item to "no override" — `opsPick` falls through to `w.tierOv`, the stale pre-flip value. An
operator's `tierOv: 0` bench reverts to `T2` ninety days later, triggered by a press on **a
different item**. The migration's claim — *"a value can never be counted or applied from both
places"* — is true at any instant and false over time, because the store's answer disappears on a
clock and the row's does not.

**2.3 [R] MONEY. The store outlives the watch row.** `removeWatch` and the scout evictions splice
the row and never touch `DB.itemOps`; re-admission pushes a blank row. Today the row *is* the
state, so removal clears it — the operator's model. Once armed, a re-added item inherits the old
manual size, tier override and graduation stamp for up to 90 days. Reach is wider than the
watchlist: the three pseudo-entry `candidateFor` callers all exclude watch items and therefore read
store-only values, so scout admission, the discovery slice and the paper book's screening cohort
are judged with operator state belonging to a row that no longer exists.

**2.4 [R] MONEY. A proven-loser bench is released by `tAt` alone, and the item-store import branch
can supply `tAt` with no pair behind it.** `provenLoser` releases on
`if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`. Every writer keeps the three
tested fields together except the import branch, which copies the seven keys independently and
range-checks only `tierOv`. A file carrying `itemOps: { "<id>": { tAt: <recent> } }` lifts the bench
with the flag armed — a restraint removed by a file rather than a press.

**2.5 [T] MONEY · reachable TODAY, flag off. A future-dated `tAt` never expires.** Neither restore
path bounds `tAt` from above (`o.tAt = num(w.tAt) || Date.now();`), and both readers test one edge
only (`Date.now() - (OPS.tAt || 0) < TESTED_TTL_MS`). A `tAt` in the future makes that difference
negative, so the file's prices override live prices **permanently** and the proven-loser bench is
permanently released. Trigger is clock skew between exporting and importing machines. The 16h TTL
is the only thing between a tested pair and a permanent price override, and it is one-sided.

**2.6 [R] MONEY at the edges. "Does this item have a tested pair?" is answered four ways, two of
them under the same name.** `calc` requires both finite **and** `> 0`; the watch column and
`testDot` require both finite; the eviction guards and the filter key read `tBuy` alone;
`provenLoser` reads `tAt` alone. The comment above the column claims the unification is done — the
*source* was unified through `opsFor`, the *predicate* was not. The disagreement region is
`tBuy <= 0 || tSell <= 0`, reachable through 2.4's import branch, and it lands on eviction (a
restraint) and on the proven-loser release (a widening).

### Repair 3 — the three cutover flags

**3.1 [T] MONEY · NEW, and it is the two-owner rule inside the two-owner repair.**
`cutoverFault` decides *"is the 5-minute streak counted universe-wide?"* by reading the set it is
handed: `if (s.pool && !s.vol5)`. The code that actually decides it takes no parameter:
`const vol5Population = () => VOL5_UNIVERSE ? S.items.map(it => it.i) : DB.watch.map(w => w.id);`.
So an injected `{ pool: true, vol5: true }` passes the guard while the counter is still
watchlist-only — **the refused state wearing the legal state's clothes**. Since `CUTOVER_POOL` is a
pinned const, injection is the *only* way the armed pool branch is reachable today, so **every
exercise of the armed pool path runs in the regime the guard exists to forbid**: pool candidates
funded with their 5m die-off streak not counted, `volGateFor` falling through to the 1h branch, and
pool items therefore sized larger than an identically-placed pin in a collapsing book. The guard
reports a coverage it does not have. Stated in its variables: **any run where
`s.vol5 !== VOL5_UNIVERSE`.**
Fix shape, and the file already has the pattern: `vol5Population` takes the flag the way
`opsOf(id, armed)` and `poolControlsHTML(x, armed)` do, and `cutoverFault` reads that same term.

**3.2 [R] MONEY (post-cutover). Two thirds of the pool benches with an instruction that cannot be
followed.** The bench copy says *"Override the tier on its watch row to include it"*;
`poolControlsHTML` renders only inside `renderPick`, i.e. on **funded** lines, and the bench row
builder emits name + reason + the exception button only. The file's own note puts the untiered
share at *"the 66% of control-cell items that land untiered"*. Direction is restraining, but it is
a restraint the operator is told they can lift and cannot.

**3.3 [R] MONEY. `poolControlsHTML` is documented as the operator's channel to RESTRAIN a pool
item; both of its buttons can only widen.** The tier cycle there is
`cur == null ? 1 : cur === 1 ? 2 : null` — it never reaches `0`, so the only reachable transitions
are *untiered → T1* (removes a bench) and *T2 → T1* (swaps the one-third ramp for the one-half
ramp). The test button writes a tested pair, which removes three restraints at once: it overrides
live prices for 16h, releases a proven-loser bench, and waives seasoning. **The verdict the comment
reaches is right and its argument is inverted**, and this comment exists specifically to steer the
next reader — one who believes the missing channel is a restraint is being pointed toward arming
`ITEM_OPS` alongside `CUTOVER_POOL` in one press, which is deployment-class.

**The eight-combination enumeration is in the reader's record and is a deliverable.** Derived once:
`cutoverPoolOn()` reduces to `P && V`. Rows 5 and 7 are refused; rows 6 and 8 widen because a ruling
widened them; rows 2 and 3 are restraining or neutral. Two gaps: the refused region is not what it
says it is (3.1), and the `ops` axis is unrefusable because `s.ops` has no reader anywhere.

### Repair 4 — seasoning

**4.1 [T] MONEY · PRE-EXISTING, inside repair 4's own property. An offline boot — or one empty
`/latest` payload — deletes the entire seasoning store.**
`updateQualStreaks` is the only accrual path in the app with no live-data precondition; its
siblings all have one (`scorerCycle`: `if (!S.min5At || !S.latestAt || !S.items.length) return null;`
· `stampDeployLog`: `if (!S.latestAt || !P) return;   // an offline boot reads funded 0 and must not
pollute the series`). At boot the stamp is `"0|0"` and `S.qualStamp` is `undefined`, so the guard
passes. `doRefresh` runs `renderAll()` from its **`finally`**, i.e. on the error path;
`renderAll` reaches `renderHomeVitals()` on every tab, which does
`try { P = buildPlan(); renderDeploy(P); } catch(e){}`; `candidateFor` returns
`{ id, name, failed:"no live price in /latest" }` for every row; and the pass loop does
`if (x.failed){ if (DB.qual[x.id]){ delete DB.qual[x.id]; …` for the whole watchlist, then `save()`.
Two live triggers: the app opened with the API unreachable, and `/latest` returning HTTP 200 with an
empty payload (`S.latest = d.data || {}` — which also *sets* `S.latestAt`, so that one fires
mid-session too). Cost: every item to `n = 0`, three counted passes at most one per touch plus a
calendar-day rollover — roughly a day of the plan funding nothing, from one failed refresh.
**This is repair 4's property one step out: a candidate that failed for lack of DATA is not a
candidate that failed a GATE, and the reset treats them identically.** Repair 4 taught the code to
distinguish absence from failure for the pool population and left the data-absence case for
everyone else.

**4.2 [R] MONEY. A long gap freezes a streak instead of resetting it.** The `qualGapCleared` branch
withholds the *credit* (`if (now - q.lastAt <= QUAL_GAP_MAX) q.n++;`) but keeps `q.n` and
`q.firstAt`, and re-stamps `q.lastAt`. An item at `n = 2` from three weeks ago takes its third count
at the very next touch, and `qualSpanned` passes immediately because `firstAt` and `lastAt` are
different calendar days. Reopening at 09:00: the stale item funds at the 12:00 touch on one
observed pass; a fresh item cannot qualify until the following day. Roughly 3 hours against 27. The
comment claims the opposite.

**4.3 [R] MONEY. A once-a-day user can never reach a second counted pass**, and the surface promises
an ETA that will never arrive. `QUAL_GAP_MAX = 12h` is wall time between *observations*, and the
poll loop returns early on `document.hidden`. Every `now - q.lastAt` is ≈24h, so `q.n++` never runs
while `q.lastAt = now` always does. The row sits at `n = 1` indefinitely and renders
`' · qualifies at ~' + eta… + ' if it holds'` — verbatim the failure the file's own provenance
comment says the design must avoid. The margin-test and logged-trip exemptions still work; the
automatic path is what is unreachable.

**4.4 [T] MONEY · defeats the ruling repairs 6 and 9 implement. `qualExemption` reads a flip's `id`
as its date.** `if (DB.flips.some(f => f.itemId === id && f.id >= cut)) return "logged round trip in
30d…"` — `f.id` is stamped at *log* time (`const rec = { id: Date.now(), …`), and the record carries
an honest `date` field this predicate ignores. The import path is the sharper edge:
`const id = num(f.id); const o = { id: id > 0 ? id : uid(), …` with
`const uid = () => Date.now() + (seq++);` — a `flips` array whose entries carry no `id` gets every
flip stamped with the import instant, so **every item in that history waives seasoning on the next
plan build**. `DB.qual` and `qualV1` are deliberately withheld from `validateImport` so a restraint
cannot be lifted by a file; the same restraint is liftable through the file's `flips` array, which
**is** carried. *Caveat that changes the fix: `f.id`-as-clock is a house convention, not a one-off —
`itemWins`, `realizedSince`, the recent-flip eviction guards and the exception lane's trip counter
all read it the same way. The copy is wrong in all of them; only this one lifts a gate.*

**4.5 [R] MONEY (post-cutover). `DB.qual[id].src` is stamped at row birth and never re-stamped**, so
an item that first seasons as a pool candidate and is later pinned keeps `src: "pool"` permanently —
retained on 30-day staleness rather than membership, and **evictable by the pool-only belt whose own
note promises `"Watchlist rows are never evicted."`**

**4.6 [R] MONEY (post-cutover). Pool rows that survive a disarm re-qualify instantly on re-arm**, up
to 30 days later: the row is not in `all` so it never advances, and not in `failSet` so it is never
deleted. It sits frozen and funds on the first scored bucket after the flag returns. Requires an
arm-and-roll-back within 30 days — which is exactly the sequence the cutover gate contemplates.

### Repair 7 — the plan's ordering

**7.1 [T] MONEY · AMPLIFIED. The new blame line asserts "plan is full" on rows the plan being full
would have prevented.** The soft-fill push is guarded by
`if ((tooSmall || cap <= 0) && !ramped && byLiquidity < x.qty && !full_ && …)` and carries **no
`whyKey`**. The picker keys entirely off `whyKey`, and its default is the "full" case — both new
branches begin *"plan is full"*, and `cands = picks` offers every funded pick as a remedy. For a
soft-fill row that is false 100% of the time by the guard above, and the row is unfunded for a
reason a freed slot cannot change. The demote handler applies immediately, so the operator loses a
funded line for the rest of the day and the item they wanted still does not fund. *The old copy made
the same false claim less specifically; A1's reason work made it more detailed rather than true.*

**7.2 [R] MONEY. `whyKey` reports position in an ordered ternary, so `tooSmall` disappears under
`full_`.** `whyKey: blockedCluster ? … : full_ ? "full" : tooSmall ? "toosmall" : "budget"` tests
`full_` first, but `tooSmall` is intrinsic to the item. An item that is both reports `"full"`, the
picker offers all seven picks, and on rebuild after the demotion the item lands in NEXT UP again —
now honestly labelled *"no demotion can fix this"*. The truthful verdict was available at the first
render and was suppressed by ordering. This is the constitution's own *ordered chain reports
position, not cause* rule reproduced inside one ternary.

**7.3 [T] MONEY (post-cutover) + a copy claim live today. `applyFamilyRule` runs before `planOrder`
and picks on raw score across populations.** `pass = applyFamilyRule(pass, bench);` then
`pass = planOrder(pass);`, and the family winner is chosen by `x.score > cur.score`. The loser goes
to `bench` and never reaches `planOrder`, so A1's tenured-first concatenation cannot protect it. A
pool item sits at 1.0 on the hour and stability weights because it has no series while a pin's can
run to roughly a third, so **a pool item with strictly worse economics can bench a pin.** The two
call sites are declared in the source as pass 7 finding 7, queued by the user. **What is not
declared is the copy**: the new NEXT UP header renders, unconditionally, *"Pins are funded before
pool items, so a pool line waits behind every pin above it however good its economics."* That
sentence is false for any pin the family rule benched, and it is the sentence the operator reads.

**7.4 [T] non-money but operator-facing, reachable TODAY in two presses. The unproven-tier-1 banner's
scope breaks under the new promoted group.** The banner fires on the first unproven T1 in render
order (`if (p.tier && p.tier.t === 1 && !p.tier.proven && !unprovenBanner)`), and its copy claims
*"everything after it in the T1 group is a test-first candidate at half size."* Tier order is the
*second* key in `planCmp`, and inside `promoted` it is never reached because `planRank` short-circuits
for any two distinct promoted ids. Promote an unproven T1, then a proven T1: a proven full-size line
renders beneath a header saying it is test-first at half size. The operator places a one-unit margin
test instead of the full line, or halves a line the allocator sized full.

**7.5 [R] non-money. A promote does not survive the family rule.** `applyFamilyRule` runs before
`planOrder`, so a promoted item that loses its family is pushed to `bench`, not `nextUp`;
`S.promoteFor` then names an id in no group and **no picker renders anywhere** — the press produces
no visible effect and no explanation. Two copy strings over-claim against this.

### Repair 8 — the cap table

*(All four were also the reason the cold review sent this repair back.)*

**8.1 [T] MONEY · NEW. The load clamp's central argument is backwards.** It refuses to range-clamp a
finite value, on the stated grounds that *"`slots: 0` clamped up to 1 would WIDEN — from funding
nothing to funding a line"*. But three consumers read through `|| default` —
`Math.max(1, Math.min(8, DB.slots || 7))`, `nonSib() >= (DB.watchCap || 25)`,
`sleeveNewOpenCount() >= (DB.sleeveMaxPos || 3)` — and zero is falsy, so a stored `0` resolves to the
**default**, the widest sane value. Clamping to 1 would have tightened 7 → 1. **Declining to clamp
is the loose choice, by 7× on offers funded**, and the refusal produces the outcome it was written to
prevent. Reachable only from the boot path, which is the path this code was added to guard.

**8.2 [T] MONEY · NEW. The clamp coerces and one consumer does not.** `clampCapKeysAtLoad` tests
`Number.isFinite(+v)`; `partCap()` tests `Number.isFinite(DB.partCapPct)` with no coercion. A stored
`"3"` passes the clamp untouched, fails `partCap()`'s test, and falls back to **10%** —
participation on every sized line at 3.3× the intended size. The two copy sites read it a third way
(`DB.partCapPct != null ? DB.partCapPct : 10`), which *does* accept the string, so the bench line
says *"participation-capped at 3%"* while the sizing used 10%. **One question, four owners** across
the nine keys: the clamp's coerced test, `capResolve`/`nz`, `partCap`'s uncoerced test, and the
`|| default` / `!= null` consumers.

**8.3 [T] MONEY · NEW. `t1Budget`, `t2Budget` and `sleeveBudget` pass the table's own membership test
and are not in it.** They bound what may be funded more directly than anything in the table
(`pools = { 1: Math.min(t1Budget, deployable) }`); an unreadable value resolves to the **default**
(60m / 30m / 60m) where the table's rule is *tight*; and `clampCapKeysAtLoad` never reaches them, so
the boot path still carries for them the exact hole this repair closed for the nine. They also carry
**no upper clamp on either path** — `Math.max(0, …)` with no `Math.min` — so an imported
`t1Budget: 1e12` removes the tier restraint outright. The classification is internally inconsistent
as it stands: `sleeveMaxPos`, the sleeve's COUNT cap, is in the table; `sleeveBudget`, the same
subsystem's MONEY cap, is not.

**8.4 [T] MONEY · NEW. No `hi` clamp on the load path either**, and the comment gives a reason only
for the `lo` direction. `Math.min(hi, v)` can only ever tighten. `slots` and `partCapPct` are
re-clamped downstream by accident; these are not — `clusterCapPct: 500` yields
`Math.floor(workingStack() * 500 / 100)`, **five times the working stack**, silently disabling the
only layer in the app that caps capital across a basket.

**8.5 [T] non-money. A dead guard with an assertion holding it alive.**
`if (!Object.prototype.hasOwnProperty.call(DB, k)) continue;` can never fire — the `DB` literal
defines all nine keys and no `delete DB.<capkey>` exists anywhere. `[R107.14]` reaches it by doing
`delete DB.scoutT1Cap` in the fixture. Per the standing rule, the assertion moves to the layer
production uses **before** the guard goes; deleting the guard first would turn a green assertion red
and read as a regression.

---

## The new assertions — 20 written, 12 carry a finding, 8 confirmed

The two worst are both the rule this project made BINDING today: **an assertion's subject is the
branch that reads a term, not the term itself.**

- **`[R107.14]`, load half** — calls `clampCapKeysAtLoad()` directly. Deleting its one call site
  (`try { clampCapKeysAtLoad(); } catch(e){}` in `load()`) leaves the suite green. Not an
  unreachable-branch case: the probe already drives `load()` elsewhere, so
  `DB.slots = "seven"; flush(); load();` was available and cheap.
- **`[R107.12]`** — its label claims *"`planRank` is the first comparator key"*; what it proves is
  that the promoted **bucket** concatenates first, which comes from `planGroups`' predicate and not
  from `planCmp`. Deleting `(planRank(a) - planRank(b)) ||` from `planCmp` leaves it green. The key
  only matters with two promoted items in one group, which the fixture does not have.

Others worth acting on: **`[R107.2]`**'s second conjunct cannot be exercised at all, because
`cutoverSetFrom` writes `s.ops` and nothing anywhere reads it (this is the same defect as 3.1, on the
other axis); **`[R107.3]`** claims *"every consumer"* and calls none of the three named consumers;
**`[R107.7]`**'s scoping claim is unproven because its fixture builds `buildPlan()` with no injection,
so the funded block's decoy header cannot exist; **`[R106.5]`** pins a count by text-matching one
spelling of `DB.positions.push(`, while `DB.positions.splice(idx, 0, …)` is already an idiom in the
same file; **`[R107.8]`**'s *"and advances one"* limb is satisfied by `>= 2` against a row seeded at
`n: 2` under a schedule that makes the advance not fire.

One stale cross-reference: `load()`'s comment says *"`[R107.6]` holds this"* about the `qualV1`
non-carry. `[R107.6]` is the `itemOpsReconcile` assertion; the one that holds it is `[R107.10]`.

**One reader claim I checked and did not sustain.** It was argued that `[R107.13]`'s second
conjunct cannot fail because the fixture's input carries no `qualV1`. The conjunct tests
`validateImport`'s *output*, which is a fresh literal — an unconditional re-add
(`qualV1: d.qualV1 ? 1 : 0`) would set the key and redden it. The true, narrower version: a
*conditional* carry would evade this fixture.

---

## Sub-areas checked and found sound

Recorded so they are not re-read: `inheritHzH`'s `{}` return at both call sites; the
`Object.assign` shrink branch in `partialPosition` (no stamp dropped); `validateImport`'s position
`hzH` carry (its guard matches the reader's test exactly); `opsWrite`'s row branch writing `null`
rather than deleting (traced every consumer — none can tell `null` from absent, and nothing
enumerates keys on a watch row); the four-state tier cycle in both regimes; `itemOpsReconcile`'s
idempotency; `opsFor` on a null or synthesised row; the t2-graduation guard's four states; the
synthesised `{ id }` row through `candidateFor` (every absence produces the documented reading);
`markSrc` provenance; type consistency across every Set / array / object-key boundary in
`updateQualStreaks`; `qualRetain`'s three `src` states; the cadence seam between `scorerCycle` and
`updateQualStreaks` (the two sets are written back-to-back, disjoint by construction, consumed
repeatedly and idempotently, never zero times); **`Infinity - Infinity` in `planCmp`** (yields `NaN`,
which is falsy, so the `||` chain proceeds correctly and no `NaN` ever reaches `sort`); incomparable
keys inside the `promoted` group (never arise — distinct ids give distinct finite ranks, so
`planSortKey` is never consulted there, though the no-duplicate-ids invariant this rests on is
unstated); render order versus funding order (equal in every constructed case); stale references
after `pass = planOrder(pass)`; budget pool arithmetic; `tight` inside `[lo, hi]` for all nine cap
keys; behaviour-identity of all nine `capResolve` call sites against the old `impCap` forms; `warn`
usability and non-clobbering at the clamp's call site; and boot order of the clamp relative to every
consumer and migration.

---

## What is owed

**Nothing has landed.** `tools/stage/land.sh` refused on 8 of 9, and these findings are additional
reasons not to force it. The repairs that need work before the set can land again are 1, 2, 3, 4, 7
and 8 — which is six of the nine, and the honest reading of that is that a staged pass of nine
repairs is too large a unit for one cold review to clear.

**The cutover gate is further away than it was.** Finding 3.1 means the armed-pool path has never
been exercised in the regime the guard calls legal, so the adversarial pass over the cutover surface
would have been reading a state the product cannot enter.
