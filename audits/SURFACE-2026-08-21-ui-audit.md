# SURFACE-2026-08-21 — the post-cutover UI audit (Parts B and C of the cutover-visibility directive)

**Propose-only.** Nothing in this file has been changed in code. Every verdict is a proposal;
the user rules row by row. Method: four read-only agents over the landed tree (batch + Part A),
each reading the FEEDER of every element in code rather than judging from the screen. The
constraints ruled with the directive apply: for every RETIRE/CONSOLIDATE the loss is argued, not
asserted; where the observation week wants an old surface as a cross-check, the verdict is
DORMANT AT MATURITY; the dormancy lane (never deletion) is the mechanism for everything ruled out.

Line numbers are the tree as of this audit (post-batch, post-Part-A).

---

## Part B·1 — PLAN & PINS, element by element

| # | ELEMENT | WHAT IT SHOWS / FEEDING TERM | DUPLICATE? | WORLD | COST | VERDICT |
|---|---|---|---|---|---|---|
| 1 | `#planTitle` + mode seg | `S.planMode` | no | steady | low | KEEP |
| 2 | `#planSub` population line (8564) | `planSubLine(P)`: pass of scored, era naming, prices age, ⏳ charts-loading count from `fails[0]` | same question as `#depSub` and Home funnel tile — one owner term (`buildPlan`), three spellings; the ⏳ count reads first-fail only (an item failing ROI first and chartless is not counted) | steady | med | KEEP; the ⏳ under-count is a finding (ruling table F6) |
| 3 | `#planCopy` print button (26275) | prints picks in FUNDING order (promotion → tier → score) | **LOUD**: screen renders `planGroups` order (tenured by score; held/pool by unweighted core) — copy order ≠ screen order; the recorded two-owner instance still live | steady | low | KEEP; feed the copy from `pickGroups` (ruling table F3) |
| 4 | `#staleOpen` yesterday's unresolved | `DB.positions` + `posActions` | same rows as positions table, same owner | steady | low | KEEP |
| 5 | Sizing/settings row (16 inputs) | `DB.*` settings | inputs are the owners | steady; **Quote width**'s only reader is behind `MM_BENCHED` | high | KEEP; Quote width → dormancy candidate with MM (loses nothing benched: its reader cannot run) |
| 6 | `#planHint` margin-test protocol | static | deliberate repetition with copy header + TEST pre-lines | steady | med | KEEP |
| 7 | Sell-mode surface | `sleeveRungCards`, `sellLines` | sell nets = positions "Unrealized" — the same formula WRITTEN TWICE (8417, 15970) | steady | low | KEEP; extract the net into one term (F7) |
| 8 | Placed-today lines | positions + both-ways gate status from one P | no | steady | low | KEEP |
| 9 | Standing QUOTE lines | `w.quotePlaced` + `quoteLegAge` | only render of in-flight legs | MM-benched era; self-retiring | low | KEEP until resolved |
| 10 | MM UNWIND lines | `invHeld` > 0 under `MM_BENCHED` | inventory panel shows same lots — same terms, two views | MM bench | low | KEEP until lots zero |
| 11 | Fresh-quote proposal / MM-READY | dead while benched (unreachable) | n/a | — | zero | already dormant behind the flag |
| 12 | Unproven-T1 banner + T2 TEST pre-lines | `p.tier` flags | banner's "everything after it in the T1 group" assumes an order the score-only tenured sort does not guarantee (F3's third face) | steady | low | KEEP; F3 |
| 13 | Funded BUY line (full row) | `allocQty`, `estFillH`, `whyTag`, sizeNotes, intel tags | `whyTag` bits overlap watch-row risk chips — mostly same terms; slow-fill copy worded independently in both | steady | med | KEEP |
| 14 | Seed-caution copy/badges | `p.caution` from candidateFor | same term as riskChip SEED-CLASS | steady | low | KEEP |
| 15 | `poolDot` persistence dot | `poolPersistence` — all states self-explain | opens to `poolDrill`, same owner | benched era + steady | low | KEEP |
| 16 | `poolControlsHTML` | returns "" until `ITEM_OPS` arms (ruled) | n/a | future | zero | KEEP (inert by design) |
| 17 | Held-group header | `planHeldHeader` per-weight causes | no | outage/transition only | low | KEEP |
| 18 | Pool-group header (funded pool) | `PLAN_POOL_HEADER` + `planPoolFedLine` | no | steady | low | KEEP |
| 19 | Countdown line `data-poolera` (Part A) | `poolEraInfo` off `S.scorerSurf.h1` | tile reads the SAME term ✓; **but the gates bench off `S.chartCache.state` — a second snapshot of the same t0Coverage arithmetic with its own TTL** (F4) | benched era; self-dissolving | low | KEEP |
| 20 | THE POOL group (Part A) | `bench.filter(src pool)` while waiting | count shared with benchSummary — one array | benched era; self-dissolving | med | KEEP |
| 21 | `planInertLine` | per-reading counts + day count | the `observed/24` days derivation is spelled INLINE IN FOUR PLACES (4018, 6136, 11014, 11027) — no owning term (F4b) | benched era; self-dissolving | med | KEEP; extract the derivation |
| 22 | POOL waiting rows (Part A) | name/tier/price/reason | deliberate replacement of bench rows | benched era | med | KEEP. **Gap: pool rows carry NO controls — no ignore, no blacklist button; a pool item can be blacklisted only via the name box** (F8) |
| 23 | Qualifying block | `P.qualifying` + lapse copy + `qualEtaText` | funnel + pipeline read same term | steady | med | KEEP |
| 24 | NEXT UP rows | `whyKeys`-derived sentence | funnel's per-key counts are FIRST-reason attribution with no label saying so (F9) | steady | med | KEEP; label the funnel partition |
| 25 | Promote picker | full `whyKeys`, third-state floor | one owner (repaired 2026-08-21) | steady | low | KEEP |
| 26 | Empty-plan message | static | no | steady | low | KEEP |
| 27 | `#planFoot` | spent-of-budget etc. | `#depSub` shows deployed-of-POOL — different denominators, both labeled, adjacent | steady | med | KEEP |
| 28 | Wednesday advisory | wed* advisories | no | steady | low | KEEP |
| 29 | `#benchSummary` | `benchShown` + "(+N pool)" | one owner | steady | low | KEEP |
| 30 | Bench rows + exception grant | `b.failed` + evidence bar | no | steady | low | KEEP. **Fix owed: the untiered reason says "Override the tier on its watch row" (7318) — a pool item has no watch row and its channel is inert until ITEM_OPS; the copy names a remedy that population cannot reach, and untiered is the control cell's LARGEST slice** (F1) |
| 31 | Pool persistence drill | `poolDrill` via `drill` | same owner as the dot | benched + steady | low | KEEP |
| 32 | `#famDebug` disclosure (8432) | `renderFamilyDebug` over **DB.watch only** | **LOUD**: `applyFamilyRule` groups the whole pass set including pool — the panel claims to show how grouping resolved while reading a population the mechanism no longer runs over (F2) | pre-cutover | low | CONSOLIDATE: widen feeder to `P.all` or retire. Loss if retired: the only pre-emptive stem audit (bench shows overlaps only when two members pass simultaneously) |
| 33 | "Proposal only" notes | constitutional restatement | deliberate | steady | low | KEEP |
| 34 | `#posSub` free-of-stack (15956) | `available()` = stack − committed — **counts the shadow reserve as free** | **LOUD**: `#watchStack` renders "free" from `workingStack()` − committed (reserve excluded, and says so). Two "free" figures on one tab differing by exactly the shadow reserve; only one qualifies itself (F5) | steady | low | KEEP the line; one owner for "free" |
| 35 | `#acPos` repair entry | lost-offer re-entry | no | steady | low | KEEP |
| 36–37 | Positions table + foot | positions, `sellAgeInfo`, `hzFroze` disclosure | sell-mode shows same rows | steady | low | KEEP |
| 38 | Inventory panel | invLots under MM bench | same lots as UNWIND lines | MM bench; self-hides empty | low | KEEP while state exists |
| 39 | Dot legend note | static | duplicated into tooltips from same entries | steady | low | KEEP |
| 40 | `#watchStack` | working/free/one-third | see 34 — the correctly-qualified one | steady | low | KEEP |
| 41 | Scout toggle/log/caps | `DB.scoutOn`, `runScout` LIVE | admission machinery — see Part C group E | pre-cutover; transitionally load-bearing (only auto top-up while pool benches) | med | **DORMANT AT MATURITY, not now.** Retired today the plan thins to hand pins for the benched era. At maturity: keep the EVICTION half or scout-added pins linger forever |
| 42 | Blacklist box | `DB.blacklist` | per-row 🚫 same owner | steady (constitutional) | low | KEEP — currently the ONLY blacklist path for pool items |
| 43 | `#acWatch` add-by-name | hand pinning | no | steady | low | KEEP |
| 44 | `#wFlagFilter` | WFILTER_OPTS over status/risk/tested | one owner via opsFor | steady | low | KEEP |
| 45 | `wSpark` redraw | `fillSparks` — pins only | pool charted via archive — different source, deliberate | steady | low | KEEP |
| 46 | Sortable headers | `DB.watchSort`; trend sort reads the resolver | one owner (repaired) | steady | low | KEEP |
| 47 | Row slots: status/identity/risk/shadow/test | same P as plan; opsFor one owner | status = same P ✓ | steady; `·scout` suffix is admission-era | med | KEEP; provenance suffix goes dormant with the scout |
| 48 | Row data columns | `calc`, resolver, `hourVerdict` | margin verdict same term as the gate | steady | low | KEEP |
| 49 | Actions cell (+log · mm · 🚫 · ⬡) | mm press REFUSED under MM_BENCHED (toast) | mm state also in expand view — same `mmVerdict` | MM bench | low | mm button → CONSOLIDATE into expand view until un-bench. Loss: only a tooltip the expand view already renders; the press cannot enroll anyway (24821 refuses) |
| 50 | Tested column (set/↻/✕) | opsFor — one owner with calc | pool gets `data-pooltest` when ITEM_OPS arms | steady | low | KEEP (the seasoning waiver + proven-loser unbench path) |
| 51 | Plan qty input + clamp tag | `planQty`, `capReason` | clamp reason same term as riskChip ⅓-CLAMP | steady | low | KEEP |
| 52 | ✕ / wiki / expand | row controls | no | steady | low | KEEP |
| 53 | `watchDetailRow` expand | one home for full row context | shadow section same terms as dot/cite | steady | low | KEEP |
| 54–55 | `#watchFoot`, `#stackNote` | row sums; workingStack/3 | different questions, labeled | steady | low | KEEP |
| 56–62 | Deploy panel: `#depSub`, funded sparkline, leave-one-out, funnel + headlineNote, marginal attribution, qualifying pipeline + census, proposals/concur | same P; `failProfile` fail sets; first-fail labeled; observed-coverage honesty | see F9 (NEXT UP partition label); Home tile is the compressed same-term click-through | steady | med | KEEP all |

