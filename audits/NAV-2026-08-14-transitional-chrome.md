# NAV-2026-08-14 — Transitional nav + header refresh (display-only)

**Ruled scope:** the chrome presents the ruled dichotomy — what would my rules find in
the market (Scorer) versus what is my actual trading doing (plan, log, capital). This is
the TRANSITIONAL refresh; the full consolidation to Scorer / Book / Sleeve is a
cutover-era change and was deliberately not built. Display-only: no behavior changes, no
constant moves, no surface logic touched. Baseline `f0bf448` (clean, pushed).

**Suite at close: PROBE-PASS — 1,072 assertions, BOTH viewports (1200×900 and
390×844), pairing clean both directions, 378 requirement ids. 16 discriminating seeds
(S1–S16), all bit, one at a time, restore-green between.** Deployment: **DEPLOY-OK at
0.5s** on a phone-viewport real-network fresh-profile boot (§5). Tree uncommitted;
committing is the user's press after the phone look.

---

## §1 Header tiles — before / after (ruled)

| slot | before | after |
|---|---|---|
| 1 | FUNNEL — pass · funded · % deployed | unchanged; **tooltip corrected** (was advertising "first-fail attribution", the demoted positional number — now: leave-one-out leads, first-fail labelled as ordering) |
| 2 | PAPER BOOK — open · closed (30d, simulated) | **SCORER** — `scorerTileLine()`: rank-readiness in the ruled words · chart gates N/7 observed days · frontier size at the last scored bucket |
| 3 | SLEEVE | unchanged (copy swept, nothing stale) |
| 4 | CAPITAL | unchanged (copy swept, nothing stale) |

