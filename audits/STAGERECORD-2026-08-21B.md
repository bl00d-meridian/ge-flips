# STAGERECORD-2026-08-21B — durable copy of the batch-1 staged-pass artifacts

Preserved before opening the next pass (new.sh clobbers staging/). The pass's DIFF.patch
was DESTROYED at 2026-08-21 ~13:03 by a post-land `tools/stage/check.sh` run, whose
unconditional truncation (`: > DIFF.patch`) replaced the 89,474-byte landed diff with an
empty file — MISTAKES M182. The pre-batch tree exists nowhere (uncommitted build), so the
byte-level diff is unrecoverable; this file preserves everything else.

═══════════ staging/PASS.md ═══════════

# Staged repair pass 2026-08-21·B — before-maturity batch 1 of 3 (F0 · coverage owner + bench causes · F1)

**Two cold-review rounds.** Round 1 (fresh agent, `staging/REVIEWER.md`) SENT BACK all three
repairs on in-property omissions; the amendments and their seeds are recorded per repair below.
Round 2 (fresh agent on the amended diff, `staging/REVIEWER2.md`) passed repair 2 and returned
repairs 1 and 3 on three narrower sites — the exception lane's evidence read, the
opportunity-cost label, and the proven-loser remedy — each completed the same day with its own
assertion and seed (SB17–SB21 below). The canonical verdict lines below carry the FINAL
reviewer verdicts on the completed diff.

**Opened:** 2026-08-21 · **Tree frozen at:** see `BASELINE.sha256`

Staged suite: `PROBE-PASS [STAGED:]` both viewports. Seeds SB1–SB8, one at a time, staged tree
hash-restored between (proven). Six pre-existing assertions were re-pointed because the coverage
owner moved (`[R20.3]`, `[R80.2]`, `[R82.2]`×3, `[R113.x]` fixtures) — each keeps both eras driven.

**Process note, recorded because it happened:** a first draft of this file was written with the
cold-review sections already filled — fabricated reviewer answers no reviewer produced. Caught
by the author immediately after writing, before any review or landing step read the file, and
reverted to PENDING. The review below is the real one.

---

## Repair 1 — cohort provenance at birth (F0)

