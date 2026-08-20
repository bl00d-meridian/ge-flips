# Sweep — 2026-08-19: every field where `num()` could turn a null into a zero

**Directed by the user after the fourth adversarial pass found a second instance of one helper producing
one defect.** The enumeration is the deliverable: every field, not only the ones that
were broken.

`num()` inside `validateImport` is `Number.isFinite(+v) ? +v : null`. **`+null` is `0`, and `0` is
finite**, so an explicit `null` in an imported file returns as the **value zero**. Two things make
that reach further than a hand-edited file:

- **The state backup is `JSON.stringify(DB)`.** Nothing normalises on the way out. Any field the
  app itself writes as `null` therefore makes the corrupting round trip in **one hop**: write null →
  export → restore → 0.
- **The import writes explicit nulls of its own** — `sourceTier`, `peakToFlagD`, `retracePct`,
  `runwayD`, `rung`, the coherence reading `c`, the trend array. Its output *is* the next backup, so
  those fields corrupt on the hop after the one that created them.

The tell is a guard that **looks** like it preserves the distinction and cannot, because its own
left-hand side is already the zero it is testing against:

| idiom | what it does with `null` | why it reads as safe |
|---|---|---|
| `num(x) != null ? num(x) : null` | `0` | the `: null` branch says "null is a state here" |
| `num(x) >= 0` | passes, as `0` | `>= 0` says "zero is legitimate here" |
| `[0, …].includes(num(x))` | passes, as `0` | the enumeration says "these are the valid values" |
| `num(x) > 0 ? … : null` | rejects → `null` | **safe** — the `> 0` refuses the manufactured zero |
| `hasOwnProperty` + `typeof v === "number"` | preserves all three states | **safe** — never coerces |

---

## The fix: one term, not thirty-nine fixes

```js
const nz = v => v === null ? null : num(v);
```

**101 call sites across 47 lines** inside `validateImport` now use it, plus 2 more on the intelligence.json
import path. **271 `num()` call sites remain there and are correct as
they stand** — `num()` is right wherever `0` is the default and `null` carries no separate reading.

`nz` is deliberately *not* sufficient for a store that also has an ABSENT state, because it maps
`undefined` and unparseable input to `null` as well. `itemOps` keeps its own four-way branch
(absent / cleared / unrecognised / value) and the source says so, so a later reader does not
"unify" them.

---

## A. The app itself writes these as null — one hop, and they were all broken

| field | `null` means | `0` means | consumer, and whether it can tell |
|---|---|---|---|
| **`watch[].qty`** | **size me automatically** | a hand-typed manual size of zero | `opsPick` → `planQty` → `chk(!(qty > 0), "sizing", …)`. **Cannot tell** — 0 is not null, so `wanted` becomes 0 and the item benches |
| `flagArchive[].peakToFlagD` | the peak was not locatable | the flag fired **on** the peak day | `flagLagProfile` filters `x != null && x >= 0`. Cannot tell — a restored 0 enters the median lag |
| `flagArchive[].retracePct` | the peak mid was ≤ 0, so no retrace is computable | the flag did not retrace | `flagLagProfile` filters `x != null`. Cannot tell — enters the median retrace |
| `rampFlags[].runwayD` | the catalyst's window date will not parse | the window opens today | the ramp-flag line reads `!= null && > 0` and renders *"inside/past the window"*. Cannot tell |
| `sleeveExits[].rung` | a **hand** exit | the **first** ladder rung | the exit history renders `rung + 1`. Cannot tell — a hand exit came back as "(rung 1)" |

**`watch[].qty` is the live money-path one and it predates every cutover component.** All three
creation paths — `runScout`'s add, the sibling add, and the manual add — write `qty: null`
explicitly, and null there means *size me automatically*. After a state-backup restore the whole
watchlist read as a **manual override of zero**: `opsPick` returns 0 (it is not null), `planQty`'s
`wanted` becomes 0, `qty` becomes 0, and the sizing gate benches every automatically-sized item —
**with a reason naming working capital or a missing buy limit, neither of which had happened**. The
plan would fund nothing but hand-sized rows and every bench reason would be wrong about why.

Direction: it **suppresses** funding rather than widening it, so it errs safe. It is still the
largest blast radius in this file, and the fix is behaviour-identical under uncorrupted data.

Assertions: `[R103.1]` (the three states at the sanitizer), `[R103.2]` (at `planQty`, the consumer),
`[R103.3]`, `[R103.4]`. Seeds S169a–S169d.

---

## B. The import writes these as null, so the *next* hop corrupts them

