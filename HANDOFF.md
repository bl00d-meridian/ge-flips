# TOMORROW: THE FLIP. Read this section and execute it — everything you need is here.

**Baseline commit `047cf6d`** (2026-08-14 → 2026-08-20, six days of work, committed *before* tonight's
fixes so those land as their own diff). **Not pushed — pushing is the user's.** Tonight's fixes are
uncommitted on top of it, so `git diff 047cf6d -- index.html` is exactly the pre-flip fix list and
nothing else.

**Suite: PROBE-PASS, both viewports (1200×900 and 390×844), cold, pairing clean both directions
(496 tags / 508 rows / 496 cited).**

---

## a. THE FIX LIST — where each of the five stands

All five landed in the tree tonight. Each carries a tagged assertion in **§108** and each assertion
was proven by seeding the defect and watching it go red alone.

| # | fix | state | assertion | seed |
|---|---|---|---|---|
| a | **4.1, the payload trigger** — `loadLatest` stamps `S.latestAt` only when the payload is USABLE, and warns when it is not; `updateQualStreaks` gains the live-data precondition its siblings have; and `candidateUnevaluated` makes an unevaluated row neither break nor credit a streak | **LANDED** | `[R108.1]` `[R108.2]` `[R108.3]` | S175a, S175b, S175c — each red alone |
| b | **`qualExemption` reads the trade's date, not the log instant** | **LANDED** | `[R108.4]` ×2 | S175d — both limbs red, discriminating |
| c | **horizon stamps on every position writer**, with `placementHzH` floored at 1h | **LANDED** | `[R108.5]` | S175e2 — red alone |
| d | **the ITEM_OPS write-path gap** — `opsWrite` writes BOTH sides; `ITEM_OPS` is a read-side switch | **LANDED** | `[R108.6]` ×2 | S175f — red alone |
| e | **the flag-pairing guard**, with `vol5Population` reading the same flag the guard reads | **LANDED** | `[R108.7]` ×2 | S175g — red alone |

**Two fixes went beyond what was asked, and the reasons are recorded at the sites:**

- **(a) has THREE readers, not one.** `candidateUnevaluated` is read by the seasoning loop, the gate
  ledger and the deployment funnel's kill attribution. The gate ledger was logging an unreadable row
  as a bench by *"plan gate"* — gate-persistence evidence about an edge nothing measured, feeding the
  4-of-7-days bar that moves gate constants. The funnel's own copy already promised *"unknown is not
  failing"* for the chart case; it is now true for the price case too.
- **(d) writes both sides in BOTH regimes**, not just while the flag is off. That closes pass 8's
  finding 2.2 as well: `itemOpsPrune` deletes a store row at 90 days and `opsPick` then falls through
  to the row, so a stale row silently REVERTED an override — a restraint lapsing on a clock, which
  `ITEM_OPS_RET_MS`'s own comment calls the constitutional line.

**One seed came back GREEN and that was a finding, not a pass.** S175e (the horizon floor) changed
nothing because the fixture set `DB.touchWindows = []`, which makes `gapHoursAt` return the 4h
fallback — the floor was present and NOT BINDING. The fixture now derives a touch four minutes out
from the clock, and carries `rawGap < 1` as a conjunct so it goes red rather than passing vacuously
if it ever stops producing the sub-hour case. Second fixture defect found in the same assertion:
`touchWindows()` returns `TOUCH_DEFAULT` for any array shorter than 2, so a one-element fixture
silently became the real four-touch schedule.

---

## b. THE ANSWER TO THE QUESTION ASKED BEFORE THE FLIP

**Pass 8's finding 3.1 was a FIXTURE limit, not a production one. The flip is not blocked.**

`cutoverFault` decided *is the 5-minute streak counted universe-wide?* by reading the flag set it was
handed, while `vol5Population()` — the code that actually decides it — read the const and took no
argument. So a **test** could hand the guard `{vol5:true}`, be told the combination was legal, and run
the armed-pool path with the streak counter still on the watchlist alone. **Production could never be
in that state**: it passes no arguments, so both sides read the same consts. Flipping both consts puts
production in the legal state genuinely. Fixed tonight anyway — `vol5Population(a)` takes the flag, so
the guard and the machinery read one term.

**BUT THERE IS A SEPARATE, PRODUCTION-SIDE FACT THE FLIP WALKS INTO, and it is the one that matters
tomorrow: the archive is 2–3 days short of its coverage gate.** Nothing is wired wrong.

**CORRECTED 2026-08-20, after the first version of this paragraph was traced and found wrong.** It
said `fillSparks` is watchlist-scoped, therefore a pool item has no series, therefore it benches. The
first step is true and the conclusion is not: **`itemSeries` is a RESOLVER with a fallback**, and the
fallback is the whole-universe T0 hourly archive.

```
if (sp && Array.isArray(sp.pts) && sp.pts.length)  return { ..., src: "spark" };
const p = chartPts(id);
if (p.length)                                      return { ..., src: "archive" };
return { pts: [], vols: [], src: "none", ... };
```

`chartPts` reads `S.chartCache.pts.get(id)`, and `chartCacheLoad` builds that map by walking every
archive bucket and every id inside it (`for (let i = 0; i < b.n; i++){ const id = b.id[i]; … }`) —
**universe-wide, keyed by nothing.** The writer is `t0Put("h1", hourStart, t0Pack(S.hour))` and
`S.hour` is the bulk `/1h` response. `chartCacheEnsure()` is reached from `renderHomeVitals`, which
runs on every tab, so it is not gated to the Scorer surface either. **Nothing between
`planCandidates` and `itemSeries` touches `DB.watch`.**

**A pool item also cannot get *"no history"*.** That gate is
`noHist = !!(sp && sp.noData) && ser.src === "none"`, and `sp` is undefined without a `/timeseries`
fetch — so it correctly refuses to claim no history exists for an item it never asked about. The only
chart bench a pool item can take is *"chart still loading"*, on `!rdy.allFed`.

**What actually gates it is a clock: `CHART_MIN_DAYS = 7` observed days, measured over
`CHART_COV_WINDOW_MS = 8` — 168 observed hourly buckets inside a trailing 192.** The last sourced
reading is `"chartGateObservedDays": "3.9 of 7"` from `inbox/analysis-scorer-2026-08-18.json`
(generated 2026-08-18T17:58Z, so treat it as a projection). 3.9 days = 93.6 observed hours against an
archive roughly 4.2 days old ≈ **93% of wall hours captured**. Hard floor even at 100% capture is 7
days of archive age → **not before ~Aug 21 late**; at the observed rate, **~Aug 22, possibly Aug 23**.
**Read the live figure on the Scorer surface before pressing — it renders as "N of 7 observed days".**

**So the flip is SAFE, and until that clock lands it is visibly almost a no-op.** What it changes is
the plan's population line (*"pins + the control cell's pool"*), the deploy ledger's regime stamp
(`mixed`), and a bench list that grows by however many pool items the control cell passes.

**What a pool item's verdict looks like the day the archive matures:** `src: "archive"`, up to 168
hourly mid points and 168 volume points. `allFed` needs `p >= 24` finite price points and `v >= 48`
volume points. Volume entries are pushed for every bucket the item appears in and are dropped by
nothing, so 48 is trivial — **the price side is the binding one**, because an hour where neither side
printed contributes `NaN` and every filter drops it. An item printing in ≥24 of 168 hours becomes
fully judged on trend, volume trend, momentum and drift; one printing in fewer stays benched, which is
the correct verdict for it, and the copy states the actual point counts rather than a category.

**One weight stays unfed permanently and it does not matter.** `hourWeight` reads `byHour`, and only
the item's own `/timeseries` carries that profile — the archive builds none. So `hw.fed` is false for
every pool item forever, `histFed` reports `unfed: ["hour"]`, and the item sorts on `planPoolSortKey`,
the unweighted core. **That is already the design**: pool items sort unweighted because their
operator-history weights are absent, and this is one more absent weight inside a group built for
exactly that. It is a score input; nothing benches on it.

**A separate bench that is not the chart's problem:** the file's own note puts **66% of control-cell
items as landing untiered**, benched by the tier bands. Unaffected by chart coverage, and still there
on the day the archive matures.

**WIDENING `fillSparks` TO POOL CANDIDATES WAS CONSIDERED AND IS THE WRONG ANSWER** — recorded here so
it is not re-proposed. The duplication is near-total (the archive holds the same hourly shape; only
`byHour` is unique, and it feeds a weight pool items do not use). The cost is not one-off:
`SPARK_TTL` is 30 minutes and `fillSparks` is sequential with a 250ms delay per item, so ~130 pool
items is ~65s of fetching every half hour on top of the watchlist's ~22s — **a spark loop longer than
the 60s poll interval**. And the real hazard is not the call count but `TS_FAIL_TRIP = 8` consecutive
failures pausing `/timeseries` for 30 minutes **for everything**: today a pool item falls through to
the archive gracefully, and under this change a trip would degrade the pins as well.

---

## c. THE FLIP

**`CUTOVER_POOL` and `VOL5_UNIVERSE` together. Never one without the other.**

```
index.html:  const VOL5_UNIVERSE = false;   →  true
index.html:  const CUTOVER_POOL  = false;   →  true
```

The guard enforces the pairing: `cutoverFault` returns a fault string for `pool && !vol5`,
`cutoverPoolOn` returns false, and `planCandidates` falls back to the watchlist — today's behaviour and
the restraining side. `cutoverFaultWarn` renders the refusal on the warn bar naming the missing flag,
so a half-flip is loud rather than silent.

**`ITEM_OPS` is NOT part of this flip.** `pool && !ops` is a warning rather than a fault, and the
reason is recorded at the site: with the store off a pool item's `opsOf` returns null on every field,
so it sizes automatically and takes its computed tier. Nothing loosens. Read the pool controls' own
comment before deciding otherwise — **both of their buttons only ever LOOSEN** (the tier cycle cannot
reach untiered, and a tested pair lifts three restraints at once), so arming `ITEM_OPS` alongside the
pool would add a bench-removal channel over the whole pool population in one press. That is
deployment-class on its own.

**Two assertions pin the consts** (`[R89.1]`, `[R93.1]`, `[R94.3]`). They will go red on the flip.
**That redness is the flip working, not breaking** — re-point them at the new shipped values in the
same edit, and say so in the commit.

---

## d. THE HALF-STACK SETTING

**It is `reserve` — the "Reserve" input in the sizing row (`#szRes`), range 0–2e9. It is a PRESS the
user makes, in the app. No code edit, no ruling, no constant moves.**

```
deployable = max(0, avail - DB.reserve)
pools[1]   = min(t1Budget, deployable)
pools[2]   = min(t2Budget, max(0, deployable - pools[1]))
```

Set `reserve` to half the current bank and the plan's deployable capital halves for as long as it
stands. Reverting is setting it back — **write the pre-change value down first**, because nothing in
the tool records it and the revert has to be exact.

**What it does NOT halve, stated because it is a limit and not a design:** the per-item one-third cap
and the cluster caps size off `workingStack()`, which is upstream of `reserve`. So individual lines
stay their normal size and there are simply fewer of them, or less total deployed. If per-LINE halving
is wanted as well, that is `partCapPct` — and `partCapPct` is a strategy constant, so it needs a
ruling and does not ride along with this.

Do not use `shadowReserve` for this. It is the Tumeken's Shadow savings target and it is real capital;
borrowing it as a throttle would corrupt the Shadow Fund reading for the whole week.

---

## e. WHAT TO REPORT AT EACH WALK-UP — not saved up

Three things, every touch, while the observation week runs:

1. **What the plan proposed** — the funded lines and, for anything on NEXT UP, the reason it gives.
2. **What was actually pressed** — including every place the press disagreed with the proposal.
3. **Every place a surface said something that did not match what was seen.**

**Watch two things hardest.** The **rdiff ledger** (the reconciliation diff — one row per scored
bucket, where the scorer's verdict and the plan's disagree). And **bench reasons**: a bench reason
that is wrong about *why* is the failure mode that costs trades, because it sends the operator to a
control that cannot help. Two live examples to watch for, both unfixed and both in tomorrow's tree:
a NEXT UP line saying *"plan is full"* when the plan is not full, and an untiered pool item told to
*"override the tier on its watch row"* when a pool item has no watch row.

---

## f. NO BACKUP RESTORES

**Not until the restore track closes.** `audits/DBKEYS-2026-08-19-restore-enumeration.md` enumerates
17 keys a restore silently keeps from the importing browser; 12 bite today and none is repaired. If
something goes wrong tomorrow, the fix is a diff against `047cf6d`, never a restore.

---

# UNRULED — the bites-today findings that did NOT land tonight

The user asked for these listed, one line each, to rule which are in. **None was ruled before the
session ended, so they are recorded here as UNRULED rather than assumed either way.** All six are in
the tree today and all six are money-path.

| # | what it is | what it costs |
|---|---|---|
| **1.2** | The sell leg is aged against the **buy** placement's horizon, and three sell-creation moments (listing, `advancePosition`, `repriceSell`) restart `stageAt` without restamping `hzH` | A buy placed at the 17:00 touch (4.5h) that fills late and is listed into the 9.5h overnight sit reaches rung 2 at 06:35 — **UNDERCUT & EXIT**, which relists one tick under the instabuy and gives up the whole quoted spread, on a leg doing exactly what the schedule priced it for |
| **1.3** | `legHorizonH`'s fallback reads the live `DB.fillHorizonH` slider | Dragging that setting from 4h to 1h flips every open **stampless** leg older than 2h to rung 2 at once — a horizon change retro-applied to open legs, which the cadence ruling forbids, arriving through the fallback rather than the stamp |
| **4.2** | A long gap **freezes** a streak instead of resetting it: the credit is withheld but `n` and `firstAt` survive and `lastAt` is re-stamped | An item at `n=2` from three weeks ago takes its third count at the very next touch and `qualSpanned` passes instantly on the calendar-day test — **a stale item funds ~3h after a reopen where a fresh one needs ~27h** |
| **4.3** | `QUAL_GAP_MAX` is 12h of **observation** time, and the poll returns early on `document.hidden` | A once-a-day or backgrounded-tab user never reaches a second counted pass: the row sits at `n=1` forever while the surface renders *"qualifies at ~HH:MM if it holds"* — an ETA that cannot arrive. The margin-test and logged-trip exemptions still work; the automatic path does not |
| **7.1** | The soft-fill NEXT UP push carries **no `whyKey`**, and its guard contains `!full_` | The picker's default branch says *"plan is full"* on a row that can only exist when it is not, and offers every funded pick as a remedy. The demote applies immediately and persists for the day, so a funded line is lost and the item still does not fund |
| **7.2** | `whyKey` reports **position in an ordered ternary** — `full_` is tested before `tooSmall` | An item that is both reports *"full"*, the picker offers all seven picks, and on the rebuild after the demotion it lands in NEXT UP again, this time honestly labelled *"no demotion can fix this"*. The truthful verdict was available at the first render and was suppressed by ordering |

**1.2 and 1.3 are one property** (a leg's horizon must track the leg, and the fallback is not a
stamp). **7.1 and 7.2 are one property** (a reason-aware picker whose reason is positional). **4.2 and
4.3 are one property** (a streak whose clock counts wall time rather than observations). Three
rulings, not six, if that is easier.

---

# WHAT STAYS QUEUED — tomorrow must not pick these up

1. **Pass 7's latent twelve.** `audits/ADVERSARIAL-2026-08-19g-pass7-cutover.md`.
2. **The restore track.** 17 keys, 12 biting today, plus the IndexedDB stores outside the restore
   entirely. `audits/DBKEYS-2026-08-19-restore-enumeration.md`.
3. **The six failed cold-review repairs' non-money halves.**
4. **The unknown-key census** (boot merge item 3) — still HELD pending its quota measurement.
5. **The apparatus consolidation** — retire assertions with their features, cull the ones that cannot
   be reddened, one assertion per property rather than per call site. Agreed, and explicitly AFTER the
   cutover.
6. **The five remaining staged repairs.** `staging/` still holds nine; repairs 1, 2 and 3 landed
   tonight in modified form and **4, 5, 6, 7, 8 and 9 did not**. Repair 8 is SENT BACK by cold review;
   the rest are unlanded and unruled. Probe sections **§106 and §107 are reserved for them** — tonight's
   work deliberately used §108 so the numbering does not collide if they land later.