## Part B·2 — REVIEW, element by element

| # | ELEMENT | FEEDS FROM | DUPLICATE? | ACTS ON | WORLD | VERDICT |
|---|---|---|---|---|---|---|
| 1 | Checklist header/date line | flips dates, `DB.lastReviewAt` | no | step presses | steady | KEEP |
| 2 | Step 0 service-the-book | `ckEffectiveList` (shared with walk-up/NOW — one owner) | same term, deliberate | execution presses on Watch | steady | KEEP |
| 3 | Per-item table step | `itemVerdicts()` over flips | scorer has NO realized-P&L view — unique | feeds the cut | steady | KEEP |
| 4 | Cut-bottom-performer step | `data-cut` → removeWatch | unique | press (removes a PIN now — demotes to pool-only, does not empty a "seat") | mechanism steady, **copy pre-cutover** ("scout will backfill the empty seat") | KEEP; copy reword owed (F10) |
| 5 | Promote-from-scanner step | scanner press | **different-term duplicate of the pool channel** (two admission rulesets) | press adds a pin | pre-cutover | DORMANT AT MATURITY; reword to "pin an item to give it operator overlays" — pinning is what attaches `w.qty`/`tierOv`/tested prices, which pool rows deliberately lack |
| 6 | Markout/capture step | `itemVerdicts()` — same map as the table (one owner) | ✓ | reads; presses live elsewhere | steady | KEEP |
| 7 | Briefing scorecard step | `DB.intel`, `intelToGrade` | only grading surface | grade presses + flags export | steady | KEEP |
| 8–9 | Seed + sibling audits | `seedAudit`/`sibAudit`, LIVE feeders | digest carries pointers only | confirm/modify/dismiss; KEEP/RETIRE auto-apply | steady, narrowed to pin-seat curation | KEEP |
| 10 | Cluster queue §3 | `DB.clusterCands` with evidence line | **LOUD: full-press duplicate of the Home digest's cluster lines — same term, two press surfaces; the digest lacks the evidence clause** | confirm/merge/dismiss | steady | CONSOLIDATE into the digest as the ONE press surface — and move the evidence clause (corr figure, category, staleness) onto the digest line, or the ruling is made without the evidence in view (F11) |
| 11 | Gate-health one-liner | `gateSummaryLine` — the agree/disagree count computed only here | ruled one-line summary | read + link | steady | KEEP |
| 12 | Prospecting one-liner | `DB.strataStats` — DORMANT except gap band | scorer coverage superseded the slice (says so itself) | read + link | dormant era | DORMANT AT MATURITY: keep until the gap band's 5-trip verdict, then fold that clause into the paper one-liner. Loss now: the gap-band verdict has no other one-line reader; the routing case-law question is open |
| 13 | §5b Applied automatically | `autoApplied` filter of decisionLog | duplicates §6 BY RULING (prominence requirement) — not drift | read | steady | KEEP (constitutionally required) |
| 14 | §6 Decision log | last-50 + copy | it IS the log's render | copy press | steady | KEEP; note: the 500-row cap now also absorbs settings/auto/cutover rows — "audit your own audit next quarter" strains against it |
| 15 | Paper one-liner + ⭳ export all three | `paperClosed` etc.; regime clause says dormant correctly | ruled one-liner of the surface | export press | steady | KEEP |
| 16 | Freshness step | per-stream ages, event-driven separated | the BINDING staleness surface | gate on reading below | steady | KEEP. **Stale copy: the T2 line still claims "no surface until stage 1e" while the Scorer surface shipped (15005)** (F12) |
| 17 | Hours-ledger step | `hoursLedger` — pins-only market stream | **the overnight verdict is COMPUTED TWICE** (18152 and 14910, thresholds copied at both sites) (F13); scorer hour bands are the different-term successor and use UTC vs this local (F14) | read; feeds a ruling-gated sizing proposal | pre-cutover coverage | KEEP now; DORMANT AT MATURITY only if the scorer grows an hour split of FILLS — loss otherwise: fillability-by-hour exists nowhere in the scorer |
| 18 | Scorer one-liner step | same terms as the scorer surface | ruled shape | read + link | benched era → steady | KEEP |
| 19 | Friction step | `DB.frictionLog` — the one READER of the global writer | writer/reader, not duplicate | handled/export/copy | steady | KEEP |
| 20–21 | Re-stamp bank + export-log steps | pointers to panel presses | no | presses live there | steady | KEEP |
| 22 | Shadow fund panel | stack/reserve/shadowItem | Home Capital tile same terms, sanctioned | Mark-as-current press | steady | KEEP |
| 23–24 | Holds + targets panels | holds/targets stores, outside flipping terms | no | edits | steady | KEEP |
| 25 | Attention & dormancy panel | walkupLoad, featTouch | no | run-report press | steady | KEEP. **Feeder defect: `SURFACE_DEPTH` has no keys for the four newest sub-views (paper/prospect/gates/scorer), so the tier check is structurally blind to them; the dormancy half still sees them** (F15) |
| 26–29 | NOW bar, glossary, tax panel, friction footer | single owners | no | various | steady | KEEP |
| 30 | WHAT CHANGED | `homeDeltaLines`; regime delta correctly era-gated both sides | only delta surface | read | steady | KEEP |
| 31 | RULINGS PENDING digest | `pendingRulingItems` — capped, overflow counted | cluster lines = §3's duplicate (see 10) | every line presses | steady | KEEP (the walk-up's ruling machinery) |
| 32 | Equity panel | realized/attentionMinutes/bankSnaps | gp/touch column disclaims toward it | read | steady | KEEP. Note hazard F16: `DB.bankSnaps` and `DB.bank`/`bankAsOf` are two hand-entries of one physical number, never reconciled |

