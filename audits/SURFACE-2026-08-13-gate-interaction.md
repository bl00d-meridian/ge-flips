# Gate interaction surface — a measurement

2026-08-13 · measurement first, then **six rulings applied the same day** — see
*Rulings applied* below. **No constant moved and none is proposed.**

> ## Rulings applied 2026-08-13
>
> 1. **The ROI-floor loosening experiment is CLOSED**, not benched, and the gate choice that
>    rested on the 74% figure is **struck**. Decision-logged with the arithmetic.
> 2. **The population fix is CLOSED** for the same reason; the reserved-scanner-slot
>    carve-out stays on record as sound but moot. Decision-logged.
> 3. **`REGIME_BANDS[0]` fixed** — reachability is now computed from the constants, the
>    exempt carve-out is a property of the item, and the dead render branch was deleted.
>    Incident recorded as **M151**.
> 4. **The affected surfaces are MARKED, not repaired** — each declares itself *headline
>    gate, not binding gate*; the sound surfaces deliberately carry no mark and `[R73.6]`
>    asserts that absence. **Amended the same day: the funnel — the one surface the user
>    reads most — was REPAIRED rather than marked.** Leave-one-out leads, first-fail is
>    demoted and labelled as ordering, the ⚑ flag is retired. Twelve surfaces remain
>    marked-only, and the full-fail-set ledger recording is HELD (queue row 10).
> 5. **§10's general-form rule is BINDING in CLAUDE.md**, with **scan 16** as its detector
>    and the methodological half filed as DOCTRINE.
> 6. **The appendix** below answers *what would it take to make attribution causal* —
>    report only, nothing built.
>
> Verification: `PROBE-PASS`, 306 requirement ids, pairing clean both directions.
> §73 adds nine assertions; three existing ones (`[R68.6]`–`[R68.8]`) went red on the
> ratification and were repaired, and `[R65.2]` was rescoped. All twelve were proven by
> seeding — including one dead seed caught and fixed, recorded in §Verification.

Ordered by the user on 2026-08-13, from HANDOFF queue rows 7 and 8: *for each hard gate,
over what regions of the (price, ROI, spread, volume) space can it be the ONLY failure?*

---

## Sources and coverage

| | |
|---|---|
| Code | `index.html`, working tree at the start of this session (uncommitted changes present) |
| Live market snapshot | RuneScape Wiki `/latest`, `/1h`, `/mapping`, fetched 2026-08-13 20:00 −05:00; the `/1h` bucket stamps **2026-08-13T22:00:00Z** |
| Universe | **4,497** items carrying both a live buy and a live sell price (4,652 mapped, 4,518 with a `/latest` row); 3,174 of them carry a `/1h` row |
| Stored ledger | `inbox/ge-flips-2026-08-13 (1).json` — `DB.gateLog` 689 rows (648 excluding `funded`/`seasoning`/`die-off detected`), 184 candidate-days, 4 observed days |
| Stored paper book | 132 trips from the same backup |
| Working capital assumed | `bank 464m − shadowReserve 300m = 164m`; `realizedSince(bankAsOf)` is not recoverable from the backup, so the one-third cap is a **lower bound** |
| Horizon assumed | `limitWindows() = 1` (the three daytime gaps); the 9.5h evening touch gives 2 |

**Nine of the fifteen hard gates are not evaluable from a price snapshot** — blacklist,
proven-loser bench, no history, chart still loading, trend (both limbs), volume trend,
momentum, fill history, drift bench all need the 7-day spark cache, the user's flip log,
or the user's walk-up history. Six are: **ROI floor, margin floor, book skew, flow
imbalance, volume floor, sizing.** Every empirical count below is over those six, and
that restriction is **safe in one direction only**: an item that fails two of the six can
never be a single-gate near-miss whatever the other nine do, so co-occurrence counts are a
sound *lower* bound on domination and sole-failure counts are a sound *upper* bound.

The `/5m` endpoint was not fetched, so `volGateFor()` resolves to its `1h` limb throughout.
The `5m` limb can only *lower* `volGate`, so volume-floor failures are also a lower bound.

---

## The result, first

**The ROI floor cannot be the only failure for any non-exempt item, at any price, at any
ROI.** Not "rarely" and not "above ~250gp" — the region is empty. The margin floor's tax
limb enforces an effective sustained-ROI floor of

    ρ* = taxMult·τ / (1 − τ − taxMult·τ)  =  0.06 / 0.92  =  3/46  =  6.5217%