7. **DETECTOR IMPROVEMENT, four items in order** (queued by the user, Aug 20 2026 — after the cutover,
   and explicitly after **a week of real use first**, because that week will show which detectors
   *should* have caught what actually mattered, which is better evidence for where to aim than
   reasoning from here):
   - **(a) Score the existing detectors from the record.** Every scan and review mechanism has a
     history in `audits/` — findings it caught, and findings later found by something else inside its
     own territory. Compute a per-detector hit rate retroactively. Known data points: scan 2 missed
     105 untagged assertions and 32 that never execute; the cold review caught one of three class
     misses. **The rates come before deciding which detectors to fix.**
   - **(b) A standing rule for detector design: a detector must be seeded with a spelling its author
     never enumerated.** Every detector that missed something this week missed it the same way — it
     enumerated by name rather than by property, so it certified its own list. `[R103.6]` grepped
     `num(x) >= 0` after the code became `nz(x) >= 0`; the `+s.tier` repair grepped the exact
     expression. Propose the wording and whether the rule itself is mechanically checkable.
   - **(c) Build a detector for UNASSERTED PATHS.** Every existing detector checks what EXISTS against
     a rule; none looks for code with no assertion pointing at it — which is where pass 8's worst
     finding lived and where the 32 never-executing assertions hid. Coverage by code path rather than
     by assertion list. **The one genuinely new instrument on the list; scope it before building it.**
   - **(d) A severity classifier the TOOL computes, not a reader's judgment after the fact.**
     "Money-path" meant "touches funding code" and lumped a defect that silently deletes a seasoning
     streak on an ordinary poll together with one needing a flag flipped AND a file restored. Pass 7
     had 17 money-path findings and zero that could bite; that mislabelling is what made the loop look
     like it was diverging. The inputs are mechanical, not judgmental — does this path run today, or
     does it need a flag armed, an import performed, or a state that has never occurred? The code and
     the flag states answer all four. Three required properties: graded by **expected cost** (what has
     to happen before it bites) and never by which subsystem it touches; **reachability is part of the
     classification, not a caveat on it** — a defect behind an off flag requiring a restore that has
     been forbidden is near-zero expectation and must not file beside a live one; and the
     classification **names its assumptions**, so it is checkable — *"bites today, assuming
     CUTOVER_POOL false"* can be wrong in a way *"money-path"* cannot.
8. **MATERIAL SETTINGS CHANGES RECORD THEIR BEFORE VALUE** (queued by the user, Aug 20 2026 — same
   sequencing: after the cutover and after the observation week). **This is provenance-at-birth
   applied to the one class that entry does not cover.** A settings edit overwrites the old value and
   nothing anywhere records what it was; the decision log holds rulings, not edits. The live instance
   is `reserve`, being halved for the observation week, where the only record of the pre-change value
   is a note on a phone.

   **SCOPE — material, defined by EFFECT and not by a list.** Log only settings that change **what
   the allocator may FUND, how it SIZES, or how it EXITS** (the property as ruled, Aug 20 2026 —
   *exit* is the third limb and it decides `sleeveRungPct`). Cosmetic and display settings are out.
   Derive from what a key does, never from where it lives — the cap classification went wrong twice
   exactly there, drawn from the 23 keys sharing one object literal and missing `slots` and
   `watchCap`, which bound funding just as hard. Pin the membership by name so it can be asserted,
   the `CAP_KEYS` pattern.

   **TWO CLASSIFICATION RULES RULED WITH THE LIST, and they belong here rather than in the list,
   because the list is an output and these are what produce it:**
   - **A key inert by a FLAG is classified by its PROPERTY, never by today's behaviour.** `quoteTicks`
     prices both legs of a quote and `MM_BENCHED` is true, so it does nothing today — and it is IN.
     Classifying by behaviour would drop it now and let it **silently re-enter scope** the day mm
     un-benches, with nothing red to mark the transition. *This generalises past this mechanism:
     `CAP_KEYS` has the same hazard and the same answer.*
   - **DISTANCE FROM THE DECISION IS NOT THE TEST; WHETHER IT CHANGES THE NUMBER IS.** `markoutX`
     thresholds a verdict that carries a caution that carries a haircut — three steps — and it is IN,
     with `pumpWindowD` and `pumpThinGp`, which are the same shape. They move together or not at all.

   **THE DECIDED LIST — ruled Aug 20 2026. The build reads this; it does not re-derive it.** The
   settings save table carries **29** keys. **25 material, 4 not.**

   *MATERIAL (25) — every one of these logs its before value:*
   `slots` · `reserve` · `shadowReserve` · `t1Budget` · `t2Budget` · `partCapPct` · `minExpectGp` ·
   `tickFloor` · `clusterCapPct` · `scoutT1Cap` · `scoutT2Cap` · `sibPerSeed` · `sibTotal` ·
   `seedTrips` · `sleeveBudget` · `sleeveMaxPos` · `fillHorizonH` · **`horizonH`** ·
   **`quoteTicks`** · **`sleeveRungPct`** · **`markoutX`** · **`pumpWindowD`** · **`pumpThinGp`** ·
   **`clusterCorr`** · **`clusterMinDays`**.

   The eight in bold were the borderlines. Six were ruled directly:
   - **`horizonH`** — read only at `scheduleOn() ? planHorizonH() : (DB.horizonH || 10)`, so it sizes
     when no cadence is kept. Same shape as `fillHorizonH`; splitting them would classify by name.
   - **`quoteTicks`** — `QUOTEW()` prices both legs. Inert under `MM_BENCHED`, IN by property.
   - **`sleeveRungPct`** — arms an exit rung. IN because the property's third limb is *exit*.
   - **`markoutX`, `pumpWindowD`, `pumpThinGp`** — threshold → caution → haircut. IN together.

   **`clusterCorr` and `clusterMinDays` were NOT among the four raised, and they move IN by consistent
   application of the ruled test rather than by a separate ruling.** They set the correlation
   threshold and the minimum history for `cohRecordAndPropose`, so they decide **whether a cluster
   exists at all** — and a confirmed cluster carries `clusterCapPct`, which changes the sized number.
   That is `markoutX`'s shape exactly, and leaving them out after ruling `markoutX` in would classify
   by distance, which is the thing the ruling rejected. **One distinction, stated so it can be
   overruled:** a cluster requires a user press to confirm, where a caution's haircut auto-applies.
   If an intervening press breaks the chain, these two come out — and `markoutX` should be re-examined
   on the same grounds.

   *NOT MATERIAL (4), each with what was actually traced:*
   - `shadowPartPct` — paper book only; no real capital moves.
   - `sleeveExitLiqPct` — `exitLiqWarn` produces a badge and a message that ends *"saved anyway, your
     call"*. **It warns and does not block**, so it changes no number.
   - `catWinTightenD` → `activeCatalystWindow()`, `briefTightStaleD` → `briefReminderInfo()`. A
     posture flag and a reminder. **Neither was traced to a sized number in this read**, which is the
     honest limit of the check — if `activeCatalystWindow` reaches sizing, they come IN and this note
     is where to overturn it.

   **COVERAGE — five writers sit outside the settings table. Decided:**
   - **`DB.touchWindows` and `DB.scoutOn` are material and this mechanism CAN reach them — no separate
     hook.** The recorder is written as a **term, not a listener**: `settingsLog(key, before, after)`,
     called from the table's `change` handler once per changed key, and called directly from
     `#szTouch`'s own handler and from the `DB.scoutOn = !DB.scoutOn` toggle. One question, one term,
     three call sites — the `opsWrite` pattern. A hook on the table alone would have covered one
     writer and reported that writer's population as the answer, which is the standing lesson.
     Two shape notes: `touchWindows` is an **array**, so its before value stringifies as a touch list
     (*"was 07:00 / 12:00 / 17:00 / 21:30"*); `scoutOn` is a **boolean** (*"was ON"*).
   - **The scan filters** (`DB.filtersT1` / `DB.filtersT2` via `SF()`) — material, and they need a
     shape decision before they can be logged at all, because they are objects rather than scalars.
     **Ruled: propose the shape when the build starts, not now.**
   - **`DB.blacklist` — OUT of this mechanism, ruled.** It goes to the decision log: a list rather
     than a scalar, and every change is already an explicit press.
   - **`watchCap` is material and has NO settings writer at all** — it is in `CAP_KEYS`, it bounds how
     large the watchlist may grow, and there is no input for it. It therefore cannot be logged by a
     settings recorder, because it cannot be set. **See the landing condition below.**

   **A LANDING CONDITION ON REPAIR 8, recorded here because the code it corrects is NOT IN THE TREE.**
   The clamp warning that tells the operator *"Re-set them in settings if the values are wrong"* lives
   in `staging/index.html` only — repair 8 was SENT BACK by cold review and did not land. So there is
   nothing to fix in shipped code today, and the fix must not be forgotten when repair 8 is repaired.
   **Ruled: change the copy rather than adding an input** (a new element costs attention under the
   zero-based complexity budget, and `watchCap` is not a setting the operator has ever needed to
   reach). The warning already names which keys clamped; for any key with no input it must say what
   can actually be done — the value is reachable only by editing stored state or by a restore — rather
   than naming a control that does not exist. **Repair 8 does not land until that copy is correct.**

   **SHAPE.** One row per changed KEY, never per save — a save touching three keys writes three rows,
   because a pooled row cannot answer *what was `partCapPct` before*. Its own bounded log,
   roll-then-prune, **not** the decision log (that is for rulings, and mixing edits in makes both
   harder to read). **Proposed size: 400 rows**, roll-then-prune least-recent-first, sized against the
   observed edit rate rather than a round number — and the number itself is a ruling. Carried through
   import, with the **partition question answered at birth before it accrues anything**: what regime
   writes it, what field records that, what happens when the regime changes.

   **WHERE IT RENDERS.** Beside the setting itself, not on a separate surface: looking at `reserve`
   should show it was 3m until Aug 20. **Smallest form that does that:** a dim inline suffix on the
   input's own label — *"was 3,000,000 · Aug 20"* — rendered only when a previous value exists, so an
   unchanged setting costs nothing. If that would push an element above a first disclosure, fold it
   into the existing settings disclosure instead of adding one.

   **WHAT IT IS NOT.** It records; the operator decides. Not an undo, not a revert control, not a
   proposal to restore an old value. And **not** a defence against a malformed import — the clamp rule
   already owns that.

   **VERIFICATION — discriminating seeds, and asserted at the CONSUMER** (the surface that renders the
   previous value), not only at the writer: a change writes a row with the correct before value; a
   save touching two keys writes **two** rows and not one; a no-op save writes **nothing**; a
   non-material key writes **nothing**; and the row survives an import in all three states.

---

# ALSO SHIPPED TONIGHT, outside the fix list

- **A wall clock fired during the session.** `SELL_ABS_BAND_RETIRES = Date.UTC(2026, 7, 20)` crossed
  sides on 2026-08-20 and `[R66.4]`'s last limb went red — correctly, because the comparison panel it
  asserted had retired exactly as ruled. **This corrects the morning's diagnostic**, which reported
  that a grep for the constant in the probe returns nothing and concluded there were zero assertions
  on either side: one assertion depended on it *implicitly, through the call*, and it was the only
  thing in the suite that noticed the date arrive. `sellAbsShadowHTML` now takes the clock as an
  argument and the assertion drives **both** sides, so the retirement is verified in both directions
  rather than on whichever side today happens to fall.
- **Two hollow injections closed.** `poolControlsHTML(x, armed)` checked `armed` at its guard and then
  called `opsOf(x.id)` with one argument, so the store read fell back to the const and both armed
  assertions passed against an empty skeleton. And `cutoverSetFrom` no longer accepts a bare boolean:
  `true` alone meant `{pool:true, vol5:false}`, the one combination the guard refuses, so the
  shorthand silently returned the watchlist while reading as the pool test.
- **The dead `&& CUTOVER_POOL` conjunct** in `cutoverFaultWarn` is gone. `why` truthy already implied
  it, and any future fault clause not predicated on `pool` would have been silently suppressed *and*
  actively cleared.

---
# PRIOR SESSION (superseded by the flip sequence above) — FIVE RULINGS ACTED ON — A1 built, the boot merge's first two items built, `DB.qual` dropped

**`index.html` has not moved all session.** It hashes `3cf9a22d321892e5…`, the value it had when
the session opened. **Everything is in `staging/` and nothing has landed** — by the user's own
ruling, the cold review is the next session's first act.

**Staged suite: `PROBE-PASS [STAGED: staging/index.html]`, both viewports, pairing clean both
directions (507 tags / 520 rows / 507 cited).** Baseline at session start was 489 / 501 / 489.
**Nine repairs are staged**, each with its property written down and its `Verdict: PENDING`.

## THE COLD REVIEW IS THE FIRST THING THAT HAPPENS

Read `staging/DIFF.patch` **without** reading `staging/PASS.md`'s "the finding that provoked it"
lines, without `audits/ADVERSARIAL-2026-08-19g-pass7-cutover.md`, and without this section. For
each of the **nine** repairs: name the property, run your own property-scoped search, record the
answer in `PASS.md`. `tools/stage/land.sh` refuses without it. Then the pass over the repairs.

## What the five rulings produced

| ruling | built | assertions |
|---|---|---|
| **A1** — the funding walk splits the two populations | `planCmp` is the one comparator, read by the walk and every render; `planOrder` is the funding order; **promoted items are their own group** so an override still crosses every boundary; the NEXT UP disclaimer clause came out in the same commit; the "plan is full" blame now names how many candidates are ahead and how many are pins | `[R107.7]`, `[R107.11]`, `[R107.12]` |
| **boot merge 1 + 2** | `CAP_KEYS` owns the nine keys, their tight ends and defaults; `capResolve` is the import's resolution; `clampCapKeysAtLoad` is the load path's, beside the existing shape guard. `impCap` deleted rather than left unused | `[R107.14]`, `[R104.9]` re-pointed |
| **`DB.qual` is not carried** | the carry removed, the correction recorded **as the user's** at the site and in the requirement row; one dependent assertion inverted, one withdrawn with its row rewritten to cite the new one | `[R107.13]`, `[R87.5]` withdrawn |
| **boot merge item 3** | **not built** — the unknown-key census needs its displacement answer first | — |
| **pass 7's other twelve** | **queued**, untouched, and the two that A1's own property search returned (`applyFamilyRule` and its pre-sort) are named in the source so the omission reads as seen rather than missed | — |

**Seeds S174a–S174e, one at a time, staged tree restored byte-identical between each.**

## Two green seeds, and both were findings (M173, M174)

- **`[R107.5]`** drove three controls through production's real handlers and still could not fail:
  with `ITEM_OPS` off, a routed write and a direct row write land the same value. Repaired with a
  source-level detector beside the drives.
- **`[R107.11]`** built all three candidates from one price template, so the pin's score and the
  pool items' sort keys were the same number and **every ordering agreed**. The seed measured sort
  stability. Repaired by giving the pool item a strictly wider spread.

**And `[R107.12]` caught a real defect in my own A1 before it shipped:** the first form made the
funding order a concatenation of three groups, which left a manual promotion unable to cross out of
its own group — an override that cannot cross the boundary it was pressed to cross is not one.

## Behaviour on today's book

**A1 changes nothing measurable today.** With the pool flag off every candidate is a watch row, so
the split is tenured versus held, and the held block is empty on the current book (measured 0 of
43). It bites during a `/timeseries` outage and after the cutover. The boot-merge clamp fires only
on a stored capacity setting that is not a finite number, which no path in the app writes. The
`DB.qual` change is restore-path only.

## Owed

- The cold review, `bash tools/stage/land.sh --yes`, the suite on the real files, and the
  reviewer's property in `audits/REPAIR-LEDGER.md`.
- **A pass over these nine repairs.** Every pass since 2 has found a defect inside the previous
  one's, and this session's own assertions found two in mine.
- Pass 7's remaining twelve money-path findings.
- The displacement answer for the unknown-key census (boot-merge item 3).
---

# THE SIX DIRECTIVES ON PASS 7 (superseded above by the rulings that followed them)

**`index.html` has not moved all session.** It hashes `3cf9a22d321892e5…`, the value it had when the
session opened — verified by six independent agents at both ends of the adversarial pass and by
`tools/stage/check.sh` at the close. **Everything built in the second half is in `staging/` and has
not landed.**

**Staged suite: `PROBE-PASS [STAGED: staging/index.html]`, both viewports, pairing clean both
directions (504 tags / 516 rows / 504 cited).** Baseline at session start was 489 / 501 / 489.

