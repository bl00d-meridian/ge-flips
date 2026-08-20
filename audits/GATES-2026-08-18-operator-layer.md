# The operator-gate layer under a control-cell pool — 2026-08-18

**Instruction 3, restated. Report only.** The scorer's core excludes operator gates by
construction; the live plan still applies them, so post-cutover the plan funds **control-cell
passers MINUS operator gates**. The question here is not where the controls render (§2f of
the readiness sweep) but whether each **gate itself executes its intended behaviour** when
its input state is keyed to a row that does not exist.

Per gate: **what it reads · item-keyed or row-keyed · what it does on a pool item.**
Verdicts: **fires correctly** · **fires wrongly** · **cannot fire** · **FIRES VACUOUSLY**
(passes because its input is absent).

---

## §1 · The three that fire vacuously

**A restraint that silently stops restraining is worse than one that breaks loudly** — and
all three below pass a pool item on an *empty input*, with a plausible-looking reason. This
is the `DB.qual` defect in three more stores.

### 1a · Momentum / the falling-knife bench — **FIRES VACUOUSLY, and it is the worst of them**

| | |
|---|---|
| **reads** | `momentum(c, sp)` where `sp = S.spark.get(w.id)` |
| **keyed** | `S.spark` is an item-keyed Map, but it is **populated only for `DB.watch` + `DB.holds`** (`fillSparks`) — so it is row-keyed in effect |
| **on a pool item** | `pts = []` → `pts.length < 5` → returns **`{ state: "flat" }`** |

`marketGateEval`'s momentum limb is
`st.moState == null ? "unknown" : (st.moState === "knife" ? "fail" : "pass")`.
**`"flat"` is not null, so it does not read as unknown — it reads as PASS.** The live chain
converts *no data* into a definite, passing verdict.

**The contrast is the proof this is a defect and not a choice:** the instrument's own stats
builder sets `moState: null` for exactly the same missing input, and the core then reports
**unknown**. Two readers of the same absence, one honest, one not.

**Consequence:** the falling-knife defense — the gate that stops you bidding into the bottom
of a falling range, where a fill happens *because the price came down through you* — is off
for every pool item. Honest form: `momentum` returns `{ state: null }` on insufficient
points, and the chain's three-state handles it.

### 1b · The drift bench — **FIRES VACUOUSLY**

| | |
|---|---|
| **reads** | `stabilityWeight(sp, margin)` → `sitRisk(sp, margin)`, plus `walkGapH` |
| **keyed** | same `S.spark`, row-keyed in effect |
| **on a pool item** | `sitRisk` needs **24 hourly points**; with none it returns `null`, so `stabilityWeight` returns `{ w: 1, drifty: false }` and `chk(stw.drifty && walkGapH > 24, …)` can never be true |

**Consequence:** "drifty pick benched — your last walk-up was N hours ago and its typical
daily wander would eat the margin unattended" **never fires on a pool item**, at any absence
length. The restraint that exists precisely for the case where you are away is the one that
silently switches off.

### 1c · The 5m die-off binding inside the volume floor — **FIRES VACUOUSLY, and its copy states something false**

| | |
|---|---|
| **reads** | `volGateFor(c)` → `c.vol5` (universe-wide, from `S.min5` — fine) **and `S.vol5Low.get(c.id)`**, the consecutive-refresh streak |
| **keyed** | `S.vol5Low` is written by `updateVol5Streaks()`, which iterates **`for (const w of DB.watch)`** — row-keyed |
| **on a pool item** | the streak is never incremented, so `n` is 0 permanently and the `n >= VOL5_BIND_REFRESHES` branch is **unreachable** |

The item's 5m volume can sit far under the floor indefinitely and the gate keeps binding on
the 1h side. **And the rendered label is actively wrong**: it says
*"5m X/h under floor, 0/N consecutive refreshes — not binding yet"*, which claims the streak
is being counted and has reached zero. It is not being counted at all. That is the
never-fed-aggregate rule inside a bench reason — a zero from *nothing feeds it* rendered
identically to a zero from *nothing qualified*.

**`DB.dieOffLog` inherits this**: die-off episodes only ever open for watchlist members, so
the die-off tag and its 24h grading are watchlist-scoped machinery.

---

## §2 · The dependency this exposes — **chart wiring UNMASKS 1a and 1b rather than fixing them**

Right now the vacuity of momentum and drift is **masked**: a pool item has no `tr`, so
`chk(!(sp && sp.noData) && tr == null, "chart still loading")` fires and the item benches
before the vacuous gates matter.

**Chart wiring, as scoped, removes the mask without removing the defect.** It supplies `tr`
and `vt` — the two gates `marketGateEval` names — from the T0 h1 archive. But `momentum` and
`sitRisk` read **`sp`**, the per-item spark object, not the archive. So on the day chart
gates start passing, the chart bench stops firing and two restraints that were previously
irrelevant become live-and-off.

