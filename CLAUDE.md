# CLAUDE.md

Single-file OSRS Grand Exchange flip tracker: `index.html` — no build step, no
dependencies, all client-side, localStorage persistence. Opening the file in a browser
*is* the app. Data comes from the RuneLite / OSRS Wiki real-time prices API, polled no
faster than 60s.

## How a ruling is written (prophylactic — user ruling, Aug 12 2026)

> **When writing a ruling, name the property first; list the surface only as the example
> that produced it. The incident is the example; the reasoning is the rule.**

This governs every rule below and every rule added after it. The constitutional scope
audit that produced it found the recurring failure: most rules here named the SURFACE
where a defect was found rather than the PROPERTY that was violated, so the same defect
recurred on the next surface and escaped a rule that had already been written about it.
The never-blend ruling is the worked example — written about a *rate*, it did not reach
a pooled *median* three days later. Ten rules were widened on Aug 12 2026; each carries
the escaping instance that motivated the widening, because the instance is what proves
the old wording was too narrow.

Two structural consequences of the same audit:

- **The constitution is split into BINDING and DOCTRINE below.** A rule that looks
  enforceable and isn't is the same defect class as a detector that cannot fire: it
  occupies the slot where a real rule would have gone and reports the property as
  covered. BINDING entries are mechanically checkable and their violations are audit
  findings. DOCTRINE entries are practices for which no test exists, and are not audited.
- **A widened rule with no detector is a DOCTRINE entry wearing BINDING clothes.** When a
  rule is widened, the audit scan that checks it is extended in the same commit, or the
  rule moves to DOCTRINE.

## The two layers, and the bar between them (user ruling, Aug 13 2026)

[MISTAKES.md](MISTAKES.md) is the **evidence layer**: every incident on record, newest
first — what happened, root cause, consequence, the rule that would prevent a repeat.
This file is the **law layer**. The bar between them:

> **An entry in MISTAKES.md is eligible for BINDING when it has recurred THREE times, or
> ONCE with a mechanical detector. Everything else stays evidence.**

The two limbs answer different questions and neither substitutes for the other. **Three
occurrences** is evidence that the SHAPE is real rather than that one incident was
memorable — the thing that makes a rule worth its slot is recurrence, and a defect that
has happened once is a story. **One occurrence plus a detector** is enough on the other
path because a rule something can mechanically catch costs nothing to keep, cannot rot
into a preference, and its violations are findings rather than opinions; the detector is
what the BINDING section is actually for.

**Eligibility is not promotion.** Entries move on the user's ruling, never automatically:
promoting a rule widens what the constitution enforces, and a rule that widens its own
scope is the machinery arming itself. The agent reports eligibility against the counts;
the user rules.

**Every entry standing in BINDING today predates this rule** and was promoted informally
— at whatever point the defect seemed important enough at the time. The backfill audit of
Aug 13 2026 (`MISTAKES.md`, and the report accompanying it) checks the standing list
against this bar in **both** directions — entries resting on a single instance with no
detector, and patterns with three or more instances that never became a rule — and
reports the mismatches without reclassifying anything.

---

# BINDING

Mechanically checkable — by a probe assertion, or by a named integration-audit scan that
reads code and copy against a stated rule. **Violations are audit findings.** Do not
soften these in code or copy.

- **The tool proposes and prefills; it never acts.** No flip is logged, no offer placed,
  no watchlist commitment made without an explicit user button press.
- **House convention (strategy layer):** strategy parameters — ceilings, floors, budgets,
  gates, tier bands, cluster caps — may be *proposed* in review copy but change only on
  the user's explicit instruction. Never self-apply.
- **Advisory layers stay advisory — except where a ruling has explicitly superseded it.**
  Scout, cluster discovery, audits, and verdicts queue candidates and recommendations;
  nothing caps or spends capital until the user ratifies. **Superseded in exactly one
  place (user ruling, Aug 11 2026):** coherence membership ADDS and the seed/sibling
  audits' KEEP / RETIRE / PRUNE recommendations self-apply at their existing evidence
  thresholds — see *Membership bookkeeping applies itself* below for the reasoning, the
  decision-log requirement, and the carve-out that coherence DROPS still queue. The
  advisory default holds everywhere the supersession does not name; the two rules are
  read together, and neither is to be quoted alone.
- **The blacklist is the user's alone.** No automated path may admit, fund, quote, or
  clear an entry — not even a margin test.
