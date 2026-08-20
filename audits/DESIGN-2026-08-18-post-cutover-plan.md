# Design — 2026-08-18: the post-cutover plan surface

**Propose only. Nothing here is built and nothing here moves a constant.** Written ahead of
the cutover ruling so the ruling covers presentation as well as the pool switch. Evidence
throughout is `inbox/analysis-scorer-2026-08-18.json` and a read of the live chain in
`index.html`.

**Read the companion first where they overlap:**
`audits/READING-2026-08-18-scorer-grid.md` §1.4 (the control cell's verdicts are six-gate
verdicts while chart gates stand at 3.9 of 7 observed days) and §4.2 (the breadth
denominator's partition question). Both bear directly on §2 and §4 here.

---

## §0 · The answer to question 4 first, because it frames everything else

The line is **at the code, not at the intent**: if `buildPlan`'s output *ordering* or
`planQty`'s output *size* changes as a function of scorer data, it is deployment-class.
Rendering a number is display; letting that number change what you press is not.

| | rides the cutover's deployment gate | display-only |
|---|---|---|
| **the pool switch itself** (`planCandidates` reading the control cell) | ● | |
| any change to the plan's sort expression | ● | |
| any pin, promotion or slot priority derived from scorer data | ● | |
| any sizing input from scorer data (persistence-weighted, breadth-weighted) | ● | |
| admitting an item today's chain would bench, or skipping a gate for pool items | ● | |
| the fix to `DB.qual`'s prune (§1.1) — it decides what may be funded | ● | |
| the per-item badge and every state it renders | | ● |
| the badge's drill and everything inside it | | ● |
| the six-gate qualifier on the badge | | ● |
| the rdiff transitional mark | | ● |
| the bench-reason copy for pool items | | ● |

**Everything I propose in §2 and §3 is in the right-hand column by construction.** That is
deliberate: the badge should be buildable and rulable ahead of the cutover, so the pool
switch arrives at a surface that already reads correctly rather than dragging a display
design through a deployment gate.

---

## §1 · The plan with a control-cell pool

### §1.1 Three structural facts that come before any design

These are not preferences. Two of them are blockers and the third resets what the plan page
looks like.

**(a) `DB.qual` is pruned to watchlist membership, every cycle.** `updateQualStreaks` ends
with:

```js
for (const id of Object.keys(DB.qual))
  if (!DB.watch.some(w => w.id === +id)){ delete DB.qual[id]; dirty = true; }
```

A control-cell item is not in `DB.watch`. Its streak is created and deleted on every pass.
**No pool item can ever season, so the plan funds nothing — permanently, silently, and with
a bench reason that reads "qualifying" rather than "impossible".** This is a one-line
blocker sitting directly on the money path, and it is exactly the seam-inventory shape: a
store whose retention key is one subsystem's membership, read by a gate that decides
funding in another.

**(b) Even with (a) fixed, seasoning imposes a one-calendar-day floor on every new
entrant.** `QUAL_PASSES = 3`, one counted pass per touch window, and `qualSpanned` requires
a **calendar-day rollover** — four touches must not buy same-day qualification. The frontier
churns: stage 0 measured an intersection of 27 against a union of 171 across two snapshots,
so a snapshot understates the population roughly 6×. A large fraction of the pool is a
first-cycle entrant at any moment. **After the cutover, seasoning becomes the dominant bench
reason.**

**(c) Two thirds of the control cell's items are outside the allocator's bands.** Of the 38
control-cell items observed in this export's trips:

| | n | share |
|---|---|---|
| under 400 gp — untiered, too cheap to band | 21 | **55%** |
| T1 (400–5k) | 12 | 32% |
| T2 (5k–100k) | 1 | 3% |
| over 100k — untiered, above the T2 ceiling | 4 | 11% |
| **reachable by the allocator (T1 + T2)** | **13** | **34%** |

Applied to the cell's measured flow of **9.09 funded items per cycle**, that is roughly
**3.1 fundable per cycle**, before seasoning, the family rule, budgets or exposure. **That
extrapolation rests on 38 items, not on the 292-item stock** — the export carries no id
roster, so the tier mix is measured over the items that happened to carry trips in the
carried window. It is enough to say the majority of the pool is outside the bands; it is not
enough to rule a band on. And of those 13, **10 carry a notional at full buy limit over
3m**, so the one-third-of-working-capital clamp binds on most of them.

**The pool switch relocates the binding constraint from admission to tiering and
seasoning.** That is the single most useful sentence about the post-cutover plan, and it
means the interesting bench reasons on the new plan page are not market gates at all.

*(Caveat on (c), stated because the ROI column would otherwise read as exact: figures are
reconstructed from each trip's stamped `bid`/`ask`, which are placement prices one tick
inside the book. The gate judged on `eMargin = min(live, 1h-sustained)`, so reconstructed
margin is an upper bound; seven of the 38 are tax-exempt and handled as such; three
unnamed ids could not be checked for exemption.)*

### §1.2 How the pool sorts — **proposal: it does not, and the two populations do not share a list**

Today: `pass.sort((a,b) => b.score - a.score)`, where

```
score = eMargin × horizonUnits × (1 + min(wins,5)·0.1) × hourWeight × stabilityWeight × reliability
```

Four of those six terms are operator-history terms. A control-cell item supplies none of
them, and each defaults to a neutral weight:

| term | source | range | a pool item gets |
|---|---|---|---|
| `(1 + min(wins,5)·0.1)` | flip log lifetime net | 1.0 – 1.5 | **1.0** |
| `hourWeight` | per-item `/timeseries` sparks | 0.7 – 1.3 | **1.0** |
| `stabilityWeight` | sparks (daily wander vs margin) | 0.7 – 1.15 | **1.0** |
| `reliability` | flip log, 30d window | 0.7 – 1.3 | **1.0** |

A watchlist item with history spans roughly **0.34× to 2.91×** on those four multipliers. A
pool item is pinned at exactly **1.0×** on all four. So a single ranked list places every
pool item in the middle of the watchlist items — **not because the evidence says middling,
but because there is no evidence and the default renders as average.** That is the
never-fed-aggregate rule at the score level: a weight of 1.0 from no data and a weight of
1.0 from balanced data are indistinguishable in the ordering and mean opposite things. An
unproven item outranking a drifty one is a claim about drift that nothing measured.

**Proposal: two ordered groups on one page, never one interleaved list.**

1. **Tenured** — items with an operator history (a flip in the reliability window, or
   sparks). Sorted by `score` exactly as today. Nothing changes for them.
2. **Pool** — control-cell items with no history. Sorted by the *unweighted* core,
   `eMargin × horizonUnits`, which is the part of `score` that is actually computed for
   them, with the header saying so in those words: **"sorted by expected gp per horizon —
   the history weights are not fed for these items and are not applied."**

The groups render in that order, and the group header is the disclosure. No composite
across them, no interleaving, and no scorer term enters either sort. **This is display-only
by construction** — the sort *within* each group is an existing expression evaluated on the
information it actually has, and the split is a rendering decision. Merging the two groups,
or adding a scorer term to either sort, is deployment-class and is not proposed.

### §1.3 Proposed versus benched, with reasons

The plan already renders bench reasons per item and already has the funnel. What changes is
the **shape of the reason distribution**, and the surface should say so rather than letting
the reader discover it:

Expected top bench reasons after the cutover, in order:

1. **untiered** — ~66% of pool items (§1.1c). Reason copy already exists and already names
   the band and the override path; it will simply become the most common line on the page.
2. **seasoning / qualifying** — every first-cycle entrant, for at least one calendar day.
3. **chart still loading** — until chart gates reach 7 of 7 observed days, **99.5% of pool
   items** (the six-gate era; companion §1.4). This one must not be allowed to ship as a
   silent bench: it is not a property of the item, it is a property of the archive's clock,
   and the copy has to say which.

**Proposal: the pool group's bench pile leads with a one-line composition summary**, in the
`rateBlend` spirit — *"N pool items benched: X untiered, Y seasoning, Z waiting on chart
coverage (3.9 of 7 observed days)"* — with the existing drill opening to the rows. That is
one line, it is a decomposition rather than an aggregate, and it prevents the most likely
misreading of the new page, which is *"the scorer found 292 items and the plan funds three,
so something is broken."*

### §1.4 Pins — **proposal: a mark, with the existing promotion mechanism unchanged**

After the cutover the watchlist stops being the *pool* and becomes, at most, the *pin list*.

**Pins get no new priority.** Priority is ordering, ordering is deployment-class (§0), and a
pin that jumps the queue reintroduces exactly the per-item admission decision the cutover
exists to remove. The existing manual-promotion path (`DB.planPriority`, reset daily with
the checklist) already does this, is already ruled, and is already the user's press — it
should carry over untouched and nothing new should be added beside it.

**What a pin should do:** render as a mark on the row, and place the item in the **Tenured**
group regardless of history, because a pin *is* the operator asserting tenure. That is a
grouping decision, not an ordering one, and the group header already declares what its sort
means.

**And the third state, which is the one that will actually come up:** a pinned item the
control cell does **not** fund. It is in the plan by the pin and by nothing else. It must
say so — *"pinned by you; the control cell does not fund this item today"* — with the fail
set available in the drill. That is the entity-with-no-state rule: a pinned item rendering
identically to a pool item is a hole where a reason belongs.

### §1.5 The walk-up budget

**It is not threatened by pool size, and it is threatened by exactly one thing.**
`walkupDecisionCount()` is `min(pendingRulingItems, rulingsCap) + briefingReminder +
reviewReady`. **Plan lines have never counted against it** — they are execution steps, not
rulings. A 292-item stock funding nine per cycle adds zero decisions.

What would blow it instantly: **any per-item admission prompt.** One "admit this item?"
ruling per new pool entrant, against a frontier that churns ~6× a snapshot, is dozens of
decisions per walk-up. **So the standing constraint on this whole design is one sentence:
the pool proposes and the user presses to log a flip; there is no per-item admission
question, ever.** Any future proposal that adds one has to displace something, and there is
nothing in the walk-up cheap enough to displace.

---

## §2 · The per-item badge

Constraints taken as binding: **a signal, never a composite**; **no ranking language while
capture is ungraded**; **opens to its rows**.

### §2.1 The pattern it inherits

The paper-book dot is the precedent and the design should not invent a second one: a
**fixed slot** that holds its place whether or not a glyph renders, one glyph, the numbers
in the tooltip, a distinct **accruing** glyph below the verdict threshold so a working
machine is never silent, and the term registered through `glTerm` so the popover and the
glossary cannot drift. Two slots, two independent signals, no arithmetic between them.

### §2.2 What renders at the row — two slots

**Slot A — persistence.** `funded n of obs observed cycles since this item entered the
pool.`

Why this one at the row, and not breadth: **persistence is a property of the item;
breadth is a property of the config grid.** The row is the trader's surface and the
question there is *"does this item keep qualifying?"*. Breadth answers *"how sensitive is
this verdict to my configuration?"*, which is the instrument-tuner's question and belongs
on the Scorer. Persistence also needs no capture grading — it counts gate verdicts, not
simulated economics — so it is sayable today in a way that nothing fill-derived is.

**It renders as a pair, never as a percentage alone** — the `daysBenchedBy` construction.
`93 of 108` and `93%` are different claims and only the first is rulable. A percentage may
render *beside* the pair, never instead of it.

**Slot B — pump exposure.** The existing ⚑, already live on the frontier browser, at the
row.

Why this one: it is the only **restraint** signal in the available set, and restraint is the
one thing that may render without ceremony — a false caution costs an absence, a missing one
costs whatever the pump extracts. It is also already stamped at trip birth and already
glossed. It is not a quality signal and must not be styled like one.

**Nothing else renders at the row.** Two slots, two glyphs, no third.

### §2.3 What lives behind the drill, and why each is not at the row

| signal | why it is not a row badge |
|---|---|
| **cell breadth (M of the grid)** | a property of the config grid, not the item — and its denominator is about to change from 16 to 20 (companion §4.2). A grid-shaped number on a trading row invites reading it as quality. Its glossary `aka` currently hardcodes "16" and would be wrong the day the grid grows |
| **fill outcomes at each capture point** | three lifecycles, and capture is **ungraded**. A row cannot show three numbers without compositing them, and showing one is a choice presented as a fact. This is the clearest "no ranking language" case in the set |
| **hour-band presence** | a 24-vector. It is genuinely useful and it is a drill, not a glyph |
| **rdiff novelty** (the watchlist never held this) | see §2.4 — it is provenance, not quality, and it is **transitional** |

The drill is `drill(key, face, spec)` — the one primitive, so the expansion inherits sort,
text filter, cohort selection and the honest-subset disclosure instead of re-earning them.
The drill opens to **cycles**, not to a summary: one row per observed cycle with its bucket,
its hour band, the cells that funded it, and the capture-lifecycle states. That is the
"opens to its rows" requirement met with actual rows.

### §2.4 The rdiff mark — transitional, with its expiry written down

*"The watchlist never held this"* is interesting for exactly one era: the first weeks after
the cutover, when the question is *what did admission cost me?*. After that every item is a
pool item and the mark distinguishes nothing — which is the mark-that-appears-everywhere
failure the constitution already names.

**Proposal: ship it as an explicitly transitional mark with a stated expiry condition** —
it renders only for items whose first pool entry predates the cutover date, and the copy
says so. Not a permanent badge, and not a badge that quietly stops meaning anything.

### §2.5 The six-gate qualifier — it rides the badge, it is not a footnote

While chart gates are unobserved, **every verdict behind the persistence count is a
six-gate verdict** — 9,271 of 9,313 funded item-cycles, 99.5%. A persistence count computed
under six gates and one computed under nine are **different populations**, and the
transition will happen inside the badge's own history.

This is the `fundedNoChart` partition applied at the item layer, and it needs the same
treatment: **the badge's tooltip states the split** — *"n of obs, of which m were scored
before chart coverage matured"* — and the count does not silently pool the two eras. The
partition question at birth, answered in writing: the regime is chart-input coverage, the
field is a per-cycle `noChart` count alongside the funded count, and when the wiring lands
the two decompose instead of merging.

---

## §3 · Items with no scorer history — the honest states

An item newly qualifying on its first cycle **has a state**, and the state is not zero. Four
states, and none of them renders as a bare number:

| state | when | renders as |
|---|---|---|
| **first cycle** | in the pool, entered this cycle | the accruing glyph, tooltip *"first observed cycle — no persistence yet; the denominator starts now"* |
| **accruing** | in the pool, history shorter than the drill's stated bar | the accruing glyph, tooltip carries the pair `n of obs` |
| **settled** | in the pool with enough observation to read | the verdict glyph, tooltip carries the pair and the era split (§2.5) |
| **not scored** | in the plan by a path other than the pool — a pin, an open position, an exception grant | **empty slot, and a stated reason**: *"not in the control cell's pool — here because you pinned it"*. Persistence is **not applicable**, which is a different claim from zero |

**The denominator is the load-bearing part, and it is the one thing that needs a persisted
field.** An item that entered the frontier an hour ago has ~12 observed cycles available,
not 1,024. Rendering `1 of 1,024` would be false in exactly the way the observed-time rule
forbids. **So persistence needs a per-item first-seen stamp**, and that stamp is a new
persisted field with a partition answer owed at birth:

> **What regime writes it:** the scorer's cycle loop, at the moment an item first enters the
> control cell's pass set. **What field records the regime:** the `SCORER_V` gate-arithmetic
> version already stamped on cell records — a change to the gate arithmetic makes the
> pre-change observation a different population, and the stamp is what lets the two
> decompose. **What happens when the regime changes:** the item's stamp closes at its
> version and a new one opens; the badge renders the current era's pair and the drill opens
> to both. **What happens when an item leaves the pool and returns:** it is the same item
> and a *new* observation window — the pair restarts, the drill keeps the prior window, and
> the tooltip says which, because a returning item is not a first-cycle item and must not
> read as one.

**"Absent must not read as bad" is met by construction here**: the accruing glyph is
visually distinct from the verdict glyph and carries no valence, exactly as `◌` does on the
paper dot today. And the converse binds as hard: an item in the **not scored** state renders
an empty slot *with a reason*, because an element that cannot explain its presence on the
screen does not render.

---

## §4 · What this replaces — the zero-based complexity answer

Every capability proposal answers what it displaces. This one:

- **The paper-book circle (`shadowDot`) yields its slot** on the plan and watchlist rows.
  Its verdicts are pre-cutover-era paper evidence about a watchlist-shaped population; the
  scorer's per-item persistence answers the same question over the pool that will actually
  be funded. The dot does not vanish — it stays on the Paper Book surface, in the dormancy
  pattern already used twice this month, and the un-retire is a ruling that flips one flag.
- **The rdiff mark is transitional and expires** (§2.4) — it is proposed with its own
  removal condition rather than as a permanent addition.
- **Net standing elements on the row: unchanged.** Two slots out, two slots in.

**Walk-up attention cost: zero.** No slot presents a ruling; every one of them is a mark
that opens to rows.

---

## §5 · What I would want ruled, in order

1. **The `DB.qual` prune (§1.1a).** It is a blocker, it is deployment-class, and it should
   be settled before anything else in the cutover is scheduled — not because it is hard but
   because it decides whether the cutover funds anything at all.
2. **Seasoning's shape for pool items (§1.1b).** A one-calendar-day floor on every entrant
   against a 6×-churning frontier is either correct (the edge must be sustained, and a
   churning item has not shown that) or it is the watchlist's tenure rule applied to a
   population it was never written for. I have no evidence either way and am not proposing
   a change — I am flagging that the cutover ruling implicitly decides it.
3. **Two groups, not one list (§1.2).** Display-only, and the alternative silently ranks
   unproven items against proven ones on defaulted weights.
4. **The badge's two slots (§2.2)** and the four states (§3), with the per-item first-seen
   stamp and its partition answer.
5. **The tier bands against the pool (§1.1c).** 66% of the control cell's items are outside
   T1/T2. That is not a defect — the bands are a ruled strategy parameter and the scorer
   scores the whole universe by design — but the cutover makes it visible for the first
   time, and *"is the T2 ceiling still where I want it now that I can see what is above
   it"* is a real question the new surface will raise on its first day. **It is a strategy
   parameter and moves only on your explicit instruction; I am naming it, not proposing
   it.**