against a stated `GATE.roi` of **1.2%**. Every item the ROI floor benches is already
benched by the margin floor, and so is every item between 1.2% and 6.52% that the ROI
floor waves through. **`GATE.roi` does not select anything.** The number on the settings
panel, in the bench copy, in the glossary, in three export headers and in the regime race
is not the floor the product applies.

On the live snapshot: **2,358 of 4,497 items fail the ROI floor and 2,358 of 2,358 also
fail the margin floor.** Zero exceptions, exempt or not.

Two gates are dominated the same way lower down the chain: **flow imbalance** is
arithmetically dominated by the volume floor over 89% of its failures, and **book skew** is
empirically dominated by it over 99%.

Of the 4,484 items failing at least one of the six gates, **366 (8.2%) have a single
identifiable binding gate**; the other 4,118 fail two or more, and for those "the reason"
is chain position by definition. The answer to the aggregate question is therefore:
**most of the plausible candidate space has a structurally dominant gate, and per-gate
attribution over it has been reporting ordering.**

---

## 1. Per-gate surface

`GATE_CHAIN_ORDER`, with the six measured gates marked ●. `ρ` is sustained ROI as a
fraction (`eRoi/100`), `P` is `c.buy`, `S` is `c.sell`, `V` is `volSide`, `F` is
`volFloorFor(P)`.

| # | Gate | Where it can act ALONE | Where structurally dominated, and by what | Designed? |
|---|---|---|---|---|
| 1 | no live price | always — returns before the chain, never enters `fails[]` | — | designed |
| 2 | blacklist | anywhere; orthogonal to every market variable | — | designed |
| 3 | proven-loser bench | anywhere in the *traded* subset; orthogonal | — | designed |
| 4 | ● **ROI floor** | **non-exempt: EMPTY.** exempt: `P > 667` and `8 ≤ eMargin < 0.012·P` | **margin floor**, everywhere else. Tax limb for `S ≥ 250`, tick limb for `S < 250`; the two overlap with no gap | **incidental** |
| 5 | ● **margin floor** | `ρ ∈ [0.012, 0.0652)` (tax limb) ∪ `eMargin < 15` at `P < 1250` (tick limb). For `S > 250m` the 5m tax cap flattens `marginNeed` to 15m, so the effective floor falls to `15m/P` | not dominated by any of the six | designed as a gate; its **magnitude** is incidental |
| 6 | ● book skew | `V ≥ F` with the two last-print stamps >60 min apart — 15 items today | **volume floor** on 2,016 of 2,031 (99.3%). Empirical, not arithmetic: `/latest` stamps and `/1h` buckets are different data | incidental |
| 7 | ● **flow imbalance** | `vol > F / balHardLo = 6.67·F` — and only about half the time even there (91 of 180) | **volume floor** whenever `vol ≤ 6.67·F`. Arithmetic: imbalance-fail ⟹ `V < 0.15·vol`. **0 of 1,412 escaped; 91 of 180 above the line did** | **incidental** |
| 8 | no history | anywhere; orthogonal | — but it **dominates** #10–#12 and #14 by nulling their inputs | designed |
| 9 | chart still loading | anywhere — and it is `GATE_UNKNOWABLE`, so it never counts toward `known` | **dominates** trend, volume trend and momentum by nulling `tr`/`vt`/`pts` | designed as a skip; dominance incidental |
| 10 | trend (falling, `tr ≤ −8`) | not measured (needs the 7-day spark) | mutually exclusive with #11 by construction; both dominated by #8/#9 | designed |
| 11 | trend (downtrend, `−8 < tr ≤ −5`) | not measured | as above | designed |
| 12 | volume trend (`vt ≤ −40`) | not measured | dominated by #8/#9 | designed |
| 13 | ● sizing | `P > workingStack/3` (≈54.7m today) or no buy limit in the mapping — 68 items, **0 sole** | not dominated; but its region is a function of the **user's bank**, not the market | designed |
| 14 | ● **volume floor** | the largest sole region of the six: **280 items**, and in the plausible subset every one of its 190 headlines is a sole failure | not dominated by any of the six. **Dominates #6 and #7** | designed |
| 15 | momentum (knife) | not measured | dominated by #9 (needs ≥5 hourly points) | designed |
| 16 | fill history | anywhere in the *timed-flip* subset; orthogonal | — | designed |
| 17 | drift bench | only when the last walk-up was >24h ago — a function of **user behaviour**, not the market | — | designed |

Two gates therefore have regions that move with something other than the market —
**sizing** with the bank and **drift bench** with the visit gap. Neither is a defect;
both mean a per-gate count is not comparable across weeks in which either changed.

---

## 2. The ROI/margin proof

`candidateFor()` evaluates, in this order (`index.html:4116` and `:4124`):

