# The re-pass queue, closed — hour weight, the consumer-anchor rule, and 23 findings

**2026-08-19. Tree uncommitted. Suite: `PROBE-PASS — 1,234 assertions, BOTH viewports, pairing
clean both directions (462 tags / 474 rows / 462 cited)`.** Baseline at the start of this pass was
**1,207**. **27 new assertions, 33 discriminating seeds (S90–S122), one at a time, restore-green
between.**

---

## 0. AN INCIDENT FIRST — three uncommitted MISTAKES entries were destroyed and two restored

A `perl` one-liner mixed a UTF-8-decoded insert with a byte-read host file and double-encoded every
multi-byte character in `MISTAKES.md`. The repair reflex was `git checkout -- MISTAKES.md`. **The
tree is deliberately uncommitted by standing ruling, so `HEAD` is not a backup**, and the checkout
discarded **M156, M157 and M158** along with the damage — 6,955 bytes, this week's evidence layer.
Nothing else in the file had changed.

- **M157 and M158 are restored VERBATIM** — both had been read in full earlier in the same session,
  so the text came back from the session's own transcript, unchanged.
- **M156 is RECONSTRUCTED and marked as such in place**, from the sweep section that found it, the
  requirement row that cites it, and the shipped glossary entry it produced. **Its original wording
  is not recoverable.** Every fact in it is cited; the file's own convention (an inferred entry says
  so rather than being reported as found) is what it now stands on.
- Recorded as **M160**, tagged `DESTRUCTIVE-UNDO`, and the rule is in CLAUDE.md's repo-hygiene
  section: **in a repo whose working tree is the deliverable, `git checkout --` / `git restore` /
  `git stash` are destructive commands, not undo** — copy the file aside first, because there is no
  second copy. Second half: a scripted edit to a UTF-8 file is made in ONE encoding domain, and one
  `grep -c 'Â'` immediately after catches the other case while the fix is still one line.

---

## 1. hourWeight — RULED AND BUILT, with the ordering measured on live data

### 1.1 What shipped

| | |
|---|---|
| **Routed** | `hourWeight(ser)` reads the resolved series. It was the last chart-derived reading on the chain still reading the raw spark, which is exactly how `itemSeries`' `byHour` field ended up an orphan with no reader. |
| **Third state** | `{ w, fed, why }`. `w: 1` from a UNIFORM profile (measured, and flat) and `w: 1` from NO profile are now distinguishable. |
| **Resolver names both sources** | `src` answers for the price/volume series; `byHourSrc` answers for the hour profile. The archive branch was **silently discarding a spark's profile** while returning `src: "archive"` — one field answering for two sources. |
| **Era fact pinned** | `[R100.4]`: with the archive READY and no spark, `byHourSrc === "none"`. Building a profile out of the archive's hour-stamped bucket keys is buildable and is a separate deployment-class ruling; **it must turn this red before it lands.** |
| **Siblings answer the same question** | `stabilityWeight` gained `fed`, so `w: 1` from absence and `w: 1` from a measured-neutral ratio are distinguishable there too. |
| **`histFed(hw, stw, rel)`** | The fed set, computed in ONE place so a fifth weight cannot be added without answering the question. It computes **no arithmetic** — the score expression keeps its exact operand order, because reassociating a float product to tidy it is a change to the numbers (re-pass finding 29). |
| **The hold-out** | A tenured candidate whose SERIES-derived weights are unfed is not placed in the score-ranked order. It renders below the ranked block, sorted on the same unweighted core the pool uses, under a line that says why. |

### 1.2 The ordering change, measured

Measured against the real watchlist (43 items from the state backup) with live `/timeseries`
responses fetched for each, running the app's own `byHour` construction and `hourWeight`:

```
hour weight FED   : 43 of 43
hour weight UNFED : 0
fed w at hour 05  : min 0.765 · p25 1.002 · median 1.049 · p75 1.093 · max 1.247
                    10 below 1.0 · 33 above · 0 pinned at a clamp edge
within 0.005 of exactly 1.000: 3 of 43
```

