# CLAUDE.md

Single-file OSRS Grand Exchange flip tracker: `index.html` — no build step, no
dependencies, all client-side, localStorage persistence. Opening the file in a browser
*is* the app. Data comes from the RuneLite / OSRS Wiki real-time prices API, polled no
faster than 60s.

**One named exception to "localStorage persistence" (user ruling, Aug 14 2026):** the
universe scorer's **T0/T1 market archive** lives in IndexedDB (`geflips-t0`) — the bulk
`/5m` and hourly `/1h` readings, ~21–31MB/day against localStorage's 5MB quota. Same
client-side no-build model; a storage API, not an architecture change. **Scoped to the
archive, its trip ledger, and the reconciliation-diff ledger (`rdiff`, flag 3 — one row
per scored bucket, 90-day retention, a ledger whose value is its length); nothing else
may move.** The flip log's boundary (never leaves the browser, nothing in this repo
contains trading data) is untouched — these stores hold market data and gate verdicts
only. Design: `audits/DESIGN-2026-08-14-universe-scoring.md` §2; build stages:
`HANDOFF.md`. *The `rdiff` store shipped one bookkeeping pass ahead of this sentence —
that ordering defect is MISTAKES **M153**, and the rule it produced is recorded in the
conformance gate below: constitutional scope statements ride the same commit as the
store they govern.*

## How a ruling is written (prophylactic — user ruling, Aug 12 2026)

> **When writing a ruling, name the property first; list the surface only as the example
> that produced it. The incident is the example; the reasoning is the rule.**
>
> **And before writing a new rule, check whether the property already has a home. A
> property with three entries has its instances split three ways and will never reach a
> count limb.** (Widened Aug 13 2026.)

This governs every rule below and every rule added after it. The constitutional scope
audit that produced it found the recurring failure: most rules here named the SURFACE
where a defect was found rather than the PROPERTY that was violated, so the same defect
recurred on the next surface and escaped a rule that had already been written about it.
The never-blend ruling is the worked example — written about a *rate*, it did not reach
a pooled *median* three days later. Ten rules were widened on Aug 12 2026; each carries
the escaping instance that motivated the widening, because the instance is what proves
the old wording was too narrow.

**The second clause is the Aug 13 widening, and it names the blind spot the first clause
had.** Naming the property governs how a NEW rule is written and says nothing about
merging rules already written about ONE property from different angles — so the same
property acquired three homes and its instances never accumulated anywhere. The escaping
instance: *a component reports nothing where it should report that it HAS nothing* lived
as an entity-state rule, a never-fed-aggregate case-law section, and a stalled-generator
finding in an audit report. Each read as its own lesson. No entry ever carried more than a
handful of instances, and the pattern's real size — **16, the largest behind any single
rule** — was invisible until every incident was tagged by root cause. **A split property
is worse than a narrow one:** a narrow rule fails to reach the next instance, while a split
one reaches it and then files it somewhere the count cannot see.
Detector: **scan 12** below, which reports candidate merges and does not assert them —
overlapping properties are a judgment about what one rule is, and merging two entries that
turn out to be genuinely different would hide the distinction the second entry exists for.

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
Aug 13 2026 (`audits/AUDIT-2026-08-13-graduation.md`) checked the standing list against
this bar in **both** directions — entries resting on a single instance with no detector,
and patterns with three or more instances that never became a rule. It reported the
mismatches without reclassifying anything; **the user then ruled on them**, and that
ruling is what moved eight entries into *Commitments without detectors* below and promoted
five patterns into BINDING with detectors. Read that report before arguing any entry's
placement — the counts it rests on are in `MISTAKES.md` and are re-derivable.

---

# BINDING

Mechanically checkable — by a probe assertion, or by a named integration-audit scan that
reads code and copy against a stated rule. **Violations are audit findings.** Do not
soften these in code or copy.

- **The tool proposes and prefills; it never acts.** No flip is logged, no offer placed,
  no watchlist commitment made without an explicit user button press.
- **A flag in a record means ONE thing, everywhere; a second concern gets a second field**
  (BINDING Aug 13 2026, user ruling). The decision log's `auto` was stamped on
  machine-applied bookkeeping so the review could show it as a reviewable block, and two
  closure entries written in code to record the *user's own* rulings made both readings of
  the flag apply at once. **A flag that means one thing in some rows and another in others
  is unusable to a reader weeks out, who cannot tell which sense a given row is in** — and
  in this case the review's own block filters on it. So `auto` means **written by the
  tool**, uniformly, and provenance moved to `by` (`"user"` when the tool writes down a
  decision the user made, `"tool"` when the tool made the call, absent on a hand press
  where the press *is* the provenance). The two are independent and the closures are the
  case that proves it: written by the tool, decided by the user. **A record predating a
  new field reads as unrecorded, never as a default to either side** — the third state
  again. Detector: `[R73.11]`, which asserts all three states at the writer.

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
- **A component reports nothing where it should report that it HAS nothing** (consolidated
  Aug 13 2026 from three entries that were the same root written three times: the
  entity-state rule here, the never-fed-aggregate case law, and the stalled-generator
  finding. **16 recorded instances** — MISTAKES.md M003, M008, M015, M016, M023, M032,
  M053, M055, M056, M062, M071, M072, M076, M093, M096, M097 — which is the largest count
  behind any single rule and was invisible while it was three entries).
  **The property: absence and data-of-absence are different readings, and a surface that
  renders them identically has reported the wrong one.** The five shapes it has taken,
  each named because each escaped a rule written about the others:
  - **An entity with no state.** Funded, next-up, qualifying, benched, held,
    owned-elsewhere, hidden, skipped, unobserved: each says so, with its reason, on the
    surface where it renders. An unexplained state reads as a broken feature even when the
    machinery underneath is correct (F18: held items passed all gates, appeared in no
    bucket, and made working auto-promote machinery feel press-gated). The converse binds:
    an element that cannot explain its presence on the screen does not render.
  - **An aggregate nothing has fed.** A stat rendering 0 because nothing FEEDS it is
    indistinguishable from one rendering 0 because nothing QUALIFIED, and the two mean
    opposite things. An aggregate whose input population is empty says so in its own words.
    Membership in a race must be a property of the CANDIDATE, evaluated once centrally,
    never a label individual entry paths remember to attach.
  - **A threshold out of reach.** Unreachable is not absent. Where coverage or sample size
    puts a bar arithmetically beyond reach, the surface says which.
  - **A generator that stopped.** A stalled generator and a quiet market are identical in
    every number on the page. A generator renders its own state — computed from the same
    values it gates on, so the two cannot disagree — **whether or not anything is wrong.**
  - **A failure that says nothing.** A match that silently missed, an eviction on a cold
    cache, a rate with no counterexample count: each asserts its own precondition and
    surfaces when it does not hold.
  Detector: **scan 2** below, which carries all five as named checks. The
  never-fed-aggregate and F18 case-law sections stay as the incident record and defer to
  this entry; they are no longer a second and third home for the rule.