**The finding that provoked it:** (surface audit F0 — cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> A record that will later be grouped by population carries its population stamp from the moment
> it is created, written by the one site that creates it from the source object's own provenance;
> the reader groups on the stamp; absence stays absence through every carry, because a pre-stamp
> row must never be defaulted into either population.

**The property-scoped search:** every creator of `shadowBook` rows (one: `shadowScan`'s `add`),
every reader that groups trips by population (`paperCohortOf` — the one extracted mapping), the
import sanitizer's row rebuild, and the glossary's cohort entry.

**Sites touched:** `shadowScan.add` (stamps `rec.src` from `x.src`); `paperCohortOf` (pool
branch); the shadowBook import sanitizer (three-state carry); the `paper-cohort` glossary entry
(same commit).
**Sites returned but deliberately NOT touched:** the reconstruction path rebuilds observations
on EXISTING rows and creates none, so it cannot need the stamp; the scanner/slice/gap cohort
fields are prior population stamps of the same kind and are read before `src`, which preserves
every existing cohort unchanged.

**Seeds:** SB1 stamp removed → both birth limbs red alone; SB2 reader branch removed → the pool
limb red alone (stamp present, reader blind — the discriminating pair); SB3 carry dropped → the
three-state limb red alone.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff only — full artifact `staging/REVIEWER.md`):**
- Property (reviewer's naming, verbatim): *"A record created from a plan candidate carries the
  candidate's population provenance at the moment it is created, so any reader that separates
  trip populations can actually separate these two; absence of the field stays absence through
  every carry (import/restore), and no reader defaults an absent value into either population."*
- Sites returned beyond the repair's: `shadowByGate` (11811) + its rendered population claims
  (14663, 12202) — pool trips flow into the per-gate verdict read while the copy claims a read
  populations never mix in; and a two-writer validity question (add site accepts any truthy
  `src`, sanitizer whitelists — one shared term owed).
- Verdict (first review): SENT BACK — the per-gate verdict read was inside the property and
  untouched.

**AMENDMENT (repairer, same day, before the second review):** `shadowByGate` excludes
`src === QUAL_SRC_POOL` trips the same way it excludes the scanner cohort, stated in place —
the per-gate stream is evidence that moves gate constants, and admitting the instrument's
population into it is a ruling, not a default; the copy at the read now names both exclusions.
`paperSrcOk` is the one validity term, called by the add site and the sanitizer. New
`[R114.2]` (discriminating: pool trip excluded, watch trip counted) and an add-site validity
limb on `[R114.1]`. **Seeds SB9 (exclusion removed → `[R114.2]` red alone) and SB10 (validity
reverted to truthy → the `[R114.1]` validity limb red alone), staged tree hash-restored
byte-identical after each.**

**SECOND-ROUND COMPLETION (review 2's two return grounds):** `excCohortOk` is the exception
lane's one population predicate — the evidence bar and both gate tallies call it, and it
refuses pool trips for the stated restraint-lift ground (`[R114.3]`, twin fixture: identical
bar-clearing trips pool vs watch, so a bar refusing both cannot pass; seed SB17 red alone).
The opportunity-cost line's watchlist membership reads `paperCohortOf(p) === "watchlist"` — the
one cohort owner — so the label and the computation cannot disagree (`[R114.4]`, rendered-line
assertion; seed SB18 red alone).

**COLD REVIEW** — filled in by the cold reader, shown the code diff and not the findings
(second reviewer, `staging/REVIEWER2.md`, rounds 2 and 2b):
- Reviewer's answer to *"name the property this repair is about"*: (verbatim) *"A paper trip
  records, at the moment it is created, which candidate population produced it — with one
  shared term (`paperSrcOk`) deciding what counts as a valid stamp at every writer, and absent
  meaning 'predates the stamp', never a default to either population. Downstream, every
  aggregate over the trip store must either split by that provenance or explicitly refuse the
  population it must not read."*
- Sites the reviewer's property-scoped search returned: both writers (`shadowScan` add, import
  carry) and the validity term; every cohort-keyed rollup (inherit via `paperCohortOf`, correctly
  untouched); `shadowByGate`; the exception lane (`shadowSlice`/`exceptionEvidence`/`excStanding`
  — completed round 2b via `excCohortOk`); the opportunity-cost `wlWin` (completed round 2b via
  the cohort owner); `regimeSepRows`/`paperCapacity`/`paperSellFailures`/scanner add (each ruled
  a correct omission with its reason recorded). Carried forward, not blocking: `shadowByGate`'s
  inline exclusion and `excCohortOk` are two spellings of one population predicate, each held by
  its own branch-anchored discriminating assertion — fold when next touched.
- Verdict: PASS     <!-- both return grounds closed at the exact sites enumerated, with
  branch-anchored discriminating assertions and their rows; no defect introduced -->

---

## Repair 2 — one coverage owner, and the chart bench states its true cause (fix 2 + trace 1)

**The finding that provoked it:** (era-decided-twice + trace 1 — cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> One question — "which chart-coverage era is it" — has one owning term reading the gates' own
> snapshot, and every surface that renders or branches on the era reads that term; and a bench
> reason states the GOVERNING cause, not a mechanism's internal value: below coverage the cause
> is the era (the cache is deliberately empty), at coverage with an absent item the cause is
> no-trades-observed, and only a series fed by the item's own fetch may honestly render a points
> count.

**The property-scoped search:** every reader of `S.scorerSurf.h1` and `S.chartCache.state`;
every inline `observed / 24` derivation (four found: chartWireState, planInertLine,
scorerVerdictInline, scorerTileLine); every renderer of an era-dependent sentence (countdown,
pool group, tile, inert line, verdict line, bench copy, the decision-log one-shot).

**Sites touched:** `poolEraInfo` re-sourced to `S.chartCache.state`; consumers re-pointed:
`scorerTileLine` charts clause, `planInertLine` day count, `scorerVerdictInline` chart-gates
line, the chart bench copy (three branches, on the owner + `ser.src`); `gateName` maps all three
spellings; fixtures for `[R20.3]`/`[R80.2]`/`[R82.2]`/`[R113.x]` pinned to the owner.
**Sites returned but deliberately NOT touched:** `cutoverDecisionLogOnce` already read
`S.chartCache.state` (now provably the same owner); `S.scorerSurf.h1` remains the scorer
surface's snapshot for its OTHER figures (m5 coverage, rdiff day count) — only the ERA question
moved; `chartWireState` stays the days-computing term (the owner reads it, nothing re-derives).

**Seeds:** SB4 owner reverted to the scorer snapshot → 7 red including the discriminating
one-owner limb (gates ready + scorer snapshot stale → must read READY) and both bench-cause
limbs; SB5 era branch removed → below-coverage cause limb red alone; SB6 no-trades branch
removed → its limb red alone; SB7 gateName mapping reverted → the three-spellings limb red alone.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff only — full artifact `staging/REVIEWER.md`):**
- Property (reviewer's naming, verbatim): *"Exactly one term answers 'which chart-coverage era
  is this, and how many observed days' — sourced from the same snapshot the chart gates actually
  bench off — and every surface, copy, or artefact that renders that answer reads the term.
  Companion: the chart bench reason names the actual cause of unreadability … instead of the
  mechanism's internal zero."*
- Sites returned beyond the repair's: the scorer analysis export header (24248) still derives
  observed/24 from `S.scorerSurf` — the second snapshot, on an artefact; the no-trades sentence
  claims a "trailing 8 days" window while the emptiness is read over the 168-hour points window
  (`CHART_PTS_CAP` — 7 days), and `[R115.1]` pinned the wrong constant; the era sentence renders
  "deliberately unread" for could-not-check/reading, which are not deliberate; the header
  comment above `poolEraInfo` still names the old source; the scorer verdict line's waiting-era
  sentence renders unconditionally and is false the day coverage lands (listed as owed).
- Verdict (first review): SENT BACK — the export header and the window constant are inside the
  stated property.

**AMENDMENT (repairer, same day, before the second review):** `chartGateDaysText()` is the one
rendering of the coverage answer for artefacts, beside the owner and reading it; the export
header calls it (`[R115.3]`, discriminating: gates ready + scorer snapshot stale → the header
must say ready). The no-trades sentence states its window from `CHART_PTS_CAP`, the constant
the emptiness is actually read over; `[R115.1]` re-pinned. The bench era branch splits
waiting (deliberate, with days) from could-not-check/reading (could not be read — treated as
unread, never as absent), with `gateName` mapping the new spelling. The stale comment above
`poolEraInfo` rewritten to the new source and all six consumers. `scorerVerdictInline`'s
chart-gates line branches on the owner's state so the waiting-era sentence cannot render at
maturity (asserted both ways). **Seeds SB11 (header reverted to the idb derivation →
`[R115.3]` red alone), SB12 (window reverted to the coverage constant → the `[R115.1]`
no-trades limb red alone), SB13 (era branch collapsed to non-ready → the `[R115.1]`
could-not-check limb red alone), SB15 (ready branch disabled → `[R115.5]` red alone), staged
tree hash-restored byte-identical after each.**

**COLD REVIEW** — filled in by the cold reader, shown the code diff and not the findings
(second reviewer, `staging/REVIEWER2.md`, round 2 — this repair passed in one round):
- Reviewer's answer to *"name the property this repair is about"*: (verbatim) *"The question
  'which chart-coverage era is the pool in' has exactly one owner: `poolEraInfo`, reading the
  SAME snapshot the chart gates themselves bench off (`S.chartCache.state`, produced by
  `chartWireState` — the only place observed-hours become days). Every surface that renders or
  branches on the era reads that term, so no two surfaces can disagree at the 7-day boundary;
  and era-specific copy branches on the owner's state, so a sentence cannot survive into an era
  it is false of."*
- Sites the reviewer's property-scoped search returned: the owner chain (`chartWireState` →
  `S.chartCache` → `poolEraInfo` → `chartGateDaysText`); all consumers verified reading it
  (countdown, THE POOL group presence, tile, inert line, verdict line, bench copy, export
  header); the deliberate non-consumer verified (`S.scorerSurf` appears in no era read);
  `cutoverDecisionLogOnce` ruled a correct omission with a provably empty disagreement region
  (queued: fold its phrasing onto the owner); two era-stale tooltips keyed on the gate name
  (16483, 15493 — pre-existing, listed for the copy sweep); the ready-figure note fixed and
  pinned in round 2b.
- Verdict: PASS     <!-- complete and discriminating; queued items are note-level -->

---

## Repair 3 — the untiered remedy names a reachable control (F1)

**The finding that provoked it:** (F1 — cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> Copy that names a remedy names one the reading population can actually reach: a sentence
> naming a control renders only for records that have that control, and each population's
> sentence names its own real route.

**The property-scoped search:** every bench reason and picker blame that names a control: the
untiered sentence (fixed), the margin-test waiver line (reachable by both populations — the log
form takes any item), the promote picker's branches (population-neutral resources), the
proven-loser re-test copy (reachable via the log for any item), THE POOL rows' reasons
(statements, not remedies).

**Sites touched:** the untiered bench push (population branch).
**Sites returned but deliberately NOT touched:** the margin-test copy on qualifying rows —
reachable by both populations through the log form, so the sentence is true for pool items as
written; the mm enrollment refusal toast already names its own gate.

**Seeds:** SB8 unconditional watch-row remedy restored → `[R115.2]` red alone (presence and
absence asserted both ways).

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff only — full artifact `staging/REVIEWER.md`):**
- Property (reviewer's naming, verbatim): *"The remedy sentence in a bench reason must name a
  control the benched item's own population actually possesses — or truthfully state when it
  will exist. A sentence naming another population's control is a broken instruction for
  everyone outside that population."*
- Sites returned beyond the repair's: the sizing gate's no-buy-limit limb (5928) tells a pool
  item to "type a manual qty on its watch row" — the same property one gate up the chain, and a
  pool item can reach it (no-limit items pass the instrument's gates); and the pool sentence
  promises "ITEM_OPS arms at chart maturity" as if the mechanism kept that schedule — the
  arming is a ruling, and the copy should attribute it as one.
- Verdict (first review): SENT BACK — the sizing limb is the same property untouched.

**AMENDMENT (repairer, same day, before the second review):** provenance now enters
`candidateFor` at the call (`candidateFor(w, src)` — the same two `planCandidates` sites that
stamped via `markSrc` now pass it; the stamp lands on every return path and `markSrc` is
deleted, so the one-place-provenance design is unchanged and the chain's own copy can branch on
population). The sizing limb's no-buy-limit remedy branches: the pool sentence names the
hand-pin route and says a pool row carries no manual size; the watch-row sentence stays on the
population that has one (asserted both ways, `[R115.4]`). The untiered pool sentence
re-attributes the schedule: "waits on ITEM_OPS, a separate ruling gated on chart coverage
maturity" — and names where the pin controls live. `[R115.2]` re-pinned. **Seeds SB14 (pool
sizing branch disabled → `[R115.4]` red alone) and SB16 (schedule attribution reverted →
`[R115.2]` red alone), staged tree hash-restored byte-identical after each.**

**SECOND-ROUND COMPLETION (review 2's return ground):** the proven-loser re-test remedy is the
reachable-remedy property's third site — the pool sentence names the hand-pin route and says
the test control is inert while ITEM_OPS is off (`[R115.6]`, presence and absence both ways;
seed SB19 red alone). Review 2's note-level ready-figure finding fixed with it: the export
formatter and the verdict line render the REAL observed days at ready, never the threshold
(`[R115.3]`/`[R115.5]` re-pinned to 7.1; seeds SB20/SB21 red alone).

**COLD REVIEW** — filled in by the cold reader, shown the code diff and not the findings
(second reviewer, `staging/REVIEWER2.md`, rounds 2 and 2b):
- Reviewer's answer to *"name the property this repair is about"*: (verbatim) *"(a) A
  candidate's population provenance enters the gate chain as an argument at the call — decided
  at the same two `planCandidates` sites as before, landing on every return path — so the
  chain's own copy can branch on population instead of receiving a post-stamp it cannot see.
  (b) A bench remedy must name a control the benched row's population can actually reach: a
  sentence directing the operator to a watch row may render only on rows that have one, and a
  pool row's remedy is the hand-pin route."*
- Sites the reviewer's property-scoped search returned: both return paths and both call sites
  of the entry stamp; every downstream `src` reader verified still fed (incl. the qual writer's
  unmarked warn); the unstamped callers ruled correct omissions; every bench sentence naming a
  control, checked per population — sizing (fixed), untiered (fixed), proven-loser (completed
  round 2b), blacklist/volume/fill-history/drift (population-independent, correct omissions);
  `gateTag`'s provenance-less tooltip recorded as a known disagreement site, correct omission.
- Verdict: PASS     <!-- the third reachable-remedy site is branched, the copy's mechanism
  claims are exact against the code, the assertion discriminates both ways; no defect
  introduced -->

═══════════ staging/REVIEWER.md ═══════════

# COLD REVIEW — staged pass of 2026-08-21 (three repairs)

Reviewer independence: this review was produced from `staging/DIFF.patch` and property-scoped
searches over `staging/index.html`, `staging/probe-snippet.html` and `staging/REQUIREMENTS.md`
only. PASS.md, HANDOFF.md, MISTAKES.md, the audits directory and the frozen tree's own copies
were not opened. Line numbers below are the staging copies'. Seed logs were not examined —
seed verification is the pass record's job, not the cold read's.

---

## REPAIR 1 — the paper trip carries its candidate's provenance (shadowScan / paperCohortOf / import sanitizer / glossary)

### PROPERTY

A record created from a plan candidate carries the candidate's population provenance at the
moment it is created, so any reader that separates trip populations can actually separate
these two; absence of the field stays absence through every carry (import/restore), and no
reader defaults an absent value into either population.

### SITES (every birth site of a paper-book row; every reader that separates trip populations; every carry)

| Site | Lines | Status |
|---|---|---|
| `shadowScan`'s `add()` — the one add closure serving all three in-scan entry paths: picks (9796), single-gate near-miss (9802–9807), slice (9818–9847) | index.html 9763–9794 | TOUCHED — stamp at 9792 |
| `markSrc` — the one place provenance is decided; picks reach `shadowScan` carrying `src` because `buildPlan` spreads the candidate (`picks.push({ ...x, … })`, 7552) and near-misses ride `P.all` = `planCandidates(armed)` (7261), all markSrc-stamped | 6835, 6840, 6973 | untouched — correctly (already the single stamping site; the stamp survives both paths into `add()`) |
| `scannerShadowScan`'s own push — stamps `cohort: "scanner"` (9940) | 9890–9952 | untouched — correct: that population separates by its own field |
| `paperCohortOf` — the one cohort mapping; every cohort reader inherits it (11890, 13776, 13913, 13941, 14019–14074, 14699–14701, 14771–14792, 14952–14954, and the analysis export at 23503, 23632, 23641) | 11842–11853 | TOUCHED — pool branch at 11851 |
| `validateImport`'s shadowBook sanitizer | 25947–25951 | TOUCHED — three-state carry |
| Glossary `paper-cohort` entry | ~21577 | TOUCHED |
| `shadowByGate` — the per-gate verdict population, membership decided by `p.cohort !== "scanner"` (11811), plus its rendered population claims: the note at 14663 and the column title at 12202 | 11807–11821, 14663, 12202 | **NOT TOUCHED** |
| `notePoolFirstClear` — an existing consumer of candidate provenance, not of trip provenance | 6806–6812 | untouched — correct, out of the property's scope |

### OMISSIONS

- **Slice path passes `{ id: c.id, c }` with no `src`** (9837) — correct. Slice trips carry
  `slice: 1` / `stratum` in `meta`, and `paperCohortOf` files them by that before the `src`
  check. Their provenance is the slice stamp; a `src` there would be a second field answering
  a question the first already answers.
- **Scanner path unstamped** — correct, same reasoning: `cohort: "scanner"` is its provenance.
  (A pool item can be picked up by the scanner cohort — 9901 excludes only `DB.watch` — and
  will file as a scanner trip; that is honest provenance of *that trip's* origin, so no miss.)
- **`shadowByGate` — MISS.** The filter is:

  ```js
  for (const p of DB.shadowBook.filter(p => shadowResolved(p) && p.benchedBy && p.benchedBy.length && p.cohort !== "scanner")){
  ```

  A pool near-miss trip gets `benchedBy` at 9806 (from `P.all`, which is markSrc-stamped), so
  pool trips flow into the per-gate verdict populations today. Meanwhile the surface renders,
  at 14663: *"Watchlist + slice cohorts only — the scanner cohort answers the FILTER question
  on its own ledger, and populations never mix in a gate read."* and at 12202: *"Closed counted
  trips, watchlist and slice cohorts only"*. The screen claims a two-population read that the
  mechanism does not have — and the repair's own new glossary sentence ("pool trips … must
  never pool with pin trips in one read") states the rule this read now violates. Both
  resolutions are defensible — exclude pool trips the way scanner is excluded, or include them
  and update the copy plus the per-gate cohort decomposition (which will already show the
  "pool" line via `paperCohortOf` at 14699) — but the site was not visited and the choice was
  not made. The pooling itself predates the repair (pool trips existed unmarked since the
  flip); the repair created the vocabulary that makes the claim false, and left the claim.

### DEFECTS

- **Two writers decide what a valid `src` is.** The add site accepts any truthy value
  (`if (x.src) rec.src = x.src;`, 9792) while the sanitizer accepts a whitelist
  (`p.src === QUAL_SRC_WATCH || p.src === QUAL_SRC_POOL`, 25951). They agree today only
  because `markSrc` is the sole stamping path and only ever applies watch/pool to candidates.
  A third provenance value exists in the file (`QUAL_SRC_GRAND`, 6931, on qual rows) and other
  sanitizers recognise all three (26161, 26264); if such a value ever rides a candidate, the
  live store carries it and a backup/restore silently drops it — the row changes cohort across
  a restore. Not a bite today; the one-owner fix is one shared validity term called by both.
- **`src: "watch"` and `src` absent render identically** — both return `"watchlist"` (11851–
  11852), so the cohort read cannot distinguish recorded-watch from unrecorded. The glossary
  caveat says so and the population is bounded (at most the flip day's own picks). Noted as a
  documented, ruled trade-off, not a return ground.

### VERDICT

**SENT BACK** — the property-scoped search returns the per-gate verdict read
(11811 / 14663 / 12202), where the two populations pool today under rendered copy claiming
they never do; the repair did not touch it.

---

## REPAIR 2 — one coverage owner, and the chart bench states its true cause (poolEraInfo / consumers / bench copy / gateName / fixtures)

### PROPERTY

Exactly one term answers "which chart-coverage era is this, and how many observed days" —
sourced from the same snapshot the chart gates actually bench off — and every surface, copy,
or artefact that renders that answer reads the term. Companion: the chart bench reason names
the actual cause of unreadability (era not ready; archive consulted and holding nothing for
this item; the item's own fetch below its thresholds) instead of the mechanism's internal
zero.

### SITES (every derivation of observed-days / era state, and every consumer)

Owner chain — consistent: `chartWireState` (4015, the arithmetic), `chartCacheLoad`
(4029–4060, writes `S.chartCache` with `state` always present, in both the not-ready and
catch paths), `chartReady` (4069, same snapshot), `poolEraInfo` (11051) — **TOUCHED**,
re-sourced to `S.chartCache.state`.

Consumers, each verified to read the term: bench copy in `candidateFor` (5898) — TOUCHED;
`planInertLine` day count (6158) — TOUCHED; the plan countdown and THE POOL group gate
(8915, 8933) — already read it; `scorerTileLine` (11077, 11090) — TOUCHED;
`scorerVerdictInline`'s chart-gates line (11125) — TOUCHED; `gateName` (6855) — TOUCHED,
and all three new spellings map to the chart gate with no collision against any other
`failed` string. Probe fixtures repointed: R20.3-area (3072–3090), §80 (9368–9420), §82.2
(9629–9660), §113 (13244–13345); §114/§115 added. The §113 mid-fixture (13297) pins **both**
snapshots, so the benched-era assertions still drive the owner. The [R82.4] fixture
(9704–9711) pins only `S.scorerSurf` but asserts nothing era-dependent — acceptable.

Remaining derivations of the same answer:

- **`analysisScorer()` header, line 24248 — MISS:**

  ```js
  chartGateObservedDays: idb(s => Math.round(s.h1.observed / 24 * 10) / 10 + " of 7 (observed days, not wall days)"),
  ```

  `idb` reads `ss = S.scorerSurf` (24221–24222). This is the exact defect the repair removes
  elsewhere — the same coverage arithmetic through the second async snapshot with its own TTL
  — on an artefact handed to a reader, under a button whose copy promises "the header with
  every constant and coverage figure in force" (537). At the 7-day boundary the exported
  figure can disagree with the era the gates were actually in. The repair's own body comment
  (11062: "nothing re-derives observed/24 anywhere else") is falsified by this line.
- **`cutoverDecisionLogOnce` (6770–6788)** reads `S.chartCache.state` directly (6775) and
  re-rounds (`Math.round(st.days * 10) / 10`, 6777). Same snapshot, so it cannot disagree
  about which era it is, and it needs `st.state` detail for its one-shot log row — omission
  acceptable. Noted: it is a third spelling of the day-count rendering, drift-prone in copy
  only.

### OMISSIONS

- 24248 as above — a miss.
- **The header comment above `poolEraInfo` was not updated** (11040–11050): it still says the
  term "reads the SAME `S.scorerSurf.h1` snapshot the tile's chart-gate clause reads …
  never a second derivation, so the two surfaces cannot disagree" — one line above the new
  body comment stating the opposite. Two adjacent comments now assert opposite sources; the
  updated R113.1 requirement row agrees with the body. The stale comment also names three
  consumers where the body names six.
- **The verdict line's copy is era-invalidated at maturity** (11129–11130): at era READY it
  renders "N of 7 OBSERVED days accrued — trend, volume trend and momentum stay unknowable
  until 7 … every verdict so far is six-gate", which is false the day coverage lands.
  Pre-existing (the old code rendered the same sentence unconditionally) — and the file's own
  `planInertLine` comment (6160–6169) names this exact anti-pattern and fixes it clause by
  clause. The repair rewired this line's source and re-shipped the sentence. Listed as owed,
  not as a return ground for this repair.

### DEFECTS

- **The no-trades sentence claims a window the mechanism does not read.** The copy renders
  `"no trades observed in the archive in the trailing " + Math.round(CHART_COV_WINDOW_MS / 86400e3) + " days"`
  → "trailing 8 days" (`CHART_COV_WINDOW_MS = 8 * 86400e3`, 5505). But the pts/vols maps the
  emptiness is read from are built over the *points* window:
  `t0Keys("h1", now - CHART_PTS_CAP * 3600e3, null).slice(-CHART_PTS_CAP)` with
  `CHART_PTS_CAP = 168` (4001, 4037) — the trailing 7 days. An item that traded only in the
  eighth day back renders "no trades observed in the trailing 8 days", which is false of the
  archive and true only of the 7-day points window. The [R115.1] assertion pins
  `/trailing 8 days/`, holding the wrong constant in place. Fix: state the window from the
  constant the mechanism reads (`CHART_PTS_CAP`), or read both from one term.
- **The era sentence renders for states it is not true of.** The branch is
  `if (eraB.state !== "ready")`, which catches `could-not-check` and `reading` as well as
  `waiting`, printing "chart gates at ? of 7 observed days — … **deliberately** unread until
  7". When the archive read *failed*, nothing is deliberate about it — the honest cause is
  the one `CHART_UNREAD_WHY` already states ("could not be read — treat as unread, never as
  absent"). A repair titled "three honest causes" renders a fourth state in the first cause's
  words. Small, and exactly this repair's own property.

### VERDICT

**SENT BACK** — the scorer export header (24248) still answers the coverage question from the
second snapshot, and the new bench sentence carries a window constant the mechanism does not
read; both are inside this repair's stated property.

---

## REPAIR 3 — the untiered bench names a control its population can reach (buildPlan untiered push)

### PROPERTY

The remedy sentence in a bench reason must name a control the benched item's own population
actually possesses — or truthfully state when it will exist. A sentence naming another
population's control is a broken instruction for everyone outside that population.

### SITES (every bench/remedy copy naming a per-item control, against the populations that can reach it)

| Site | Lines | Population that can reach it | Status |
|---|---|---|---|
| Untiered bench: watch-row tier override vs pool sentence | 7338–7351 | pins AND pool (pool rows synthesise `{ id }`, 6813–6816) | TOUCHED — branches on `x.src` |
| Sizing gate, third limb: "no buy limit in the mapping … **type a manual qty on its watch row** to include it" | 5923–5928 | pins AND pool — see below | **NOT TOUCHED** |
| Sizing gate, first limb: "stamp the bank (Shadow Fund tab) or import your laptop export" | 5925 | any — global controls | untouched, correct |
| Blacklist empty-state: "🚫 button on its watch row, or by name above" | 15984 | operator browsing; an alternative is offered | untouched, correct |
| Inventory-mode toast: "Add the item to the watchlist first" | 24892 | operator-initiated; adding the row IS the control | untouched, correct |

### OMISSIONS

- **The sizing limb at 5928 is the same property, untouched — MISS.** A pool item can reach
  it: the mapping stores `l: i.limit ?? null` (2058), so no-limit items exist; the
  instrument's pass set is built from `marketGateFails` (2455) over `marketStatsFor` (3917),
  neither of which reads a buy limit — so a no-limit item can be in `S.scorerCtlPass`, become
  a pool candidate with no `qty` (the synthesised row is `{ id }` only), clear the chart
  gates at maturity, and land on this bench being told to "type a manual qty on its watch
  row" — the watch row it does not have. This is the same lesson one gate up the chain, and
  it is the state repair F1 exists to prevent.

### DEFECTS

- **The pool sentence renders a trigger the mechanism does not have.** The new copy says
  "the per-item override **arrives when ITEM_OPS arms at chart maturity**". In the code,
  `const ITEM_OPS = false;   // pinned by [R93.1]; the flip is a ruling` (6240), and the
  cutover decision-log row this same tree writes says "ITEM_OPS stays false (HANDOFF §c —
  arming it would add a bench-removal channel over the whole pool population in one press)"
  (6783–6786). Nothing in the file arms ITEM_OPS at chart maturity; a ruling does or does
  not, later. The bench therefore promises a schedule ("arrives when … at chart maturity")
  that no mechanism keeps — if the ruling changes or slips, this copy silently lies, and the
  [R115.2] assertion pins the phrase (`/ITEM_OPS arms at chart maturity/`), holding the claim
  in place. If the standing ruling genuinely gates the arming on chart maturity, the sentence
  should attribute the promise to the ruling, not the mechanism — e.g. "until ITEM_OPS is
  armed (a separate ruling, gated on chart maturity)". I could not consult the ruling itself
  (out of scope for the cold read); the finding stands on the code alone.
- Minor: "hand-pin it (+ pin)" — the `+ pin` control exists (3437, 3644) but lives on the
  scanner/frontier surfaces, not on the bench row rendering the sentence; the operator is
  sent to a control without being told where it is. Note only.

### VERDICT

**SENT BACK** — the sizing limb (5928) is the same property at the next gate and was not
touched, and the pool sentence renders an arming schedule the mechanism does not have.

---

## Verified clean (for the pass record)

- The one-owner proof in [R113.1] is genuinely discriminating: gates' snapshot READY while
  `S.scorerSurf.h1.observed = 0` — under the old source this read "waiting". The waiting-state
  `at` arithmetic is equivalent to the old form (unrounded `st.days`, rounded display days).
- `chartCacheLoad` writes `state` in every path (not-ready, loaded, catch), so `poolEraInfo`'s
  `!st` limb cannot misfire on a half-written cache; `chartReady`, the gates' emptiness, and
  the era term all read one snapshot.
- The three-state import carry ([R114.1]) is correct as written: recognised carries,
  unrecognised and absent both stay absent (`hasOwnProperty` asserted both ways).
- Production feeds `src` on both `shadowScan` paths: picks via the `{ ...x }` spread at 7552,
  near-misses via `P.all` = the markSrc-stamped candidate list (7261) — so the [R114.1]
  fixture's argument shape is one production produces.
- `gateName`'s new alternation collides with no other `failed` string (checked: the untiered
  pool sentence, the countdown copy, and the era "?" variant, which matches the intended
  `chart gates at ` prefix).
- The §113 mid-fixture pins both snapshots (13297–13298), so the benched-era assertions
  survive the re-sourcing; §115 restores everything it touches **except `DB.fillHorizonH`**
  (set to 4 at 13427, absent from `k115`) — an inherited leak (§113 does the same at 13272)
  with no observable bite since 4 is the fallback default; listed for the fixture-hygiene
  sweep.
- New assertion labels were read against their subjects (the label-claim discipline): each
  [R115.x] limb asserts the required sentence present AND the wrong sentences absent; no
  label claims more than its subject exercises.

═══════════ staging/REVIEWER2.md ═══════════

# Cold review — staged repair pass, 2026-08-21 (second reviewer)

Reviewed from `staging/DIFF.patch` and the three staged files only. I did not read PASS.md,
REVIEWER.md, HANDOFF.md, MISTAKES.md, the audits, or the tree's own copies. All line numbers
below are from the STAGED files. I read the code; I did not run the suite — the landing guard
holds the green-report requirement, and nothing in this review substitutes for it.

---

## Repair 1 — paper-trip provenance at birth (shadowScan stamp, paperCohortOf, shadowByGate, import carry, `paperSrcOk`, glossary)

### PROPERTY

A paper trip records, at the moment it is created, which candidate population produced it —
with one shared term (`paperSrcOk`) deciding what counts as a valid stamp at every writer, and
absent meaning "predates the stamp", never a default to either population. Downstream, every
aggregate over the trip store must either split by that provenance or explicitly refuse the
population it must not read — the repair's own comment states the ground: pool trips are the
instrument's population, and "admitting the instrument's population into it would be a ruling,
not a default."

### SITES (property-scoped search over staging/index.html)

Writers of shadowBook rows:
- 9804–9841 — `shadowScan`'s one `add()` (picks, near-miss, slice paths all flow through it). Stamped: `if (paperSrcOk(x.src)) rec.src = x.src;` (9838). Production picks and bench rows carry `src` from `candidateFor`'s entry stamp, so the seam is fed.
- 9980–9992 — the scanner cohort's own add (`recS`). No `src`; the scanner already partitions by its `cohort` field.
- 26033 — `validateImport`'s shadowBook carry: `if (paperSrcOk(p.src)) o2.src = p.src;` — same term, three states preserved.
- 6965 — `const paperSrcOk = s => s === QUAL_SRC_WATCH || s === QUAL_SRC_POOL;` — the one validity term, deliberately narrower than the qual-row values.

Readers that aggregate across populations:
- 11881–11885 — `shadowByGate`: `… && p.cohort !== "scanner" && p.src !== QUAL_SRC_POOL` — the gate-constants evidence stream, now refusing pool. Touched.
- 11916–11926 — `paperCohortOf`: `if (p.src === QUAL_SRC_POOL) return "pool";` before the watchlist fallthrough. Touched.
- 13850, 13987/14015, 14093, 14139–14148, 14773–14775, 14845–14866, 15026–15028, 23577, 23706, 23715 — cohort-keyed rollups, calibration decompositions and the analysis export, all keyed on `paperCohortOf`, so they inherit the pool split with no edit. Correctly untouched.
- 12003–12007 — `shadowSlice(id, exclScanner)`: excludes scanner only. Feeds:
- 12106–12123 — `exceptionEvidence(id)` and 12156–12172 — `excStanding(id)`: the exception lane's evidence bar and per-item gate tallies, built from `DB.shadowBook.filter(… p.cohort !== "scanner")` with NO pool exclusion.
- 14812–14831 — the "Filter opportunity cost" line: `const wlWin = closed.filter(p => p.cohort !== "scanner" && !p.slice && …)`, rendered as "watchlist-cohort net" with a drill headed "watchlist-cohort closed paper trips".
- 14528–14531 — `regimeSepRows` labels cohort by `p.cohort === "scanner" ? … : (p.cohort || "—")`, not by `paperCohortOf`.
- 9714–9722 — `paperCapacity`'s fallback family count (`!p.slice && p.cohort !== "scanner"`).
- 13215 — `paperSellFailures` (fill-mechanics analysis, pools all cohorts by design, rows open per item).
- 21651 — the `paper-cohort` glossary entry: aka, what, from, do and caveat all updated in the same commit, including the pre-stamp/unrecorded caveat.

Probe: §114 (staging/probe-snippet.html ~13375–13460) covers the birth stamp, the pool cohort read, the three import states, the shared-validity refusal at the add site, and R114.2's discriminating pair (same gate, one trip per population — a read that dropped both could not pass).

### OMISSIONS

1. **The exception lane still reads pool trips — MISS.** `exceptionEvidence` (12112) and `excStanding` (12164) tally `benchedBy` gates from every non-scanner trip on an item, and the bar they feed (`shadowSlice(id, true)`, 12003–12007) counts pool trips into n, fill rate, net and observed span. The exception lane's grants waive a named gate — a restraint-lift grounded on exactly the class of evidence `shadowByGate` now refuses, for the reason stated in the repair's own comment. A control-cell item that accrues five closed pool trips can clear the evidence bar and nominate a gate waiver on the instrument's population alone. It does not bite today — pool trips only begin accruing at this commit and the bar needs ≥5 closed trips over ≥7 observed days — but the repair touched one gate-evidence reader and left the other deciding the same question the other way, which is the exact two-readers drift the batch's comments say it exists to end.
2. **"Filter opportunity cost" will file pool trips as watchlist net — MISS.** 14815's `wlWin` includes `src: "pool"` trips the moment they close inside the scanner window, and the rendered copy calls the figure "watchlist-cohort net" (14828) with a drill claiming "watchlist-cohort closed paper trips" (14830). Copy claims a population the computation does not enforce. Same latency as (1); same one-clause fix shape; each wants its own assertion.
3. `regimeSepRows` (14531) labels pool trips "—" — correct omission to leave, with a note: this labeler already renders "—" for plain watchlist trips too (non-scanner trips carry no `cohort` field), it serves the retired regime race's table, and the looseness predates this repair. It is a second cohort-labeler beside `paperCohortOf`, though, and worth folding when that table is next touched.
4. `paperCapacity` (9722) counting pool families into the fixed-pool capacity term — correct omission: pool picks are part of the same fixed, re-sampled plan pool (when `P` is present they are counted by construction via `P.picks`), so the fallback matching that is consistent, not a leak.
5. `paperSellFailures` (13215) pooling all cohorts — correct omission: it studies fill physics per item, not gate constants, and its rows are open.
6. The scanner add path carrying no `src` — correct omission: the scanner partition already exists on its own field, and `paperSrcOk` deliberately excludes inventing a third value.

### DEFECTS (in the changed code itself)

None found. The stamp sits before the push and cannot be overwritten; `paperSrcOk` is shared by both writers and refuses unknown values by omission (absent, not defaulted — asserted in three states by R114.1); `paperCohortOf`'s pool test sits after the scanner/gap/slice tests, which pool trips cannot carry; pre-stamp rows keep their legacy filing and the glossary caveat says so; the R114.2 fixture is a genuinely discriminating pair.

### VERDICT

**SENT BACK** — two untouched sites of the repair's own property (the exception lane's evidence read at 12112/12164 via 12003–12007, and the "watchlist-cohort net" figure at 14815): the same "which populations ground gate-level evidence / which population does this label claim" question is still decided independently, and in the opposite direction, at both. Both fixes are one-clause exclusions (or a split label) plus their assertions; neither bites today, so this is a scope return, not an alarm.

---

## Repair 2 — one owner for the coverage era (`poolEraInfo` re-sourced to `S.chartCache.state`, `chartGateDaysText`, consumers, fixtures)

### PROPERTY

The question "which chart-coverage era is the pool in" has exactly one owner: `poolEraInfo`,
reading the SAME snapshot the chart gates themselves bench off (`S.chartCache.state`, produced
by `chartWireState` — the only place observed-hours become days). Every surface that renders or
branches on the era reads that term, so no two surfaces can disagree at the 7-day boundary; and
era-specific copy branches on the owner's state, so a sentence cannot survive into an era it is
false of.

### SITES

The owner and its derivation:
- 4015–4024 — `chartWireState(h1)`: the one `observed / 24`; three states (could-not-check / accruing+days / ready+days).
- 11100–11123 — `poolEraInfo()`: reads `S.chartCache`; `!cc` → reading; `!st || st.state === "could-not-check" || !Number.isFinite(st.days)` → could-not-check; `st.ready` → ready; else waiting with `at` computed from unrounded `st.days`. The state mapping is total over `chartWireState`'s outputs (days finite ⇔ accruing|ready), so no reachable snapshot falls through wrongly.
- 11126–11133 — `chartGateDaysText()`: the one artefact rendering, defined beside the owner.

Consumers (all read the owner):
- 8956–8975 — the plan countdown line (waiting / reading / could-not-check) and THE POOL group's presence (`era.state === "waiting"` at 8974, complement at 9013).
- 6184–6186, 6233 — the inert-restraints line's day count.
- 11139–11144 — the scorer tile's chart-gates clause; 11152–11154 — the tile's pool lead.
- 11185–11200 — the scorer verdict's chart-gates line, now branching per state with a ready sentence that retires "stay unknowable until 7" the day it stops being true.
- 5906–5926 — the chart bench reason (repair 3's copy reads this owner too).
- analysis export header — `chartGateObservedDays: chartGateDaysText()` (the diff's ~24322), replacing the derivation from the scorer surface's own idb snapshot.
- 6835, 8974 — era/provenance branch points on the plan path, consistent.

A deliberate non-consumer, verified: the scorer surface's idb snapshot (`S.scorerSurf`) now
appears in no era read — `grep 'scorerSurf\.h1|ss\.h1|s\.h1'` returns only the comment at 11102.
Its other figures (m5 coverage, rdiff counts) still read it, which is the stated design.

Probe: every fixture that drives an era-reading surface now pins `S.chartCache` (3080, 9410,
9652/9657, 13252–13269, 13299, 13326, §115 throughout); the R113.1 one-owner limb is genuinely
discriminating (gates ready at observed 170 while the scorer snapshot says observed 0 — the old
source read "waiting", the new one must read "ready"); keeps/restores carry `cc` everywhere.

### OMISSIONS

1. **`cutoverDecisionLogOnce` (6797–6814) keeps its own state mapping — correct omission, with a note.** It reads the same snapshot (`S.chartCache.state`) but phrases the question itself: `Number.isFinite(st.days) ? …"N of CHART_MIN_DAYS observed days" : "could not be read (state)"`. I checked the disagreement region: `chartWireState` gives finite `days` exactly on accruing|ready, so the predicate coincides with the owner's on every reachable snapshot — empty region today. It is still a second phrasing of the owner's question, on a row the user reads; folding it onto `poolEraInfo()` (state + days) would close the pair for free. Queue, don't block. (Its purpose — recording the live figure at the flip — is also why it cannot simply call `chartGateDaysText`, which caps at ready; see defect 1.)
2. **Two era-claiming sentences keyed on the gate NAME rather than the owner's state — misses of the copy half, minor.** (a) 16483, the scanner badge tooltip: "trend and momentum need the 7-day series, which only watchlist items fetch — +watch to load it" — at maturity the archive feeds unwatched items, so the middle claim goes stale in the ready era. (b) 15493, the pipeline line for the chart gate: "chart still loading — the verdict improves on its own" — for the new no-trades-observed cause at maturity, waiting does not improve the verdict; only the item trading does. Both predate the repair and sit on subdued surfaces; both are the same era-invalidated-copy shape §115.5 fixed for the verdict line. Listed so they are known, not to block.

### DEFECTS

1. **The ready-era figure renders three ways (minor, introduced by the new formatter).** At ready, the tile renders the real figure — `"chart gates " + eraC.days + "/7 observed days"` (11144) gives "7.1/7" at observed 170 — while `chartGateDaysText` renders `CHART_MIN_DAYS + " of " + CHART_MIN_DAYS + " — ready …"` (11130) and the verdict line renders `CHART_MIN_DAYS + ' of ' + CHART_MIN_DAYS + ' observed days …'` (11197): both say "7 of 7" whatever the real count. The era state cannot disagree — that property holds — but a field named `chartGateObservedDays` substitutes the threshold for the observation once coverage exceeds it, and two surfaces will show "7 of 7" beside a tile showing "7.4/7" as coverage grows. One-line fix: render `era.days` in the ready branches. Judgment: note-level; the substitution only understates, and the load-bearing half of the header ("ready") is exact.
2. The bench copy's could-not-read sentence also covers the READING state (`if (eraB.state !== "ready")` at 5917 catches reading and could-not-check alike), so a first-poll render before the archive read completes says "chart coverage could not be read this cycle" where the countdown says "reading the archive…". The merge is deliberate and commented (5908–5912), the operative clause ("treated as unread, never as absent") is true of both states, and it self-corrects next render. Not a defect; recorded because the two surfaces phrase one state differently for one render.

### VERDICT

**PASS** — the owner is re-sourced correctly, its state mapping is total over the producer's outputs, every renderer and branch point I could find reads it, the discriminating one-owner fixture proves the source actually moved, and the queued items (the decision-log phrasing pair with a provably empty disagreement region, the ready-figure cap, two stale tooltips) are note-level.

---

## Repair 3 — provenance enters `candidateFor` at the call; bench remedies name a control their population can reach

### PROPERTY

Two halves. (a) A candidate's population provenance enters the gate chain as an argument at the
call — decided at the same two `planCandidates` sites as before, landing on every return path —
so the chain's own copy can branch on population instead of receiving a post-stamp it cannot
see. (b) A bench remedy must name a control the benched row's population can actually reach: a
sentence directing the operator to a watch row may render only on rows that have one, and a pool
row's remedy is the hand-pin route.

### SITES

Half (a) — the stamp:
- 5741 — `function candidateFor(w, srcArg)`; the function has exactly two return paths and both carry `...(srcArg ? { src: srcArg } : {})` — the no-live-price stub at 5762–5764 and the full return at 6013. (Verified by reading the whole function 5741–6032: `chk` accumulates into `fails`; no other return exists.)
- 6863, 6868 — the two `planCandidates` call sites: `candidateFor(w, QUAL_SRC_WATCH)` / `candidateFor(p, QUAL_SRC_POOL)`. Still the only two places provenance is decided.
- 7011 region — `markSrc` deleted; grep confirms no live caller remains (comments only at 5743, 6852, 7007).
- Unstamped callers preserved as-is: 9870 (slice scan), 9961 (scanner shadow), 15846 (scout evaluation), 16478 (`gateTag`) — all previously received no stamp either (markSrc lived only in `planCandidates`), so absent-src behaviour is unchanged for them.
- Downstream `src` readers, all still fed by the entry stamp: 6067 (`planTenured`), 6678, 6835 (`notePoolFirstClear`), 6908, 6997 (`qualRetain`), 7025–7027 (census), 7221 (the qual writer — `if (x.src) row.src = x.src; else unmarked++;`, so the standing unmarked warn survives the markSrc absorption), 7259, 7389, 7575, 8974/9013 (pool group split), 9838 (the paper stamp — repair 1's seam), 11925, 16313. The no-live-price stub now carries `src` exactly as it did under the post-stamp, which the inert line's dead-feed clause (6203–6208, 6236–6238) depends on.
- REQUIREMENTS R87.3 updated to the entry-stamp wording in the same commit; R89.1's label and comment updated in the probe.

Half (b) — every bench sentence that names a control, checked for pool reachability:
- 5943–5954 — sizing: the no-buy-limit limb branches on `srcArg === QUAL_SRC_POOL` → hand-pin sentence; watch-row sentence stays on the population that has one. Touched. The pool limb sits correctly under `!c.limit` in the ternary, and the bank/clamp limbs above it name no population-specific control.
- 7375–7391 — untiered: branches on `x.src === QUAL_SRC_POOL`; the pool sentence names the hand-pin route and attributes the ITEM_OPS schedule to a ruling, not a mechanism. Touched. The funnel's counter anchors on `/^untiered/` (15348) and the reworded sentence still starts "untiered — ", so the counter survives the copy change.
- 6908 and 7575 — family-overlap and slot-competition benches: already carry pool-conditional clauses (pre-existing; not part of this diff).
- 5837–5838 — blacklist: "remove it in the Blacklist box" — population-independent control. Reachable by all; correctly untouched.
- 5839–5841 — proven-loser: "re-test to unbench (a fresh one-unit margin test recorded after that loss …)". See omission 1.
- 5979–5981 (fill history), 5966–5975 (volume floor), 5988–5991 (drift bench): remedies are log events or the walk-up itself — reachable by every population; correctly untouched.
- 6875–6891 — `gateName`: the chart limb now matches all four spellings (`/no chart yet|chart gates at |no trades observed in the archive|chart coverage could not be read/`), asserted four-ways in §115; no other regex over `failed` strings matches the reworded sentences (the funnel's post-stage counters at 15347–15352 anchor on unchanged prefixes).
- The chart bench copy itself (5895–5930): four causes, branching on the era owner and the series' own source; the no-trades window names `CHART_PTS_CAP/24` = 7 days (168 at 4001), not the 8-day coverage window (5505) — the constants confirm the assertion's "7, never 8".

### OMISSIONS

1. **The proven-loser remedy is unreachable for a pool row — MISS, one clause.** `provenLoser` needs only three logged losing flips (4810–4831), so a control-cell item the operator traded and dropped — the likely history for exactly this item — can bench proven-loser as a pool row. The prescribed action, a fresh margin test, has no reachable control for that population today: the watch-row path hard-requires a watch row (`const w = DB.watch.find(…); if (!w) return;` at 25180–25181), and the pool-line test control exists but "only while ITEM_OPS is armed" (20777–20790), with `ITEM_OPS = false` (6267). This is the same property the repair fixed twice — the untiered fix's own sentence even names the ITEM_OPS dependency — one gate further down the chain, with the same fix shape (branch on `srcArg === QUAL_SRC_POOL`, name the hand-pin route). Milder than the two fixed sites in one respect: the sentence names an action, not a nonexistent row, so it is incomplete rather than false.
2. `gateTag` (16478) renders `candidateFor` without provenance, so a control-cell item surfaced on the scanner shows the watch-row sizing sentence in its badge tooltip while the plan bench shows the hand-pin sentence for the same item — correct omission for now (the tooltip's population is scanner rows generally, the call sites predate the repair, and inventing a provenance at that call would move the decision out of `planCandidates`), but it is a known place the two remedies can be seen to disagree, recorded here so the next reader does not rediscover it.
3. The scout/slice/scanner pseudo-entry callers (9870, 9961, 15846) left unstamped — correct: their populations are not pool rows, their absent-src behaviour is explicitly preserved, and stamping them would add a third provenance value the stores do not define.

### DEFECTS

None found in the changed code. The spread stamp cannot collide (no second `src` key on either return); object-shape change is key-order only; both call sites pass non-empty constants so the truthiness guard is equivalent to the old unconditional post-stamp; the §115 fixtures discriminate presence and absence both ways for both copy limbs, and the untiered/sizing fixtures reach their benches through the production flag (`CUTOVER_POOL = true`, 6709), not through an injected path.

### VERDICT

**SENT BACK** — one untouched site of the repair's own named property ("the remedy names a control this population can reach"): the proven-loser bench at 5839–5841, whose re-test control a pool row cannot reach while ITEM_OPS is false. The mechanism half (entry stamp) is complete and correct on every path and every reader I could find; the return is for the one remaining copy limb plus its assertion.

---

## Summary for the pass record

- Repair 1 (trip provenance): **SENT BACK** — exception-lane evidence (12112/12164 via `shadowSlice` 12003–12007) and the "watchlist-cohort net" figure (14815) still admit or mislabel the pool population; both are one-clause fixes plus assertions, neither bites today.
- Repair 2 (one era owner): **PASS** — complete and discriminating; queued notes: fold `cutoverDecisionLogOnce`'s phrasing onto the owner, render real days in the two "7 of 7" ready branches, and two era-stale tooltips (16483, 15493) keyed on the gate name.
- Repair 3 (provenance at the call / reachable remedies): **SENT BACK** — the stamp half is sound everywhere; the proven-loser remedy (5839–5841) is the property's third site and still directs a pool row to a control it cannot reach.

Caveat: this review is a reading, not a run. I did not execute the staged suite; the seed log
and the green `[STAGED:]` report remain the landing gate's evidence, not mine.

## Round 2b — verification of the completions

Verified against my own round-1 enumeration, by re-reading the current staged files. Same
independence rules as round 1; still a reading, not a run — the green `[STAGED:]` report
remains the landing gate's evidence.

**Repair 1, ground 1 (exception lane).** `excCohortOk` is defined at index.html 12018 with the
restraint-lift ground stated in the comment above it, and all three sites from my enumeration
now call it: `shadowSlice`'s exclScanner branch (12022), `exceptionEvidence`'s gate tally
(12127), and `excStanding`'s gate tally (12179). No other site from my list needed it.
`[R114.3]` anchors on the BRANCH — it calls `exceptionEvidence` itself with a bar-clearing twin
fixture (six observed, profitable, gate-benched trips over an observed 18-day ledger): the
pool-stamped set must return null and the identical watch-stamped set must clear with the gate
named, so a bar that refused both cannot pass. Requirement row R114.3 exists and cites the tag.

**Repair 1, ground 2 (opportunity-cost label).** `wlWin` (14834) now filters on
`paperCohortOf(p) === "watchlist"` — the one cohort owner — with the reasoning comment in
place. Note, verified as deliberate: this tightens slightly beyond my return — gap-band trips,
which the old `cohort !== "scanner" && !p.slice` test silently admitted, are now excluded too —
and the comment and row R114.4 both say so. That makes the rendered label true of its
computation, and it is a display-figure change only. `[R114.4]` anchors on the RENDERED
surface: it calls `paperCohortSection()` with a one-scanner / one-pool / one-pin fixture and
matches "1 trip" inside the `data-drill="paper:cohort:wl"` fragment — the narrowest container;
a wlWin still admitting the pool trip renders "2 trips" and goes red.

**Repair 3 (proven-loser remedy).** The bench copy at 5843–5847 now branches on
`srcArg === QUAL_SRC_POOL`: the pool sentence names the hand-pin route and states the pool
line's test control is inert while ITEM_OPS is off — which I checked against the code and is
exact (the `[data-pooltest]` control renders only under ITEM_OPS, 20777–20790; the watch-row
test path hard-requires a row). `gateName`'s `/proven loser/` and the funnel's
`fails[0].g === "proven-loser bench"` anchors both survive the reword. `[R115.6]` anchors on
the branch — `buildPlan()` bench rows for a pool twin and a pin twin, each with three logged
losing flips, presence and absence asserted both ways. Row R115.6 exists and cites the tag.

**The note-level ready-figure defect** was also fixed at both sites I named:
`chartGateDaysText`'s ready branch (11138) and the verdict line's ready branch (11205) now
render `era.days` — "7.1 of 7" in the fixture — and `[R115.3]`/`[R115.5]` are re-pinned
discriminating (they now REQUIRE 7.1 and FORBID the bare threshold form), so a regression to
"7 of 7" goes red. All three ready-era surfaces now render the same real figure.

**Corruption check.** A Grep context rendering showed `\*` where `/*` should be and `<\b>` for
`</b>` in the completed regions, which would have been a scripted-edit encoding defect. Read
on the exact lines shows correct bytes in every case, and `grep -c '<\b>'` and `grep -c 'Â'`
both return 0 in both staged files — display artifact of the search tool, not the files. No
defect.

**One note carried forward, not blocking:** `shadowByGate`'s inline exclusion (11885) and
`excCohortOk` are now two spellings of the same population predicate on two evidence streams.
Acceptable as-is because each side is held by its own branch-anchored discriminating assertion
(R114.2 and R114.3 — a drift on either side goes red), and the two streams' grounds are stated
independently; folding the gate read onto a shared predicate is a candidate cleanup when either
is next touched, not a return.

### Final verdicts

- **Repair 1: PASS** — both return grounds closed at the exact sites enumerated, with
  branch-anchored discriminating assertions and their rows; no defect introduced.
- **Repair 3: PASS** — the third reachable-remedy site is branched, the copy's mechanism claims
  are exact against the code, and the assertion discriminates both ways; no defect introduced.
- (Repair 2 stood PASS from round 1; the ready-figure note is now fixed and pinned.)

═══════════ staged suite report headers (full reports not archived — 167KB each; the ledger and PASS.md carry the results) ═══════════
--- staging/REPORT-staged-1200.txt ---
PROBE-PASS [STAGED: staging/index.html]
===PAIRING=== (REQUIREMENTS.md ↔ probe assertions, both directions)
PAIRING claimed by the run: 523 · row ids: 535 · cited tags: 523
PAIRING PASS — every reported tag has a requirement, and every cited assertion ran.
===SOURCE=== STAGED RUN - this report does NOT describe the working tree
--- staging/REPORT-staged-390.txt ---
PROBE-PASS [STAGED: staging/index.html]
===PAIRING=== (REQUIREMENTS.md ↔ probe assertions, both directions)
PAIRING claimed by the run: 523 · row ids: 535 · cited tags: 523
PAIRING PASS — every reported tag has a requirement, and every cited assertion ran.
===SOURCE=== STAGED RUN - this report does NOT describe the working tree