**Therefore item 4's scope must include momentum and drift inputs, not just `tr`/`vt`.** Both
are derivable from the same hourly series (momentum needs 5 points, `sitRisk` needs 24; the
archive carries 8 days). This is a scope correction to a build that has not started, which is
the cheapest moment to make it.

---

## §3 · The full per-gate table

### Fires correctly — restraint intact

| gate | reads | keyed | behaviour on a pool item |
|---|---|---|---|
| **blacklist** | `isBlk(id)` → `DB.blacklist` | **item** | fires. The user's veto is item-keyed and constitutionally unconditional |
| **proven-loser bench** | `recentNet(id, 3)` over `DB.flips`; `w.tAt` only for the *unbench* | **item** (the release is row-keyed) | fires. A pool item with a losing record still benches; only the fresh-margin-test release is unavailable — the restraint holds and its escape hatch does not, which is the conservative direction |
| **fill history / slow fills** | `slowHistory(id)` → `fillHistory(id)` from the log | **item** | does not fire, correctly: no traded history is not evidence of slow fills. Identical to a newly added watch item |
| **wins waiver on the volume floor** | `itemWins(id)` over `DB.flips` | **item** | does not fire, correctly: the waiver requires realized wins, so the floor binds. Conservative |
| **volume floor (1h limb)** | `c.volSide`, `volFloorFor(c.buy)` | **item** | fires |
| **ROI / margin / skew / imbalance / volTrend** | `marketGateFails` at `liveMarketConfig()` | **item** | fire. Pure functions of (stats, config) by construction — this is what stage 1a bought |
| **margin floor's tax and tick limbs** | `marginNeedFor(id, tax)`, `tickFloorFor(id)` → `exemptIds` | **item** | fire, exemption included |
| **chart still loading** | `tr == null` | effectively row | **fires** — and this is the bench that currently masks §1a/1b, and why chart gates at 7/7 is a cutover prerequisite |
| **seasoning** | `qualState(id)` → `DB.qual` | **item** (fixed today, §87) | fires. Before the prune fix it could not — that was the ruled defect |
| **seasoning exemption** | `qualExemption(id, c)`: `c.tested`, then `DB.flips` | **item** (`c.tested` needs a row) | does not fire, correctly: a pool item has no tested pair and no logged trip, so it seasons normally |
| **exception / probation lane** | `excFor(id)` → `DB.shadowExceptions`; adjudication over `DB.flips` | **item** | fires |
| **pump caution + seed slot** | `suspectedPump(id)`, `cautionCat(name)`, `catSlots` per build | **item / name / population** | fires. Half-size cap and the one-slot-per-category rule both apply |
| **family rule** | `familyKey(c.name)` | **name** | fires. More collisions at pool scale — a copy question, not a correctness one |
| **bank sizing** | `planQty(w, c)` → `planCap`, `workingStack()` | **global** | fires. `w.qty` absent → `undefined == null` is true → the computed cap is used, which is the intended default |
| **tier bands** | `itemTier(id, c)` → `tierFromPrice` | **item** (override is row-keyed) | fires on the price band. **66% of control-cell items land untiered** and the override — the only re-admission path — is unavailable until the operator re-key |

### Cannot fire

| gate | why |
|---|---|
| **T2 graduation stamp** (`w.t2Grad`) | written onto `DB.watch.find(...)`; a pool item has no row, so a T2 item that earns full size never records it and re-ramps for ever. Not a restraint — a *release* that cannot fire, so the failure is conservative |
| **tested-price override** (`w.tBuy`/`w.tSell` via `calc`) | no row → `hasTest` false → live prices. Correct evaluation; the operator's escape hatch is simply absent |

---

## §4 · Summary

| verdict | n | which |
|---|---|---|
| **FIRES VACUOUSLY** | **3** | momentum / falling knife · drift bench · the 5m die-off binding |
| **cannot fire** | 2 | T2 graduation stamp · tested-price override |
| **fires correctly** | 15 | the table above |

**The pattern in the three vacuous ones is a single shared cause: they read `S.spark` or
`S.vol5Low`, and both are populated by loops over `DB.watch`.** Every gate that reads an
item-keyed *store* survives the cutover; every gate that reads an item-keyed *cache filled by
a watchlist loop* does not. That is the mechanical tell, and it is worth carrying into the
adversarial pass as a search pattern rather than a list of three.

**Two of the three fail in the dangerous direction and one fails loudly-but-silently:**
momentum and drift both *pass* on empty input; the die-off binding does not pass anything by
itself but renders a bench reason that states a false fact about its own counter.

**None of this is fixed by the pool switch and none of it is visible in `[R89.1]`/`[R89.2]`** —
those assert the seam, and these are three stores behind it. I have not changed any of them:
the fixes are behaviour changes on the money path and belong in the frontload with their own
ruling, alongside the chart-wiring scope correction in §2.