Also found: **there is no element named "weekly verdict"** — the nearest is the date-line's ripeness clause; reported as a finding, not invented as a row.

## Part B·3 — the other tabs, surface level

(Verbatim from the audit run; the full table is retained here.)

| PANEL | QUESTION · FEEDER (accrual) | DUPLICATE? | WORLD | VERDICT |
|---|---|---|---|---|
| Home FUNNEL / SCORER / SLEEVE / CAPITAL tiles | buildPlan / scorerTileLine (poolEraInfo) / sleeve stores / stack | same owner terms as their panels | steady | KEEP ×4 |
| Deployment funnel panel | leave-one-out from fail sets; live over pins + pool | question-overlaps paper per-gate and scorer delta — different terms, each labeled | benched era's main explainer | KEEP |
| Scanner · Filters | second RULESET (`DB.filtersT1/T2`) feeding funding via pins | **loud different-term duplicate of the control cell** | pre-cutover; this week the working pin-discovery screen | DORMANT AT MATURITY (retiring the presets now kills pin discovery during the benched era) |
| Scanner · results + "+pin" | `scanRows`; the ONE admission press with gate context | scorer lists carry no actions BY DESIGN | pre-cutover; benched era load-bearing | DORMANT AT MATURITY (the admission-gap cross-check while proving out) |
| Scanner · Beyond the net | slice half dormant; gap-band half live (+pin); accrual lives in shadowScan, not this render | gap rows summarized on Prospecting | held-rulings evidence | CONSOLIDATE AT MATURITY: move the live gap-band row render into Prospecting's gap panel |
| Scanner · scout machinery | `runScout` LIVE — auto-maintains scout pins, evicts | pool is the second, larger auto channel; different rulesets | pre-cutover; keeps the pin book alive this week | DORMANT AT MATURITY — and the retire is a RULING (changes what reaches funding) |
| Prospecting · per-stratum map | `strataStats` frozen except gap | superseded by universe coverage BY RULING | historical | KEEP AS-IS (already dormant); delete would lose the only per-stratum outcome ledger |
| Prospecting · gap band | live, accruing; serves TWO HELD RULINGS (T3 proposal bar + routing) | scorer scores the items but carries neither ruling's evidence bar | held rulings | KEEP until those rulings resolve |
| Prospecting · hours ledger | pins-only spread-by-hour + paper fills-by-hour | scorer bands = funded flow in UTC; this = spread width in LOCAL (two clocks, F14) | pre-cutover + era-independent question | DORMANT AT MATURITY; loss at retire: spread-by-hour exists nowhere in the scorer |
| Paper Book · verdict/headline | shadowBook, accruing from pins + pool | different SIMULATOR from scorer econ (F17) — answers "MY gates on MY stream" | all worlds | KEEP |
| Paper Book · regime race fold | `shadowDivLog` frozen; dormant banner | superseded by config grid BY RULING | historical | KEEP AS-IS (dormant) |
| Paper Book · fill-model calibration | `DB.calib` replays REAL logged flips | **no duplicate anywhere — the only machinery that can ever grade the capture constant class** | era-independent, MORE important post-cutover | KEEP (irreplaceable) |
| Paper Book · overnight-vs-daytime | cohort × time × duration with concentration | scorer has no cohort-of-my-book and no per-cell concentration; the routing question reads this by name | era-independent | KEEP |
| Paper Book · per-gate outcomes | shadowByGate binding-gate attribution | partial different-term overlap with scorer delta (membership only, ungraded econ) | era-independent | KEEP; CONSOLIDATE candidate only after capture grades |
| Paper Book · cohorts panel | per-cohort ledger | **LOUD: `shadowScan.add` stamps no `src` and `paperCohortOf` defaults to "watchlist" — pool trips will file into the "watchlist" cohort the moment coverage matures. One label, two populations, biting exactly at the milestone the proving week waits on** (F0) | pre-cutover semantics | KEEP + the stamp gap wants a fix BEFORE maturity |
| Gate Health · two streams | realized (flips+gateLog, src-stamped) + paper | **realized streams irreplaceable — nothing in the scorer reads DB.flips** | era-independent | KEEP |
| Gate Health · die-off episodes | dieOffLog — now accruing UNIVERSE-wide | none; "new-era surface in old clothes" — it now grades a restraint that binds the pool | new era | KEEP |
| Gate Health · exception lane | shadowExceptions, live | none | era-independent | KEEP |
| Scorer · all seven panels | the new-era instrument | ctl-funded section = same-term duplicate of the plan's pool group (one owner ✓, deliberate); hour bands vs hours ledger = two clocks (F14); econ = second simulator (F17, partitioned by design); rdiff copy says "watchlist" where the compared set is the pin list | benched era + steady | KEEP ×7 |

