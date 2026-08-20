# Every pinned era fact, classified — and what works for the class a pin cannot cover

**2026-08-19, on the user's ruling.** The third adversarial pass found that `[R76.9]`'s "armed era
tripwire" **cannot fire at the transition it names**, and that CLAUDE.md, two code comments and a
requirement row all said it does. That was corrected for the instance. This audit asks the question
the instance raised: **which pins are armed, which only look armed, and what actually works for the
ones that cannot be.**

---

## The distinction

| class | the era changes because | can an in-page assertion observe it? |
|---|---|---|
| **CONSTANT-FLIP** | a **code edit** — a `const` moves, a function body changes | **YES.** The suite runs against the code, so the edit is the thing it reads. |
| **RUNTIME-STATE** | **data arrives** — coverage matures, a store fills, a clock passes, an operator acts | **NO.** The probe runs on synthetic fixtures with DNS dead. Nothing it reads changes when the real world does. |

**A pin on a runtime-state era is not a weak detector; it is not a detector.** It reports the era as
covered while nothing watches it, which is the same defect class as a rule with no detector — the
slot is occupied and the property is not.

---

## The audit

### CONSTANT-FLIP — armed, and correctly so (7)

| era fact | pin | verified |
|---|---|---|
| `CUTOVER_POOL = false` | `[R89.1]` | Asserts the const AND drives the armed branch through `planCandidates(armed)`. A silent flip reddens the off-path assertion. |
| `ITEM_OPS = false` | `[R93.1]` | Asserts the const AND, since this session, drives the armed branch through `opsOf(id, armed)`. |
| `VOL5_UNIVERSE = false` | `[R94.3]` | Asserts the const and that the streak population is the watchlist while it is. |
| `SCORER_CAPTURE_GRADED = false` | `[R78.17]` | Asserts the const in its ruled words, and every "cannot rank yet" surface is gated on it. |
| `MM_BENCHED = true` | `[R79.1]` | Asserts the const beside the behaviour it gates. |
| `REGIME_RACE_RETIRED = true` | `[R81.1]` | Asserts the const beside the dormancy copy it produces. |
| `SLICE_SAMPLING_RETIRED = true` | `[R81.1]` | Same shape. |

All seven are code edits. Each pin is read by the same run that reads the flag, so the flip and the
detector cannot separate. **Nothing to change.**

### CONSTANT-FLIP with a blind spot — armed for one implementation shape only (1)

| era fact | pin | the blind spot |
|---|---|---|
| *the T0 archive does not feed an hour-of-day profile* | `[R100.4]` | It forces a READY cache and asserts `itemSeries(id, undefined).byHourSrc === "none"`. A future wiring **inside `itemSeries`** turns it red, correctly. But a loader that **synthesises `S.spark` records** from the archive's hour-stamped bucket keys would feed the weight without touching the resolver — and the assertion passes `undefined` for `sp` explicitly, so it cannot see that path at all. |

**Fixed in this session** by adding the second shape: the assertion now also drives `chartedNow`'s
population through a spark-shaped archive record and requires the weight to stay unfed unless the
record came from a real `/timeseries` fetch. Recorded here because the *lesson* generalises: **a pin
is armed against the implementation the author imagined**, and naming the other implementations is
part of arming it.

### RUNTIME-STATE — a pin cannot cover these (2)

| era fact | what was claimed | what is true |
|---|---|---|
| **chart coverage reaches 7 of 7 observed days** | `[R76.9]`'s `marketStatsFor().tr === null` "forces the accounting when the wiring lands" | **False, and proven historically:** the wiring landed Aug 18 and nothing went red. Its subject is a synthetic id absent from the real archive, so its `tr` is null whatever the gate says. Corrected this session; it now asserts both directions and catches a code change that feeds `tr` unconditionally, which is a **different and smaller** promise. |
| **the `sc-sixgate` glossary entry's claim** that `marketStatsFor` carries no chart inputs yet | rendered as a standing fact | Already stale — after step C it *does* carry them, gated. Nothing pins it, and nothing could: the sentence is about a runtime state. |