**The ordering change on today's data is NIL — 0 of 43 items are held.** Both series-derived weights
are fed for the entire live book. The restraint is entirely for the post-transition population and
for a `/timeseries` breaker outage. **That the number is zero is what let it be armed** without a
second ruling.

The measurement also states the size of the defect it closes: a `1.0` from absence lands at the
**p25 of the fed distribution** — not an edge case that sorts harmlessly to one end, but squarely
mid-field, on no evidence.

### 1.3 The scope question the measurement opened, and how it was settled

The same measurement, run for the sibling weights:

| weight | fed on the live book | absence value | where absence lands |
|---|---|---|---|
| hour | **43 of 43** | 1.0 | middle of 0.765–1.247 |
| stability | **43 of 43** | 1.0 | second of four values |
| reliability | **3 of 43** | 1.0 | middle of 0.7–1.3 |
| wins boost | n/a | 1.0 | **the FLOOR** of 1.0–1.5 |

A hold-out keyed on *any* unfed history weight would have held **40 of 43** items out of their own
ranking, which is a deletion of the ranking rather than a restraint on it. The scope is therefore
**series-derived weights only**, and the line is not drawn by population size but by what the
absence MEANS:

- **SERIES-derived (hour, stability)** are absent only when the DATA PIPELINE has not fed them — a
  failed fetch, a tripped breaker, an accruing archive. That is a **tool state**: temporary, nothing
  to do with the item, and ranking on it is ranking on nothing.
- **LOG-derived (reliability, wins)** are absent when **you have not traded the item**. That is a
  **fact about the book**, and it is the normal state of every new candidate — holding those out
  would hold out exactly what the plan exists to surface.

`wins` is in neither set and deliberately so: absence gives its FLOOR rather than its middle, which
is the conservative reading rather than a fabricated average.

**Flagged, not ruled:** `reliability` renders `why: null` when `n === 0` and *"thin history (2/4
trips in 30d) — reliability weight off"* when `n` is 1–3. So **partial** absence is disclosed on the
row and **total** absence is silent, which is the inverse of what you would want, and it affects 30
of 43 rows today. Fixing it means adding a string to 30 of 43 plan lines — a material change to a
daily surface — so it is reported rather than shipped.

---

## 2. CASE LAW — assert at the consumer, not the plumbing

**Three instances in two consecutive adversarial passes, one root:** *the property was awkward to
reach, so I reached around it.*

- `[R89.1]` claimed the pool path was exercised; `CUTOVER_POOL` was a const read inside the
  function, so the armed branch was dead code and the assertion tested the term the flag guards.
- `[R94.2]` tested `chartReady`/`chartPts`/`chartVols` — the plumbing — while the ruling was about
  four CONSUMERS, one of which was never wired at all.
- `[R99.3]` tested `seriesReadiness` after the mask was re-keyed onto it. **Reverting the mask left
  the suite green.**

**BINDING in CLAUDE.md**, on both limbs of the promotion bar at once (three instances *and* a
detector): *an assertion's subject is the BRANCH THAT READS a term, not the term itself.*

**The load-bearing half is the qualification**, because this project's own rule set walks into the
trap: the standing remedy for the seventh face — *extract the logic into a named function and point
the assertion at that* — PRODUCES this defect when it stops there. **Extraction fixes reachability;
reachability is not coverage. An extraction owes TWO assertions — the term for its arithmetic, the
branch for its wiring** — and only the second can go red when the wiring is reverted.

**Detector: integration-audit scan 15**, the consumer-anchor scan. Slot 15 was empty since the
Aug 13 renumbering and nothing anywhere cited a scan 15, so this **fills the hole rather than
renumbering 16 and 17** — no existing citation moves. It is adjacent to scan 13 and not the same
check: scan 13 asks whether a production caller could produce the probe's ARGUMENTS and clears a
term the product really does call; scan 15 asks whether any assertion's subject is the BRANCH.
`[R99.3]` passed 13 and failed 15.

