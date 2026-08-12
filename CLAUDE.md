# CLAUDE.md

Single-file OSRS Grand Exchange flip tracker: `index.html` — no build step, no
dependencies, all client-side, localStorage persistence. Opening the file in a browser
*is* the app. Data comes from the RuneLite / OSRS Wiki real-time prices API, polled no
faster than 60s.

## Design philosophy (standing — user ruling, Aug 10 2026)

**Division of labor.** The machine verifies parts, traces requirements, audits
composition, grades its own accuracy, proposes its own restructurings, and surfaces
questions proactively on a schedule — noticing is buildable machinery, never the
user's job; their irritation must never be the detector. The user's non-delegable
job: ground truth from lived use, judgment of purpose, and rulings.

- **Every layer ships with a detector and a correction channel** — parts→probe suite,
  specs→REQUIREMENTS.md, composition→integration audit, judgment→scorecard. A
  component nothing can catch failing is unfinished even if it works.
- **The constitution accretes case law.** Near-misses become named, dated precedents
  (see the rulings below); write incidents down, don't just resolve them.
- **"Done" requires the integration exercise.** Verification milestones are not design
  milestones; "show me the audit" is answered with an audit, not a claim.
- Propose/dispose, attention-not-authority, metric honesty, realized-data-over-
  narrative, attention-cost complexity, adversarial-source, and human-handoff
  principles are codified in the sections below — they are instances of this
  philosophy, not exceptions to it.

## Product constitution (binding — do not soften these in code or copy)

- **The tool proposes and prefills; it never acts.** No flip is logged, no offer placed,
  no watchlist commitment made without an explicit user button press.
- **House convention (strategy layer):** strategy parameters — ceilings, floors, budgets,
  gates, tier bands, cluster caps — may be *proposed* in review copy but change only on
  the user's explicit instruction. Never self-apply.
- **Advisory layers stay advisory.** Scout, cluster discovery, audits, and verdicts queue
  candidates and recommendations; nothing caps or spends capital until the user ratifies.
- **The blacklist is the user's alone.** No automated path may admit, fund, quote, or
  clear an entry — not even a margin test.
- **Automated decisions show their work.** Every bench, clamp, and cap states its reason
  inline where the user reads it.
- **Every aggregate decomposes to its rows, in one click** (user ruling, Aug 11 2026).
  Any statistic, verdict, score, or summary the tool renders must open to the constituent
  rows that produced it — which items, which events, with the per-item evidence. A number
  that cannot be audited is a number that cannot be ruled on, and the operator's job here
  is auditing reasoning, not accepting conclusions. The collection layer has consistently
  outrun the display layer in this project: aggregates are cheap to build and expensive to
  use, so the drill-down is part of the feature, not a follow-up to it.
  **One primitive, not per-surface drill-downs** (Aug 11 2026): `drill(key, face, spec)` in
  `index.html` is the single implementation — sort, text filter, cohort selection and
  honest subset disclosure live in it, so a new aggregate inherits the expansion instead of
  re-earning it. Wrap the number at the point you render it; never hand-roll an expansion.
  When rows shown are fewer than the number counts, the primitive says so and why — a
  quietly truncated expansion is the defect, not a detail.
- **Every allocator-touched entity states where it stands** (user ruling, Aug 11 2026).
  An unexplained state reads as a broken feature even when the machinery underneath is
  correct — the F18 incident: held items passed all gates, appeared in no bucket, and
  made working auto-promote machinery feel press-gated. Funded, next-up, qualifying,
  benched, held, owned-elsewhere, hidden, skipped: each says so, with its reason, on the
  surface where it renders. The converse binds too: an element that cannot explain its
  presence on the screen does not render.
- Known repeated bug class: gates that re-punish what sizing already priced in
  (double-counting). Bench only on information the sizing/margin logic doesn't use.