```js
chk(eRoi == null || eRoi < GATE.roi, "ROI floor", …)
const marginNeed = Math.max(GATE.taxMult * (c.tax || 0), tickFloorFor(w.id));
chk(eMargin != null && eMargin < marginNeed, "margin floor (ticks / 3× tax)", …)
```

with `eRoi = eMargin / c.buy * 100`, `tax = min(floor(0.02·S), 5e6)`, `tickFloorFor = 15`
(8 when tax-exempt).

**Claim.** For a non-exempt item with `S ≥ P`, `eRoi < 1.2` ⟹ `eMargin < marginNeed`.

**Proof.** `eRoi < 1.2` is `eMargin < 0.012·P`. And
`marginNeed = max(3·floor(0.02·S), 15) ≥ max(0.06·S − 3, 15) ≥ max(0.06·P − 3, 15)`.
Take the two branches: for `P ≥ 62.5`, `0.06P − 3 ≥ 0.012P` ⟺ `0.048P ≥ 3` ✓; for
`P < 62.5`, `0.012P < 0.75 < 15` ✓. So `eMargin < 0.012·P ≤ marginNeed` throughout. ∎

The `S ≥ P` premise fails only on an inverted book, where the margin is negative and both
gates fire anyway.

**The converse — the dead band.** Setting `margin = ρ·P` and `tax = 0.02·S` with
`S = (P + margin)/0.98`, the condition `margin < 3·tax` reduces to
`ρ < 0.06/0.92 = 6.5217%`. So the margin floor benches everything below 6.52% ROI,
including the entire `[1.2%, 6.52%)` range the ROI floor passes.

**Empirical confirmation, live snapshot.** Of 1,431 non-exempt items that pass the margin
floor, the minimum sustained ROI is **2.24%** — and every one of the six below 6.52% is a
named boundary case, not a counterexample:

| item | buy | eRoi | why it passes |
|---|---:|---:|---|
| 3rd age druidic robe bottoms | 1,560m | 2.24% | `TAX_CAP` — `marginNeed` flattens to 15m |
| 3rd age druidic cloak | 678m | 2.39% | `TAX_CAP` |
| Elysian sigil | 491m | 4.89% | `TAX_CAP` |
| 3rd age longsword | 825m | 5.32% | `TAX_CAP` |
| Death talisman | 1,000 | 6.30% | `floor()` slack: `3·floor(0.02·1084) = 63 = eMargin` |
| Steel keel parts | 2,650 | 6.49% | `floor()` slack: need 171, margin 172 |

Below the 250m tax-cap threshold and outside ±3gp of `floor()` rounding, **6.52% is exact.**

**The exempt carve-out is the whole of the ROI floor's power.** `tax = 0` collapses
`marginNeed` to 8, so the region opens at `P > 667`. There are **48** exempt items with
live prices and **6** above 667gp. Today none is in the region — but the carve-out is
visible from the other side: of the **13 items that pass all six gates**, **seven are
tax-exempt**, and six of those seven sit below 6.52% ROI:

    Ardougne teleport (tablet)   2.52%      Ring of dueling(8)     1.72%
    Camelot teleport (tablet)    2.11%      Varrock teleport (tab) 3.67%
    Falador teleport (tablet)    3.56%      Old school bond        1.41%
    Lumbridge teleport (tablet)  4.68%

Six of the thirteen clean passers in the entire market are there **only because they are
tax-exempt.** That is the mechanism the ROI floor was thought to be gating, running the
other way.

---

## 3. Where the ROI band actually is

Non-exempt items by sustained ROI, live snapshot:

| band | items | of which pass the margin floor |
|---|---:|---:|
| negative | 1,861 | 0 |
| `[0, 1.0)` | 437 | 0 |
| **`[1.0, 1.2)` — the loosening experiment's target band** | **41** | **0** |
| `[1.2, 1.44)` — current-not-tight | 45 | 0 |
| `[1.44, 6.52)` — **the dead band** | 495 | 6 |
| `≥ 6.52` — fundable | 1,570 | 1,425 |

**679 items (15.1% of the universe; 18.0% of the plausible subset) sit in the dead
band** — above the stated ROI floor, benched by an unstated one.

The 41 items in `[1.0, 1.2)` are the entire population a 1.2% → 1.0% loosening could
reach. **All 41 fail the margin floor.** Loosening `GATE.roi` to 1.0% would admit exactly
nothing, at this snapshot, by arithmetic rather than by luck.

---

## 4. Headline versus binding, on one population