- **Every automated decision states its reason inline where the user reads it** (widened
  Aug 12 2026 — the previous wording enumerated "every bench, clamp, and cap", and the
  enumeration was read as the scope). Escaping instances: auto-applied coherence
  membership adds, and auto-voided die-off episodes — neither is a bench, a clamp, or a
  cap, so neither was covered by a rule that plainly meant to cover them.
- **Never pool a statistic across populations that answer different questions** — rate,
  median, count, verdict or score alike (widened Aug 12 2026; the Aug 12 wording said
  "never blend a *rate*", which itself generalised an Aug 11 rule written about *net*).
  **The pooled figure may render only ALONGSIDE its decomposition** — beside it on the
  page, not merely inside an expansion the reader has to open. `rateBlend()` in
  `index.html` is the sanctioned renderer for a rate; it emits the blend and the split
  together so a caller cannot produce the first without the second.
  The original incident: paper trips filled at "a median 37% of intended size", which
  read as a book-wide sizing problem. Split by cohort it was watchlist 100%, scanner 37%,
  discovery slice 8.3% — the items closest to fundable fill completely, and the low figure
  was four populations averaged.
  Escaping instances that forced the second widening, both live findings as of Aug 12
  2026: `paperEconomics`' **median trip net** pooled across four cohorts, and
  calibration's **median share credited when wrong** pooled across fast and slow legs.
  Neither is a rate, so the rate wording did not reach them.
  **The general lesson, which is why the prophylactic above exists: when a ruling names a
  quantity, check whether it is really about the quantity or about the shape.**
- **Any statistic, verdict, score, or summary must open to, or ship with, its constituent
  rows — on screen, in an export, or in any artefact handed to a reader** (widened Aug 12
  2026; the previous wording said "renders … in one click", which bound the screen only).
  Which items, which events, with the per-item evidence. A number that cannot be audited
  is a number that cannot be ruled on, and the operator's job here is auditing reasoning,
  not accepting conclusions. The collection layer has consistently outrun the display
  layer in this project: aggregates are cheap to build and expensive to use, so the
  drill-down is part of the feature, not a follow-up to it.
  Escaping instance: the three analysis exports carry per-gate rollups, bound summaries
  and the volume index as bare numbers — they ship rows only by the author's choice, not
  by rule, because a rule about clicks says nothing about a file.
  **One primitive, not per-surface drill-downs** (Aug 11 2026): `drill(key, face, spec)`
  is the single on-screen implementation — sort, text filter, cohort selection and honest
  subset disclosure live in it, so a new aggregate inherits the expansion instead of
  re-earning it. Wrap the number at the point you render it; never hand-roll an expansion.
  When rows shown are fewer than the number counts, the primitive says so and why — a
  quietly truncated expansion is the defect, not a detail. An artefact obeys the same rule
  in its own idiom: rows carried with the number, and every truncation declared.
- **No claim may be made about a period that was not observed. Any denominator counting
  time or occasions must count only observed ones, and state its coverage** (widened Aug
  12 2026; previously this lived only as the paper book's series-coverage rule, which
  bound reconstruction and nothing else).
  Escaping instance: `daysBenchedBy(id, gate, 7)` drove gate-persistence proposals reading
  "benched by this gate on 4 of the last 7 days" with a denominator of 7 even when the app
  was closed for three of them. The numerator was always honest — a ledger row exists only
  on a day a plan actually built — so the defect was the denominator claiming a period
  nothing had looked at. The 4-of-7 bar is the standard that moves gate constants, and a
  standard must not be read against an inflated window. Fixed Aug 12 2026:
  `observedDaysIn()` is the ledger of days a plan actually built, `daysBenchedBy()` returns
  the pair `{n, obs}` so no caller can render the numerator without its coverage, and the
  copy states the unobserved remainder explicitly. Where coverage puts the bar out of
  reach, the surface says so rather than reporting "no persistence" — a never-fed
  aggregate, not a reading of zero.
- **Every entity the user can see states where it stands, and why** (widened Aug 12 2026;
  previously "every *allocator-touched* entity", which excused everything the allocator
  does not touch). An unexplained state reads as a broken feature even when the machinery
  underneath is correct — the F18 incident: held items passed all gates, appeared in no
  bucket, and made working auto-promote machinery feel press-gated. Funded, next-up,
  qualifying, benched, held, owned-elsewhere, hidden, skipped: each says so, with its
  reason, on the surface where it renders. The converse binds too: an element that cannot
  explain its presence on the screen does not render.
  Escaping instance: a paper trip in the unobserved state renders as a hole with no
  explanation — the paper book is not allocator-touched, so the old wording let it through.