- **Restraint may auto-arm; deployment never** (user ruling, Aug 10 2026). Defensive
  intel may act pre-ratification precisely because its only power is restraint — a false
  caution costs nothing (absence, lifted by one dismissal), a late defense costs whatever
  the pump extracts before the next walk-up. Anything that could DEPLOY capital stays
  ratification-gated. New features inherit this distinction.
- **The file is the press, and it presses in one direction only** (user ruling, Aug 12
  2026 — the *file-as-press* precedent). A `disposition` block arriving inside
  `intelligence.json` is the user's own press, because they carried the file and pressed
  Import: the handshake pattern already makes the carry a deliberate act, and requiring
  the same ruling twice would make the desk a place where decisions go to be re-entered.
  **But it is their press only for actions that DROP an advisory, never for actions that
  arm one.** Dismissal travels in the file; ratification requires a press in the tool.
  The reasoning is the restraint/deployment line applied to indirect consent: a
  dismissal removes a caution the user already read and judged, and its blast radius is
  bounded by what it stops doing, whereas a ratification arms a record that then tags
  items, can carry a sizing haircut, and can create calendar entries — so a mistake in
  the file, a stale copy, or a record the user never actually ruled on would ADD
  machinery rather than remove it. The asymmetry is enforced at import, not documented:
  `action: "ratify"` is ignored, and a dismissal with no stated reason is ignored too,
  because a dismissal without a why is not a record. Every applied disposition is
  decision-logged with an `auto` stamp, the reason, and the date the user ruled.
  **New consent channels inherit this shape**: whenever user intent reaches the tool by
  any route other than a press on the surface itself, that route may drop advisories and
  may not arm them.
- **A manipulation defense never relaxes on the manipulator's chosen evidence** (user
  ruling, Aug 10 2026). Recent wins during a pump are the bait, so wins never graduate a
  flagged pump caution; the only lift path is the user dismissing the warning record —
  nothing else.
- **Disclosure-in-summary is not ratification** (user ruling, Aug 10 2026). Judgment
  thresholds and verdict boundaries discovered mid-build are strategy parameters: propose
  them and leave them unapplied until the user rules. Applying one and mentioning it in
  the summary is a near miss, not compliance (the incident: entry-watch DISCOUNTED set to
  ≤ −2% in-flight; ratified after the fact).
- **The human carries the file** (handshake pattern — user ruling, Aug 10 2026). Where
  the browser and repo can't reach each other (`intelligence.json` in,
  `flags-pending.json` out), the human carries the file. This is architecture, not a
  workaround — do not propose sync infrastructure to replace deliberate human handoffs.
- **Feedback edges tune ATTENTION, never AUTHORITY** (closed-loop constitution — user
  ruling, Aug 10 2026). Learning loops (story-resolution signatures, lag profiles,
  scorecard priors, rulings digests, ramping triggers) may change what gets watched,
  flagged, and prioritized; gates, sizing, and deployment still move only by ruling.
- **Membership bookkeeping applies itself** (user ruling, Aug 11 2026 — **supersedes
  "membership never recomposes silently"**, R4.2b, which stood from Aug 10 2026).
  Coherence membership ADDS and the seed/sibling audits' KEEP / RETIRE / PRUNE
  recommendations now apply automatically at their existing evidence thresholds —
  persistence-gated, statistical-cap-respecting, blacklist-excluded. **The reason for the
  supersession:** membership is mechanical bookkeeping about correlation, not a capital
  decision; exposure caps and every gate still bind, so what changed is who presses, not
  what qualifies. Every application is decision-logged with an `auto` stamp, surfaces in
  the review's own "Applied automatically" block (decomposable to its rows like any
  aggregate), and is reversible by hand — an add from the basket's thesis detail, a
  retired lineage by re-seeding. PROMOTE stays manual: it names a thesis cluster, and a
  name is a judgment.
  **One carve-out, flagged rather than assumed:** coherence DROPS still queue for
  ratification. An add only *tightens* a basket's exposure cap, which is restraint and
  may auto-arm; a drop *loosens* one — it removes an item from the cap's scope, so the
  allocator may fund capital the cap was withholding. That is the restraint/deployment
  line, and moving it is the user's call. The drop's queue line states this where it
  renders.