Chain order restricted to the six, `headline` = first failing gate, `sole-binding` = the
gate when it is the *only* one of the six that fails:

**Whole universe (4,497):**

| gate | headline | sole-binding |
|---|---:|---:|
| ROI floor | **2,358** | **0** |
| margin floor | 686 | 85 |
| book skew | 942 | 1 |
| flow imbalance | 218 | 0 |
| volume floor | 280 | 280 |
| sizing | 0 | 0 |

**Plausible subset — has `/1h` data and a buy limit (2,970):**

| gate | headline | sole-binding |
|---|---:|---:|
| ROI floor | 1,696 | 0 |
| margin floor | 542 | 78 |
| book skew | 328 | 1 |
| flow imbalance | 203 | 0 |
| volume floor | 190 | 190 |
| sizing | 0 | 0 |

The two columns are not noisy versions of each other. They are **a function of chain
position**: the ROI floor sits fourth, so its headline count equals its total failure
count; the volume floor sits second-to-last, so its headline count equals its *sole*
failure count exactly (190 = 190). A gate's ledger presence measures where it sits in the
list.

Number of the six each item fails: `0:13 · 1:366 · 2:1569 · 3:1174 · 4:1043 · 5:327 · 6:5`.

---

## 5. The ledger — what it stores, verified

`DB.gateLog` is written at `index.html:4618` as `gateName(b.failed)`, and
`b.failed = fails[0].detail` (`:4190`). **One row per item·gate·day, headline only.**
Re-derived from the stored backup, reproducing the power check's figures exactly:

| | |
|---|---:|
| candidate-days | 184 |
| carrying an ROI-floor row | 162 |
| of those, **also** carrying a margin-floor row that same day | **127** |
| of those, carrying the ROI-floor row **alone** | 14 |

Those 127 are the direct measurement of the point: on 127 candidate-days the headline
flipped between the ROI floor and the margin floor *within the day*, which is only
possible because the row records an event rather than a state. And the 14 "sole blocks" are
not days on which one gate was failing — by §2 the margin floor was failing on every one of
them, unrecorded.

**The two populations the power check left as an unresolved contradiction (§5) are now
resolved, and they resolve against the ledger:**

| "the only thing stopping this item" | volume floor | margin floor | ROI floor |
|---|---:|---:|---:|
| paper book `benchedBy` — a **true** single-gate failure | **66** | 50 | **0** |
| gate ledger "sole blocks" — headline never changed | **0** | 2 | **14** |

They are exact inverses, and the reason is chain position. The volume floor is the most
common true sole failure in the book and can almost never be a headline; the ROI floor is
the most common headline and can never be a true sole failure. They were never in conflict
— one of them was not measuring what its name says.

---

## 6. The loose regime is unfeedable — by arithmetic, not by sampling

The regime race exists to answer whether 1.2% is the right floor. `SHADOW_LOOSE = 1/1.2`
puts the loose regime at exactly **1.0%**. A trip carries `loose` but not `current` only
when `eRoi ∈ [1.0%, 1.2%)`. Such an item **fails both the ROI floor and the margin floor**,
so it has two known failures and:

- the **watchlist** path (`shadowScan`, `:6281–6286`) admits only `failProfile().nearMiss` — rejected;
- the **scanner** path screens at 1.0% (`:6377`) and then requires `pass || nearMiss` (`:6390`) — rejected;
- the **slice / gap band** paths require `clean || fl.length === 1` (`:6314`) — rejected;
- **picks** are by definition unbenched.

There is no admitting path. Stored book, 132 trips: **125 carry `current+loose+tight`, 7
carry `current+loose`, 0 carry `loose` alone** — and all 50 margin-floor near-miss trips
carry `current`, which is what §2 predicts (margin-floor headline ⟹ ROI passed ⟹
`eRoi ≥ 1.2%`).

**`REGIME_BANDS[0]` states the wrong mechanism and produces a false denominator**
(`index.html:9578–9580`):

```js
{ wider: "loose", narrower: "current",
  eligible: p => p.cohort === "scanner",
  whyIneligible: "screened at the full ROI floor on entry, so it cannot sit below it" }
```

Both halves are wrong. The watchlist path applies **no ROI pre-screen at all** — it admits
any single-gate near-miss — so the stated reason for its ineligibility is not the operative
one. And the scanner cohort is **not** eligible: its 1.0% screen is followed by the
near-miss test, which the band cannot pass. So `nEligible` counts the 14 scanner trips as
chances that were had and missed, when the true count of chances is **zero**. This is the
never-fed-aggregate defect living one level up inside the classifier written to detect it:
the code comment at `:9571–9576` says an empty band over an ineligible population "must not
render as *no trip sits in this band*", and the eligibility predicate it relies on is
itself mis-stated. *Reported. Not fixed here.*