**Filed as `PROXY-ASSERT`**, a new pattern tag following the `CLAMP` precedent exactly — a face of
`TEST-SUITE` **and** a law in its own right, counted once inside `TEST-SUITE`'s total and reported
separately. M157 (already inside `TEST-SUITE`) and M158 (moved out of `CLAIMS-VS-CODE`, which goes
13 → 12) were **retagged rather than split**, with the arithmetic stated in the census and a note in
each entry so the history stays legible.

**Two of this session's own repairs needed a design change before they could be asserted at all** —
which is M157's remedy rather than its repeat. `scoutEvictable(w, ctx)` was extracted out of an
async, timer-driven filter lambda; `opsOf(id, armed)` took a defaulted parameter so the branch
behind the const is reachable. Both production call sites are unchanged.

---

## 3. The queue — 23 findings, closed

**Verdict census:** 30 findings, 27 confirmed, 1 refuted (24), 1 uncertain (11), 1 no-verdict (22).
The 7 money-path findings were closed in the previous pass. This pass closes the remaining 23.

### Production repairs

| # | what | evidence |
|---|---|---|
| **8** | `[R94.1]`'s `\|\|` short-circuited on its first limb, so *"unknown is not a pass"* — the label's headline claim — was never evaluated. Now a conjunction over the whitespace-normalised string, **and the contradicting claim is forbidden** (eleventh face) | S103 |
| **9** | `planInertLine` and `PLAN_POOL_HEADER` pinned copy that becomes FALSE at the chart transition — an **anti-tripwire** pointing the opposite way from `[R76.9]`. Every clause now follows a READING; the header's DESIGN claim (*not applied*) is constant and its DATA claim (*not fed*) is computed. **Both assertions went red on the fix**, which is the evidence the standing rule asks for | S113, S114 |
| **10** | `chartedNow()` defined *charted* as SPARK PRESENCE while the chain had moved to the resolver — two live definitions of one predicate, disagreeing exactly where the archive answers, with the eviction guard declining to act on a stated precondition that had become false | S99 |
| **11 + 17** | The `no history` bench read the spark's `noData` flag alone, so it could tell the operator no price history is published for an item the same chain had just read 168 archive buckets for — as the HEADLINE bench reason. Now benches only when NEITHER source has anything. **This settles finding 11's UNCERTAIN** with exactly the fixture its verifier named | S97 |
| **15** | `opsPick`'s `!= null` could not express a CLEARED override: writing `null` fell through to the watch row and resurrected the value the operator had just deleted, which **WIDENS what the allocator may fund**. Three states, with the partition answer in writing | S100 |
| **19** | Five display readers still on the raw spark, so an archive-fed row showed no FALLING chip and a dimmed *"…"* that reads as still-loading while the chain benched that row *"falling chart"*. `hourVerdict`'s readers deliberately NOT routed — `byHour` has no archive equivalent, so their *—* is honest | S98 |
| **26** | The gate-name enumeration was enforced at the import writer and not at the GRANT writer, so a stale or hand-edited paper book could nominate any gate — including the constitutional veto — into a lane whose grants delete a bench | S101 |
| **27** | `opsOf`'s `bands` row fallback was dead (nothing writes `w.tierOvBands`) and read as the thing making a migrated override's band stamp look optional. Deleted, with the reason stated | — |
| **28** | The dead `if (exc && isBlk(x.id)) continue;` **KEPT**, stated as unreachable defence-in-depth. It guards the one constitutional veto in the product; deleting a guard on the user's own veto to tidy a dead branch is the wrong side of that trade. No assertion written — nothing in production can reach it, and manufacturing the state would be the twelfth face | — |
| **29** | `horizonUnitsFor`'s operand order recorded as **normative**, so the next extraction is checked against a stated form rather than three inline memories | — |
| **30** | `GATE_CHAIN_ORDER` changed job — from a DISPLAY ordering where an unlisted name sorted last, to the **whitelist** the import validator and now the grant writer use to DROP an exception — with nothing pinning the correspondence. `chk` records a miss on `S.gateNameOff`; `gateNameOffWarn` renders it on every plan build; the suite asserts empty. Recorded rather than thrown: a chain name is a developer fact, and the answer is a visible warning and a red assertion, not a broken plan | S102 |