- **Correct parts do not compose into a correct product** (BINDING Aug 13 2026 — promoted
  on **26 recorded instances**, the largest pattern in MISTAKES.md and the one that had no
  rule at all; the integration audit existed and nothing stated what it was checking for).
  **The property: a defect can live entirely in the seam between two subsystems that are
  each correct and each fully tested, and neither side's tests can see it.** Every path
  where two subsystems meet is checked by a walk that CROSSES it: a value one writes and
  another reads, a state one owns and another displays, a guard one applies and another
  bypasses, a ledger whose accrual depends on another's render, a constant one sizes with
  and another ages against.
  The founding instance is the meta-finding of Aug 10 2026: **252 green assertions could
  not see two money-path defects** — the self-cross guard built one-directional against a
  universal spec, and the plan and quote cycle both owning inventory-mode items while
  `committed()` could not see quote legs. *Parts-level verification and composition-level
  audit are different detectors; a green suite is not a clean bill.*
  Two sub-classes have repeated often enough to name: **state coupled to a render path**
  (four instances — a checklist rolling only when its tab renders, ledgers riding
  `renderDeploy` because the boot tab happened to be Watchlist, a sensor computed as a
  render side-effect and read from another tab) and **a constant tuned for one regime read
  by another** (`limitWindows` at a fixed 2, a hardcoded 15:00 day split, a cooldown scaled
  to a horizon it had no exposure argument for).
  Detectors: **scan 10** below, the seam inventory, whose enumeration is the deliverable in
  the same shape as the restraint-lift and clamp scans; and mechanically for the
  render-coupling sub-class, `[R34.1]`, which drives accrual with every tab and sub-view
  active and with no render at all.
- **A long-lived client detects and reports its own staleness** (BINDING Aug 13 2026 —
  four recorded instances, MISTAKES.md M004, M005, M057, M061). **The property: a freshness
  claim states the age of the thing it names, not of the fetch that carried it, and a
  client whose host never reloads must be able to notice that its inputs, its derived
  values or its own build have gone stale.** Two clocks are never presented as one. A
  check that could not run renders as *could-not-check*, never as up-to-date — a stamp
  trusted by its absence is not a stamp. Derived data records which build produced it,
  because a corrupt population that cannot be identified by a field must be discarded
  rather than partitioned.
  Detectors: the per-stream freshness panel split by nature (scheduled streams flagged
  against their own cadence, event-driven ones never, because silence there is data); the
  build stamp's three distinct states; the `/timeseries` circuit breaker; and **scan 7
  extended Aug 13 2026 to freshness claims**, which is the check that would have caught
  "prices 12s ago" standing over an item that trades 27 times an hour.
- **A simulation may use only information that existed when it claims to have acted**
  (BINDING Aug 13 2026 — four recorded instances, MISTAKES.md M063, M073, M081, M099;
  previously a companion bullet inside case law, which is neither BINDING nor DOCTRINE and
  so had no enforceable home). **The property: a modelled result is evidence only if every
  input to it was available at the modelled moment, each piece of evidence is consumed
  once, and the comparison is anchored to the event it claims to measure.** A leg is filled
  only by tape that printed after it was placed. A bucket credits once. A trip that
  resolves in its opening cycle is a bug rather than a fill. A forced exit prices at the
  value AT the horizon, not at the moment we noticed — which is correct on a perfect host
  too, and is why the rule is about information rather than about absence.
  **An average is not the interval it summarises**, and a gate that reads one as if it were
  invents evidence in both directions: the buy leg's pessimistic bias and the sell leg's
  all-or-nothing bucket credit are the same fault twice.
  Detector: **scan 11** below, the information-horizon scan, plus the shipped stamps that
  make a violation visible after the fact — `openSeq`/`openPollSeq`, `bt ≥ p.t`,
  once-per-bucket credit, and `FILL_MODEL_V` partitioning populations by the model that
  produced them.
- **An ordered rule chain that reports "the reason" is reporting POSITION IN THE
  ORDERING** (BINDING Aug 13 2026, user ruling). **Per-rule attribution may not be read as
  causal without an interaction surface: for each rule, the region of the input space where
  it can be the ONLY failure. A rule whose region is empty is structurally inert, and its
  counts measure the rule ahead of it.**
  **Companion:** an attribution ledger may store only the first match — read its writer and
  establish whether it records all matches or only the first, before computing anything
  from it.
  The founding instance, measured over 4,497 live items: `GATE.roi` is 1.2% and the margin
  gate's tax limb is a sustained-ROI floor in disguise at `taxMult·τ/(1 − τ − taxMult·τ)` =
  **6.52%**, so **2,358 items fail the ROI floor and 2,358 of 2,358 also fail the margin
  floor** — the ROI floor cannot be a single-gate failure for any taxed item at any price.
  Nobody wrote that rule; it is the ratio between two constants set independently. On the
  same measurement the volume floor, second to last in the chain, is the sole binding gate
  on **every one** of the 280 it heads. A gate's ledger presence measures where it sits in
  the array. Two conclusions had already been drawn off the artifact and were struck: *"sole
  blocker in 14 of 19, 74%"* (0% by construction) and *"the volume floor is never the sole
  blocker, so loosening it would free nothing"* (it is the most common sole blocker there
  is). Full measurement: `audits/SURFACE-2026-08-13-gate-interaction.md`.
  **Where the causal number is cheaply available, it LEADS and the positional one is
  demoted and labelled** (user ruling, Aug 13 2026). The deployment funnel now opens with
  leave-one-out — *relax this rule alone and this many candidates clear the chain* — which
  needed no new machinery: independent per-gate evaluation means the counterfactual is
  already in the fail sets, and the panel had been rendering the positional number three
  lines above the causal one since Aug 12. A first-fail partition is kept **only** where a
  cumulative count needs each candidate attributed exactly once, and says so where it
  renders. **Marking is the fallback, not the goal**, and a mark that appears on every
  surface distinguishes none of them.
  Detectors: `effRoiFloorPct()` and `bandUnreachable()` are the derived terms, asserted at
  the source by `[R73.1]`–`[R73.3]`; `[R73.5]`/`[R73.6]` assert the label is present on
  every positional surface **and absent from every binding one**; `[R73.10]` asserts the
  causal number leads by DOCUMENT POSITION and that a rule binding nothing renders its
  zero; and **scan 16** below is the enumeration.
  **The methodological half, which is DOCTRINE and not a rule** — see *Arithmetic on the
  constants* under **Practices and principles**: no scan in this file could have found
  this, because every detector here reads code or copy against a STATED rule, and this was
  a relationship between two constants that no rule ever stated.