- **Concur-recommended proposals skip the ruling ceremony** (user ruling, Aug 10 2026).
  A proposal that argues FOR keeping an existing rule against softer data is the correct
  default posture, not a decision point: flag it "concur-recommended", batch such entries
  under their own header in review copy, and keep them out of the rulings-pending count.
  The full ruling flow is reserved for proposals that want to change something.

## Surface map (Aug 11 2026)

Four tabs — Home, Trade, Sleeve, Review. Trade carries six sub-views: **Plan & Watchlist**,
**Scanner**, **Flip Log**, and the three pull surfaces added Aug 11 2026 — **Paper Book**
(regime curves, divergence ledger, per-gate outcomes), **Prospecting** (per-stratum map,
gap band, hours ledger, recipe basis) and **Gate Health** (two streams per gate, die-off
episodes, exception lane). The three present no rulings: they are read, not worked, so the
walk-up attention budget is untouched. The weekly review keeps a one-line summary of each
with a link through and no longer re-renders them — that consolidation is what paid for
them under the zero-based complexity budget.

**Each of the three carries an `⭳ export for analysis` button** (user-directed, Aug 12
2026), with a combined `export all three` in the weekly review — a curated JSON file
written to be READ by an analyst in chat, carrying evidence with its provenance rather
than the aggregates it rolls up to. It is **not** the state backup on the Flip Log tab:
that one restores this browser, this one is capped, readable and never a restore point.
Every export states in its header what was in force (epoch, counts by cohort / grade /
horizon, constants, standing caveats) and exactly what it truncated — a file too big to
paste is useless, and one that truncates silently is worse. Observation-floor exclusions
travel INCLUDED and marked: the floor gates verdicts, never the record.

## Naming: the PAPER book (renamed Aug 11 2026 — user ruling)