### Probe fixture and label repairs

| # | what | evidence |
|---|---|---|
| **12** | The proven-loser bench's ENTRY condition had no assertion — only its firing and its release. Both limbs now: three PROFITABLE flips do not bench, two losing ones do not either | S104 |
| **13** | `[R98.5]` claimed the fixture cleans both ends; four persisted stores `buildPlan()` writes were never snapshotted, **`DB.gateLog` being the one whose reader moves gate constants**. All five captured and restored, caches restored by value, and `DB.gateLog` asserted by CONTENT | S109 |
| **14** | `[R89.2]`'s `hasOwnProperty("failed")` conjunct could not fail (`candidateFor` sets `failed` on every return including the no-price early return), and its fixture ids had no price data, so **the assertion never reached a single line its label names**. Real prices added; the tautology replaced with the properties only a bare synthesised row can produce | S105 |
| **21** | `[R91.1]`'s behavioural pair proved agreement at ONE point, which a second interpreter with a shifted constant satisfies. Swept across **all four state boundaries** — the knife line from both sides, the chase line from both sides, the direction sign at a fixed q, the flat-range guard at exactly its threshold, and the five-point minimum | S112 |
| **22** | `[R97.2]` claimed a by-value restore and did a blind key-delete, and checked **three of eight** cache cells. Set-or-delete, all four caches × both ids | S108 |
| **23** | §95 captured `latest`/`hour` and tore down with a key-delete two lines later — **the capture was dead code and the author's intent was contradicted by the next statement**. `spark` was not captured at all. All four restored set-or-delete, with `[R95.5]` as the teardown detector its two neighbours already had | S107 |
| **24** | REFUTED by its verifier (the third conjunct independently asserts chk-chain position, and the differential pair makes the attribution sound). The proposal applied anyway as a strengthening: `clean95.length === 0` converts *the gate fires* into *the gate is what withholds funding from an otherwise-fundable item* | — |
| **25** | §87/§89 drove `S.scorerCtlPass` to a synthetic three-item list and never restored it, so **every later block ran against a fabricated pool** — the M152 leak, on the one session field the cutover switch reads. `[R89.3]` asserts the restore | S106 |
| **20** | Already fixed in the previous pass (`committed()` takes no arguments) | — |
| **16** | Already fixed in the previous pass (drift threshold restored to ratio ≤ 2, with the discriminating case) | — |
| **18** | **DEFERRED by the finding's own proposal** — a pruned migrated item-ops row resurrects from the watch row while the prune's warning tells the operator to re-set it. Raised as a delta for the stage that flips `ITEM_OPS`, where it needs an assertion at the composition | — |

### The owed allocator assertions

- **`[R7.3]`'s one-slot limb — WRITTEN.** Two items in one caution category and different families:
  one funds, the other holds with the category and the slot count named. A third item outside every
  category funds alongside, so the assertion cannot be satisfied by a plan that merely funds one
  thing. `GATE.seedSlots === 1` is pinned in the same condition. **The row's citation is corrected
  now that the assertion exists** — `one-slot limb: OWED, no probe` is gone.
- **`[R98.6]` — the TIER-2 CONCURRENCY CAP.** Three live T2 positions hold a fourth T2 candidate.
  Nothing exercised it: every allocator fixture ran with `DB.positions` empty, so `t2Live` was
  always 0 and the comparison could never bind — the same shape as R98.3 and R98.4, on the ramp
  rule's other half.

### Also fixed, found by running rather than by the pass

- **`[R40.4]` failed at 05:00 on a clean tree** — it asserted that six hours before *now* is the same
  calendar day as *now*, which is false for every run started between midnight and 06:00 local. The
  fifth face, shipping for as long as the assertion has existed, invisible because the suite is
  usually run in working hours. Anchored at local noon: the ruled repair is to **inject** the varying
  input, never to pin the ambient clock. **M161.**

