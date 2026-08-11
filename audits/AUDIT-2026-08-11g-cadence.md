# Cadence-change impact audit — 2026-08-11g

**Report only. Nothing in this audit is fixed yet**, per the user's instruction, so the
rulings below can be made before any code moves. Scope: every mechanism that reads time,
sit duration, or visit rhythm, walked against the proposed four-touch schedule —
coffee ~07:00, lunch ~12:00, afternoon ~17:00, evening ~21:30.

Derived gaps: **5.0h · 5.0h · 4.5h · 9.5h**.

---

## 0 · Headline finding — the observation floor disqualifies the overnight strategy

This is the one that matters, and it is an interaction between two things that are each
individually correct.

`shadowTick` credits observation as `min(now − lastObs, SHADOW_OBS_CAP)` with the cap at
**10 minutes**. While the tab is closed, the entire gap collapses to one capped credit. An
overnight paper trip opened at the evening touch and closed by morning therefore accrues
**at most ~10 minutes of observation against a 9.5h horizon — about 1.7%**.

The observed-share floor (ruled today) excludes anything under 25%. So:

> **Every overnight paper trip will be excluded as "insufficient observation."**

The floor is not malfunctioning — it is correctly reporting that we did not watch the
night. But the consequence is that the paper book can never accumulate evidence for the
overnight sit, which is precisely the strategy the four-touch shape exists to enable. The
learning loop that would say "these thicker items fund at 10h" cannot run on paper; it can
only ever run on realized trips.

The floor also gets *harder*, not easier, in absolute terms — worth stating because the
request assumed the opposite. At today's 4h global horizon the floor is **60 minutes**.
Per-touch it becomes **75 min** (5h gaps), **67 min** (4.5h gap) and **142 min** (9.5h
overnight).

**Needs a ruling. Three options, no recommendation smuggled in:**

- **(a) Accept it.** Overnight evidence comes from realized trips only; the paper book
  stays a daytime instrument and says so. Cheapest, and honest, but it means the "qualifies
  at the evening touch" line can never be corroborated by the screen.
- **(b) Floor on the OBSERVABLE portion.** Measure observed share against the part of the
  horizon the app could plausibly have watched, not the whole span. Keeps overnight trips
  eligible, but redefines a metric mid-flight and weakens the floor's original claim.
- **(c) Exempt the overnight cohort with its own label** — not "insufficient observation"
  but "unobservable by construction", excluded from fill-rate verdicts while still
  counting for net. Preserves the distinction, costs a new state to explain.

---

## 1 · Visit/session clock — **mostly a non-finding, with one real consequence**

`VISIT_GAP_MS` and `markTouch` both use a 2h quiet gap. The tightest scheduled gap is
**4.5h**, so every scheduled touch rolls its own visit correctly. **The 2h convention
survives the four-touch shape unchanged** — no mis-segmentation, no fix needed. Two touches
inside 2h (nipping back to check a fill) still merge into one visit, which is the intended
behaviour.

What *does* change, exactly as anticipated:

- **The couch-minute denominator doubles.** `touchSessions()` counts `DB.touchLog.length`;
  four touches a day is 4 sessions instead of 2. `gp/min = realized ÷ (sessions × minutes-
  per-visit)`, so **at an unchanged minutes-per-visit the metric halves for the same daily
  gp.** That is arithmetically correct and directionally misleading: the number falls
  because attention is being *counted* more finely, not because it got worse.
  - The honest correction is the other half of the fraction: minutes-per-visit is a hand-set
    default, and four ~6-minute touches is not the same as two ~12-minute sittings. If the
    setting stays where it was, the metric double-counts the change. **This needs a ruling
    on the new per-visit minutes, and the panel should state the schedule it is dividing by.**
- **`touchSessions()` back-fills untracked historical days at ×2**, with the comment "the
  schedule was always two-touch". That stays correct for the past and becomes a stale claim
  as a general statement — worth a dated note rather than a change.
- **Per-visit dismissals get less sticky in wall-clock terms.** `ckDismissAt` returns the
  checklist next visit; that is now 4×/day rather than 2×. Correct by design, more frequent
  in practice.

## 2 · Paper book

- **Horizon per cohort** — currently one global `FILLH()` drives `shadowSizeFor`, the
  lifecycle horizon `H`, the dedup cooldown (`2 × FILLH`), and `shadowObsShare`. Trips must
  stamp the horizon in force at open and use it thereafter.
- **Do NOT retro-apply** — agreed and worth stating as a rule: open trips carry the horizon
  they were opened under. Legacy records without a stamp fall back to the old global, which
  is exactly what they ran against.
- **Forced-exit timing** moves with the horizon by construction once stamped: a daytime trip
  force-exits after 5h, an overnight one after 9.5h.
