# Cutover readiness sweep — 2026-08-18

**Report only; the batch is yours to rule.** This is the seam inventory run
**prospectively**: not *what is broken* but *what changes meaning when the candidate pool
stops being `DB.watch`*. Walked, not guessed — **99 `DB.watch` references** in `index.html`,
each read for whether it defines a population, a denominator, or a piece of copy.

**Your third instruction is cut off** ("3. STATE THE"). §4 below is what I judged it most
likely to be — the ordering and dependency question, i.e. which of these must land *with*
the flip and which can follow — but it is my inference, not your ruling. Say what you meant
and I will redo that section.

Classification, as ruled: **READS CORRECTLY** · **READS WRONG** (same label, different
population — the honest label is given) · **BREAKS** · **BECOMES MEANINGLESS**.

---

## §1 · The finding that leads

**Two 7-day ledgers change population mid-series with no field recording it.** Everything
else in this sweep is a label; these two are the never-pool rule about to be broken by a
flag flip, and they are the only entries that lose information *permanently* rather than
reading oddly until someone fixes the copy.

| ledger | what changes | why it cannot be fixed afterwards |
|---|---|---|
| **`DB.deployLog`** — hourly `{h, pass, funded, dep}`, 168h retention | `pass` counts candidates clearing the chain. Today's population is 43 watch rows; after the flip it is the control cell's pass set plus pins | the rows carry no regime field, so a pre-flip hour and a post-flip hour are indistinguishable. The funnel's own trend line would show a step change that is **entirely population** and read as gate behaviour |
| **`DB.gateLog`** — `{d, id, g, v}`, one row per (day, item, gate) | the bench population multiplies by roughly an order of magnitude; `funded` and `seasoning` rows likewise | same: no field says which pool produced a row. Every per-gate count, every leave-one-out figure and every gate-health rate reads across the boundary as one series |

**Both need the `fundedNoChart` treatment — a stamp at birth — and it has to land BEFORE
the flip, because a row written without it can never be classified afterwards.** This is
the partition-question-at-birth rule, and it is the one item in this sweep I would call a
prerequisite rather than a cleanup.

---

## §2 · The enumeration

### 2a · The funnel tile and the deployment box — **three figures, three different denominators**

You asked which denominator each actually uses. They are not the same, and only one is the
watchlist:

| figure | denominator in code | verdict |
|---|---|---|
| **pass** | none — it is a *count* of `P.pass`, whose population is `planCandidates()` | **READS WRONG.** The label survives, the population multiplies. Honest label: **"pass (of the scored pool)"**, and it must say which pool |
| **funded** | none — a count of `P.picks`, bounded by `targetSlots` | **READS CORRECTLY.** Slot-capped, so the pool's size cannot move it |
| **% deployed** | `P.deployed / (t1Pool + t2Pool)` — **capital pools**, not candidates | **READS CORRECTLY.** A capital-utilisation figure with no watchlist term in it |

### 2b · `#planSub` — **the one that goes arithmetically absurd**

```js
$("#planSub").textContent = pass.length + " of " + DB.watch.length + " pass the gates"
```

**BREAKS.** After the flip the numerator counts passes from the pool and the denominator
counts the pin list. With a 3-item pin list and 9 pool passes it renders **"9 of 3 pass the
gates"**. Not a subtle mislabel — a figure that cannot be true. Honest form: **"9 pass the
gates, of 412 scored"**, with the scored count coming from the control cell.

### 2c · The leave-one-out attribution and the per-gate counts

**READS WRONG across the boundary.** The arithmetic is sound and stays sound — every gate is
evaluated independently and the counterfactual is already in the fail sets. What changes is
the *population* those counts are over, and since they are read from `DB.gateLog` (§1) a
7-day or 30-day view silently spans two populations. Honest form: the panel states its
population and its window refuses to cross the flip until the rows are stamped.

### 2d · Gate Health's streams

- **"traded while still benched"** — **READS WRONG as a rate.** The numerator is realized
  flips on items you actually traded, which the pool does not change. The base it is read
  against is gateLog bench rows, which multiplies. So the *count* stays honest and the
  *rate* collapses toward zero for reasons that have nothing to do with the gate. Honest
  form: keep it as a count with its population named; withhold the rate across the boundary.
- **The realized-override lane** — **READS CORRECTLY** in substance: it is flips against
  bench days, item-keyed, and it is the one clean stream by design. Same caveat on any rate.
- **Die-off episodes and the exception lane** — **READS CORRECTLY**, item- and flip-keyed.

### 2e · The family correlation cap and the seed caution caps

Both **READ CORRECTLY as rules** and both change *character*:

- **`applyFamilyRule`** keeps the best-scoring member per family and benches the rest with
  *"family overlap with X"*. Today that sentence means **you are watching two similar
  things**. After the flip it means **the market offered two similar things this cycle** —
  the same words describing a different event, and the bench pile will be much larger.
  Honest form: one word of context in the bench copy.
- **`catSlots` / `GATE.seedSlots = 1`** — one funded slot per caution category for unproven
  items. A larger pool puts more items in competition for the same single slot, so
  *"category: only 1 slot until proven, already used"* goes from rare to routine. The cap is
  the intent and should not move; the **bench-reason distribution** shifts under it, which
  is the plan surface's composition line (design §1.3), not a rule change.

### 2f · Operator state keyed to watchlist ROWS — **the class that BREAKS**

Every one of these lives on a watch row, and a pool item has none. `cutoverPoolRows()`
deliberately synthesises `{ id }` and nothing else, so the *evaluation* is correct
(`[R89.2]`) — but the **controls that write these values have nowhere to render**:

| state | field | verdict |
|---|---|---|
| tested prices (the Tested column) | `w.tBuy` / `w.tSell` | **BREAKS** — the control renders per watch row; a pool item cannot be margin-tested |
| manual qty intent | `w.qty` | **BREAKS** — same |
| tier override | `w.tierOv` | **BREAKS** — and this one matters most, because **66% of control-cell items are untiered** and the override is the only re-admission path |
| inventory mode | `w.invTarget` | **READS CORRECTLY** — mm is benched; the frozen `invTarget` re-key is already a ruled follow-up |
| scout provenance | `w.src` / `w.scoutTier` / `w.sib` | **BECOMES MEANINGLESS** — the admitting scanner retires with the cutover |
| t2 graduation stamp | `w.t2Grad` | **BREAKS** — written onto a row that will not exist |

**The shape of the fix, and it is one decision not six: operator state re-keys from ROWS to
ITEMS.** A pinned item keeps its row; a pool item needs a place to hold a tested pair, a
manual qty and a tier override without being pinned. That is a store change with a partition
question, it is deployment-class, and it is the largest single piece of work this sweep
found. **It does not have to land with the flip** — the flip works without it, and what you
lose until it lands is the ability to override a tier or margin-test a pool item, which is
exactly the operator's escape hatch. I would not want to be without it for long.

### 2g · `+ watch`, the tab label, and the copy that names the mechanism

| surface | verdict | honest form |
|---|---|---|
| the scanner's **`+ watch`** button | **READS WRONG** — it will mean *pin*, not *admit* | **`+ pin`** |
| the **"Plan & Watchlist"** sub-tab label | **READS WRONG** — the watchlist stops being the pool | **"Plan & Pins"**, or just **"Plan"** |
| the cluster panel's *"Needs 3+ watchlist items — nothing to correlate"* | **READS WRONG** — it will correlate over the pin list, a smaller and differently-selected population than what you trade | name the population |
| `chartedNow()` — watch items carrying sparks | **BECOMES MEANINGLESS** once chart wiring lands universe-wide | delete with the chart wiring |
| scout/sibling admission (`DB.watch.push`, `watchCap`, sibling budgets) | **BECOMES MEANINGLESS** — this is the admission machinery the cutover retires | already on the retirement list |

### 2h · Glossary entries defining the pool as the watchlist

Five, and one of them is the tool's statement of its own constitutional rule:

| entry | verdict |
|---|---|
| **`gov-propose`** — *"no flip is logged, no offer placed, no **watchlist commitment** made without a press"* | **READS WRONG.** The property survives the cutover exactly; the noun does not. After the flip nothing is committed to a watchlist and the sentence describes a mechanism that no longer gates anything. Honest form names the property — *no capital is committed* — not the surface |
| **`paper-cohort`** (`aka: "watchlist, slice, gap band, scanner·T1/T2"`) | **READS WRONG** — "watchlist" as a cohort name will mean the pin list |
| the scanner-vs-watchlist net comparison | **BECOMES MEANINGLESS** — it exists to judge *your scout's admission*, and admission is what the cutover removes |
| *"Promote from here into the watchlist deliberately — the scanner shows what passes filters, the watchlist is what…"* | **BECOMES MEANINGLESS** — same reason |
| the cohort never-blend entry naming the watchlist as a cohort | **READS WRONG** — population rename |

### 2i · Reads correctly, checked and cleared

Recorded so the next run starts from a list rather than from scratch: the **weekly review's
gp-per-touch** denominators (item-keyed and touch-keyed; the pool does not change how many
touches you make); the **exception and probation lanes'** eligibility reads (`DB.flips` and
`DB.shadowExceptions`, item-keyed); **markouts and reliability** (flip-keyed); **the
blacklist** (item-keyed, and constitutionally the user's alone); **capital pools, budgets
and exposure caps** (gp-denominated); **the paper book's own trip ledger** (cohort-stamped
at birth already); **`analysis-*` exports** — none carries a watchlist-scoped row set under
a label that would change meaning, because each already names its cohort.

---

## §3 · Summary count

| verdict | n | the ones that cost something |
|---|---|---|
| **BREAKS** | **7** | `#planSub`'s impossible fraction; the six operator-state fields keyed to rows |
| **READS WRONG** | **11** | the two ledgers (§1), the funnel's `pass`, gate-health rates, `+ watch`, the tab label, five glossary entries |
| **BECOMES MEANINGLESS** | **5** | scout/sibling admission, `chartedNow`, three glossary entries about admission |
| **READS CORRECTLY** | the rest | listed in §2i so the next run does not re-derive them |

---

## §4 · What I think your third instruction was — inferred, not ruled

Read as *"state the dependency: which of these must land with the flip and which may
follow."* My answer:

**Must land BEFORE the flip** (information is lost otherwise, permanently):
1. **The regime stamp on `DB.deployLog` and `DB.gateLog`** (§1). Rows written unstamped can
   never be classified. This is the only true prerequisite in the sweep.

**Must land WITH the flip** (the surface is wrong the moment it flips):
2. `#planSub`'s denominator — it renders an impossible fraction on the first refresh.
3. The funnel tile's `pass` label and the gate-health rates' population statement.
4. `+ watch` → `+ pin`, the tab label, and the five glossary entries.

**May follow the flip, with the cost named:**
5. **Operator state re-keyed from rows to items** (§2f). The flip works without it; what you
   lose meanwhile is the tier override and the margin test on pool items — the escape hatch
   for the 66% that land untiered. Deployment-class in its own right.
6. Family and caution bench copy (§2e) — a word of context, not a correctness fix.
7. Retirements of the admission machinery (§2g) — already on the post-cutover list.

**If the third instruction was something else, this section is the wrong answer to it.**
