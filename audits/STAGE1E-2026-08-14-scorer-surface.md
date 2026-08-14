# Stage 1e — the scorer surface

2026-08-14 · same-day continuation after the 1d rulings, against the pushed baseline
`c3fc572`. Suite at close: **PROBE-PASS — 1,073 assertions, both viewports (1200×900
and 390×844), pairing clean both directions.** Deployment: **DEPLOY-OK at 1.0s on a
phone-viewport real boot, with the rendered first screen captured as the artifact.**
Tree uncommitted per standing practice.

This session also carried two mid-turn directives, recorded here because they rode the
same tree: **the log-flip landing fix** (§7) and **the mm-mode bench** (§8).

---

## §1 What was built

**Trade → Scorer**, a pull surface in the ruled class (read, not worked; zero rulings;
walk-up budget untouched). Three panels:

- **The verdict panel — the first screen.** One question ("Can this instrument tell me
  anything yet?"), one answer sentence ("It is measuring, not yet ranking…"), then the
  four waiting-on lines with real numbers: **accruing** (cycles + archive coverage with
  the observes-only-while-open honesty), **chart gates** (N of 7 OBSERVED days — never
  wall days), **ranking** (the ruled cannot-rank-yet words with the dependency named),
  **reconciliation diff** (day N, rows, its reader named). Below it the state line,
  which renders whether or not anything is wrong. IDB-backed figures load
  asynchronously into `S.scorerSurf`: pending reads say *reading the archive…*, failed
  reads say *could not check — treat as unread, never as current*.
- **The grid panel.** All 17 cells (16 + control, deduped): funded-per-cycle — a pooled
  average over 24 hour-band populations, so it renders WITH its peak/trough inline and
  ALL 24 bands in its opening (unfed bands read UNOBSERVED, never quiet) — flow totals,
  distinct-ever stock with the capped flag, the six-gate share, and the blacklist
  canary (opens to names; zero reads "none" with the counted-from-birth claim).
- **The econ panel.** The readiness verdict leads in the ruled words; each (horizon ×
  participation) renders in its own `[data-hz][data-part]` container — the never-pool
  rule made structural in the DOM — with per-capture-lifecycle columns (n + outcome
  census, nets at the three stated bounds, concentration as the top mover's share OF
  GROSS, pump decomposition), the three econ states under their own names, and every
  bucket opening to its trips with the truncation declared (7-day window of the 30-day
  ledger, cap, carried-of-total, T0-replay path for the remainder). **No ordering of
  cells renders anywhere while capture is ungraded.**

**The export** (`analysis-scorer-*.json`): header with every ruled constant, the
cannot-rank words, coverage figures, declared truncations, and standing caveats; cells
with bands, econ and canary; open and closed trip rows riding. Figures the session has
not loaded export as NOT LOADED, never a stale guess. Registered in the collector
(`analysis-scorer` class in sweep.sh; the CLAUDE.md table updated in the same commit).

**Glossary:** a new scorer group with nine entries (frontier, flow-vs-stock, capture
lifecycles, cannot-rank-yet, gross movement, hour bands, canary, six-gate,
reconciliation diff), each with all three fields, marked inline where the vocabulary
renders — same commit as the terms. The R38.6 scan caught my own first draft hedging
(`sc-rdiff` said "nothing directly" without naming its decision) and the entry now
names the cutover ruling it is context for. **The weekly review** gained the one-line
scorer summary with a link through (the pull-surface consolidation rule); the line
reads sync state only and says the coverage figures load on the surface.

**Staged stores consumed** (map §2b): `scorerT2` econ and the `t1` rows now have their
1e readers and come off scan 2's re-report list; `rdiff` **stays staged** for the
cutover gate — the verdict line's day-count read is informational and does not
discharge it.

**CLAUDE.md maintenance (factual, dated):** the surface map now lists seven Trade
sub-views with the Scorer described; "each of the three carries an export" became
"each pull surface"; the collector table gained `analysis-scorer-*`.

---

## §2 Conformance stanza (deltas against the ratified map)

- **BINDING touched:**
  - *Rule 3 re-enters at 1e as the map said it would* (its N/A expired): every
    automated verdict on the surface states its reason inline where the user reads it —
    the readiness verdict carries the ruled words and the named dependency, exclusions
    render their named split, the canary states what it is evidence against, the
    concentration figure names its gross denominator, and every bench/void the trip
    layer produces renders its reason on the mm and plan lines (§8). No decision
    renders as a bare state.
  - *Verdict-first / silent-state* → the first screen is the verdict (`[R80.2]`, seed
    T2); the state line renders always (`[R80.9]`, seed T12); the three econ states
    named (`[R80.6]`, seed T9); an unfed grid cell says never-fed; the canary's zero is
    a real reading (`[R80.5]`).
  - *Never pool* → horizon/participation groups structural in the DOM (`[R80.4]`, seed
    T6); the grid's pooled average ships its decomposition inline + full bands
    (`[R80.5]`, seed T7).
  - *Interrogability (scan 5 at 1e, as the map scheduled)* → every rendered number
    opens through the shared drill primitive; the DRILLS specs are asserted
    structurally (24 bands; trip rows with the truncation IN the drill, `[R80.7]`, seed
    T10); the export ships rows with every rollup and declares what it dropped
    (`[R80.8]`/`[R80.8b]`, seed T11).
  - *Staleness* → session-scoped stamps read "not yet this session"; a failed IDB read
    renders could-not-check and never a stale number (`[R80.2b]`, seed T4 — the
    failure-as-pending conflation proven caught).
  - *Glossary same-commit* → `[R80.10]`, seed T13; R38.6 live-caught my own hedge.
  - *Scoping tested by absence* → `[R80.1]`, seed T1 (computed visibility on the subs
    where the section must NOT appear).
  - *Readiness verdict wherever a ranking would render* → `[R80.3]`, seed T5, plus the
    ordinal-absence half; the deployment artifact shows the econ section leading with
    the ruled words on real data.
- **Detectors same commit:** §80 rows + assertions, the surface, the export, the
  glossary and the review line all ride this tree together.
- **Seeds:** 12 for §80 (T1, T2, T4–T7, T9–T14), one at a time, each red on its
  target, restore-green between; §7 and §8 added 1 + 4 more. All discriminating; two
  cascades recorded as propagation (T5's glossary mark; S2's kept-machinery renders).
- **Scans at the boundary:** scan 5 as above; scan 2 — staged list updated (map §2b),
  connectivity: every new panel names its writer and reader, `S.scorerSurf` is written
  by the loader and read by the surface + export; scan 7 — every rendered claim
  checked against its computation (the deployment artifact caught two live copy
  defects: "5m ago ago" and "1 scoring cycles" — fixed and re-greened, which is the
  claims-vs-computation scan earning its keep on real output); scan 8 — nothing new
  pools (the one pooled average ships its decomposition); scan 14 over the §80 labels
  — universals backed by enumerated states ("only on its own sub" — both directions
  driven; "wherever a ranking would render" — the positive and absence halves both
  asserted; "always" on the state line — seeded in the gated direction).
- **DOCTRINE by inspection:** zero-based complexity — the surface's price was paid by
  the weekly review keeping a one-line summary instead of re-rendering anything, the
  same consolidation that paid for the other three pull surfaces; walk-up budget
  untouched (a pull surface presents no decisions); the ships-with-detector doctrine
  at commit grain throughout.

**The era-fact tripwire:** still armed, untouched — chart wiring did not land;
`marketStatsFor().tr === null` stays green inside `[R76.9]`; the surface renders the
six-gate share at 100% and the export stamps it.

---

## §3 The walk-up test (the 1e acceptance criterion) — the artifact

Real network, fresh profile, **phone viewport (390×844)**, real boot. The deployment
check opened Trade → Scorer cold and captured the first screen as rendered:

> **Can this instrument tell me anything yet?**
> **It is measuring, not yet ranking.** Every mapped item is scored against the 16-cell
> grid each 5m bucket, and fills are simulated on the funded frontier at three capture
> points and two horizons. It cannot rank cells yet, and says so where a ranking would
> render, rather than ranking anyway.
> · **accruing** — 1 scoring cycle since 2026-08-14 · archive coverage 1 of 864
> five-minute buckets in the last 72h (it observes only while the app is open — the
> gap is unobserved time, not quiet market)
> · **chart gates** — 0 of 7 OBSERVED days accrued — trend, volume trend and momentum
> stay unknowable until 7 (observed days, not wall days); every verdict so far is
> six-gate and stamped so
> · **ranking** — cannot rank yet — capture is ungraded until real flips exist on
> frontier-class items; the dependency is the operator's calibration flips inside the
> tape window
> · **reconciliation diff** — day 1 — 1 row of control-vs-plan history (the cutover's
> plumb line; its reader is the cutover gate)

State line beneath: *"Scorer state: bucket last scored 5m ago · fill sim last opened
5m ago · archive last wrote 5m ago · 744 open trips across 124 items · no failure
streaks — this line renders whether or not anything is wrong."* The econ section leads
with the ruled words. That is the dictated read — accruing, chart gates N of 7
observed days, cannot rank pending calibration flips, reconciliation diff at day N —
as a sentence and four lines, not a wall of scaffolding. (Your own phone is the final
judge; this is the same build at the same viewport.)

The same boot: **744 trips = 124 frontier items × 3 participation × 2 horizons**
(h6/h9.5 split exactly 372/372), all in the carry; control funded 10 at 19:20Z,
loosest cell 124 — the frontier read 115 → 134 → 124 across three real boots today,
the churn on display. The two copy defects the artifact caught were fixed and the
suite re-greened before this report.

---

## §4 What did not happen, said plainly

- **Chart wiring did not land** (tripwire armed, §2).
- **Rankings do not exist anywhere** — by ruling, until capture is graded.
- **The b=100 corner stays deferred** (ruled; restated on the export's caveats).
- **The rdiff store stays staged** for the cutover gate (map §2b).
- **Nothing was committed**; the tree carries 1e + the two directives below.

---

## §5 Suite and seed ledger for this session (post-1d)

PROBE-PASS 1,073 (from 1,055 at the 1d close): +13 §80, +3 §79 (mm bench), +1 R24.3
(landing), plus repairs. Seeds this session: 12 (§80) + 4 (§79 S1–S4) + 1 (R24.3) =
**17, all bit, one at a time, restore-green between each**; both-viewport pass at
close.

---

## §6 Rulings pending from this stage

None. The stage introduced no new constants and applied no unruled boundary — the
ceiling and readiness were ruled at 1d; the surface only renders them.

---

## §7 Mid-turn directive: the log-flip landing (fixed, seeded, real-pressed)

**Diagnosis (one line):** the press performed NO landing at all — it bare-focused the
qty input and let the browser's focus-scroll (geometry- and soft-keyboard-dependent,
never offset for sticky chrome) decide where the viewport ended up; the R24.2 landing
idiom was simply never applied to this press. Desktop Chromium happens to land
acceptably (two headless repro attempts landed clean); the phone soft-keyboard
displacement is the reported failure and is not reproducible headless — stated rather
than claimed.

**Fix:** `navLand()` extracted from `navGoto` (behaviour unchanged — one landing
implementation); `logFromWatch` lands on `#logForm` through it, with both focuses
(`immediate` and the async prefill's re-focus) carrying `preventScroll` so neither can
fight the landing. Scope held: no other scroll behaviour touched.

**Proof:** `[R24.3]` asserts structurally (the form is the landing target and holds
focus; the panel below is NOT the target) — seeded by retargeting the landing at the
Sharpe box, red on both halves. **Real-press artifact** (phone viewport, real build,
real button): post-click the viewport sat at y=2548 — the old code's end state — and
the deferred landing took it to y=366 with the form title at 121px, exactly 10px below
the 110px chrome; focus on the qty input; first visible panel = the form.

**Same-class site, LISTED not fixed** (per scope): the sleeve form's direct
`scrollIntoView` (`#slvFormPanel`) has no measured chrome pad — same overlay class.
**FRICTION.md carries no entry for the landing bug; nothing to close there.**

---

## §8 Mid-turn directive: MM mode benched (disabled, not deleted)

**Measurement first, answered from the schema: CANNOT ATTRIBUTE.** Flip records carry
no mm stamp (`itemId, qty, buy, sell, date, note, tier`, fill-telemetry fields — and
nothing else) and `invTarget` keeps no history, so which flips were mm flips is
unrecoverable. The bench rests on walk-up attention cost, and the decision log records
exactly that — with the in-flight snapshot (enrolled items, targets, held units at
FIFO cost, standing legs, lots-without-mode) computed **in your browser** at the
benched build's first poll, so the cutover un-bench has its evidence base. Written by
the tool, decided by you (`auto: 1, by: "user"`, asserted).

**In-flight state first-class — nothing strands, nothing vanishes:** standing quote
legs keep rendering, ageing, filling, repricing and clearing until resolved (they are
real offers in-game); held lots stay tracked and sellable through the FIFO true-cost
flow (MM UNWIND lines with the reason inline — the unwind is yours to execute, the
tool proposes sell-down); the mm panel states the bench where the machinery renders.

**Disable, don't delete:** `MM_BENCHED = true`, pinned (`[R79.1]` — seed S1 flipped it
and five assertions went red: the un-bench cannot land silently); no new enrollment,
no new placements, MM-READY lines stop; per-item `invTarget` persists frozen and
re-keys as pinned-item state at cutover, or retires by ruling. **The plan reverts per
item as its unwind completes:** nothing in flight → normal plan handling; lots or a
standing quote → benched with the unwind named (R16.1 amended to the benched-era
form). The §9 kept-machinery fixtures now construct standing records directly —
production-shaped — since placement itself is benched and its refusal is R79.1's
assertion. Four seeds (S1–S4), all bit. The mandate-gate glossary entry carries the
bench caveat. *(The directive's point 3 arrived truncated mid-sentence; the visible
spec — persist, re-key at cutover or retire by ruling — is what was built.)*