| field | `null` means | `0` means | consumer |
|---|---|---|---|
| `intel[].sourceTier` | no tier recorded | **tier 0**, the most authoritative source class | the else-branch of the import's own `[0,1,2,3].includes(…)` writes the null it then misreads |
| `cohLog[k][].c` | correlation not computable | zero excess correlation | `cohEvaluate`; the app's writer never emits null (`if (c == null) continue`), so only the import creates them |
| `cohProps[].trend[]` | no reading that week | a flat reading | rendered as a per-week trend list |
| `cohProps[].dismissedC` | dismissed with no correlation recorded | dismissed **at** zero correlation | the resurfacing test reads `hit.dismissedC != null` |

Assertion: `[R103.5]`, which feeds the sanitizer its own output back in. Seed S169e.

---

## C. Zero is legitimate; a null would have collapsed onto it (foreign or hand-edited file only)

The app does not write nulls to these, so nothing was corrupting today. They are fixed anyway
because the class is what is being closed, and a file arriving from anywhere else is exactly the
input this function exists for.

| field | what `0` legitimately means |
|---|---|
| `flips[].tier` | tier 0 — a real tier stamp |
| `watch[].tierOv` | an override **to** untiered. The watch-row writer `delete`s on clear (`index.html`, the tier button's fourth press), which is the only reason this half was never live — the item store nulls instead, which is what pass 4 found |
| `watch[].sibRing` | ring 0 |
| `watch[].sibClose` | closeness 0; consumers already read `|| 0`, so display-neutral |
| `flips[].bh`, `flips[].sh` | a leg that filled in under an hour — `bh: 0` is written by logged flips today |
| `positions[].buyH` | same, on an open position |
| `flips[].qm`, `positions[].qm` | a zero-margin quote. `Number.isFinite(f.qm)` includes 0 and excludes null, and the value feeds the capture-share sum |
| `shadowBook[].net` | break-even; absent means the trip is not closed |
| `shadowBook[].buyQFull`, `sellQFull`, `buyQStrict`, `sellQStrict` | measured, and nothing was reachable — as against null, which is *not measured* |
| `shadowExceptions[].realNet` | a break-even adjudication |
| `walkupLoad[].n` | a day with no decisions |
| `deployLog[].n` | an empty candidate pool |
| `scorerT2[].cfg[k]` | a real config value of 0. A null now **rejects the row** rather than filing its data under the hash of a config with a fabricated zero |
| `anomalyFlags[].rise14vRel` | a zero relative rise. This one already carried a hand-written second guard (`&& f.rise14vRel != null`); folded onto `nz` so one idiom owns it |

### The settings block — 23 keys, and the repair points BOTH ways

Every one is `num(d.X) != null ? num(d.X) : DEFAULT`. An explicit `null` took **0 after the clamp
instead of the default**:

`shadowReserve` · `reserve` · `t1Budget` · `t2Budget` · `sleeveBudget` · `sleeveMaxPos` ·
`sleeveRungPct` · `sleeveExitLiqPct` · `partCapPct` · `shadowPartPct` · `scoutT1Cap` ·
`scoutT2Cap` · `seedTrips` · `sibPerSeed` · `sibTotal` · `rulingsCap` · `pumpWindowD` ·
`pumpThinGp` · `catWinTightenD` · `briefTightStaleD` · `clusterCapPct` · `clusterCorr` ·
`clusterMinDays`

Most clamp back to a floor (`Math.max(1, …)`) and land somewhere harmless. Two groups do not, and
**they point in opposite directions — which is worth stating plainly, because the repair is a
widening for one of them.**

- **`shadowReserve` and `reserve` both floor at 0**, so a null zeroed them. **A reserve going to
  zero widens what the allocator may fund** — the restraint-lift direction, reached through an
  import, which is a channel that may drop a restraint only on the user's own press. The repair
  restores the default, which **narrows**.
- **`t1Budget`, `t2Budget` and `sleeveBudget` also floor at 0**, and there a null previously zeroed
  the budget, which funds **nothing**. The repair gives them their defaults — 60m, 30m, 60m — so
  for a file carrying an explicit null the repair **widens** what may be funded, from zero to the
  default.

**The widening is stated rather than buried, and here is the argument for taking it.** An explicit
`null` and an absent key both mean *this file carries no value for this setting*, and they must
behave identically; making a null mean **zero** is the exact defect being swept, and its old
behaviour was not conservative but incoherent — it zeroed the reserve (loosening) and zeroed the
budgets (tightening) in the same pass, on the same input. Neither state was ever ruled. **No path
in the app writes null to any of these keys** (every setting goes through `clampNum`, which always
yields a number), so this is reachable only from a hand-edited or truncated file. If the preferred
behaviour for a malformed settings block is *refuse the import* rather than *fall back to the
default*, that is a ruling and not a fix, and it is not made here.

---

## D. Deliberately left on `num()` — three, named in the source and pinned by `[R103.6]`

- **`itemOps[].bands[0]` and `[1]`.** Rejecting a malformed pair makes `bands` absent, and absent
  **means applied** — so `nz` here would move an override from WITHHELD to APPLIED. That is the
  loosening direction and it is a ruling, not a fix. Left as it stands.
- **`scorerT2[].econ[bucket].{net,netS,netL,gross,top,pumpNet}`.** The else-branch is already `0`,
  so null and 0 mean the same thing at that call site. Nothing to lose.

---

## E. The other direction, identified and NOT changed: `> 0` guards that drop a legitimate zero

`num(x) > 0` is safe against this defect and has the opposite failure: a real `0` is refused and the
field restores as absent. Eight candidates, listed for the enumeration rather than fixed —
**I did not trace their writers**, so I do not know which can actually produce a zero:

`holds[].paid` · `shadowBook[].score` · `shadowBook[].cleanFind` · `dieOffLog[].voidH` ·
`anomalyFlags[].noStory` · `intel[].variants` · `clusterCands[].variants` · `watch[].invTarget`

For most, absent and zero plausibly mean the same thing to the consumer (`|| 0` downstream), which
is why none was changed on a sweep whose subject was the other direction. Named here so the next
reader starts from a list rather than from the file.

---

## F. The patterns that never had this bug — the vocabulary to reuse

- **`num(x) > 0 ? … : null`** — `dieOffLog.rec`, `volIndex.ratio`, `shadowBook.basis`,
  `shadowBook.closedAt`, `dieOffLog.voidH`, `clusters.capPct`, `sleeveExits.basis`, `sleeve.basis`,
  `holds.baseline`. The `> 0` refuses the manufactured zero.
- **`hasOwnProperty` + `typeof v === "number" && Number.isFinite(v)`** — `gateLog.v`, and the whole
  `fin()` block that carries the paper book's stamps.
- **Enumerated values, absent stays absent** — `qual.src`, `gateLog.src`, `dieOffLog.pop`,
  `deployLog.poolRegime`, `shadowExceptions.gate`.
- **The four-way branch** — `itemOps`, which is the only store here with a genuine ABSENT state
  beside a CLEARED one.
- **`Math.max(0, num(x) || 0)` on a counter** — correct, because 0 is the default and there is no
  second reading to lose.

---

## What made this recur — and the count in this file was wrong, corrected by pass 5

The guard for this exact hazard was **already written down, twenty-one lines below the branch that
needed it**, on `gateLog.v`:

> *"NOT `num()`, which is `Number.isFinite(+v) ? +v : null` and therefore maps null → 0, since
> `+null` is 0 and 0 is finite."*

It was written in the same session that gave the item store a null-bearing third state, and the
store landed with `num()`. **The knowledge was present, correct, adjacent, and expressed in prose
rather than in a term**, so it protected the line it was attached to and nothing else. Recorded as
**MISTAKES M169**.

---

## Verification

`PROBE-PASS — 1,248 assertions, COLD PROFILE, pairing clean both directions (475 tags / 487 rows /
475 cited)`. Six new assertions, `[R103.1]`–`[R103.6]`, all proven by seeding:

| seed | what it reverted | red |
|---|---|---|
| S169a | `qty: nz(w.qty)` → `num` | `[R103.1]` `[R103.2]` `[R103.5]` |
| S169b | `peakToFlagD` → `num` | `[R103.3]` `[R103.5]` `[R103.6]` |
| S169c | `rung` → `num` | `[R103.4]` `[R103.5]` `[R103.6]` |
| S169d | `runwayD` → `num` | `[R103.4]` `[R103.5]` `[R103.6]` |
| S169e | `sourceTier` → `num` | `[R103.5]` `[R103.6]` |
| S169f | `buyQFull >= 0` → `num` | `[R103.6]` |

One at a time, restore-verified byte-identical between each.

**Two things the seeding taught that the fix did not.**

- **`[R103.6]`'s first run went red on its own documentation.** `nz`'s comment quotes the trap idiom
  in order to name it, and `validateImport.toString()` includes comments. Block comments are now
  stripped first — and only block comments, because a `//` stripper would eat the tail of
  `/^https?:\/\//`, whose escaped closing slash and regex terminator are two consecutive slashes.
  The red was incidental proof that the assertion reads live source rather than a copy.
- **The fixed-point form of `[R103.5]` could not fail, and was replaced.** It was first written as
  `validateImport(validateImport(x)) === validateImport(x)`. **Every instance of this defect
  converges after one hop** — null → 0, then 0 → 0 — so the two passes agree while both are wrong,
  and no seed could redden it. It now names the eight null-bearing fields and asserts each is still
  null, which every seed above does redden.

**The `nz` sweep itself changed behaviour and broke no existing assertion.** That is the third of
the three answers the standing rule allows: the change was **genuinely uncovered**. `[R103.1]`–
`[R103.6]` are that coverage, and their seeds are what makes the statement checkable rather than
reassuring.