**Both are the same shape**: a claim about what the data currently is, written as though it were a
claim about what the code currently does.

---

## The pattern the project already gets right, and why it is the answer

Every runtime-state era that the project handles WELL is handled the same way, and none of them is
pinned: **it is recorded in a field on the row, at the moment the row is written.**

| runtime era | the field that records it |
|---|---|
| six-gate vs full-chain verdicts | `fundedNoChart` / `ncN` on the pool-persistence row |
| which scorer config produced a verdict | `configHash`, `SCORER_V` on `poolSeen`, with an era-closed state |
| which fill model produced a paper trip | `FILL_MODEL_V` |
| which candidate pool a gate row came from | `gateLog.src`, `deployLog.poolRegime` |
| which retention regime a qual row is under | `qual.src`, three states with absent meaning pre-stamp |
| which tier bands an override was made under | `itemOps.bands`, three states |

**That is partition-at-birth, and it is the correct instrument for runtime state** — it does not try
to detect the transition, it makes every row say which side of it the row is on, so the two
populations can never pool no matter when the transition happened or whether anyone noticed.

**What partition-at-birth does NOT do** is tell anyone the transition happened. It makes the
accounting *possible*; it does not make it *owed*. That gap is exactly where the chart-coverage
fact fell.

---

## PROPOSAL — an era ledger, for runtime-state facts only

**Not built.** This is the mechanism I would use; it is deployment-adjacent only in that it changes
what the walk-up shows, so it wants a ruling.

**One append-only store, `DB.eraLog`, and one predicate registry.** A row is written the FIRST time a
registered runtime era is observed to have changed, and never again for that era:

```
{ k: "chart-coverage", at: <ms>, from: "accruing", to: "ready",
  owed: "six-gate and full-chain verdicts must not pool; …",
  ack: <absent until the operator clears it> }
```

**Three properties, each of which is the reason for a piece of it:**

1. **Written at OBSERVATION, not at transition.** Nobody can promise the app is open at the moment
   coverage matures. The row records *when it was first seen*, and says so — the observed-time rule
   applied to an era boundary. A row that says "first observed 3 days after it could have happened"
   is honest; a row that claims the transition instant is not.
2. **Durable and unacknowledged by default.** A banner is ephemeral: if the operator is not looking
   at that surface on that day, the transition is lost. A decision-log row is durable but reads as
   *something that was handled*. An **unacknowledged era row is an owed item** — it renders as an
   explicit unresolved marker until a human clears it, which is the only shape that survives the
   operator being away for a week.
3. **The predicate registry is CONSTANT-FLIP, so the mechanism itself is assertable.** No assertion
   can observe real coverage maturing, but every one of these *can* be asserted: that the registry
   contains the era, that a first observation writes exactly one row, that a second observation
   writes none, that an unacknowledged row renders the marker, that an acknowledged one does not,
   and that a row is never written for an era whose predicate is false. **The transition is
   unobservable; the machinery that notices it is not, and that is the part worth arming.**

**Attention cost: zero in the steady state.** The marker renders only while an unacknowledged row
exists, which is at most a handful of times in the product's life. It displaces nothing.

**The registry would start with two entries:** chart coverage reaching the gate, and — if the archive
is ever wired to feed an hour-of-day profile — the hour weight becoming fed for a population whose
ordering was ruled on the assumption that it was not.

---

## The rule this produces, now in CLAUDE.md

> **A pin is a detector for a CONSTANT-FLIP era only. An era that changes because DATA ARRIVED cannot
> be pinned, and describing one as armed reports a coverage that does not exist.** Runtime-state eras
> get partition-at-birth so the populations can never pool, plus a first-observation record so the
> accounting is owed rather than hoped for — and the assertion goes on the machinery that notices,
> which is code, rather than on the transition, which is not.