- **Data nothing reads, and surfaces nothing feeds, are defects** (stated Aug 13 2026 —
  four recorded instances, MISTAKES.md M018, M027, M036, M095; scan 2 had been checking
  this since Aug 10 with no rule stating the property). **A field written and never
  consulted is a claim that something is being tracked**; a surface that renders without a
  reader for what it shows is a claim that something is being decided. Every persisted key,
  panel, queue, record type and setting answers: who writes it, who reads it, what decision
  changes because it exists. Removal is a valid answer and so is wiring it up; silence is
  not.
  **Widened and ratified Aug 14 2026 (conformance-map row 12): a store whose reader is a
  RULED FUTURE STAGE, named on record in the schema register, is not an orphan — scan 2
  reports it as STAGED, not orphaned; a staged store whose named stage ships without
  reading it becomes an ordinary orphan finding at that stage's boundary; and scan 2
  RE-REPORTS every staged store on every audit until it is consumed, so a stalled stage
  cannot leave a store staged indefinitely and invisibly.** The escaping instance: the
  universe scorer's T0 archive and T2 rollups accrue ahead of their 1d/1e readers by
  explicit staging ruling, which the unwidened rule would have flagged as write-only.
  Detector: **scan 2** below.
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
  arm one.** The reasoning is the
  restraint/deployment line applied to indirect consent: a dismissal removes a caution the
  user already read and judged, and its blast radius is bounded by what it stops doing,
  whereas a ratification arms a record that then tags items, can carry a sizing haircut,
  and can create calendar entries — so a mistake in the file, a stale copy, or a record the
  user never actually ruled on would ADD machinery rather than remove it. The asymmetry is
  enforced at import, not documented: `action: "ratify"` is ignored, and a dismissal with
  no stated reason is ignored too, because a dismissal without a why is not a record. Every
  applied disposition is decision-logged with an `auto` stamp, the reason, and the date the
  user ruled.
  **New consent channels inherit this shape**: whenever user intent reaches the tool by any
  route other than a press on the surface itself, that route may drop advisories and may
  not arm them.
- **A manipulation defense never relaxes on the manipulator's chosen evidence** (user
  ruling, Aug 10 2026). Recent wins during a pump are the bait, so wins never graduate a
  flagged pump caution; the only lift path is the user dismissing the warning record —
  nothing else. *One recorded instance (MISTAKES.md M090); eligible on the detector limb,
  scan 6 below.*
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
- **Membership bookkeeping applies itself** (user ruling, Aug 11 2026 — **supersedes
  "membership never recomposes silently"**, R4.2b, which stood from Aug 10 2026; and see
  *Advisory layers stay advisory* under **Commitments without detectors** in DOCTRINE,
  which names this supersession explicitly rather than contradicting it — the two are read
  together and neither is to be quoted alone). Coherence membership ADDS and the
  seed/sibling audits' KEEP / RETIRE
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
  2026. ~~*graduated to BINDING on the second occurrence, which is the bar*~~ — **struck
  Aug 13 2026**: two occurrences is not the bar under the promotion rule recorded above,
  and the sentence misstated the standard. This entry qualifies on the **detector limb**,
  scan 9 below, and now stands on **six** recorded instances — MISTAKES.md M074, M118,
  M119, M120, M122, M124 — which clears the count limb as well). When the
  quantity you care about is one input to a `Math.min`, a cap, a floor or a ceiling, the
  final value is frequently pinned by the *other* input, and then a seeded defect in your
  term changes nothing observable. The report is green and reads exactly like a working
  test.
  **QUALIFIED Aug 13 2026 (user ruling), because a careful reader declined to apply the
  rule as written.** In the adversarial pass over the money tier, the verifier examining
  `probe:111` refused to adopt this entry's own paraphrase — the assertion passes
  `qty = 1e9`, so the `Math.min` selects the horizon term and the cap does **not** pin the
  output. Under the rule as stated it read as a clamp finding; on the code it is a
  re-implementation finding, and the distinction changes the fix. The qualification:
  **a clamp absorbs a defect only where it BINDS for the fixture in question, and an
  assertion downstream of one must state WHICH INPUT PINS ITS OUTPUT.** A clamp that is
  present but not binding absorbs nothing; a clamp that binds absorbs everything upstream
  of it. Naming the pinning input is what makes the difference checkable instead of
  assumed — and it is the same discipline as stating the effective unit beside an `n`.
  Where the assertion cannot say which input pins it, that is itself the finding.
  A rule imprecise enough that its own detector's operator sets it aside is a rule that
  reports coverage it does not have, which is the defect this section exists to name.

  Both instances, named because the pair is what proved the shape rather than the
  incident: **`strataCount()`** — the per-stratum sampling counter sat behind a
  near-miss filter, so a probe that computed the counts itself passed with the bug fully
  intact; and **`shadowHorizonUnits()`** — paper sizing reverting from the fixed horizon
  to the schedule changed no output at all, because `planCap`'s buy-limit clamp pinned
  both readings to the same number. In both, the fix was the same: **extract the term
  into a named function and point the assertion at that.** Never reproduce it in the
  probe; the extraction is the fix, not a convenience.
  Detector: integration-audit scan 9 below.

---

# DOCTRINE

**Nothing in this section is enforceable and nothing here is audited.** No test exists for
anything here; do not cite one as a finding, and do not let one masquerade as a rule.

The section holds two different kinds of thing, and the distinction matters when reading
one: **commitments** (below) are promises about what the tool may do, binding on conduct
and unenforceable only in the sense that nothing can catch a breach; **practices** (after
them) are things the work aims at. Both are undetectable. They are not equally serious,
and a reader who takes the first group as aspiration has misread it.

## Commitments without detectors (demoted from BINDING, user ruling, Aug 13 2026)

Every entry here was in BINDING on **zero or one recorded instance with no mechanical
detector** — promoted informally, at whatever point it seemed important. They are real
commitments and they still govern conduct. They are moved because a rule that looks
mechanically checkable and is not occupies the slot where a real rule would have gone and
reports the property as covered. **Any of them returns to BINDING the moment it acquires a
detector, or on a third recorded instance.**

