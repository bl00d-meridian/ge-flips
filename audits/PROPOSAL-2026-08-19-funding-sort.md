# A1 — RULED AND BUILT (Aug 19 2026). This is the proposal it was ruled from.

> **The user ruled A1 on Aug 19 2026: build it, with the nextUp reason work, and the NEXT UP header
> clause out in the same commit.** It is staged and awaiting the cold review; see `staging/PASS.md`
> repair 7 and `[R107.11]`/`[R107.12]`. The costing below is kept as written, because the reasons
> the other options were declined are the record of why A1 is what shipped.


**Directive 3, Aug 19 2026: *"THE FUNDING SORT IS A DEFECT AGAINST MY RULING, not a decision for
me."*** Recorded as such: the two-group split was ruled, and applying it after funding leaves the
sort that picks the seven slots ranking pool items on unfed terms defaulting to neutral. Nothing
here was built when this was written; A1 was ruled the same day and is now staged. The NEXT UP half was unambiguous and was built first.

## The defect, in the sort's own variables

```js
pass.sort((a,b) => (rank(a) - rank(b)) || (groupOf(a) - groupOf(b)) || (b.score - a.score));
```

`score = eMargin × max(1, horizonUnits) × (1 + min(wins,5)×0.1) × hw.w × stw.w × rel.w`

Four of those six are operator-history terms and **each defaults to exactly 1.0 when its input is
absent**. A tenured item's product of the four spans **0.34× to 2.91×** (the range the source
states). A pool item is pinned at **1.0× on all four**, because `wins` is 0 for an untraded item,
`hourWeight` returns `{w: 1, fed: false}` when no spark was ever fetched (and none is — `fillSparks`
iterates `DB.watch` and `DB.holds`), and `reliability` returns `{w: 1, fed: false}` below its trip
floor. So a pool item's score **is** its raw `eMargin × horizonUnits` core, and it lands in the
**middle** of the tenured field — not because the evidence says middling but because there is no
evidence and the default renders as average.

Two consequences, both in the sort's own terms:

- A tenured item carrying a 0.34× penalty — unreliable, drifty, wrong hour — sorts **below** a pool
  item with identical raw economics and no evidence at all.
- A tenured item carrying 2.91× sorts **above** a pool item with up to 2.9× better raw economics.

`planGroups` is called once, at render, on `picks` — the set already chosen and sized.

## Option A — fund from two sorted lists, with a stated allocation rule (**recommended**)

Split `pass` with the existing `planGroups`, sort each list on the key it already uses for display
(`score` for tenured, `planPoolSortKey` — the unweighted core — for pool and held), and walk both
against one shared slot and budget ledger.

**The allocation rule is the whole decision, and it is a strategy parameter.** Three shapes:

| rule | what it does | direction vs today |
|---|---|---|
| **A1 · tenured-first, pool fills the remainder** | fund tenured in score order until slots or budget run out; pool takes what is left | **strictly narrower** — a pool item can never displace a tenured one, which it can today |
| **A2 · tenured-first with a pool floor of K slots** | as A1, but K of the seven slots and a share of each tier budget are reserved for pool | **widens for pool, narrows for tenured** — net effect on what is funded is ambiguous and would need measuring |
| **A3 · fixed interleave** | alternate by rank at a stated ratio | same ambiguity as A2, with a less legible failure mode |

**A1 is the recommendation**, for three reasons. It is the only one of the three that is *strictly
restraining* relative to today, so it does not need a measurement to justify it. It makes the
display and the money agree, which is the state the ruling asked for. And it leaves A2 available
later, once the pool has a track record — a floor is a widening and widenings should follow
evidence, not precede it.

**What it costs, stated rather than implied:**

- `buildPlan`'s pass-1 loop becomes two walks over one ledger. The ledger itself (slots, `t1Pool`,
  `t2Pool`, `committed()`) does not change.
- **`nextUp`'s reasons change.** `whyKey` and the promote/demote picker blame a binding resource —
  *"plan is full"*, *"budget"*, *"cluster"*. With two lists, "full" has to say **which** list is
  full, or the picker offers demotions that cannot help. That is a daily-read surface and it is
  where the real work is.
- The header clause `[R107.7]` added to NEXT UP — *a group's position is not its place in the
  queue* — **comes back out**, because it would no longer be true.
- Assertions: the funding order across two populations is uncovered today, in both directions. The
  new ones are cheap once the split exists.

## Option B — normalize each item's score over the terms actually fed

The user named this and it is worth costing, because it is the one that looks cheapest and is not.

**"Normalize over the fed terms" has no honest form at the item level.** If an item has one fed
term with multiplier `m`, extrapolating to the other three (`m⁴`, or a geometric mean raised back
to four) **invents evidence** for the three that were never measured — the never-fed defect
committed a second time, in the repair for it. If instead the unfed terms are dropped from the
product, an item with no fed terms scores its raw core and an item with four scores its core times
a number that can be under 1 — which is the same incomparability, unchanged.

**The one form of B that is coherent is B1: change the unfed default.** A multiplier of 1.0 sits in
the middle of the 0.34–2.91 fed range, so "unknown" reads as "average". Defaulting an unfed term to
the **restraining end** would rank unknowns last, honestly, with no new machinery — it is a constant
per term.

**Its cost is that it answers a question nobody measured.** Setting the unfed default to 0.34 says
"an item with no operator history is worth as little as the worst-behaved item we have measured",
which is a claim about the market, not about the data. And it would make pool items close to
unfundable, which defeats the pool. **B1 is a strategy-constant change dressed as a bug fix**, and
that is exactly the class the constitution reserves for an explicit ruling with evidence behind it.

## What is NOT proposed

**Merging the two sorts, or adding a scorer term to either.** The source already calls that
deployment-class in as many words, and nothing found this session changes that.

## The ruling

**A1, ruled and built.** One thing the build found that this costing did not anticipate: making the
funding order a concatenation of the three groups left a **manual promotion unable to cross out of
its own group**, which silently removes a control the operator has today. Promoted items are now a
fourth group — which is also the only shape in which the render and the funding order stay the same
list, so the repair did not reintroduce the defect it exists to fix. Caught by the assertion written
for it (`[R107.12]`) before anything shipped.

**And the `nextUp` reason work turned out to fix something that was already wrong.** *"Any funded
pick can give up its slot"* is true only of the row at the HEAD of the queue; for every row behind
one, a demotion frees a slot the row ahead takes. That was true before A1 — the split is what made
it visible.