**The "watchlist"-naming sweep list** (rendered strings only; comments excluded; era-guarded uses excluded) — ~40 sites in six families: the paper cohort labels (loudest — see F0); panel chrome (`<h2>Watchlist</h2>` at 736, scout cap tooltips, cluster "watchlist rows"); plan/deploy copy (8588 "not on the watchlist — gates not evaluated" — false for a pool item, whose true state is "not scored this cycle"; 8931; 8958); warn channel (6934, 7213); paper/prospect copy (9678/9687, 12096/12118, 14854/18151/23840 "watchlist items already fetch" = mechanically the PIN list; 16344 "+watch to load it" — doubly stale, pool items chart from the archive with no fetch); scorer/rdiff wording (11230/11241/11308 "control passes · watchlist lacks" = the pin list; glossary 21389/21414/21419/21432; export notes 24272/24286); toasts/misc (16728, 16740, 18254, 18285, 20779, 21729, 22553, 24823, 25005, 25340).

---

## The consolidated drift-hazard register (two terms answering one question, or one term hiding two populations)

| id | Hazard | Where | Bite |
|---|---|---|---|
| F0 | **Paper cohort label pools pins + pool trips** — `shadowScan.add` stamps no `src`; `paperCohortOf` defaults to "watchlist" | 9731, 11787 | **at chart maturity** — the proving week's headline cohort read pools two populations with opposite epistemic standing. RECOMMEND fix before maturity (partition-at-birth: stamp `src` on trip open; cohort reader branches on it) |
| F1 | Untiered bench copy names a remedy pool items cannot reach ("override the tier on its watch row") | 7318 | at maturity, on the control cell's LARGEST slice — the known pass-8 bench-reason hazard |
| F2 | Family-debug panel reads DB.watch while `applyFamilyRule` runs over the whole pass set | 8432 vs 6846 | now (a pool item can bench "family overlap" the panel cannot show) |
| F3 | Three orders for one plan: funding sort ≠ screen groups ≠ copy button print; T1 banner assumes an order the sort does not guarantee | 7327, 6041, 26285, 8695 | now (the copy button is the recorded instance) |
| F4 | Two chart-coverage snapshots decide one era: gates read `S.chartCache.state`, countdown/pool group/tile read `S.scorerSurf.h1` — same t0Coverage arithmetic, two async TTLs; plus the `observed/24` days derivation spelled inline in four places | 4015, 10936; 4018/6136/11014/11027 | at the 7-day boundary (the group can dissolve while rows still bench, or vice versa — degrades honestly, but the era is decided twice) |
| F5 | Two "free gp" figures: `available()` counts the shadow reserve as free (posSub, unqualified); `workingStack()` excludes it (watchStack, says so) | 3278 vs 5392 | now — money copy contradicting the reserve's own constitution |
| F6 | The ⏳ charts-still-loading count reads first-fail only | 8563 | benched era (undercount) |
| F7 | The sell-net formula written twice | 8417, 15970 | latent |
| F8 | Pool rows carry no controls — no ignore/blacklist press; blacklist reachable only via the name box | Part A group | benched era (minor; blacklist path exists) |
| F9 | The funnel's NEXT-UP per-key counts are first-reason attribution with no label | 15219 | now (label owed) |
| F10 | Review checklist copy renders the seat economy ("cut → scout backfills"; "promote from the scanner") the allocator no longer runs | 22414–22415 | now (copy) |
| F11 | Cluster candidates pressed from two surfaces; the digest lacks the evidence clause | §3 vs digest | now |
| F12 | Freshness T2 line claims the scorer has no surface; stage 1e shipped | 15005 | now (copy) |
| F13 | The overnight-spread verdict computed twice with copied thresholds | 18152, 14910 | latent drift |
| F14 | Two hour clocks: hours ledger LOCAL, scorer bands UTC — no surface says so | 2913/14818 vs 11101 | now (cross-tab comparison off by the offset) |
| F15 | `SURFACE_DEPTH` lacks the four newest sub-views — the tier check is blind to them | 19988 | latent |
| F16 | Two hand-entries of the bank (`bankSnaps` vs `bank`/`bankAsOf`), never reconciled | equity vs fund panel | latent |
| F17 | Two fill simulators (paper vs scorer t1), partitioned by stamps, disagreement rendered nowhere | by design | accepted-by-design; note only |