- ~~**Known repeated bug class: gates that re-punish what sizing already priced in**~~
  **(double-counting). — CLAIM STRUCK, Aug 13 2026, not merely demoted.** The graduation
  audit searched the whole repo and found **zero** substantiated instances: every
  `double-count` in the tree is a different defect (bank-plus-realized, the funnel's
  negative residual, the attention denominator). An entry asserting *"known repeated"* with
  no recurrence on record makes a false claim about the project's own history, which is
  worse than an unenforceable rule — it is unearned authority. **The underlying guidance
  survives as guidance, with its claim removed:** where a gate and the sizing logic read the
  same information, prefer to price it once; bench on what sizing does not use. If it ever
  happens, it gets a MISTAKES.md entry and starts its count at one.
- **House convention (strategy layer):** strategy parameters — ceilings, floors, budgets,
  gates, tier bands, cluster caps — may be *proposed* in review copy but change only on the
  user's explicit instruction. Never self-apply. *One instance (M028), shared with the
  entry below.*
- **Disclosure-in-summary is not ratification** (user ruling, Aug 10 2026). Judgment
  thresholds and verdict boundaries discovered mid-build are strategy parameters: propose
  them and leave them unapplied until the user rules. Applying one and mentioning it in the
  summary is a near miss, not compliance. *One instance (M028): entry-watch DISCOUNTED set
  to ≤ −2% in-flight, ratified after the fact.*
- **A consent channel may carry no strategy-parameter change at all; those move only on an
  explicit in-tool ruling** (the file-as-press final clause, added Aug 12 2026, demoted Aug
  13 2026). Its stated escaping instance — a settings block changing the ROI floor, which
  neither drops an advisory nor arms one — is a **gap, not an incident**: it has never
  happened, and the Aug 12 audit recorded in `AUDIT-2026-08-12-scope.md` §5 that nothing
  asserts it. The two-direction half of the file-as-press rule keeps its detector and stays
  BINDING; only this clause moves.
- **Advisory layers stay advisory — except where a ruling has explicitly superseded it.**
  Scout, cluster discovery, audits, and verdicts queue candidates and recommendations;
  nothing caps or spends capital until the user ratifies. **Superseded in exactly one place
  (user ruling, Aug 11 2026):** coherence membership ADDS and the seed/sibling audits'
  KEEP / RETIRE / PRUNE recommendations self-apply at their existing evidence thresholds —
  see *Membership bookkeeping applies itself* in BINDING for the reasoning, the
  decision-log requirement, and the carve-out that coherence DROPS still queue. The
  advisory default holds everywhere the supersession does not name; the two rules are read
  together, and neither is to be quoted alone. *Zero instances as an incident — it is the
  posture the specific BINDING rules implement, rather than a rule that has been breached.*
- **The blacklist is the user's alone.** No automated path may admit, fund, quote, or clear
  an entry — not even a margin test. *Zero instances.*
- **Feedback edges tune ATTENTION, never AUTHORITY** (closed-loop constitution — user
  ruling, Aug 10 2026). Learning loops — story-resolution signatures, lag profiles,
  scorecard priors, rulings digests, ramping triggers — may change what gets watched,
  flagged and prioritized; gates, sizing and deployment still move only by ruling. *Zero
  instances.*
- **Shipping a correction means shipping the path by which it lands, for any artefact the
  user has already read** (widened Aug 12 2026, demoted Aug 13 2026). Withdrawing
  contaminated numbers from a brief exposed the original defect: re-importing an
  already-ratified record was silently absorbed, so eleven corrected records would have
  left the wrong numbers on screen while the brief claimed they were fixed (M070). Its
  escaping instances — a corrected glossary entry, a revised requirement row — have no
  landing path at all. **This entry was already flagged in BINDING as weaker than its
  placement implied, with one attempt at a detector owed.** The demotion settles it without
  spending that attempt: the candidate check (*every artefact type the user has read has a
  defined update path, enumerated*) remains the way back to BINDING, and building it is now
  optional rather than a debt.

## Practices and principles

These are things the work aims at, kept because they explain *why* the binding rules are
shaped as they are.

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
- **Staging practice** (user ruling, Aug 14 2026, ratified as standing practice). Three
  rules for ordering a multi-stage build: **accrual ships ahead of its consumers when its
  clock gates the schedule** — a component needing N days of accumulated data puts its
  accrual layer on the critical path however uninteresting the code, and the clock's fine
  print is stated (an archive that accrues only while the app is open counts observed
  coverage, not wall days); **sizing numbers are measured under the rules that will
  actually run** — a budget derived under conditions the plan itself changes is a
  plausible number with an unknown error, and the re-measurement is its own stage, before
  any code (the stage-0 re-measure found the 6× churn understatement the original number
  hid); **superseded machinery stands until the replacement's first real output** —
  retirement is a separate ruling gated on output, never a side effect of building the
  successor. **A fourth rule ratified Aug 14 2026, the companion to partition-at-birth:
  when a store's writing regime is scheduled to change, pin the current era's
  distinguishing fact in a test** — `marketStatsFor().tr === null` inside `[R76.9]` is
  the instance — **so the new regime's arrival forces the accounting rather than
  permitting it**: the wiring that starts the second era cannot land without turning
  something red, and the stanza that clears the red is where the partition gets checked.
  No detector exists for the first three; the fourth is the practice of *writing*
  detectors, and each pinned fact is itself mechanical.
- **Arithmetic on the constants, not a pattern match on the code** (user ruling, Aug 13
  2026). **Every detector in this file reads code or copy against a STATED rule. A
  relationship between two constants that no rule ever stated is invisible to all of
  them** — no scan found the margin/ROI entanglement and no scan could have. It was found
  by trying to verify a claim that could not be supported and following the arithmetic.
  So when a per-rule count, a ranking, or a "this is the binding constraint" conclusion is
  on the table, take the constants that meet in one comparison and compute their ratio.
  Expect more of this class. **This is DOCTRINE because it names a gap rather than a
  rule**, and it is deliberately not dressed as enforceable: a candidate detector exists
  and is cheap to state — enumerate every pair of constants that meet in one comparison
  and compute the ratio — but whether it is worth building is its own ruling and has not
  been made. Scan 16 covers the ordered-chain case only, which is one instance of this
  shape rather than the shape itself.
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

## Surface map (Aug 11 2026; Scorer added Aug 14 2026)