- Known repeated bug class: gates that re-punish what sizing already priced in
  (double-counting). Bench only on information the sizing/margin logic doesn't use.
- **Restraint may auto-arm; deployment never — and REMOVING a restraint counts as
  deployment, whether by action, by expiry, or by a rule change. Anything that widens what
  the allocator may fund is the user's press** (widened Aug 12 2026). Defensive intel may
  act pre-ratification precisely because its only power is restraint — a false caution
  costs nothing (absence, lifted by one dismissal), a late defense costs whatever the pump
  extracts before the next walk-up. New features inherit this distinction.
  Escaping instance: intel records auto-expire at `validUntil`, so a promotion-warning or a
  watch-note lifted with no press at all — the old wording covered *arming* a deployment and
  said nothing about a caution ending by the calendar. **Audited and fixed Aug 12 2026**
  (`audits/AUDIT-2026-08-12-scope.md` §4): a ratified caution now **lapses** rather than
  lifting — it keeps applying and asks once, batched, on the walk-up — while context records
  (catalysts, demand-context) still expire on the calendar, because they restrain nothing
  and so nothing is deployed when they end. **Pump-defense records do not lapse at all**,
  closing a direct contradiction: the standing rule says a flagged pump caution lifts on one
  path, the user's dismissal, "nothing else", and *four* calendar paths contradicted it —
  expiry, the pending sweep, the 30-day staleness broom, and the anomaly leg's own window,
  which let a fired defense un-fire as its evidence aged. Evidence ageing is not evidence
  against. **The bulk action is the restraining one:** "extend all" is offered, "drop all"
  deliberately is not, because a lift is a per-item judgment.
- **The file is the press, and it presses in one direction only** (user ruling, Aug 12
  2026 — the *file-as-press* precedent). A `disposition` block arriving inside
  `intelligence.json` is the user's own press, because they carried the file and pressed
  Import: the handshake pattern already makes the carry a deliberate act, and requiring
  the same ruling twice would make the desk a place where decisions go to be re-entered.
  **But it is their press only for actions that DROP an advisory, never for actions that
  arm one — and a channel may carry no strategy-parameter change at all; those move only
  on an explicit in-tool ruling** (final clause added Aug 12 2026). The reasoning is the
  restraint/deployment line applied to indirect consent: a dismissal removes a caution the
  user already read and judged, and its blast radius is bounded by what it stops doing,
  whereas a ratification arms a record that then tags items, can carry a sizing haircut,
  and can create calendar entries — so a mistake in the file, a stale copy, or a record the
  user never actually ruled on would ADD machinery rather than remove it. The asymmetry is
  enforced at import, not documented: `action: "ratify"` is ignored, and a dismissal with
  no stated reason is ignored too, because a dismissal without a why is not a record. Every
  applied disposition is decision-logged with an `auto` stamp, the reason, and the date the
  user ruled.
  Escaping instance for the final clause: a settings or config block changing the ROI floor
  neither drops an advisory nor arms one, so the two-direction wording did not classify it
  at all — and a parameter that arrives in a file has been ruled on by nobody.
  **New consent channels inherit this shape**: whenever user intent reaches the tool by any
  route other than a press on the surface itself, that route may drop advisories, may not
  arm them, and may never move a strategy parameter.
- **A manipulation defense never relaxes on the manipulator's chosen evidence** (user
  ruling, Aug 10 2026). Recent wins during a pump are the bait, so wins never graduate a
  flagged pump caution; the only lift path is the user dismissing the warning record —
  nothing else.
- **Disclosure-in-summary is not ratification** (user ruling, Aug 10 2026). Judgment
  thresholds and verdict boundaries discovered mid-build are strategy parameters: propose
  them and leave them unapplied until the user rules. Applying one and mentioning it in
  the summary is a near miss, not compliance (the incident: entry-watch DISCOUNTED set to
  ≤ −2% in-flight; ratified after the fact).