The same arithmetic makes `depProposalFor`'s ROI-floor branch (`:5703–5707`) **unreachable
for non-exempt items** — it fires from `nmByGate`, and "ROI floor" can never be a key there.
A dead branch behind a green surface, the eighth face's shape.

---

## 7. Every reader of per-gate attribution, classified

### Affected — reads the headline, so it reports ordering

| Surface / artefact | Where | What it claims |
|---|---|---|
| `DB.gateLog` writer | `:4618` | the origin: `gateName(fails[0].detail)` |
| `daysBenchedBy()` | `:5644` | "benched by this gate on N of M observed days" |
| **gate-persistence bar for proposals** | `:10428` | `daysBenchedBy(...).n >= GATE_PERSIST_DAYS` — **the bar that moves gate constants** |
| near-miss row copy | `:10385–10388` | mixes a *true* single-gate near-miss with a *headline*-derived day count **in one sentence** |
| `gateHealthAudit()` | `:12091` | the whole function; every row is headline-attributed |
| Gate Health "two streams" | `:12206` | renders a headline-attributed realized stream **beside** a sole-failure-attributed paper stream, under one gate name, inviting comparison |
| `gateStreamDirs()` | `:7623` | the combined too-tight verdict, from those two |
| `gateSummaryLine()` | `:12443` | the weekly review's agree/disagree count across the two |
| `gateVerdict()` | `:18614` | "are my gates too tight or too loose?" |
| `analysisGates()` | `:18162` | the `analysis-gates-*.json` export |
| **deployment funnel** | `:10313–10358` | `firstGate = fails[0].g`; the header says "first-fail attribution, in the order the chain applies", which is honest — **the ⚑ "the two biggest killers this refresh" line is not**, because *killer* reads as cause |
| `POWER-2026-08-13-roi-floor.md` | §2, §3, §6 | the per-gate table, the **74% sole-blocker** figure, the 3.5/day rate |
| HANDOFF queue row 5 | — | "gate choice stands on the sole-blocker evidence (74% of all sole blocks…)" |

### Sound — reads the full fail set, so it reports binding

`failProfile()` (`:3074`) and everything built on it: the marginal-gate attribution
(`:10365–10393`), the `nmByGate` proposal engine (`:10420`), `shadowScan`'s `benchedBy`
(`:6285`, `:6318`), `scannerShadowScan`'s (`:6413`), `strataCount` (`:2712`),
`shadowByGate` (`:7090`), the paper export's `benchedByGate` (`:17976`), `gateRoll`
(`:18093`), and the exception lane's `x.fails.every(...)` (`:4359`).

**With one standing caveat that applies to all of them:** their attribution is sound, but
their *population* is shaped by the same entanglement. "ROI floor" can never appear in any
of them. `shadowByGate()` has no ROI-floor bucket not because the gate is quiet but because
it is arithmetically excluded — an absence that currently renders as an absence of evidence.

### Broken

`REGIME_BANDS[0].eligible` / `.whyIneligible` (`:9578–9580`) — §6.

---

## 8. What this does and does not overturn

**Survives.** The ROI floor is the most active *headline* gate — 57 distinct items over 4
observed days, 18 of them on all four. That is a true statement about the ledger and it
stays true; it just means "the first thing the chain says about these items", not "what
stands between them and funding".

**Falls.** Every reading that treated a per-gate count as that gate's exclusive
contribution:

1. **"Sole blocker in 14 of 19, 74%"** — the ROI floor's sole-block count is **0** by
   construction for non-exempt items. Of the 11 items behind those 14 candidate-days, **9
   fail both the ROI floor and the margin floor on today's snapshot**; the other two
   (Black d'hide chaps (g), Saradomin d'hide boots) currently pass both.
2. **"The volume floor is never the sole blocker… loosening it would free nothing."** The
   opposite: among the six measured gates the volume floor is the *only* gate whose
   headline count and sole-binding count coincide — 280 sole failures market-wide, 190 in
   the plausible subset, and 66 of 132 paper trips. It reads as never-sole in the ledger
   because it sits second-to-last in the chain.
3. **"Current ≡ loose in the paper book, so the floor looks right."** The band is
   unfeedable; the equality is an identity, not a finding (§6).
4. **The ⚑ "two biggest killers"** — a ranking of headline counts is a ranking of chain
   positions weighted by failure frequency. Relaxing the top entry frees nothing when the
   next gate catches the same population, which is exactly the ROI/margin case.

---

