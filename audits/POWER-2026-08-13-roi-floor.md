# Power check — ROI floor loosening experiment

> ## ⚠ CORRECTED 2026-08-13, and the experiment it supports is CLOSED
>
> Read `audits/SURFACE-2026-08-13-gate-interaction.md` before this file. The correction is
> not a detail; it inverts two of this report's conclusions and the user has struck both.
>
> **§3 — the 74% sole-blocker figure is 0% by construction.** `DB.gateLog` stores
> `fails[0]`, the HEADLINE gate. A candidate-day carrying one gate means *the headline
> never changed that day*, not *one gate was failing*. And the ROI floor **cannot** be a
> single-gate failure for any taxed item at any price: the margin gate's tax limb enforces
> a sustained-ROI floor of `0.06/0.92` = 6.52%, so all 2,358 live items that fail the ROI
> floor also fail the margin floor. On this file's own ledger, **127 of the 162 ROI-floor
> candidate-days also carry a margin-floor row** — the headline flipping within the day.
>
> **§3 — "the volume floor is never the sole blocker … loosening it would free nothing" is
> inverted.** It is the most common true sole blocker in the product (280 items market-wide,
> 66 of 132 paper trips). It reads as never-sole here because it sits second-to-last in the
> chain and can therefore almost never be a headline.
>
> **§5 — the "contradiction between two populations" is resolved, against this ledger.**
> The paper book's `benchedBy` is the BINDING gate (set only on a single-gate near-miss);
> the ledger's "sole blocks" are headline runs. They are exact inverses because of chain
> position, and were never in conflict — one of them was not measuring what its name says.
>
> **§4 — the stated mechanism is wrong, though the conclusion holds.** The watchlist path
> does **not** "screen at the full 1.2% floor"; it applies no ROI screen at all. Zero band
> trips is not a cohort-sampling artefact: no entry path can admit a band item, because
> every one carries two gate failures and every path requires a clean pass or a single-gate
> near-miss. The scanner cohort is not eligible either. See M151.
>
> **§6 and §7 are overtaken.** Adding `v` to the ledger row shipped and was the right call,
> but the question it was to answer is closed: loosening `GATE.roi` to 1.0% admits **0 of
> the 41 live band items**, by arithmetic rather than by an absence of opportunity.
>
> **What survives:** §1 (the ledger cannot see the band), §2's counts as *headline*
> attribution, and §4's measured 118/14 cohort split. Neither constant has moved.

2026-08-13 · retrospective, from stored data · **no edit made, nothing started**

Ordered by the user on 2026-08-13 as a precondition to the ROI-floor loosening
experiment: *"distinct items benched by the ROI floor with sustained ROI in [1.0, 1.2)
per OBSERVED day"*, plus the same count for the margin floor and the volume floor, so the
gate that is actually excluding candidates can be seen rather than guessed.

---

## Source and coverage

| | |
|---|---|
| Source | `inbox/ge-flips-2026-08-13 (1).json` — localStorage state backup |
| File age | **unknown** — the backup carries no `generatedAt` |
| Ledger recency | `DB.gateLog` max date is **2026-08-13**, and `DB.obsDays` includes today, so the ledger content is current regardless of the file stamp |
| Observed days | **4** — 2026-08-10, 08-11, 08-12, 08-13 |
| `DB.obsDays` stamps | 2 (08-12, 08-13) — the explicit stamp was added Aug 12 |
| Observed set used | union of `obsDays` and ledger dates, per `observedDaySet()` — the retroactive rule for stores predating the stamp |
| `gateLog` rows | 689 total, **648** after excluding `funded` / `seasoning` / `die-off detected` |
| Candidate-days benched by ≥1 gate | 184 |

**Three of seven days in a 7-day window were not observed. No claim is made about them.**

---

## 1. What the ledger can and cannot answer

`DB.gateLog` rows are `{d, id, g}` — date, item, gate name (`index.html:1274`, written at
`index.html:4584`). **The ROI value at bench time is not recorded.**

Consequence: the count as literally ordered — items benched by the ROI floor *with
sustained ROI in [1.0, 1.2)* — **is not answerable from stored data.** A row saying "ROI
floor" means `eRoi < 1.2%`; it cannot distinguish 1.19% from 0.2%.