---

## 4. Two of this session's own defects, recorded

- **M162 — I wrote the same short-circuit defect I was in the middle of fixing.** `[R101.5]` shipped
  as `(evReal === null || evReal.gate === "ROI floor") && …`. The positive case did not occur: the
  fixture's trips carried no `obsMs`, so every one was `thin` and `exceptionEvidence` returned null.
  The assertion proved two refusals while its label said a real gate is KEPT. **A disjunct in an
  assertion condition is a claim that BOTH branches are acceptable outcomes** — where one branch
  means *the case did not occur*, it is a hole, and a pass cannot be read for which limb satisfied
  it.
- **M163 — a fixture kept an empty-but-present spark, so two definitions of "charted" agreed.**
  Reverting `chartedNow` to spark presence left the suite green: a spark OBJECT existed, so the old
  and new definitions agreed on that fixture. **Where an assertion's subject is a DISAGREEMENT
  between two definitions, the fixture must sit where they disagree.** Found only by the seed.

Both were caught in-session. They are recorded because of when: knowing a defect class in detail,
and having just written the rule for it, did not prevent reproducing it within the hour.

---

## 5. Conformance stanza

### BINDING rules touched, with the mechanical check

| rule | check |
|---|---|
| *An assertion's subject is the branch that reads a term* | **NEW BINDING**, scan 15 shipped in the same commit; `[R99.3]`, `[R101.3]`, `[R101.4]`, `[R100.1]` are all consumer-anchored, each seeded |
| *A component reports nothing where it should report that it HAS nothing* | `hourWeight.fed`, `stabilityWeight.fed`, `planInertLine`'s per-reading clauses, `planPoolFedLine`, the held block's absence — seeds S90, S95, S113, S114 |
| *Data nothing reads is a defect* | `itemSeries.byHour` acquired its reader (scan 2(a) orphan closed); `opsOf`'s dead `bands` fallback deleted; `S.gateNameOff` has a writer, a production reader and an assertion |
| *A flag means ONE thing everywhere; a second concern gets a second field* | `byHourSrc` split from `src` — `[R100.5]`, seed S94 |
| *Every automated decision states its reason inline where the user reads it* | the held block's header names the weights actually unfed — `[R100.6]`, seed S95 |
| *Restraint may auto-arm; deployment never* | the hold-out is restraint (it narrows a ranking, funds nothing); `opsPick`'s cleared state closes a WIDENING path; the `no history` repair is a loosening and says so |
| *Metric honesty / copy claims exactly what it computes* | finding 8's conjunction, finding 9's era-aware copy, `[R89.2]`'s and `[R7.3]`'s label corrections |
| *A long-lived client detects its own staleness* | era fact `[R100.4]` armed against the archive-feeds-byHour transition |
| *Every new probe assertion is proven by seeding* | **20 seeds, S90–S114, one at a time, restore-green between** |

### Seeds — every new assertion proven to bite

| seed | first-order red | propagation |
|---|---|---|
| S90 | `[R100.1]` | R100.2, R100.4, R100.6 |
| S91 | `[R100.2]` | R100.6 |
| S92 | `[R100.3]` | R100.1, R100.2, R100.6 |
| S93 | `[R100.4]` | — |
| S94 | `[R100.5]` | — |
| S95 | `[R100.6]` | — |
| S96 | `[R40.4]` | — |
| S97 | `[R101.1]` | R101.2 |
| S98 | `[R101.2]` | — |
| S99 | `[R101.3]` | — |
| S100 | `[R101.4]` | — |
| S101 | `[R101.5]` | — |
| S102 | `[R101.6]` | — |
| S103 | `[R94.1]` | — |
| S104 | `[R95.2]` (entry condition) | — |
| S105 | `[R89.2]` | — |
| S106 | `[R89.3]` | — |
| S107 | `[R95.5]` | — |
| S108 | `[R97.2]` | — |
| S109 | `[R98.5]` | — |
| S110 | `[R7.3]` (both arms) | — |
| S111 | `[R98.6]` | — |
| S112 | `[R91.1]` (boundary sweep) | — |
| S113 | `[R92.5]` (era half) | — |
| S114 | `[R92.3]` (header split) | — |
| S115 | `[R95.6]` (the TTL magnitude) | — |