The counterfactual book is the **paper book** everywhere: surfaces, tooltips, copy,
docs, and audit reports from here on. The rename removes a collision with the **Shadow
Fund** (the Tumeken's Shadow savings target), which keeps its name along with the
`shadow reserve` setting — those are real capital, not simulation. "Paper" also states
the ruled epistemic status: screening evidence, never a verdict. The row dot keeps its
glyph identity (circle-in-circle) but its tooltip and the legend read "Paper screen: …".

Two things deliberately were NOT renamed, so nothing silently breaks:
- **Persisted keys and code identifiers** (`DB.shadowBook`, `shadowDivLog`,
  `shadowExceptions`, `shadowEpoch`, `shadowPartPct`, `shadowTick`, `shadowScan`,
  `shadowDot`, …). Renaming a persisted key would orphan the user's existing store
  without a migration, and the rename was scoped "where cheap". Read `shadow*` in code
  as the paper book, except `shadowReserve` / `shadowItem` / `renderShadow`, which are
  the Shadow Fund.
- **Historical records.** Prior audit reports and decision-log entries use the old term;
  they are left as written so past records stay readable and internally consistent.

## Definitions protocol (metric honesty — user ruling, Aug 10 2026)

When the user asks what a metric measures, the standing rule is **answer first, build
later**: state exactly what the current code computes (not what it was meant to compute),
show one concrete data row as proof, flag known biases unprompted, and propose
corrections without applying anything until the user rules. The house standard for every
metric: **realized quantities only** — actual logged round trips, tax netted; no
counterfactual fills, no price drift counted as missed profit — and where a signal could
flatter the machine's own case (e.g. a "gate too tight" verdict), the copy must claim
exactly what is measured and no more. Gate health is the reference implementation:
"traded while still benched" (the user overrode the gate — clean evidence for or against
it) is never conflated with "traded after unbenching" (re-admission latency only — the
gate eventually agreeing with itself is not the user being right against it).

## Case law: the Jul 24 volume artifact (user ruling, Aug 12 2026)

**A data-feed methodology change was read as market signal for four sweeps.** On
2026-07-24 reported GE volume stepped ~5–7× across the entire market at once —
nature runes, sharks, ranarr, coal, dragon boots, uncut sapphire — with prices
flat. Nothing had happened in the game. The accumulation-anomaly scan compares
each item's recent volume against its own volume 2–3 weeks earlier, so every
baseline straddling that date showed a several-hundred-percent gain, and the scan
duly raised seven flags reading "+418%", "+546%", "+930%". Four of them went to
the analyst desk for up to four sweeps hunting a story that did not exist,
generating watch-notes and a suspected-pump escalation off a number that measured
the API. Normalised against a control band, not one flagged item showed
item-specific volume growth; three were *below* market.

**The rule: a detector that compares an item to its own past must be normalised
against a market-wide control, because a feed change moves every item at once and
looks like news on each of them individually.** Self-comparison cannot distinguish
"this item moved" from "the ruler changed length". The fix is `VOL_INDEX_BASKET`
in `index.html` — eight liquid items chosen for having nothing to do with each
other — and the volume term is now item-relative-to-index. The interim
cross-break suppression is **date-driven and self-expiring**: it stops firing once
baselines clear 2026-07-24, with no flag day to remember.

Three corollaries, each of which cost something here:

- **Suppression means not flagged, not flagged-on-half.** The accumulation
  signature is price AND volume; with the volume leg unreadable the honest answer
  is "cannot tell", and flagging on price alone invents the missing half.
- **A detector's own denominator is an aggregate and decomposes like any other.**
  The index's one failure mode — a future update moving the whole basket together
  — is visible only in its control rows, so the panel opens to them.
- **Corrections must reach the tool, not just the brief.** Withdrawing the
  contaminated numbers exposed a second defect: re-importing an already-ratified
  record was silently absorbed, so eleven corrected records would have left the
  wrong numbers on screen while the brief claimed they were fixed. Shipping a
  correction means shipping the path by which it lands.

## Case law: the never-fed aggregate (user ruling, Aug 12 2026)

**A stat that renders 0 because nothing FEEDS it is indistinguishable, on screen,
from a stat that renders 0 because nothing QUALIFIED — and the two mean opposite
things.** The regime race, the machinery that exists to answer whether the 1.2%
ROI floor is right, spent an entire epoch reporting three zero curves and a
two-day all-zero divergence ledger while not one of 272 paper trips had ever been
assigned to a regime. Four of the six entry paths hardcoded an empty set instead
of evaluating, and in that epoch those four were 96% of the book. Nothing said so.

This is the same class as the silent-unfunded-state defect (F18): **a component
reporting nothing where it should report that it HAS nothing.** The rule:
an aggregate whose input population is empty says so, in its own words, instead
of rendering a zero. Membership in a race like this must be a property of the
CANDIDATE, evaluated once centrally, never a label that individual entry paths
remember to attach.

Three companions found in the same review, each worth its own line:

- **Causality in a simulator is not optional.** The fill model credited a leg
  from a trailing five-minute aggregate on the leg's first tick, and re-credited
  the same bucket every poll — 182 of 272 trips opened and closed in under a
  second (median 55ms), all "filled", booking 52% of the headline net from tape
  that printed before they existed. A simulated leg may only be filled by tape
  that printed after it was placed, each bucket counted once, and a trip that
  resolves in its opening cycle is a bug rather than a fill.
- **A rate needs its counterexample count.** "Fill rate 100%" appeared on every
  stratum and every hour, and `neverFilled` was 0 in every per-gate rollup — a
  model built on the premise that would-never-have-filled is the finding half the
  time was finding it never. Every rate now renders its counterexample count, so
  100% reads as a claim about zero counterexamples rather than as a default.
- **A ratio whose denominator is filtered by its own numerator is not a ratio.**
  The per-stratum sampling counter sat after the near-miss filter, so it counted
  only items that had already qualified: near-misses were 577 of 578 sampled
  items, 100% by construction, and contradicted the funnel's own attribution.
  Count the population where the test runs, not where it passes.

## Complexity governance (standing — user ruling, Aug 10 2026)

- **Attention budget as a probe.** The walk-up targets ≤2 min of rulings, enforced by
  instrumentation: the walk-up surface reports its distinct-decision count, and the
  probe suite asserts it stays **≤ 7**. A new surface that would breach the budget must
  displace something, not stack. Every feature proposal states its walk-up attention
  cost. Weekly review reports the trend.
- **Usage-based pruning.** Feature touches (panels opened, buttons pressed, settings
  changed) are instrumented per 30 days. Quarterly, the review renders a DORMANCY
  report: features untouched in 90 days are proposed for demotion — collapsed behind a
  "more" disclosure, not deleted (code is cheap; screen space and mental inventory are
  not). Demotions are ratified like anything else.
- **Feature freeze with a price tag.** Every new capability proposal (the agent's
  included) answers in one line: "what existing surface does this replace or absorb?"
  Additive-only proposals get the ledger-will-make-the-case treatment. The complexity
  budget is zero-based: growth is paid for in consolidation.

## Integration audit (standing discipline — user ruling, Aug 10 2026)

Run by the agent **after any week containing a build session; skip after pure-usage
weeks** (integration debt accrues at build speed — cadence tied to activity, not the
calendar; user ruling, Aug 10 2026), and on the user's demand. Distinct from probes
(parts work) and friction review (reported pain): this hunts **unreported composition
defects**.

1. **Workflow walks:** trace each real workflow end-to-end through the actual code
   paths — walk-up, briefing cycle, sleeve entry-to-exit, weekly review — and for every
   surface touched answer: what feeds it, what does it feed, when in the workflow does
   it earn its render. Any missing answer is a finding.
2. **Orphan scan:** every panel, queue, record type, and setting gets a connectivity
   check — who writes it, who reads it, what decision changes because it exists.
   Write-only data and read-never surfaces are findings.
3. **Redundancy scan:** concepts implemented twice under different names (cluster
   baskets vs catalyst item-links was exactly this) — propose merges.
4. **Glossary-coverage scan** (user ruling, Aug 11 2026): every term, badge, tag,
   indicator, metric, gate name, record type and status string the tool renders is
   checked against the glossary. **A term rendered without an entry is a finding.** The
   glossary is a data structure (`GLOSSARY` in `index.html`), so the scan is mechanical:
   gate names are checked against `gateName()`'s own returns, and each entry must carry
   all three fields. Findings also include an entry whose "what it should change for
   you" line is missing, and one that hedges to "nothing directly" without naming the
   decision it is context for — that hedge marks a **deletion candidate**, and surfacing
   those while writing is part of the scan's job.
5. **Interrogability scan** (user ruling, Aug 11 2026): for every aggregate, statistic,
   verdict, score, or summary the tool renders, check that it opens to its constituent
   rows in one click — which items, which events, with the per-item evidence behind the
   number. Findings are: any number that cannot be opened; any expansion showing a subset
   without saying so; any verdict whose stated reason doesn't name the specific items or
   thresholds behind it; and any surface reporting a conclusion where the underlying rows
   would teach more than the conclusion does. **This is distinct from the orphan scan** —
   a surface can be fully connected, reading real data and feeding real decisions, and
   still be opaque. Connected-but-unauditable is a finding.
6. **Output:** a findings report with proposed restructurings, ruled like everything
   else. No findings is a valid result and says so.

## Verification

No Node on the dev machines. All verification runs as headless-Edge probes against the
real app with synthetic market data, reporting over a loopback beacon.
**The complete workflow, prerequisites, and troubleshooting live in [PROBE.md](PROBE.md).**

```bash
bash tools/probe/run.sh   # exit 0 = PROBE-PASS
```

Run the suite after any nontrivial change to `index.html`, and extend
`tools/probe/probe-snippet.html` alongside new features.
**Scoping rules are tested by absence** (user ruling, Aug 11 2026): a rule about
where something renders is only verified by asserting where it must NOT appear —
existence assertions (`querySelector` finds hidden elements) passed for a full day
while a CSS specificity bug rendered Home's blocks on every tab. Assert computed
visibility (`offsetParent`, `getComputedStyle`) on the surfaces that must be clean.

### A test that cannot fail is a liability, not a test (user ruling, Aug 11 2026)

A green suite is a claim, and an assertion that cannot fail makes that claim falsely.
Worse than no test: it occupies the slot where a real one would have gone, and it
reports the feature as covered. Four named instances, all shipped green:

- **The `|| true` assertion** (Aug 11 2026): a probe line ending `… || true`, written
  to check the poll calls the accrual step. It passed unconditionally and asserted
  nothing whatever.
- **The R29.4 durability detector** (Aug 11 2026): it seeded a closed record, rolled it,
  *then* aged it past the retention window — so it passed whether the roll happened
  before or after the prune, which was the entire property under test. Rewritten to
  start from a record already past the window; only then could it fail.
- **The R22.2 scoping assertions**: `querySelector` existence checks pass on hidden
  elements, so a CSS specificity bug rendered Home's blocks on every tab for a full day
  behind a green suite. Fixed by asserting computed visibility where it must be absent.
- **The R24.2 landing assertions**: "target top in viewport" passed with the title
  hidden under the sticky header — which is precisely how the offset bug shipped green.
  Fixed by asserting the first VISIBLE title sits below the chrome's bottom edge.
- **The intermittent assertion is the same liability** (user ruling, Aug 11 2026). A test
  that fails at random teaches the operator to ignore failures, which is the same damage
  as a test that cannot fail. The incident: `[R18.1]` compared the whole paper book's
  length across a rescan, folding the dedup rule it claimed to test together with the
  discovery slice's draw — whose family key embeds the first-failing gate and whose
  stratum comes from the price cycle, both functions of the clock. It failed in roughly
  1 run in 7. **The fix is never to pin the ambient input** — pinning the fixture clock
  would have traded a flaky assertion for a silently-wrong one everywhere `S.latestAt`
  carries staleness meaning. Instead: inject the varying input for the fixture, or assert
  the property that holds across all of its values; and if neither is possible, the
  assertion is testing the varying mechanism rather than the behavior it claims, so split
  it in two. `[R18.1]` now asserts the plan-driven families exactly and the invariant that
  holds under every stratum ("no family is open twice"), while rotation is tested on its
  own with the cycle injected. Instrumentation that makes a failure name its own cause
  stays even once the flake is gone.
- **The simultaneity assertion** (Aug 12 2026), a second instance of the same class,
  found by accident while seeding an unrelated defect. `[R40.1]` compared
  `planHorizonH()` against `gapHoursAt(Date.now())` with a tolerance of `1e-9` hours —
  3.6 microseconds. `planHorizonH()` reads the clock internally, so the assertion was
  comparing TWO SEPARATE CLOCK READS and passed only when both landed in the same
  millisecond; any millisecond boundary between the calls failed it. It had been green
  for a day. Split per the ruling: the BEHAVIOUR is tested at one injected instant
  against a bound derived from how the fixture builds its schedule, and the WIRING
  ("planHorizonH is that gap, taken now") keeps a tolerance of 3.6 *seconds* — which is
  what "two reads moments apart" actually claims. A tolerance tight enough to assert
  clock-simultaneity is testing the clock, not the behaviour.

- **The assertion that re-implements what it tests** (user ruling, Aug 12 2026) — the
  fifth distinct way this suite has found itself lying, alongside `|| true`, the detector
  that could not fail, presence-vs-absence, and DOM-position-vs-visible-position. A probe
  asserted that the per-stratum sampling counters summed correctly — but it computed the
  counts itself, in the probe, rather than calling the production path. It passed with
  the bug fully intact in `index.html`, because the bug was in code the assertion never
  touched. **Assertions call production code; they never carry a parallel implementation
  of the thing under test.** The fix pattern is the `strataCount()` extraction: when the
  logic under test is buried inside a closure the probe cannot reach, EXTRACT it into a
  named function and point the assertion at that — do not reproduce it in the probe. A
  test that re-derives the answer is testing your arithmetic twice and the product zero
  times. The tell is a probe line that computes rather than calls.
  **It recurred within the day** (Aug 12 2026), on the calibration harness: the probe
  built its own replay window instead of calling the anchoring code, so seeding the
  anchor defect changed nothing the suite could see. Extracted as `calibWindow()` and
  `calibSummarise()` and re-seeded before it counted as proof. Two instances in one day
  means the tell is worth checking on every new assertion, not just when something feels
  off: **if a probe line constructs an input the product would have constructed, the
  product's constructor is untested.**
- **Dead safeguards and dead seeds** (user ruling, Aug 12 2026) — the sixth entry, and
  the one that generalises the others. Three instances, one root: **a green result can
  mean the test never ran.**

  **A guard whose trigger condition cannot be reached by its own upstream limits is not
  protection — it is decoration that reads as protection.** The calibration export
  trimmed any trace over 60 buckets to its first and last 20, a rule written into the
  requirements and rendered in the file's own truncation notice. The stored trace cap
  was 24. The trim could never fire. Nothing was wrong with either number in isolation;
  the defect lived in the relationship between them, which no single reading of either
  file would surface. The same shape appeared twice in one build: the export also
  carried a defensive fallback for an empty duration bucket while `calibSplit()` already
  guaranteed both groups, so the fallback was unreachable. **The fix is not always to
  make the guard reachable** — for the trim, the stored cap was raised so the rule has
  work to do; for the fallback, the dead branch was deleted and the assertion pointed at
  the upstream guarantee instead. Choose by asking which layer should own the promise,
  then make sure exactly one does.

  **A seeded defect that lands on unreachable code produces a passing assertion that
  proves nothing, and on the report it is indistinguishable from real proof.** Seeding
  the dead fallback above changed no behaviour, so the suite stayed green — which reads
  exactly like "the assertion is weak" and is in fact "the code you broke never runs".
  **Standing tell: when seeding a defect, first confirm the modified line executes at
  all. If the seed changes no observable behaviour, establish whether the code is dead
  BEFORE concluding the assertion is weak.** A seed is only proof once you have seen it
  bite.

  **And two defects can hide each other.** Seeding the ambiguous-reachability widening
  and the reconstruction touch-history rule together (commit `f8a0a73`) left the
  reconstruction assertion passing: with the widening removed, passing a touch into a
  rule that ignores touches changes nothing, so the second defect had no way to express
  itself. Neither seed was wrong; their interaction was. **Seed one defect at a time,
  and when a batch is unavoidable, re-run any assertion that did not fail in isolation
  before counting it as proven.**

  All three are the reimplementation trap's siblings: in each, the assertion reported a
  pass without ever exercising the thing it names.

**Standing practice: prove every new assertion by seeding the defect it is meant to
catch, watching it fail, then restoring green.** An assertion that has never failed is
unproven, and "it passes" is not evidence that it *can* fail. This applies to every new
assertion, not only to detectors written for a known bug — the R29.4 case was a detector
written for a defect that still slipped through, because the fixture was built so the
defect could not express itself.

### Every user-visible term ships with its glossary entry (user ruling, Aug 11 2026)

Same discipline as REQUIREMENTS.md rows: **a new term, badge, tag, indicator, metric,
gate name, record type or status string ships with its glossary entry in the SAME
commit** — never one without the other. The glossary is the `GLOSSARY` data structure in
`index.html`, grouped by area; an entry states three things and the third is the one that
makes it a glossary rather than a dictionary:

- **what** it means, **from** what produces it, and **do** — what decision it should
  change for the user. Where the honest answer is "nothing directly", the entry says so
  *and names the decision it is context for*. A term that changes no decision and is
  context for none is a **deletion candidate**, and writing the entry is how those get
  found.
- Known caveats ride the entry, not a footnote: paper-book quarantine status, stratum
  approximation, markout attribution lean, observed-share limits.
- **The entry also renders inline, as a popover on the term itself** (ruled Aug 11 2026):
  hover on desktop, tap on touch, same content from the same entry — one source, two
  presentations, so a definition cannot drift. Two restraints, both learned from use:
  mark terms with a dotted underline and nothing else (the indicators carry state, the
  underlines carry vocabulary), and **never gloss a control that already delivers its own
  intel** — a chip whose press opens the explanation, or a line that already renders its
  reason. Gloss vocabulary, not affordances.
- Gate names are registered by listing them in their family entry's `names` array, which
  is what makes them tappable from a bench reason; `[R38.2]` asserts every name
  `gateName()` can return has a home, so an unglossed gate fails the suite.

Ruled requirements live in
[REQUIREMENTS.md](REQUIREMENTS.md) with stable IDs; probe assertions carry `[R#]` tags
and the report's `===REQS===` section cross-references them — when adding a gated
feature, add its requirement row and a tagged assertion together, never one without
the other.

## Repo hygiene

- Commit only under the repo-configured anonymized identity (`git config user.name` /
  `user.email` in this clone) — never a personal name or email.
- `ge-flipping-guide.md` and `cleanup.html` are gitignored on purpose (personal); don't
  force-add them.
- The site deploys via GitHub Pages from `main` — pushing `main` is publishing.
- The flip log lives only in the user's browser localStorage; nothing in this repo ever
  contains user trading data.

## Cadence: four touches, per-touch horizons (user ruling, Aug 11 2026)

The day is not uniform and neither are the horizons. `DB.touchWindows` (four editable
hours-of-day, default 07:00 / 12:00 / 17:00 / 21:30) gives gaps of **5.0 / 5.0 / 4.5 /
9.5h**, and **every placement sizes and prices for the gap until the NEXT touch**. There
is no global fill horizon any more: `FILLH()` *is* the schedule's gap, and
`DB.fillHorizonH` survives only as the fallback for an explicitly empty schedule ("no
cadence kept").

- **Two strategies fall out by construction, not by instruction.** A daytime placement can
  only fund what fills in ~5h, so it favours fast cyclers; the evening placement has ~9.5h
  and can carry the slower, thicker items a short gap must bench. The bench line says so —
  "qualifies at the evening touch — needs ~7h" — because an item that would fund tonight is
  information the old single-horizon plan simply lost.
- **A leg ages against the horizon it was PLACED under** (`hzH` stamped on positions, quote
  records and paper trips). A leg placed at the evening touch is mid-sit at 05:00, not
  stale. Never retro-apply a horizon change to an open leg.
- **Absence-tolerant by construction**: everything derives from "now → next window", so a
  missed touch means the next window is further away and the following horizon stretches.
  Nothing to reset.
- **Horizon shape and evidence grade are GROUPING dimensions, not filters.** A finding that
  holds at 5h and not at 9.5h is a *horizon* finding, not a gate finding, and a filter
  defaults to hiding exactly that. `shadowByGate()` stays keyed by gate for the verdict
  machinery and takes a flag for the split view, so the two can never disagree.
- **Reconstruction is a backstop, not a substitute.** After an observation gap each open
  trip's 5m series is replayed under the live fill rules; observation credit is SERIES
  COVERAGE (a bucket with data is five observed minutes, a bucket without credits nothing),
  provenance is stamped live/reconstructed/mixed, and an aggregate resting only on
  reconstructed evidence says so. Forced exits price at the series value AT the horizon —
  the proper fix for the defect that caused the epoch reset, and correct on a perfect host
  too.
- **Cadence is not edge.** Gates, floors, reserve and budgets are untouched by a schedule
  change, and the walk-up attention budget still binds at ≤ 7.
- When a metric's denominator changes because the cadence changed, **show both sides**: the
  equity panel reports gp/day beside gp/attention-minute and states the change in place, so
  a fall in the rate is not read as a fall in the trading.