- **Shipping a correction means shipping the path by which it lands, for any artefact the
  user has already read** (widened Aug 12 2026; previously scoped to intelligence records,
  where the defect was found). Withdrawing contaminated numbers from a brief exposed the
  original: re-importing an already-ratified record was silently absorbed, so eleven
  corrected records would have left the wrong numbers on screen while the brief claimed
  they were fixed.
  Escaping instances: a corrected glossary entry and a revised requirement row have no
  landing path at all — the user read them once and nothing tells them the words changed.
  **⚠ FLAGGED: this entry is weaker than its BINDING placement implies** (user ruling,
  Aug 12 2026). The Aug 12 detector review found no mechanical check for the general
  case; per-instance probes exist and nothing enforces the rule itself. It stays BINDING
  with this flag attached and **the next integration audit gets exactly one attempt** to
  make it mechanical. The candidate detector, to be tried: *every artefact type the user
  has read — glossary entry, requirement row, intel record, brief — has a defined update
  path, enumerated*, the same enumerate-then-check shape that made the restraint-lift
  scan work. **If that audit cannot produce a check, this moves to DOCTRINE without
  further argument** — a rule that keeps failing to acquire a detector is the thing the
  BINDING/DOCTRINE split exists to expose, and arguing for it a second time would be the
  defect defending itself.
- **Metric honesty.** Every metric reports **realized quantities only** — actual logged
  round trips, tax netted; no counterfactual fills, no price drift counted as missed
  profit — **and every metric's rendered copy claims exactly what it computes, asked or
  not** (final clause added Aug 12 2026: the rule was previously written as the
  *definitions protocol*, a response procedure triggered by the user asking, which did not
  bind copy written unprompted). Where a signal could flatter the machine's own case (e.g.
  a "gate too tight" verdict), the copy claims exactly what is measured and no more. Gate
  health is the reference implementation: "traded while still benched" (the user overrode
  the gate — clean evidence for or against it) is never conflated with "traded after
  unbenching" (re-admission latency only — the gate eventually agreeing with itself is not
  the user being right against it). The response half of the protocol stands: see
  *Definitions protocol* below.
- **Feedback edges tune ATTENTION, never AUTHORITY** (closed-loop constitution — user
  ruling, Aug 10 2026). Learning loops (story-resolution signatures, lag profiles,
  scorecard priors, rulings digests, ramping triggers) may change what gets watched,
  flagged, and prioritized; gates, sizing, and deployment still move only by ruling.
- **Membership bookkeeping applies itself** (user ruling, Aug 11 2026 — **supersedes
  "membership never recomposes silently"**, R4.2b, which stood from Aug 10 2026; and see
  the advisory-layers entry above, which names this supersession explicitly rather than
  contradicting it). Coherence membership ADDS and the seed/sibling audits' KEEP / RETIRE
  / PRUNE recommendations apply automatically at their existing evidence thresholds —
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
- **Walk-up attention budget ≤ 7 distinct decisions.** The walk-up targets ≤2 min of
  rulings, enforced by instrumentation: the walk-up surface reports its distinct-decision
  count and the probe suite asserts the bound. A new surface that would breach the budget
  must displace something, not stack.
- **Every user-visible term ships with its glossary entry, in the same commit** — see the
  Verification section for the entry's required shape and the `[R38.2]` assertion that
  fails the suite on an unglossed gate name.
- **Every new probe assertion is proven by seeding the defect it is meant to catch** — see
  Verification. An assertion that has never failed is unproven.
- **An assertion downstream of a clamp, cap or floor cannot see a defect the clamp
  absorbs. Assert the TERM UNDER TEST, not the clamped output** (user ruling, Aug 13
  2026 — graduated to BINDING on the second occurrence, which is the bar). When the
  quantity you care about is one input to a `Math.min`, a cap, a floor or a ceiling, the
  final value is frequently pinned by the *other* input, and then a seeded defect in your
  term changes nothing observable. The report is green and reads exactly like a working
  test.
  Both instances, named because the pair is what proved the shape rather than the
  incident: **`strataCount()`** — the per-stratum sampling counter sat behind a
  near-miss filter, so a probe that computed the counts itself passed with the bug fully
  intact; and **`shadowHorizonUnits()`** — paper sizing reverting from the fixed horizon
  to the schedule changed no output at all, because `planCap`'s buy-limit clamp pinned
  both readings to the same number. In both, the fix was the same: **extract the term
  into a named function and point the assertion at that.** Never reproduce it in the
  probe; the extraction is the fix, not a convenience.
  Detector: integration-audit scan 10 below.