Four tabs — Home, Trade, Sleeve, Review. Trade carries seven sub-views: **Plan & Watchlist**,
**Scanner**, **Flip Log**, and the pull surfaces — **Paper Book**
(regime curves, divergence ledger, the overnight-vs-daytime comparison added Aug 13 2026,
per-gate outcomes), **Prospecting** (per-stratum map,
gap band, hours ledger — the recipe basis was withdrawn Aug 11 2026 and the copy that
still advertised it was removed Aug 13 2026), **Gate Health** (two streams per gate, die-off
episodes, exception lane), and **Scorer** (stage 1e, Aug 14 2026 — the universe scorer's
read surface: verdict-first first screen, the grid with hour bands and the blacklist
canary, fill economics per horizon × participation × capture lifecycle, the "cannot rank
yet" readiness verdict wherever a ranking would render). The pull surfaces present no
rulings: they are read, not worked, so the
walk-up attention budget is untouched. The weekly review keeps a one-line summary of each
with a link through and no longer re-renders them — that consolidation is what paid for
them under the zero-based complexity budget.

**Each pull surface carries an `⭳ export for analysis` button** (user-directed, Aug 12
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

> **This section is the incident record, not the rule.** The rule is *a component reports
> nothing where it should report that it HAS nothing*, in BINDING, which consolidated this
> section, the entity-state entry and the stalled-generator finding on Aug 13 2026 — one
> root that had been written three times, so its sixteen instances never accumulated
> against anything. Cite the rule; read this for what it cost.

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

## Case law: n is not sample size (user ruling, Aug 13 2026)

> **Before ruling any constant from an aggregate, identify the unit that actually VARIES
> and count THAT. State it beside every n.**

The incident: a proposed change to the sell credit rule was evaluated over **232 buckets
carrying 33,234 units of tape across 17 trips**, and came out at −23%. That reads as a
sample. It was not. Of the gross loss, **84% was one item** (Adamant cannonball, −3,221 of
−3,851); of the gross gain, **97% was one item** (Snape grass seed, +940 of +965). The other
fifteen moved by 630 combined. **The −23% was one trip halved and one trip rescued**, and
removing just those two flipped the sign of the result under a different intercept.

The general shape: an aggregate's n counts the rows you happened to compute over, not the
independent draws the conclusion rests on. Buckets are not independent of their trip; trips
are not independent of their item; items are not independent of their basket. **The unit
that varies is the one at which the *decision* would be wrong**, and it is almost always
coarser than the row.

This is the same lesson as the gap band's overnight cell — 3 trips netting +399k of which
one carried 103% of the net — arriving on a different population and at a different layer,
which is why it graduates from a companion note to case law in its own right.

Two operational consequences:

- **State the effective unit beside every n**, not the row count alone. "232 buckets" and
  "232 buckets across 17 trips, 84% of the effect in one" are different claims and only the
  second is rulable.
- **Concentration is a precondition for ruling a constant, not a caveat on it.** A figure
  whose top contributor exceeds the callout share has not measured the population; it has
  measured that contributor, and the constant it would justify is fitted to one trip.

## Case law: the residue that was a threshold artifact (user ruling, Aug 13 2026)

**A large "neither fits" pile is evidence about the THRESHOLDS before it is evidence about
the market.** The sell discriminator's first live run classified 10 of 17 failures as
neither dilution nor mislocation — a residue larger than both named mechanisms combined,
and exactly the shape that invites a third class.

There was no third mechanism. Decomposed, the ten were four different things: **2** had no
high print in 48 buckets (illiquidity, and the classifier was filing that stronger case in
the residue while giving the name to the weaker prints-but-no-volume condition); **3** sat
inside a third of the item's own spread; **2** were three and six points of *sustain* short
of the mislocation bar rather than between the gap bands at all; **3** were genuine
residue. Measured against each item's own spread, the residue ran **0.13–0.74** — inside
what the spread explains — while the mislocated pile ran **0.40–2.57**, beyond it.

**Fault A was the mechanism for the whole pile** — a 5-minute average read as if it
described the interval — and it was already on the contamination register. The pile existed
because an absolute band was measuring a proportional phenomenon: half a spread lands inside
the 1% dilution band on a tight item and outside it on a wide one, so the same physics
classified three different ways depending on the item.

**The discriminator did its job by refusing.** It was built so that "neither fits" is a real
available outcome rather than a residue forced into one of two buckets, and that refusal is
what made the pile legible instead of mislabelling ten cases as dilution or mislocation. The
lesson is the reverse of the intuitive one: **a classifier producing a large unclassified
pile may be working perfectly, and the first thing to check is whether its thresholds are
the wrong SHAPE, not whether it is missing a class.**

Three corollaries, each of which cost something here:

- **An absence must never be filed as an ambiguity.** The two no-print cases were the
  strongest illiquidity finding available and sat in the pile meaning "we could not tell".
  The named class existed and was pointed at the weaker condition.
- **A stale-input hypothesis is testable by dimension.** The proposed explanation was a
  stale or offset ask, which would produce a roughly *constant absolute* gap. The gaps ran
  −2.17% to −10.87% in proportion to spread, which falsified it without needing new data.
- **A pattern shared by every case is not a discriminator.** Buy credit 100% and observation
  100% held for 15 of 17 — including both named classes — so it described what it takes to
  *have* a failing sell leg, not what caused one.

## Integration audit (standing discipline — user ruling, Aug 10 2026)

Run by the agent **after any week containing a build session; skip after pure-usage
weeks** (integration debt accrues at build speed — cadence tied to activity, not the
calendar; user ruling, Aug 10 2026), and on the user's demand. Distinct from probes
(parts work) and friction review (reported pain): this hunts **unreported composition
defects**. Scans 1–5 predate Aug 12 2026; scans 6–8 were added that day so the rules
widened in the scope audit have detectors rather than good intentions; scans 9–11 were
added Aug 13 2026 for the rules promoted out of the graduation audit. **Renumbered Aug 13
2026** — the list ran 1–8, 10, 11 with no scan 9, so a rule citing "scan 10" was citing a
position rather than a check; scan 9 is now the clamp-absorption scan it always was in
substance.

1. **Workflow walks:** trace each real workflow end-to-end through the actual code
   paths — walk-up, briefing cycle, sleeve entry-to-exit, weekly review — and for every
   surface touched answer: what feeds it, what does it feed, when in the workflow does
   it earn its render. Any missing answer is a finding.
2. **Orphan and silent-state scan:** the detector for two BINDING rules — *data nothing
   reads is a defect*, and *a component reports nothing where it should report that it HAS
   nothing*. **(a) Connectivity:** every panel, queue, record type, persisted key and
   setting answers who writes it, who reads it, and what decision changes because it
   exists; write-only data and read-never surfaces are findings. **(b) Silent state**, the
   five shapes named in the rule, each checked separately because each escaped a check
   written for the others — an entity rendering as a hole, blank or dash with no stated
   reason; an aggregate whose input population can be empty and does not say so; a
   threshold that can be arithmetically out of reach and reports as absent; a generator
   that can stop and does not render its own state; and a failure path that can miss
   silently (a name match, an eviction on a cold cache, a rate with no counterexample
   count). *(a) has run since Aug 10 2026, (b) was extended to entity state Aug 12 2026 and
   to all five shapes Aug 13 2026 on the consolidation of sixteen instances.*
   **(a) amended Aug 14 2026 (ratified with the conformance map):** a write-only store
   whose reader is a ruled future stage named in the schema register reports as
   **STAGED**, not orphaned — and is **re-reported on every audit until consumed**, with
   its named stage, so a stalled stage cannot leave a store staged indefinitely and
   invisibly. A staged store whose named stage has shipped without reading it reports as
   an ordinary orphan finding at that boundary.
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
   because the definitions protocol only ever fired when the user asked. **Extended Aug 13
   2026 to freshness claims**, as the detector for *a long-lived client detects and reports
   its own staleness*: every rendered age is checked against the thing it names rather than
   the fetch that carried it, and every "as of" is checked for whether the clock it reads
   is the clock the reader will assume. The escaping instance was "prices 12s ago" standing
   over an item that trades 27 times an hour — true of the fetch, false of the number
   underneath it.
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
9. **Clamp-absorption scan** (Aug 13 2026, the detector for the clamped-output rule
    above): enumerate every clamp in the product — `planCap`, the participation haircut,
    the one-third stack clamp, the buy-limit clamp, `Math.min`/`Math.max` guards on a
    sized quantity — and for each, list the assertions whose subject is computed
    downstream of it. Each is checked for whether the property under test could be
    absorbed: if the clamp can pin the output while the term changes, the assertion is a
    finding whatever its current colour, and the remedy is extraction rather than a
    stronger regex. **The enumeration is the deliverable**, the same shape as the
    restraint-lift scan: a clamp nobody listed is a clamp nobody checked.
10. **Seam inventory scan** (Aug 13 2026, the detector for *correct parts do not compose
    into a correct product*): enumerate every place two subsystems meet — every persisted
    key and `S.*` field with its writer and its readers named; every ledger whose accrual
    depends on a render path; every guard that reads one store and is consulted from
    another; every constant read by two mechanisms that assume different regimes — and for
    each, name the walk that CROSSES it. A seam covered only by tests that live on one
    side of it is a finding whatever colour those tests are. **The enumeration is the
    deliverable**, the same shape as scans 6 and 9: a seam nobody listed is a seam nobody
    checked. This subsumes and replaces nothing — scans 1 and 2 walk workflows and
    connectivity; this one walks the joins.
11. **Information-horizon scan** (Aug 13 2026, the detector for *a simulation may use only
    information that existed when it claims to have acted*): enumerate every point where a
    simulated or replayed result reads evidence — each fill-credit path, each replay
    window, each forced exit, each comparison anchor — and check three things per point:
    the read is bounded by the modelled moment, each piece of evidence is consumed exactly
    once, and no interval statistic is being read as if it described the interval. A path
    that cannot state its own information horizon is a finding.
12. **Overlapping-property scan** (Aug 13 2026, the detector for the prophylactic's second
    clause): enumerate every BINDING entry's **stated property** — the sentence in bold,
    stripped of its incident — and check each pair for overlap: does one entry's property
    describe a case the other's already covers, and would an instance filed under one be
    equally at home under the other? For each overlap found, report a **candidate merge**
    with the instance counts each entry currently carries and what the merged count would
    be. **Report, never assert** — merging entries that are genuinely different hides the
    distinction the second one exists for, so the merge is the user's ruling. The
    enumeration is the deliverable, as in scans 6, 9, 10 and 11: two entries nobody
    compared are two entries nobody knows are one.
13. **Reachable-fixture scan** (Aug 13 2026, the detector for the twelfth face):
    enumerate every probe assertion that calls a production function **directly with
    arguments the probe constructs**, and for each, name a production call site that
    could produce arguments of that shape. An assertion with no such call site is
    exercising a state the product cannot reach — it is testing the function's behaviour
    on impossible input, and any guard it covers is unprotected in practice however green
    the line is. Two remedies, and the choice is the dead-safeguard choice: move the
    assertion to the layer production actually calls, or — if the constructed state is
    genuinely reachable by some caller — name that caller in the assertion's comment so
    the next scan does not re-raise it. **The enumeration is the deliverable**, the same
    shape as scans 6, 9, 10 and 11: an assertion nobody traced to a caller is an
    assertion nobody knows is testing the product.
    Run it **before** deleting any guard found unreachable by scan 11 or scan 9, because
    a green assertion over dead code is the signal this scan exists to explain.
14. **Label-claim scan** (Aug 13 2026, user ruling — the detector for a class nothing
    was looking at): **an assertion label is copy, and copy claims exactly what it
    computes.** Every existing scan reads what CODE does; none reads what a TEST says
    about itself, so a label claiming more than its subject exercises is invisible to
    all of them. This is the metric-honesty rule pointed at assertion names.
    The founding instance: `probe:116`, labelled **"uncapped item funded full"**, asserts
    `allocQty === 5000` — where 5000 *is* the per-item cap and the unclamped size is
    30000. The test is sound as a clamp test; the label makes a false claim about which
    test it is. The census found it only because the CLAMP face happened to route
    through it — nothing was looking for the label itself.
    **The cheap mechanical half:** grep every assertion label for STRONG-CLAIM words and
    list the hits for reading. Four classes, each naming something the label claims not
    to depend on, or claims to hold universally — which are exactly the claims a narrow
    fixture or a clamped subject silently fails to keep:
    - *negated mechanism* — `uncapped`, `unclamped`, `not through`, `rather than`,
      `instead of`, `without`
    - *source claim* — `at the source`, `directly`, `itself`, `the term`
    - *universal* — `never`, `always`, `only`, `every`, `any`, `cannot`, `must not`
    - *sufficiency* — `exactly`, `alone`, `regardless`
    Findings are: a universal exercised against one instance (`[R4.3]`, *"intel cannot
    touch blacklist / reserve / gate constants"*, tested against the single record type
    with no write path at all); a negated-mechanism label whose subject is computed
    downstream of that very mechanism (`probe:116`); a source claim whose subject is
    still behind the clamp (`probe:111`, *"asserted at the source, not through a cap
    that pins it"* — and the assertion copies production's expression, so the cap pins
    it anyway).
    **The grep produces CANDIDATES; the read is the work, and it is not mechanical.**
    Same shape as scans 6, 9, 10, 11 and 13: **the enumeration is the deliverable** — a
    label nobody read against its subject is a claim nobody checked. On the current
    suite the four classes flag on the order of 100–200 of 958 labels, which is a
    bounded first pass and shrinks as they are cleared.
16. **Interaction-surface scan** (Aug 13 2026, the detector for *an ordered rule chain
    reports position in the ordering*): for every ordered chain that reports "the reason"
    — the gate chain, the funnel, `GATE_CHAIN_ORDER`, any first-match classifier added
    later — enumerate each rule and state **the region of the input space where it can be
    the ONLY failure**, in the variables that define it. A rule whose region is empty is
    structurally inert and every count attributed to it belongs to the rule ahead of it;
    a rule whose region is empty *for the population that actually reaches it* is the same
    finding one step weaker. For each dominated rule, name the dominating rule and the
    **ratio between the constants that produces the domination**, and say whether that
    domination was designed or is incidental to two constants set independently.
    **The enumeration is the deliverable**, the same shape as scans 6, 9, 10, 11 and 13: a
    rule nobody bounded is a rule nobody knows is inert. Second half, and it is a separate
    read: for every surface, export field and prior conclusion that consumes the chain's
    attribution, state whether it reads the FIRST match or the FULL match set — the two
    are different populations and must never be joined on rule name.
17. **Output:** a findings report with proposed restructurings, ruled like everything
    else. No findings is a valid result and says so.

## The scorer conformance gate (standing requirement — user ruling, Aug 14 2026)

Applies to **every universe-scorer stage from 1d on**, and **identically to the sleeve
addendum stages when they start** — the conviction-boundary detector ships with the first
planner surface, not after. The one-time BINDING mapping lives in
`audits/CONFORMANCE-2026-08-14-scorer-map.md`; it was reported for ratification once, and
every stage thereafter checks its **deltas** against that table rather than re-arguing
the whole constitution.

**Every stage report carries a conformance stanza — structured, not prose:**

- **BINDING rules touched**, each with the mechanical check that verifies it: a scan run
  with its enumeration count, or an assertion id with its seed result.
- **Detectors shipped in the same commit as the surfaces they watch.** The
  ships-with-detector doctrine enforced at commit grain: a surface landing without its
  detector is an **incomplete stage, not a fast one**. **Read as covering constitutional
  scope statements too (user ruling, Aug 14 2026 — M153):** a store lands in the same
  commit as the scope sentence that sanctions it, because a constitution contradicting
  the code it governs is the same defect as a surface without its detector — the
  authority that would catch the next violation is the thing that is stale.
- **Seeds:** every new assertion proven to bite; discriminating where states are
  distinguished; **cascades recorded as propagation, not proof**.
- **The applicable scans run at the stage boundary:** pooling (8); never-fed /
  silent-state (2); claims-vs-computation (7); interrogability (5) over any new aggregate
  or export; scan 14 over new assertion labels; scan 16 semantics — full fail sets — on
  anything chain-shaped.
- **DOCTRINE items satisfied by inspection, listed as inspection** — never dressed as
  checks.

**Schema decisions get the partition question at birth, in writing.** For every new store
or row type: what regime writes it, what field records that, and what happens when the
regime changes. `fillModelV` and `configHash` are the precedents; the 1c coverage-stamp
gap (six-gate cycles that would have pooled with full-chain cycles when the h1 archive
matured) is the live instance that earned the rule. **No store accrues past a session
without its partition answer on record** — the register lives in the conformance map file.

**The cutover stage gets the heaviest gate, distinct from the rest:** reconciliation
history at the verdict level (already ruled); an integration-audit walk of the new
surfaces; AND an adversarial pass over the cutover-critical assertions. The plan's pool
switch is the one deployment-class change in the migration, and it gets the `[R7.3]`
standard: **prove the guard red before trusting it green.**

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

**Twelve named faces, all shipped green, numbered in the order they appear below**
(renumbered Aug 13 2026: the list had grown to eleven shapes while its ordinals reached
only "eighth", two of them ran out of file order, and one was unnumbered — a count that
does not match its own list cannot support a graduation argument, which is the whole use
the count is put to). **A thirteenth shape, clamp absorption, left this list on Aug 13
2026** and is a BINDING rule in its own right with scan 9 as its detector; it is not
missing here, it graduated.

- **The `|| true` assertion** — **first face** (Aug 11 2026): a probe line ending `… || true`, written
  to check the poll calls the accrual step. It passed unconditionally and asserted
  nothing whatever.
- **The R29.4 durability detector** — **second face** (Aug 11 2026): it seeded a closed record, rolled it,
  *then* aged it past the retention window — so it passed whether the roll happened
  before or after the prune, which was the entire property under test. Rewritten to
  start from a record already past the window; only then could it fail.
- **The R22.2 scoping assertions** — **third face**: `querySelector` existence checks pass on hidden
  elements, so a CSS specificity bug rendered Home's blocks on every tab for a full day
  behind a green suite. Fixed by asserting computed visibility where it must be absent.
- **The R24.2 landing assertions** — **fourth face**: "target top in viewport" passed with the title
  hidden under the sticky header — which is precisely how the offset bug shipped green.
  Fixed by asserting the first VISIBLE title sits below the chrome's bottom edge.
- **The intermittent assertion is the same liability** — **fifth face** (user ruling, Aug 11 2026). A test
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
- **The simultaneity assertion** — **sixth face** (Aug 12 2026), a second instance of the same class,
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

- **The assertion that re-implements what it tests** — **seventh face** (user ruling, Aug 12 2026). A probe
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
- **Dead safeguards and dead seeds** — **eighth face** (user ruling, Aug 12 2026). Three instances, one
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

  **And before deleting an unreachable guard, check whether an assertion is holding it
  alive** (added Aug 13 2026 with the twelfth face). A dead guard with a green assertion
  pointed at it is the normal case, not the surprising one: the assertion is reaching it
  by a call path production does not have. Deleting the guard will turn that assertion
  red, and the red is information rather than a regression — it names the artificial call
  path. Move the assertion to the layer production actually uses **before** the guard
  goes, or the deletion looks like it broke a working test.

  **And two defects can hide each other.** Seeding the ambiguous-reachability widening
  and the reconstruction touch-history rule together (commit `f8a0a73`) left the
  reconstruction assertion passing: with the widening removed, passing a touch into a
  rule that ignores touches changes nothing, so the second defect had no way to express
  itself. Neither seed was wrong; their interaction was. **Seed one defect at a time,
  and when a batch is unavoidable, re-run any assertion that did not fail in isolation
  before counting it as proven.**

- **The broad-container assertion** — **ninth face** (user ruling, Aug 12 2026), and the
  one that carries the *ran, but passed for the wrong reason* half of the root. **The tell:
  an assertion matching against a
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

- **A seed that fails a form the fix was meant to PRESERVE proves nothing** — **tenth
  face** (user ruling, Aug 12 2026), the mirror image of the dead seed. When a fix
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
- **Presence of the right phrase is not absence of the wrong one** — **eleventh face**
  (Aug 13 2026), found while seeding `[R62.6]` and not by suspecting it. The assertion
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
  which is the discrimination the tenth face demands.
- **The assertion that manufactures the only state in which the code can run** —
  **twelfth face** (user ruling, Aug 13 2026), the cousin of the seventh. Where the
  seventh re-derives the ANSWER in the probe, this one constructs the STATE: it calls
  production code by a path production does not have, so the code executes, the assertion
  is real, and the result says nothing about the product. **The tell: an assertion that
  reaches its subject by a call path no production caller can produce.**
  The instance, and it was found by accident rather than by suspicion: `reconReplay`'s
  causality guard `if (bt < p.t) continue` was unreachable — the caller clamps the replay
  window to at least `p.t` — and deleting it turned `[R43.2]` **red**, which is how the
  assertion was discovered to be holding it alive. That probe called `reconReplay`
  directly with a window starting before the trip existed. Green, on real production code,
  over a line that could never run in the product.
  **The consequence for the dead-guard rule, which is the load-bearing part: before
  deleting an unreachable guard, check whether an assertion is holding it alive.** A guard
  that looks dead and has a green assertion pointed at it is not evidence that the guard
  runs; it is evidence that something is calling it artificially, and the assertion has to
  move to the layer production actually uses before the guard goes. The repair here is the
  pattern: `reconWindowStart()` was extracted, the promise stated there, and the assertion
  re-pointed at it. Detector: **scan 13** below.

### A ratification that breaks no test is not evidence (user ruling, Aug 13 2026)

> **A ratification that changes behaviour and breaks no test has either NO coverage or
> STALE coverage, and green does not distinguish them.**

The instance: the sell dilution band was ratified from a flat 1.0% to a third of the item's
own spread — a live behaviour change, three cases reclassifying — and **the suite stayed
green**. `[R66.4]` asserted *"the live classifier is still the absolute one"* and kept
passing because it called the classifier **without a spread**, so the fallback band answered
and the superseded expectation still held. The assertion was testing a rule that no longer
existed, and passing for a reason unrelated to the claim in its own name.

This is the **twelfth face at one remove**: not manufacturing an impossible state, but
continuing to exercise a now-vestigial code path and reading its answer as the product's.
The tell is the same — the assertion reaches its subject by an argument shape the product no
longer uses at that call site.

**Standing practice: after any ratification that changes behaviour, check that something
went red. If nothing did, find out why BEFORE treating the suite as evidence.** There are
only three answers and two of them are defects: the change was genuinely uncovered; an
assertion is stale and is still passing on the old path; or the change did not actually take
effect. A green suite across a behaviour change tells you which of the three you are in
exactly as well as a coin does.

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

## Downloads auto-collect (user ruling, Aug 13 2026)

The browser cannot write to the repo, so every export the tool produces used to cost a
manual hop — find it in Downloads, move it, delete the ` (1)` copies. The flags file had
a collector; nothing else did, and the hop cost a step every session for a week.

**`bash tools/inbox/sweep.sh` is the collector, and it runs at SESSION START, not only
during a briefing.** For each export class it takes the newest by modified time, moves
it, and deletes that class's older members from Downloads:

| Class | Lands in |
|---|---|
| `analysis-paper-*` · `analysis-prospecting-*` · `analysis-gates-*` · `analysis-calibration-*` · `analysis-scorer-*` · `analysis-all-*` | `inbox/` |
| `ge-flips-*` (state backup) | `inbox/` |
| `flags-pending*` | `briefings/` — **unchanged**, because the briefing procedure reads it there by name |

Four properties, each of which is the rule rather than an implementation detail:

- **Downloads is resolved from the known-folder API**, never a hardcoded path — the
  machine may relocate it.
- **Every class reports a line, including `none found`.** Absence of a file and absence
  of a report are different things and the reader must not have to tell them apart.
- **Age comes from the file's own `generatedAt`, never its mtime.** An export that sat in
  Downloads for a day is a day old regardless of when it was collected. Over **6h** it is
  marked STALE and must not be read as current state; a file with no `generatedAt` reports
  *age unknown* rather than being assumed fresh. **If a question needs state the file
  predates, say so instead of answering from it** — this is the observed-time rule applied
  to an artefact.
- **Everything collected is gitignored** (`inbox/`, plus the standing `analysis-*.json` /
  `ge-flips-*.json` patterns). The repo carries the tool, never the data it produced.

**Three triggers, because a session-start-only sweep is the wrong shape** (corrected Aug 13
2026, on the first mid-session export after it shipped): **exports happen mid-session by
nature.** A session-start run collects what was already sitting there and misses everything
the user presses export for while working, which is most of them.

| Trigger | Mode | Why |
|---|---|---|
| `SessionStart` hook | verbose | the backlog that accumulated between sessions |
| `UserPromptSubmit` hook | `--quiet` | the opportunistic one that actually matters — silent unless something moved, so a no-op costs nothing and a collected file always announces itself |
| `/inbox` skill, or `bash tools/inbox/sweep.sh` | verbose | the explicit ask |

**Run it without being asked** whenever the user mentions exporting or dropping a file, and
**before reading any export** — the copy in `inbox/` may be older than what is in Downloads.

**The hooks are local and the script is tracked.** `.claude/*` is gitignored by standing
rule, so the hooks live in `.claude/settings.json` on this machine only; the behaviour is
inherited through this section, the `/inbox` skill (which is tracked) and the script itself.
Recreate the hooks with:

```json
{ "hooks": {
  "SessionStart":     [ { "hooks": [ { "type": "command", "command": "bash tools/inbox/sweep.sh",         "timeout": 60 } ] } ],
  "UserPromptSubmit": [ { "hooks": [ { "type": "command", "command": "bash tools/inbox/sweep.sh --quiet", "timeout": 30 } ] } ]
} }
```

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