## THE NEXT SESSION'S FIRST TASK IS THE COLD REVIEW

Read `staging/DIFF.patch` **without** reading `staging/PASS.md`'s "the finding that provoked it"
lines and without reading `audits/ADVERSARIAL-2026-08-19g-pass7-cutover.md`. For each of the **six**
repairs: name the property it is about, run your own property-scoped search, and record the answer
in `PASS.md`. `tools/stage/land.sh` refuses to land without it.

## What was built (directives 1, 2, 3b, 4, 5)

| # | directive | what shipped, staged | assertions |
|---|---|---|---|
| 1 | flag pairing | `cutoverFault` + `cutoverPoolOn`; **`CUTOVER_POOL` without `VOL5_UNIVERSE` is REFUSED**, falls back to the watchlist, and raises a warning bar naming the missing flag. All six readers of the flag now read the effective term. The guard **refuses rather than repairs** — deriving one flag from another would arm deployment-class machinery on one press. `pool && !ops` is a stated warning and not a fault, with the reasoning recorded at the site | `[R107.1]`–`[R107.3]` |
| 2 | ITEM_OPS must not discard operator state | `opsWrite` is the one writer in both regimes; `opsFor` the one reader for callers holding a row; `itemOpsReconcile` (`itemOpsV2`) makes the store agree with the row **before** the flag can arm. **The property search returned TEN sites where the finding named four — six of them READS** | `[R107.4]`–`[R107.6]` |
| 3b | NEXT UP | grouped like the funded block, **and the header says what the grouping is not**: the funding sort does not yet split, so a group's position is not a queue position. That clause comes out when directive 3a is ruled | `[R107.7]` |
| 4 | seasoning: absent ≠ failed | `scorerCycle` keeps `S.scorerCtlFail` beside its pass set; `updateQualStreaks` breaks a streak on a **scored** failure and leaves an unscored cycle alone. The `!inAll` guard keeps the scorer's verdict off the population the allocator evaluated itself | `[R107.8]`, `[R107.9]` |
| 5 | `qualV1` ruled: do not carry | recorded at the migration site and asserted at the sanitiser | `[R107.10]` |

**Seeds S173a–S173j, one at a time, staged tree restored byte-identical between each.** Every one
reddened its own assertion; the two that cascaded were re-seeded individually.

**One seed came back GREEN and that was the finding (MISTAKES M173).** `[R107.5]`'s first form drove
all three drivable controls through production's own delegated handlers and still could not fail:
with `ITEM_OPS` off, a routed write and a direct row write land the same value, and nothing at
runtime flips the flag. Repaired with a source-level detector beside the drives — the app's own
script text must carry **zero** direct `w.<field> =` writes of the six operator-state fields — and
re-seeded red alone.

## What was NOT built, and why

- **Directive 3a — the funding sort.** Deployment-class, the user rules the proposal:
  `audits/PROPOSAL-2026-08-19-funding-sort.md`. Three allocation rules costed;
  **A1 (tenured-first, pool fills the remainder) is recommended** because it is the only option
  strictly *narrower* than today, so it needs no measurement to justify it. Option B is costed and
  shown to have no honest item-level form except changing the unfed default, which is a
  strategy-constant change dressed as a bug fix.
- **Directive 6 — the boot merge.** Scoping only:
  `audits/BOOTMERGE-2026-08-19-load-path-scoping.md`. **The import's sanitiser does not serve at
  load, for four reasons that are not cosmetic** — it drops rows (22 `filter(Boolean)` passes), it
  mints ids on every boot, it applies sixteen retention caps, and its null→tight rule is written
  against a foreign file rather than the user's own store. The recommendation is **not** a load-path
  sanitiser: extract the clamp rule into one term applied on both paths, extend the existing shape
  guard to the nine cap keys, and **report** unknown keys rather than deleting them.

## Owed

- The cold review, then `bash tools/stage/land.sh --yes`, then the suite on the real files, then the
  reviewer's property in `audits/REPAIR-LEDGER.md`.
- **A pass over these repairs.** Every pass since 2 has found a defect inside the previous one's.
- Pass 7's remaining findings — 12 of the 17 money-path ones are untouched by these six directives.
- Rulings: directive 3a; the `DB.qual` carry question raised by directive 5 (`DB.qual` **is**
  carried, so a restored file's streaks travel with it, which the file-as-press argument reaches
  the same way it reaches `qualV1`); the boot-merge clamp extraction.
---

# PASS 7 ITSELF — the cutover-scoped pass, 17 money-path findings (the directives above act on six of them)

**Tree UNCOMMITTED and UNCHANGED this session.** `index.html` hashes
`3cf9a22d321892e5…` — the same value it had when the session opened, verified by six independent
agents at both ends of the adversarial pass and by `tools/stage/check.sh` at the close. **Suite on
the tree: `PROBE-PASS`, cold, 489 tags / 501 rows / 489 cited, pairing clean both directions.**
Committing and pushing are the user's.

**Everything built this session lives in `staging/` and has not landed.** That is the new rule, not
an accident — see *the staged repair pass* below.

## 1. Pass 7 — the cutover surface, `audits/ADVERSARIAL-2026-08-19g-pass7-cutover.md`

| pass | scope | money-path |
|---|---|---|
| 4 | cutover-critical assertions | 0 that bite today |
| 5 · 6 | `validateImport` and its repairs | 3 · 8 |
| **7** | **the cutover surface itself** | **17** |

Five non-overlapping readers, adversarial refutation per finding, a completeness critic.
**435 reader-minutes · 322 call sites · 147 assertion bodies read in full.** 34 findings,
25 verified, **22 survived, 3 refuted**. No finding rests on a suite result. Verification was capped
at 5 per reader and **the 5 it did not reach are named in the report** — all non-money-path.

**Almost every finding is LATENT and armed by exactly the flags the ruling would flip**, which is
why four earlier passes could not see them: the population they concern does not exist until
`CUTOVER_POOL` is true.

**The four that decide the ruling**, each re-verified against source by hand:

- **The operator store and the watch row have different owners for reading and writing.** `opsPick`
  prefers the store; `itemOpsMigrate` snapshotted once and never runs again; and of the writers of
  those six fields **exactly one branches on the flag** (line 7869) while the four watch-row
  controls write the row unconditionally. So flipping `ITEM_OPS` **discards every operator edit made
  since the migration boot** — including a hand-set untiered override, which is a bench removed with
  no press. `[R93.4]`'s fixture writes the store and never the row, so no assertion can see it.
- **`CUTOVER_POOL` without `VOL5_UNIVERSE` is a widening.** The 5m die-off streak is kept for
  `DB.watch` only and *deleted* for everyone else, so `volGateFor` falls through to the 1h branch for
  a pool item. The 5m binding is a `Math.min`, so pool items would be sized **larger** and clear the
  volume floor **more easily** than an identically-placed pin in a collapsing book. Three independent
  `const`s; nothing enforces the pairing; only this ordering is dangerous.
- **The plan's two-group split is applied AFTER funding.** `planGroups` is called once, on `picks`.
  The sort that decides the seven slots and the per-slot budget is one list, on a score whose four
  history terms are a neutral 1.0 for pool items — the exact condition the split's own design
  comment calls *"the never-fed-aggregate rule inside a sort comparator"*. **This was scoped
  deliberately** (the comment says display-only and calls the merge deployment-class), so it is a
  decision for the ruling rather than a defect to fix. Its second half is not ambiguous: **NEXT UP —
  the automatic funding queue — is not split at all**, so the surface shows a separation the money
  never had.
- **The seasoning reset cannot see a pool item's market-gate failure.** The reset fires on
  `x.failed`, and a pool item that fails a market gate is simply *absent* from the candidate list
  rather than failed. Three passes out of ~576 buckets would season a pool item; the same behaviour
  never seasons a pin. **Seed result: nothing — uncovered.** Deleting the reset entirely turns no
  assertion red.

**What this does to the gate.** Three of the four ruled requirements were done; the adversarial pass
was the fourth and it did not come back clean. **The position is not "one clean pass away" — it is
"triage these, close the money-path ones, then a pass over the repairs".** Every pass since 2 has
found a defect inside the previous pass's repairs; budget for it.

## 2. The staged repair pass is built and proven — `tools/stage/`, PROBE.md, CLAUDE.md

`run.sh` takes `PROBE_SRC` / `PROBE_SNIPPET` / `PROBE_REQ`; four scripts open a pass, run the full
suite against it, prove the freeze and produce the diff, and land it under a guard. **A staged run
stamps its own header** (`PROBE-PASS [STAGED: …]`) so it can never be quoted as a tree run.
`staging/` is gitignored; the durable record is **`audits/REPAIR-LEDGER.md`**, which carries **both**
namings of each property — the repairer's and the cold reviewer's — because only the pair says
whether a later recurrence means the property was named too narrowly or the search was run too
narrowly.

**Proven by seeding, both overrides, one at a time:** a sign flip in `staging/index.html` alone took
the suite to `PROBE-FAIL 8` with `index.html` hashing unchanged; an always-false `ok()` in the staged
snippet alone took it to `PROBE-FAIL 1`. `land.sh` was proven to refuse and to pass.

## 3. STAGED, AWAITING COLD REVIEW — the live-trading track

**`staging/PASS.md` · `staging/DIFF.patch` · `staging/REPORT-staged-{1200,390}.txt`.**
Staged suite green on both viewports, pairing clean (494 tags / 506 rows / 494 cited).
**Seeds S172a–S172e each reddened their own assertion alone**, one at a time, restored between.

**THE NEXT SESSION'S FIRST TASK IS THE COLD REVIEW OF THAT DIFF.** Read it *without* reading this
section or `staging/PASS.md`'s finding line: name the property each repair is about, run your own
property-scoped search, and record your answer in `PASS.md` before anything lands.

The finding named two writers; the property returned **three**. Five assertions, anchored at
`sellAgeInfo` and `staleBuyInfo` — the branches that render *undercut & exit* and *cancel — market
moved* — plus one pinning the number of position-creation sites so a fifth cannot land silently.

## 4. The restore track is enumerated and closed — `audits/DBKEYS-2026-08-19-restore-enumeration.md`

**29 keys `validateImport` never writes: 17 WRONG, 6 HARMLESS, 6 DELIBERATE.** Twelve bite today.
Sharpest: the **one-shot migration flags** (`shadowPurgeV1`, `paperEpoch2`) — restoring a
pre-migration file into a browser that already ran the migration leaves the flag set, so the imported
data **never migrates, permanently** — and **`poolSeen`**, which splits the pool-persistence ledger's
numerator from its denominator across the restore boundary, corrupting the evidence base for the
seasoning measurement the cutover ruling needs.

Three findings the key-by-key question could not produce: **the boot merge at line 1363 has no
sanitiser at all** (one question, two owners, in the largest store in the app); **five IndexedDB
stores are outside the restore entirely**, including `rdiff`, the cutover gate's own evidence; and
`shadowBook[].clrGen` is a row-level omission a key-level enumeration is structurally blind to.

**Nothing here is repaired.** The remediation is not one commit — 14 keys want carrying, 6 want a
comment at the site, 1 (`qualV1`) wants a ruling because carrying it grandfathers restored rows past
the seasoning gate, and two structural findings are bigger than the import path.

## 5. What is owed

- **The cold review of `staging/`**, then `bash tools/stage/land.sh --yes`, then the suite on the
  real files, then a row in `audits/REPAIR-LEDGER.md`.
- **Triage of pass 7's 17 money-path findings**, staged under the new rule. Three of them are
  decisions rather than repairs and belong to the user: whether the funding sort splits the two
  populations; whether `CUTOVER_POOL` may flip without `VOL5_UNIVERSE` (on the evidence it may not);
  and whether a pool item seasons on the same rule as a pin.
- **A pass over those repairs**, because every pass since 2 has found a defect inside the last one's.
- The restore-track remediation, at the user's pace — the backup is not being restored until it
  closes.

## The three clocks (unchanged, no code moves them)

1. **Chart gates — N of 7 OBSERVED days.** Read the tripwire caveat in the section below before
   trusting it: `[R76.9]` cannot observe a runtime coverage transition, and the correction is
   recorded. Pass 7 adds that **`VOL5_UNIVERSE`'s armed branch is unreachable from any test at all** —
   `planCandidates` and `opsOf` both took an injection parameter for this reason and
   `vol5Population()` did not.
2. **Capture grading — waits on the operator's real calibration flips.** `[R78.17]` pins
   `SCORER_CAPTURE_GRADED = false`; every ranking surface says "cannot rank yet".
3. **Reconciliation history — `rdiff` accrues every scored bucket.**
---

# PRIOR POSTURE (superseded by the section above — kept for the detail it carries)

**Tree UNCOMMITTED. Suite: `PROBE-PASS — 1,262 assertions, COLD PROFILE, both viewports, pairing
clean both directions (489 tags / 501 rows / 489 cited)`.** Cold and warm compared: identical,
assertion for assertion. Committing and pushing are the user's.

**THE SUITE NOW RUNS COLD BY DEFAULT** (user ruling, Aug 19 2026). `run.sh` deletes the browser
profile before every run; `PROBE_WARM=1` keeps it, and exists only to produce a warm run to compare
against. **If cold and warm ever differ, that difference is a finding** — some assertion is reading
state nothing wrote, and the warm green is the one that was lying. This was not hypothetical:
`[R82.4]` was passing on reconciliation rows an EARLIER RUN had left in IndexedDB (**M166**).

**Full record: `audits/QUEUE-2026-08-19-repass-closure.md` (the queue) and
`audits/ADVERSARIAL-2026-08-19c-queue-pass.md` (the third adversarial pass over it).** In one line
each: **hourWeight** routed through the resolver with a third state and a hold-out (ordering change
measured at **0 of 43** live watch items); **assert-at-the-consumer** is BINDING with **scan 15**
as its detector and `PROXY-ASSERT` as its tag; **23 re-pass findings closed**, the two owed
allocator assertions written, and `[R7.3]`'s owed limb paid.

**One incident to know about before anything else:** an agent-side `git checkout --` destroyed
three uncommitted `MISTAKES.md` entries. M157 and M158 were restored verbatim from the session
transcript; **M156 is RECONSTRUCTED from its cited sources and marked as such — its original
wording is not recoverable.** Recorded as M160; the rule is in CLAUDE.md's repo-hygiene section.

**The three clocks (no code moves them):**

1. **Chart gates — N of 7 OBSERVED days from 1b** (Razer uptime gates it). When day 7 lands, the
   chart-wiring build runs. **READ THIS BEFORE TRUSTING THE TRIPWIRES.** `[R76.9]`'s era fact was
   claimed, in CLAUDE.md and in two code comments, to fire when the wiring lands. **It does not,
   and the third adversarial pass proved it historically: the wiring landed on Aug 18 and nothing
   went red.** Its subject is a synthetic id absent from the real archive, so its `tr` is null
   whatever the gate says. It has been strengthened to assert BOTH directions and the claim is
   corrected everywhere — but **no in-page assertion can observe a runtime coverage transition**,
   because that is a clock and not a code shape. The forcing function for the clock is the cutover
   gate's fourth prerequisite, read by a person. `[R100.4]` — added Aug 19, asserting the archive
   does NOT feed an hour-of-day profile — is a genuine armed fact by contrast: it forces its own
   fixture's ready path, so wiring a profile out of the archive's hour-stamped keys turns it red. The second is armed
   against a different transition: building `byHour` out of the archive's hour-stamped bucket keys
   would feed a score weight for a whole population whose ordering was ruled on the assumption that
   it was not fed. **That wiring is deployment-class in its own right and must turn `[R100.4]` red
   before it lands.**
2. **Capture grading — waits on the operator's real calibration flips** inside the 36h tape window,
   on frontier-class items. `[R78.17]` pins `SCORER_CAPTURE_GRADED = false`. Until then every
   ranking surface says "cannot rank yet" in the ruled words. b=100 stays deferred on exactly this.
3. **Reconciliation history — `rdiff` accrues every scored bucket**; the reader is built and the
   classification runs on the next app open, including the 7-row coverage gap. `rdiff` is a
   CONSUMED store and scan 2 no longer re-reports it.