---

# DOCTRINE

**Nothing in this section is enforceable and nothing here is audited.** These are
practices and principles the work aims at, kept because they explain *why* the binding
rules are shaped as they are. No test exists for any of them; do not cite one as a
finding, and do not let one masquerade as a rule.

**Division of labor.** The machine verifies parts, traces requirements, audits
composition, grades its own accuracy, proposes its own restructurings, and surfaces
questions proactively on a schedule — noticing is buildable machinery, never the
user's job; their irritation must never be the detector. The user's non-delegable
job: ground truth from lived use, judgment of purpose, and rulings.

The ten standing design principles (propose/dispose at every layer; every layer ships
with a detector and a correction channel; feedback tunes attention not authority;
realized data outranks narrative; complexity is measured in operator attention;
the constitution accretes case law; "done" requires the integration exercise; metric
honesty; adversarial sources filed as adversaries; the human handoff is architecture)
live here in full. Several have binding *instances* above — a specific detector, a
specific check — and those instances are what the audit enforces. The principle itself
is not enforceable, and two of them read as though they were:

- **"Realized data outranks narrative."** Its binding instances are the metric-honesty
  entry and the gate-proposal persistence bar. The principle in general has no detector.
- **"Complexity is measured in operator attention, not code size."** Its one binding
  instance is the ≤7 walk-up bound, which a probe asserts. Everything else about
  complexity — the zero-based budget, "what does this replace", the dormancy report — is
  judgment, and is listed under *Complexity governance* below as practice, not as rule.
- **"Every layer ships with a detector and a correction channel"** (parts→probe suite,
  specs→REQUIREMENTS.md, composition→integration audit, judgment→scorecard). A component
  nothing can catch failing is unfinished even if it works. There is no detector for the
  presence of detectors; this is an aim.
- **"The constitution accretes case law."** Near-misses become named, dated precedents;
  write incidents down, don't just resolve them. A practice, not a check.
- **"'Done' requires the integration exercise."** Verification milestones are not design
  milestones; "show me the audit" is answered with an audit, not a claim. The audit is a
  scheduled discipline (below), but "done" is a judgment.

## Complexity governance (practice — user ruling, Aug 10 2026)

The ≤7 walk-up bound is BINDING and probe-asserted. The rest of this section is practice:

- **Usage-based pruning.** Feature touches (panels opened, buttons pressed, settings
  changed) are instrumented per 30 days. Quarterly, the review renders a DORMANCY
  report: features untouched in 90 days are proposed for demotion — collapsed behind a
  "more" disclosure, not deleted (code is cheap; screen space and mental inventory are
  not). Demotions are ratified like anything else.
- **Feature freeze with a price tag.** Every new capability proposal (the agent's
  included) answers in one line: "what existing surface does this replace or absorb?"
  Additive-only proposals get the ledger-will-make-the-case treatment. The complexity
  budget is zero-based: growth is paid for in consolidation.
- Every feature proposal states its walk-up attention cost; the weekly review reports the
  trend.

---

## Surface map (Aug 11 2026)

