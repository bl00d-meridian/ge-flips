# Above the T2 ceiling in the control cell — 2026-08-18

**Report only.** Tier bands are a strategy parameter and move on your explicit instruction;
this is the evidence for that ruling, not a proposal. **The sub-400 band is deliberately
not discussed** — the constraint there is notional per touch and fill time, not capital, and
more capital makes it worse.

## The population, and its base

| | |
|---|---|
| control-cell items **above the 100k ceiling** | **4** |
| trip-observed control items | 38 |
| the cell's distinct-ever stock | 292 |
| **so this is a 13% sample of the stock, not a census** | |

**Stated because it bounds what this can support:** the export carries no id roster, only
trip rows, so these four are the above-ceiling items that happened to carry trips in the
carried window. The true count over the full 292-item stock is unknown and is very likely
higher. **Four is a floor, not a measurement.**

## The four

| item | id | buy | margin | ROI | limit | notional at full limit | breadth | sim lifecycle states |
|---|---|---|---|---|---|---|---|---|
| **Old school bond** *(tax-exempt)* | 13190 | 11,742,386 | 257,502 | **2.19%** | 100 | 1,174,238,600 | **16 of 16** | open ×18 |
| *(id 30443 — closed-window row, name not carried)* | 30443 | 672,923 | 99,714 | **14.82%** | 1 | 672,923 | **16 of 16** | unobserved ×9 |
| **Dragon pickaxe upgrade kit** | 12800 | 600,124 | 66,276 | **11.04%** | 50 | 30,006,200 | **16 of 16** | open ×9 |
| *(id 19478 — closed-window row)* | 19478 | 555,377 | 38,185 | **6.88%** | 8 | 4,443,016 | **16 of 16** | unobserved ×9 |

**Price range: 555,377 – 11,742,386.**

## The reading that actually matters

**All four carry breadth 16 of 16 — every cell in the grid funds them.** These are not
items a loose corner admits; they are items *every configuration in the sweep agrees on*,
excluded from the allocator by a price band and nothing else. That is a different and much
stronger structural signal than the marginal v500 population, which no cell agrees on and
which decomposes net-negative.

**Persistence: not yet available, and the reason is dated.** The per-item pool-persistence
store (`DB.poolSeen`) ships in this same commit and is empty until the app next runs, so
there is no funded-of-observed pair for these four. **Breadth is the only durable structure
metric the export carries**, and it is unanimous. The persistence pairs arrive with a few
days of accrual and I will report them then rather than substituting a session count for a
durable one.

**Sim fill outcomes are uninformative here and I am not going to dress them up.** Two items
show `unobserved ×9` — the app was closed across their horizon — and two show `open ×18`
and `open ×9`, trips placed at the export's own boundary that have not resolved. **Not one
above-ceiling item has a `filled` outcome in a bucket the instrument watched.** The sim
cannot speak to this population yet, which is the same limitation the v500 marginal set had
and for the same reason.

## The capital arithmetic you asked for

The ceiling was set against a **~22M working stack**; the stack is now **~162M working
against a 460M bank**.

| | one-third of the stack (the sizing clamp) | above-ceiling items that fit whole |
|---|---|---|
| **at ~22M** (when the ceiling was set) | 7,333,333 | **2 of 4** |
| **at ~162M** (now) | 54,000,000 | **3 of 4** |

The one that still does not fit is **Old school bond**, at 1.17bn notional against its full
100-unit limit — and it does not need to: the clamp would size it to roughly 4 units at the
current stack, which is a real position rather than a rejected one. **So on the capital
argument, the ceiling has stopped binding for reasons of capital on 3 of 4 and sizes the
fourth sensibly.**

**What that does and does not establish.** It establishes that the ceiling's *original
capital rationale* has weakened by roughly 7×. It does **not** establish that the band
should move: the T2 ceiling also carries a thinness argument (a 555k–11.7m item's book is
structurally thinner in units), and the fill evidence that would test that argument does not
exist yet — see the sim outcomes above. **The capital half of the case is measurable and has
changed; the fill half is not measurable yet.**

## Context, in a clearly different population

Across the **whole frontier** — every cell in the grid, most of them looser than the control
— **146 of 419** trip-observed items sit above the ceiling. That figure is *not* about your
post-cutover pool and must not be read as though it were; it is here only to show that the
above-ceiling region is large in the universe generally, so the control's 4-of-38 is a
statement about the control's tightness rather than about the market's shape.

## What would make this rulable

1. **The persistence pairs**, after a few days of `DB.poolSeen` accrual — do these four keep
   qualifying, or are they occasional?
2. **A fill outcome that is not `unobserved` or `open`** on at least one of them.
3. **The full above-ceiling count over the 292-item stock**, which needs either the id
   roster in the export or a surface that enumerates it. Currently neither exists — the
   4-of-38 sample is the honest ceiling on what I can say.