Everything below is therefore an **upper bound** on the band population, and the band
fraction is reported as unmeasured rather than estimated. This is a third outcome to the
two the ruling pre-declared, and it is filed as its own outcome rather than forced into
either — an absence must not be filed as an ambiguity.

---

## 2. Per-gate bench counts — 4 observed days

| Gate | distinct items | item-days | days present | items benched on **all 4** days |
|---|---:|---:|---:|---:|
| **ROI floor** | **57** | **162** | 4 | **18** |
| margin floor (ticks / 3× tax) | 52 | 134 | 4 | 10 |
| chart still loading | 44 | 85 | 4 | 2 |
| flow imbalance | 36 | 78 | 4 | 3 |
| **volume floor** | **32** | **61** | 4 | **4** |
| book skew | 19 | 36 | 4 | — |
| trend | 17 | 36 | 4 | — |
| momentum | 15 | 22 | 4 | — |
| plan gate | 12 | 17 | 4 | — |
| volume trend | 4 | 5 | 3 | — |
| fill history | 3 | 5 | 3 | — |
| proven-loser bench | 2 | 6 | 4 | 4 |
| blacklist | 1 | 1 | 1 | — |

The ROI floor benches more distinct items than any other gate, and 18 of them on every
observed day — which clears `GATE_PERSIST_DAYS = 4`, the bar that moves gate constants.

---

## 3. Sole blocker — the user's stated criterion

> *"The gate that benches the most items with otherwise-passing candidates is the one
> worth an experiment."*

A candidate-day is **sole-blocked** when exactly one gate benched that item that day.

**How many gates bench a candidate at once:**

| gates benching | candidate-days |
|---:|---:|
| 1 | 19 |
| 2 | 54 |
| 3 | 23 |
| 4 | 25 |
| 5 | 34 |
| 6 | 22 |
| 7 | 6 |
| 8 | 1 |

**Sole-blocked candidate-days, by gate — 19 in total:**

| Gate | sole candidate-days | distinct items | share of all sole blocks |
|---|---:|---:|---:|
| **ROI floor** | **14** | **11** | **74%** |
| margin floor (ticks / 3× tax) | 2 | 2 | 11% |
| proven-loser bench | 2 | 1 | 11% |
| book skew | 1 | 1 | 5% |
| **volume floor** | **0** | **0** | **0%** |

**The rows behind the 14** (names resolve only where the item appears elsewhere in the
store; the ledger stores ids):

| itemId | name | sole on |
|---|---|---:|
| 3144 | *(name not in store)* | 2 days |
| 29280 | *(name not in store)* | 2 days |
| 1135 | *(name not in store)* | 2 days |
| 2501 | *(name not in store)* | 1 day |
| 2503 | *(name not in store)* | 1 day |
| 219 | *(name not in store)* | 1 day |
| 205 | *(name not in store)* | 1 day |
| 105 | *(name not in store)* | 1 day |
| 12383 | *(name not in store)* | 1 day |
| 19933 | Saradomin d'hide boots | 1 day |
| 12492 | *(name not in store)* | 1 day |

**The volume floor is never the sole blocker.** It benches 32 distinct items, and every
one of them was also benched by something else the same day. Loosening it would free
nothing — a clean negative result, and the reason to test it is now gone.

---

## 4. The cited evidence cannot see the band

The experiment's §1 rests on: *"Current and loose regimes were IDENTICAL in the paper book
… no trip between 1.0% and 1.2%."*

The paper book stores regime membership per trip (`regimesFor()`, `index.html:3070`), so
this is directly checkable. Of **132** stored paper trips:

| regimes carried | trips |
|---|---:|
| current + loose + tight | 125 |
| current + loose | 7 |
| **loose but NOT current (= the [1.0, 1.2) band)** | **0** |

Zero band trips — the premise holds on its face. But **every one of the 132 carries
`current`**, meaning no trip below the 1.2% floor has ever entered the book. And the
`benchedBy` distribution confirms it:

| benchedBy | trips |
|---|---:|
| volume floor | 66 |
| margin floor (ticks / 3× tax) | 50 |
| momentum | 5 |
| fill history | 3 |
| trend | 3 |
| *(none)* | 2 |
| book skew, proven-loser bench, flow imbalance | 1 each |
| **ROI floor** | **0** |

**Not one ROI-floor-benched item has ever entered the paper book**, while the live ledger
records 57 distinct ones over the same four days.