Four tabs — Home, Trade, Sleeve, Review. Trade carries six sub-views: **Plan & Watchlist**,
**Scanner**, **Flip Log**, and the three pull surfaces added Aug 11 2026 — **Paper Book**
(regime curves, divergence ledger, the overnight-vs-daytime comparison added Aug 13 2026,
per-gate outcomes), **Prospecting** (per-stratum map,
gap band, hours ledger — the recipe basis was withdrawn Aug 11 2026 and the copy that
still advertised it was removed Aug 13 2026) and **Gate Health** (two streams per gate, die-off
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
**The interrogability rule binds these files** (widened Aug 12 2026): a rollup that ships
without its rows is the same finding in a file as it is on a screen.

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

## Definitions protocol (the response half of metric honesty — user ruling, Aug 10 2026)

When the user asks what a metric measures, the standing rule is **answer first, build
later**: state exactly what the current code computes (not what it was meant to compute),
show one concrete data row as proof, flag known biases unprompted, and propose
corrections without applying anything until the user rules. The binding half — realized
quantities only, and copy that claims exactly what it computes whether or not anyone
asked — is in the BINDING section above.

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
  correction means shipping the path by which it lands — widened Aug 12 2026 to
  every artefact the user has already read, including glossary entries and
  requirement rows.

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

The observed-time widening (Aug 12 2026) produced a second instance of exactly this
shape: a gate-persistence pile reporting "none carry multi-day ledger persistence" when
the truth was that fewer than four days had been observed and the 4-day bar was
arithmetically out of reach. Unreachable is not absent, and the copy now says which.

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

## Case law: routing is not coverage (user ruling, Aug 13 2026)

**A finding is evidence for the change it is ABOUT. A held proposal is not un-held by a
finding that answers a different question, however striking the finding or however
adjacent the proposal.**

The incident: the gap band printed **+399k on 3 overnight trips against −219k on 16
daytime ones** — opposite signs on one population. The proposal on the desk was a T3
scanner for the band: more coverage. The evidence argues about *when* the band's trips
should be placed, not about how many of its items should be watched. Those are different
changes with different costs and different failure modes, and reading one as the other's
evidence would let a proposal be ratified by a finding that was never about it. **The
scanner proposal stays held; the routing question is raised as its own question and
clears the same bar any strategy change clears** — clean post-fix trips in the cell,
which the band's overnight cell does not have.

Three companions, each of which cost something here:

- **The dimension nothing rendered.** This finding was not hidden in a hard number; it
  was in no number at all. Nothing on screen split a cohort by horizon, so seeing it
  required downloading the analysis export and grouping trips by hand — and the export's
  own `byHorizonShape` tally pooled every cohort into two counts, which cannot show a
  cohort whose halves disagree. **A pooled statistic is at least visible as a pooled
  statistic; a dimension no surface splits by is invisible to the reader and to the
  pooling scan alike.** The scan was extended for this, and the split now has its own
  panel.
- **n is not sample size when one trip carries the cell.** 3 trips netting +399k, of
  which one 10.6m-notional trip is +412k, is one result and two that offset it. A trip
  count cannot show that and a rate cannot either — only concentration can, which is why
  the top-trip share renders per cell and why the routing bar treats a trip count as
  necessary and not sufficient.
- **A share of a negative net is not a proportion.** `top5/net` on a losing cell returns
  a percentage that reads exactly like a concentration figure: the gap band's daytime
  cell yields 13%, which would have been read as "well spread". Both concentration
  figures now withhold, with the reason stated, wherever the net is not positive. This
  is the metric-honesty rule catching an operator that was correct arithmetic on a
  denominator whose sign changed its meaning.

## Integration audit (standing discipline — user ruling, Aug 10 2026)

Run by the agent **after any week containing a build session; skip after pure-usage
weeks** (integration debt accrues at build speed — cadence tied to activity, not the
calendar; user ruling, Aug 10 2026), and on the user's demand. Distinct from probes
(parts work) and friction review (reported pain): this hunts **unreported composition
defects**. Scans 1–5 predate Aug 12 2026; scans 6–8 were added that day so the rules
widened in the scope audit have detectors rather than good intentions.

1. **Workflow walks:** trace each real workflow end-to-end through the actual code
   paths — walk-up, briefing cycle, sleeve entry-to-exit, weekly review — and for every
   surface touched answer: what feeds it, what does it feed, when in the workflow does
   it earn its render. Any missing answer is a finding.
2. **Orphan scan:** every panel, queue, record type, and setting gets a connectivity
   check — who writes it, who reads it, what decision changes because it exists.
   Write-only data and read-never surfaces are findings. **Extended Aug 12 2026 to entity
   state:** every entity the user can see — not only allocator-touched ones — must state
   where it stands and why; an entity rendering as a hole, a blank, or a dash with no
   stated reason is a finding.
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
5. **Interrogability scan** (user ruling, Aug 11 2026; widened Aug 12 2026 from screens to
   artefacts): for every aggregate, statistic, verdict, score, or summary the tool
   renders **or exports**, check that it opens to — or ships with — its constituent rows:
   which items, which events, with the per-item evidence behind the number. Findings are:
   any number that cannot be opened; any export carrying a rollup without its rows; any
   expansion or file showing a subset without saying so; any verdict whose stated reason
   doesn't name the specific items or thresholds behind it; and any surface reporting a
   conclusion where the underlying rows would teach more than the conclusion does. **This
   is distinct from the orphan scan** — a surface can be fully connected, reading real
   data and feeding real decisions, and still be opaque. Connected-but-unauditable is a
   finding.
6. **Restraint-lift scan** (Aug 12 2026, for the widened restraint/deployment rule):
   enumerate every path by which a caution, warning, bench, cap, haircut or refusal
   STOPS applying — an action, an expiry, a timeout, a status transition, a retention
   prune, a rule change. Each one is checked for a user press. A lift with no press is a
   finding, and the enumeration itself is the deliverable: a path nobody listed is a path
   nobody checked.
7. **Claims-vs-computation scan** (Aug 12 2026, for the widened metric-honesty rule):
   for every metric the tool renders, read the rendered copy against the code that
   produces it and check the copy claims exactly that — no more, no fewer caveats, the
   right population, the right denominator. Unprompted copy is in scope; this scan exists
   because the definitions protocol only ever fired when the user asked.
8. **Pooling scan** (Aug 12 2026, for the widened never-pool rule; extended to artefacts
   Aug 13 2026): every rate, median, count, verdict and score is checked for whether its
   population is one population. A pooled figure rendering without its decomposition
   beside it is a finding, whatever kind of statistic it is. **The scan reads exports and
   any other artefact handed to a reader, not only screens** — the escaping instance was
   the paper export's `byHorizonShape`, a count pooling every cohort into two numbers
   while the cohorts disagreed in sign; a screen-only scan had nothing to say about it.
   **Also checked: the DIMENSIONS a population is not split by at all.** A statistic
   pooled across a dimension no surface renders is invisible to a scan that only reads
   what is on screen, which is how the horizon split went unnoticed until an export was
   read by hand.
10. **Clamp-absorption scan** (Aug 13 2026, the detector for the clamped-output rule
    above): enumerate every clamp in the product — `planCap`, the participation haircut,
    the one-third stack clamp, the buy-limit clamp, `Math.min`/`Math.max` guards on a
    sized quantity — and for each, list the assertions whose subject is computed
    downstream of it. Each is checked for whether the property under test could be
    absorbed: if the clamp can pin the output while the term changes, the assertion is a
    finding whatever its current colour, and the remedy is extraction rather than a
    stronger regex. **The enumeration is the deliverable**, the same shape as the
    restraint-lift scan: a clamp nobody listed is a clamp nobody checked.
11. **Output:** a findings report with proposed restructurings, ruled like everything
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
reports the feature as covered.

**The root property, widened Aug 12 2026: a green result can mean the test never ran, OR
that it ran and passed for a reason other than the property it names — and a RED result
can mean the seed was too broad rather than that the assertion is sound.** The original
wording covered only the first half, and the R49.2 instance below is the second — an
assertion that ran, on real production output, and would have passed with the property
gone. Every named instance is a face of that one root.

Named instances, all shipped green:

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

- **The assertion that re-implements what it tests** (user ruling, Aug 12 2026). A probe
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
- **Dead safeguards and dead seeds** (user ruling, Aug 12 2026). Three instances, one
  root — the same root the whole section now carries: **a green result can mean the test
  never ran.**

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

- **The broad-container assertion** (user ruling, Aug 12 2026) — the face of the root that
  is *ran, but passed for the wrong reason*. **The tell: an assertion matching against a
  container broader than the thing under test.** `[R49.2]` asserted that a specific
  per-gate fill rate carries its cohort split by testing `/watchlist 100% of 2/` against
  the whole page's HTML — which any other blend anywhere on that page would have
  satisfied. Delete the split from the gate rate and the assertion still passes, on real
  production output, having exercised real production code. Fixed by scoping the match to
  the blend under test: `blendFrag(html, key)` in the probe locates the one
  `data-drill="<key>"` element and its inline sibling, and every per-surface pooling
  assertion matches inside that fragment only. **Generalised: match against the narrowest
  container that still contains the property. If the assertion would pass with the
  property deleted from its subject but present elsewhere, the container is too broad.**

- **Presence of the right phrase is not absence of the wrong one** (Aug 13 2026) — the
  eighth face, found while seeding `[R62.6]` and not by suspecting it. The assertion
  checked that the export's touch-ledger note says the schedule is "unverified rather
  than false" when no walk-ups are recorded. Seeding the defect — rewriting the note's
  FIRST half to claim *"the configured schedule is being followed"* — left the asserted
  phrase in the second half untouched, so **the suite stayed green while the file
  asserted the exact opposite of the rule it was policing.** A green run there reads
  identically to a weak assertion and to a dead seed, and it is neither: the assertion
  ran, on real output, and permitted the contradiction. **An assertion about what copy
  CLAIMS must forbid the contradicting claim as well as require the correct one** — the
  absence half of the scoping ruling, applied to sentences instead of to surfaces. Fixed
  by adding the negative match; the old form passes the seed and the new form fails it,
  which is the discrimination the seventh face demands.
- **A seed that fails a form the fix was meant to PRESERVE proves nothing** (user ruling,
  Aug 12 2026) — the seventh face, and the mirror image of the dead seed. When a fix
  replaces a weak assertion with a stronger one, the seed has to DISCRIMINATE: the old
  form passes, the new form fails. A seed that fails **both** has not demonstrated the
  fix; it has demonstrated that **the fixture cannot distinguish the two forms**, and the
  correct response is to fix the fixture, not to record the run as proof. The instance is
  the R49.2 repair above: deleting the split from the one gate blend failed the
  whole-section match too, because the fixture held only one blend, so a section-wide
  pattern had nothing else to satisfy it. Rebuilt with two gates carrying identical
  splits, the seed separated them — and a standing assertion now holds the fixture to
  carrying that second blend, so the scoping test cannot quietly become untestable again.
  Where the dead seed changes nothing, this one changes too much; both report as proof.
  **The tell: a seed whose failure list includes assertions you expected to stay green.**

### The seeding precondition (global rule — user ruling, Aug 12 2026)

> **Confirm the seed applied, changed something observable, and that the change is the
> one you intended — before reading any result.**

This is the general form of every named instance above, and it is a PRECONDITION rather
than a check: until all three hold, the run's output carries no information and must not
be interpreted. The three fail independently, and each has been hit in this project:

1. **Applied.** A scripted substitution can silently match nothing and leave the file
   untouched; the suite then runs green against unmodified code and the green reads as
   evidence. Verify the text changed — do not assume the command worked.
2. **Changed something observable.** The modified line executes *and* the modification
   alters behaviour. It fails two ways: the line is unreachable (the dead-guard case), or
   it runs and computes the same value anyway — re-deriving a constant from an expression
   that happens to evaluate to the original number is the worked example, and a `const` is
   fixed at load so the derivation never re-runs.
3. **The change is the one you intended.** Not broader, not narrower. A seed that also
   breaks forms the fix was meant to preserve has demonstrated only that the fixture
   cannot tell the forms apart.

Why this earns a rule of its own: in all three cases the report is **indistinguishable
from real proof**, so the false confidence propagates into everything built on top of the
assertion it claimed to verify.

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

### The pairing is checked in BOTH directions (user ruling, Aug 13 2026)

**A cross-reference checked in one direction reports a coverage it has not verified.**
`tools/probe/reqpair.sh` runs after every suite and fails it on either half:

- **A tag with no requirement.** Six assertions carried `[R61.x]` tags for the
  verdict-first work and no §61 rows were ever written, so the report printed
  `REQ PASS R61.1` against nothing for a day. A requirement that does not exist cannot
  fail, and the report said it passed.
- **A requirement with no assertion.** §31's withdrawn rows went on claiming
  `` probe `[R31.x]` `` after the assertions were deleted with the feature, and R35.4
  cited one of them. **This is the seasoning-gate shape with the arrow reversed** — a
  spec claiming an implementation that is not there, which is how the seasoning gate
  vanished with nothing noticing. Rows verified by inspection, UI or documentation cite
  no probe tag and are exempt by construction, which is what makes the check safe to
  state globally rather than row by row.

The check lives OUTSIDE the page because it must read `REQUIREMENTS.md` and the in-page
suite cannot — which is exactly why the gap survived as long as it did. It appends a
`===PAIRING===` section and **rewrites the report header**, so `head -1` never reads
PROBE-PASS while a pairing failure stands. **The general property, which is the part
worth carrying: a ledger that maps two artefacts to each other is only a ledger if BOTH
maps are checked; the unchecked direction is where the drift accumulates, because
nothing there ever goes red.**

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
  too. This is the paper book's instance of the general observed-time rule in BINDING; the
  general rule reaches every denominator counting time or occasions, not just this one.
- **Cadence is not edge.** Gates, floors, reserve and budgets are untouched by a schedule
  change, and the walk-up attention budget still binds at ≤ 7.
- When a metric's denominator changes because the cadence changed, **show both sides**: the
  equity panel reports gp/day beside gp/attention-minute and states the change in place, so
  a fall in the rate is not read as a fall in the trading.
