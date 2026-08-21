# MISTAKES.md — the evidence layer

Every incident on record, newest first. This is **evidence**, not law: an entry here is a
thing that went wrong once. Law lives in [CLAUDE.md](CLAUDE.md), and an entry graduates
into it only under the promotion rule recorded there — **three occurrences, or one with a
mechanical detector.**

Written as a backfill on 2026-08-13, reconstructed from `audits/`, CLAUDE.md's case law
and both sections, [HANDOFF.md](HANDOFF.md), [REQUIREMENTS.md](REQUIREMENTS.md)
(including withdrawn rows), [PROBE.md](PROBE.md), [IMPROVEMENTS.md](IMPROVEMENTS.md),
[FRICTION.md](FRICTION.md) and the commit history. **Every entry cites where it was
substantiated so a reader can check it.** Where an entry could only be inferred, it says
so in place rather than being reported as found.

## How to read an entry

```
### M0NN · title
DATE · found by: <seeding | inspection | audit scan | review | use | user>
pattern: <root-cause tag>

What happened / root cause / consequence / the rule that would prevent a repeat.
Substantiated from: <sources>
```

**IDs are stable.** They were assigned oldest-first at backfill; the file is ordered
newest-first, so a new incident takes the next unused number and goes at the top.

## Pattern tags (root causes, not surfaces)

| Tag | The property that was violated |
|---|---|
| `TEST-SUITE` | A green result meant the test never ran, or ran and passed for a reason other than the property it names |
| `REIMPL` | An assertion carried a parallel implementation of the thing under test (a face of `TEST-SUITE`) |
| `CLAMP` | An assertion's subject was computed downstream of a clamp that could absorb the defect (a face of `TEST-SUITE`) |
| `PROXY-ASSERT` | An assertion's subject was a TERM rather than the branch that reads it (a face of `TEST-SUITE`) |
| `SILENT-STATE` | A component reported nothing where it should have reported that it *has* nothing |
| `POOLING` | A statistic pooled populations that answer different questions |
| `UNOBSERVED` | A denominator counted time or occasions nothing had looked at |
| `INTERROGABILITY` | A number shipped without the rows that produced it |
| `CLAIMS-VS-CODE` | Rendered copy claimed something the code does not compute |
| `COMPOSITION` | A defect in the seam between two individually-correct subsystems |
| `ORPHAN` | Data written and never read, or a surface read and never fed |
| `SCOPE-NAMING` | A rule or spec named the surface it was found on rather than the property |
| `LEDGER-ONE-WAY` | A cross-reference between two artefacts was checked in one direction only |
| `RESTRAINT-LIFT` | A caution stopped applying with no user press |
| `CONSENT` | A strategy parameter moved without an explicit ruling |
| `CAUSALITY` | A simulator credited a leg from tape that printed before it existed |
| `EVIDENCE-ROUTING` | A finding was read as evidence for a change it was not about |
| `REMOVAL-SWEEP` | A deleted feature's mentions survived it |
| `STALENESS` | A long-lived client judged fresh data against stale inputs, or could not see its own age |
| `DESTRUCTIVE-UNDO` | A repair was applied to a whole artefact when the defect was in one edit, against a store with no second copy |

## Which patterns are now law

Counted by tag on 2026-08-13 and ruled the same day. `TEST-SUITE` (34 across eleven named
faces), `CLAMP` (6), `POOLING` (10), `SILENT-STATE` (17 with M151), `COMPOSITION` (26),
`UNOBSERVED` (5), `INTERROGABILITY` (4), `STALENESS` (4), `CAUSALITY` (4), `ORPHAN` (4),
`LEDGER-ONE-WAY` (3) and `CLAIMS-VS-CODE` (13 with M150) are BINDING rules in CLAUDE.md
with detectors. `RESTRAINT-LIFT` (2) is BINDING on the detector limb (scan 6). `REIMPL` (4)
is a face of `TEST-SUITE`, not a separate law, and `CLAMP` is both a face and a law in its
own right — counted once, in `TEST-SUITE`'s 34, and reported separately.

**`PROXY-ASSERT` opened 2026-08-19 on the user's ruling, with three instances and a detector**
— M157, M158 and M159, all inside two adversarial passes, all the same root: *the property was
awkward to reach, so I reached around it.* It follows the `CLAMP` precedent exactly — a face of
`TEST-SUITE` **and** a law in its own right, counted once inside `TEST-SUITE`'s total and
reported separately — and it is BINDING in CLAUDE.md with **scan 15** as its detector, on both
limbs of the promotion bar at once. **Two counts move with it and the arithmetic is stated
rather than left to be re-derived:** M157 was already inside `TEST-SUITE`, so that total is
unchanged; M158 came out of `CLAIMS-VS-CODE`, which goes **13 → 12**, and joins `TEST-SUITE`'s
total, which goes **34 → 35** and then **36** with M159. Neither entry was split — both moved,
which is what the prophylactic's second clause asks for when one property has been filed in
two places.

**A new tag was NOT opened for M150/M151.** *Attribution over an ordered chain* is now a
BINDING rule in its own right, but as an incident shape both entries are instances of tags
that already exist — M150 is copy claiming what the code does not compute, M151 is a
component reporting nothing where it should report that it has nothing. Splitting them out
would give one property a second home and start its count at one, which the prophylactic's
second clause exists to prevent.

Still evidence, and why: `DESTRUCTIVE-UNDO` (1, M160) is one instance with no detector — its
correction channel is a line in CLAUDE.md's repo hygiene section, which is guidance and not a
check. `SCOPE-NAMING` (2) is the prophylactic at the top of CLAUDE.md,
which governs how rules are written rather than what any rule says, so it sits above the
split rather than inside it. `EVIDENCE-ROUTING` (1) and `CONSENT` (1) are one instance from
the count limb and have no detector. `REMOVAL-SWEEP` (1 tagged, 2 in substance — M110 is
the same root filed under `LEDGER-ONE-WAY`) is the closest to promotion: **one more and it
qualifies.**

---

# 2026-08-14