The mechanism, as far as the code supports: only the **scanner** cohort screens at the
loose floor — `scanScreenTier(t, SHADOW_LOOSE, PAPER_HORIZON_H)` at `index.html:6316`,
where `SHADOW_LOOSE = 1/1.2` puts the screen at exactly 1.0%. The scanner cohort is **14
of 132 trips**. The other **118** carry no cohort and come through the watchlist path,
which screens at the full 1.2% floor and therefore cannot contain a band trip by
construction. The scanner path is additionally capped at `SHADOW_SCAN_TOP = 8` opens and
`SCOUT_EVAL_PER_TIER = 12` full evaluations per tier per cycle.

**This is the never-fed-aggregate defect.** The regime race reports "current ≡ loose" not
because the regimes are equivalent but because 89% of its population came through a path
that cannot differentiate them, and the one path that can has contributed 14 trips and no
ROI-benched item at all. An aggregate whose input population is empty must say so.

*Rendering it as a two-way tie is the reported defect; the fix is not proposed here.*

---

## 5. A contradiction between two populations, unresolved

Both of these describe "the only thing stopping this item", and they disagree:

- **Paper book `benchedBy`** — near-miss admissions, so each is by definition a
  single-gate failure: **volume floor 66**, margin floor 50.
- **Live gate ledger sole blocks** — **volume floor 0**, margin floor 2.

Different populations sampled at different times by different code paths, so they are not
pooled here and no combined figure is given. But they are the same concept computed twice,
which is the shape `failProfile()` was extracted to prevent (`index.html:3046`, the funnel
vs slice disagreement). **Reported, not pursued** — out of scope for the power check.

---

## 6. What the rate implies for 8 trips in 14 days

| | |
|---|---|
| Sole-blocked ROI candidate-days | 14 over 4 observed days = **3.5 / observed day** |
| Distinct items sole-blocked by ROI | 11 over 4 observed days = **2.75 / observed day** |
| Naive 14-day projection | ~38 sole-blocked candidate-days |
| **Fraction of those in [1.0, 1.2)** | **UNMEASURED — the ledger does not record the value** |

The gate-level rate is **not** ~0/day, so the ruling's stated abort branch does not fire.
But the band-level rate — the number that actually decides whether the experiment can
reach 8 trips across 4 distinct items — is unmeasured, and the only population that
records band membership is structurally unable to contain a band member.

Two further constraints already flagged and unchanged: `minExpectGp` resolves to ~90,000
gp/cycle on the stored 60m/30m tier budgets (`index.html:4392`), which at 1.0% ROI and
half sizing needs ~18m of full-size notional to clear; and the other gates still bind, so
a band item is fundable only if the ROI floor was its sole blocker.

---

## 7. Recommendation, unapplied

**Add the gate's own value to the ledger row.** `DB.gateLog` rows become `{d, id, g, v}`,
where `v` is the `have` figure the gate already computes and already renders in its bench
copy (`chk(...)` passes `{ have: eRoi, need: GATE.roi, short: ... }` at
`index.html:4080-4083`). The number exists at write time and is discarded.

- It is a **measurement, not a deployment** — it widens nothing the allocator may fund.
- It is the same ruling already made for the trip stamp: **record the value, never a
  boolean**, so band membership derives from data rather than from window membership.
- After 3–4 observed days it answers the ordered question exactly, and it makes any future
  INCONCLUSIVE attributable to a named cause rather than to "no opportunities."
- It retro-fixes nothing: existing rows keep `v` absent, which reads as *unmeasured*, not
  as zero. **`v` must be read with `!= null`, never truthily — a gate value of 0 is
  legitimate** (a 0% ROI item is benched by the ROI floor with `have: 0`).

**Do not start the experiment on the current evidence.** The gate choice is well
supported — the ROI floor is the most active gate in the book and 74% of all sole blocks —
but the reason given in §1 is inverted, and the number that decides feasibility does not
exist yet.

---

## Verification status

Every figure above was computed by the agent directly from the stored JSON, single-pass,
and **not independently re-derived**. The derivations are deterministic and re-runnable;
the schema readings (`gateLog` shape, `regimesFor` semantics, the `SHADOW_LOOSE` screen)
were each confirmed against the code at the cited lines. The mechanism in §4 is stated as
far as the code supports it and no further: the 118/14 cohort split is measured, the
ranking-cutoff contribution is not.