**The cutover gate (deployment-class, the user rules when):** four ruled requirements —
reconciliation history explained; an integration-audit walk of the new surfaces; an adversarial
pass over cutover-critical assertions at the `[R7.3]` standard; and **chart gates at 7 of 7
observed days**. The gate's internal order is ruled: integration audit → scan 14 → adversarial
pass. **Three of the four are done. The clock is the one that is not.**

Plus three explicit decisions inside the ruling itself: the pool switch; seasoning's shape for pool
items (bring the measurement — how often is a first-cycle entrant still in the pool one calendar
day later); and the plan surface as approved.

**Every deployment-class component is built and flagged OFF:**

| flag | what it arms | pinned by |
|---|---|---|
| `CUTOVER_POOL = false` | the plan's candidate pool reads the control cell | `[R89.1]` |
| `ITEM_OPS = false` | operator state reads the item store instead of the watch row | `[R93.1]` |
| `VOL5_UNIVERSE = false` | the 5m die-off streak counts universe-wide | `[R94.3]` |
| *(coverage gate, not a flag)* | chart wiring activates at 7 of 7 observed days | `[R94.1]` |
| *(era fact, not a flag)* | the archive does not feed an hour profile | `[R100.4]` |

**Anytime items (no clock, no ruling needed to start):** the remaining **369 of 385 scan-14
candidate labels**, unread; the production-anchor `codeQuote` schema for future censuses.