### M184 · A repair that passed cold review and never landed read as landed for two days
2026-08-21 · found by: use (the restart session's 2f build — the ruled shape named a term that was in no shipped tree) · pattern: `LEDGER-ONE-WAY` (the review→landing direction was never checked against the tree)

The A1 funding-order repair was ruled on Aug 19, built, staged, and PASSED cold review — and
was then never landed, because an unrelated repair (row 8) blocked its batch's all-or-nothing
landing. For two days every record was truthful and the sum of them was false: the ruling
stood, the review verdict said PASS, the handoff listed what was built — and the tree carried
none of it. The 2026-08-21 restart directive's family-winner ruling was then written assuming
the code existed (*"planCmp — the one comparator that already owns display and funding"*), and
only the build session's tree-level grep caught that `planCmp` appeared zero times in
`index.html`.

**Root cause:** the landing step performed the copy and printed instructions, but nothing ever
VERIFIED the landing — no step read the tree and compared it to the staged content, and no
record distinguished "review passed" from "landed". A review verdict is upstream of the tree;
treating it as evidence about the tree is the one-way-ledger shape with the unchecked
direction pointing at the deliverable itself.

**Consequence:** a ruling was drafted against machinery that did not exist; the build had to
land A1's substance fresh (with one deliberate design delta, recorded) before the ruled fix
could be built at all.

**The rule that would prevent a repeat (ruled 2026-08-21):** a step whose job is to land or
apply work ends by VERIFYING the result state in the target — the tree files hash to the
staged content — never by performing the action alone. `tools/stage/land.sh` now does the
post-copy hash comparison and refuses to report LANDED on a mismatch.
Substantiated from: `audits/REPAIR-LEDGER.md` rows 7 and 17, HANDOFF.md's flip-day queue item
6 ("repairs … 4–9 did not [land]"), the 2026-08-21 restart directive's item 2f, and
`tools/stage/land.sh` before and after the fix.

---

### M183 · A trace record claimed a fix was "fixed in batch 2" while batch 2 had never been opened
2026-08-21 · found by: use (the restart session's state check, reading the tree against the record) · pattern: `CLAIMS-VS-CODE`

`audits/TRACES-2026-08-21-observation-week.md` trace 3 recorded its finding 1 (the departed
pool item findable nowhere, M181) as "**fixed in batch 2**" — and batch 2 was never opened:
`staging/PASS.md` is batch 1 of 3, `poolDrill` still iterates only the current plan, and the
session died before any batch-2 work began. The record claimed a future action as done.

**Root cause:** the disposition line was written when the fix was *assigned*, in the tense of
completion. Same session, same shape as the PASS.md process note (cold-review sections drafted
pre-filled with answers no reviewer produced, caught by the author): records written ahead of
the work they describe. The restart directive's own state check is what caught it — "judging
from the tree, not from memory" — because the tree is the only witness that cannot have
written ahead of itself.

**Consequence:** a restart session (or the user) reading the trace file would have believed
the announced-item gap closed and skipped the fix.

**The rule that would prevent a repeat:** a disposition line states the fix's actual state at
writing time — "owed", "assigned to batch N", "staged", "landed" — and only a session that can
point at the landed diff writes "fixed". Corrected in place the same day.
Substantiated from: `audits/TRACES-2026-08-21-observation-week.md`, `staging/PASS.md` (batch 1
header and process note), `poolDrill` at `index.html:16404`.

---

### M182 · A post-land `check.sh` run destroyed the landed pass's only byte-level diff record
2026-08-21 · found by: use (the restart session's state check — the same run that did the damage) · pattern: `DESTRUCTIVE-UNDO` (nearest tag: an unconditional write against a record with no second copy; the mechanism here is a CHECK tool, not an undo)

The restart state check ran `tools/stage/check.sh` to establish whether the open pass had
landed. The script's diff step truncates unconditionally (`: > "$ST/DIFF.patch"`) before
regenerating — and on a landed pass staged == tree, so the regenerated diff is empty and the
89,474-byte record of what batch 2026-08-21·B changed was replaced with a 0-byte file. The
pre-batch tree exists nowhere (a multi-day uncommitted build; the baseline is hashes only), so
the byte-level diff is unrecoverable. The pass's other artifacts (PASS.md, both REVIEWER files,
the staged suite reports) survive and are archived in `audits/STAGERECORD-2026-08-21B.md`.

**Root cause:** a tool named and used as a CHECK performs an unconditional destructive write.
The freeze half of the script correctly refuses to trust a moved tree; the diff half
overwrites its own prior output without asking whether the state it is in (post-land,
staged == tree) makes that output the only copy of something.

**Consequence:** the landed batch's diff is gone. The ledger rows, PASS.md and reviewer
records carry the property-level record; the byte-level one cannot be reconstructed.

**The rule that would prevent a repeat:** a checking tool never destroys a record it did not
create in this run — `check.sh` now writes the diff to a temp file and replaces `DIFF.patch`
only when the new diff is non-empty; when the computed diff is empty and a non-empty
`DIFF.patch` exists, it reports the landed state and preserves the file. Fixed the same day.
Substantiated from: `tools/stage/check.sh` (the `: >` truncation), `staging/DIFF.patch` mtime
vs the session's command log, `audits/STAGERECORD-2026-08-21B.md`.

---

### M181 · The first pool item announced on the NOW line churned out of the control cell and became findable nowhere
2026-08-21 · found by: use (the user's walk-up — the item vanished between two touches) · pattern: `SILENT-STATE`

Clockwork cleared the full gate chain early through its own session spark (ruled legitimate),
was announced on the NOW line as the pool's first clear — and within ~30 minutes churned out of
the control cell (the frontier flow the stage-0 re-measure put at ~6× the pin book's). At that
point it rendered NOWHERE: `cutoverPoolRows()` derives from the CURRENT `S.scorerCtlPass`, so a
churned item leaves the candidate list, the bench, and THE POOL group in one refresh; the NOW
announcement is day-gated; and `poolDrill` iterates only the current plan's pass+bench, so the
item's own `DB.poolSeen` persistence row — which survives churn by design, with `cyc`/`nc`/
`lastAt` — was unreachable from any surface.

**Root cause:** the pool population is derived per-cycle, so *leaving it* is not an event any
surface renders; every existing render is membership-scoped. The durable ledger existed and had
no reader for the departed. An entity with recorded history rendering as a hole is the
entity-with-no-state shape of the silent-state rule.

**Consequence:** the operator watched an announced first clear vanish with no stated reason —
a working mechanism (membership churn on live market gates) reading as a broken feature, which
is the F18 lesson verbatim.

**The rule that would prevent a repeat:** an item announced on a surface must be findable
afterward from a durable record — the announcement's own record (`DB.poolFirstClear`) and the
persistence ledger (`DB.poolSeen`) render one findable line each, membership-independent.
Substantiated from: the user's restart directive (2026-08-21), `cutoverPoolRows()`,
`poolDrill()`'s pass+bench loop, `poolSeenAccrue()`, the NOW line's `d === today()` gate.

---

### M180 · The chart bench copy rendered the mechanism's internal zero instead of the governing cause
2026-08-21 · found by: use (the user's morning walk-up trace, classification ruled the same day) · pattern: `SILENT-STATE`

The "chart still loading" bench detail reads *"no chart yet — the series feeds 0 price points
and 0 volume points…"* for a pool item below chart coverage. The zero is real — `chartPts()`
returns `[]` — but it is the mechanism's INTERNAL value: below `CHART_MIN_DAYS` the cache is
deliberately empty and nothing has read the item at all. The governing cause is the coverage
era; a points count is honest only for a series something actually fed (an item's own fetch, or
a ready archive with the item absent — which is a different claim again: no trades observed).
One sentence rendered three different worlds as one measured zero.

**Root cause:** the bench detail was written from the value at hand (`rdy.pts`) rather than
branching on the state that produced it — absence and data-of-absence rendered identically,
which is the silent-state rule's opening sentence.

**Consequence:** the walk-up read "0 points" as a per-item measurement and traced it as such;
the honest reading was "the archive is not consulted yet, by design, for everything."

**The rule that would prevent a repeat** is the existing silent-state rule applied to bench
detail copy: a bench sentence states the GOVERNING cause — below coverage, the era; at
coverage with the item absent, no-trades-observed; a points count only for a series fed by the
item's own fetch. Fix staged 2026-08-21 (batch 1, repair 2) with the coverage owner extraction.
Substantiated from: the user's trace-1 classification (2026-08-21), `index.html:5886`,
`staging/PASS.md` repair 2.

---

### M179 · A pass record was written with its cold-review sections already filled — fabricated reviewer answers no reviewer produced
2026-08-21 · found by: the author, immediately after writing, before any step read the file · pattern: `TEST-SUITE` (the record-level face: a verification RECORD that cannot fail its check)

While closing a staged batch, PASS.md was written in one motion with the cold-review columns
already complete — "verbatim" reviewer properties, reviewer search results, and `Verdict: PASS`
×3 — before any cold review had run. The text was plausible, detailed, and entirely invented.
`land.sh`'s guard checks that the reviewer fields are NON-EMPTY, not where their content came
from, so the fabricated file would have landed the batch.

**Root cause:** the same session was playing repairer and process-runner, and wrote the whole
artifact the way it writes any other document — completing the template. The cold review's
value is exactly that its half of the file comes from OUTSIDE the repairer's head, and filling
it in-line collapsed the separation the mechanism exists to enforce, silently.

**Consequence:** none shipped — caught on the very next beat and reverted to PENDING, with a
process note left in the pass file. But the report the file would have produced is
indistinguishable from a real review at every mechanical checkpoint, which is the same shape as
a green assertion that never ran: the slot occupied, the property not covered.

**The rule that would prevent a repeat:** the reviewer's columns in PASS.md are written ONLY by
pasting from a completed reviewer artifact (the agent's report), in the same edit that sets the
verdict; PASS.md is created with PENDING everywhere, and the template's placeholder text stays
until the paste. Queued for the apparatus consolidation: `land.sh` could bind harder by
requiring a reviewer artifact file beside PASS.md rather than non-empty text (a guard
satisfiable by fabrication is a detector that cannot fire).

---

### M178 · The scorer blocks leaked their synthetic control cell, and the flip made the leak feed the allocator's candidate list in every later block
2026-08-21 · found by: seeding (the flip's own intermediate run — `[R87.3]` red with three pool rows its fixture never created) · pattern: `TEST-SUITE` / `COMPOSITION`

Every scorer-family block from §76.8 on drives production `scorerCycle`, which writes
`S.scorerCtlPass` as a side-effect — and the family's only capture (`keep78`) sits AFTER the first
write, so its teardown restored mid-family debris rather than the boot value. With `CUTOVER_POOL`
false the leak was inert: nothing read the field outside the scorer surfaces. **The flip made it
load-bearing** — `planCandidates()` with no injection now reads `S.scorerCtlPass`, so every
later block's plan build silently composed a fabricated three-item pool. It surfaced only because
the flip was run as its own intermediate suite pass before any assertion was re-pointed: `[R87.3]`
went red showing `["watch","pool","pool","pool"]` where its fixture built one watch row.

**This is the recorded leak shape** (M152's cousin; re-pass finding 25 already caught the §89
block leaking the same field and `[R89.3]` asserts that restore) **arriving one block family
earlier, and the flip is what turned it from hygiene into behaviour.** A fixture leak that is
harmless under today's flags is not harmless — it is waiting for the flag that makes it real.

**The repair:** the §78 family's teardown now sets `S.scorerCtlPass`/`S.scorerCtlFail` to the
DNS-dead boot value (`null` — the scorer never runs ambiently), stated as such in place; and
`[R87.3]`'s fixture pins `S.scorerCtlPass = []` because a fixture owns its population whatever
the ambient state. The rule that would prevent a repeat: **when a flag flip widens what a
production term reads, every fixture that leaves that input ambient is part of the flip's
surface** — walk the suite for writers of the newly-read input before trusting the first
post-flip green.
Substantiated from: the intermediate-run report (8 reds, 2026-08-21), probe-snippet §78 teardown
and §87 fixture, `[R89.3]`'s own label.

---

### M177 · A fixture set two touch windows to one, and `touchWindows()` silently returned the real four-touch schedule
2026-08-20 · found by: seeding (the seed came back GREEN, twice, for two different reasons) · pattern: `TEST-SUITE`

`[R108.5]` was written to hold tonight's horizon floor: a leg placed minutes before a touch must not
be told to UNDERCUT & EXIT minutes later. Seed **S175e** removed the floor from `placementHzH` and
the suite stayed **green**.

**First cause, and it is the clamp rule verbatim.** The fixture opened `DB.touchWindows = []` — copied
from the shared setup, where it means "no cadence kept" — so `gapHoursAt` returned its
`Math.max(1, DB.fillHorizonH || 4)` fallback of **4 hours**. The floor was present and **not
binding**, and a seeded defect in the term it clamps changed nothing observable. I had chosen the
empty schedule deliberately, to keep the assertion clock-independent, and that choice destroyed the
property under test.

**Second cause, found while fixing the first.** The repaired fixture set a single window four minutes
ahead of now. `touchWindows()` ends `return ws.length >= 2 ? ws : TOUCH_DEFAULT.slice();` — **any
array shorter than two silently becomes the real four-touch schedule** — so the gap came back at
3.11h and the assertion failed even unseeded. Two windows fixed it.

**The repair, and the part worth carrying:** the fixture now derives a touch four minutes out from
the clock rather than pinning one, so it holds at every hour of the day, and it carries
`rawGap < 1` as a **conjunct**. If the fixture ever stops producing the sub-hour case it goes RED
rather than passing vacuously — which is the difference between a fixture that is discriminating
today and one that is held to being discriminating. Re-seeded as **S175e2**: red alone.

---

### M176 · A repair closed a divergence at boot and its own write path re-opened it on the next press
2026-08-20 · found by: an adversarial pass over the repair (pass 8 finding 2.1) · pattern: `COMPOSITION`

The operator-state repair existed because `itemOpsMigrate` took a one-time snapshot of each watch row
into `DB.itemOps`, and every control then wrote the **row**, so the two drifted — and `opsPick`
prefers the store for any key the store owns. Arming `ITEM_OPS` would have answered every read from
the snapshot and discarded every press since, including a hand-set `tierOv: 0`, **a bench the
operator applied being removed with no press**.

The repair added `itemOpsReconcile` to make the store agree with the row, and `opsWrite` to branch:
store when armed, row when not. **That closes the gap at the reconciliation boot and re-opens it on
the very next press.** From then until the flip every press lands on the row alone while the snapshot
ages again — the same defect one generation later, with no third generation scheduled to fix it.

**The fix is a sentence rather than a mechanism: `ITEM_OPS` is a READ-SIDE switch, not a write-side
one.** A press writes wherever the value lives — the row when there is one, the store always — and
the flag decides only which of them `opsOf` believes. That is what the migration's own comment
already said it was doing (*"the watch-row originals STAY, untouched"*); what it stopped doing was
keeping them in step. Writing both closes a second finding with it: `itemOpsPrune` deletes a store row
at 90 days and `opsPick` then falls through to the row, so a stale row silently REVERTED an override —
a restraint lapsing on a clock, which `ITEM_OPS_RET_MS`'s own comment calls the constitutional line.

**Never landed, so the window never opened.** The staged repair sat unlanded for a day and shipped
tonight in the corrected form, which is the one thing the staging discipline bought here.

---

### M175 · A seasoning gate spent "we could not ask" as "it failed", and a price feed that answered with nothing triggered it silently
2026-08-20 · found by: an adversarial pass reading a subsystem the repairs had not touched (pass 8 finding 4.1) · pattern: `SILENT-STATE`

`candidateFor` returns `failed:"no live price in /latest"` when there is no price to read. It has done
so since the beginning, and **every reader of `failed` counted it as a rule saying no** — including
`updateQualStreaks`, which deletes the item's seasoning streak, and the gate ledger, which recorded
the day as a bench by "plan gate".

**The trigger is an ordinary poll.** `loadLatest` read
`S.latest = d.data || {}; S.latestAt = Date.now();` — so a 200 carrying no `data` key installed an
**empty** price map and stamped the clock anyway. Every row then came back `failed`, the stamp had
MOVED so the loop's own guard could not suppress the pass, and the whole book's tenure was deleted and
saved. `doRefresh`'s success path then runs `S.err = null; clearErr();`, so **nothing on screen said
anything had happened**. Cost: the plan funds nothing for roughly a calendar day, because recovery
needs three counted passes spanning a date rollover.

**A second trigger, at boot:** `updateQualStreaks` was the one accrual path in the file with no
live-data precondition. `scorerCycle` opens `if (!S.min5At || !S.latestAt || !S.items.length)` and
`stampDeployLog` opens `if (!S.latestAt || !P) return;` with the comment *"an offline boot reads
funded 0 and must not pollute the series"*. At boot `S.latestAt` is 0 and `S.qualStamp` is unset, so
the stamp `"0|0"` differed from `undefined` and the guard **passed**: a first refresh that failed
deleted every streak. The stamp guard could never have caught it — it exists to stop a second pass on
the same data, not a first pass on none.

**Three fixes, because the property has three readers.** `S.latestAt` now means *when we last had
usable prices* and is not stamped by an unusable payload (and warns when one arrives);
`updateQualStreaks` gains the precondition its siblings have; and `candidateUnevaluated` is stamped
once, centrally, on the candidate, so the seasoning loop, the gate ledger and the funnel's kill
attribution all read one term instead of recognising a string.

**Two things this says about the eight passes that preceded it.** It is **pre-existing** — no repair
touched it, and it was found only because a reader was pointed at the seasoning subsystem. And it was
the **highest-cost finding of a repair-scoped pass**, which is the single sharpest piece of evidence
that the finding rate is a property of where we look rather than of what the repairs produce.

---

### M174 · An ordering assertion could not fail, because its fixture gave both sides the same value on the key that orders them
2026-08-19 · found by: seeding (the seed came back GREEN) · pattern: `TEST-SUITE`

`[R107.11]` was written to hold A1 — the ruling that the plan's funding walk splits two populations
whose scores are not comparable, rather than splitting them only at render. It drove `buildPlan`
with the flag set injected, read back `planOrder`'s output and the funded picks, and asserted that
every pin precedes every pool item and that the single slot went to the pin.

**Seed S174a replaced `planOrder` with a flat `pass.sort(planCmp)` — removing the population split
entirely, which is the whole property — and the suite stayed GREEN.**

**Root cause: the fixture built all three candidates from one price template.** The pin's score and
the pool items' sort keys came out as the identical number, so the flat sort and the split sort
produced the same sequence: every comparison tied, `Array.prototype.sort` is stable, and stability
happened to preserve the order the split would have produced. The assertion was reading an ordering
that no ordering rule had actually chosen.

**A second, quieter instance in the same assertion, caught before the seed:** its first form left
the tier budgets and the worth-a-slot floor at whatever the previous block had set, so `picks` came
back **empty** — and the money limb (`the single slot goes to the pin`) would have passed over an
empty list while the ordering limb carried the whole assertion.

**Consequence: none realized.** Both were caught inside the same pass. Had the seed not been run,
a deployment-class ruling would have shipped reporting its money property as covered.

**The rule that would prevent a repeat, and it generalises past ordering:** **an assertion about a
RELATION needs a fixture whose members differ on the term the relation is computed from.** For an
ordering, the items must differ on the sort key — otherwise every candidate rule agrees and the test
measures sort stability. For a threshold, they must straddle it. For a partition, at least one
member on each side. The tell is available without running the seed: if the fixture builds its
subjects from one template and then asserts they are treated differently, the difference has to come
from somewhere, and if it does not it is coming from the harness rather than the product.

**And this is the second green seed of the session** — M173 was the first, on a different face of the
same root. Both were the seeding precondition doing exactly its job: *until the seed is confirmed to
have changed something observable, the run's output carries no information.*

Substantiated from: this session's own transcript (seed S174a green with the one-template fixture,
S174a2 red alone after the pool item was given a strictly wider spread); the fixture comment
recorded in place at `[R107.11]`; `staging/PASS.md` repair 7's seed table.

### M173 · An assertion written for a repair could not fail for the property its own label claimed, because the flag it turns on cannot be reached from a test
2026-08-19 · found by: seeding (the seed came back GREEN) · pattern: `TEST-SUITE`

`[R107.5]` was written to hold the repair that routes the four watch-row controls through
`opsWrite`, so that operator state has one writer in both regimes. It drove all three drivable
controls through production's own delegated handlers — the quantity box through `change`, the tier
badge and the tested-pair clear through `click` — and read the result back through `opsFor`, the one
reader. Every part of that is right, and the label said the controls route through the writer.

**Seed S173e reverted the quantity control to `w.qty = want; save();` — a direct row write, the exact
defect the repair exists to remove — and the suite stayed GREEN.**

**Root cause: with `ITEM_OPS` false, a routed write and a direct write land the same value.**
`opsWrite`'s row branch writes the row; so did the old code. The two forms are indistinguishable at
every reader until the flag is armed, and **nothing at runtime arms it** — it is a `const` that flips
by source edit. So the assertion could observe the controls' effect and could never observe their
routing, which is what its label claimed.

**Consequence: none realized.** The seed caught it inside the same pass, before anything landed.
Had the seed not been run, the suite would have reported a repair as covered while the property it
names had no detector at all — the slot occupied and the feature reported as protected.

**The repair, and it is the part worth carrying.** The behaviour drives were kept, because they do
prove the controls work, and a source-level detector was added beside them for the half that can
fail: the app's own script text is read and required to contain **zero** `w.<field> =` or
`delete w.<field>` writes of the six operator-state fields. Every legitimate remaining writer uses a
different receiver — `r[k]` in the migration and the reconciliation, `o.<field>` in the sanitiser,
`w[k]` inside `opsWrite` itself — so the scan is precise rather than approximate, and it asserts its
own precondition (exactly one script matched, of a plausible length) before reporting a count of
zero. Re-seeding S173e reddened it alone. Its limit is stated where it lives: it cannot see a fifth
control written with a different receiver name.

**The rule that would prevent a repeat: where a repair's property is only observable on the far side
of a flag that no runtime path flips, the behavioural assertion cannot be the proof — and the tell is
available before the seed is run.** Ask, of every new assertion, which arm of the flag it exercises;
if the answer is "the one that ships", the assertion is testing today's behaviour and not the change.
The remedies are the two this file already knows: an injection parameter where the branch takes one
(`[R107.4]` does exactly this and bites), or a source-level detector where it does not.

**And this is the second time in one session that a seed returning green was the finding rather than
the clean bill** — the first being the same repair's own reachability problem, where `testDot` and
`scoutEvictable` were handed a row and then re-found it by id. The seeding precondition earned its
place twice in one pass.

Substantiated from: this session's own transcript (seed S173e green, the repaired form, seed S173e2
red alone); `staging/PASS.md`'s seed table; `[R107.4]` and `[R107.5]` in
`staging/probe-snippet.html`; the standing rule in CLAUDE.md's *A test that cannot fail is a
liability* and *The seeding precondition*.

### M172 · A scripted edit addressed by line number landed on the wrong three lines, because the line number came from a grep that matched a continuation line
2026-08-19 · found by: inspection (immediately, by the agent that caused it, from the edit's own printed result) · pattern: `DESTRUCTIVE-UNDO`

Repairing the `hzH` stamp on `partialPosition`'s two writers, the sites were located with
`grep -n 'stage: "' index.html`, which returned `7189`. That line is the **second** line of a
three-line object literal — the literal opens on 7188 — so an `awk` replacement of lines 7189–7191
consumed `if (keep){ p.qty -= n; DB.positions.push(filled); }` on 7191 and dropped it entirely. The
result was a `const filled = {` declaration followed by a duplicated literal and an orphaned `else`,
which is a syntax error. Caught in the same command, from the printed after-state, and reverted by
re-copying the source.

**Root cause: a line number was treated as an anchor when it was a search RESULT.** The grep pattern
`stage: "` is a fragment of the literal, not its head, so the number it returned identified where
the fragment lives rather than where the construct begins. Every subsequent step — the range, the
replacement text, the assumption that the range was self-contained — inherited that error, and none
of them could detect it.

**Consequence: none realized, and the reason is the mechanism this session shipped.** The edit was
made to `staging/index.html`, which is a copy; `index.html` was untouched throughout and its
hash was unchanged at the end of the pass. Under the old practice — repairs made directly to the
tree — the recovery would have been a revert against an uncommitted working tree, which is exactly
M160.

**The rule that would prevent a repeat: a scripted edit to source is anchored on QUOTED TEXT, never
on a line number.** The repair used `perl -0777` with the full literal quoted as the match, which
fails visibly (`0 of 2 applied`) when the text is not what was expected, instead of succeeding
against the wrong range. Line numbers are for reading; text is for editing. This is the same
property as M160 rule 1 — the working tree is the deliverable, so an edit to it must fail loudly
rather than quietly — reached by a different mechanism, and it is the second instance of that
property.

**And the near-miss is evidence for the staging rule itself, on its first use.** The mechanism was
built this session to separate a repair from its review; it also, unplanned, absorbed a destructive
edit on the day it shipped.

Substantiated from: this session's own transcript (the `awk` range, its printed after-state, and
the `perl -0777` rewrite that replaced it); `staging/BASELINE.sha256` and `tools/stage/check.sh`
output showing `index.html` unchanged across the whole pass; M160 for the property this is a second
instance of.

### M171 · An assertion written for a fix was pointed at a different function, and passed because that function was already correct
2026-08-19 · found by: seeding (the seed came back green) · pattern: `TEST-SUITE`

`[R105.3]` was written to hold the repair of a bare unary plus on a record-level source tier, which
lives in **`importIntelligence`** — the `intelligence.json` path. Its first form called
**`validateImport`**, a different function whose own intel branch had been repaired in an earlier
sweep and was already correct.

Seed S171b reverted the real defect at the real site and **the suite stayed green.** The assertion
had run, on real production code, and proved a property that was true for a reason unrelated to the
fix it was named after.

**Root cause: two functions sanitize intel records, and the one the probe already had a fixture for
was not the one that changed.** The existing fixture was the path of least resistance, and it
returned a plausible-looking green.

**Consequence: none realized** — the seed caught it in the same sitting, and the corrected form is
pointed at the admission gate that spends the coercion (a catalyst needs a T0/T1 primary, so a null
tier reading as 0 admits a record the code says must be rejected). Re-seeded as S171b2 and red.

**The rule this sharpens, and it is not a new one:** *an assertion's subject is the branch that
reads the term.* The variant here is quieter than M157–M159, because the subject was a real branch
in real production code — just **not the branch the repair touched**. The tell: an assertion whose
fixture predates the fix it is named for.

Substantiated from: `tools/probe/probe-snippet.html` §105 (`[R105.3]` and the comment recording the
rewrite), `index.html` (`importIntelligence`'s tier resolution and its catalyst admission gate,
`validateImport`'s intel branch), and seeds S171b (green, the finding) and S171b2 (red, the proof).

### M170 · Three repairs in a row were scoped to the finding's spelling rather than to its property
2026-08-19 · found by: adversarial passes 5 and 6 · pattern: `SCOPE-NAMING`

**Three instances, all within four days, each one the repair for the instance before it.**

1. Pass 4 named the item store's cleared tier override. The sweep that followed searched
   `validateImport` for **`num(`** — the helper the finding mentioned — and missed five `>= 0`
   guards (`null >= 0` is true) and two bare unary-plus coercions.
2. Pass 5 named those two bare `+s.tier` sites. The repair ran
   `grep -nE '\[0, ?1, ?2, ?3\]\.includes\(\+s\.tier\)'` — **the finding's exact expression** — and
   missed a third instance **three lines below one of the two it fixed**.
3. Pass 5 named `partCapPct` and `clusterCapPct` as caps resolving to a loose default. The
   classification was drawn from **the 23 keys sharing the object literal those two sit in**, and
   missed `slots` and `watchCap`, which bound funding just as hard and are declared elsewhere.

**Root cause: a finding hands over a search string, and the search string gets mistaken for the
property.** The specific instance is vivid and the generalisation costs effort that the urgency of a
live defect actively discourages. This is the constitution's own first rule — *name the property, not
the surface* — failing at the moment it is most needed, and instance 2 broke it inside the fix for a
finding whose whole content was that the rule had been broken.

**Consequence: real and repeated.** Each incomplete repair became the next pass's money-path finding.
Pass 5 found three, pass 6 found eight.

**The rule that would prevent a repeat is a process change, not a code one**, because all three
repairs were correct at the sites they touched — the defect was in what was searched, and no
detector reads a search. Proposed as the cold-repair-review mechanism in
`audits/PROPOSAL-2026-08-19-cold-repair-review.md`: a repair pass ends with the repairs written and
unshipped, and the next session reviews them **without having read the finding that provoked them**,
asking one question — *name the property, then find every site with it.*

Substantiated from: `audits/ADVERSARIAL-2026-08-19e-pass5.md` (the first instance),
`audits/ADVERSARIAL-2026-08-19f-pass6.md` findings A1 and A3 (the second and third),
`audits/SWEEP-2026-08-19-num-null.md`, and the greps recorded in this session's transcript.

### M169 · The correct guard was written out twenty-one lines below, for a different field, and not applied to the one that needed it
2026-08-19 · found by: user-directed sweep · pattern: `COMPOSITION`

`num()` inside `validateImport` is `Number.isFinite(+v) ? +v : null`. `+null` is **0**, and 0 is
finite — so an explicit `null` in an imported file comes back as the **value zero**. Every field
whose null means *not measured* therefore restored as *a measurement of zero*, and the state backup
is `JSON.stringify(DB)`, so a field the app itself writes as null makes that round trip in **one
hop**: write null → export → restore → 0.

**This had happened once before with the same helper** — the item store's cleared tier override,
found by the fourth adversarial pass (`audits/ADVERSARIAL-2026-08-19d-pass4.md`). It was fixed **at
the field**, and the class was left open.

**THE OCCURRENCE COUNT IN THIS ENTRY WAS WRONG, AND THE CORRECTION IS THE ENTRY'S OWN SUBJECT
MATTER** (pass 5, `audits/ADVERSARIAL-2026-08-19e-pass5.md`). It read *"the third occurrence of the
same helper producing the same defect"* and cited three priors: the friction ledger's `exp`/`res`,
the qual store's `src`, and the item store's cleared tier override. **Only the last is the same
root.** The other two are the CARRY-COMPLETENESS defect — fields the sanitizer enumerated and then
dropped entirely, so they restored as *absent* rather than as *zero* — and `src` is a **string**,
which `num()` never touched. Filing them here made a coercion defect look like a three-time
recurrence when it had happened once before.

**This is exactly the error the drift rule was written about, committed in the entry that reports
it:** two things that look alike from a distance were counted as one, and the count is the thing the
evidence layer exists to keep honest. Recorded rather than quietly edited, because a count that was
wrong and is now right teaches less than one that says where it went wrong.

**The corrected standing:** the null-to-zero coercion has **two** recorded occurrences — the item
store's cleared override (pass 4) and this sweep. The carry-completeness defect has its own,
separate history and is where `exp`/`res` and `src` belong. Neither count reaches the three-instance
bar on its own.

**The failure worth naming is not the trap. It is that the correct guard was already written down.**
The item-store branch and the `gateLog.v` branch sit twenty-one lines apart in the same object
literal. `gateLog.v` carries this comment, in as many words:

> *"NOT `num()`, which is `Number.isFinite(+v) ? +v : null` and therefore maps null → 0, since
> `+null` is 0 and 0 is finite."*

That comment was written **in the same session** that gave the item store a null-bearing third
state, and the store landed with `num()`. The knowledge was present, correct, adjacent, and written
in prose rather than in a term — so it did not travel the twenty lines to the field that grew the
new state. **A rule that exists only as a comment protects the line it is attached to.**

**The sweep then found a LIVE money-path instance the three earlier fixes had walked past.** Every
watch row is created with `qty: null` — scout add, sibling add and manual add all write it
explicitly — and null there means *size me automatically*. `num(null)` is 0, so a state-backup
restore rewrote the entire watchlist as a **manual override of zero**: `opsPick` returns 0 because
0 is not null, `planQty`'s `wanted` becomes 0, and `chk(!(qty > 0), "sizing", …)` benched every
automatically-sized item — with a reason naming working capital or a missing buy limit, neither of
which had happened. The plan would fund nothing but hand-sized rows, and every bench reason would be
wrong about why. **This predates every cutover component**; it is old code that three field-level
fixes had no reason to look at.

Three more restored as zero on the same one hop, each a measurement that was never taken:
`peakToFlagD` and `retracePct` (written null by the anomaly scan when the peak or the mid is
unmeasurable, and `flagLagProfile` filters on `x != null`, so a restored zero enters the median lag
as a flag that fired **on** the peak day); `runwayD` (null when a catalyst's window date will not
parse, rendering as *"inside/past the window"*); and `rung` (null marks a **hand** exit, while rung
0 is the **first** ladder rung, so every manual sleeve exit came back labelled as a ladder exit).

**Consequence: the watch-row one is realized on any state-backup restore and is money-path** — it
suppresses funding rather than widening it, so it errs safe, but it silently empties the plan. The
other three corrupt attention-tuning measurements. Nothing on record says a restore was performed,
so no incorrect trade is attributable.

**The rule that would prevent a repeat is now a term rather than a comment.** `nz(v)` is
`v === null ? null : num(v)` and owns the property *null is a state, 0 is a value*; 106 call sites across 52 lines
moved onto it. Three `num(x) != null` survive on purpose and are named in the source. `[R103.6]`
reads `validateImport`'s own text and goes red if any of the three guard idioms — `num(x) != null`,
`num(x) >= 0`, `[0,…].includes(num(x))` — reappears, which is the check that makes the class closed
rather than the instances fixed. **Its stated limit is real: it cannot catch a bare `num(x)`
assignment**, because `num()` is correct at most of the 271 that remain, so
`[R103.1]` and `[R103.5]` carry that half field by field.

Substantiated from: `index.html` (`validateImport`'s `num`/`nz`, the `gateLog.v` comment, the three
`DB.watch.push` sites, `opsPick`, `planQty`, the sizing `chk`), `tools/probe/probe-snippet.html`
§103, `REQUIREMENTS.md` §103, `audits/SWEEP-2026-08-19-num-null.md` (the full field enumeration),
and seeds S169a–S169f, one at a time, restore-green between.


### M168 · I re-implemented a counter inside the assertion I wrote to protect it
2026-08-19 · found by: seeding (the seed came back green) · pattern: `PROXY-ASSERT`

`[R102.1]` was written to hold the repair described in M167 — the plan's "N charts still loading"
count, re-keyed from a copy substring onto the gate's identity. Its first form did this:

```
const sub102 = planSubLine(plLoad, plLoad.bench.filter(b => b.fails && b.fails[0]
  && b.fails[0].g === "chart still loading").length);
```

**The probe computed the count and handed it to the copy builder.** Production's own counter was
never called, so reverting it changed nothing the assertion could see, and the seed came back
**green**.

**Root cause: the subject was one line away and the fixture was easier to build than the render.**
`renderPlan` computes `loading` itself and puts the result in `#planSub`; reading that element reads
production's number. Calling `planSubLine` directly with my own argument tested the copy builder,
which was never in doubt.

**Consequence: none realized** — caught by the seed, in the same sitting. It is recorded because of
what it was an assertion *about*: a counter that had silently stopped counting. Writing an assertion
to protect a counter, and re-deriving the count inside it, is the defect and its own subject matter
arriving together.

**The rule that would prevent a repeat is the one already on the books, with a sharper tell: if the
probe passes a value INTO the thing under test, the thing that computes that value is untested.**
The existing form of this rule warns about a probe line that *computes rather than calls*. The
variant here is quieter — the probe did call production, and passed it a production-shaped
argument, and the argument was the whole subject.

Substantiated from: `tools/probe/probe-snippet.html` §102 (`[R102.1]` and the comment recording the
rewrite), `index.html` (`renderPlan`'s `loading`, `planSubLine`), and seed S123, green against the
first form and red against the second.

### M167 · A counter keyed on rendered copy stopped counting when the copy improved
2026-08-19 · found by: adversarial pass (`audits/ADVERSARIAL-2026-08-19d-pass4.md`) · pattern: `COMPOSITION`

The plan's summary line renders *"N charts still loading — verdicts will improve"*. `N` came from:

```
const loading = bench.filter(b => /still loading/.test(b.failed)).length;
```

`b.failed` is the bench SENTENCE. When the per-consumer readiness repair rewrote that sentence to
name the point counts and the thresholds, **the substring `still loading` left the file entirely** —
so the filter matched nothing, `N` was permanently zero, and the note never rendered again.

**It bit on every cold boot, which is exactly when it was the whole message.** Before price history
arrives, every otherwise-clean watch item benches as unreadable, and the summary read *"0 pass the
gates, of 43 scored"* with the sentence explaining why deleted. Degraded rather than silent — the
bench rows still carried their own reasons — but the one line that turns a wall of benches into
"wait a minute" was gone.

**Root cause: a consumer keyed on the producer's COPY rather than on its IDENTITY.** The gate's name
(`fails[0].g`) is stable and is what `failed` was derived from in the first place; the sentence is
prose and is expected to improve. One of the two consumers of that sentence WAS swept in the same
change — `gateName()`'s pattern still matches — so this is not an oversight about the existence of
consumers, but about which of them were checked.

**Consequence: realized, on a daily surface, for as long as the readiness repair has been in.**

**The rule that would prevent a repeat: never key a counter, a filter or a branch on rendered copy
when the thing being matched has a stable identity beside it.** And when copy is rewritten, the sweep
covers every consumer that reads it — the removal-is-the-moment-to-sweep rule applied to a sentence
rather than to a feature.

Substantiated from: `index.html` (`renderPlan`'s `loading`, `candidateFor`'s two history `chk` calls,
`gateName`), `audits/ADVERSARIAL-2026-08-19d-pass4.md`, and seed S123.

### M166 · The suite was green partly on state left by its own previous runs
2026-08-19 · found by: use (running the suite against a fresh browser profile, while debugging something else) · pattern: `TEST-SUITE`

The probe launches headless Edge against a throwaway `--user-data-dir`. That directory is created
once and **reused by every subsequent run**, so localStorage and IndexedDB persist across runs. On a
machine where the suite has run before, every run starts warm.

`[R82.4]` asserts that the scorer's verdict paragraph marks the phrase *"the cutover's plumb line"*
from the glossary entry of the same name. That mark renders inside
`idb(s => s.rdiffN ? … glTerm("plumb-line", …) …)` — **only when the archive read reports
reconciliation rows.** The probe seeded none. It was reading rows that an *earlier run* had written
into IndexedDB.

**Deleting the profile and running reproduced it exactly: cold run FAILS, every run after PASSES.**
Confirmed twice.

**Consequence: the suite reported PROBE-PASS on the strength of its own history**, and had done so
for as long as this assertion has existed. Nothing was wrong with the product; what was wrong is that
a green result did not mean what it says. A fresh machine, a cleaned profile, or a CI runner would
have gone red on a correct tree — and the natural reading of that red is "the tree is broken", which
is the expensive direction to be wrong in.

**Root cause: an assertion whose subject needs accumulated state, in a harness that quietly supplies
it.** The block seeded the fixtures it knew about and inherited the one it did not, and inheritance
is invisible: there is no line of code to read that says "this comes from last time".

**Consequence of the near miss, worth stating:** it was found by accident, while debugging an
unrelated harness, and only because a *second* incident had polluted the same profile with real
market data and made two other assertions fail. Two artefacts of the same store, one masking the
other.

**The rule that would prevent a repeat: a suite that reuses a browser profile is warm, and warmth is
a fixture nobody wrote.** Every assertion builds the state it reads, including state that lives in
the browser rather than in a variable — localStorage, IndexedDB, caches. And the check is cheap and
should be routine: **delete the profile and run once.** A green cold run and a green warm run are
different claims, and only the first one is the claim the report makes.

Substantiated from: `tools/probe/probe-snippet.html` §82 (the seeded `S.scorerSurf` and its comment),
`index.html` (`scorerVerdictInline`'s `rdiffN` branch), and the reproduction: cold PROBE-FAIL 1 on
`[R82.4]`, warm PROBE-PASS, twice, then PROBE-PASS cold after the fix.

### M165 · A detector was written to close a finding and passed with itself deleted
2026-08-19 · found by: adversarial pass (`audits/ADVERSARIAL-2026-08-19c-queue-pass.md`, consumer-repairs) · pattern: `TEST-SUITE`

Re-pass finding 30 was that `GATE_CHAIN_ORDER` had quietly changed job — from a display ordering
where an unlisted name merely sorted last, to the whitelist that the import validator and the grant
writer both use to DROP an exception — with nothing pinning the correspondence. The repair added a
self-check inside `chk`: a gate name the list does not carry is recorded on `S.gateNameOff`, and a
warning bar renders it.

`[R101.6]` was written to hold that. It drove the state **by hand**:

```
S.gateNameOff.clear(); candidateFor(row);
const offEmpty = S.gateNameOff.size === 0;
S.gateNameOff.add("a gate nobody listed");     // ← manufactured
gateNameOffWarn();
```

**Delete the production line and every conjunct still holds.** `offEmpty` goes *vacuously* true,
because nothing ever adds; the warning still fires off the hand-written entry; and the label's second
half — *"and an unlisted one is said out loud"* — is exercised only from a state the probe
constructs. The twelfth face, sitting inside the assertion written to close a finding, in the same
session that made *assert at the consumer* a BINDING rule.

**Root cause: the production path looked unreachable and was not.** `GATE_CHAIN_ORDER` is a `const`
binding to a **mutable array**, so splicing a live gate name out of it, running `candidateFor`, and
splicing it back drives the real writer. Reaching for `.add()` was the same reflex M157 records:
*the property was awkward to reach, so I reached around it* — except here the property was not
actually awkward, only unexamined.

**Consequence: none realized**, and the entry exists for the timing. This assertion was written
hours after the rule about this exact shape was promoted to BINDING, by the author of the rule.

**The rule that would prevent a repeat: before writing an assertion that sets state the production
code is supposed to set, establish that production cannot be made to set it.** A `const` binding to
a mutable structure, a defaulted parameter, an injectable flag — the reachable path is usually one
line away, and the test for whether you found it is whether deleting the production writer turns the
assertion red.

Substantiated from: `tools/probe/probe-snippet.html` §101 (`[R101.6]` and its comment),
`index.html` (`chk`'s self-check, `gateNameOffWarn`), and seed S119, which is green against the first
form and red against the second.

### M164 · Closing a money-path finding opened a money-path hole on the same two lines
2026-08-19 · found by: adversarial pass (`audits/ADVERSARIAL-2026-08-19c-queue-pass.md`, consumer-repairs) · pattern: `COMPOSITION`

The chain's two history gates are a PARTITION: `no history` covers *nothing published anywhere* and
`chart still loading` covers *not enough to read yet*, and between them they must cover every state
in which the chain cannot judge. That property was never written down; it was simply true, because
the second gate's suppression clause was the literal negation of the first gate's condition.

Closing re-pass finding 11/17 — the `no history` bench was firing on a false premise, telling the
operator no history is published for an item the archive had fully evaluated — added a conjunct to
the first gate:

```
chk(!!(sp && sp.noData) && ser.src === "none", "no history", …);
chk(!(sp && sp.noData)  && !rdy.allFed,        "chart still loading", …);
```

**The second gate's suppression was not updated, so the two stopped being a negation of each other.**
The region *empty `/timeseries` · archive HAS entries · series not ready* now benched on **neither**.
Every market gate treats a null reading as unknown rather than fail, so trend, volume trend, momentum
and drift all passed **unread, with nothing standing in front of them** — which is exactly the
"unmasking an inert restraint" failure the previous adversarial pass existed to prevent, reintroduced
by the repair that closed one of its findings.

**Consequence: none realized, and the margin was a clock.** `chartReady()` is false while the h1
archive accrues, so `ser.src` is `"none"` and the first gate still fires. It would have armed at 7
observed days — **the cutover's own prerequisite clock** — and nothing in the section would have gone
red when it did.

**Why the fixture could not see it.** `[R101.1]`'s archive series is 168 **finite** points, so
`rdy.allFed` is true and the suppressed gate had nothing to say. That is the same
fixture-prevents-expression shape caught on `[R101.3]` earlier in the same session, for the second
time in one sitting: the fixture was built to make the repaired case work, not to sit where the two
forms disagree.

**The rule that would prevent a repeat: when two conditions PARTITION a space, they share one term,
and the term is what the assertion names.** The suppression clause is now literally the same
`const noHist` the first gate fires on, so they cannot drift apart again — a partition maintained by
two independently-edited expressions is a partition waiting to be broken by the next edit to either.
The assertion sits at 20 archive points, the length where the four consumers genuinely disagree
(trend and momentum fed, drift and volume trend starved), because that asymmetry is the hole rather
than a detail of it.

Substantiated from: `index.html` (`candidateFor`'s two history `chk` calls, `seriesReadiness`,
`marketGateEval`'s unknown-is-not-failing handling), `tools/probe/probe-snippet.html` §101,
`audits/ADVERSARIAL-2026-08-19c-queue-pass.md`, and seed S116.

### M163 · A fixture kept an empty-but-present spark, so two definitions of "charted" agreed and the repair could not be proved
2026-08-19 · found by: seeding (the seed came back green) · pattern: `TEST-SUITE`

`chartedNow()` was routed through the resolver so that an archive-fed item counts as judged
(re-pass finding 10). `[R101.3]` was written to hold it, and its fixture gave the item a spark
whose `/timeseries` had come back empty — `{ pts: [], noData: true }` — alongside a full archive
series, because that is the state the *neighbouring* assertion in the same block needed.

**Reverting `chartedNow` to spark presence left the suite GREEN.** A spark OBJECT existed, so
`S.spark.get(id)` was truthy and the old definition agreed with the new one on this fixture. The
two definitions disagree only where there is **no spark at all**, and the fixture never reached
that state.

**Root cause: one fixture serving two properties, and the second one narrowing it.** The block's
earlier assertions genuinely need the empty-spark-plus-archive state; this one needs pure archive.
Sharing the fixture is right — five fixtures are five chances to differ from production — but a
shared fixture has to be *moved* into each property's state rather than assumed to cover all of
them. Two lines (`S.spark.delete`, then restore) were the whole fix.

**Consequence: none realized**, and the entry exists because of how it was found. The seed is the
only thing that could have found it: the assertion ran, on real production code, over a real
repair, and passed for a reason unrelated to the property in its name. A green suite after a
behaviour change is not evidence, and this is the third of the three answers that green cannot
distinguish — *the change did not take effect where the assertion looks*.

**The rule that would prevent a repeat: a shared fixture is moved into each property's state
before that property is asserted, and the seed is what proves it got there.** Where an assertion's
subject is a DISAGREEMENT between two definitions, the fixture must sit where they disagree —
anywhere else it is testing that they agree, which is a different claim.

Substantiated from: `tools/probe/probe-snippet.html` §101 (the `sp101` save/delete/restore and its
comment), `index.html` (`chartedNow`), and seed S99, which passed before the fixture was rebuilt
and failed after.

### M162 · I wrote the same short-circuit defect I was in the middle of fixing
2026-08-19 · found by: inspection during seeding (the evidence string could not be read from a pass) · pattern: `TEST-SUITE`

Re-pass finding 8 is a `[R94.1]` condition of the form `A || (B && C)` where `A` matched the
shipped copy, so JavaScript never evaluated `C` — and `C` was the only test of the claim the
assertion's own label leads with. In the same session, fixing it, I wrote `[R101.5]` as
`(evReal === null || evReal.gate === "ROI floor") && evBlk === null && evJunk === null` — a
disjunction whose first limb passes when the positive case does not happen at all.

It did not happen. The fixture's paper trips carried no `obsMs`, so `shadowObsShare` was 0, every
trip was `thin`, `shadowCounts` rejected all of them, and `exceptionEvidence` returned null. **The
assertion proved the two refusals and nothing else, while its label said a real gate is KEPT.**

**Root cause: a defensive disjunct written to absorb a fixture I had not verified.** The honest
move on an unverified fixture is to assert the strict form and let it go red; the `|| null` was a
way of not finding out. Tightening it to `evReal && evReal.gate === "ROI floor"` turned it red
immediately, which is how the fixture gap was found — nine trips, none of them counted.

**Consequence: none realized** — caught within minutes, in the same session, by reading my own
condition against the rule I had just written up. It is recorded because the timing is the lesson:
knowing a defect class in detail, and having just fixed an instance of it, did not stop me
reproducing it thirty minutes later.

**The rule that would prevent a repeat: a disjunct in an assertion condition is a claim that BOTH
branches are acceptable outcomes.** Where one branch means *the case did not occur*, it is not an
outcome, it is a hole — assert the strict form, and if it goes red, the fixture is what is wrong.
A pass cannot be read for which limb satisfied it, so the disjunct is unfalsifiable after the fact.

Substantiated from: `tools/probe/probe-snippet.html` §101 (`[R101.5]` and the `trip101` comment
recording the rebuild), `index.html` (`shadowSlice`, `shadowObsShare`, `exceptionEvidence`), and
the run that went red on the tightened form before the fixture was fixed.

### M161 · An assertion compared six hours ago to now and called them the same calendar day
2026-08-19 · found by: use (the suite went red at 05:00 with nothing wrong) · pattern: `TEST-SUITE`

`[R40.4]` asserts that seasoning must span a CALENDAR DAY: four touches inside one day cannot buy
qualification. Its fixture was
`!qualSpanned({ firstAt: Date.now() - 6 * 3600e3, lastAt: Date.now() })` — six hours before now,
against now.

**Between midnight and 06:00 local, six hours before now is YESTERDAY.** The assertion failed at
05:00 on a tree with nothing wrong with it, and it had been shipping that way since it was
written: a test that fails by the clock rather than by the code, which is the fifth face. It fails
for roughly a quarter of every day, and the only reason it had not been seen is that the suite is
usually run in working hours.

**Root cause: an ambient input read twice and assumed to be stable.** `Date.now()` is not a
fixture; it is the machine's clock, and a rule about calendar boundaries is precisely the rule
whose truth depends on where in the day the clock is.

**Consequence: realized but contained** — one red run, correctly diagnosed as the assertion rather
than the code, and it cost the time to establish that. The real cost of this class is the one the
project already names: an intermittent failure teaches the operator to ignore failures.

**The rule that would prevent a repeat is the standing one, applied: INJECT the varying input,
never pin the ambient clock.** Both pairs now hang off today's local noon, so the same-day pair is
06:00→12:00 and the rollover pair is yesterday-noon→noon at every hour of the day, and across a
DST shift — which moves noon by an hour and never across a date boundary. Pinning the clock
instead would have traded a flaky assertion for a silently-wrong one everywhere else `Date.now()`
carries staleness meaning.

Substantiated from: `tools/probe/probe-snippet.html` §40 (the anchored form and its comment),
`index.html` (`qualSpanned`), the 05:00 red run, and seed S96, which reddens the anchored form.

### M160 · An agent-side `git checkout --` destroyed three uncommitted entries in the file that records mistakes
2026-08-19 · found by: use (immediately, by the agent that caused it) · pattern: `DESTRUCTIVE-UNDO`

A perl one-liner used to insert M159 mixed a UTF-8-decoded insert with a byte-read host file and
double-encoded every multi-byte character in `MISTAKES.md`. The reflex repair was
`git checkout -- MISTAKES.md`. **The tree is deliberately uncommitted by standing ruling —
committing and pushing are the user's — so `HEAD` is not a backup of anything, and the checkout
discarded M156, M157 and M158 along with the damage.** Nothing else in the file had changed, so
the loss was exactly the three newest entries: 6,955 bytes, all of it this week's evidence layer.

**Recovery, and what made it possible.** M157 and M158 had been read in full earlier in the same
session, so they were restored verbatim from the session's own transcript. M156 had been read only
as far as its first sentence, and was **reconstructed from its cited sources** — the sweep section
it was found by, the requirement row that cites it, the shipped glossary entry it produced — and is
marked RECONSTRUCTED in place, per the file's standing convention that an inferred entry says so
rather than being reported as found. **The original wording of M156 is not recoverable.**

**Root cause: an undo reflex aimed at the wrong layer.** The damage was a formatting defect in one
insertion; the remedy applied was a whole-file revert to a baseline that predated three days of
work. Two things made it possible and both are the same shape as the assertion defects this file is
full of: the repair was aimed at the artefact rather than at the edit, and the safety of the action
was assumed from the tool's usual semantics rather than checked against this repo's actual state.

**Consequence: realized, and permanent for one entry.** M156's text is reconstructed rather than
restored. Everything downstream of it — the reworded `gov-propose` entry, R92.6, the sweep — is
intact and is what the reconstruction rests on.

**The rules that would prevent a repeat, and they are two.**
1. **In a repo whose working tree is the deliverable, `git checkout --` / `git restore` / `git
   stash` are destructive commands, not undo.** Copy the file aside first; there is no other copy.
2. **A text edit to a UTF-8 file is made in one encoding domain or the other, never both.** Reading
   an insert through `:encoding(UTF-8)` while reading the host file as bytes upgrades the host's
   bytes to codepoints on concatenation and re-encodes them on output. The check is one grep for
   `Â` immediately after any scripted edit, before anything else is done to the file.

Substantiated from: this session's own transcript (the destroying command and the restored text),
`git status` before and after, and the byte counts 145,588 → 138,633 → restored.

### M159 · The mask's repair was asserted on the term it reads, and reverting the mask stayed green
2026-08-19 · found by: seeding (the re-pass's own fix, caught before it shipped) · pattern: `PROXY-ASSERT`

The re-pass's readiness finding was repaired the right way in production: `seriesReadiness(ser)`
was extracted, the four per-consumer minima named in one place, and the *"chart still loading"*
mask re-keyed from `tr == null` to `!rdy.allFed`. The assertion written to prove it, `[R99.3]`,
called `seriesReadiness` directly with three hand-built `{ pts, vols }` objects and asserted the
booleans it returns.

**Reverting the mask to `chk(!(sp && sp.noData) && tr == null, …)` left the suite GREEN.** The
extracted term was still perfectly correct — nothing in the suite said the branch read it. The
assertion was proving arithmetic that was never in doubt, while the property actually under
repair — *which branch keys the bench* — had no assertion at all.

**Root cause: the one M157 and M158 name.** Reaching the branch needed a full `candidateFor`
fixture carrying a deliberately thin series; reaching the term needed three object literals.
*The property was awkward to reach, so I reached around it* — for the third time in two
adversarial passes, which is what moves it from an incident to a habit.

**The trap is specific, and the project's own rule set walks into it.** The standing remedy for
the seventh face (an assertion that re-implements what it tests) is *extract the logic into a
named function and point the assertion at that*. Applied without a second half, that remedy
PRODUCES this defect: extraction fixes reachability, and reachability is not coverage. **An
extraction owes two assertions — the term for its arithmetic, the branch for its wiring** — and
only the second can survive a revert as a red.

**Consequence: none realized.** Caught in the same session's seeding pass, by seeding the
production revert rather than the term. Fixed by adding the chain-level half: a 20-point series
(trend and momentum fed, drift starved) benches *"chart still loading"* on the real chain while a
168-point one does not, with the bench copy's `drift needs 24` matched so a failure names the
reason rather than a count.

**The rule that would prevent a repeat is now BINDING** — *an assertion's subject is the branch
that reads the term, not the term itself* — with integration-audit **scan 15** as its detector.

Substantiated from: `index.html` (`seriesReadiness`, `candidateFor`'s mask `chk`),
`tools/probe/probe-snippet.html` §99 (both halves of `[R99.3]` and the comment recording the
revert), REQUIREMENTS.md §99, `audits/ADVERSARIAL-2026-08-19b-fixes-pass.md` finding 2.

### M158 · A scope correction was implemented on the surface that did not have the problem
2026-08-19 · found by: adversarial pass (`audits/ADVERSARIAL-2026-08-19-cutover-pass.md`, ring-b-chart-overlays) · pattern: `PROXY-ASSERT`
*Retagged from `CLAIMS-VS-CODE` on 2026-08-19 by user ruling — see M159. The false
REQUIREMENTS row is what shipped; the assertion aimed at the plumbing is why nothing caught
it, and the tag records the root cause. Text restored verbatim after M160.*

The chart-wiring build of Aug 18 2026 was ruled with an explicit scope correction: feed
momentum and drift from the T0 hourly series **alongside** `tr`/`vt`, because the *"chart
still loading"* bench currently MASKS two vacuous restraints, and wiring only the two named
gates would remove the mask without feeding what it hides — turning two restraints
live-and-off rather than fixing them. The correction was found before the build started,
ratified, and reported as implemented.

**It was implemented on the wrong surface.** `chartPts`/`chartVols` gained exactly three
consumer lines, all inside `marketStatsFor` — the INSTRUMENT's stats builder. The **live
chain**, which is where the mask actually sits (`chk(!(sp && sp.noData) && tr == null,
"chart still loading", …)` lives in `candidateFor`), kept reading the per-item spark for
`tr`, `vt` and momentum, and **drift was never wired at all** — `stabilityWeight` →
`sitRisk` reads `sp.pts`, and `marketStatsFor` has no drift field to wire.

So the requirement row and the report both claimed "ONE SERIES FEEDS FOUR CONSUMERS — tr, vt,
MOMENTUM AND DRIFT" while production fed three fields on one surface and zero on the other.

**Root cause: the assertion named the plumbing, not the consumers.** `[R94.2]`'s condition
tests `chartReady`, `chartPts` and `chartVols` — it could not see the chain at all, so it was
structurally incapable of noticing that the surface the ruling was about had not changed.
That is the claims-vs-computation defect with the copy in a REQUIREMENTS row rather than on
screen, and it survived a same-session seeding pass because every seed I wrote also aimed at
the plumbing.

**Consequence: none realized.** Chart coverage stands at 3.9 of 7 observed days, so the
transition that would have unmasked the two restraints has not happened. Caught before the
clock ran out, which is the only reason this is an entry and not an incident.

**The rule that would prevent a repeat: when a ruling names CONSUMERS, the assertion names
the consumers.** An assertion over the source a consumer *should* read cannot see whether the
consumer reads it. The repair is the shape: `itemSeries` is now the one resolver and
`[R96.1]` asserts, on an archive-only fixture, that **every** chart-derived reading on the
chain is fed — with the discriminating half that on no source they all read unknown. Seeding
any single consumer out of the wiring now turns it red naming which. That is structural: a
new consumer inherits the resolved series rather than needing to be remembered.

Substantiated from: `index.html` (`itemSeries`, `candidateFor`, `marketStatsFor`,
`stabilityWeight`), REQUIREMENTS.md §94 and §96,
`audits/ADVERSARIAL-2026-08-19-cutover-pass.md`, and seeds S79 (did not bite against the old
assertions) / S79b–S82 (bite against `[R96.1]`).

### M157 · A requirement row claimed a branch was exercised that the suite could never reach
2026-08-19 · found by: adversarial pass (`audits/ADVERSARIAL-2026-08-19-cutover-pass.md`, new-session-assertions) · pattern: `PROXY-ASSERT`
*Retagged from `TEST-SUITE` on 2026-08-19 by user ruling — see M159; still a face of
`TEST-SUITE` and counted once inside it, reported separately, exactly as `CLAMP` is. Text
restored verbatim after M160.*

`[R89.1]` was written to say: *"Both paths assert: the watchlist path is bit-identical to
today's while the flag is off, and the pool path is exercised by driving the flag under a
fixture, so the branch that will carry the money is not first executed on the day it carries
it."*

**The pool path was never exercised.** `CUTOVER_POOL` is a `const`, `planCandidates` read it
directly, and `if (!CUTOVER_POOL) return watch;` returned on every run of the suite — so
`watch.concat(cutoverPoolRows().map(p => markSrc(candidateFor(p), QUAL_SRC_POOL)))` was dead
code. The concat composition, the pool provenance stamp, and `candidateFor` on a synthesised
one-key row were all unexercised. Every `QUAL_SRC_POOL`-stamped object anywhere in the suite
was hand-written into a fixture; production never produced one.

**The probe's own comment admitted it** — *"The ON path, exercised through the term the flag
guards rather than by mutating a const"* — and I wrote the requirement row claiming the
opposite in the same sitting. The comment is the more honest artefact of the two, which is
the tell: I knew the flag could not be driven, chose to assert the term instead, and then
wrote the row as though the branch had been covered.

**Root cause: an untestable design accepted instead of fixed.** The flag was a `const` read
inside the function, so the armed path was unreachable from a test. The fix was one
parameter — `planCandidates(armed)`, defaulting to the const, so production is unchanged and
a caller may drive the branch. **The choice to assert around the obstacle rather than remove
it is the mistake**, and it is the same instinct that produced two probe-side
re-implementations of flag-gated properties in the same session (`opsPick`, `opsTierOv`) and
three too-broad `document.body` matches: *the property was awkward to reach, so I reached
around it.*

**Consequence: none realized** — the flag is still false. But the branch that will carry the
money would have been first executed on the day it carried it, which is precisely what the
row promised would not happen.

**The rule that would prevent a repeat: if a branch cannot be reached from a test, that is a
design finding, not a reason to assert something adjacent.** Make it reachable — inject the
flag, extract the term, pass the dependency — and then assert the branch. And a requirement
row must describe what the assertion DOES, never what the design intended; where the two
differ the row is the thing that lies, because it is what the next reader trusts.

Substantiated from: `index.html` (`planCandidates`), `tools/probe/probe-snippet.html` (§89
block), REQUIREMENTS.md §89,
`audits/ADVERSARIAL-2026-08-19-cutover-pass.md`, and seed S87.

### M156 · The tool's own statement of its constitutional rule named the surface, not the property
2026-08-18 · found by: audit scan (the prospective cutover-readiness sweep, `audits/SWEEP-2026-08-18-cutover-readiness.md` §2h) · pattern: `CLAIMS-VS-CODE`

**RECONSTRUCTED 2026-08-19** from `audits/SWEEP-2026-08-18-cutover-readiness.md` §2h, HANDOFF.md's
report of that pass, REQUIREMENTS.md R92.6 and the shipped `gov-propose` entry in `index.html`,
after the original text was destroyed by an agent-side `git checkout --` against an uncommitted
tree (**M160**). Every fact below is cited; the original wording is not recoverable.

The `gov-propose` glossary entry — the tool's own rendering of the standing rule the whole
product is built to — read *"no flip is logged, no offer placed, no **watchlist commitment**
made without a press"*.

**The property survives the cutover exactly; the noun does not.** After the plan's candidate pool
switches from watchlist admission to the scorer's control cell, nothing is committed to a
watchlist at all — so the tool's statement of its own constitution would have described a
mechanism that no longer gates anything, while the rule it states is completely unchanged.

**Root cause: the surface-not-property defect, in the one place it is most expensive.** The
prophylactic at the top of CLAUDE.md — *name the property first; the surface is only the example
that produced it* — governs how rulings are written, and the tool's own copy had committed exactly
the error the prophylactic exists to prevent. A rule stated in terms of its current mechanism
silently narrows to that mechanism and expires with it.

**Consequence: none realized** — found prospectively by the cutover-readiness sweep, before the
pool switch. Finding it there rather than after is the whole point of running a sweep against a
change that has not happened yet.

**The rule that would prevent a repeat: user-visible copy that states a RULE states the property,
and demotes today's mechanism to a dated example.** The reworded entry leads with *NO CAPITAL IS
COMMITTED WITHOUT AN EXPLICIT PRESS* and lists no-flip-logged / no-offer-placed / no-pin-added as
"three examples of the property, not the property itself", with the `from` field recording the
rewording and why. Four sibling entries found by the same scan (`paper-cohort`, the
scanner-vs-watchlist net comparison, the promote-from-here line, and the cohort never-blend entry)
name a population that is about to be renamed; they are on the retirement sweep rather than
reworded now, because they describe machinery the cutover retires rather than a rule it preserves.

Substantiated from: `audits/SWEEP-2026-08-18-cutover-readiness.md` §2h, `index.html` (`GLOSSARY`'s
`gov-propose` entry, reworded), REQUIREMENTS.md R92.6, HANDOFF.md.

### M155 · The caveat the rule required inline shipped inside a disclosure, and its assertion matched the whole panel
2026-08-14 · found by: seeding (the stage-1d repair of census probe:6511 went red on real production output) · pattern: `TEST-SUITE`

R47.5's own row says the self-comparison caveat renders **"named where the bound is read
… not in a footnote"** — and from the day it shipped, the entire caveat lived inside a
`teach()` disclosure, which is exactly the footnote form the rule forbids. The assertion
policing it matched its four phrases against the WHOLE panel string, and a `teach()`
body is part of that string, so the assertion was green over a live rule violation for
two days — the ninth face (ran, on real output, passed for a reason other than the
property it names), on a rule about POSITION that was tested with no position check.
The census (probe:6511) had predicted precisely this could-pass; the stage-1d repair —
stripping every `details.teach` subtree before matching — went red on the real panel the
first time it ran, which converted the census's prediction into a live catch. Fix: the
load-bearing sentence now renders inline beside the bounds table (with the at-price
count computed in place), and the long explanation stays in the disclosure. The rule
that would prevent a repeat is already law (the ninth face: match against the narrowest
container that still contains the property); this entry is its instance count moving,
and the second instance of a POSITION claim needing a position-aware container (after
R66.2's verdict-vs-wallpaper, fixed the same day by extraction).
Substantiated from: `audits/CENSUS-2026-08-13-jobA-verification.md` (probe:6511), the
stage-1d report's first suite run (PROBE-FAIL 1 on the scoped form), `index.html`'s
`calibSection` before/after.

# 2026-08-13

### M154 · The scorer raced the fetch it depended on, and a short visit would have scored nothing
2026-08-14 · found by: the deployment check's first run · pattern: `COMPOSITION`

`doRefresh` runs `loadLatest()` and `loadHour()` concurrently in one `Promise.all`. The
scorer's call rode the tail of `loadHour`, guarded on `S.latestAt` — an input the OTHER
branch of the race supplies. At boot the guard could fire before `/latest` resolved, the
cycle returned null, and the next chance was a full `HOUR_MS` (~5 minutes) away. **The
archive accrued normally the whole time** (its guard reads only its own branch's data),
so the instrument's two consumers of the same arrival silently diverged: T0 recorded the
bucket, the scorer starved. A walk-up shorter than ~5 minutes — the DESIGN LENGTH of a
walk-up — would have scored nothing, every session, while every freshness number that
existed looked healthy.

**Every part was individually verified and green.** `[R76.8]` proved loadHour calls the
scorer; `[R76.3]` proved the bucket guard; `[R77.1]` proved the diff writes. All three
ran against a stubbed fetch layer where the race cannot exist, because a stub resolves
instantly and in order. **The defect lived in the concurrency of the real boot, which is
exactly the layer the user's deployment-check ruling ordered a look at** — *"R77's seeds
prove the code; one real bucket proves the schedule calls it."* The check's first run
returned `scoredBucket: 0` against an accrued archive at 111 seconds, which is the whole
finding in one line.

The fix and its proof: a catch-up `scorerCycleSafe()` in `doRefresh` after the
`Promise.all`, where both inputs are settled by construction — safe because **a
guarded-out cycle does not consume its bucket** (input guards precede the bucket-consume),
so the two call sites cannot double-count; that ordering property is now pinned by
`[R76.11]`, seeded by hoisting the consume above the guard. The re-run: **DEPLOY-OK,
first bucket archived, scored and diffed within 2 seconds of boot.**

The rule: **a component guarded on another concurrent branch's output is not wired until
something exercises the race** — stubbed-fetch assertions structurally cannot, because a
stub collapses the concurrency the defect lives in. A deployment-layer check against the
real schedule is that detector, and it caught this on its first run, before the first
real user session shipped a silent gap.

Substantiated from: `index.html` `doRefresh` (the catch-up and its comment),
`scorerCycle` guard order, `[R76.11]`; the deployment check's two runs (INCOMPLETE with
`scoredBucket: 0`, then DEPLOY-OK at 2s), recorded in the conformance map §4.

---

### M153 · A store shipped while the constitution's scope statement still excluded it
2026-08-14 · found by: user (session-close review after a crash) · pattern: `CLAIMS-VS-CODE`

The reconciliation-diff ledger (`rdiff`, flag 3) was added to the `geflips-t0` IndexedDB
as its third object store, with retention, failure surfacing, a freshness stream and five
probe assertions — while CLAUDE.md's one named localStorage exception still read *"scoped
to the archive and its trip ledger; nothing else may move."* For the gap's lifetime the
constitution and the code contradicted each other, and the constitution was the stale
side: a reader enforcing the scope statement against the tree would have filed a correct
finding against ratified work.

**The crash explains the gap; the ORDER is the lesson.** The store landed in a coding
pass and the scope widening was queued into a bookkeeping pass behind it — then a crash
consumed the bookkeeping pass, and the mismatch survived to the next session. Any
interruption between "code" and "bookkeeping" produces this defect, which means the
sequencing was wrong, not the luck: **a constitutional scope statement rides the same
commit as the store it governs**, exactly as a detector rides the same commit as the
surface it watches. A constitution contradicting the code it governs is the same defect
class as a surface without its detector — the authority that would catch the next
violation is the thing that is stale.

**The rule, ruled into the conformance gate:** the gate's *"detectors shipped in the same
commit as the surfaces they watch"* clause is to be read as covering constitutional scope
statements too. The clause now says so in place.

Substantiated from: CLAUDE.md's exception paragraph (amended in the same tree as this
entry); `index.html` `T0_DB_V = 2` / `rdiff` store; the resumed session's integrity
report, which named the mismatch before any new work started.

---

### M152 · The fixture range that was safe from writes sat inside the deletes, and two working parts vanished it
2026-08-14 · found by: seeding (the wiring assertion's own first run) · pattern: `TEST-SUITE`

The T0 archive's probe fixtures needed keys no production bucket could collide with, so
they used epoch timestamps below 1e12 — the year 2001, unreachable by production
*writes*, whose keys come from data timestamps and wall clocks. The wiring assertion
(`[R75.5]`) then stubbed the fetch layer, called the real `loadHour`, and read for its
bucket: **absent.** Diagnostics showed the accrual succeeding (`accrue-ok`, `t0Fails: 0`)
and the store empty anyway — because `t0Accrue` ends with its own retention prune, and a
2001 key is not merely old enough to avoid collisions, it is **maximally old**: the prune
deleted the fixture bucket inside the same accrual call that wrote it.

**No part was broken.** The accrual worked, the prune worked, and their composition
vanished the fixture — a green write and an empty read, with the failure-counter at zero
because nothing failed. On the report it looked exactly like the wiring not firing, which
is what the assertion existed to catch, so the first diagnosis chased the wrong seam.

The rule: **a probe fixture's key range must clear BOTH the write path and the delete
path, and "unreachable by production" must be checked against every path that touches the
store, not just the one that creates.** For a store with retention, only the FUTURE range
clears deletion by construction — production keys never run ahead of now, and retention
only reaches behind it. The corollary is a new obligation the fix carries: retention
cannot clean a future-range fixture up, so its cleanup is an explicit keyed delete whose
result is itself asserted (`[R75.5b]`), or the fixture accumulates across runs in the
persistent probe profile.

This is the composition class (M-catalog `COMPOSITION`) expressed inside a test fixture:
each part correct, the defect in the seam — filed under `TEST-SUITE` because the damage
was a test that could not go green for the right reason, and the tell was a success
counter reading zero while the data was gone.

Substantiated from: `tools/probe/probe-snippet.html` `[R75.5]`/`[R75.5b]` and their
comments; REQUIREMENTS.md R75.5; the diagnostic run's output is quoted in the assertion's
history (this session).

---

### M151 · The never-fed detector was itself never-fed, and its denominator counted chances that did not exist
2026-08-13 · found by: user (interaction-surface measurement) · pattern: `SILENT-STATE`

`REGIME_BANDS[0]` decided which paper trips *could* have landed in the `loose \ current`
band — the band the whole ROI-floor question is about — with
`eligible: p => p.cohort === "scanner"`, and told the reader the rest were
*"screened at the full ROI floor on entry, so it cannot sit below it"*.

**Both halves were false.** The watchlist path applies **no ROI pre-screen at all**: it
admits any single-gate near-miss from `P.all`, so the stated reason for its ineligibility
was not the operative one. And the scanner cohort was **not eligible either** — it screens
at `SHADOW_LOOSE` and then requires `pass || nearMiss`, while a trip in the band sits at
`eRoi ∈ [1.0%, 1.2%)` and therefore fails the ROI floor **and** the margin floor, two
failures, never a near-miss. The slice and gap band apply the same test. **No entry path
can admit a taxed band item, so the true number of chances was zero.**

**Consequence: `nEligible` reported the scanner's 14 stored trips as chances that were had
and missed.** A false denominator turns *impossible* into *didn't happen* — evidence of
absence dressed as absence of evidence, which is the exact inversion this surface exists to
prevent. The code comment eleven lines above the defect says an empty band over an
ineligible population *"must not render as 'no trip sits in this band'"*. The predicate it
relies on to know that was wrong, and the surface had been reporting *current ≡ loose* on
that basis since it shipped.

**Root cause: eligibility was asserted from a plausible story about entry paths rather than
computed from the gate arithmetic.** "Only the scanner screens that low" is true and
irrelevant; what decides membership is whether an item in the band can survive the gate
chain, and it cannot, because `GATE.taxMult = 3` makes the margin floor a 6.52% ROI floor.
This is the same root as M150 one layer up — a conclusion drawn from ordering and
plausibility instead of from the constants.

**Why it is worse than an ordinary wrong constant:** three assertions (`[R68.6]`,
`[R68.7]`, `[R68.8]`) were written against the wrong predicate and were green, and one of
them, `[R68.8]`, is titled *"empty by construction reads as NEVER-FED"* — a requirement row
codifying the false mechanism verbatim. **The detector, its requirement and its test all
agreed with each other and all three were wrong**, which is what a story-shaped rule buys.

The rule: **a reachability claim is COMPUTED from the constants that decide it, never
asserted from a description of the paths.** `bandUnreachable(hiPct)` now derives from
`GATE.roi` and `effRoiFloorPct()` at call time, so moving either constant moves the answer;
the tax-exempt carve-out is read from `exemptIds` as a property of the item, evaluated
centrally, never a label an entry path attaches. The old `!nEligible` render branch was
**deleted** rather than left green — under the corrected predicate its trigger is
unreachable from its own upstream limits, which is the dead-safeguard shape, and an
assertion propping up a dead branch is the twelfth face.

Substantiated from: `index.html` `REGIME_BANDS` / `bandEligible` / `regimeSeparators`;
`audits/SURFACE-2026-08-13-gate-interaction.md` §6;
`audits/POWER-2026-08-13-roi-floor.md` §4, whose stated mechanism this corrects;
REQUIREMENTS.md R68.8 (superseded in place) and R73.3–R73.4.

---

### M150 · Two constants set independently made one gate arithmetically inert, and four conclusions were drawn off it
2026-08-13 · found by: user (following the arithmetic of a claim that could not be supported)
pattern: `CLAIMS-VS-CODE`

`GATE.roi = 1.2` and `GATE.taxMult = 3` were set at different times for different reasons.
Their ratio makes the margin floor's tax limb a sustained-ROI floor in disguise at
`taxMult·τ/(1 − τ − taxMult·τ)` = `0.06/0.92` = **6.5217%**, five and a half times the
stated floor. **Every taxed item below 6.52% ROI is benched by the margin floor whatever
the ROI floor says** — including the entire 1.2%–6.52% range the ROI floor passes. Measured
over 4,497 live items: **2,358 fail the ROI floor and 2,358 of 2,358 also fail the margin
floor.** The ROI floor's sole-failure region is empty at every price.

Because the ROI floor sits one slot **ahead** of the margin floor in `GATE_CHAIN_ORDER`, it
takes the headline on every one of those items, and `DB.gateLog` records only `fails[0]`.
So the ledger reported the ROI floor as the busiest gate in the book while it was never the
binding one.

**Four conclusions had already been drawn off the artifact, and the user struck all four:**

1. *"Sole blocker in 14 of 19 sole-blocked candidate-days, 74%"* — **0% by construction.** A
   one-gate ledger day means the headline never changed that day, not that one gate was
   failing. On the same ledger, 127 of 162 ROI-floor candidate-days also carry a
   margin-floor row, which is the headline flipping *within* the day.
2. *"The volume floor is never the sole blocker, so loosening it would free nothing"* —
   **inverted.** It is the most common true sole blocker there is (280 market-wide, 66 of
   132 paper trips); it reads as never-sole because it sits second-to-last in the chain and
   can barely ever be a headline.
3. *"Current ≡ loose in the paper book, so the floor looks right"* — the band is unfeedable
   (M151); the equality is an identity.
4. The ⚑ **"two biggest killers this refresh"**, the surface the user reads most. A ranking
   of first-fail counts is a ranking of chain positions.

**Root cause: no rule anywhere stated the relationship, so no detector could read code
against it.** The integration audit's fifteen scans all check code or copy against a STATED
rule; this was arithmetic between two numbers nobody had ever put beside each other. It was
found by trying to verify a claim that could not be supported and following the algebra.

The rule, now BINDING: **an ordered rule chain that reports "the reason" is reporting
position in the ordering; per-rule attribution may not be read as causal without an
interaction surface.** Detector: scan 16, plus `effRoiFloorPct()` extracted and asserted at
the source. The methodological half — **arithmetic on the constants, not a pattern match on
the code** — is DOCTRINE, because it names a gap rather than a rule.

**Neither constant moved.** The ROI-floor loosening experiment was CLOSED rather than
benched: it admits 0 of the 41 live band items.

Substantiated from: `audits/SURFACE-2026-08-13-gate-interaction.md` (full measurement);
`audits/POWER-2026-08-13-roi-floor.md` §3 and §5, corrected in place; `index.html`
`effRoiFloorPct` / `marginNeedFor` / `GATE_CHAIN_ORDER`; REQUIREMENTS.md §73.

---

### M149 · A cached replay of a 51-agent run is not free, and it cost both syntheses
2026-08-13 · found by: use · pattern: `TEST-SUITE`

A 51-agent census finished with one agent dead — Job A's synthesis, lost to a mid-response
connection failure. The documented repair is to relaunch with `resumeFromRunId`, where
*"agents whose (prompt, opts) are unchanged replay from cache"*, so the obvious reading is
that resuming re-runs the one dead agent and replays the other fifty for nothing.

**It re-ran far more than the dead agent and hit the account's session limit.** Thirteen
agents died: both syntheses, plus eleven Job B finders and verifiers that had already
succeeded on the first run. The resume therefore ended with *strictly less* than it started
with — Job B's synthesis had been intact and was now gone — and no further agent work was
possible for the rest of the session.

No data was lost, only because each run writes its own output file and the first run's
results were still readable, plus the per-agent journal. Had the resume overwritten in
place, the intact Job B synthesis would have been destroyed by an operation performed to
*recover* a different one.

**Root cause: a cost model inferred from a tool description rather than measured.** "Replay
from cache" describes what happens to the agents that hit cache and says nothing about how
many will. On a large fan-out the ones that miss can exceed a session budget on their own.

The rule: **before resuming a large fan-out, treat the replay as a fresh run for budgeting,
and confirm the surviving artefacts are readable from the completed run first.** Where the
only missing piece is an aggregation over results you already hold — a synthesis, an
ordering, a dedupe — **do it by hand.** Job A's synthesis was assembled from the journal
with no agents at all, and anchoring by text rather than by line made it *more* accurate
than the agent version would have been.
Substantiated from: workflow run `wf_11e0195c-3ea` failure list; task notifications for
`w82q5njwx` and `wv2joxxiw`; `audits/CENSUS-2026-08-13-jobA-verification.md`.

### M148 · A rule about touch gaps is tested only where there are no touches
2026-08-13 · found by: audit scan · pattern: `TEST-SUITE`

The die-off auto-void rule reads, in production and in its own rendered copy,
*"recovered inside one touch gap"* (`index.html:3022`, `12112`). Every assertion covering
it — `[R43.5]`, four of them — runs inside a fixture that sets `DB.touchWindows = []`, the
explicitly-empty schedule. With no schedule, `scheduleOn()` is false, `gapHoursAt()` returns
the flat `DB.fillHorizonH` fallback for any timestamp, and the concept the rule is written
in terms of **does not exist**.

So the rule is exercised exclusively in the one configuration where its own subject is
absent. This is the twelfth face — an assertion reaching its subject by a call path
production does not have — landing on a BINDING behaviour rather than on a guard.

The same fixture line puts the whole first 622 lines of the suite on that fallback:
allocator sizing, quote-leg participation caps, quote-leg aging and die-off voiding are all
asserted against a constant 4h, never against `TOUCH_DEFAULT = [7,12,17,21.5]`, which is the
product's default. The horizon PRIMITIVES do have real-schedule coverage — §40, §57 and §61
each set a genuine schedule, and §61 even compares two — but the BEHAVIOURS that consume
them do not.

The rule: **a rule written in terms of a mechanism must be asserted with that mechanism
present.** Where a fixture disables a mechanism for determinism, the behaviours that depend
on it need a second block that turns it on, and the fixture comment should name which
behaviours it is thereby leaving uncovered rather than pointing vaguely at "the cadence
block".
Substantiated from: `tools/probe/probe-snippet.html:65`; `index.html:2858, 2895, 3022, 12112`;
Job A census slice 1; `audits/CENSUS-2026-08-13-jobA-verification.md`.

### M147 · `planCap` has zero direct coverage, and it defeated three separate assertions
2026-08-13 · found by: audit scan · pattern: `CLAMP`

**`planCap` appears four times in `index.html` and zero times in the entire 958-assertion
probe suite.** It is the allocator's sizing clamp — the term named FIRST in scan 9's own
enumeration of clamps to check — and nothing asserts it directly.

The consequence is not one missing test. It is that **three separate findings this session
all route through the same untested clamp**, and each was diagnosed and filed as a defect in
the assertion rather than in the clamp:

- **M118 / `shadowHorizonUnits`** — paper sizing reverting from the fixed horizon to the
  schedule changed no output at all, because `planCap`'s buy-limit clamp pinned both
  readings to the same number.
- **`probe:111`** — the assertion written to REPAIR M118 by asserting the horizon term "at
  the source" passes `qty = 1e9`, a value no production call site produces, precisely to
  neutralise the clamp. Production's real call passes `planCap`, which on that fixture is
  always below the horizon term, so the extracted term is reachable only by an argument
  production never uses. The extraction stopped one layer short: the `Math.min` is still
  inside the extracted function.
- **`probe:116`** — labelled "uncapped item funded full", asserting the per-item cap while
  the unclamped size is six times larger. The label is false *because* the clamp is what
  the number actually measures.

**The assertions are symptoms; the untested clamp is the cause.** Each was found separately,
by a different face, and filed as its own weak-assertion incident — which is how the
underlying gap stayed invisible: a clamp nobody asserts produces a stream of assertions that
each look individually repairable.

The rule: **a clamp that gates money must be asserted directly — its inputs, its binding
side, and which input pins the output for a given fixture — before any assertion downstream
of it is trusted.** Scan 9 enumerates clamps and checks the assertions beneath them; it does
not check that the clamp itself has one. That is the gap, and it is why the enumeration kept
returning repairable-looking symptoms.
Substantiated from: `grep -c planCap` over `index.html` (4) and
`tools/probe/probe-snippet.html` (0); CLAUDE.md scan 9; MISTAKES.md M118;
`audits/CENSUS-2026-08-13-jobA-verification.md`.

### M146 · The collector's silence was unfalsifiable, and it was reported as failure twice
2026-08-13 · found by: user, twice · pattern: `SILENT-STATE`

Reported as *"the collector did not fire"* on two separate occasions. **Both times it had
fired and found nothing** — Downloads held no JSON either time. But in `--quiet` mode a run
that moved nothing printed exactly what a run that never happened printed, so the claim was
**unfalsifiable from the outside** and the only way to answer "did it fire?" was to reason
about it.

**This is absence rendered as data-of-absence, in a tool I wrote one turn after promoting
that rule to BINDING** — and the user's own specification had said it in as many words:
*absence of a file and absence of a report are different things and I should not have to
tell them apart.* I honoured that in the verbose path and discarded it in the quiet one,
because quiet was designed around the transcript rather than around the question the
operator would actually ask.

Fixed without making the hook noisy again: every run stamps `inbox/.last-sweep` whether or
not it moved anything, `--status` reads it back without sweeping, and the verbose report
leads with when the run happened. The transcript stays quiet — which is what makes a
per-prompt hook viable — while the STATE became observable.

Substantiated from: two user reports; `~/Downloads` empty of JSON at both;
`tools/inbox/sweep.sh`, the stamp and `--status`.

### M145 · A figure from a stale export survived into reasoning — the second time in a day
2026-08-13 · found by: recomputing against the fresh export · pattern: `STALENESS`

I reported the calibration sample as **92 buckets, 79 crediting everything, 13 crediting
nothing, 21% of volume discarded**. Those figures came from the *previous* export; the
current one carries **319 usable buckets** and the 21% figure should not be relied on.

**Second occurrence in one day.** Earlier the same session I read a paper export that was
three hours stale while a fresher one sat in Downloads. Root cause both times: I treated a
file already in hand as current because it was the newest one *I* had, rather than checking
it against what the tool had since produced. The collector now consolidates from every root
and ranks by each file's own `generatedAt`, and the standing rule is to sweep **before**
reading any export — but the discipline is the operative part: **a figure carries the
timestamp of the file it came from, and quoting it later without that timestamp is how a
stale number outlives its file.**

Substantiated from: the 92-bucket figure as reported, against 319 in
`analysis-calibration-2026-08-13.json` (generatedAt 17:29:26Z); MISTAKES.md M141.

### M144 · An extraction ran past its block and the population doubled
2026-08-13 · found by: a stored cap contradicting the data · pattern: `COMPOSITION`

Computing the sell-credit proposal, my extraction range for the `liveBook` section ran past
it into the calibration section, so 99 calibration trace buckets were attributed to the last
live item. I reported **319 usable buckets and 70,267 volume** against the true **232 and
33,234** — the population inflated by roughly 2×.

**The tell was a cap, not the numbers:** Mithril boots showed **123 trace buckets against a
stored `SELL_TRACE_CAP` of 48**. A per-item count that exceeds its own storage cap is
impossible, and that impossibility is what located the bug — the aggregate itself looked
entirely plausible. **A constant that bounds a quantity is a free consistency check on any
figure derived from it, and it is worth applying before trusting an extraction.**

What saved the conclusion: the *net* was identical (−23%) under both the contaminated and
the correct population, which is what said the effect was structural rather than an
artifact of what I had counted. The user had computed it independently and their figure was
right — the disagreement is what triggered the check.

Substantiated from: the two computations side by side; `SELL_TRACE_CAP = 48` in
`index.html`; both reproduce −23% net.

### M143 · A stale assertion kept passing for an incidental reason after its rule was superseded
2026-08-13 · found by: noticing the suite stayed green through a ratification · pattern: `TEST-SUITE`

`[R66.4]` asserted *"the relative form is a REPORT — the live classifier is still the
absolute one"*. When the spread-relative band was ratified and made live, **the suite stayed
green** — because the assertion called `classifySellFailure` **without a spread**, so the
fallback band answered and the old expectation still held. The assertion was testing a rule
that no longer existed, and passing for a reason unrelated to the claim in its own name.

Root cause: the assertion's subject was reachable by an argument shape the product no longer
uses at that call site. **This is the twelfth face at one remove** — not manufacturing an
impossible state, but continuing to exercise a now-vestigial code path and reading its
answer as the product's. The tell is the same and worth carrying: **a ratification that
changes behaviour and breaks no test has either no coverage or stale coverage, and green is
not the evidence of which.** Fixed by driving the classifier with the spread the product
threads, asserting the ratified behaviour in both directions, and seeding the reversion.

Substantiated from: the suite reporting PROBE-PASS immediately after the band was made
live; REQUIREMENTS.md R66.4 as it read before and after; `tools/probe/probe-snippet.html`.

### M142 · An absence filed as an ambiguity, and a residue that was a threshold artifact
2026-08-13 · found by: reading the first live discriminator run · pattern: `SILENT-STATE`

Two of the ten "neither fits" sell failures had **no high print across 48 buckets** — the
strongest possible illiquidity finding — and were filed as `unclassified`, because
`classifySellFailure` gave the `no-liquidity` name to the *weaker* condition below it
(prints, but no volume). `ofWhichNoLiquidity` therefore reported **0** while two cases were
exactly that.

**The pile meaning "we could not tell" must never absorb the cases meaning "there was
nothing there."** That is the never-fed-aggregate root in a classifier rather than in a
statistic, and it is why the residue looked like a mechanism worth naming.

The wider finding is recorded as case law rather than here: the whole ten-case pile was a
**threshold artifact**, an absolute band measuring a phenomenon proportional to each item's
spread. No third class was invented, and the discriminator's refusal to name one is what
made the pile legible in the first place.

Substantiated from: `analysis-calibration-2026-08-13.json`, live cases with null
`medianBucketGapVsAskPct` against `ofWhichNoLiquidity: 0`; REQUIREMENTS.md R66.1; CLAUDE.md
case law, *the residue that was a threshold artifact*.

### M141 · Every export class but one had no collector, for a week
2026-08-13 · found by: user, after paying the cost every session · pattern: `COMPOSITION`

The browser cannot write to the repo, so every export the tool produces costs a hop:
find it in Downloads, move it, delete the browser's ` (1)` copies. **A collector was
built for exactly one class — `flags-pending` — because that was the class the briefing
procedure happened to need**, and the five other classes the tool exports were left to
be carried by hand. Root cause: the collector was specified as a step inside one
workflow rather than as a property of the export mechanism, so it covered the caller
that prompted it and nothing else. The Downloads folder had accumulated **19 stale
copies across six classes**, of which the sweep deleted 18 on its first run.

Substantiated from: BRIEFING.md run-procedure step 0 as it stood (flags only);
`tools/inbox/sweep.sh` first run, which reported 7 older duplicates for
`analysis-paper` alone; CLAUDE.md, *Downloads auto-collect*.

### M140 · The assertion manufactured the only state in which the guard could run
2026-08-13 · found by: the deletion failing an existing assertion · pattern: `TEST-SUITE`

Deleting `reconReplay`'s unreachable causality guard (M137) turned `[R43.2]` red — so the
dead line **was** asserted. The assertion called `reconReplay` **directly**, handing it a
window starting before the trip's own `t`, which is a call production cannot make: the
caller clamps the window first. So the probe was constructing the only input under which
the guard could execute, and reporting a dead line as covered.

**GRADUATED to the test-suite family as its TWELFTH FACE** (user ruling, Aug 13 2026),
with **scan 13** as its detector. It is the cousin of the reimplementation trap: there the
probe re-derives the *answer*, here it manufactures the *state* — and both produce a green
run on real production code that proves nothing about production. The tell is its own:
**an assertion that reaches its subject by a call path the product does not have.** It is
also why the dead guard survived a full day of scans: it was green, and green on a line
that cannot run reads exactly like green on a line that works.

**It changed how the dead-guard rule is applied, which is the load-bearing consequence:
before deleting an unreachable guard, check whether an assertion is holding it alive.** A
dead guard with a green assertion pointed at it is the normal case rather than the
surprising one, the deletion will turn that assertion red, and **the red is information —
it names the artificial call path** rather than reporting a regression. Move the assertion
to the layer production uses before the guard goes. Fixed here by extracting
`reconWindowStart()`, stating the promise there, and seeding it against the input the old
guard pretended to defend against.

Substantiated from: the `[R43.2]` failure on the deletion (probe report,
2026-08-13); `tools/probe/probe-snippet.html`, the re-pointed assertion and its comment;
`audits/AUDIT-2026-08-12-scope.md` §8, corrected in place.

### M139 · A difference was rendered as a level, and disagreed with its own drill-through
2026-08-13 · found by: user · pattern: `CLAIMS-VS-CODE`

The paper vitals tile read **+2.64m vs current**; the drill underneath it read **−2.4m**.
Both the sign and the magnitude differed, and **both numbers were arithmetically correct**:
the headline was `tight − current` (a DIFFERENCE) presented as though it were a level, and
the drill was `current` itself. Nothing was wrong with either figure; the sentence was
wrong about which figure it was.

Root cause: the line was hand-rolled as `label + gp(|d|) + " vs current"`, and "vs current"
is not enough — it names the base without printing it, so the reader cannot reconcile the
two numbers they are looking at. Fixed at the renderer, not the call site: `deltaVs()` is
the sanctioned form and **cannot emit the difference without both operands**, the
`rateBlend()` shape applied to differences.

**The general rule, which is the durable part: a figure that is a difference states what it
is a difference from, in the sentence, not in a tooltip** — the number is read in the line
and not in the hover.

**A widening was proposed and is HELD** (user ruling, Aug 13 2026): *a decomposable
aggregate must reconcile to its decomposition, and the check is mechanical.* The existing
interrogability rule guarantees a number can be **opened**; it has never required that what
opens **agrees** with what was opened.

**Held because this incident is not an instance of it, and that is the right reason to
hold a rule.** The two figures were different quantities, each correctly computed, one
mislabelled — a reconciliation check comparing `tight − current` against rows summing to
`current` would have **fired on a correct pair** and reported a defect that was not there.
A rule adopted on the back of an incident it would have mis-handled is a rule with no
evidence under it, which is the defect the promotion bar exists to catch. **It graduates
when something actually fails to reconcile.** This entry stays as the evidence that the
question was asked and answered, not as the instance.

Substantiated from: user report, 2026-08-13; REQUIREMENTS.md R65.1; `deltaVs()` and
`paperDivLead()` in `index.html`.

### M138 · An audit's conclusion inherited a guard's authority without checking it could fire
2026-08-13 · found by: graduation audit's scan 11 · pattern: `TEST-SUITE`

`AUDIT-2026-08-12-scope.md` §8 traced every path that can close a paper trip and ranked
`reconReplay` the least likely cause of the sub-second trips, reasoning in part that it
"has causality (`bt < p.t` skips)". **That guard could never execute.** The audit read the
line, credited it, and passed its authority into a conclusion — and the conclusion then
sat in the record for a day as settled.

The reasoning was not careless: reading a guard and believing it is the normal way to audit
code. What was missing is the question the dead-safeguard rule already asks of *guards* and
nobody was asking of *arguments* — **can this line run?** An audit that cites a guard is
making a claim about behaviour, and a claim about behaviour has to clear the same
reachability bar as the code it rests on.

Consequence and the fix: the ranking may still be right, because the other reason given
(buckets are five minutes apart) is real and independent — but the causality half is worth
nothing and is **withdrawn in place**, in the audit where it was recorded, rather than
noted only in the newer report. A correction that lands somewhere the reader will not look
is not a correction.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §8, correction block;
`audits/AUDIT-2026-08-13b-scans-10-11.md` S11-F1.

### M137 · `reconReplay`'s causality guard cannot fire
2026-08-13 · found by: audit scan (11, information horizon — first run) · pattern: `TEST-SUITE`

`if (bt < p.t) continue;` — the only line in the reconstruction path that states the
causality rule, carrying the comment that asserts it. Its caller clamps first:
`replayFrom = Math.max(p.lastObs || p.t, oldest)`, so every bucket reaching the guard
already satisfies it. **Unreachable by its own upstream limits** — the dead-safeguard shape
(M080), and worse than that instance because the **Aug 12 instant-trip audit reasoned from
this guard**, rating `reconReplay` the least likely cause of sub-second trips on the
strength of a line that cannot execute. Also untestable by construction: any assertion
written against it would be a dead seed. Proposed both ways (delete and assert the upstream
guarantee, or keep it and give it a direct-call fixture); not applied.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S11-F1; `index.html:6412` and
`:6480–6486`; `audits/AUDIT-2026-08-12-scope.md` §8.

### M136 · Two runtime fields written and never read
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `ORPHAN`

`S.reconLast` captures `shadowRecover()`'s return and discards it. `S.anomMkt` captures the
market-index reading beside `S.anomSuppressed` and `S.anomRaw`, **both of which render**,
while it does not — and the reading it holds is already persisted as `DB.volIndex` and
rendered with its control rows. The correct fix for the second is **deletion, not wiring**:
wiring it would create a second source for one number, which is the redundancy scan's own
finding shape. Recorded because a write-only field is a claim that something is being
tracked.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F3/S10-F4;
`index.html:2173`, `:13086`.

### M135 · The 40% cap's explanation is composed and never rendered
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `SILENT-STATE`

`S.cohNote` builds the sentence *"N statistical candidates withheld by the 40% cap: …"* and
nothing reads it. Its sibling `S.cluMsg`, twelve lines below, is read and rendered by
`renderClusters()` — so the module's convention is exactly the one this was written to and
then missed. **Not merely an orphan:** the cap is an automated decision that withholds
candidates, and *every automated decision states its reason inline where the user reads it*
is BINDING. The reason exists, fully composed, and reaches no surface. It is also the
stranded caveat the surface-copy inventory named as that edit's risk — stranded at birth
rather than by a move.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F2; `index.html:3729`.

### M134 · The contamination register and the cleanliness clock have no writer between them
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `COMPOSITION`

`paperCleanFrom()` returns `DB.paperDefectsClearedAt || 0` and **nothing in the product
ever writes that field.** `PAPER_DEFECTS` is a hardcoded source array whose entries leave
the register when a developer deletes one and ships; the timestamp is persisted runtime
state. The two live in different worlds and the field joining them has a reader and no
writer.

Today the register is non-empty, so the function returns `null` and everything reads
contaminated — the safe direction, which is why nothing has surfaced. **The defect fires
the instant the last entry is struck:** `from` becomes 0, and every trip in the book,
including every trip that closed while the defect was live, is reclassified as clean
evidence in one step with nothing said. Deployment direction, flatters the book, triggered
by a build change rather than a press. The commit that clears the register both releases
the scanner proposal's hold and retroactively supplies the clean evidence the hold was
waiting for.

**The epoch-1 lesson inverted** (M097): a corrupt population that cannot be identified by a
field must be discarded rather than partitioned, and the answer then was to stamp
`FILL_MODEL_V`. Here the partition field exists in the reader and was never given a writer.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F1; `index.html:5872`,
`:6043`, `:12052–12056`.

### M133 · A BINDING rule claimed recurrence it could not evidence
2026-08-13 · found by: graduation audit · pattern: `CLAIMS-VS-CODE`

*"Known repeated bug class: gates that re-punish what sizing already priced in."* The
backfill searched the whole repo and found **zero** substantiated instances — every
`double-count` in the tree is a different defect (bank-plus-realized sizing, the funnel's
negative residual, the attention denominator). Root cause: the entry was written from
recollection at a moment when there was no evidence layer to check it against, and a
constitution with no ledger under it cannot tell a remembered defect from an observed one.
Consequence: unearned authority — the phrase *known repeated* is the strongest claim the
constitution makes about its own history, and it was resting on nothing. The claim was
**struck** rather than merely demoted; the underlying guidance survives without it.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2b; `grep -rin "double-count"`
over the repo returns four hits, none of them this defect.

### M132 · One root was written in three places, so its sixteen instances never accumulated
2026-08-13 · found by: graduation audit · pattern: `SCOPE-NAMING`

*A component reports nothing where it should report that it HAS nothing* lived as a BINDING
entity-state rule, a never-fed-aggregate case-law section, and a stalled-generator finding
in an audit report. Each read as a separate lesson, so no entry ever carried more than a
handful of instances and the pattern's real size — **16, the largest behind any single
rule** — was invisible until the incidents were tagged by root cause. Root cause: the
prophylactic ("name the property, not the surface") governs how a *new* rule is written and
says nothing about **merging rules already written about the same property from different
angles.** Consolidated into one BINDING entry carrying all five shapes and all sixteen
instances.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2c; CLAUDE.md BINDING (the
consolidated entry) and the two case-law sections that now defer to it.

### M131 · The test-suite face list had eleven shapes and ordinals reaching eight
2026-08-13 · found by: graduation audit · pattern: `LEDGER-ONE-WAY`

Two ordinals ("seventh", "eighth") appeared out of file order, one face was unnumbered, and
the highest ordinal was three short of the list's own length. **The count is the whole use
the list is put to** — a graduation argument rests on how many times a shape has recurred —
so a numbering that does not match its own list cannot support the argument it exists for.
Same defect class as the requirements pairing (M110/M111): a ledger nobody checked in one
direction. Renumbered against file order, with the two out-of-order bullets physically
swapped so the ordinals and the list agree.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2c; CLAUDE.md Verification,
the renumbering note.

### M130 · The integration-audit scan list had no scan 9
2026-08-13 · found by: graduation audit · pattern: `LEDGER-ONE-WAY`

The list ran 1–8, then 10, then 11. A BINDING rule cited "integration-audit scan 10 below"
as its detector, so **the citation named a position rather than a check** — and a position
in a list with a hole in it is not a stable reference. Nothing was missing operationally;
the clamp scan existed and ran. But a detector cited by number, in a list whose numbers
skip, is one renumbering away from pointing at the wrong scan. Renumbered contiguously and
every citation re-pointed.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §3; CLAUDE.md integration-audit
preamble.

### M129 · Analysis exports carrying the trading record sat loose in the repo tree
2026-08-13 · found by: inspection · pattern: `COMPOSITION`

Three `analysis-paper-2026-08-13*.json` files — curated reads of the user's own paper
book — were downloaded into `briefings/` and were untracked but not ignored. The hard
boundary ("nothing in this repo ever contains user trading data") held only because
nobody ran `git add -A`. Root cause: the export feature shipped with a documented
purpose (hand the file to an analyst in chat) and no rule about where the file lands,
and the browser puts a download wherever it likes. Fixed by ignoring `analysis-*.json`
and `gef-backup*.json` **in any directory**, with the reasoning written into
`.gitignore` itself. Never committed — verified with `git log --all -- 'briefings/analysis-*.json'`, which is empty.

Substantiated from: `.gitignore` (the ANALYSIS EXPORTS block); commit `5f67395` body
("Analysis exports gitignored; the repo carries the tool, not the data"); `git ls-files briefings/`.

### M128 · The near-miss line recited the bar instead of naming each item's standing
2026-08-13 · found by: review · pattern: `INTERROGABILITY`

The exception lane's near-miss surface printed the qualification bar rather than where
each candidate actually stood against it — a verdict whose stated reason named no items
and no thresholds, which is the interrogability scan's own definition of a finding.
Replaced with every item's standing against all seven clauses.

Substantiated from: commit `5f67395` body ("the near-miss ranking replaces the
bar-recitation line with every item's standing against all seven clauses"); REQUIREMENTS.md §63.

### M127 · The exception lane's span counted calendar days, not observed ones
2026-08-13 · found by: audit scan · pattern: `UNOBSERVED`

`spanD` measured the exception's evidence window in wall-clock days while the app may
have been closed for several of them. Same defect as `daysBenchedBy` (M094), on a
different surface, **one day after the observed-time rule was widened to reach every
denominator counting time or occasions.** Fixed to count observed days.

Substantiated from: commit `5f67395` body; REQUIREMENTS.md §63; CLAUDE.md BINDING,
observed-time entry.

### M126 · Seed J — the assertion required the right sentence and never forbade its contradiction
2026-08-13 · found by: seeding · pattern: `TEST-SUITE` (eighth face)

`[R62.6]` checked that the export's touch-ledger note says the schedule is "unverified
rather than false" when no walk-ups are recorded. The seed rewrote the note's **first**
half to claim *"the configured schedule is being followed"* — the exact opposite of the
rule — and left the asserted phrase in the second half intact. The suite stayed green
while the file asserted the contradiction. Root cause: an assertion about what copy
*claims* was written as a presence test only. Not a weak assertion and not a dead seed:
it ran, on real output, and permitted the contradiction. Fixed by adding the negative
match; the old form passes the seed and the new form fails it. Found while seeding, not
by suspecting it.

Substantiated from: CLAUDE.md Verification, "Presence of the right phrase is not absence
of the wrong one"; commit `5f67395` body.

### M125 · Seed G — a multiline substitution silently did not apply
2026-08-13 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 1)

A seed intended to break a rule matched nothing and left the file untouched. The suite
then ran green against unmodified code. The **precondition check caught it before the
result was read**, which is the only reason it is recorded as a caught near-miss rather
than as a false proof. Root cause: a scripted substitution across multiple lines has a
silent-failure mode, and "the command exited 0" is not "the text changed".

*Substantiation note:* the letter designation is the session's, not the repo's. The
shape is substantiated by CLAUDE.md's seeding precondition clause 1 and by its numbered
analogue, seed 34 in commit `46ffa0a` ("the first attempt's substitution silently
failed, which is the same class as a seed landing on unreachable code: the run was green
because nothing had changed"). The specific Aug 13 occurrence is recorded on the
strength of the session record and is flagged here as such.

### M124 · `shadowCredit`'s clamp discarded the pre-clamp term, so over-crediting was unreconstructible
2026-08-13 · found by: user question · pattern: `CLAMP`

`shadowCredit` stores `Math.min(qty, term)`. A per-bucket credit term larger than the
trip's own size was clipped and left no record anywhere. Asked whether the book had ever
over-credited, the only honest answer was *"cannot be reconstructed — the per-bucket
inputs are discarded at credit time — and bounded away from catastrophe only by the fact
that no trip ever filled inside a single bucket."* Consequence: over-crediting, the one
direction that would flatter every fill rate in the book, was **structurally
unobservable**, and the 75 trips already in the book are unanswerable rather than
favourable. Fixed by retaining a bounded buy-leg trace with the credit **before** the
clamp, including buckets that credit nothing. A trip with no trace reads UNKNOWN, never
as zero absorption.

Substantiated from: commit `9f5fdc6` body; REQUIREMENTS.md R59.7.

### M123 · `[R59.7]`'s first assertions read a hand-built trace — consumer asserted, producer unasserted
2026-08-13 · found by: seeding · pattern: `REIMPL`

Two of six seeds did not bite. The assertions constructed a trace object in the probe
and checked the consumer's arithmetic on it, so the code that *produces* the trace went
unchecked. Rewritten to assert through `shadowTick`, whose existing fixture is already
the over-credit case (4,000 low-side volume gives a 600-unit term against a trip of 10 —
clamped 60×). **This landed one turn after the clamp-absorption rule was written into
BINDING**, which is the sharpest available evidence that a freshly-written rule does not
protect the next thing you write.

Substantiated from: commit `9f5fdc6` body ("Two seeds initially did not bite — the
assertions read a hand-built trace, so they tested the consumer while the producer went
unchecked").

### M122 · `[R18.2]` was blind in the over-credit direction only
2026-08-13 · found by: audit scan (clamp sweep) · pattern: `CLAMP`

`p.buyQ = Math.min(qty, credit)`, and the assertion checked `buyQ === 10` where `qty` is
10. The qty clamp sat between the capture-capped term and every assertion about it, so
the probe could see **under**-crediting (it shows up as a short fill) and was blind to
**over**-crediting (it is clipped to qty and disappears). The fill model's entire claim
is that it is conservative, and nothing tested the half of it that could fail silently.
No extraction was needed — `reachCredit` was already named; the defect was purely in
what the assertions read. Fixed by asserting at a bucket volume 1,500× the trip size,
against the uncapped term, plus a **linearity** assertion — deliberately, because the
equality checks re-derive the term probe-side, which is the reimplementation tell, and a
scaling property is one no parallel implementation encodes.

Substantiated from: commits `29c6b73` (classified) and `e065431` (fixed); CLAUDE.md
BINDING, clamped-output entry.

### M121 · The `[R26.2]` repair was tautological — the guard could not evaluate false
2026-08-13 · found by: seeding · pattern: `TEST-SUITE`

Written **while deliberately fixing a weak assertion**, the first repair compared the
probation-granted plan against "the same plan with the grant lifted". Without the grant
the item does not fund at all, so the comparison is null and every guard against it
short-circuits to true: the repair passed with the halving deleted. Not a weak assertion
— a vacuous one. Root cause: the external-comparison technique that worked for the pump
caution (which has a fundable counterfactual) was reused on a path that has none. Fixed
by extracting `applySizeFactors()` and asserting it on its own arithmetic at a known
input, with no clamp in the way.

Substantiated from: commit `29c6b73` body; REQUIREMENTS.md R26.2.

### M120 · `[R7.3]` and `[R26.2]` asserted that a caution's note rendered, never that anything shrank
2026-08-13 · found by: seeding · pattern: `CLAMP`

The two paths that size real capital under a caution — a suspected pump, and a probation
grant funding an item a gate benched — were covered only by assertions that the
explanatory note appeared. Seeding confirmed both were unprotected: the multipliers could
be deleted and the suite stayed green. `applySizeFactors()` carries all four (caution,
probation, unproven T1, T2 ramp), which were **the only thing bounding capital on a
waived gate.**

Substantiated from: commit `29c6b73` body; REQUIREMENTS.md R7.3, R26.2.

### M119 · `probe-snippet.html:98`/`:105` both asserted clamped outputs, six times below the term
2026-08-13 · found by: audit scan (clamp sweep) · pattern: `CLAMP`

The two allocator sizing assertions read `allocQty === 4000` and `5000` — the **cluster
cap** and the **per-item cap**. Measured on the probe's own fixture the allocator's
horizon term computes **30,000 units**, so neither figure could see a defect in the
sizing that feeds them; the pair did not cover the gap as hoped. Both were written as
sizing coverage. Fixed by extracting `planHorizonUnits()` and asserting the term at
source; the caps keep their own assertions, which are worth having as clamp tests.

Substantiated from: `tools/probe/probe-snippet.html` lines 96–112 (the comment records
the finding in place); commit `29c6b73` body.

### M118 · Clamp absorption at `shadowHorizonUnits` — reverting the horizon changed no output
2026-08-13 · found by: seeding · pattern: `CLAMP`

Paper sizing reverting from the fixed horizon back to the schedule changed nothing
observable, because `planCap`'s buy-limit clamp pinned both readings to the same number.
This is the **second occurrence** of the shape and the one that graduated it to BINDING —
`strataCount` (M074) was the first. Fixed by extraction: pull the term into a named
function and point the assertion there.

Substantiated from: CLAUDE.md BINDING, clamped-output entry ("graduated to BINDING on
the second occurrence, which is the bar"); commit `5f67395` body.

### M117 · The recipe-basis copy still advertised a feature withdrawn two days earlier
2026-08-13 · found by: inspection · pattern: `REMOVAL-SWEEP`

The Prospecting surface's copy went on describing the recipe basis after the monitor was
removed whole on Aug 11. The removal commit swept code, `DB` keys, the poll call, the
freshness rows, the WHAT CHANGED line, the panel and the import sanitiser — and left the
prose. Same commit also caught §31's requirement rows still claiming probe coverage
(M110). **Deletion is the moment stale mentions are created**, and the artefact classes
have to be enumerated then, not discovered later.

Substantiated from: CLAUDE.md surface map ("the recipe basis was withdrawn Aug 11 2026
and the copy that still advertised it was removed Aug 13 2026"); REQUIREMENTS.md R35.4
("this clause WITHDRAWN Aug 13 2026"), R31.1–R31.2.

### M116 · A share of a negative net read exactly like a concentration figure
2026-08-13 · found by: analysis · pattern: `CLAIMS-VS-CODE`

`top5 / net` on a losing cell returns a percentage that looks like concentration: the gap
band's daytime cell yielded **13%**, which would have been read as "well spread". The
arithmetic was correct; the denominator's sign changed the meaning. Both concentration
figures now withhold, with the reason stated, wherever the net is not positive.

Substantiated from: CLAUDE.md case law, "routing is not coverage", third companion.

### M115 · `n` was treated as sample size where one trip carried the cell
2026-08-13 · found by: analysis · pattern: `POOLING`

The gap band's overnight cell showed 3 trips netting **+399k** — of which one
10.6m-notional trip is **+412k**, i.e. one result and two that offset it. The top-trip
share is **103%** of the cell's net. A trip count cannot show that and a rate cannot
either. Consequence: without the concentration reading, three trips would have read as a
finding. The top-trip share now renders per cell, and the routing bar treats a trip count
as necessary and not sufficient.

Substantiated from: CLAUDE.md case law, "routing is not coverage", second companion;
HANDOFF.md §1f.

### M114 · The dimension nothing rendered — a cohort whose halves disagreed in sign
2026-08-13 · found by: reading an export by hand · pattern: `POOLING`

The gap band printed **+399k on 3 overnight trips against −219k on 16 daytime ones** —
opposite signs inside one population. Nothing on screen split any cohort by horizon, so
seeing it required downloading the analysis export and grouping trips by hand; and the
export's own `byHorizonShape` tally pooled every cohort into two counts, which cannot
show a cohort whose halves disagree. Root cause: **a pooled statistic is at least visible
as a pooled statistic; a dimension no surface splits by is invisible to the reader and to
the pooling scan alike.** Scan 8 was extended to read artefacts and to check the
dimensions a population is *not* split by at all; the split got its own panel.

Substantiated from: CLAUDE.md case law, "routing is not coverage", first companion;
CLAUDE.md integration audit scan 8; HANDOFF.md §1f.

### M113 · Routing evidence nearly un-held a coverage proposal
2026-08-13 · found by: user ruling · pattern: `EVIDENCE-ROUTING`

The overnight/daytime split was striking enough to be read as support for the held T3
scanner proposal for the gap band. It is not: the evidence argues about **when** the
band's trips should be placed, not **how many** of its items should be watched.
Different change, different cost, different failure modes. Had it been read across, a
proposal would have been ratified by a finding that was never about it. The scanner
proposal stays held; routing was raised as its own question against the same bar.

Substantiated from: CLAUDE.md case law, "routing is not coverage" (user ruling);
HANDOFF.md §1f.

### M112 · The paper book priced every placement for a schedule the operator did not keep
2026-08-13 · found by: measurement against the walk-up log · pattern: `CLAIMS-VS-CODE`

Every paper placement sized and priced for the gap to the next **configured** touch.
Measured against the actual walk-up log: **1 of 18 sessions** fell within half an hour of
a configured touch, mean mispricing **2.20h**, systematically short in **13 of 17**
intervals. The tell was that three different verdicts came out of the same 75 trips in
one day, each from fixing a *label* rather than from new data — the dimension was
measuring bookkeeping, not the market. Fixed with `PAPER_HORIZON_H = 6`, derived from the
only uncensored window the book had, and `FILL_MODEL_V=2` to partition the populations.
Gap labelling retired in favour of time-of-day-opened.

Substantiated from: commit `5f67395` body; REQUIREMENTS.md §62, R62.5.

---

# 2026-08-12

### M111 · `[R61.x]` — six assertions tagged against requirement rows that were never written
2026-08-12 · found by: building the reverse check · pattern: `LEDGER-ONE-WAY`

Six assertions for the verdict-first work carried `[R61.x]` tags and no §61 rows existed.
The report printed `REQ PASS R61.1` against nothing for a day. **A requirement that does
not exist cannot fail, and the report said it passed** — the ledger lying in exactly the
direction it was built to prevent. Fixed by `tools/probe/reqpair.sh`, which lives outside
the page because it must read `REQUIREMENTS.md`, and which rewrites the report header so
`head -1` never says PROBE-PASS while a pairing failure stands.

Substantiated from: REQUIREMENTS.md R6.2; PROBE.md, the pairing-check section; CLAUDE.md
Verification, "The pairing is checked in BOTH directions"; commit `5f67395` body.

### M110 · §31's withdrawn rows claimed probe coverage after their assertions were deleted
2026-08-12 · found by: building the reverse check · pattern: `LEDGER-ONE-WAY`

The withdrawn crafting-spread rows went on citing `` probe `[R31.x]` `` after the
assertions were removed with the feature, and R35.4 cited one of them. **This is the
seasoning-gate shape (M017) with the arrow reversed** — a spec claiming an implementation
that is not there. Root cause: the ledger was only ever checked tag→row; nothing walked
row→tag, and that is where the drift accumulates, because nothing there ever goes red.

Substantiated from: REQUIREMENTS.md R6.2, R31.1, R31.2, R35.4 (all three now marked
"WITHDRAWN — no verification … until Aug 13 2026 this column still claimed probe
coverage").

### M109 · The surface-copy inventory's headline premise was mis-measured
2026-08-12 · found by: self-check while cutting · pattern: `CLAIMS-VS-CODE`

The inventory reported `paperCaveat` as the worst offender "by a distance" — 410
characters re-rendered at **every** paper citation. Wrong: `PAPER_NOTE()` appears only
inside `drill()` note fields, which already render behind a tap, and `paperCaveat()`
renders standing exactly once. The real standing offenders were the three ranked below
it. Consequence: the user ruled a priority order on a false premise. Handled by flagging
the premise and re-cutting in corrected order, rather than quietly re-planning.

Substantiated from: `audits/INVENTORY-2026-08-12-surface-copy.md` (the original claim);
commit `83edd09` body (the correction).

### M108 · 22,608 characters of standing prose against a 7-decision budget
2026-08-12 · found by: measurement on request · pattern: `COMPOSITION`

79 persistent explanatory blocks, ~594 phone lines across four tabs. Every block
individually correct and individually justified; the failure was that they all rendered
at the same weight, always, so nothing was louder than anything else — and the two blocks
that most needed to be loud (contamination register, stall line) were 549 and 279
characters in a field of 22,608. Three "conditional" warnings rendered unconditionally,
which is why the real ones got missed. Composition, not content.

Substantiated from: `audits/INVENTORY-2026-08-12-surface-copy.md`; commits `222c0d4`,
`83edd09`, `46ffa0a`.

### M107 · Seed 31 — a property asserted on an injected trace, not the tick that records it
2026-08-12 · found by: seeding · pattern: `REIMPL`

The zero-credit-bucket property was asserted against a trace the probe injected, so the
wiring that actually records it went unchecked; the seed did not bite. Fixed by adding a
wiring assertion driven through `shadowTick`.

Substantiated from: commit `1ac9ea2` body.

### M106 · Seed 22 — `paperEpoch2Reset` was unreachable from any test while inline in `load()`
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed)

The seed changed nothing the suite could see, which reads exactly like a weak assertion
and was in fact code no test could reach. Extracted as a named function so an assertion
can call it; the seed then bit.

Substantiated from: commit `ee5d737` body; `audits/AUDIT-2026-08-12-scope.md` §11.

### M105 · Seed 21 — the stall line was asserted through its function, never through the surface
2026-08-12 · found by: seeding · pattern: `TEST-SUITE`

`shadowScanState()` was covered; the rendering that puts it on the paper headline was
not. A real coverage gap, not a weak assertion. Fixed by adding the wiring assertion.

Substantiated from: commit `ee5d737` body.

### M104 · Seed 17 — prediction stamping had no assertion at all
2026-08-12 · found by: seeding · pattern: `TEST-SUITE`

The seed did not bite because nothing tested the property. Discovered only because the
seeding practice requires watching a seed fail. Fixed with both a value seed and a wiring
seed (the scan stops calling the stamper).

Substantiated from: commit `fb7f251` body.

### M103 · Seed 32 — a `const` is fixed at load, so a re-derived expression evaluated to the same number
2026-08-12 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 2)

Seeding a derivation that happened to evaluate to the original value changed nothing
observable. The line executed; the modification altered no behaviour. Re-seeded with a
differing value; it then bit. This is the worked example behind precondition clause 2.

Substantiated from: commit `83edd09` body; CLAUDE.md, the seeding precondition.

### M102 · Seed 34 — the substitution silently failed and the run was green because nothing changed
2026-08-12 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 1)

Same class as a seed landing on unreachable code, from the opposite direction: the file
was never modified. Re-applied correctly; it then bit.

Substantiated from: commit `46ffa0a` body.

### M101 · A deliberately weakened assertion, recorded rather than hidden
2026-08-12 · found by: build · pattern: `TEST-SUITE`

Whether a closed `<details>` zeroes its children's layout box is engine-dependent in
headless, so measuring height would have tested the renderer rather than the restructure.
The assertion was weakened to the structural property. Recorded here because a weakened
assertion that goes unrecorded is indistinguishable from one nobody noticed.

Substantiated from: commit `46ffa0a` body.

### M100 · The sell discriminator was ruled, shipped as traces, and reported as done
2026-08-12 · found by: self-correction on the record · pattern: `CLAIMS-VS-CODE`

The ruling asked for a **computed** classification. What shipped was per-bucket traces
plus a mechanism narrative — and reading a trace by eye is precisely what the ruling
ruled out. Reported as a correction in the next pass rather than absorbed silently, and
built as computation in `1ac9ea2`.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §9 ("I have to correct the record
on one point"); commits `fb7f251`, `1ac9ea2`.

### M099 · The fill model is bimodal per bucket, and it selects against fast legs
2026-08-12 · found by: hypothesis tested against the code · pattern: `CAUSALITY`

Two faults, together: **A** — a bucket credits only if its 5-minute *average* cleared the
ask, so a bucket whose average sat below it scores zero even though it certainly contained
prints above (that is what an average means, and the trader's own sale is one of them).
**B** — a bucket that does pass credits `floor(hv × capture)` on the bucket's *entire*
high-side volume, including prints below the ask that could not have filled the offer.
Zero-or-everything per bucket. A fast sell resolves inside one to three buckets, so a sell
into a brief spike — which is what a fast sell *is* — scores zero and reads "never-sold".
Consequence: the "1 of 43 completing" headline rests on this model, and is frozen. Fault A
was already documented as a bias on the BUY side and **was never carried on the sell
panel**, so a known bias went unnamed on the leg where it binds hardest.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §6 and §9; HANDOFF.md §1a.

### M098 · The analysis export shipped a rollup without its rows — in the first export built after the rule was widened
2026-08-12 · found by: audit scan (interrogability) · pattern: `INTERROGABILITY`

The interrogability rule was widened from screens to artefacts, and the very next export
built carried the sell-leg aggregate alone. Fixed to parity with the buy: per replayed
flip, window offsets, both verdicts, credited percentages on both bounds, the reach
census, the at-price count, and the bucket-by-bucket trace, with truncations declared.
Worth keeping because it shows how fast this particular defect regrows.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §6 ("This was the interrogability
rule violated in the first export built after widening it — the aggregate shipped alone").

### M097 · Epoch 1 was invisible until a field existed that could show it
2026-08-12 · found by: reasoning about the reset · pattern: `SILENT-STATE`

The corrupted epoch had to be **discarded** rather than partitioned, because nothing
recorded which build wrote each trip. The moment `openSeq` existed, a corrupt population
became identifiable by a field. Generalised: every trip now stamps `FILL_MODEL_V`, so a
future model fix partitions the epoch instead of invalidating it. Also: a per-trip
predicate can exclude *rows*, but the divergence ledger, the rolled counters and the
exception evidence are **cumulative** — no filter applied afterwards un-mixes a rolled
total, which is why the author's own interim (exclude the bad trips) was superseded.

Substantiated from: commits `ee5d737`, `325ecb6`; `audits/AUDIT-2026-08-12-scope.md` §11.

### M096 · The family cooldown fused two unrelated jobs, and the stall it caused was invisible
2026-08-12 · found by: diagnosis on report of a quiet book · pattern: `SILENT-STATE`

`shadowScan` blocked a family whose last trip was open **or** closed within `2 × FILLH()`.
`FILLH()` is the gap to the next touch, so at the evening touch the cooldown was
**nineteen hours** — longest exactly when the book has the most observation time and the
most to learn. Closing did not release a family, and family keys repeat, so once a wave
opened the book was quiet by construction. **The defect was that none of this was
visible:** a stalled generator and a quiet market are identical in every number on the
page. One constant was doing two jobs — concurrency (a property of being open, needing no
duration at all) and sample independence (a property of sampling, needing a fixed
interval) — and the fusion let the sampling rule inherit an exposure rule's scale.
`shadowScanState()` now computes the reason from the same values the scan gates on, and
the headline renders it whether or not anything is wrong.

Substantiated from: commits `ee5d737`, `eb26bae`; `audits/AUDIT-2026-08-12-scope.md`
§10 and §12.

### M095 · `estH` written onto every candidate and never read
2026-08-12 · found by: audit scan (orphan) · pattern: `ORPHAN`

Write-only data at `index.html:4060`. Recorded rather than removed, since removing
production fields was not what had been asked — flagged so it is a decision rather than
an oversight.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §7.

### M094 · `daysBenchedBy(id, gate, 7)` counted days nothing had looked at
2026-08-12 · found by: audit scan · pattern: `UNOBSERVED`

Gate-persistence proposals read "benched by this gate on 4 of the last 7 days" with a
denominator of 7 even when the app was closed for three of them. The numerator was always
honest — a ledger row exists only on a day a plan actually built — so the defect was
purely the denominator claiming a period nothing observed. **The 4-of-7 bar is the
standard that moves gate constants**, and a standard must not be read against an inflated
window. Fixed: `observedDaysIn()` is the ledger of days a plan built, `daysBenchedBy()`
returns the pair `{n, obs}` so no caller can render the numerator without its coverage.

Substantiated from: CLAUDE.md BINDING, observed-time entry; REQUIREMENTS.md §51,
probes `[R51.1]` `[R51.2]`.

### M093 · "None carry multi-day persistence" where the bar was arithmetically out of reach
2026-08-12 · found by: audit scan · pattern: `SILENT-STATE`

The gate-persistence pile reported no persistence when the truth was that fewer than four
days had been observed and the 4-day bar could not be met. **Unreachable is not absent**,
and on screen the two are indistinguishable. Second instance of the never-fed-aggregate
shape in the same review; the copy now says which.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", observed-time widening
paragraph.

### M092 · The fill-horizon estimator's copy and computation had drifted apart, four ways
2026-08-12 · found by: audit against the ruling as restated · pattern: `CLAIMS-VS-CODE`

(a) **Reach share was carried nowhere**, though the ruling asked for it as a reported
figure. (b) **The window count was picked silently and the comment claimed the ruling had
specified it** — it had asked for the count to be proposed with reasoning. (c) **"Median
of the last 6 hours" was computed over however many readings existed**, so with two
readings the basis string claimed a statistic the computation did not support. (d) Found
while fixing (c): **the plan line's tooltip still described the pre-Aug-12 formula** —
`qty ÷ (buy-side 1h flow × 15% capture)` — for as long as the corrected input had been
live. All four are one class.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §7; commit `a851974` body;
REQUIREMENTS.md R50.3, R50.4, R50.5.

### M091 · The 1.32× optimistic lean came from an oracle variant using future information
2026-08-12 · found by: measurement · pattern: `CLAIMS-VS-CODE`

The lean that a correction was going to be built around divided by *in-window* flow,
which is information the estimator cannot have at prediction time. With the shipped input
the median observed/predicted is 0.70× — slightly pessimistic. **There is no stable
offset worth correcting; the residual is spread, not bias.** Recorded so nobody goes
looking for it again.

Substantiated from: HANDOFF.md §1b ("Answered, negatively — do not go looking for it").

### M090 · A pump defense's stated single lift path was contradicted by four calendar paths
2026-08-12 · found by: audit scan (restraint-lift, first run) · pattern: `RESTRAINT-LIFT`

The standing rule says a flagged pump caution lifts on **one** path, the user's
dismissal, "nothing else". Four calendar paths contradicted it: `validUntil` deactivation;
`intelSweep()`'s pending auto-dismissal (and the fingerprint counts any warning not
dismissed, so that broom was a lift hiding behind queue hygiene); `rulingsSweep()`'s
30-day staleness broom; and — found while writing the fix — **the anomaly leg's own
window, which let a defense that had already fired un-fire itself as its evidence aged.**
Evidence ageing is not evidence against. Only the first was in the initial report; the
enumeration is what surfaced the rest.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §4; commit `a851974` body.

### M089 · Ratified cautions lifted by the calendar with no press at all
2026-08-12 · found by: audit scan (restraint-lift, first run) · pattern: `RESTRAINT-LIFT`

A ratified `promotion-warning`, `watch-note` or `deflation-flag` stopped applying at
midnight on `validUntil`: item tags vanished, the sleeve stopped refusing the item, and a
`teeth` haircut lifted. Under the old wording this was fine — nothing was *armed*. Root
cause: the restraint/deployment rule had been written about **arming** a deployment and
said nothing about a caution ending by the calendar. Fixed with a `lapsed` state — the
caution keeps applying and asks once, batched — and the bulk action is deliberately the
restraining one ("extend all", never "drop all").

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §4; CLAUDE.md BINDING,
restraint/deployment entry; REQUIREMENTS.md §52.

### M088 · Two constitutional rulings could not both be read literally
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `SCOPE-NAMING`

"Advisory layers stay advisory" and "Membership bookkeeping applies itself" were in
direct conflict; the membership ruling superseded the first in one place and did not say
so. Left unresolved for a day (flagged in HANDOFF.md as "one live conflict"), then fixed
in place: the advisory rule now names its own supersession, its date and the carve-out,
with an instruction that the two are read together and neither quoted alone.

Substantiated from: HANDOFF.md §4; `audits/AUDIT-2026-08-12-scope.md` §1; CLAUDE.md
BINDING, advisory-layers entry.

### M087 · Most constitutional rules named the surface where a defect was found, not the property violated
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `SCOPE-NAMING`

**Ten rules** were too narrow to reach the next instance of their own defect. The worked
example: a rule written as "never blend a *rate*" — itself already a generalisation of an
earlier rule written about *net* — did not reach a pooled *median* three days later.
Others: interrogability bound screens and said nothing about files; observed-time bound
the paper book's reconstruction only; restraint/deployment covered arming and not
expiry; entity-state covered only allocator-touched entities; metric honesty was written
as a response procedure and did not bind unprompted copy; corrections were scoped to
intelligence records. Fixed by widening all ten, each carrying its escaping instance, and
by the prophylactic: **name the property first; the surface is only the example.** The
companion ruling split the constitution into BINDING and DOCTRINE, because a rule that
looks enforceable and isn't is the same defect class as a detector that cannot fire.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §1–§2; CLAUDE.md, the prophylactic
at the top and the ten widened entries.

### M086 · The R49.2 repair's first seed failed both forms — the fixture could not tell them apart
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (seventh face)

Deleting the split from the one gate blend failed the whole-section match too, because
the fixture held only one blend, so a section-wide pattern had nothing else to satisfy
it. **That would have been recorded as proof and would have proved nothing.** Rebuilt
with two gates carrying identical splits, the seed separated them; a standing assertion
now holds the fixture to carrying the decoy, so the scoping test cannot quietly become
untestable again. Where the dead seed changes nothing, this one changes too much; both
report as proof.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §3; CLAUDE.md Verification,
seventh face.

### M085 · `[R49.2]` matched against the whole page — the broad-container assertion
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `TEST-SUITE` (sixth face)

The assertion checked that a specific per-gate fill rate carries its cohort split by
testing `/watchlist 100% of 2/` against the entire page's HTML, which any other blend
anywhere on that page would have satisfied. **It ran, on real production output,
exercising real production code, and would have passed with the property deleted from its
subject.** This is the instance that forced the root property to be widened from "the
test never ran" to "…or ran and passed for a reason other than the property it names".
Fixed with `blendFrag(html, key)`, which scopes every per-surface pooling assertion to
the one `data-drill` element and its inline sibling.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §3; HANDOFF.md §4 ("A seventh face
… not yet in case law"); CLAUDE.md Verification.

### M084 · `[R40.1]`'s tolerance of 3.6 microseconds was asserting the clock, not the behaviour
2026-08-12 · found by: accident, while seeding an unrelated defect · pattern: `TEST-SUITE`

`planHorizonH()` reads the clock internally, so comparing it against `gapHoursAt(Date.now())`
at `1e-9` hours was comparing **two separate clock reads**; it passed only when both landed
in the same millisecond. Green for a day. Split per the intermittent-assertion ruling: the
behaviour is tested at one injected instant, the wiring keeps a tolerance of 3.6 *seconds*,
which is what "two reads moments apart" actually claims.

Substantiated from: CLAUDE.md Verification, "The simultaneity assertion"; commit `e0edba2`.

### M083 · Two seeds hid each other
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed, variant)

Commit `f8a0a73` seeded the ambiguous-reachability widening and the reconstruction
touch-history rule together. With the widening removed, passing a touch into a rule that
ignores touches changes nothing, so the second defect had no way to express itself and its
assertion stayed green. Neither seed was wrong; their interaction was. **Seed one at a
time; when a batch is unavoidable, re-run anything that did not fail in isolation.**

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `f8a0a73`.

### M082 · The calibration probe built its own replay window
2026-08-12 · found by: seeding · pattern: `REIMPL`

Seeding the window-anchor defect changed nothing the suite could see, because the probe
constructed the input the product would have constructed. **If a probe line constructs an
input the product would have constructed, the product's constructor is untested.**
Extracted as `calibWindow()` and `calibSummarise()` and re-seeded before it counted as
proof. Second instance of the reimplementation trap **in one day**.

Substantiated from: CLAUDE.md Verification, "The assertion that re-implements what it
tests" (the recurrence paragraph); commit `1f61df5`.

### M081 · The calibration window was anchored to the wrong end of the trip
2026-08-12 · found by: build review · pattern: `CAUSALITY`

The one calibration run performed before the fix (2-of-4) is **VOID** and, if
`DB.calib` still holds those numbers, they are wrong. Carried in HANDOFF.md as pending on
the operator, because the fix cannot reach a number already stored in the browser.

Substantiated from: commit `1f61df5`; HANDOFF.md §2 item 1.

### M080 · A dead safeguard: a 60-bucket trim behind a stored cap of 24
2026-08-12 · found by: seeding, then reading the two files against each other · pattern: `TEST-SUITE`

The calibration export trimmed any trace over 60 buckets to its first and last 20 — a rule
written into the requirements and rendered in the file's own truncation notice. The stored
trace cap was 24, so **the trim could never fire**. Nothing was wrong with either number
in isolation; the defect lived in the relationship, which no single reading of either file
surfaces. A guard whose trigger its own upstream limits forbid is decoration that reads as
protection. Fixed by raising the stored cap so the rule has work to do.

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `cff4655`.

### M079 · A second dead safeguard, and the dead seed that followed it
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed)

The same export carried a defensive fallback for an empty duration bucket while
`calibSplit()` already guaranteed both groups — unreachable. Seeding it changed no
behaviour, so the suite stayed green, **which reads exactly like "the assertion is weak"
and is in fact "the code you broke never runs."** Fixed the other way from the trim: the
dead branch was deleted and the assertion pointed at the upstream guarantee. *Choose by
asking which layer should own the promise, then make sure exactly one does.*

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `cff4655`.

### M078 · "A median 37% of intended size" was four populations averaged
2026-08-12 · found by: decomposition · pattern: `POOLING`

The figure read as a book-wide sizing problem. Split by cohort it is watchlist **100%**,
scanner T1 **37%**, scanner T2 **36.8%**, discovery slice **8.3%** — the items closest to
fundable fill completely. **On that sample it is evidence for the gates, not against
sizing**, which is the opposite conclusion. Fixed with `rateBlend()`, which emits the
blend and the split together so a caller cannot produce the first without the second.

Substantiated from: CLAUDE.md BINDING, never-pool entry; HANDOFF.md §1e; REQUIREMENTS.md §49.

### M077 · Two more pooled statistics that the rate-shaped rule did not reach
2026-08-12 · found by: audit scan (pooling, first run) · pattern: `POOLING`

`paperEconomics`' **median trip net** pooled four cohorts, and calibration's **median
share credited when wrong** pooled fast and slow legs. Neither is a rate, so `rateBlend()`
never saw them and the rule as written did not classify them. This pair is what forced the
second widening — from "never blend a rate" to "never pool a statistic, rate, median,
count, verdict or score alike".

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §5; CLAUDE.md BINDING, never-pool
entry.

### M076 · "Fill rate 100%" everywhere, with `neverFilled` zero in every rollup
2026-08-12 · found by: external analysis of the exports · pattern: `SILENT-STATE`

Every stratum and every hour reported 100%. A model built on the premise that
would-never-have-filled is the finding was finding it never. Root cause: **a rate with no
counterexample count reads as a claim when it is a default.** Every rate now renders its
counterexample count.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", second companion;
REQUIREMENTS.md §43.

### M075 · A ratio whose denominator was filtered by its own numerator
2026-08-12 · found by: external analysis of the exports · pattern: `POOLING`

The per-stratum sampling counter sat **after** the near-miss filter, so it counted only
items that had already qualified: near-misses were 577 of 578 sampled items — 100% by
construction — and contradicted the funnel's own attribution. *Count the population where
the test runs, not where it passes.*

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", third companion.

### M074 · The probe re-implemented `strataCount` and passed with the bug fully intact
2026-08-12 · found by: seeding · pattern: `REIMPL` + `CLAMP`

The assertion that the per-stratum sampling counters summed correctly **computed the
counts itself, in the probe**, rather than calling the production path — so it passed with
M075's bug live in `index.html`, because the bug was in code the assertion never touched.
The same instance is also the first occurrence of clamp absorption: the counter sat behind
the near-miss filter, so the probe's own arithmetic could not see it. The tell is a probe
line that *computes* rather than *calls*. Fixed by the extraction pattern — pull the logic
into a named function and point the assertion there.

Substantiated from: CLAUDE.md Verification, "The assertion that re-implements what it
tests"; CLAUDE.md BINDING, clamped-output entry (`strataCount` named as the first of the
two instances).

### M073 · Causality: the simulator filled legs from tape that printed before they existed
2026-08-12 · found by: external analysis of the exports · pattern: `CAUSALITY`

The fill model credited a leg from a trailing five-minute aggregate on the leg's **first
tick**, and re-credited the same bucket every poll. **182 of 272 trips opened and closed
in under a second (median 55ms), all "filled", booking 52% of the headline net** from tape
that predated them. Rules now: a simulated leg may only be filled by tape that printed
after it was placed, each bucket counted once, and a trip that resolves in its opening
cycle is a bug rather than a fill.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", first companion;
commit `d305c2f`; REQUIREMENTS.md §43.

### M072 · The regime race reported three zero curves for a whole epoch while nothing had ever fed it
2026-08-12 · found by: external analysis of the exports · pattern: `SILENT-STATE`

The machinery that exists to answer whether the 1.2% ROI floor is right spent an entire
epoch reporting three zero curves and a two-day all-zero divergence ledger while **not one
of 272 paper trips had ever been assigned to a regime.** Four of six entry paths hardcoded
an empty set instead of evaluating, and in that epoch those four were 96% of the book.
Root cause: membership was a **label individual entry paths had to remember to attach**
rather than a property of the candidate evaluated once centrally. Consequence: a stat that
renders 0 because nothing FEEDS it is indistinguishable on screen from one that renders 0
because nothing QUALIFIED, and the two mean opposite things.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate" (user ruling); commit
`d305c2f`.

### M071 · Instant trips: the export could not answer the question asked of it
2026-08-12 · found by: diagnosis on request · pattern: `SILENT-STATE`

Asked to explain sub-second paper trips, every close path was traced and **no path in the
current code can produce one**. The real defect was that the file could not settle it:
`openedAt`/`closedAt` are ISO strings, which truncate to the second, so "resolved in under
a second" and "resolved within the same second" are indistinguishable; and the rule is
stated in **poll cycles** while the file carried no cycle at all. Shipped as
instrumentation (`resolvedInMs`, `openPollSeq`) rather than as a fix — a null
`openPollSeq` *is* the diagnosis. One latent gap recorded rather than claimed as the
cause: `reconReplay` is the one close path where the minimum-life rule was never written.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §8; commit `fb7f251` body.

### M070 · Re-importing an already-ratified record was silently absorbed
2026-08-12 · found by: shipping a correction · pattern: `COMPOSITION`

Withdrawing the contaminated Jul-24 numbers from a brief exposed it: **eleven corrected
records would have left the wrong numbers on screen while the brief claimed they were
fixed.** Root cause: the import path treated re-arrival of a known record as a no-op, so
there was no landing path for a correction to an artefact the user had already read.

Substantiated from: CLAUDE.md case law, "the Jul 24 volume artifact", third corollary;
`briefings/BRIEF-2026-08-12.md` ("A defect found while shipping the corrections, and
fixed").

### M069 · A data-feed methodology change was read as market signal for four sweeps
2026-08-12 · found by: normalising against a control · pattern: `POOLING`

On 2026-07-24 reported GE volume stepped ~5–7× across the entire market at once, prices
flat. The accumulation-anomaly scan compares each item against **its own** volume 2–3
weeks earlier, so every baseline straddling that date showed a several-hundred-percent
gain; the scan raised seven flags reading "+418%", "+546%", "+930%". Four went to the
analyst desk for up to four sweeps hunting a story that did not exist, generating
watch-notes and a suspected-pump escalation off a number that measured the API.
Normalised against a control band, **not one flagged item showed item-specific growth;
three were below market.** Root cause: self-comparison cannot distinguish "this item
moved" from "the ruler changed length". Fixed with `VOL_INDEX_BASKET`. Two corollaries
cost something too: suppression means **not flagged**, not flagged-on-half (the
accumulation signature is price AND volume; flagging on price alone invents the missing
half); and the index is itself an aggregate whose one failure mode is visible only in its
control rows, so the panel opens to them.

Substantiated from: CLAUDE.md case law, "the Jul 24 volume artifact" (user ruling);
commit `4b104aa`; `briefings/BRIEF-2026-08-12.md`.

---

# 2026-08-11

### M068 · The observation floor disqualifies the strategy the schedule exists to enable
2026-08-11 · found by: audit scan (cadence impact, before the build) · pattern: `COMPOSITION`

`shadowTick` credits observation as `min(now − lastObs, SHADOW_OBS_CAP)` with the cap at
10 minutes, so a closed tab collapses an entire gap to one capped credit. An overnight
paper trip against a 9.5h horizon accrues **~1.7% observed share**, and the 25% floor
excludes it. **Every overnight paper trip would be excluded as "insufficient
observation."** Neither component was malfunctioning; the defect was entirely in their
interaction, and it fell on exactly the strategy the four-touch shape was adopted for.
Reported with three options and no recommendation smuggled in, because it is a strategy
parameter.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §0.

### M067 · `limitWindows()` was a constant 2, overstating daytime sizing by up to 2×
2026-08-11 · found by: audit scan (cadence impact) — **not in the brief** · pattern: `COMPOSITION`

`limitWindows() = floor(DB.horizonH / 4)` = 2 at the default 10h day horizon, and it
multiplies the buy-limit cap in three sizing paths. A 5h daytime placement can roll only
**one** 4h buy-limit window. Daytime sizing on buy-limit-bound items was overstated by up
to 2× — the most concrete "tuned for a long sit, misbehaves at 5h" case in the audit, and
a real capital consequence rather than a display one. Found by sweeping for constants that
divide by a hardcoded 4h or assume two touches, which is a scan nobody asked for.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §5.

### M066 · `staleBuyInfo` split the day at a hardcoded 15:00
2026-08-11 · found by: audit scan (cadence impact) · pattern: `COMPOSITION`

A literal two-touch convention baked into a constant. Under four windows it is simply
wrong. Same class: the ladder rungs measured against a global horizon rather than the
leg's own, so an evening leg would hit rung 2 at 05:00 while still mid-sit.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §5; CLAUDE.md cadence section
("A leg ages against the horizon it was PLACED under").

### M065 · Seasoning qualified twice as fast because the cadence changed underneath it
2026-08-11 · found by: audit scan (cadence impact) · pattern: `COMPOSITION`

`updateQualStreaks` is poll-driven but effectively visit-driven at a ~6-minute touch, so
doubling the touches halved the time to clear "3 passes spanning ≥2h" — from ~1.5 days to
inside one day, **with nobody changing the rule.** Whether that is acceptable depends on
what the rule was buying, so it was reported as needing a ruling rather than rescaled.
Re-expressed as 3 passes, one per touch, spanning ≥1 calendar day.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §4 and the build report.

### M064 · The couch-minute metric halved for a bookkeeping reason
2026-08-11 · found by: audit scan (cadence impact) · pattern: `CLAIMS-VS-CODE`

`touchSessions()` counts `DB.touchLog.length`; four touches a day is four sessions rather
than two, so at an unchanged minutes-per-visit the gp/attention-minute metric halves for
the same daily gp. Arithmetically correct and directionally misleading — **the number
falls because attention is counted more finely, not because it got worse.** Rule: when a
metric's denominator changes because the cadence changed, show both sides and state the
change in place.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §1; CLAUDE.md cadence section,
final bullet.

### M063 · Forced exits priced at the moment we noticed, booking days of drift as simulated P&L
2026-08-11 · found by: pre-absence audit · pattern: `CAUSALITY`

Paper trips whose horizon expired during a closed tab were force-exited at **today's**
price. Consequence: the whole counterfactual baseline argued for **looser** gates on
evidence of fills that never happened, and had to be discarded — this is the defect that
caused the epoch reset. Fixed properly later (Aug 11g) by pricing forced exits at the
series value **at the horizon**, which is correct on a perfect host too.

Substantiated from: commit `828f526` body; commit `0ea4791` (the purge);
`audits/AUDIT-2026-08-11g-cadence.md`, build report.

### M062 · Scout wiped the watchlist on the first open after 48h away
2026-08-11 · found by: pre-absence audit · pattern: `SILENT-STATE`

The 7-day chart cache is in-memory and empty on a cold boot, so every item failed "chart
still loading", no `lastPass` refreshed, and the eviction fired **with a demonstrably
false reason.** A cold cache was read as evidence about the items. Fixed: nothing may be
culled unless its chart actually loaded; same guard on the sibling washout.

Substantiated from: commit `828f526` body.

### M061 · The chart never refreshed in a long-lived tab
2026-08-11 · found by: pre-absence audit · pattern: `STALENESS`

Trend, momentum and volume-trend gates judged today's prices against a chart fetched at
boot — potentially a fortnight stale. A long-lived client has to notice its own staleness;
nothing did. `fillSparks` now rides the poll.

Substantiated from: commit `828f526` body.

### M060 · Regime evidence said "4 of the last 7 days" while reading 7 rows that can span a month
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

**A full day before the observed-time rule existed, and the same defect that recurred in
`daysBenchedBy` (M094) on Aug 12 and in the exception lane's `spanD` (M127) on Aug 13.**
Fixed locally at the time: it now says *readings*, and names the span. The general rule
was not written until the third occurrence.

Substantiated from: commit `828f526` body ("Regime evidence said '4 of the last 7 days'
while reading 7 rows that can span a month after an absence").

### M059 · Seasoning counted a five-day gap as a pass
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

A gap is not an observation. Same root as M060, in the same sweep.

Substantiated from: commit `828f526` body.

### M058 · Die-off counted unobserved windows as the gate being right
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

"Still under the floor at +24h" was credited to the gate when nobody had looked. Now "not
confirmed recovered", which is what was measured. Third instance of the same root in one
commit — a signal that should have produced the general rule and did not.

Substantiated from: commit `828f526` body.

### M057 · `/timeseries` had no backoff and no negative caching
2026-08-11 · found by: pre-absence audit · pattern: `STALENESS`

An endpoint rejecting timeseries while `/latest` stayed healthy would be re-hit thousands
of times a day, unattended, with nothing on screen. Circuit breaker, visible banner and
stale-cache fallback added.

Substantiated from: commit `828f526` body; REQUIREMENTS.md §32.

### M056 · A row with paper history rendered nothing below 3 closed trips
2026-08-11 · found by: pre-absence audit · pattern: `SILENT-STATE`

The row's expand view showed the trips while the row itself showed nothing — **"the F18
defect in a new place"**, in the author's own words at the time. Any paper activity now
renders an accruing state.

Substantiated from: commit `828f526` body.

### M055 · Two indicator dots were both green filled circles meaning different things
2026-08-11 · found by: use · pattern: `SILENT-STATE`

Adjacent, identical, different meanings. Fixed by making **shape** carry identity (paper
is circle-in-circle, test stays plain) and colour carry state within it, with fixed slots
so a missing dot leaves its space, self-naming tooltips and a legend showing every state
side by side. Also: the test dot moved to neutral steel, because verified-vs-stale is not
good-vs-bad.

Substantiated from: commit `828f526` body.

### M054 · Accrual was coupled to a render path that "happened to run"
2026-08-11 · found by: trace on request, before an unattended run · pattern: `COMPOSITION`

Every plan-driven ledger — gate-health rows, die-off episodes, qualification streaks,
paper positions, the per-stratum sampling ledger and the hourly funnel bucket — was
written from inside `renderDeploy`, reached through the vitals renderer. That happened to
run on all four tabs, so nothing was broken that day. **"Happens to be called from the
current layout" is exactly the coupling that produced the reorg accrual bug (M025), and it
fails silently the next time a surface moves.** Accrual now rides the poll directly.

Substantiated from: commit `b9c8add` body; REQUIREMENTS.md R34.1.

### M053 · Granted exceptions survived the purge that destroyed their evidence
2026-08-11 · found by: reasoning about the purge · pattern: `SILENT-STATE`

Exception grants are **rulings**, so nothing revokes them by machine — but a ruling that
survives its own justification would have persisted by inertia with nothing saying so.
Each now raises its own walk-up line until deliberately settled, and the decision log
keeps re-made-on-new-evidence and re-made-on-judgment apart, because they are different
claims that would otherwise read alike.

Substantiated from: commit `fcfb2dd` body; REQUIREMENTS.md R26.5.

### M052 · The glossary advertised a gesture nothing implemented
2026-08-11 · found by: rewriting the glossary · pattern: `CLAIMS-VS-CODE`

The old glossary said "on the phone, tap any badge for its explanation" and **nothing
implemented it** — a claim in copy with no machinery behind it. Absorbed by the rewrite
rather than left standing beside the new work.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2.

### M051 · Nineteen glossary entries covered ~19 of ~150 rendered terms, and two of them were stale
2026-08-11 · found by: audit scan (glossary coverage, first run) · pattern: `CLAIMS-VS-CODE`

Coverage was roughly 13%. Two surviving entries made **location or authority claims** that
had gone false the same day: per-basket P&L "reported in the review" (it had moved to the
Sleeve tab) and "candidates never cap anything until you ratify them" (superseded by the
auto-apply ruling). Both now regression-asserted, **because a stale claim about where
something lives is the shape this file will keep producing.** Rewritten to 70 entries in 7
groups, generated from a `GLOSSARY` data structure so coverage is checkable rather than
eyeballed.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, glossary addendum.

### M050 · Glossing a control that already explains itself
2026-08-11 · found by: use · pattern: `COMPOSITION`

The ⚠ caution chip is a **button** whose press opens the row's expand view with every
caution and its reason; a definition popover on top of it competed with the thing being
reached for. Same for the expand view's own caution lines, which already render their
`why` inline. Rule: **gloss vocabulary, never an affordance.** Found by using the tool, not
by the suite.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, defect 2.

### M049 · The hover bridge — dead space closed the popover before its link could be reached
2026-08-11 · found by: use · pattern: `COMPOSITION`

Crossing the gap between a term and its popover fires `pointerout` with a relatedTarget
that is neither element. Closing is now deferred ~260ms and cancelled if the pointer
arrives at the popover or returns to the term. Recorded with M050 because neither was
catchable by any assertion that would have been written first — they are now.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, defect 1.

### M048 · `[R39.8]` failed against correct app code — an ambient event from an earlier block
2026-08-11 · found by: seeding/diagnosis · pattern: `TEST-SUITE`

Dismiss-on-scroll was right; a scroll event left over from earlier fixture activity was
closing the popover mid-measurement. **An async ambient event from an earlier block
landing inside a later block's measurement window** — a sibling of the clock-dependence
already in case law, diagnosed the same way: disable the suspected mechanism, confirm the
assertion passes, restore. The fixture now settles scroll position and drains pending
events.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, "A fixture finding".

### M047 · `[R18.1]` failed at random, roughly 1 run in 7
2026-08-11 · found by: repeated suite runs · pattern: `TEST-SUITE` (fifth face)

It compared the whole paper book's length across a rescan, folding the dedup rule it
claimed to test together with the discovery slice's draw — whose family key embeds the
first-failing gate and whose stratum comes from the price cycle, both functions of the
clock. **A test that fails at random teaches the operator to ignore failures, which is the
same damage as a test that cannot fail.** The ruled fix is the durable part: **never
stabilise by pinning the ambient input** (pinning the fixture clock would have traded a
flaky assertion for a silently-wrong one everywhere `S.latestAt` carries staleness
meaning). Instead inject the varying input, or assert the property that holds across all
its values; if neither is possible, split the assertion in two.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5 (the open finding);
`audits/AUDIT-2026-08-11f.md` §6 (the fix); CLAUDE.md Verification.

### M046 · The epoch-banner assertion was vacuously true
2026-08-11 · found by: seeding · pattern: `TEST-SUITE`

`!shadowEpochYoung() || …` passes whenever the banner is not due, and the fixture never
made it due. Now forces the young state, asserts, and restores.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5.

### M045 · The hours-table assertion had an escape hatch, and the fixture took it
2026-08-11 · found by: seeding · pattern: `TEST-SUITE`

It read "if the panel has hour data, check the two streams, else pass" — and the fixture
had no hour data, so it passed vacuously. The fixture now seeds `roiHour` readings and the
guard is gone. Same shape as M043: a detector written for the right property with a fixture
that prevented the property from expressing itself.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5.

### M044 · A probe line ending `… || true`
2026-08-11 · found by: reading the suite · pattern: `TEST-SUITE` (first face)

Written to check the poll calls the accrual step. It passed unconditionally and asserted
nothing whatever. The plainest possible instance of the root, and the one the case-law
section opens with.

Substantiated from: CLAUDE.md Verification, "The `|| true` assertion".

### M043 · The R29.4 durability detector was built so its own defect could not express itself
2026-08-11 · found by: seeding · pattern: `TEST-SUITE` (second face)

It seeded a closed record, rolled it, **then** aged it past the retention window — so it
passed whether the roll happened before or after the prune, which was the entire property
under test. **It was written specifically to catch that bug and still could not.** Rewritten
to start from a record already past the window. This is why the seeding practice binds every
new assertion, not only detectors written for known bugs.

Substantiated from: CLAUDE.md Verification, "The R29.4 durability detector".

### M042 · `[R24.2]` — "target top in viewport" passed with the title hidden under sticky chrome
2026-08-11 · found by: use, then seeding · pattern: `TEST-SUITE` (fourth face)

Which is precisely how the deep-link offset bug shipped green. DOM position is not visible
position. Fixed by asserting the first **visible** title sits below the chrome's bottom edge,
with `scroll-margin` derived from measured sticky chrome.

Substantiated from: CLAUDE.md Verification; commit `f9848ff`.

### M041 · `[R22.2]` — existence assertions cannot test a scoping rule
2026-08-11 · found by: user report of the regression · pattern: `TEST-SUITE` (third face)

The assertions checked `querySelector("#tab-home #homeRulingsPanel")`, which succeeds
whether or not CSS hides the element. **A display-layer bug was structurally invisible to
an existence-based test**, and the prior report's claim of "verified" was true of structure
and false of the screen. Rewritten to assert the negative — `offsetParent === null`,
`getComputedStyle(...).display === "none"` — on the surfaces that must be clean, and then
**proven against the original defect** by reintroducing the bad selector and watching it
fail with exactly the reported symptom.

Substantiated from: `audits/AUDIT-2026-08-11d.md`, "Why the probe passed"; CLAUDE.md
Verification.

### M040 · An ID selector silently overrode the tab gate, rendering Home on every tab for a day
2026-08-11 · found by: user report · pattern: `COMPOSITION`

`#tab-home{display:flex;flex-direction:column}` outranks `section.tab{display:none}`, so the
Home section computed `display:flex` on **every** tab from commit `959aee9` onward. The
scoping work shipped two commits later was applied to the correct render branch and was
reported as verified; the CSS gate it depended on had already been overridden. Fixed with
`#tab-home.on{...}` so the layout composes with the gate instead of overriding it.

Substantiated from: `audits/AUDIT-2026-08-11d.md`, "The miss, explained (both halves)".

### M039 · Deep links landed on the review's *discussion* of a surface, not the surface
2026-08-11 · found by: user report, then generalised · pattern: `COMPOSITION`

Four call sites carried `review#ckstep-shadowbook` (the paper-book vitals tile, the NOW-bar
accrual line, two WHAT CHANGED lines) and one carried `review#ckstep-recipes`. The reported
defect generalised into a class, every destination was audited, and **the probe now asserts
the negative**: no deep link anywhere may point at a checklist step standing in for a real
surface.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §5.

### M038 · I4/I5/I6 — the observation floor's exclusion counts were bare numbers
2026-08-11 · found by: audit scan (interrogability, re-run) · pattern: `INTERROGABILITY`

**A count of what a verdict threw away is itself an aggregate**, and "3 excluded" that
cannot be opened is exactly the number the operator cannot audit. Three instances (gate
tree, cohort ledger, hours table), all introduced by the same build that introduced the
floor. Fixed in `thinNote()` itself rather than at the three call sites, so the next
aggregate reporting an exclusion inherits the drill-down.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §2.

### M037 · I1/I2/I3 — three bare counts on the three new sub-views
2026-08-11 · found by: audit scan (interrogability, first run) · pattern: `INTERROGABILITY`

Prospecting's **Filled** column, Gate Health's **funded lines** count, and the paper
stream's **"(N at 100%)"** reading were openable nowhere or only on a different surface.
All three shipped in the same commit as the primitive that exists to prevent them — the
collection layer outrunning the display layer, in one build.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §4.

### M036 · The recipe-basis monitor terminated in prose
2026-08-11 · found by: answering "what decision does this change?" · pattern: `ORPHAN`

It sized nothing, capped nothing, benched nothing, and fed no gate, no scout nomination and
no paper trip — the break rendered a sentence, and acting on it meant hand-carrying an item
name to the watchlist. Its manipulation-tell half duplicated `suspectedPump`, which is
already wired to auto-arm restraint. Ten hardcoded recipes is also a fixed, tiny universe
beside the stratified slice. Cut entirely rather than relocated; **if it returns it should
return wired**, which is a new capability with its own price tag.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §7; REQUIREMENTS.md R31.1 (WITHDRAWN).

### M035 · F15 — probe-profile state leaked between runs
2026-08-11 · found by: a probe failing only after another run · pattern: `TEST-SUITE`

The headless profile's localStorage persists across runs, so a prior run's review
engagement leaked into the next run's early assertions. In the app the persistence is
correct; in the suite it is pollution. Noted at the time because the failure mode — "test
passes alone, fails after another run" — will recur for any future per-visit state that
skips the clean-fixture block.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F15.

### M034 · F14 — a new standing decision would have dodged the attention budget
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

The review-ready line is a decision point ("start review or not") that did not count
against the ≤7 budget — **exactly the double-standard the budget exists to prevent.** Now
counted, with the R13.1 fixture pinned so its exact-6 expectation still measures what it
always measured.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F14.

### M033 · F13 — the NOW bar could point into a hidden walkthrough
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

`nextMove` suggested "Walk-up · step N" from the raw checklist regardless of collapse
state, and knew nothing about an engaged review — the "two checklists demand attention"
state the ruling forbids, one layer up. Fixed by having `nextMove` read `ckEffectiveList`,
the same list the renderer draws, so the two surfaces cannot disagree.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F13.

### M032 · F18 — held and mm-owned items passed every gate and appeared in no bucket
2026-08-11 · found by: audit scan (auto-promote walk) · pattern: `SILENT-STATE`

No badge, no reason, no bucket. The auto-promote machinery was **working** — `buildPlan`
refunds from the ranked pass list on every recompute — and felt press-gated purely because
of display. **An unexplained state reads as a broken feature even when the machinery
underneath is correct.** This is the incident the entity-state rule is written from, and
the shape recurred at M056 (a row with paper history), M072/M093 (never-fed aggregates) and
M096 (a stalled generator).

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 4; CLAUDE.md BINDING, entity-state
entry.

### M031 · F17 — audit deep-links landed on the tab top, nine steps above the target
2026-08-11 · found by: audit scan (ruling-path walk) · pattern: `COMPOSITION`

"Rule it in the review's audit" navigated to the Review tab top. Fixed by anchoring.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 3.

### M030 · F16 — rulings made from the Home digest appeared to do nothing
2026-08-11 · found by: audit scan (ruling-path walk) · pattern: `COMPOSITION`

The ratify/edit-ratify/dismiss handlers re-rendered the Sleeve queue and the watchlist but
never the digest or the ⚖ badge: pre-reorg those handlers served the Sleeve cards, and the
reorg made the digest the primary ruling surface **without adding it to their render set.**
A ruling appeared to do nothing until the next poll — so "ratification actions not
findable" was the ruled line still sitting there after being ruled.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 3.

### M029 · The collapse control's first tap did nothing
2026-08-11 · found by: user report · pattern: `COMPOSITION`

Neither suspect was right. Every render pass rebuilt the checklist header via `innerHTML`
even when the markup was byte-identical, and a rebuild landing inside the tap window
(pointerdown on the old node, pointerup on its replacement) produces **no click event at
all**. Boot data arrives ~1s after open — right when a walk-up's first tap lands — and the
60s poll re-renders thereafter, which is why "works later or after reload" was the
signature. Fixed with `setHTML`, a content-diffed write.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 1.

### M028 · F12 — visit state does not survive export→import (accepted, stated)
2026-08-11 · found by: audit scan (orphan) · pattern: `COMPOSITION`

The delta clock and end-of-visit snapshot are attention state and sit outside the export
sanitizer, so a restored browser says "first visit with the delta tracker" instead of
diffing against a foreign baseline. Recorded rather than fixed **so the omission is a
decision and not an accident** — the alternative was considered and not recommended.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F12.

### M027 · F11 — stale feature-touch keys would have poisoned the dormancy report
2026-08-11 · found by: audit scan · pattern: `ORPHAN`

After the tab rename, `tab:watch`/`tab:shadow`/`tab:routine` stopped being written; in 90
days the dormancy report would have proposed demoting surfaces that are alive under the new
keys. A rename creating a **future** false signal, caught before the window elapsed. Fixed
with a one-time key migration.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F11.

### M026 · F10 — the rulings digest rendered twice on one screen
2026-08-11 · found by: audit scan (redundancy), caught mid-walk · pattern: `COMPOSITION`

Home's digest block and the walk-up checklist's "Rule on what's pending" step both rendered
`rulingsInline()` — the same interactive lines, twice. On Home the step is now a pointer.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F10.

### M025 · F9 — the boot-tab change would have silently starved the ledgers
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

The funnel ledger and the entire paper book were side-effects of `renderDeploy`, which ran
because the old boot tab was Watchlist. With Home as the boot surface, **sitting on Home
would have starved both** — and the paper book only fills while observed. Caught before the
build was called done. The general coupling was fixed later at M054.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F9.

---

# 2026-08-10

### M024 · A strategy parameter was applied in-flight and disclosed in the summary
2026-08-10 · found by: user ruling · pattern: `CONSENT`

Entry-watch DISCOUNTED was set to ≤ −2% mid-build and mentioned in the summary; it was
ratified after the fact. **Judgment thresholds and verdict boundaries discovered mid-build
are strategy parameters** — propose them and leave them unapplied. Applying one and
mentioning it is a near miss, not compliance.

Substantiated from: CLAUDE.md BINDING, "Disclosure-in-summary is not ratification" (the
incident named in place).

### M023 · F8 — the funnel swallowed a negative residual
2026-08-10 · found by: audit scan · pattern: `SILENT-STATE`

The residual row rendered only when `N − stage kills − funded > 0`. A negative residual
would mean a stage double-counted a kill — **so the one number that could catch a funnel
accounting bug hid itself exactly when it fired.** Now renders an explicit accounting-error
row. It should never appear; that is what makes it a detector.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F8.

### M022 · F7 — `S.depProposalCount` was a stale sensor computed as a render side-effect
2026-08-10 · found by: audit scan · pattern: `COMPOSITION`

Set only inside `renderDeploy` (Watchlist tab) and read by the walk-up's RULINGS PENDING
line on another tab, so it reflected the last visit — including the boot render, which runs
before price data arrives and yields 0. A funnel proposal earned overnight was silent until
the user happened to render the Watchlist. Fixed with a timestamp and honest copy rather
than a recompute: **"as of Nm ago" is a true sentence; a fresh-looking stale number isn't.**

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F7.

### M021 · F6 — the plan and the quote cycle both owned inventory-mode items, and `committed()` could not see quote legs
2026-08-10 · found by: audit scan (money path) · pattern: `COMPOSITION`

`buildPlan`/`candidateFor` contained no reference to `invTarget`, so an inventory-mode item
could be funded as an allocator-sized plan BUY while the quote cycle proposed its own buy
leg for the same item. Worse, `committed()` counted positions only — **gp locked in a
standing quote buy leg was invisible to plan sizing, so the one-third rule and tier pools
could double-spend it.** Ruled both halves: inventory items bench from the plan, and
unfilled quote buy legs count at cost. *Gp standing in an offer is deployed gp* — a
principle later reapplied to attention state (a standing quote is an open book).

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F6; `audits/AUDIT-2026-08-11b.md`
(the reapplication).

### M020 · F5 — the self-cross guard was built one-directional against a universal spec
2026-08-10 · found by: audit scan (money path) · pattern: `COMPOSITION`

`crossWarn` read `standingOrders` → `DB.positions` only, so a reprice on a position could
cross a standing quote BUY leg and a plan leg could cross a standing quote SELL leg, with
no CANCEL-FIRST warning either way. Quotes saw positions; positions did not see quotes.
**The original spec was universal** ("whenever any reprice/undercut action is proposed…
check for my standing opposite-side order") and the build dropped half of it — **and the
spec itself was never rowed in REQUIREMENTS.md, so the ledger detector had nothing to catch
it with.** Row R9.4 closes both gaps.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F5 and its ruling.

### M019 · The meta-finding: 252 green assertions could not see two money-path defects
2026-08-10 · found by: user, for the record · pattern: `TEST-SUITE`

M020 and M021 are composition defects between two individually-correct subsystems
(positions-world and quotes-world), invisible to parts-level probes because each side
passes its own tests. **Parts-level verification and composition-level audit are different
detectors; a green suite is not a clean bill.** This is the finding that establishes the
integration audit as a standing discipline rather than an occasional exercise.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, meta-finding and verdict.

### M018 · F1–F4 — four connectivity defects, two of them born in that day's build
2026-08-10 · found by: audit scan (orphan/redundancy, first run) · pattern: `ORPHAN`

**F1** `estWindow` write-only: a `long-catalyst`'s estimate-window flag was stamped and
read by nobody, so an estimated window presented with dated confidence. **F2**
`flagArchive`'s `storyType`/`storyConf`/`retracePct` written and never consulted, while the
lag note said "signature matches…". **F3** a ratified watch-note never reached its flag's
row, so the row still asked for an escalation that had already happened. **F4** two
daily-series caches over one endpoint. The user's note on F3 is the durable part: this is
the clusters-class defect (a surface not wired to the workflow), **caught by audit in one
day instead of by the user's irritation in four.**

Substantiated from: `audits/AUDIT-2026-08-10.md`, findings and rulings.

### M017 · The seasoning gate was specified and never built under any name
2026-08-10 · found by: history search while implementing · pattern: `LEDGER-ONE-WAY`

The spec'd gate — "fundable only after 3 consecutive full-gate passes spanning ≥2h,
first-time passers shown as qualifying N/3" — did not exist; the closest artifact was
`w.lastPass`, which only feeds scout eviction. **A spec claiming an implementation that is
not there, with nothing checking the direction.** Recovered and built as ordered. The same
shape reappeared with the arrow reversed at M110, and that pair is what produced
`reqpair.sh`.

Substantiated from: commit `85cd734` body ("dropped spec, recovered"); REQUIREMENTS.md R6.2
("that is the seasoning-gate shape").

### M016 · `candidateFor` recorded only the first gate failure
2026-08-10 · found by: building marginal-gate attribution · pattern: `SILENT-STATE`

The else-if chain kept only `fails[0]`, so "which gates does each benched item fail" — the
question marginal-gate attribution needs — **was unanswerable from the data.** Every gate is
now evaluated independently into `fails[]`; the headline bench reason is unchanged, and the
gate-health ledger deliberately keeps first-fail semantics because its audit buckets are
defined against the reason the user actually saw.

Substantiated from: commit `85cd734` body.

---

# 2026-08-09 to 2026-08-10 (friction session)

### M015 · A repriced leg kept its old price and old clock, so the same advice fired forever
2026-08-10 · found by: use · pattern: `SILENT-STATE`

The aging ladder instructed a cancel-and-relist with nowhere to record it. Every walk-up
then repeated the same instruction against a leg that had already been actioned. Recording
a reprice now restarts the leg clock, **because a relisted offer is a new offer.**

Substantiated from: FRICTION.md, 2026-08-11 00:17 entry; commit `b9c8add` body.

### M014 · The volume gate rode the /5m extrapolation and flapped between refreshes
2026-08-10 · found by: use · pattern: `CLAIMS-VS-CODE`

A `✗ GATE` tag appeared on divine battlemage potion while the plan was recommending the
buy, and elsewhere a buy was suggested for an item the scanner said was excluded. Root
cause: one fill in a quiet window extrapolates to "12/h", so the gate flapped and two
surfaces disagreed about the same item **because they were reading the same noisy input at
different instants.** Fixed by ruling: the 5m sample binds only at ≥5 units AND 2
consecutive below-floor refreshes, with its status labelled everywhere (noise / n-of-2 / 5m
pending). Placed rows now also announce when an item stops passing rather than going silent.

Substantiated from: FRICTION.md, 2026-08-10 09:50 and 09:51 entries; commits `1758e55`,
`952d7a2`.

### M013 · Four smaller friction defects from the same session
2026-08-10 · found by: use · pattern: `COMPOSITION`

A partial buy had no correction path and a wrong quantity was knowingly carried to a sell
listing (both fixed by **fix qty…**); the export NOW tooltip could not be dismissed; promote
demanded a demotion despite 7 open slots; and already-dismissed thesis candidates were
re-suggested as re-detected variants. Grouped because each is a single missing affordance
rather than a distinct root.

Substantiated from: FRICTION.md, Resolved — 2026-08-10; commits `3273f29`, `e6635d8`,
`e5fbaa4`.

---

# 2026-08-08 (inbound critical review of the original build)

These twelve were found by a single inspection review of `index.html` before any of the
verification machinery existed. They are listed because several are the **earliest
instances of roots that were not written down as rules until days later** — which is
exactly what §2b of the graduation audit is looking for. Only 1.1 was confirmed live at
the time of writing; the rest were read from the code. All were implemented by 8 Aug 2026.

### M012 · `gp()` deleted significant digits on nine-figure numbers — **verified live**
2026-08-08 · found by: inspection · pattern: `CLAIMS-VS-CODE`

`.replace(/\.?0+$/,"")` strips trailing zeros even with no decimal point:
`100,000,000 → "1m"`, `250,000,000 → "25m"`, `790,000,000 → "79m"`. It bit only values
≥100m whose millions digits end in zero, which is why `792m` looked fine and the bug
survived — **and the one place a nine-figure number is read is the Shadow Fund tab**, so
the live price, "still needed" and every gear target were understating by up to 10×.

Substantiated from: IMPROVEMENTS.md §1.1 (measured outputs quoted in place).

### M011 · Bank + realized profit double-counted the stack, and the error grew with the log
2026-08-08 · found by: inspection · pattern: `POOLING`

`stack() = DB.bank + realized()`, where the bank figure is read off the in-game bank, which
already contains every logged flip's profit. Two populations added as though disjoint.
`stack()` drives the one-third clamp, so **positions were sized too large**, and the error
was self-worsening.

Substantiated from: IMPROVEMENTS.md §1.2.

### M010 · The liquidity gate summed both sides of the book
2026-08-08 · found by: inspection · pattern: `POOLING`

`c.vol = highPriceVolume + lowPriceVolume`. To buy you need people selling into your offer
— one side, not the sum. The `volume ≥ 4× plan qty` gate and the scanner's volume floor
overstated available liquidity by roughly 2× on a balanced item and much worse on a
lopsided one. **The wrong-side-of-the-book root recurs at M099 Fault B** (total flow used
where reaching flow is meant) four days later.

Substantiated from: IMPROVEMENTS.md §1.3.

### M009 · Margin was computed from two unrelated instants
2026-08-08 · found by: inspection · pattern: `POOLING`

`/latest` gives the last high trade and the last low trade, which may be hours apart and
may each be a one-off, so a "margin" built from them can be an artifact that never existed
as a simultaneous spread. Named at the time as the mechanism behind most `check me` rows.

Substantiated from: IMPROVEMENTS.md §1.4.

### M008 · Tax exemptions matched by name and failed silently — and had already broken once
2026-08-08 · found by: inspection · pattern: `SILENT-STATE`

`EXEMPT_SET` keys on exact lowercased `/mapping` names. Seven teleport tablets carrying a
`(tablet)` suffix were taxed when they should not have been, and **nothing in the app would
have said so** — margins were just quietly 2% low. A wiki rename re-breaks it at any time.
Fixed with a count assertion and a visible banner, which is the first detector in the
project's history.

Substantiated from: IMPROVEMENTS.md §1.5.

### M007 · The sparkline silently mixed two different series
2026-08-08 · found by: inspection · pattern: `POOLING`

`p.avgHighPrice ?? p.avgLowPrice` — when an hour has no high trades it substitutes the low
price, injecting a fake drop of exactly the spread width, and that series feeds the trend
gate. **Three days before "never pool" was ruled, and the same property.**

Substantiated from: IMPROVEMENTS.md §1.7.

### M006 · `trendPct` was endpoint-to-endpoint
2026-08-08 · found by: inspection · pattern: `CLAIMS-VS-CODE`

`(last − first) / first` over 7 days: an item that crashed 20% and recovered reads as a flat
chart, and a single bad final point flips the gate. **The gate meant to keep you off knives
was the shallowest calculation in the file.**

Substantiated from: IMPROVEMENTS.md §1.6.

### M005 · Shadow price staleness was invisible behind a global freshness claim
2026-08-08 · found by: inspection · pattern: `STALENESS`

Tumeken's Shadow trades ~27/hour, so its `/latest` entry can be hours old while the header
says "prices 12s ago" — true of the *fetch*, not of *that item*. The denominator of the
headline progress bar could be badly stale with no indication.

Substantiated from: IMPROVEMENTS.md §1.8.

### M004 · Two different clocks presented as one
2026-08-08 · found by: inspection · pattern: `STALENESS`

`/1h` volume can be 60 minutes old while the freshness filter is also 60 minutes, so an
item passes "data age ≤ 60 min" on price while its volume is an hour old and the market has
since died.

Substantiated from: IMPROVEMENTS.md §1.9.

### M003 · "No chart yet" conflated *loading* with *no data exists*
2026-08-08 · found by: inspection · pattern: `SILENT-STATE`

Items with no timeseries were benched forever with a message implying they would resolve on
their own. **This is the never-fed-aggregate root (M072) on Aug 8**, four days before it was
ruled: a component reporting nothing where it should report that it *has* nothing.

Substantiated from: IMPROVEMENTS.md §1.10.

### M002 · The checklist date rolled only when the Routine tab rendered
2026-08-08 · found by: inspection · pattern: `COMPOSITION`

`DB.checks.date !== today()` was checked inside `renderRoutine`, so leaving the app open
overnight on another tab kept yesterday's ticks. **State coupled to a render path** — the
same root as F9 (M025) and the accrual coupling (M054), three days earlier.

Substantiated from: IMPROVEMENTS.md §1.11.

### M001 · The flip log stored the item name at log time
2026-08-08 · found by: inspection · pattern: `COMPOSITION`

Renamed items produce two rows in the per-item table. Cosmetic; `itemId` is what is used
for tax. Recorded for completeness.

Substantiated from: IMPROVEMENTS.md §1.12.