The paper book's open · closed read moved to its own surface header
(`#paperRegimeSub`, asserted under `[R65.1]`'s dormant form). Nothing was deleted.

**The tile's source term** is `scorerTileLine()` — extracted per the `paperDivLead`
pattern so the assertion points at the term, and the wiring assertion proves the tile
renders exactly it. Honest states, each seeded: *reading…* (pending IDB read), *could
not check* (failed read — never a number, never still-reading), *no cycle yet this
session* (no stale frontier), and the counted state with the frontier's bucket age
inline. The readiness clause can only flip when `scorerRankReadiness()` itself does —
the tile compresses the ruled phrasing, never contradicts it. The async chart-gate
fill-in is a **targeted text refresh of the tile alone**, never a full vitals render
from the callback (renderHomeVitals runs the plan; async re-runs stamp ledgers at
unpredictable moments — the R65.1 lesson).

**`paperDivLead` now has no production caller in any era.** Its gated `[R65.1]` live
branch is rewritten as an **un-retire tripwire**: a deliberate red stating that an
un-retire ruling must name the divergence lead's render home before the race can ship
live (the pinned-era-fact pattern).

## §2 Trade sub-tab row — ruled order + subdued treatment

Before: Plan & Watchlist · Scanner · Flip Log · Paper Book · Prospecting · Gate Health · Scorer
After: **Plan & Watchlist · Flip Log · Scorer · Paper Book · Gate Health · Scanner · Prospecting**

Scanner and Prospecting carry `.sunset` (opacity .62 at rest, **full strength while
active** — the subduing is for scanning the row, not for reading the open surface), and
nothing else does. Both stay fully live; their tooltips state the era ("cutover-era
retirement candidate — retires only by ruling after the cutover proves out") plus what
still accrues. Asserted structurally (`[R82.1]`): exact order, exact class set, computed
opacity at rest and active. Order change is HTML-only — navigation is keyed by
`data-sub`, nothing reads position.

## §3 Proposals — **BOTH RATIFIED as recommended (user ruling, same day) and applied in §8**

**3a. Prospecting's disposition — recommend: leave until cutover (option c). RATIFIED.**
- *(a) fold the gap band elsewhere + dormant the tab*: the band still accrues live paper
  entries at its ruled `floor(SLICE_SHADOW_CAP/2)` share and serves TWO held rulings —
  the T3 scanner bar's clean-trip count renders on Prospecting, and the routing question
  reads the band's stamped populations on the Paper Book's overnight panel. Folding it
  into Paper Book moves an admission-space concept into
  the book's population space, costs a drill/anchor migration mid-era, and the cutover
  ruling will consolidate surfaces wholesale anyway — pay once, not twice.
- *(b) rename the tab to what it now is*: cosmetic churn on a tab that is already
  subdued and already truthful (tooltip + dormant banners); a rename invalidates the
  feature-touch keys' history for no decision benefit.
- *(c) leave until cutover* — **recommended**: the subdued treatment built here IS the
  era signal; the tab's remaining live content (gap band, hours ledger) has standing
  readers; retirement lands with the cutover ruling where it belongs.

**3b. Paper Book era qualifier — recommend: header, not tab. RATIFIED.**
Keep the tab label "Paper Book" (stable identity, phone tab width, muscle memory).
Add the qualifier where the surface header already states its own era:
`#paperRegimeSub` gains "· the cutover's plumb line" — the phrase the scorer's verdict
line already uses for the rdiff ledger's role. Ships with its glossary entry
in the same commit per the standing rule. Persisted keys never move either way.

## §4 FRICTION.md sweep

The live queue is **empty** — no open entries to triage (FIX NOW: none · NEEDS RULING:
none · MOOT: none). One hygiene defect in the file itself: the two 2026-08-11 resolved
entries (mm both-filled/repriced; the sleeve coherence-block collapse) cited `_pending_`
commit hashes. Both resolve to `b9c8add` ("Accrual rides the poll, not a render path;
friction notes addressed") — filled in, dated 2026-08-14.

**One observation from this pass, not a friction entry (agent finding, not reported
pain):** at a TRUE 390 CSS-px viewport (`--force-device-scale-factor=1`) the page
overflows horizontally (right tile column and header clipped). **Baseline-identical** —
verified by screenshotting `HEAD:index.html` under the same condition — so it predates
this pass and was not introduced by it. The ruled phone runs (`PROBE_WINDOW=390,844`,
no scale override) render at ~518 CSS px where the layout fits. Flagging for the
user's own phone look; a fix would be its own display pass.

## §5 The deployment artifact (M154: one real boot proves the deployment)

Real network, fresh profile, phone viewport, the real `index.html` plus the beacon
snippet only. Verbatim:

```
PROBE DEPLOY-CHECK — transitional nav, real-network fresh-profile boot
viewport: 518x747
bootToFirstPollMs: 501
bootToFirstScoreMs: 517
tiles: ["watch#deployPanel","scorer#scorerVerdictPanel","sleeve#sleevePanel","review#tab-shadow"]
scorerTile: "Scorermeasuring, cannot rank yet · chart gates 0/7 observed days · frontier 145 items (bucket 5m ago)"
funnelTile: "Funnel0 pass · 0 funded · 0% deployed"
subtabs: ["watch","log","scorer","paper","gates","scan(sunset)","prospect(sunset)"]
scanOpacityAtRest: 0.62
paperOpacityAtRest: 1
paperSurfaceSub: "3 open · 0 closed trips · 0 daily readings · simulated throughout"
frontierN: 145
frontierBkt: 2026-08-14T23:35:00.000Z
errs: []
```

First poll at 0.5s; the first real bucket scored a **145-item frontier** and the tile
rendered it with its bucket age; chart gates honestly 0/7 on a fresh profile (observed
days, not wall); the paper surface header carries the open · closed read (3 paper trips
opened on the fresh profile's first scan). Screenshots captured at the same condition
(Home chrome; Trade row with the subdued candidates visible) — handed to the user in
session. The viewport condition (518 CSS px at window-size 390,844) matches every prior
deploy artifact on this machine.

## §6 Conformance stanza

**BINDING rules touched, each with its check:**
- *Claims-vs-computation (scan 7) over every reworded string*: funnel tooltip's stale
  "first-fail attribution" claim corrected to leave-one-out-leads (the R73.10 surface's
  own ordering); scanner/prospecting era tooltips tightened to "retires only by ruling
  after the cutover proves out" (the restraint/deployment line — no expiry implied);
  Prospecting's "Where the edge lives" lead removed (the scorer holds that question —
  the prospect verdict already says so); every tile clause traced to its computation
  (readiness ← `scorerRankReadiness()`, days ← `h1.observed/24` labelled *observed*,
  frontier ← cycle-stamped readout with bucket age).
- *A component reports nothing vs HAS nothing (scan 2, silent-state, over the new
  tile)*: three absence states built and seeded — reading…, could-not-check,
  no-cycle-yet — none renders as a number or as up-to-date.
- *Interrogability (scan 5)*: the tile adds no new aggregate; it is a click-through to
  the Scorer surface where every figure opens to its rows (`[R80.x]`, green). The
  paper surface header's open · closed read sits above drills that already decompose.
- *Pooling (scan 8)*: no new pooled statistic; the tile renders single readings.
- *Staleness rule*: could-not-check ≠ up-to-date asserted; the frontier figure carries
  its bucket age in the line; a pending read never shows a number.
- *Restraint/deployment*: nothing armed, nothing lifted — display only.
- *Walk-up budget*: 0 decisions added on any touched surface (tiles and tabs are
  click-throughs); the ≤7 probe bound green on both viewports. Before/after: hold.
- *Glossary same-commit*: no new glossed term rendered — every tile word ("cannot rank
  yet", "chart gates", "frontier") already ships entries from 1e; tiles are controls
  and stay popover-free per the standing restraint.
**Detectors shipped in the same commit:** `[R82.1]` (order, class set, computed
opacity both states), `[R82.2]` (five term states), updated `[R20.3]` (ruled tile
order + term wiring with a pinned, self-checking distinctive fixture), `[R24.2]`
(scorer tile wiring + the new landing destination), `[R65.1]` (dormant form re-pointed;
un-retire tripwire); REQUIREMENTS §82 + row updates (R20.3, R24.2, R65.1, R81.1) and
the CLAUDE.md surface map ride the same tree.
**The ratification-breaks-no-test check:** the chrome change was run against the
UNTOUCHED suite first and turned exactly the three expected assertions red (R20.3
paper tile, R24.2 paper wiring, R65.1 dormant tile form) — coverage confirmed before
any assertion was edited.
**Seeds (all bit, one at a time, restore-green between):** S1 hand-rolled tile copy →
wiring red; S2 order swap → order red; S3 sunset off Scanner → marks + at-rest red;
S4 sunset on Gates → marks red (absence half); S5 `.sunset.on` rule deleted →
active-full-strength red; S6 at-rest dimming neutered → at-rest red; S7 readiness
contradiction → ruled-words red (wiring stayed green — correct discrimination);
S8 pending read claims a number → reading red; S9 could-not-check claims a number →
could-not-check red; S10 no-cycle guard dropped → no-cycle red + with-data red (bucket
clause); S11 days arithmetic /12 → with-data red + R20.3 fixture self-check red (the
pinned-distinctive-fixture guard biting on the same seed); S12 divergence clause
re-added to the strip → absence red; S13 open count dropped from the paper header →
open·closed red; S14 tile goto to review commentary → three wiring/order reds, same
defect; S15 scorer anchor renamed → landing red; S16 (after the at-rest widening)
sunset on Gates → marks + widened at-rest red.
**Fixture notes:** the R82.1 opacity reads wait out the global `button{transition:.12s}`
before reading (a synchronous read sees the transition's starting frame — the
simultaneity lesson on a render clock); the R20.3 wiring fixture pins a distinctive
2.2/7 figure and self-checks it, so a hand-rolled tile or an undistinctive fixture
both fail (the decoy discipline).
**Scan 14 over the new assertion labels:** 4 findings, fixed before close — "lands on"
→ "is wired to" (landing is R24.2's measured subject); "NOTHING else — signaled,
never hidden" trimmed to what the equality tests; "never up-to-date" dropped where no
copy match backs it; the R65.1 label trimmed to its copy-absence subject; plus the
at-rest assertion widened from two spot-checks to all seven tabs to match its plural
label.
**DOCTRINE satisfied by inspection, listed as inspection:** complexity budget — the
tile slot is re-awarded, not added (the flagship slot's occupant changed; four tiles
before and after); the subdued treatment displaces nothing.

## §7 What did NOT move (scope fence)

No gate, constant, accrual, admission, or export logic. The scorer tile's only
production-side additions are two session display readouts stamped in `scorerCycle`
(`S.scorerFrontierN`/`S.scorerFrontierBkt` — nothing gates on them), one shared
staleness helper (`scorerSurfEnsure`, so the tile and the Scorer view cannot disagree),
and the targeted tile-text refresh in `scorerSurfLoad`'s completion. Persisted keys
untouched. *(§3's proposals were unapplied at this section's writing; both were
ratified the same day and applied in §8 below.)*

---

# SECOND PASS, SAME DAY — the ratified items + the friction export

**Suite at close: PROBE-PASS — 1,087 assertions, BOTH viewports, pairing clean both
directions, 384 requirement ids. Eight further discriminating seeds (S17–S24), all bit,
one at a time, restore-green between.** Deployment: **DEPLOY-CHECK2 clean** — a
real-network fresh-profile phone boot logging a friction note through the real UI and
exporting it (§11).

## §8 The two ratified chrome items, applied

**8a. Prospecting: leave until cutover — decision-logged** (`prospectHoldLog`, the
R81.3 shape: once per store, `auto: 1, by: "user"`, RATIFIED, the cutover named), so
the cutover consolidation inherits a decided item. Rides the same poll site as the
retirement logs. `[R82.3]`, seeded (S17: guard removed → double-log caught).

**8b. Paper Book era qualifier: header, not tab.** `#paperRegimeSub` now ends
"· the cutover's plumb line", glossed inline; the tab label stays "Paper Book"
(asserted as a negative) and persisted keys do not move. **One term, one meaning:** the
phrase already had two referents (the paper book as fill-model reference; the rdiff
ledger), so the new `plumb-line` glossary entry covers both as members of one concept —
a standing reference the cutover gate reads — and the scorer verdict's occurrence now
marks from the same entry, so the definition cannot fork. `[R82.4]`, seeded both
halves (S18 header, S19 verdict mark).

## §9 The friction export — the missing leg of an existing loop

**What existed** (built Aug 10–11, and why the gap was real): capture (`✎ note
friction`, global footer on every tab, one field, ctx + timestamp auto-stamped,
`DB.frictionLog`), the walk-up capture step, the weekly reader with the
open / exported / handled lifecycle — but the ONLY carry-out was a clipboard
markdown copy inside the weekly review checklist, which a phone cannot usefully reach.
The user hunting for "export the friction log" and not finding it was the gap's own
proof.

**What was built — no new infrastructure, per the ruling:**
- `analysisFriction` on the EXISTING analysis bus (`ANALYSIS_BUILDERS.friction`):
  header (counts: total / carriedBefore / resolvedInApp / inFile; truncation: none;
  the claims sentence), entries = every never-carried note, open and resolved alike,
  each with capture timestamp, date, ctx, and `resolvedAt`. The builder is READ-ONLY.
- The carry stamp rides the export press (`frictionMarkCarried`, after the payload is
  built): marks `exp` — the SAME field, same meaning the markdown copy stamps — and
  deletes nothing. "Clear exported" stays the one explicit sweep (M152's shape).
- Affordances: a `⭳ export` chip INSIDE the global ✎ disclosure (zero standing
  elements added above the first disclosure — the cold path is the friction button
  itself), and `⭳ export for FRICTION.md` in the weekly review's friction step, which
  now renders its control row even when zero notes are open (the population can be
  resolved-unexported).
- **Accumulating class:** successive exports carry DISJOINT entries, so filenames are
  time-suffixed (`analysis-friction-<date>-<hhmmss>.json`, still under the
  `analysis-*.json` gitignore) and `sweep.sh` gained `sweep_accum` — moves EVERY
  member, deletes only byte-identical duplicates (content compared, not names),
  idempotent, collected members stay in `inbox/` until folded. Keep-newest would have
  destroyed notes the app had already stamped carried.
- **Desk side** (CLAUDE.md standing instruction): a collected friction file is folded
  into FRICTION.md in the same pass, entries dated from their CAPTURE timestamps, the
  fold reported, the folded file then removed — an unfolded file in inbox/ is work
  owed, not archive.
- **Live defect found and fixed on the way:** the state-backup import sanitizer
  rebuilt friction rows without `exp`/`res`, so a restore silently revived carried and
  handled notes as open. Fixed; absent stays absent. `[R83.4]`, seeded with the
  original defect (S23).
- **Partition register** (conformance map §2): `frictionLog` row answered
  retroactively per the register's own rule — writer regime is the user's press only
  (the press is the provenance; no `auto`/`by` field until an automated writer
  exists, which then adds `by` before its first row), `exp`/`res` are the lifecycle
  fields, export files are the accumulating class.

## §10 Verification for the second pass

**Seeds S17–S24, one at a time, restore-green between, all bit:** S17 once-guard
removed → double log; S18 header qualifier dropped; S19 verdict mark dropped (S18's
partner assertion stayed green both times — the halves discriminate); S20 export
filter removed → three R83.1 assertions red, same defect; S21 mark replaced with
deletion → the mark-vs-removal discrimination (`len:1`) plus the re-export counts;
S22 builder made to stamp → the read-only assertion (`[true,true,true]`) plus the
press-stamp count; S23 the sanitizer's original defect re-seeded → lifecycle-carry
red; S24 the chip pulled from the ✎ disclosure → the scoped affordance assertion
(the review-step copy did not satisfy it — narrowest container held).
**Sweep verified with planted fixtures:** two distinct friction files + one
byte-identical browser copy in the real Downloads → both distinct files collected,
the identical copy dropped as a duplicate, older distinct members NOT deleted, second
run a clean no-op ("none found to collect"). One cosmetic note: which of two
identical-content names survives depends on find order — content decides, names stay
unique and dated.
**Scan 7 over the new copy:** button titles, toast, badge tooltip, gov-friction and
plumb-line entries each traced to computation; one catch in my own draft — the
prospect ruling's reason claimed both held-ruling bars render on Prospecting when the
routing bar renders on the Paper Book's overnight panel — fixed before the string
could land in any real store. **Scan 14 over the new labels:** clean ("ONLY",
"nothing", "never" each backed by an explicit negative or count check).
**Walk-up budget:** unchanged — capture predates, the export adds no decision.

## §11 The overflow scoping (report only — nothing changed)

Diagnostic walk at forced device-scale-1 (the harness renders a 390-px window at
~477 CSS px in page mode and ~390 in screenshot mode; the ruled `PROBE_WINDOW`
phone runs render at ~518 — so the ruled verification has never exercised true 390):

- **At ~477 CSS px: zero body-level overflow.** Every wide table (watch 555px, scorer
  grid 651px) scrolls INSIDE its `.tw{overflow-x:auto}` wrapper by design — that is
  the intended phone behaviour and needs no fix.
- **At true ~390:** the body's min-content lands around 440–480, so the whole page
  shifts/clips (the earlier screenshot: header Refresh, right tile column, panel text
  all cut by the same amount). The offenders are not tables but **fixed-min-width
  flex/grid compositions**: `.funrow{grid-template-columns:230px 1fr 130px}` (min
  ~400), `.ac{min-width:170px}` beside its row siblings, `ol.plan li .body
  {min-width:220px}` in flex rows, the sleeve form's `min-width:300px` labels, and
  the header controls row (no wrap).
- **Fix shape and cost:** a display-only pass of roughly a dozen CSS rules —
  `flex-wrap` on the header/controls rows, `minmax(0,…)`/`fr` or an `overflow-x`
  wrapper for `.funrow`, and audited `min-width` reductions — verified by an
  offender-walk assertion at true 390. **The ~518 ruled phone runs would look
  unchanged** (everything already fits at ≥477). A real layout redesign is NOT
  indicated; this is a wrap-and-minmax pass, one session. Nothing changes until the
  user rules after the real-phone look.

**RULING (user, Aug 14 2026): the pass is PRE-APPROVED exactly as scoped above,
conditional on the real-phone look.** If the phone shows horizontal clipping, the
wrap-and-minmax pass builds with no further ruling — the scope (the dozen rules, the
offender-walk assertion at true 390, ~518 runs unchanged) is the fence, and anything
beyond it is a new proposal. If the phone renders like the ruled runs (~518
effective), the pass is SKIPPED and the observation closes as **device-dependent,
not-reproduced-on-target-hardware**. The trigger lives in HANDOFF's waiting posture.

## §12 The deployment artifact (M154) — the feature's own path, cold

Real network, fresh profile, phone viewport; the beacon drives the REAL affordances
(button presses and a real Enter keydown; the only instrumentation is an observation
wrapper reading the blob the real press produced). Verbatim:

```
PROBE DEPLOY-CHECK2 — friction capture + export, real-network fresh-profile phone boot
bootMs: 2021
bootLandedOn: home/watch
fricBtnVisibleCold: true
disclosureOpenedOnPress: true
noteCaptured: true ctx: "home/walkup" t: 1786754574710
exportFileName: "analysis-friction-2026-08-14-004254.json"
exportHeaderCounts: {"total":1,"carriedBefore":0,"resolvedInApp":0,"inFile":1}
exportEntryTexts: ["deploy-check: logged from a phone boot — the capture-and-export loop, cold"]
entryStampedExportedAfterPress: true storeLenUnchanged: 1
errs: []
```

The cold path works end to end on a phone boot: the ✎ button is visible on the boot
tab, the press opens the disclosure, the real Enter captures with the auto-stamped
context, the export press produces a correctly named file carrying exactly the
un-carried note with honest counts, and afterwards the note is stamped exported with
the store length unchanged — a mark, not a removal.

---

# THIRD PASS, SAME DAY — SCORER ITEM VISIBILITY (user ruling)

**Suite at close: PROBE-PASS — 1,100 assertions, BOTH viewports, pairing clean both
directions, 390 requirement ids. Ten further discriminating seeds (S25–S34), all bit,
one at a time, restore-green between.** Deployment: **DEPLOY-CHECK3 clean** (§17) —
a real-network fresh-profile phone boot rendering NAMED items in every new section.

## §13 The disclosure map — before / after

Before: verdict block → state line → [Grid panel fold] → [Econ panel].
After: verdict block (the rdiff line now carries an inline **named-disagreements
drill**) → state line → **§1 control-cell funded set (closed fold)** → **§2 frontier
browser (closed fold)** → **§3 delta memberships (closed fold)** → [Grid panel fold]
→ [Econ panel]. **Elements above the first disclosure: unchanged** (the verdict head,
its four waiting-on lines, the honesty line, the state line — the only addition inside
that region is the rdiff drill face, which is itself an opener, not content). Every
list is a closed disclosure whose label carries the count of the rows inside it, and
every table rides the `drill()` primitive (sort/filter/truncation inherited).

## §14 The four sections, and what shaped them

- **§1 Control-cell funded set** — the control's pass set at the last scored bucket,
  named, sorted by **post-tax margin** (the sort figure is stated in the copy, beside
  the distinction that cannot-rank gates cell rankings, never membership; "would
  fund" conditional throughout). Two drills: figures (margin / ROI / **gate-side** 1h
  volume, labelled as the min-of-sides the gate actually reads / session hour bands)
  and the **full gate detail** — every gate's value against the control config's own
  constants via the new one-owner evaluator, with unknown chart gates reading
  *skipped, not failing*.
- **§2 Frontier browser** — union membership with **funded-by breadth** (M of 16,
  glossed `sc-breadth`), compact cell keys, session hour bands, session flow beside
  distinct-ever stock (each labelled with its scope; the SCORER_ID_CAP truncation
  declares itself when any cell's stock is capped). **Blacklist shaped this render:**
  a vetoed item is never a member — it renders only in the ruled canary count line
  (which opens to names; sight, never funding), and the zero renders as the canary's
  zero in words. Pump-stamped items carry ⚑ inline, stamped never excluded.
- **§3 Delta memberships** (glossed `sc-delta`) — ladders through the control's grid
  coordinates: 4 taxMult notches at the control's volBase, 2 volume-base notches at
  its taxMult, plus the one ruled roi notch (m0.5 b250, where the stated floor
  re-emerges). Names and market figures only; **cannot-rank shaped this render:**
  where each notch's net would appear, the ruled words appear instead, and the probe
  asserts no gp net exists anywhere in the section while capture is ungraded.
- **§4 Rdiff window** — the verdict's reconciliation line opens to the CURRENT
  cycle's named disagreements, cohort-split in one drill (control passes · watchlist
  lacks / plan-funded · control fails, the latter with FULL fail sets in config-free
  keys), labelled informational: the ledger's reader is still the cutover gate, the
  staged status (scan 2's re-report) does not change, and the plan side's unobserved
  state renders its reason.

**Data layer, display-only:** the cycle now stamps display readouts (`S.scorerFrontier`
snapshot with per-item stats, `S.scorerCtlPass`, `S.scorerBlCycle`, `S.scorerRdiffLast`
— the same row the ledger just took) plus a session per-item history (cycles funded,
hour bands, cells — session-scoped by design, labelled "this session" wherever it
renders). Nothing gates on any of it; no persisted store was added, so no partition
row. Names come from the cached /mapping; zero new API calls.

**The one production refactor:** `marketGateEval(st, cfg)` — ONE evaluator returning
all gates in chain order with pass/fail/unknown — with `marketGateFails` DERIVED from
it, so the pass-value display and the fail chain cannot disagree (a second evaluator
would be the re-implementation trap in production). Equivalence preserved exactly and
the §74 assertions continue to pin the derived chain: the ROI null limb still fails
(the live chain's own bench), a momentum fail still carries `have: null`, unknown is
still not failing. The refactor changed no behavior and correctly broke no test; the
new `[R84.6]` assertions pin the eval's own states, seeded.

## §15 Verification

**Seeds S25–S34, one at a time, restore-green between, all bit:** S25/S26 the
reconcile property both directions (label +2; rows −1); S27 sort figure silently
swapped to ROI under a margin label (the fixture's margin and ROI orders deliberately
disagree, so the swap had to express); S28 a blacklisted item leaked into membership
(two assertions red, same defect — the veto and the reconcile both caught it);
S29 pump mark dropped; S30 a gp net rendered where the cannot-rank words belong (both
halves — words absent, net present); S31 the rdiff fail set collapsed to first-fail;
S32 a `+ watch` button planted in a section (the button-census caught the stowaway:
13 buttons, 12 drill faces); S33 a null margin read as pass (the eval property alone
went red — the derived chain correctly unaffected); S34 the momentum fails-shape
drifted (`have: "knife"`).
**Scan 7 over the new copy:** every clause traced — gate-side volume named as
min-of-sides; session figures scoped "this session"; the truncation note conditional
on an actually-capped cell; the delta label counts MEMBERSHIPS (an item can appear at
several notches), worded exactly so; the rdiff head's not-a-new-consumer claim
matches the code (an S-readout of the row the ledger already took).
**Scan 14 over the new labels:** clean — every "NEVER"/"NO"/"every"/"FULL" is backed
by an explicit negative or census check.
**Glossary:** `sc-breadth` and `sc-delta` shipped same-commit, three fields each,
marked inline at first use; `sc-cannotrank` and `sc-canary` reused.
**Walk-up budget:** a pull surface, zero rulings added; above-first-disclosure element
count unchanged (reported in §13).

## §16 Ruled constraints that shaped the render (stated, not implied)

1. **Cannot-rank** gated §3's economics slot (the ruled words render where a net
   would) and §1's sort copy (display sort ≠ cell ranking) — it never gated
   membership, which is the ruling's own line.
2. **No-actions** removed nothing that was wanted — but it is why every button in the
   sections is a drill face and why the census assertion exists at all.
3. **Blacklist** turned §2's membership into members-plus-canary-line: vetoed items
   are visible as counts that open to names, never as fundable rows.
4. **Truncation** (SCORER_ID_CAP) shows up only in §2's stock figure and declares
   itself only when a cell has actually capped — a permanent warning about a cap
   nothing has hit would be wallpaper.
5. **The staged rdiff status** is untouched: §4 is a window on the row the ledger
   just took, and both the code comment and the drill head say so.

## §17 The deployment artifact (M154) — named items on a real boot

Real network, fresh profile, phone viewport. Verbatim:

```
PROBE DEPLOY-CHECK3 — scorer item visibility, real-network fresh-profile phone boot
bootToScoreMs: 517
ctlLabel: What my current rules would fund right now — 8 items
ctlRows: 8 · first: Armadyl chaps | Amethyst dart(p+) | Squid paste | Lumbridge teleport (tablet) | Unicorn horn (+3 more)
ctlTopFigures: {"margin":"20k","roi":"11.16%","vol":"16/h"}
frontierLabel: Everything any cell would fund — 129 items
frontierRows: 129 · first: Amethyst dart(p+) | Armadyl chaps | Falador teleport (tablet) | Lumbridge teleport (tablet) | Squid paste (+124 more)
frontierTopBreadth: 16 of 16 [CTL·m3b1000 m3b500 m3b250 m2b1000 m2b500 m2b250 m1.5b1000 m1.5b500 m1.5b250 m1b1000 m1b500 m1b250 m0.5b1000 m0.5b500 m0.5b250 m0.5b250r1]
blLine: rendered its zero form ("No blacklisted item qualifies…" — the beacon's count
        regex only matched the nonzero form; the page HTML contains the line)
deltaLabel: What one notch admits — 87 delta memberships across 7 adjacent pairs
delta0admits: 8 · Sunfire fanatic cuirass | Dagon'hai robes set | Elder chaos robe (+5 more)
cannotRankInDelta: true
rdiffLine: this cycle: 8 named disagreements
errs: []
```

First real bucket at 0.5s: the control would fund **8 named items** (Armadyl chaps
leading at 20k margin / 11.16% ROI), the frontier browser carries **129 named items**
with Amethyst dart(p+) funded by all 16 cells, the m3→m2 notch admits 8 named items
(Sunfire fanatic cuirass first), the cannot-rank words stand in the delta section, and
the rdiff window names 8 disagreements. A screenshot of the surface with the control
list open (real names visible in the drill table) was captured on the same build and
handed to the user in session — the screenshot harness crops by injecting a negative
top margin after render; the beacon run is unmutated.