**Conditionally pre-approved (trigger is the user's real-phone look, nothing else):** the 390px
wrap-and-minmax display pass, exactly as scoped in `audits/NAV-2026-08-14-transitional-chrome.md`
§11. IF the phone shows horizontal clipping → build it, no further ruling. IF it renders like the
ruled runs → close the observation as device-dependent and strike this trigger.

**Queued behind capture calibration:** the sleeve integration stages — the conformance gate applies
identically, and the conviction-boundary detector ships with the first planner surface. Only the
90d retention extension may ride early.

---




# PASS 6 — EIGHT money-path findings, six inside pass 5's repairs. THE GATE IS NOW SPLIT.

`audits/ADVERSARIAL-2026-08-19f-pass6.md` · `audits/GATESPLIT-2026-08-19-cutover-vs-restore.md`

**THE GATE SPLIT (user ruling, Aug 19 2026).** The cutover's requirement is that the CUTOVER path is
clean — the pool switch, the plan surface, the operator store, the gates, the scorer. **Restore is a
different subsystem and has never been in the cutover's scope.** Of the 12 money-path findings across
passes 5 and 6: **8 restore/import · 3 live-trading · 1 claim-level on the cutover surface · ZERO
behaviour defects on the cutover path.**

**Two things that follow, and the second is the one that matters:**
- **It is a THREE-way split.** Findings 7, 8 and 12 are neither cutover nor restore — they bite today
  on an ordinary trading day with no import involved. A two-track plan drops them.
- **Passes 5 and 6 had the cutover surface nowhere in scope**, so their zero is evidence nobody
  looked, not evidence the surface is clean — and equally, neither counts against the cutover.
  **The cutover has one clean pass over its own surface (pass 4) and needs a second, scoped the same
  way.** That pass has not been run. The cutover gate is one cutover-scoped pass away.

---

# SHIPPED 2026-08-19 (earlier session) — the three unambiguous pass-6 fixes, all seeded

**Suite: `PROBE-PASS — 1,262 assertions, COLD PROFILE, both viewports, pairing clean both directions
(489 tags / 501 rows / 489 cited)`.** Cold and warm identical. Seeds S171a–S171g, one at a time,
tree restored byte-identical between each.

- **A restore is now persisted.** `flush()` alone was a no-op — it returns early on `if (!dirty)`,
  and `dirty` is set only inside `save()`, which `Object.assign` never calls. A whole-state restore
  lived in memory until some unrelated save happened to fire. **`applyImport` was EXTRACTED** so the
  branch could be asserted at all: it lived inside a `FileReader.onload` no test can drive.
  `[R105.1]`, `[R105.2]`.
- **The record-level source tier.** The third bare unary plus, three lines below one the previous
  repair fixed. Asserted at the **admission gate** that spends it — a catalyst with no tiered
  citation and a null record tier is now REJECTED. `[R105.3]`.
- **Clearing the quantity box clears the override** instead of writing a manual size of zero. Live,
  no import involved. Driven through production's own delegated `change` handler. `[R105.4]`,
  `[R105.5]`.

**CAPS RE-RULED, both halves separated (user ruling):** **null → TIGHT, absent → DEFAULT.** Absent
was never misbehaving, and resolving it tight rewrote nine strategy constants on any backup
predating a field. `impCap(o, k, tight, def)` replaces `impTight` and reads `hasOwnProperty`, so the
two states are genuinely different answers. **`slots` and `watchCap` JOINED the cap set** — the
classification now comes from what a key does (does it bound what may be funded, sized or admitted?)
rather than from which object literal it sits in. Nine keys, **membership pinned by name** in
`[R104.9]`, because the defect was a classification error rather than a coding one.

**`[R104.8]` repaired twice over, from pass 6's own findings:** its allow-list is now checked in
**both directions** (an entry that stops appearing is caught — four went stale within one revision),
and its "absent" fixture now genuinely omits keys instead of setting them to `undefined`, which
every `hasOwnProperty` branch had been reading as PRESENT.

## Two incidents worth knowing

- **M171** — `[R105.3]`'s first form was pointed at `validateImport` when the fix was in
  `importIntelligence`. The seed reverted the real defect and **the suite stayed green**. Caught by
  seeding, re-pointed at the admission gate, re-seeded red.
- **M170** — **three repairs in a row were scoped to the finding's spelling rather than its
  property**, each one the repair for the instance before it. This is the constitution's first rule
  failing at the moment it is most needed.

# OWED as of that session (superseded by "What is owed" at the top)

- **The restore track:** `hzH` unstamped by two production writers, `planPriority`/`planDemoted`
  surviving a restore, `clrGen` missing from the shadowBook carry, seven browser-scoped provenance
  keys, the import repainting two settings inputs of ~30, `dieOffLog[].voidH` write-only, and the
  **full `DB` key enumeration** the user queued (three buckets: deliberate, harmless, wrong).
- **The live-trading track:** the two unstamped-position writers.
- **The cutover track:** one pass scoped to the cutover surface.
- **`[R104.8]`'s stated limits**, both from pass 6: it covers only the stores its fixture builds
  (17 of ~36) and reads only `validateImport`.
- **A ruling on the cold-repair-review mechanics**, proposed in
  `audits/PROPOSAL-2026-08-19-cold-repair-review.md`.

---
# PASS 5 — THREE money-path findings. NOT the second clean pass.

`audits/ADVERSARIAL-2026-08-19e-pass5.md`. Two non-overlapping readers (33 and 45 call sites),
per-finding adversarial verification on three lenses, a completeness critic. Freeze held on all six
hashes. **13 findings, 12 survived verification, 1 refuted. Neither reader ran the suite.**

| pass | money-path | where |
|---|---|---|
| 2 | 7 | inside pass 1's fixes |
| 3 | 1 | inside pass 2's fixes |
| 4 | 0 that bite today | — |
| **5** | **3** | two inside pass 5's own session; **one pre-existing and older than all of them** |

**The one that bites today, on real money: `hzH` was dropped from real positions and standing
quotes.** A leg stamps the horizon in force when it was placed; neither carry preserved it; and
`legHorizonH` falls back to 4h. So after any state-backup restore a leg placed at the 21:30 touch
under a 9.5h horizon read at 05:00 as past **2×** its horizon, `sellAgeInfo` returned rung 2, and
the sell card said **UNDERCUT & EXIT** on a leg behaving exactly as placed. **The same function
already enforced this for the paper book**, under a comment calling the loss forbidden in the
cadence ruling's own words. Fixed.

**The two that were mine:** the settings repair moved `partCapPct` and `clusterCapPct` off their
restraining floor of 1% to their permissive defaults of 10% and 15% — for a cap the floor **is** the
restraint — and the `bands` comment stated the withholding direction as a universal, which
`tierOv: 0` falsifies. Both ruled and fixed.

**The biggest finding was not money-path and it killed the sweep's central claim.** `null >= 0` is
**true**, so five of the 106 conversions were renamed rather than repaired, and `[R103.6]` — the
assertion certifying the class closed — greps for `num(x) >= 0` and found none **because they were
now spelled `nz(x) >= 0`.** Green, reading live source, certifying a property that did not hold.
Two bare `+s.tier` coercions survived for the same reason. **Root: the sweep was scoped to the
helper's NAME rather than to the PROPERTY** — a coercion that maps null to zero — which is the
first rule in CLAUDE.md, broken while writing a different rule into CLAUDE.md.

---

# THE REPAIRS — all six ruled items shipped, seeded S170a–S170g

**Suite: `PROBE-PASS — 1,256 assertions, COLD PROFILE, both viewports, pairing clean both
directions (483 tags / 495 rows / 483 cited)`.** Cold and warm identical, assertion for assertion.
One seed at a time, tree restored byte-identical between each.

- **`hzH` rides the carry for real legs**, asserted at `legHorizonH` — the branch that turns the
  stamp into a sell instruction — as well as at the carry. Absent stays absent.
- **`nz` is module-scope now**, beside `clampNum`, with the property stated in full. It had to move:
  the second `+s.tier` lives on the intel import path, outside the sanitizer, and **a term that owns
  a property cannot live inside one of its callers.**
- **`[R104.8]` is the new detector and it tests BEHAVIOUR, not text.** All-null and all-absent
  fixtures, one row per store; every output path that comes back as the number 0 must be in a stated
  allow-list. **The allow-list is the deliverable — 54 paths in seven named groups.** Its seed was
  `Math.round`, a spelling on no list anywhere, and **`[R104.8]` went red alone** out of 1,256
  assertions.
- **`[R103.6]` kept and relabelled** — it enumerates the three known `num`-spelled idioms and no
  longer claims to close the class.
- **CAPS RULED: an import may never loosen.** Seven cap-like keys resolve to their tight end for
  null AND absent; budgets and reserves keep their defaults. `impTight` takes the tight end
  **explicitly**, because the floor is not always the tight end — `[R104.5]` asserts the four
  counterexamples (`pumpThinGp`, `seedTrips`, `pumpWindowD`, `clusterMinDays`) keep theirs, since
  flooring them would have **loosened four settings in the name of a rule against loosening**.
- **Numbers corrected: 271 `num()` sites, not 274.** And **M169's occurrence count was wrong** —
  only one of its three cited priors is the same root; the other two are carry-completeness defects
  and one is a string the helper never touched. The correction is recorded in the entry, not edited
  over it. **This coercion has two recorded occurrences, not three.**
- **The bands sentence fixed, the ruling kept.** It now rests on the argument that holds —
  withholding is the *smaller* change — rather than on a false universal about direction.

## Owed from pass 5, not fixed

- **`dieOffLog[].voidH` is write-only.** Carried by the import, read nowhere; `voidHs` recomputes a
  different quantity. Pre-existing, no assertion holds it alive, not a staged store.
- **`[R103.2]`'s ambient dependence on working capital** — left uncertain by the reader, unresolved.
- **The `DB` key enumeration (queued by the user).** `DB = Object.assign(DB, v.db)` means any key
  the sanitizer does not write silently keeps the importing browser's current value. Three buckets:
  deliberate, harmless, wrong. **Same restore path that dropped `hzH` and turned `qty: null` into
  zero**, so it earns an enumeration rather than a spot check.

---
# THE `num()` NULL SWEEP — a live money-path defect, and a class closed rather than an instance

`audits/SWEEP-2026-08-19-num-null.md` is the full enumeration; **M169** is the incident.

`num()` in `validateImport` is `Number.isFinite(+v) ? +v : null`, and `+null` is **0**, which is
finite — so an explicit null in an imported file returns as the **value zero**. The state backup is
`JSON.stringify(DB)`, so any field the app writes as null corrupts in **one hop**.

**THE LIVE ONE, AND IT PREDATES EVERY CUTOVER COMPONENT: `watch[].qty`.** All three creation paths
write `qty: null`, and null there means *size me automatically*. After a state-backup restore the
whole watchlist read as a **manual override of zero** — `opsPick` returns 0 because 0 is not null,
`planQty`'s `wanted` becomes 0, and the sizing gate benched every automatically-sized item, **with
a reason naming working capital or a missing buy limit, neither of which had happened**. The plan
would fund nothing but hand-sized rows. It suppresses funding rather than widening it, so it errs
safe, and the repair is behaviour-identical under uncorrupted data.

Four more restored as measurements that were never taken: `peakToFlagD` and `retracePct` (into the
anomaly scan's median lag and median retrace), `runwayD` (rendering *"inside/past the window"*), and
`rung` (every hand sleeve exit relabelled as a ladder exit).

**Closed as a class, not as five fixes.** `nz(v) = v === null ? null : num(v)` owns *null is a
state, 0 is a value*; **101 call sites across 47 lines** use it, **271 `num()` sites remain
and are correct**, and **three `num(x) != null` are retained on purpose and named in the source** —
the two `itemOps.bands` edges (rejecting a malformed pair would move an override from WITHHELD to
APPLIED, which is a ruling) and the econ nets (else-branch is already 0).

**The settings block cuts BOTH ways, and one half is a widening — stated rather than buried.** Five
of the 23 keys floor at 0 rather than at 1. `shadowReserve` and `reserve`: a null zeroed them, and a
reserve going to zero **widens what the allocator may fund**, so the repair (fall back to the
default) **narrows**. `t1Budget`, `t2Budget`, `sleeveBudget`: a null zeroed them too, which funds
**nothing**, so the repair **widens** — from zero to 60m / 30m / 60m — for a file carrying an
explicit null. The argument for taking it: an explicit null and an absent key both mean *this file
carries no value here* and must behave identically, and the old behaviour was not conservative but
**incoherent**, loosening the reserve and tightening the budgets on the same input. **No path in the
app writes null to any of these keys** — every setting goes through `clampNum`, which always yields
a number — so this is reachable only from a hand-edited or truncated file. If the wanted behaviour
for a malformed settings block is *refuse the import* rather than *fall back to the default*, that
is a ruling and is not made here.

**`[R103.1]`–`[R103.6]`, seeds S169a–S169f, one at a time, restore-verified byte-identical between
each.** `[R103.6]` reads `validateImport`'s own source and goes red if any of the three guard
idioms reappears; **its limit is stated where it lives** — it cannot catch a bare `num(x)`
assignment, and `[R103.1]`/`[R103.5]` carry that half field by field.

Two things the seeding taught: `[R103.6]`'s first run went **red on its own documentation** (the
`nz` comment quotes the idiom; block comments are now stripped, and only block comments, because a
`//` stripper would eat the tail of `/^https?:\/\//`). And the first form of `[R103.5]` was written
as a **fixed point** (`f(f(x)) === f(x)`) and **could not fail** — this defect converges after one
hop, so both passes agree while both are wrong. Replaced with eight named fields, each of which a
seed does redden.

**The `nz` sweep broke no existing assertion.** That is the third of the three answers the standing
rule allows — the change was genuinely uncovered, and §103 is that coverage.

---

# NEW BINDING RULE — one question, one term

**Written into CLAUDE.md on the user's ruling, with scan 17 as its detector.** Three instances in
four adversarial passes: the readiness mask vs its four consumers (`[R99.3]`), the two history gates
that stopped being a partition (M164), and the scout's eviction guard vs the gate chain
(`[R102.2]`); plus a weaker fourth where the two sites were two *writers* (`[R101.5]`).

**The mechanical half was measured and rejected, and the measurement is the useful part.** The
obvious candidate — find every expression compared against two different numeric literals — returns
**84 groups from 1,141 numeric comparisons** in `index.html`, almost all legitimate (`pts.length`
against 5 and 24 is momentum and drift **correctly** disagreeing) or noise from one-letter names.
Worse, its recall on the recorded instances is **zero for the two that can be checked**: their
conditions contain no numeric literal at all (`ser.src === "none"`, `!(sp && sp.noData)`,
`tr == null`). The third instance's pre-fix expression is **not recoverable** — the tree is
uncommitted and that intermediate state never reached `HEAD`, so it is reported unknown rather than
guessed. **The drift was between differently *phrased* predicates every time, not between
constants.** So scan 17 is a read with an enumeration as its deliverable, in the shape of scans 6,
9, 10, 13, 14 and 15.

**Also fixed in passing:** nine unexpanded `$EM` placeholders in MISTAKES.md M167/M168 — a prior
session's shell variable that never interpolated inside a quoted heredoc.

---
# PASS 4 — ZERO money-path findings that bite today

`audits/ADVERSARIAL-2026-08-19d-pass4.md`. Two readers, deliberately non-overlapping: one over the
recent changes, one told NOT to read the diff and to read instead the code that did not change but
now receives different values. 106 and 61 call sites read in full. Freeze held on both hashes.

| pass | money-path findings |
|---|---|
| 2 | **7** (inside pass 1's fixes) |
| 3 | **1** (inside pass 2's fixes) |
| **4** | **0 that bite today** |

**Neither reader used a suite result as evidence for any finding** — everything is traced from
quoted source to its consumer. That matters because every green before the cold-profile fix was a
warm green; nothing here rested on one, so nothing needed re-checking.

**One finding was LIVE and is fixed:** the plan's *"N charts still loading"* count matched a phrase
in the bench SENTENCE, the readiness repair rewrote that sentence, and the phrase left the file — so
the count was permanently zero and the plan stopped explaining why nothing passes, on every cold
boot (**M167**). The assertion written to protect it re-derived the count inside the probe and did
not bite; caught by the seed and repaired (**M168**).

**Two are money-path in SHAPE and latent behind `ITEM_OPS`, both fixed:** `provenLoser` added its
own row fallback after `opsOf` and so resurrected a CLEARED test date, releasing a proven-loser
bench; and the item-store import mapped a cleared override's `null` to the VALUE zero, which reads
as a manual override to UNTIERED and benches the item, with copy claiming a decision the operator
had removed. The same branch had no range check, so `tierOv: 7` produced a funded line with a NaN
quantity. **Both arm at the `ITEM_OPS` ruling** — they are removed from that stanza's path now.

**Structural repair worth knowing:** `historyVerdict` now owns the two history gates AND the scout's
eviction guard, so `judged` is the exact complement of the two benches. They had drifted — the guard
called an item judged at 3 finite points while the chain benched it unreadable until 24, so an item
in that window was evictable on a verdict the chain could not reach. **Third time in four passes a
paired condition drifted; the answer each time is to make it one term.**

---

# THE THIRD ADVERSARIAL PASS — 41 findings, and it found what the two before it found

`audits/ADVERSARIAL-2026-08-19c-queue-pass.md`. Four read-only agents over a frozen tree; the
freeze held on all four hashes. **Every one of the three passes has now found a money-path defect
inside the previous pass's fixes, and this one found the defect introduced while closing the
previous pass's money-path finding.** Assume a fourth would too.

**The money-path finding: the two history gates stopped being a partition.** Adding
`&& ser.src === "none"` to the `no history` bench — the fix for the re-pass's own finding 11/17 —
left the OTHER gate still suppressing itself on `!(sp && sp.noData)`, so the region *empty
/timeseries, archive has entries, series not ready* benched on **neither**, and trend, volume
trend, momentum and drift all passed unread. Latent, and it would have armed at 7 observed days.
Fixed by making the suppression the SAME named term the first gate fires on. **M164.**

**Live today, and fixed:** the inert-restraint line and the pool-persistence drill were written to
`#benchBody` and overwritten four lines later, so the persistence badge rendered on every funded
row with its rows unreachable. And `[R101.6]` — the assertion written to close finding 30 —
**passed with its own detector deleted**, because it drove the state by hand instead of through
`chk`. **M165.**

**Two claims corrected rather than defended:** `[R76.9]`'s tripwire (above), and the fact that
routing `hourWeight` through the resolver is a **behavioural identity today** — `ser.byHour` IS
`sp.byHour` on every branch, so no assertion can distinguish the two forms until something other
than the spark feeds a profile. The routing is prospectively right; the report claimed more.

Everything else fixed in the same pass: four union-rendered-as-universal defects in the plan copy,
three merged absences (`hw.fed` was three facts wearing one answer), the residual anti-tripwire in
`planInertLine`'s frame, two coverage clocks reported as one, `chartedNow` wrong in two directions,
`excStanding` as an unenforced third reader of the gate-name promise, five assertions that could
not fail, three fragile fixtures, and five records that outlived what they described.

---

# OWED, and each one is a decision rather than a task

- **`reliability`'s total-absence silence.** It renders *"thin history (2/4 trips in 30d) —
  reliability weight off"* for `n` of 1–3 and **says nothing at all for `n === 0`** — partial
  absence disclosed, total absence silent, which is the inverse of what you would want. Measured:
  **30 of 43 live watch items** have no flip history at all, so fixing it adds a string to 30 of 43
  plan lines. A material change to a surface read daily, so it is reported rather than shipped.
- **Finding 18 of the re-pass** — a pruned migrated item-ops row does not lose its value (it
  resurrects from the watch row) while the prune's warning tells the operator to re-set it.
  Deferred by the finding's own proposal to the stage that flips `ITEM_OPS`, where it needs an
  assertion at the composition rather than on either side of it.
- **Teardown assertions cannot discriminate set-or-delete from a blind key-delete.** The probe runs
  with DNS dead, so `/mapping` never loads and every captured cache cell is `undefined` in every
  run — the conditional's set branch is unreachable. They detect a MISSING restore, which is real
  but narrower than `[R95.5]`/`[R97.2]`/`[R98.5]`'s labels claim. Remedy is the tenth-face decoy the
  project already uses for `blendFrag`: plant a sentinel on each block's own ids before the capture.
- **`chartWireState`'s could-not-check branch is unreachable from production** and the real producer
  is the surrounding `catch`, carrying a SECOND copy of the same copy. `[R94.1]` asserts the
  unreachable one. One owner, one string.
- **The `sc-sixgate` glossary entry** says `marketStatsFor` carries no chart inputs yet; after step C
  it does, gated. Stale constant, no landing path, nothing pinning it.
- **`itemOpsPrune`'s 90-day drop of a manual `qty`.** Recorded by the previous pass as a question
  for the arming stanza, not a finding against a dead path: dropping an `mq` smaller than the cap
  WIDENS the funded size, which is an expiry that loosens, and the restraint-lift rule reserves
  that for a press.

---

# SESSION CLOSE — 2026-08-19 (the re-pass queue)

**Suite 1,207 → 1,228. 21 new assertions, 26 discriminating seeds (S90–S115), one at a time,
restore-green between.** Two seeds came back GREEN and both were findings rather than clean bills —
one ambiguous pattern caught by the harness's own match-count assertion, one fixture that could not
express the defect (**M163**).

## What changed for the operator

**Nothing about what the plan funds or how it sizes.** Every change is a render grouping, a
disclosure, a restraint that narrows, or a test.

- **A new block may appear on the plan: *"Not ranked — price history not fed"*.** It holds picks
  whose hour or stability weight came from a failed fetch rather than a measurement. They are
  funded and sized exactly like any pick above; only their PLACE in the ranking is withheld.
  **Measured at 0 of 43 items today** — it will render during a `/timeseries` outage and after the
  cutover, and nothing else.
- **The pool header now separates two claims** — *not applied* (a fact about the sort, true for
  ever) from *not fed* (a fact about the data, computed and self-correcting).
- **The inert-restraint line names only the restraints actually absent**, so it stops contradicting
  its own day count at the chart transition.
- **A watch row's FALLING chip and sparkline read the same series that benched the row.** An
  archive-fed row used to show no chip and a dimmed "…" while the chain benched it *"falling chart"*.
- **The `no history` bench stopped firing on a false premise** — it read the item's own
  `/timeseries` flag alone and could claim no history exists for an item the archive had fully
  evaluated.
- **A new warning bar exists and should never appear:** *"Gate name not listed in
  GATE_CHAIN_ORDER"*. If you ever see it, that is a build defect, not a market condition.

## Still pending, not blocked

rdiff classification (needs accrued verdicts) · the seasoning measurement (needs days of pool
observation) · chart-gate verdict validation (needs 7 of 7 coverage) · capture grading (needs the
operator's calibration flips) · the T2 ceiling ruling (evidence in
`audits/CEILING-2026-08-18-above-t2.md`).

---

# SESSION CLOSE — 2026-08-18 (fourth pass: the frontload, A–E complete, TREE READY TO FREEZE)

**Steps A → B → C → D → E of the ruled frontload are done. F is the freeze, and this is the
report that precedes it.**

**Suite: `PROBE-PASS — 1,181 assertions, BOTH viewports, pairing clean both directions
(430 tags / 442 rows / 430 cited)`.** Baseline at the start of this pass was 1,121.
**60 new assertions across §87–§94, 57 discriminating seeds (S22–S78c), one at a time,
restore-green between.** **Tree UNCOMMITTED — committing and pushing are the user's.**

## Every deployment-class component is built and flagged OFF

| flag | what it arms | pinned by |
|---|---|---|
| `CUTOVER_POOL = false` | the plan's candidate pool reads the control cell | `[R89.1]` |
| `ITEM_OPS = false` | operator state reads the item store instead of the watch row | `[R93.1]` |
| `VOL5_UNIVERSE = false` | the 5m die-off streak counts universe-wide | `[R94.3]` |
| *(coverage gate, not a flag)* | chart wiring activates at 7 of 7 observed days | `[R94.1]` |

**Nothing changes what the plan proposes until those are ruled.** Each pin goes red on a
silent flip, forcing the accounting.

## What landed, by step

**A — the plan surface (§92, display-only).** Two groups never interleaved, as a *render*
grouping only; slot A persistence as a **pair** with the percentage only beside it; four
no-history states plus an era closure; the inert-restraint line said **once** over the
population as the archive's state; `#planSub` fixed at the source; `+pin`, **Plan & Pins**,
`gov-propose`'s property-not-mechanism fix (M156), family and caution context.
**Two corrections to my own design, both in the code:** the returning-item case does not
exist (the scorer observes the whole universe every cycle, so a window opens at first pass
and never closes — the one real return is a regime change), and the drill opens to what
exists while naming the T0 replay path for per-cycle rows.

**B — operator state re-keyed (§93).** One store, four fields migrating; scout provenance
dies with the scanner; `invTarget` stays reserved. **`bands`** records which tier-band world
an override was made in, in three states — and an override under different bands is
**withheld**, because declining to apply narrows. Migration **copies, does not move**;
originals stay until the admission machinery retires and `opsOf` is the single reader, so
nothing is ever read twice. Controls render on the item for pool rows only, and render
nothing while the flag is off.

**C — chart wiring (§94), corrected scope.** One universe-wide series feeds **four**
consumers — `tr`, `vt`, momentum, drift — because wiring only the two named gates would have
removed the mask over two vacuous restraints. Every reader is inert below 7 observed days,
asserted with a populated cache behind a not-ready gate. The 5m streak's universe feed and
`dieOffLog`'s bound and `pop` partition ride here.

**D — integration audit.** Six findings, all in this session's own build, all fixed: two
write-only eviction counters, a term rendered four times with no glossary entry, two
glossary entries nothing rendered, and E-F1/E-F2 below. **`rdiff` is no longer STAGED.**

**E — scan 14, first run ever.** 385 candidate labels of 1,181. **`[R4.3]`, its own founding
example, was already repaired** on Aug 13 — so it comes off the adversarial pass's list,
which is exactly why E was ordered before F. Two new findings, and **they were masking each
other**: `[R33.1]`'s sub-view loop missed `scorer`, and the cold-start fixture was not cold
for `scorerT2`/`poolSeen`/`itemOps`. Fixed, re-seeded, and the seed now bites naming
`trade/scorer`.

## Owed before or at the freeze

- **The deployment artifact — RESOLVED Aug 19 2026 as a TOOLING LIMITATION.** Six things
  tried, all recorded in `tools/probe/deploy.sh`'s header; the decisive one is that a
  MINIMAL page whose only content is the beacon POST also fails, while `run.sh` beacons
  every run — so the failure is the invocation, not the app. Headless Edge here executes
  reliably only under run.sh's flag set, which blocks the network on purpose.
  **Substitute: the three-step operator checklist in PROBE.md,** run on the real phone at
  CUTOVER (not per UI change). Rows that would cite a deployment artifact read
  **operator-verified**, not owed. The gap is closed.
- **369 of the 385 scan-14 candidates are unread.** The enumeration is the deliverable and
  the remainder is named.

## F — the adversarial pass, when the tree is frozen

Scope, with E's result folded in: **16 exact + 56 candidates**, minus `[R4.3]` (clean), plus
the named search pattern from the gate check — **every item-keyed cache populated by a
`DB.watch` loop, and every gate reading one.** Three were found by reading (`S.spark` via
`fillSparks`, `S.vol5Low` via `updateVol5Streaks`, and the `DB.qual` prune); the pass
confirms there is no fourth.

## Still pending, not blocked

rdiff classification (needs accrued verdicts) · the seasoning measurement (needs the prune
fix live plus days of pool observation) · chart-gate verdict validation (needs 7 of 7
coverage) · capture grading (needs the operator's calibration flips) · the T2 ceiling ruling
(evidence delivered in `audits/CEILING-2026-08-18-above-t2.md`).

---

# PRIOR PASS — 2026-08-18 (third pass: the frontload begins)

**Suite: `PROBE-PASS — 1,149 assertions, BOTH viewports, pairing clean both directions
(413 tags / 425 rows / 413 cited)`.** Baseline at the start of this pass was 1,121.
**28 new assertions, 28 discriminating seeds (S22–S46), one at a time, restore-green
between.** Tree **uncommitted**.

## Built and verified

| § | what | flag |
|---|---|---|
| **§87** | the `DB.qual` scoped retention fix, as ruled | live (no plan behaviour change) |
| **§89** | the pool switch | **`CUTOVER_POOL = false`, pinned** |
| **§90** | the ledger regime stamps — the cutover's one true prerequisite | live |
| **§91** | the three vacuous restraints, made honest | live |

**§87 — the prune scoped, not replaced.** Membership retention for `"watch"`, staleness
(30d, a **storage** bound and the comment says so) plus a pool-only capped belt for
`"pool"`; eviction flagged and warned because it costs an item its streak. `src` across
three regimes, **absent = predates the field**, stamped centrally in `planCandidates`,
carried through import in all three states with unrecognised values staying absent. The
grandfathered census renders only while that population is non-empty. **S22/S23 are the
discriminating pair:** restoring the unscoped prune reddens pool-survives; deleting the
prune reddens watch-dies. The tempting one-liner fails exactly one of them.

**§89 — the switch, off.** Both paths assert. `cutoverPoolRows` synthesises `{ id }` and
nothing else, so every operator overlay is absent, which is the truth about a pool item
rather than a gap to fill with defaults; a pinned item keeps its real row. **S33 flipped
the flag and turned three assertions red** — that is what "forces the accounting" means.

**§90 — the stamps.** `gateLogRow` is the single writer for all four push sites, stamping
the **candidate's own** `src`; `deployLog` stamps `poolRegime` (`watch` / `mixed`) and
**`n`, the candidate count `pass` is a count OF** — the readiness sweep's §2b finding fixed
at the source rather than at the label. `mixed` is deliberate: an hourly row genuinely
aggregates pins and pool items, so a per-candidate stamp there would be false precision.

**§91 — the three vacuous restraints.** `momentumState(pts, buy)` is now the one term both
callers route through (asserted as wiring, so a second interpreter cannot reappear
silently) and returns **`null`, not `"flat"`**, on too few points; `stabilityWeight` carries
**three states on `drifty`**; `volGateFor` reports **`streak: null` and says NOT COUNTED**
rather than claiming a counter that is not running.

> **Why the suite stayed green across §91 before its own assertions landed, stated rather
> than trusted** (the ratification-that-breaks-no-test rule): all three fixes change a value
> the GATE reads identically — unknown is not failing, `null && x` is falsy, and the
> volGate label differs only for an item the streak never counted. Every candidate today is
> a watch member, so the changed branches are reachable only through the pool, which is
> behind the flag. **The change was genuinely uncovered**, which is one of the three
> answers that rule permits; §91's assertions are that coverage and every one is seeded.

**And these are honesty fixes, not restraint fixes** — the requirement rows say so in those
words. Unknown is not failing, so nothing is newly benched. **The restraints return when
the chart wiring feeds them**, which is why its scope correction (below) matters.

## Ratified this pass, affecting work not yet started

- **Chart wiring scope corrected** — momentum and drift inputs from the T0 hourly series
  **alongside** `tr`/`vt`. Found because both read the per-item spark object while the spark
  cache is filled by a `DB.watch` loop, so the wiring as originally scoped would have
  **unmasked** two vacuous restraints rather than fixed them. `chartPts(id)` is the single
  line that build changes.
- **The plan surface gains a fourth requirement**: render which restraints are **INERT** on
  a given item, as an honest state in the same class as the four no-history states.
- **The adversarial pass gains a named scope item**: every item-keyed cache populated by a
  `DB.watch` loop, and every gate reading one. Three found by reading; the pass confirms
  there is no fourth.

## Reports delivered

`audits/SWEEP-2026-08-18-cutover-readiness.md` (prospective seam inventory: 7 BREAKS,
11 READS WRONG, 5 BECOMES MEANINGLESS) · `audits/GATES-2026-08-18-operator-layer.md`
(the operator-gate layer, per gate) · `audits/FIX-2026-08-18-qual-retention.md` ·
**M156** recorded — `gov-propose` naming the mechanism instead of the property, in the
tool's own statement of its constitutional rule, caught prospectively.

## Still to build, in the ruled order

**item 2** the plan surface (two groups · badge slots · four no-history states · the inert
restraints · the first-seen stamp · `#planSub` · the must-land-with copy) → **operator
re-key shape for ruling** → **chart wiring** (corrected scope) → **integration audit** →
**scan 14** → **freeze** → **adversarial pass**.

**Pending, not blocked** (cannot be frontloaded): rdiff classification (needs accrued
verdicts), the seasoning measurement (needs the prune fix live plus days of pool
observation), chart-gate verdict validation (needs coverage), capture grading (needs the
operator's flips).

---

# PRIOR PASS — 2026-08-18 (second pass: the cutover rulings acted on)

Rulings of 2026-08-18, items 1–5. **Suite: `PROBE-PASS — 1,121 assertions, BOTH viewports,
pairing clean both directions (399 tags / 411 rows / 399 cited)`.** 13 new assertions, **13
discriminating seeds (S9–S21), one at a time, restore-green between**; one seed (S17)
aborted on precondition 3 — it added a key without changing the relative order it claimed
to test — and was rebuilt as an actual move before any result was read. **Tree
uncommitted.**

### Item 1 — `DB.qual` prune: SHAPE REPORTED, nothing built

`audits/FIX-2026-08-18-qual-retention.md`. **The prune is not wrong, it is UNSCOPED.**
Membership retention is correct for a hand-curated list (departure is an explicit act with
a meaning); staleness retention is correct for a machine-fed pool (departure there is only
churn). Proposal keeps the membership prune for `"watch"` rows and adds staleness (30d, a
**storage** bound and labelled as one) plus a capped belt for `"pool"` rows. Retargeting
the membership test at the pool is rejected with its reason: an item absent from the pool
was not necessarily evaluated, so it would delete on non-evaluation as well as on failure.
Partition answer: `src` across **three** regimes — and the third, the Aug 10 grandfathering
that wrote `n:3` from no observation at all, has never been distinguishable from three real
passes. The import sanitizer must take `src` in the same commit or the third state starts
lying on restore. **Behaviour for today's book is bit-identical** under the scoped form;
the one difference the naive one-line fix would have introduced is named rather than
absorbed.

### Items 2 and 3 — recorded

The **fourth prerequisite (chart gates 7/7)** and the **ruled gate order** are in CLAUDE.md's
scorer conformance gate and in the waiting posture at the top of this file, with the
reasoning, not just the list.

### Item 4 — the rdiff READER: BUILT (§86, R86.1–R86.6)

- **`t0All(store, lo, hi, cap)`** — a values reader whose cap takes the **NEWEST** rows.
  Keys are read first and the bound derived from them, because `getAll(range, count)`
  returns the FIRST count in key order. **Seed S20 reproduced the t1 defect exactly and the
  assertion caught it**, which is the closest thing to a proof that the §5.1 finding was
  real. *(The t1 call site is NOT changed — that finding is still awaiting its own ruling.)*
- **`rdiffCoverage`** — the gap reconciled in **five** states: complete / explained (the
  pre-diff window covers it) / partly explained (**with the remainder named**: accrual is
  fire-and-forget while `r.cycles++` is synchronous) / not comparable (the cell is younger
  than the diff — a closed population, so differencing is the pooling error) / cannot check.
- **`rdiffPlanStates`** — the three states lead, tallied **by the writer's own words**
  rather than parsed, and the missing side's denominator counts observed rows only.
- **`rdiffRuns` + `rdiffClassOf`** — the **third class shipped**. Persistence is measured in
  adjacent *observed* buckets; a run whose adjacency spans an unobserved bucket is
  `cannot say`, never persistence. **`timing` exists on the missing side only** and its
  absence from `extra` is asserted, not merely omitted.
- **`analysisRdiff`** → `analysis-rdiff-*.json`, in the ruled order, rows riding with every
  rollup, truncation stating its real window; collector class registered in `sweep.sh` and
  the CLAUDE.md table. Surface section on Trade → Scorer with the same order and the same
  three unread states. Two glossary entries shipped in the same commit.

**What the reader cannot do from here, stated rather than faked:** produce the 7-row gap's
verdict. That read needs `DB.scorerT2[control].firstAt` and the ledger itself, both of which
live in the browser. **The machinery computes and renders the verdict; the first app open
produces it.** Seeded tests prove the code; one real read proves the answer.

**`rdiff` is a CONSUMED store from this commit** — scan 2 stops re-reporting it as staged.

### Item 5 — plan surface: APPROVED, not yet built

Approved as designed, display-only. Blocked behind item 1 by its own logic: the two ordered
groups and the badge describe a pool that cannot season until the prune fix is ruled.

### Found while building

**The §86 fixture cleaned at block end but not at block start** — and seeding the cleanup
assertion (S21) left two rows behind, which turned the capped-read assertion red on the
next clean run with a total of 6 for a fixture of 4. Hardened to clean at both ends and the
requirement row records how it was found. An end-only clean is not a clean.

---

# PRIOR PASS — 2026-08-18 (sixth session: the four-day grid reading, three closures, the plan-surface design)

**Two reports and one build.** `audits/READING-2026-08-18-scorer-grid.md` answers the
four-part ruling of 2026-08-18; `audits/DESIGN-2026-08-18-post-cutover-plan.md` proposes the
post-cutover plan surface ahead of the cutover ruling. **No constant moved.**

**Suite:** `PROBE-PASS — 1,108 assertions, BOTH viewports, pairing clean both directions
(393 tags / 405 rows / 393 cited)`. Baseline was 1,100. **8 new assertions, 8 discriminating
seeds (S1–S8), one at a time, restore-green between**; three of them aborted once on
precondition 1 (the driver refused a substitution that had not applied) and the pattern was
corrected before any result was read.

**Tree is UNCOMMITTED — the user commits.**

### Shipped (§85 — the one build)

`scorerClosuresLog()` writes three `DB.decisionLog` rows, once per store, **guarded per
subject** so a half-written store completes, each `auto: 1, by: "user"`:

1. **taxMult loosening — CLOSED, monotone worse.** The ordering holds at 18 of 18 econ keys.
   The blacklist canary rises monotonically with the loosening (290 → 379 would-fund
   item-cycles at b1000), a second reading independent of the money.
2. **ROI 1.2 → 1.0 at m0.5/b250 — CLOSED, last by proven net at 18 of 18 keys.** +30 distinct
   items for −237.4m at `h6|p50|c15`. Retroactively vindicates the ROI-loosening bench.
3. **Volume base 1000 → 50 — STAYS DENIED**, and the entry says this reading supersedes
   nothing: 50 is outside the tested axis and no cell speaks to it.

Three extracted terms carry the standing "every cited aggregate ships the three" rule —
`scorerCountPair` (a distinct-item count beside every trip count, no way to write one
without the other), `scorerConcNote` (concentration, with its NOT-DERIVABLE state as a
disclosure rather than an omission), `scorerCitedCaveat` (the capture-grading status).
`[R85.3]` asserts all three over **every** entry the writer produces, not one sampled string.
**The general machinery — a proposal surface that REFUSES to render without the three — is
NOT built and the requirement row says so.**

### Readings that need carrying forward

- **taxMult is monotone at 18 of 18 econ keys**, stronger than stated. **Volume base is
  stable at h6 (all nine keys) and unstable at h9.5** — narrower than stated, and the split
  is what forces the axis-stability verdict to be per (axis × horizon) rather than per axis.
- **The b500 marginal population decomposes exactly** (containment verified, 195 of 195):
  it is 37–39% of b500's trips, **2.7–11.7% of its gross movement**, fills *more* often
  (10.4–19.1% vs 6.7–12.5%) and is net-**negative** at the proven bound in 15 of 18 keys.
  The cell total looks near-control because the shared population dominates it.
- **Only 34% of the control cell's trip-observed items (13 of 38) are reachable by the
  allocator** — 55% under the 400gp minimum, 11% above the T2 ceiling. Extrapolated to the
  measured flow that is ~3.1 fundable of 9.09 funded per cycle; the base is 38 items, not
  the 292-item stock, because the export carries no id roster.

### Proposed, awaiting ruling

- **Axis-stability verdict** — three states, per (axis × horizon), four assertions, the
  fourth forbidding the contradicting claim. Wording drafted verbatim.
- **m4/m5 at volBase {1000, 500}** — **frontier growth is exactly zero** (the margin need is
  monotone in taxMult, so tighter cells are subsets), fill-sim load zero, +25% scoring,
  ≤ 27 KB. **The real cost is the breadth denominator moving 16 → 20**; recommendation is to
  stamp it before growing the grid, as one ruling rather than two.
- **A probation lane of five marginal items**, chosen to SPAN thinness (21/h to 1000/h) and
  margin headroom (1.6× to 3.5×) rather than to be the five best — Dwarf weed seed,
  Bananas(5), Warrior ring, Black d'hide chaps, Quetzal feed. Half size, separable stamp,
  criteria before the trades. Opens at cutover; no constant moves.
- **The whole plan-surface design**, display-only by construction so it can be ruled ahead
  of the deployment gate.

### Findings raised, none repaired

- **The scorer export carries the OLDEST 500 trip rows, not the newest** —
  `getAll(lowerBound, count)` returns the first N in key order. In this file that is 3.67 h
  of a 168 h window (2.2%), of which **97.6% of lifecycles are `unobserved` holes**. The
  truncation note declares a cap and not a selection rule. Scan 5 and scan 7 finding.
- **A 7-row gap between the scorer's 1,024 cycles and rdiff's 1,017 rows**, unexplained.
- **`sc-breadth`'s glossary `aka` hardcodes "16"** — a live copy defect the moment the grid
  grows.
- **`DB.qual` prunes to watchlist membership** — a one-line cutover blocker on the money
  path (design §1.1a).

---

# PRIOR SESSION — 2026-08-14 (fifth session: transitional nav + friction export + item visibility)

**Third pass (same day, ruled): SCORER ITEM VISIBILITY** — the surface names what the
instrument sees (report part 3, §13–§17). Suite at final close: **PROBE-PASS — 1,100
assertions, BOTH viewports, pairing clean, 390 requirement ids; 34 discriminating
seeds this session (S1–S34), all bit, one at a time.** Deployment: **DEPLOY-CHECK3
clean** — first real bucket at 0.5s, the control funding **8 named items** (Armadyl
chaps, 20k margin), the frontier browser **129 named items** (Amethyst dart(p+) at
16-of-16 breadth), 87 delta memberships across 7 notch pairs with the cannot-rank
words standing where nets would render, 8 named rdiff disagreements.

- Four sections under the verdict (all closed disclosures, counts on labels,
  label-reconciles-to-rows asserted both directions): the **control cell's funded
  set** (named, sorted by stated figure, full gate detail per item), the **frontier
  browser** (`sc-breadth` — bl items only ever the canary line, pump ⚑ inline), the
  **delta memberships** (`sc-delta` — membership now, economics behind the readiness
  verdict), and the **rdiff named-disagreements window** (informational; rdiff stays
  STAGED for the cutover gate).
- **`marketGateEval` is the one gate evaluator; `marketGateFails` derives from it**
  (§84.6) — behavior-identical, §74 still pins the chain, the ROI null limb still
  fails, momentum fails still carry `have:null`.
- Display readouts only; no persisted store added; session per-item history is S.*
  and labelled "this session"; **no item actions anywhere** (button census asserted —
  viewing is not proposing; admission is the cutover's).

**Uncommitted — the user commits after the phone look, which now includes trying the
✎ friction capture-and-export cold.** Record:
`audits/NAV-2026-08-14-transitional-chrome.md` (both passes). Suite at close:
**PROBE-PASS — 1,087 assertions, BOTH viewports, pairing clean both directions, 384
requirement ids; 24 discriminating seeds (S1–S24), all bit, one at a time,
restore-green between.** Deployments: **DEPLOY-OK at 0.5s** (chrome — 145-item
frontier on the tile at the first real bucket) and **DEPLOY-CHECK2 clean** (a phone
boot logging a friction note through the real UI and exporting it, cold).

**Second pass (same day, both §3 proposals RATIFIED as recommended):**

- **Prospecting: leave until cutover — decision-logged** (`prospectHoldLog`, once per
  store, `auto:1, by:"user"`) so the cutover consolidation inherits a DECIDED item
  (`[R82.3]`).
- **Paper Book era qualifier applied: header, not tab** — `#paperRegimeSub` ends
  "· the cutover's plumb line", glossed from the new `plumb-line` entry which covers
  BOTH referents the phrase already had (paper book + rdiff) as one concept; the
  scorer verdict's occurrence marks from the same entry (`[R82.4]`).
- **The friction export shipped** (§83) — the missing leg of the Aug 10–11 loop:
  `analysis-friction-<date>-<hhmmss>.json` on the existing analysis bus, read-only
  builder, carry stamp (`exp`, the same field the markdown copy uses) rides the press,
  never deletes; chips inside the global ✎ disclosure and in the weekly friction step.
  **ACCUMULATING collector class** (`sweep_accum` in sweep.sh — disjoint contents,
  keep-newest would destroy carried notes); **desk folds collected files into
  FRICTION.md dated from capture timestamps** (standing instruction in CLAUDE.md).
  Live defect fixed on the way: the import sanitizer dropped `exp`/`res`, reviving
  carried notes on restore (`[R83.4]`). `frictionLog`'s partition-register row added
  to the conformance map.
- **The 390px overflow SCOPED, not built — and the pass is PRE-APPROVED as scoped,
  conditional on the phone look** (report §11; trigger recorded in the waiting
  posture at the top of this file): clipping on the real phone → build it as scoped,
  no further ruling; ~518-like rendering → skip and close as device-dependent,
  not-reproduced-on-target-hardware.

- **Header tiles are FUNNEL · SCORER · SLEEVE · CAPITAL** — the Paper Book tile yielded
  its slot; its open · closed read moved to the paper surface header (`[R65.1]` dormant
  form). The scorer tile renders `scorerTileLine()`, its one source term (`[R82.2]`,
  five seeded states); the funnel tooltip's stale first-fail claim was corrected.
- **Trade sub-tab row**: Plan & Watchlist · Flip Log · Scorer · Paper Book · Gate
  Health · Scanner · Prospecting, with `.sunset` subduing exactly the two cutover-era
  retirement candidates (`[R82.1]`, computed-opacity both states).
- **`paperDivLead` has no production caller in any era now** — the gated `[R65.1]` live
  branch is an un-retire tripwire: a deliberate red forcing the un-retire ruling to name
  the divergence lead's render home.
- **Two proposals AWAITING RULING** (report §3, nothing applied): Prospecting's
  disposition (recommend: leave until cutover) and the Paper Book era qualifier
  (recommend: header sub gains "· the cutover's plumb line"; tab label unchanged).
- **FRICTION.md queue was empty**; the two `_pending_` hashes resolved to `b9c8add`.
- **Observation, pre-existing (baseline-verified):** at TRUE 390 CSS px
  (`--force-device-scale-factor=1`) the page overflows horizontally; the ruled phone
  runs render at ~518 CSS px where the layout fits. Not introduced here; a fix would be
  its own display pass, if the real-phone look warrants one.

# PRIOR SESSION — 2026-08-14 (fourth session: the two retirements + the sleeve landing)

**Committed and pushed in `f0bf448`** — the record is
`audits/RETIRE-2026-08-14-dormancy.md`. Suite at close: **PROBE-PASS — 1,061
assertions, BOTH viewports, pairing clean both directions, 376 requirement ids; 15
discriminating seeds this session (S1–S15), all bit, one at a time, restore-green
between.** Deployment: **DEPLOY-OK at 1.0s on a phone-viewport real-network
fresh-profile boot** — both retirement decision-log entries landed on first poll
(`auto: 1, by: "user"`), the frozen divergence ledger took no row, only the gap band
accrued, and every real trip opened under the dormant race carries no `regimes` key.

## THE RETIREMENTS ARE DONE (dormancy lane, ruled at the 1e close, built this session)

- **Regime race dormant** (`REGIME_RACE_RETIRED` pinned, `[R81.1]`): stamping, the
  daily snapshot and divergence evidence/proposals stopped; historical curves, bands
  and ledger render under the dormant banner; freshness reads DORMANT; export stamps
  the era. Era fact: dormant-era trips carry NO `regimes` key (absent ≠ `[]`), carry
  and export preserve it.
- **Slice sampling role dormant** (`SLICE_SAMPLING_RETIRED` pinned, `[R81.2]`): the
  stratified draw/rotation and stratum-ledger accrual stopped; the map is the frozen
  historical ledger. **THE GAP BAND STAYS LIVE** at exactly its ruled
  `floor(SLICE_SHADOW_CAP/2)` share — scope call recorded in the stage report §1: the
  clean-count register is paper-book-wide plumbing (two consumers), the band serves the
  held T3 proposal and the routing question, so triage finding 3500 stays conditional.
- **6 of the 17 EXPIRE-AT-RETIREMENT findings expired** (2481, 5574, 2575, 6127,
  7300, 7317 — expiry record in the triage file); the other 11 wait on cutover-era
  retirements. IMPROVEMENTS 6.7 closed as mooted. Legacy assertions are dormant-gated,
  never deleted (`[R81.4]`) — the un-retire re-arms them by flipping one constant.
- **Sleeve-form landing fixed** (R24.4, seeded): `[data-slvedit]` now lands through
  `navLand`, the one implementation.

# PRIOR SESSION — 2026-08-14 (third session: stage 1e + two directives)

Stage 1d is committed and pushed (`c3fc572`); stage 1e plus the log-flip landing fix
and the mm bench went out in `8bf841e`. Suite state at that close: **PROBE-PASS — 1,073
assertions, BOTH viewports (1200×900 and 390×844), pairing clean both directions; 17
further seeds that session (12 §80, 4 §79, 1 R24.3), all bit, one at a time.**
Deployment: **DEPLOY-OK at 1.0s on a phone-viewport real boot — 744 trips (124 frontier
× 3 × 2, h6/h9.5 split 372/372) — with the Scorer's first screen captured as the
walk-up-test artifact** (stage report §3; it reads as the dictated
sentence-plus-four-lines, and it caught two live copy defects that were fixed and
re-greened).

## STAGE 1e IS DONE — `audits/STAGE1E-2026-08-14-scorer-surface.md` is the record

Trade → Scorer (seventh sub-view, pull-surface class): verdict-first first screen
(question → one sentence → accruing / chart-gates-N-of-7-observed / cannot-rank-yet in
the ruled words / rdiff-day-N), the always-rendering state line, the grid (pooled
average WITH extremes inline + all 24 bands opening, flow + stock, six-gate share, the
canary), econ per (horizon × participation) in structural `[data-hz]` containers with
per-capture-lifecycle figures, concentration on GROSS, the three econ states named,
trips drills with declared truncation; the `analysis-scorer` export (collector class
registered, CLAUDE.md table updated); nine glossary entries same-commit, marked
inline; the weekly review one-liner. **Staged stores:** econ + t1 rows consumed (off
scan 2's re-report list); **rdiff still staged for the cutover gate** (map §2b — the
verdict line's day-count read is informational). Era-fact tripwire still armed (chart
wiring not landed; six-gate 100% renders and stamps).

## ALSO IN THIS TREE (mid-turn directives, both done)

- **Log-flip landing fixed** (report §7): the press performed no landing at all —
  bare focus-scroll, keyboard/geometry-dependent, never chrome-offset. Now lands on
  the form through the one landing implementation (`navLand`, extracted from navGoto
  unchanged), both focuses preventScroll. `[R24.3]` seeded; real-press artifact on the
  phone viewport shows the form title landing 10px below the chrome. Same-class site
  LISTED, not fixed: the sleeve form's unpadded `scrollIntoView` (#slvFormPanel).
  FRICTION.md had no entry to close.
- **MM mode benched** (report §8): disabled until the scorer stands, not deleted.
  Measurement honest: **cannot attribute** (no mm stamp on flips, no invTarget
  history) — the bench rests on attention cost and the decision log records exactly
  that plus the in-flight snapshot, computed in the user's browser at the benched
  build's first poll. Nothing strands: standing legs resolve, lots sell down (MM
  UNWIND lines), panel states the bench; plan reverts per item as its unwind
  completes. `MM_BENCHED` pinned — the un-bench flips only by ruling (`[R79.1]`, seed
  S1 turned five assertions red). Per-item state persists for the cutover re-key.

## STAGE 1d IS DONE — `audits/STAGE1D-2026-08-14-fill-sim.md` is the record

Built: the fill sim on the frontier (trips per item × participation at the ruled 6h
horizon, shared across cells by birth-stamped membership; three capture LIFECYCLES per
trip — 0.05/0.15/0.30 each run their own legs because capture moves the sell window);
the pure shared core (`fillCredit` with capture/participation as arguments,
`obsAccrual`, `sellBucketEligible`, `sellWindowStart` — both the paper book and the trip
layer route through them); IDB v3 (`t1` closed-trip ledger, 30d, roll-then-prune;
`t1open` boot carry — held-never-dropped at boot, the M154 property seeded in from
birth); econ rollups under four-stamp keys (`h6|p50|c15|fv1` — pooling structurally
impossible); the bl no-trip guarantee (discriminating seed pair vs the canary; mid-trip
blacklisting VOIDS as `vbl`); pump stamps at birth, decomposed, never excluded; the
capture-probe verdict terms (`scorerCaptureVerdict` / `scorerRankGate` /
`scorerCellEconState` — "insufficient calibration to rank" IS the verdict; full fail
sets; concentration ceiling is an ARGUMENT, unruled). All 23 TRANSFER findings
dispositioned with proofs, the 3 in-scope SPLIT halves landed (4447/5908 restated as 1e
obligations). Scan 11 at the boundary: 20 points, 0 findings. M155 recorded (the R47.5
caveat lived in a footnote behind a green whole-panel assertion; live-caught by the
scoped repair, fixed inline).

## THE §6 RULINGS — RULED AND APPLIED SAME DAY (stage report §9)

1. **Horizon set {6h, 9.5h} RATIFIED, participation {25, 50, 100%} confirmed** — built:
   trips per (item × participation × horizon), horizon in the trip key and the econ key;
   the overnight comparison is a stamped population against a stamped population.
   `[R78.16]` demonstrates the set (same tape, 6h closed while 9.5h accrues).
2. **Concentration ceiling RATIFIED at 0.5, measured on GROSS movement** — econ carries
   `gross` (Σ|net|) and `top` (max |net| mover); the rank gate disqualifies at
   top/gross > 0.5, measurable on losing cells, rank-disqualifier only. Seed AG proved
   the ruled and pre-ruling measurements genuinely disagree.
3. **Capture status RATIFIED as the rendered verdict** — `scorerRankReadiness()` says
   **"cannot rank yet"** in the ruled words wherever a ranking would render;
   `SCORER_CAPTURE_GRADED = false` is the pinned era fact (`[R78.17]`) so grading cannot
   arrive without a ruling; the dependency stays named (calibration flips inside the
   tape window). b=100 stays deferred on exactly this.
4. **The three-lifecycle probe design recorded** in the design doc §9 with its causal
   reason, so 1e renders per-lifecycle figures without re-deriving it.
   The rulings are decision-logged in the tool (`auto: 1, by: "user"`, asserted).

## WHAT 1e'S CLOSE UNLOCKS, AND WHAT STILL WAITS

- ~~**The retirements HELD "until the scorer's first readable output" are now
  unlockable**~~ — **DONE, fourth session of Aug 14 2026** (the block at the top of
  this file; `audits/RETIRE-2026-08-14-dormancy.md`). Ruled, built in the dormancy
  lane, seeded, deployed; 6 of the 17 triage findings expired with their surfaces.
- **1e residual obligations, small:** the 4447/5908 SPLIT halves were restated for 1e
  and remain open — excluded counts opening to their trips on the SCORER surface
  (partially covered by the econ exclusions rendering; the drill-through for excluded
  trips specifically is not built), and the 100%-rate zero-counterexample claim
  belongs to whatever surface first renders a fill RATE (none does yet — econ renders
  censuses, not rates). Carry both into the next surface work.
- **b=100 deferred** until capture calibration (ruled; restated in the export).
- **Chart wiring** still pending; the era tripwire forces its stanza when it lands. **Chart wiring still pending** ("here or later" — later): the
pinned era fact `marketStatsFor().tr === null` in `[R76.9]` stays armed; when the wiring
lands, `fundedNoChart` (cells) and `ncN` (econ) decompose the transition and the stanza
accounts for it.

**First thing on next app-open (user-profile self-check):** the freshness panel now has
FOUR scorer-class streams — market archive, universe scorer, reconciliation diff, **fill
sim (frontier trips)** — all should show a first bucket within one poll.

**Then:** the cutover gate behind reconciliation history (the `rdiff` ledger should be
the longest-observed number in the instrument by cutover day — heaviest gate:
verdict-level reconciliation, integration-audit walk, adversarial pass on
cutover-critical assertions, `[R7.3]` standard); ~~retirements HELD~~ **retirements
DONE (fourth session, dormancy lane — top of this file)**; **sleeve addendum
stages after capture calibration**, conformance gate applying identically,
conviction-boundary detector with the first planner surface.

## THE UNIVERSE SCORER — build ruled Aug 14 2026, staged

Design ratified as plan of record: `audits/DESIGN-2026-08-14-universe-scoring.md`, with
the six rulings recorded there and below. Stage status:

| stage | status | where |
|---|---|---|
| 0 — frontier re-measured under the instrument's own gates | **DONE** | `audits/STAGE0-2026-08-14-frontier.md` — the frontier CHURNS (109/89 at two times of day, intersection 27, union 171); concurrent sim load ~90–110/participation level; sizing gate added zero; thinness confirmed (median 43/h) |
| 1a — pure gate core `(stats, config) → fails` | **DONE** | `marketGateFails` / `marginNeedCfg` / `volFloorCfg` / `liveMarketConfig` / `marketStatsFor` in `index.html`; the live chain routes through the core; §74 (R74.1–R74.5b), six discriminating seeds; operator leaks excluded one by one |
| 1b — T0 archive accrual | **DONE, and the 7-day clock is RUNNING once the app is next opened** | `t0*` in `index.html`, riding `loadHour`; IndexedDB `geflips-t0` (m5 72h / h1 8d retention); coverage = keys-present as a pair; failure surfaced on `warn()`; §75 (R75.1–R75.5b), six seeds incl. the wiring; **CLAUDE.md carries the named localStorage exception in the same tree** |
| 1c — scoring + T2 rollups | **DONE** | §76 (R76.1–R76.7), seven discriminating seeds. The core emits **config-free keys** (`MARKET_GATE_KEYS`; display names are persisted ledger keys in `MARKET_GATE_LABEL` and do not move — the "3×" stands only in the live chain's own label, whose taxMult IS 3; the copy sweep derived every other rendered instance from `GATE.taxMult`/`effRoiFloorPct()`). 16-cell grid + live control deduped by hash; **one pass per 5m bucket**; per-cell flow (`cycles`/`fundedItemCycles`) and stock (`ids`/`distinct`, capped at `SCORER_ID_CAP=3000` sized from the union flow) first-class; 24 UTC hour-bands keyed to the BUCKET's hour; `DB.scorerT2` with an explicit `validateImport` carry that **re-derives the hash from the sanitized config**; failure surfaced via `scorerFailNote` |
| **conformance gate** — standing, every stage from 1d | **IN FORCE, mapping RATIFIED** | `audits/CONFORMANCE-2026-08-14-scorer-map.md`: 23 rows — row 12's widening ratified WITH the scan-2 re-report addition; row 15 pre-ruled (stamp, don't exclude); **row 23 added** (the blacklist canary, amended form); partition register ratified including the deliberate non-answer on ids stock; pinned-era-fact ratified as standing practice. Stages check deltas; stanza per report |
| **row 23 + flag 3** (consolidated rulings) | **DONE, seeded, deployed** | The canary pair `blFunded`/`blIds` (`[R76.10]`/`[R76.10b]` — discriminating seeds both directions, B proven on the crashed run's own 09:06 report); the reconciliation diff in IDB `rdiff` (DB v2, 90d, `[R77.1–3]`); the boot race found by the deployment check and fixed (`[R76.11]`, **M154**); **DEPLOY-OK — first bucket archived, scored and diffed 2s after boot on the real API** |
| **fill-tier triage** (mid-session order) | **DONE** | `audits/TRIAGE-2026-08-14-fill-tier.md`: the census's 45 fill-tier findings (the surviving superset of the 32-CONFIRMED roster, which died with the syntheses — M149): **23 TRANSFER** (fold into 1d), **17 EXPIRE-AT-RETIREMENT** (reason per finding; unfixed by design until the retirement ruling), **5 SPLIT** (property re-lands in 1d/1e, assertion dies with its surface) |
| 1d — fill sim on the frontier + capture probe | **DONE** | `audits/STAGE1D-2026-08-14-fill-sim.md` — §78 (R78.1–R78.15), 26 discriminating seeds + 1 live catch (M155); trip layer + pure shared core + IDB v3 (`t1`/`t1open`) + four-stamp econ keys + verdict terms; 23 TRANSFERs dispositioned; scan 11 clean (20 points); DEPLOY-OK at 1s (804 trips on the first real bucket post-rulings); **the §6 rulings ruled and applied same day** (report §9: horizon set {6, 9.5}, gross-movement ceiling 0.5, cannot-rank-yet readiness pinned, three-lifecycle rationale recorded) |
| 1e — surfaces + exports, drill-decomposable | **DONE** | `audits/STAGE1E-2026-08-14-scorer-surface.md` — §80 (R80.1–R80.11), 12 discriminating seeds; Trade → Scorer with the verdict-first first screen (the walk-up test's artifact captured on a phone-viewport real boot), the state line, horizon-grouped per-lifecycle econ on gross concentration, drills with declared truncation, the `analysis-scorer` export + collector class, nine same-commit glossary entries, the weekly one-liner; econ + t1 consumed off the staged list, **rdiff still staged for cutover**; the R38.6 scan and the deployment artifact each caught a live copy defect, both fixed and re-greened |

**The clock's fine print:** T0 accrues only while the app is open. The 7-day chart-gate
cold start counts OBSERVED coverage, not wall days — `t0Coverage` reports the pair, and a
closed browser is an unobserved gap from the moment it starts (warn fires only on accrual
*failures*, not on absence — absence is the observed-time rule's territory).

**Standing sub-rulings:** first-fail never enters the instrument's schema (full fail sets
from birth); retirements (regime race, discovery slice's sampling role) ~~HELD~~ **DONE
Aug 14 2026, fourth session — dormancy lane** (top of this file); minExpect at read
time, never a dimension.

## Ruled and NOT yet done (pre-scorer queue — nothing here jumps ahead)

| # | Item | Why it waits |
|---|---|---|
| 1 | **The fill-tier findings — TRIAGED 2026-08-14**, dispositions in `audits/TRIAGE-2026-08-14-fill-tier.md`. The two-agent 32-CONFIRMED roster is not re-derivable (died with the syntheses, M149); the triage covers the census's 45-finding superset: 23 TRANSFER → folded into 1d's scope, 17 EXPIRE-AT-RETIREMENT with reasons recorded, 5 SPLIT (property re-lands, assertion expires with its surface) | dispositions applied; transfers ride 1d |
| 2 | **The 82 gates/other findings** — SINGLE-AGENT, no adversarial pass ever ran (11 verifiers died at a session limit). **Ruled: no fixes off them, counted separately in every report, never folded in with verified findings** | needs its own adversarial pass first |
| 3 | **Scan 14's first run** (label-claim scan, written into CLAUDE.md) — never executed | new |
| 4 | **The production-anchor schema change** — every future census carries a `codeQuote` for production citations, not just probe ones | applies to the next census, not retroactively |
| 5–8 | **CLOSED 2026-08-13** — see the section below. Numbers retained, never reused | — |
| 9 | **THE 12 REMAINING AFFECTED SURFACES ARE MARKED, NOT REPAIRED** (user ruling, Aug 13 2026). Each declares itself *headline gate, not binding gate*; the surfaces reading the full fail set deliberately carry no mark, and `[R73.6]` asserts that absence because a mark on everything distinguishes nothing. **The 13th — the deployment funnel — was repaired on 2026-08-13** and is done: leave-one-out leads, first-fail is demoted and labelled, the ⚑ flag is gone (`[R73.10]`). The repair-or-retire decision for the other twelve is **still open**; the appendix to `audits/SURFACE-2026-08-13-gate-interaction.md` costs the options | open, deliberately |
| 10 | **FULL-FAIL-SET LEDGER RECORDING — HELD** (user ruling, Aug 13 2026). `DB.gateLog` would write one row per failing gate instead of `fails[0]`: ~4 lines at `index.html`'s writer, **~3.5× the rows** (648 → ~2,300 over four observed days, order of 20k at 30-day retention), and a **migration partition** — pre-change rows are headline-only and must be reported as their own population until they age out, never merged. **Held because the causal number turned out to be available without it:** the funnel's leave-one-out ranking ships today from `failProfile()`, so this buys *historical* attribution rather than *current*, and a migration is not worth that alone. **What would revive it:** a question that needs per-gate history — most likely the persistence bar, which still promotes proposals on headline day-counts, or a retrospective asking what was binding last month rather than now | held, logged |

## Rows 5–8 — CLOSED 2026-08-13 by user ruling

Rows 5 and 6 are **dead, not benched**; rows 7 and 8 are **measured and acted on**. Kept
here as a record of what was closed and why, so neither is re-proposed without meeting the
arithmetic that killed it. Both closures are written to the in-tool decision log
(`ROI_EXP_CLOSED_KEY`, `PAPER_POP_CLOSED_KEY`, once per store, not stamped `auto`).

- **Row 5 — the ROI-floor loosening experiment: DEAD.** Loosening `GATE.roi` 1.2% → 1.0%
  admits **0 of the 41 live band items**, because the margin gate's tax limb enforces an
  effective 6.52% floor. **The gate choice it rested on is struck**: the "74% of all sole
  blocks" figure is 0% by construction. Neither constant moved.
- **Row 6 — the paper-book population fix: DEAD, same reason.** The `loose \ current` band
  cannot be fed while the entry condition is `pass || nearMiss` and every band item carries
  two failures. **The reserved-scanner-slot carve-out stays recorded as sound but moot** —
  the right protection for a change no longer worth making.
- **Row 7 — the margin/ROI entanglement: MEASURED.** `audits/SURFACE-2026-08-13-gate-interaction.md`.
  The queue's arithmetic was right and understated: the domination is not "above ~250gp",
  it is total, because below 250 the tick limb takes over from the tax limb with no gap.
- **Row 8 — the gate ledger records `fails[0]` only: CONFIRMED and now law.** BINDING in
  CLAUDE.md, detector scan 16, incidents M150–M151.

## For the NEXT session

**Nothing is queued from the gate-surface work except row 9's open decision.** The
measurement is complete, the rulings are applied, the suite is green at 306 requirement
ids, and §9 of the surface audit lists three adjacent findings that were deliberately not
pursued (the `strataCount` residual-bucket label, the marginal-gate attribution's three
buckets not summing to their population, and the tax-cap regime above a 250m sale price).

## Done this session, so it does NOT belong in the queue

The gate-ledger `v` field and its three round-trip states; the regime-race pairing fix
(named bands, `loose \ current` computed at last) and `shadowRegimeEvidence`'s tie-vs-
never-fed split; the paper-trip carry (21 dropped fields restored, `pend` deliberately
dropped); the `fillModelV` pooling note; the falsy-zero fixes (`f.bh` skip reason, both
`spreadPct` erasures, the band selector); the pump-guard extraction `[R70.x]`; the intel
sacred-set coverage `[R71.x]`; the horizon-term split `[R72.x]`; `probe:116`'s rename;
scan 14 written; the clamp rule's binding-vs-present qualification; MISTAKES M147–M149.

## Standing facts worth not rediscovering

- **`planCap` has zero direct probe coverage** (M147) and is the clamp scan 9 names first.
  It defeated `shadowHorizonUnits`, `probe:111`'s seed and `probe:116`'s label.
- **The first 622 probe lines run on `DB.touchWindows = []`**, a constant 4h fallback, so
  allocator sizing, quote participation caps and die-off voiding are never asserted against
  the product's default four-window schedule (M148).
- **A cached workflow replay is not free** — resuming a 51-agent run cost 13 agents and
  killed both syntheses (M149).
- **Freeze the tree during any background analysis**, and prove it by content hash at both
  ends of every agent's work. The method is recorded and it worked: 9 agents, one
  fingerprint at start and one at end.

---

# HANDOFF — 2026-08-12

State that lives only in a conversation and would be lost with it. Everything
else is in [CLAUDE.md](CLAUDE.md) (rulings and case law),
[REQUIREMENTS.md](REQUIREMENTS.md) (ruled requirements, `[R#]`-tagged to probe
assertions), [IMPROVEMENTS.md](IMPROVEMENTS.md), [FRICTION.md](FRICTION.md) and
`audits/`.

Written at commit `f1a8de3`, after a build session covering the Jul 24 volume
artifact, the paper-book defect fixes, the fill model's causality and
reachability rules, the calibration harness, and a constitutional scope audit.

---

## 1. Open questions, and what would settle each

### 1a. Is "1 of 43 trips filled" a market finding or a model artifact?

**Where it stands.** Re-run at both reachability bounds after the causality and
partial-outcome fixes:

| | filled | forced-exit | partial | never |
|---|---|---|---|---|
| proven (lower) | 1 | 8 | 21 | 13 |
| possible (upper) | 1 | 9 | 21 | 12 |

Only **2 of 43** differ between the bounds, so this is *not* a
strict-comparison artifact — unlike calibration, where the comparison price is
the trader's own realized fill and self-comparison depresses the lower bound
hard. The paper book compares against a simulated bid that never traded, so
there is no self-comparison to correct for. The two constructs are distinct and
must not be read against each other.

**What would settle it.** The sell-leg calibration (§2). Nine of the ten
failures are on the sell leg; if the model says never-sold for sells that
really completed in minutes, the 1-of-43 means nothing.

### 1b. Does the ~1.3× optimistic lean survive as a correctable constant?

**Answered, negatively — do not go looking for it.** The 1.32× came from an
oracle variant that divided by *in-window* flow, which is future information.
With the shipped input (reaching flow, median of six hours) the median
observed/predicted is **0.70×**, i.e. slightly pessimistic, and with the mean
variant 0.78×. There is no stable offset worth correcting; **the residual is
spread, not bias.**

### 1c. The fill-horizon band treatment

**Deferred by ruling until the corrected input is regraded on fresh data.** But
one finding already constrains the design, and it inverts the priority:

> All three input variants false-bench **the same 4 of 10** completed trips.

Fixing the input shrank the error magnitude enormously (Varrock teleport
tablets: predicted 49.8h → 2.0h) without removing a single false bench, because
all four are near-misses against the horizon — predicted 1.5–2.4h, horizons
1–1.77h, actually filled in 0.66–1.5h. **The band is not polish; it is the part
that fixes the harm.** The evidence supports an optimistic end at roughly
`predicted × 0.33`.

**What would settle the width.** A regrade of the corrected input on a sample
that is not the corrupted epoch — so, after the reset.

### 1d. Capture (0.15) is ungraded, not validated

It cannot be tested against paper trips: those fills were generated using it,
so measuring it there is circular. Stated as ungraded in the calibration panel
and the export honesty lines rather than left to look implicitly confirmed.

**What would settle it.** Realized flips, once the replayable sample is large
enough to separate capture from the reach and drift effects around it. The
harness is scoped for it; the sample is not there yet.

### 1e. Does the partial-fill picture survive on a larger sample?

Median buy credited, by cohort, across the 43:

| cohort | n | median credited |
|---|---|---|
| watchlist | 8 | **100%** |
| scanner T1 | 9 | 37% |
| scanner T2 | 6 | 36.8% |
| slice | 20 | 8.3% |

The pooled "median 37% of intended size" was four populations averaged. The
cohort closest to fundable fills completely. **On this sample it is evidence
for the gates, not against sizing.**

**Caveats a fresh session must carry.** None of the 43 was a clean gate-passer,
so "funded shape" has n=0 in the strict sense — watchlist is a proxy, and it is
8 trips. **What would settle it:** the same decomposition on a post-reset epoch
with clean passers in it.

### 1f. Should the gap band be routed exclusively to the evening touch?

**Raised Aug 13 2026, open, and deliberately not answered.** The band's two
horizons disagree in sign: **+399k on 3 overnight trips against −219k on 16
daytime ones.** Placed only at the evening touch, the band's trips get the
~9.5h sit; placed in the daytime they get ~5h, and on this evidence that is
where the losses are.

**This is not the scanner question and must not be read as it.** The held T3
scanner proposal asks whether the band deserves more coverage. Routing asks
when its trips should be placed. Different change, different cost, different
bar — see the routing-is-not-coverage case law in CLAUDE.md. **The scanner
proposal stays held on its own bar** (5 clean post-fix closed trips; the line
on Prospecting reports the standing count).

**What would settle it.** Five clean post-fix closed trips in the *overnight
cell*, with a concentration reading that is not one trip. Neither half is met:

| | n | notional | net (sim) | top-trip share |
|---|---|---|---|---|
| gap band · overnight | 3 | ~10.9m | **+399k** | **103%** |
| gap band · daytime | 16 | — | **−219k** | none — net is negative |

The overnight cell is **one 10.6m-notional trip** plus two that offset it: 103%
of the cell's net is the single top trip, so the effective sample size is one,
and three trips would not have been enough regardless. Read the cell as an
anecdote until it has trips that stand without that one.

**Where to look.** Trade → Paper Book → **Overnight vs daytime**, which renders
every cohort at both horizons with n, notional, net and concentration per cell,
and opens each to its trips. The analysis export carries the same as
`perCohortHorizonRollup`.

---

## 2. Pending on Mike

Nothing below can be done from the desk; each needs the browser or a ruling.

1. **Run the sell-leg calibration while flips are fresh.** Trade → Paper Book →
   ▸ run calibration. The 5m tape retains ~36h, so this is a *rolling* test —
   run it soon after a batch of flips completes, not at review time. The one
   run so far (2-of-4) is **VOID**: it predates the window-anchor fix in
   `1f61df5`. If `DB.calib` still holds those numbers, they are wrong.
2. **Re-run the anomaly scan after Aug 14**, on a fully post-break baseline.
   Until then every 2–3-week baseline straddles 2026-07-24 and the volume term
   is suppressed by design.
3. **Paper-book epoch reset — queued behind calibration**, deliberately. The
   corrupted epoch is the fixture for the fill-model work; resetting before the
   model settles would force a second reset.
4. **Rule on the constitutional scope audit.** Eleven proposed widenings, five
   rules found adequately stated, five flagged as preferences sitting in the
   constitution looking enforceable, and one genuine conflict (below). Nothing
   applied — the findings are in the conversation only, which is the one item
   in this file with no other home. Re-request the table if it is gone.
5. **Press Import briefing** if `intelligence.json` has not been imported: 22
   records, of which one is the first `measured`-tier record and three carry
   `disposition` dismissals (Bandos chestplate, Bandos tassets, Golem Crafting
   gems) that apply on import and decision-log themselves.
6. **Poll #270 (Jeweller's chisel) is unresolved.** It closed 2026-08-12 with
   `POLL_STATE_RUNNING` still showing at ~11:55 UTC. The wiki's poll page
   renders an unpopulated results template — a "2 votes, 50/50 tie" — which is
   placeholder data, **not** the outcome. The next briefing must read the real
   result. The Bronzeman / A Ruff Situation poll opens Aug 14.

---

## 3. Interim states that must not become permanent by inertia

### The fill-horizon gate is a SOFT TAG, not a hard bench

**Ruled 2026-08-12, effective now, interim.** The gate queues candidates as
NEXT UP with "predicted fill ~Xh — estimator under repair, input error known to
be large" instead of benching them.

**Reason:** graded against 43 replayed trips, observed/predicted spanned
0.025×–13.17× — a **518× range** — and the gate would have benched 4 of the 10
trips that actually completed. A hard gate on an input that noisy costs more in
real candidates than the noise it admits.

**Reversion condition:** returns to a hard bench when the corrected input is
regraded on a post-reset sample and a band width is ruled.

Both the downgrade and its reversion are written to the decision log
(`FILL_GATE_SOFT_KEY`, logged once per store, with the 518× figure and the
reversion clause in the reason). Probe `[R50.2]` asserts the reversion clause
is present, so deleting it fails the suite. **This is the mechanism that stops
the interim becoming permanent — do not remove it when reverting; log the
reversion instead.**

---

## 4. Everything else a fresh session would need and not otherwise find

### The hard boundary on the flip log — read this before offering to help

**The flip log never leaves the browser, and nothing in this repo may contain
trading data.** This is why the calibration harness is an in-browser surface
rather than an analysis the agent performs: the natural move is to ask for an
export and replay it at the desk, and that move is wrong. The calibration
export (`⭳ export calibration`) exists so the *measurement* can leave without
the record: prices only as percentages against the trader's own fill, no gp,
no wall-clock times.

One deliberate deviation from the brief, still open for overrule: the export
carries the bucket-vs-fill comparison as a **percentage only**, not the
"delta and percentage" that was asked for, because carrying both is invertible
— `fill = delta ÷ (pct/100)` recovers the absolute price exactly.

### Where the numbers in this file came from

Three analysis exports sit in the user's Downloads:
`analysis-paper-2026-08-12.json` (272 closed trips),
`analysis-gates-2026-08-12.json`, `analysis-prospecting-2026-08-12.json`.
Every figure quoted above was computed from those plus 5m tape fetched at
~13:00 UTC. **They are a snapshot of the corrupted epoch, pre-fix.** After the
reset they become historical curiosities, not baselines. The 5m tape cache was
in a session scratchpad and is gone.

### Mean vs median on the fill-forecast window

The ruling specified the **median** of the last six hourly readings, and that
is what shipped. Measured on the same 43, the mean over the window is tighter
on spread (15.5× vs 24.6×) while the median is better on wrongly-promised fits
(9 vs 13). Neither differs on false benches — both are 4. Worth an overrule if
spread matters more than false fits; not worth revisiting otherwise.

### A seventh face of the test-suite failure, not yet in case law

The case-law entry states the root as "a green result can mean the test never
ran". That does not bind an assertion which **runs, exercises the right code,
and passes for the wrong reason** — e.g. `[R49.2]` matches
`/watchlist 100% of 2/` against whole-page HTML, which any other blend on that
page would satisfy. Surfaced in the scope audit; **pending a ruling**, so it is
deliberately not in CLAUDE.md yet.

### One live conflict between two rulings

**"Advisory layers stay advisory"** and **"Membership bookkeeping applies
itself"** cannot both be read literally. The membership ruling supersedes the
first in one place and does not say so. Flagged in the audit; pending.

### Probe discipline, from four instances in one week

The reimplementation trap fired four times in this session, twice in code
written immediately after documenting it. The operative discipline is not the
rule but the check: **no assertion counts as proven until its seeded defect has
been seen to fail it.** Two further failure shapes, both now in case law: a
seed landing on unreachable code proves nothing and looks identical to real
proof, and two defects seeded together can hide each other — so seed one at a
time, and re-run anything that did not fail in isolation.

### Things that are fine and might look alarming

- **`shadow*` identifiers are the paper book**, except `shadowReserve`,
  `shadowItem` and `renderShadow`, which are the Shadow Fund. Persisted keys
  were deliberately not renamed.
- **The regime curves may read zero.** If no trip carries a regime the surface
  says "has never been fed" rather than showing zeros — that copy is the
  detector working, not a bug.
- **Ancestral, prayer scrolls and the CoX complex moved hard on 2026-08-12.**
  That is the shipped reweighting, front-run since the 22 July proposal, and it
  is fully written up in `briefings/BRIEF-2026-08-12.md`.