## 9. Found on the way — adjacent, out of scope, not pursued

1. **`strataCount`'s residual bucket is mislabelled.** `index.html:2717`,
   `else st.wall = (st.wall||0)+1` with the comment *"failed 2+ knowable gates"*. An item
   whose **only** failure is `chart still loading` has `known.length === 0` — it is neither
   clean nor a near-miss, and it lands in `wall` under a label claiming the opposite. The
   ledger records 85 item-days / 44 distinct items on that gate, so the path is live. A
   claims-vs-computation finding (scan 7).
2. **The marginal-gate attribution's three buckets do not sum to their population.**
   `near` (n===1), `two` (n===2) and `wall` (n≥3) are computed over `gated` (`:10365–10369`),
   which includes items with `n === 0` — chart-pending-only failures. Those render in no
   bucket and are not declared, against the drill-down rule's "subset shown must say so".
3. **The tax cap changes the gate's shape above 250m sell.** `marginNeed` stops scaling and
   flattens to 15m, so the effective ROI floor *falls* with price — 2.24% at 1.56b. Nothing
   states this; four items sit there today.

---

## 10. The general form — proposed text, **not applied**

The queue's framing asked whether this is in `CLAUDE.md`. **It is not** — no BINDING entry
and no DOCTRINE entry names it, and none of scans 1–14 would find it. Proposed wording,
for the user's ruling:

> **An ordered rule chain that reports "the reason" is reporting POSITION IN THE ORDERING.**
> Per-rule attribution may not be read as causal without an interaction surface: for each
> rule, the region of the input space where it can be the ONLY failure. A rule whose region
> is empty is structurally inert, and its counts measure the rule ahead of it.
> **Companion:** an attribution ledger may store only the first match — read its writer and
> establish whether it records all matches or only the first, before computing anything
> from it.

And the methodological half, which is the part no existing detector covers:

> **Every detector in this constitution reads code or copy against a STATED rule. A
> relationship between two constants that no rule ever stated is invisible to all of them.**
> This defect was found by following the arithmetic of a claim that could not be supported.
> Expect more of the same class, and expect arithmetic on the constants — not a pattern
> match on the code — to be what finds them.

If the second paragraph is ruled in, it names a gap rather than a rule, and under the
graduation bar it would be DOCTRINE until it has a detector. A candidate detector exists
and is cheap to state: **enumerate every pair of constants that meet in one comparison, and
compute the ratio.** Whether that is worth building is a separate ruling.

---

## 11. What is NOT here

No constant is moved and none is proposed to move. `GATE.taxMult = 3` and `GATE.roi = 1.2`
stand exactly as they are. The 6.52% effective floor is reported as a **measurement of what
the product currently does**, not as an argument that it is wrong — a margin floor at three
times the tax has a stated rationale (`index.html:4120–4122`, the scratch-exit bleed) and
this measurement says nothing against it.

The ROI-floor loosening experiment stays where the queue left it. This measurement adds one
fact to that file: at this snapshot the experiment could admit **zero** items, and the
reason is arithmetic rather than an absence of opportunity — which is the "attributable
named cause" the power check's §7 said any future INCONCLUSIVE should have.

---

---

# APPENDIX — what causal attribution would cost

*Added on the ruling of 2026-08-13: "what would it take to make attribution causal rather
than positional? I am not asking you to build it. I want to know the shape and cost before
deciding whether the funnel is worth repairing or should stop claiming attribution."*
**Nothing here is a proposal and nothing below has been built.** Costs are stated in the
units this project measures: operator attention, storage, and what each option can and
cannot answer.

## What "causal" would have to mean

There are three distinct questions the funnel currently answers with one number, and no
single change answers all three. Naming them is most of the work, because the cheap option
answers one of them completely and the expensive option is only needed for the third.

| | Question | What it needs |
|---|---|---|
| **Q1** | *Which gates was this item failing?* | the full fail set per item·day — a **record** change |
| **Q2** | *If I relaxed gate X, how many items would become fundable?* | a **counterfactual re-run** of the chain with X removed |
| **Q3** | *If I relaxed gate X, how much would I earn?* | Q2 **plus** outcomes for items that never traded |

Q1 is a bookkeeping fix. Q2 is a real computation but a small one. **Q3 is not obtainable**
and should be struck from anyone's expectations: it requires knowing what an unfunded item
would have done, which is the paper book's whole job and the paper book is a screen, not
evidence. Any repair that implies Q3 is overselling.

## Option A — record the full fail set (answers Q1)

`DB.gateLog` writes one row per item·gate·day from `fails[0]`. Writing one row per
**failing gate** instead is a four-line change at `index.html:4643`: iterate `b.fails`
rather than taking the head.