- **Aggregates must stamp and filter by horizon** (the addition to the request). A gate that
  looks too tight at 5h and fine at 10h is a *horizon* finding, not a gate finding, and
  blending them hides the distinction the schedule exists to create. This means a horizon
  facet on `shadowByGate`, the cohort ledger, the per-stratum map and the gate-health tree,
  plus a filter in the shared drill-down. **Note the volume cost:** the per-gate table
  roughly doubles in rows if horizon becomes a grouping dimension rather than a filter — I'd
  propose filter-by-default with the split visible on demand, but that is a ruling.

## 3 · Walk-up staleness ladders — **confirmed fine, with the reasoning**

Every ladder checked is expressed in **calendar days**, not visits, so touch frequency does
not move them: rulings snooze 3d, audit-card rest 7d, cluster-candidate staleness 14d,
scout-log retention 14d, sibling washout 5d, zombie rule 7d/3d, paper-book pruning 30d,
markout/relative windows 30d. The briefing reminders (7d/3d) are likewise day-based —
**confirmed as asked**.

The only visit-keyed states are the per-visit checklist dismissal and review engagement,
covered in §1.

## 4 · Seasoning — **qualifies roughly twice as fast; poll-driven, not visit-driven**

`updateQualStreaks` runs off **new price data** (gated on `S.latestAt|S.hourAt`), so it is
poll-driven — but a pass only counts when `now − lastAt ≥ QUAL_GAP_MS` (1h). A ~6-minute
touch therefore contributes **at most one pass**, making the streak *effectively*
visit-driven at this cadence.

`QUAL_GAP_MAX` is 12h: the 9.5h overnight gap still credits a pass, a missed day does not.

- Today (2 touches/day): ~2 passes/day → 3 passes spanning ≥2h takes **~1.5 days**.
- Four touches: ~4 passes/day → the same bar clears **inside one day**.

So seasoning gets about **2× faster** without anyone changing it. Whether that is right
depends on what the rule was buying: if it was "prove the edge is sustained across
sessions", four sessions in a day may satisfy it; if it was "let a day pass before
committing capital to something new", it no longer does. **Needs a ruling** — and the fix,
if any, is to express the span in touches or in calendar time rather than rescaling the
hours.

## 5 · Absolute-hour clocks that implicitly meant "one sit"

These are the ones that need to become horizon-relative rather than merely rescaled:

| Mechanism | Today | Problem under four touches |
|---|---|---|
| `staleBuyInfo` | `ageH > FILLH()` **or** `slot()` changed | `slot()` splits the day at a **hardcoded 15:00 am/pm boundary** — a literal two-touch convention. Under four windows it is simply wrong. |
| `ladderRung` | rung 1 at `1× FILLH`, rung 2 at `2× FILLH` | Must measure against the *leg's own* stamped horizon, or an evening leg hits rung 2 at 05:00 while still mid-sit. |
| quote-leg aging (`buyStale`, `sellRung`) | same constants, same `slot()` | Same fix, same stamp. |
| paper dedup cooldown | `2 × FILLH` | Relative already; follows once the horizon is per-placement. |
| touch-timing heatmap colour | amber ≤ `FILLH()` | Threshold silently changes meaning per touch; see §6. |

**Also found (not in the brief):** `limitWindows() = floor(DB.horizonH / 4)` = **2** at the
default 10h day horizon, and it multiplies the buy-limit cap in three sizing paths. A
5h daytime placement can only roll **one** 4h buy-limit window, not two. **Daytime sizing on
buy-limit-bound items is currently overstated by up to 2×.** This is the most concrete
"tuned for a long sit, misbehaves at 5h" case in the audit, and it is a real capital
consequence rather than a display one.

## 6 · Hours ledger and touch-timing heatmap — the question changes

Both were built to answer *"when should I touch?"*. With four fixed windows the question
becomes *"which of my four windows is most productive, and what should each one carry?"*.

- The heatmap's closing line literally says **"aim the touches there"** — advice that no
  longer applies to a fixed schedule. It should instead score the four windows against each
  other, and its amber threshold should read the applicable gap rather than one constant.
- The hours ledger's overnight finding ("this is the case for sizing the standing overnight
  book heavier") stops being a proposal and becomes **directly actionable**: the evening
  touch is the overnight book. Worth reframing from "consider" to "this is what the evening
  touch is for", and worth pairing with §0 — the market stream can support that claim
  overnight, the paper stream cannot.

## 7 · Anything else

- **Drift-risk bench** reads "a long gap before this visit predicts a long gap after it"
  from `lastWalkupAt()`. With gaps shrinking from ~12h to ~5h, this gate will fire markedly
  less often. Probably correct — the sits genuinely are shorter — but it is a silent
  loosening of a bench, and silent loosenings deserve to be named.