---

## Part C — why is there still a watchlist: the dependency enumeration

**Count: 109 occurrences of `DB.watch` (≈95 in code), + `DB.watchSort` ×5, + `DB.watchCap` ×1 live read, + field read-throughs via `opsOf`/`opsFor`/`candidateFor`/`validateImport`.**

**The structural fact:** watch rows carry TWO kinds of state and only one has a successor store.
The six operator fields (`tBuy tSell tAt qty tierOv t2Grad`) already mirror into `DB.itemOps` on
every press and read through one term (`opsOf`, row-resolution at 6276 — the single
highest-leverage line: every operator-state dependency funnels through it). Everything else —
membership itself, provenance (`src`), admission bookkeeping (`addedAt lastPass scoutTier sib*`),
MM state (`invTarget`, `quotePlaced{…}`) — has no store other than the row.

**Six release groups** (full tables retained from the enumeration run):

- **A — releases when ITEM_OPS arms** (already-ruled deployment-class step; row retirement after is
  mechanical): the six operator fields and every consumer — `calc` tested-pair, `planQty` manual
  size, `provenLoser` re-test release, `itemTier` override, T2 auto-graduation, the row-requiring
  control handlers (whose armed-era replacement, `poolControlsHTML`, is already built).
- **B — releases when membership re-keys to a PIN SET**: `planCandidates`' tenured membership
  (the deployment-class boundary — it defines tenured vs pool), `cutoverPoolRows`' held-set
  subtraction, **`qualRetain`'s membership branch (deployment-class: leaving the set deletes the
  streak — membership must remain a deliberate act)**, rdiff's `wlN` (partition note owed at
  re-key), `sleeveMandateConflict` (a restraint — keep a fires-when-it-should assertion), cohort
  exclusion sets, cluster populations, display sites.