| | |
|---|---|
| **Code** | ~4 lines at the writer; `daysBenchedBy` and `gateHealthAudit` need no change — they already filter by gate name and would simply see more rows |
| **Storage** | the measured mean is **3.5 failing gates per benched candidate-day** (184 candidate-days, 648 headline rows, and the live census's fail-count distribution). So ~3.5× the ledger: **648 rows → ~2,300** over four observed days, against a 30-day retention. Order of 20k rows at steady state. localStorage is not the constraint |
| **Attention** | zero. No new surface; the same panels report better-founded numbers |
| **Migration** | rows written before the change are headline-only and **must be partitioned**, not merged — a `v2` stamp on the row, and every aggregate reports the split until the old rows age out at 30 days. Merging them would pool two populations answering different questions, which is the never-pool rule |
| **What it fixes** | the persistence bar (`GATE_PERSIST_DAYS`, the bar that moves constants), gate health's realized stream, the gates export, `daysBenchedBy` copy — all of them become statements about what was failing rather than about what spoke first |
| **What it does NOT fix** | the funnel. A funnel over a full fail set double-counts: an item failing four gates would appear in four stages and the cumulative "N remain" arithmetic breaks. The funnel needs Option B or C |

**Verdict on A: cheap, and it is the part with real leverage.** The persistence bar is the
mechanism by which gate constants change, and it is currently reading ordering.

## Option B — a leave-one-out counterfactual (answers Q2)

For each gate, re-run the chain with that gate disabled and count how many candidates
become clean passers. This is what "biggest killer" was always meant to convey.

| | |
|---|---|
| **Code** | `candidateFor` would take an optional `skip` set. It is already structured for this — the ENABLER refactor of Aug 10 2026 made every gate evaluate independently and collect into `fails`, so **no re-run is needed at all**: leave-one-out is computable from the fail sets the chain already produced. `n_alone(X) = count of items whose only failure is X`. That is `failProfile()` grouped by gate, which the marginal-gate attribution **already computes and already renders**, once per refresh |
| **Cost** | **near zero.** The number exists on screen today under a different name |
| **Attention** | zero if it replaces the funnel's per-stage counts; one new column if it sits beside them |
| **What it answers** | exactly Q2 for a single-gate relaxation |
| **The catch, and it is worth stating** | leave-one-out does not compose. Relaxing two gates can admit items that neither relaxation admits alone, and the single-gate numbers give no hint of that. A pairwise table is 15×15 and unreadable; the honest presentation is single-gate counts plus a stated caveat that they do not add |

**Verdict on B: the funnel's per-stage kill counts could be replaced by the sole-failure
counts tomorrow at no computational cost.** The two numbers are both already computed on
every refresh; the funnel renders the positional one.

## Option C — keep both, and say which is which

Render each stage as **`headline N · binding M`**. The funnel's cumulative arithmetic keeps
working (it needs first-fail to partition candidates without double-counting), and the
second number carries the causal reading.

| | |
|---|---|
| **Code** | ~15 lines in `renderDeploy`; both inputs already exist |
| **Attention** | **one extra number per funnel row.** This is the real cost and it is not nothing — the funnel is on the walk-up path and the ≤7 budget binds. Against that: it is a number, not a decision, and the walk-up budget counts decisions |
| **What it answers** | Q1 and Q2 together, with the divergence between the two columns visible — which is itself the most informative thing on the panel. A gate whose two numbers are far apart is a gate whose count is positional |

## Option D — stop claiming attribution

Delete the per-stage gate breakdown; keep the funnel as a pure survivorship curve
(`N enter → N pass gates → N funded`) with no per-gate rows, and route every "which gate"
question to the marginal-gate attribution, which is sound today.

| | |
|---|---|
| **Code** | a deletion — perhaps 40 lines, plus `GATE_CHAIN_ORDER`'s display use |
| **Attention** | **negative.** The funnel shrinks from ~14 rows to 3 |
| **What is lost** | the ability to see, at a glance, that (say) the volume floor is heavily involved. The marginal-gate attribution only shows items failing *exactly one* gate, so a gate that is always one of three would vanish entirely from the panel |
| **What is gained** | no surface makes a claim it cannot support |

## Ruled 2026-08-13

- **B is DONE.** The funnel now leads with leave-one-out — *relax this gate alone and this
  many candidates clear the gate chain* — and first-fail is demoted to a secondary `heads`
  figure labelled as ordering. **The ⚑ mark is retired**: its only job was "look here", and
  a ranking that is honest about what it measures does that job without a flag. Assertions
  `[R73.10]`; requirement row R73.10.
  Two things fell out of building it, both kept: a gate that heads candidates while binding
  none **renders its zero** rather than dropping out of the list (that gate is the finding);
  and the block states that **single-gate relaxations do not add**, with the two-gate and
  multi-gate counts no single relaxation reaches.
  Paid for under the zero-based complexity budget by **absorbing the per-item near-miss
  list** — the same population, now inside the `binds` drill with each item's miss and its
  persistence count.
- **A is HELD.** The causal number arrived without it, so recording the full fail set buys
  *historical* attribution rather than *current*, and a migration partition is not worth
  that alone. Logged as queue row 10 with the revival condition: a question that needs
  per-gate history — most likely the persistence bar, which still promotes proposals on
  headline day-counts.
- **C and D are moot** for the funnel, which took B. They remain the shape of the decision
  for the twelve surfaces still only marked.

## The honest recommendation shape, as it was put for the ruling

Not a proposal — the trade, stated so it could be ruled:

- **A is the one with leverage and it is cheap.** The persistence bar moves constants and
  currently reads ordering. Everything else on this page is a display question; that one is
  a decision-making question. Its only real cost is the migration partition.
- **B is nearly free and already computed.** If the funnel keeps per-gate rows, they should
  be sole-failure counts.
- **C buys the divergence — the most useful single thing on the panel — for one number per
  row against a budget that counts decisions, not numbers.**
- **D is the right answer if the funnel is not actually load-bearing.** Worth asking
  directly: the ⚑ line is read most, and its job is "look here". A survivorship curve plus
  the marginal-gate attribution may do that job better than a ranking that needed a warning
  label.

**One thing that is NOT on this list:** re-running the chain, storing per-gate
counterfactuals, or building a gate-interaction matrix. The chain's independent-evaluation
structure means the expensive-sounding version is already done; what remains is a recording
choice and a rendering choice.

---

## Verification status

### Seeding record for the twelve assertions (added with the rulings)

Every assertion was proven by seeding one defect at a time, confirming the seed **applied**
(byte-compare before reading any result) and **changed something observable**, then
restoring green. Baseline and final state both `PROBE-PASS`.

| Seed | Target went red | Also red — and why that is correct |
|---|---|---|
| `effRoiFloorPct` returns a literal | R73.1 | — |
| `marginNeedFor` uses `2 ×` tax | R73.2 | — |
| `bandUnreachable` drops its second limb | R73.3 | — |
| `bandEligible` drops the exempt limb | R73.4 | — |
| ⚑ line reads "biggest killers" | R73.5 | — |
| mark added to the marginal-gate attribution | R73.6 | — |
| glossary entry loses its `do` field | R73.7 | `[R38.1]` — the glossary-shape rule, which checks every entry; genuine overlap, not a fixture failure |
| a closure stamped `auto` | R73.8 | — |
| export caveat loses `soundAlternative` | R73.9 | — |
| `only` set inverted | R68.6 | four `[R65.2]` assertions — they rest on the same set arithmetic |
| unreachable branch rendered unconditionally | R68.7 | — |
| unreachable branch removed | R68.8 | `[R65.2]` and `[R73.4]` — they assert the same production copy from other fixtures |

**One dead seed, caught and recorded.** R73.5's first form reused whatever `DB.watch` held;
the ⚑ line renders only when a stage kills more than one candidate, that condition did not
hold, and the `!/biggest killers/` clause was satisfied by a line **not on the page**.
Seeding the word back changed the file and changed nothing observable — green, and
indistinguishable from proof. The fixture now forces three unpriced ids so the flag renders,
and the assertion **requires the ⚑ line before forbidding the word**, which is what stops
the negative clause going vacuous again.

**Three non-discriminating pairs are recorded rather than contrived away**, per the tenth
face: where two assertions rest on the same production expression, a seed in that expression
fails both, and that is the correct behaviour rather than a fixture defect.

### The measurement itself

The §2 proof is algebra over the cited lines and is independently checkable. Every
empirical figure was computed once, by this agent, from the two named sources; the ledger
figures **reproduce `POWER-2026-08-13-roi-floor.md` §2 and §3 exactly** (162 ROI item-days,
57 distinct, 14 sole; margin 134/52), which is an independent cross-check of the parsing
against a report written from the same file by a different route. The live-snapshot figures
have no second derivation and are a **single point in time** — the structural claims do not
depend on the snapshot, but the counts do. The nine unmeasured gates are named as
unmeasured rather than assumed inert; the six-gate restriction is stated with its direction
of error at the top.