- **Copy that assumes an ad-hoc schedule**: the fast-cycler note ("worth a midday re-arm
  when you're around") and the sizing panel's "buy limits still roll every 4h across the day
  horizon" both need to speak in terms of the schedule.
- **`DB.fillHorizonH` becomes vestigial** as a primary input. Recommend keeping it as the
  fallback for an unusable schedule and as the floor under a pathologically short gap,
  clearly labelled as such rather than deleted.
- **`DB.horizonH` (10h "hours the offers sit before the evening touch")** is now derivable
  from the schedule — keeping both invites them to disagree.

---

## Constants that would move

| Constant | Now | Under the schedule |
|---|---|---|
| Fill horizon | one global, default 4h | 5.0 / 5.0 / 4.5 / 9.5h, per placement |
| Observation floor (25%) | 60 min | 75 / 75 / 67 / 142 min |
| Buy-limit windows | 2 (from 10h day horizon) | 1 daytime, 2 overnight |
| Stale-buy boundary | 15:00 am/pm split | next scheduled window |
| Ladder rungs | 1×/2× of the global | 1×/2× of the leg's stamped horizon |
| Seasoning span | ~1.5 days at 2 touches | <1 day at 4 touches (unchanged rule) |
| Couch-minute denominator | 2 sessions/day | 4 sessions/day |

## Rulings needed before the build

1. **§0** — which of (a) accept, (b) floor on the observable portion, (c) an "unobservable
   by construction" state, for overnight paper trips.
2. **§1** — the new minutes-per-visit, so the couch-minute metric does not halve for a
   bookkeeping reason.
3. **§4** — whether seasoning qualifying ~2× faster is acceptable, or whether the span
   should be re-expressed in touches or calendar days.
4. **§2** — horizon as a drill-down *filter* (my inclination) versus a grouping dimension
   that splits every per-gate row.

---

# Build report — what actually moved

Built after the rulings. All eight assertion families proven by seeding their defect;
both viewports green; 172 requirement ids, zero REQ FAIL.

## Constants that moved

| Constant | Was | Now |
|---|---|---|
| Fill horizon | one global, `DB.fillHorizonH` (default 4h) | the gap to the next touch — 5.0 / 5.0 / 4.5 / 9.5h. The global survives as the fallback for "no cadence kept" |
| Buy-limit windows | `floor(DB.horizonH / 4)` = **2**, always | `floor(applicable gap / 4)` — **1** daytime, **2** overnight |
| Stale-buy boundary | hardcoded 15:00 am/pm split | the next scheduled window, per leg |
| Ladder rungs | 1× / 2× of the global | 1× / 2× of the **leg's stamped** horizon |
| Observation floor (25%) | 60 min against a 4h global | per trip: 75 min daytime, 142 min overnight |
| Seasoning | 3 passes, ≥2h span, one per hour | 3 passes, one per **touch**, spanning ≥1 **calendar day** |
| Attention denominator | sessions × one global minutes figure | per-touch minutes (6/6/6/10), summed |
| Day capacity (slot-hours) | `DB.horizonH` constant | sum of the schedule's gaps |
| Forced-exit price | the instasell at the moment we noticed | the **series value at the horizon** |

## Nothing else tuned for a 14h overnight was found misbehaving

The sweep for constants dividing by a hardcoded 4h or assuming two touches turned up
exactly the two the audit had already named (`limitWindows`, `staleBuyInfo`'s 15:00 split)
plus three that were display-only and are now horizon-aware: the touch-timing heatmap's
amber threshold, the slot-hour capacity figure, and the sizing panel's copy. Every
remaining `FILLH()` call site is a *planning* site and correctly reads the applicable gap
now that `FILLH` is the schedule's gap. Two sites needed the leg's own horizon instead and
got it: paper-trip observed-share and the aging ladder.

## The reconstruction backstop, and what it does not claim

The replay is the same model, and the honesty rules are the interesting part. Credit is
**series coverage** — a 5m bucket with data is five observed minutes, a bucket without
credits nothing, and coverage stops when the trip closes, because a closed trip's later
buckets are not part of its life. Provenance is stamped, and an aggregate built only from
reconstructed trips says so where it renders: reconstruction reads 5m buckets after the
fact and cannot see intra-bucket sequencing, so it is the same model on weaker evidence,
not the same evidence.

Forced exits now price at the series value **at the horizon** rather than at the moment we
noticed. That is the proper fix for the defect that caused the epoch reset — it was
booking hours of price drift as simulated P&L — and it is correct on a perfect host too,
which is why it applies to all trips rather than only reconstructed ones.

## Interrogability scan

No new findings. The two new aggregate dimensions (horizon shape, evidence grade) render
as row-level facets that carry into every existing drill-down rather than as new
un-openable numbers, and the per-trip rows gained `Horizon` and `Evidence` columns so an
expansion explains its own grouping. The recovery log surfaces as a WHAT CHANGED event
that links to the cohort panel.

## Unchanged, and asserted so

Gates, floors, reserve and budgets — cadence is not edge. The walk-up attention count is
still ≤ 7 and still probe-asserted. Existing open paper trips keep the horizon they were
opened under; nothing was retro-applied.