**Two seeds came back GREEN and both were findings, not clean bills.** S98's first form matched two
places (an ambiguous pattern — caught by the match-count assertion in the seeding harness, which is
the applied limb of the seeding precondition). S99 came back green because the fixture could not
express the defect — **M163**.

### Schema decisions, partition question answered at birth

| store / field | regime that writes it | field that records it | what happens when the regime changes |
|---|---|---|---|
| `ser.byHour` | the item's own `/timeseries` only | `byHourSrc` (`"spark"` / `"none"`) | `[R100.4]` goes red the day the archive feeds a profile; that wiring is a separate deployment-class ruling |
| `hw.fed` / `stw.fed` | computed per candidate per cycle, never persisted | the field itself | no persistence, no partition needed; stated so it is not re-asked |
| `x.wFed` | stamped by `candidateFor`, never persisted | absent = not built here, and `planSeriesFed` treats absent as **RANKED** | withholding an item on a bookkeeping absence would be the never-fed defect pointed the other way |
| `DB.itemOps[id][k] === null` | the operator CLEARING an override | key present with a null value | `opsSet` never wrote a null, so **no stored row changes meaning**; inert while `ITEM_OPS` is false, pinned by `[R93.1]` |
| `S.gateNameOff` | `chk`, on every candidate | the set itself; empty is the only correct value | it exists so that adding a gate without listing it is loud rather than silently unexceptable |

### Scans run at this boundary

- **Scan 2 (never-fed / silent state)** — the five shapes checked over everything new. `byHour`
  closed as an orphan; `S.gateNameOff` answers all three questions; the held block and the
  pool-fed line render only when their populations are non-empty, asserted by absence.
- **Scan 7 (claims-vs-computation)** — findings 8, 9, 14, 20 are this scan's own findings, applied.
- **Scan 8 (pooling)** — the held block and the ranked block are two populations and are never
  summed; the fed/unfed split is the pooling remedy rather than a new pooled figure.
- **Scan 5 (interrogability)** — no new aggregate; the held block IS the decomposition of a
  population that was previously pooled into the ranked list.
- **Scan 14 (label-claim)** — applied to every new label. `[R89.2]`, `[R7.3]` and `[R95.4]`'s
  wording corrected; `[R100.1]`'s universal is exercised against both arms of its pair.
- **Scan 15 (consumer-anchor)** — the new one, run over §100 and §101: every assertion's subject is
  a branch, and where a term is asserted (`seriesReadiness`, `opsPick`) the branch is asserted too.

### DOCTRINE satisfied by inspection, listed as inspection

- **Complexity:** the held block displaces nothing and adds no decision — it re-orders picks that
  were already rendered. Walk-up decision count unchanged.
- **Advisory layers stay advisory:** the hold-out is a render grouping; `buildPlan` decides funding
  and sizing and neither moves.
- **No strategy constant moved.** `GATE.seedSlots`, `T2_MAX_CONCURRENT`, `TESTED_TTL_MS`,
  `SERIES_MIN` and the gate constants are untouched — two of them are now *pinned* by assertions
  that did not exist before.

---

## 6. What the adversarial pass then found

**41 findings, one money-path, and it was mine — introduced while closing the finding above.** Full
record: `audits/ADVERSARIAL-2026-08-19c-queue-pass.md`. All of it is fixed and seeded in the same
session; the residue is listed in HANDOFF.md rather than here.

## 7. What is still owed

- **`reliability`'s total-absence silence** (30 of 43 rows today) — measured and reported above,
  not shipped. It is a material change to a daily surface.
- **Finding 18** — the pruned migrated item-ops row, deferred by its own proposal to the stage that
  flips `ITEM_OPS`.
- **369 of the 385 scan-14 candidates** remain unread. Standing queue item, not a gate.