- **C — releases on the MM un-bench / re-key ruling** (the bench log itself says "re-keys as
  pinned-item state at cutover, or retires by ruling"): **`committed()` — money — counts standing
  quote legs**; `invItems`; the MM bench filter in buildPlan; quote lifecycle writers;
  `crossWarn`'s self-cross guard (deployment-class, the universal spec); renders.
- **D — releases when the archive replaces the per-item spark, or stays pin-scoped with the bias
  stated**: `fillSparks`' fetch population (the bounded-set need), `hoursLedger`'s market stream,
  the hour column, the freshness row; plus `vol5Population`'s dormant off-branch (pinned by
  `[R94.3]`; retiring it is the flag pair's dormancy-lane ruling).
- **E — the admission machinery itself (release = "admission retires", a RULING — it changes what
  reaches funding via pins)**: `addWatch` (+pin — SURVIVES as "create pin"), `runScout` upkeep and
  eviction, `runSiblings`, the seed/sib auto-apply rules, `removeWatch` (becomes "unpin"), the
  import sanitizer's row schema, `watchCap` (a strategy cap riding this group, with NO settings
  writer — the known repair-8 landing condition), and every reader inside the machinery.
- **F — the pins surface and misc display**: re-keys trivially or needs nothing. Era vocabulary
  ("watch" in `qual.src`, `dieOffLog.pop`, `deployLog.poolRegime` and their import recognizers)
  **releases NEVER** — historical partition values a sweep must not touch.

