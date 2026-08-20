# Integration audit + scan 14's first run — 2026-08-18 (steps D and E)

Run at the cutover gate's ordered position: after step A gave the new surfaces something
to walk, before the freeze. **Overdue independently of the cutover** — the last integration
audit was `AUDIT-2026-08-13b` and five build sessions have landed since.

**Suite at close: `PROBE-PASS — 1,181 assertions, BOTH viewports, pairing clean both
directions (430 tags / 442 rows / 430 cited)`.**

---

## Part D · The integration audit

### Findings — six, all in this session's own build, all fixed

That every finding is mine is the expected result and not a comfort: this session added four
stores, two flags, three ledger stamps and a plan surface, and the audit's job is to catch
what a build that size leaves behind.

| # | scan | finding | fix |
|---|---|---|---|
| **D-F1** | 2 (orphan) | **`DB.poolSeenEvict` was write-only.** Persisted at eviction, read nowhere. An evicted item loses its observation window and reads as a first-cycle item again — precisely the thing a reader needs told rather than left to infer | renders in the persistence drill's head, only when non-zero |
| **D-F2** | 2 (orphan) | **`DB.qualEvict`'s only consumer was its own writer.** The running total fed the warn at the moment of writing and nothing else; after a reload the counter survived and nothing surfaced it — and it is the explanation for an item re-seasoning unexpectedly weeks later | renders beside the provenance census, only when non-zero |
| **D-F3** | 4 (glossary) | **`plan-persist` was rendered by `glTerm` four times with NO glossary entry.** A direct violation of the same-commit rule, invisible to `[R38.2]` because that assertion only checks *gate names* | entry added, all three fields, with the pair-not-percentage rule and the six-gate caveat in it |
| **D-F4** | 2 (surfaces nothing feeds) | **`sc-rdiff-class` and `sc-rdiff-run` were glossary entries nothing rendered** — the reverse of D-F3, and unreachable vocabulary | both marked up with `glTerm` on the drill's column headers |
| **E-F1** | 14 | see Part E | |
| **E-F2** | 14 | see Part E | |

### Scans run, and what each covered

- **1 · Workflow walks** — the plan walk was re-traced end to end after step A: `planCandidates` → `candidateFor` → `buildPlan` → `renderPlan`'s two groups → the bench block's inert line and persistence drill. Every new surface answers what feeds it (the control cell's pass set, via `poolSeenAccrue`), what it feeds (the badge and its drill; nothing gates on it), and when it earns its render (only when the item has pool history; `not-scored` renders an empty slot with a reason).
- **2 · Orphan and silent state** — every store and field this session created was walked for writer, reader and decision-changed. **Four had all three; two did not** (D-F1, D-F2). Silent-state: the four no-history states, the era closure, the three chart-coverage states and the `NOT COUNTED` streak are each a named state rather than a zero. **`rdiff` is no longer STAGED** — its reader shipped, and scan 2 stops re-reporting it.
- **3 · Redundancy** — checked the obvious risk, that `opsOf`/`opsPick` and `calc`'s old inline watch-row read would both exist. They do not: `calc` routes through `opsOf`, one reader. `poolDot` and `shadowDot` are two dots answering two different questions on two different surfaces, not a duplication.
- **4 · Glossary coverage** — D-F3 and D-F4.
- **5 · Interrogability** — every new aggregate opens to rows: the persistence pair to the drill, the rdiff counts to their classified rows, the inert line to the population it counts. **One declared limit, stated rather than hidden:** the persistence drill opens to what exists — the session's per-item history beside the durable pair — and names the T0 replay path for per-cycle rows, because the durable store keeps counts, not rows, for the same reason `scorerT2.ids` does.
- **6 · Restraint-lift** — enumerated every path by which a restraint stops applying in the new code. Four: qual-store staleness prune, qual cap eviction, `itemOps` staleness prune, `itemOps` cap. **All four warn**, none is silent, and all four are storage bounds whose comments say in as many words that the thing they bound does not expire. **One deliberate lift with no press, and it is the conservative direction:** a tier override under different bands stops applying — that *narrows* what the allocator may fund, and narrowing may auto-arm.
- **7 · Claims vs computation** — read every new rendered figure against its code. `#planSub` now computes what it says; the funnel tile's `pass` names its pool and the other two figures deliberately do not, because their denominators are not the pool; the streak label stopped claiming a counter that was not running; the accruing chart-gate copy names all four consumers.
- **8 · Pooling** — the new populations are stamped at birth in five places: `qual.src`, `gateLog.src`, `deployLog.poolRegime` + `n`, `dieOffLog.pop`, `poolSeen.ch`/`v`. **`mixed` on `deployLog` is the honest value** at that grain rather than a false per-candidate precision.
- **9 · Clamp absorption** — the new asserted subjects sit behind no clamp. The one place a clamp could absorb — `planQty`'s cap over the manual qty — is asserted at `opsPick`, upstream of it.
- **10 · Seam inventory** — the seams this session created, each with the walk that crosses it: `planCandidates → updateQualStreaks` (provenance stamp, `[R87.3]`); `scorerCycle → poolSeenAccrue` (persistence, `[R92.1]`); `buildPlan → stampDeployLog` (regime stamp, `[R90.2]`); `calc → opsOf` (read-through, `[R93.2]`); `t0 archive → chartCache → marketStatsFor` (four consumers, `[R94.2]`).
- **11 · Information horizon** — no new simulated result. `poolSeen`'s `c0` is taken *before* the cycle increments, so an item's first cycle reads `obs 1`, not `obs 0`.
- **12 · Overlapping property** — no new BINDING entries this session, so nothing to compare.
- **13 · Reachable fixture** — the new assertions call production terms with constructed arguments; each term has a named production call site (`opsPick` ← `opsOf`; `opsTierOv` ← `opsOf`; `chartWireState` ← `chartCacheLoad`; `momentumState` ← `momentum` and `marketStatsFor`; `qualRetain` ← `updateQualStreaks`; `poolControlsHTML` ← the pick row). **Two of these terms exist BECAUSE this scan's rule was violated first** — see Part E's note on re-derivation.
- **16 · Interaction surface** — nothing new is chain-shaped.

---

## Part E · Scan 14, first run

Written into the constitution on 2026-08-13 and **never executed until now**.

### The mechanical half

**385 candidate labels of 1,181** carry a strong-claim word, against the constitution's
estimate of 100–200 for a 958-label suite. The rate is higher because this session's own
labels are dense with universals.

| class | hits |
|---|---|
| universal (`never`, `always`, `only`, `every`, `any`, `cannot`, `must not`) | 301 |
| negated mechanism (`uncapped`, `unclamped`, `not through`, `rather than`, `instead of`, `without`) | 62 |
| sufficiency (`exactly`, `alone`, `regardless`) | 33 |
| source claim (`at the source`, `directly`, `itself`, `the term`) | 22 |
| **union** | **385** |

**The read is the work and 385 is more than this pass read.** Prioritised by the founding
examples' shapes: the 16 labels carrying **both** a universal and a negated mechanism (the
`probe:116` shape), all 22 source claims (the `probe:111` shape), and `[R4.3]`.