**Dependencies fitting NO named trigger:**
1. **The bounded-set need under `fillSparks`**: as long as any `byHour`/`roiHour` reader lives,
   SOME small bounded population must exist — one polite HTTP call per item cannot run over 4,497.
   The archive replaces trend/vol/momentum/drift but nothing replaces the hour-of-day stream.
   Either the archive grows an hour profile — **which is deployment-class in its own right and
   must turn `[R100.4]` red by design (standing ruling)** — or the pin set is accepted as this
   stream's permanent population with the bias stated. This is a genuine ruling to schedule.
2. The era vocabulary (above) — never releases; protected from sweeps.
3. Vestigial: `provenLoser(id, w)`'s `w` parameter is dead (three call sites feed it; the body
   reads `opsOf(id)` only); `mmVerdict`'s row find exists only to feed that dead parameter.

**Does anything genuinely need a maintained LIST? No.** The stored array's order is never
load-bearing; the cap is a cardinality bound on a set; every read is membership, per-row state,
cardinality, or iteration. Three dependencies need an **explicit-membership bounded set** rather
than a derived one: `qualRetain`'s membership semantics, scout eviction's yours-vs-machine
distinction (`src`), and the spark population. **A pin = operator state on an item id, with
pinned-ness itself one of the states**, satisfies all three; deriving pinned-ness implicitly from
"has any operator state" would break the first two.