### `[R4.3]` — the founding example is already clean

Scan 14's own founding finding was *"a universal exercised against one instance"* —
`[R4.3]`, *"intel cannot touch blacklist / reserve / gate constants"*, tested against the
single record type with no write path at all.

**It was repaired on 2026-08-13 by an adversarial pass, and the repair is exactly what this
scan would have prescribed.** It is now four assertions, and one of them reads *"EVERY
activation left the sacred set untouched — not just the one branch that cannot write"*,
asserting both that no activation moved the sacred set **and** that the fixture exercised
all five writing branches — so a new branch with no fixture goes red and names the gap.

**Consequence for step F: `[R4.3]` comes off the adversarial pass's must-re-verify list.**
That was the stated reason for ordering E before F, and the ordering paid.

### E-F1 and E-F2 — two findings that were masking each other

**E-F1: `[R33.1]`'s universal outran its fixture.** The label claims *"a cold, near-empty
store renders **every** review surface and **all four** tabs"*. The tabs claim was true. The
sub-view loop walked **six of seven** — `scorer`, the newest and most complex sub-view,
added 2026-08-14, was never added to it.

**E-F2: the cold-start fixture was not cold.** Its clear list covers 30 array stores and 11
object stores and had **not kept pace with the stores the product added**: `scorerT2`
(Aug 14), `poolSeen` and `itemOps` (today) were all absent. So "a cold, near-empty store"
was false for exactly the newest and least-exercised machinery.

**They masked each other, which is the eighth face and is the part worth recording.** Adding
the sub-view alone did not bite — a seeded cold-store crash in `renderScorerView` changed
nothing, because the store was not cold. Clearing the store alone would not have mattered —
the sub-view was not walked. **The seed that proved nothing is what exposed the second
defect**: an unconditional throw aborted the run, proving the code reachable, which meant
the conditional seed had been dead rather than the assertion weak.

Both fixed; **re-seeded after both, and the seed now bites naming `trade/scorer` exactly.**
The Scorer renders clean on a genuinely cold store — so the widening closed a real coverage
gap and found no live defect, which is the honest result and is stated as such.

### A note this pass earned: re-derivation is a habit, not an event

Three assertions this session were written against a **probe-side re-implementation** of a
flag-gated property, and in two cases the seed could not bite until the term was extracted
(`opsPick`, `opsTierOv`). A third case — a `document.body` match — recurred **three times**,
finding the app's own inline `<script>` source and another assertion's label text.

**Both are named faces of the case law and both still happened, repeatedly, in one session.**
The tell in each case was the same: the property was awkward to reach, so I reached around
it. The rule that would have prevented all five: **when a property is hard to assert
directly, extract it — never re-derive it, and never widen the container to find it.**

---

## What was NOT done, stated plainly

- **369 of the 385 scan-14 candidates were not read.** The enumeration is the deliverable and
  the unread remainder is named rather than implied. It shrinks as they are cleared.
- **The real-network deployment artifact is still owed** (M154's discipline). Two attempts
  failed in-session: a `--screenshot` boot never terminated (the app never goes idle), and a
  beacon-instrumented real-network boot produced no beacon inside 90 s. **A stand-in was not
  substituted.** It is the first thing to verify on the next app open, and step A is a
  surface that is read, so it matters.