---

## THE COLLAPSE PLAN (proposal — every step below moves only on a ruling)

End state: **no separate maintained list. A pin is a record in the per-item store: pinned-ness is
an explicit field beside the six operator fields; the pin SET (bounded, explicit-membership) is
derived from that field and serves the three set-needs above. Admission machinery is gone; "+pin"
and "unpin" are the only membership presses; discovery is the pool.**

| step | what | releases | class | when (vs the ruled sequence) |
|---|---|---|---|---|
| 0 | **The paper cohort `src` stamp** (F0): stamp trip provenance at `shadowScan.add`, branch `paperCohortOf` on it — partition-at-birth for pool trips | nothing (prevents a pooling) | data partition; display-adjacent, no funding change | **BEFORE chart maturity** — recommended immediately on ruling |
| 1 | The copy sweeps: F1 (pool bench remedy), F10/F12 (stale claims), the watchlist-naming list; the small fixes F5 (one owner for "free"), F6, F9, F2 (famDebug feeder), F4 (one coverage-era owner + the days-derivation term), F13 (one overnight verdict term), F14 (label the clocks or unify), F3 (copy button reads pickGroups) | nothing structural | display-only (each is its own row ruling) | during the observation week, as ruled row by row |
| 2 | **ITEM_OPS arms** | Group A (six fields; pool controls channel opens) | **deployment-class — already ruled to happen at coverage maturity** | at maturity (~Aug 22–23) |
| 3 | Pinned-ness moves into the item store (`pinned: 1` beside the six fields); `DB.watch` becomes a derived compatibility view; membership presses (+pin/unpin) write the store | Group B mechanically re-keys; `qualRetain`'s membership semantics preserved (explicit act) | mechanical refactor UNDER a deployment-class boundary (the tenured/pool definition) — stage it like the cutover: build behind the existing flags' pattern, assert both eras | after ITEM_OPS proves out (during/after the observation week) |
| 4 | **Admission retires**: scout/sibling/seed auto-machinery to the dormancy lane (dormant-gated tests, removal sweep, era facts — the Aug 14 pattern); scanner + prospecting verdicts from Part B·3 apply; keep the eviction half or scout pins linger; `watchCap` retires with it or re-keys as the pin-set bound (its no-writer condition already recorded on repair 8) | Group E | **deployment-class ruling** (changes what reaches funding via pins) | after the cutover proves out — the already-ruled "admission machinery retiring after cutover proves out" |
| 5 | **MM un-bench decision**: quote/inventory state re-keys to the item store (or retires); `committed()` and `crossWarn` accounting move with it | Group C | **deployment-class** (money + a universal guard) | after the observation week — the already-ruled MM sequence |
| 6 | **The hour-stream ruling**: archive hour profile (turns `[R100.4]` red by design, deployment-class) OR pin-scoped-forever with bias stated on the two surfaces that read it | Group D's residual | deployment-class either way | independent; schedule when the observation week's data says whether hour evidence matters |
| 7 | Delete-the-array cleanup: import sanitizer re-schema, migrations retire when restore-safe, era vocabulary protected | Group F | mechanical | last |

**What cannot release:** nothing requires a maintained list; the three set-needs ride the explicit
`pinned` field. The one permanent exception is the era vocabulary, which is history, not a
dependency.
