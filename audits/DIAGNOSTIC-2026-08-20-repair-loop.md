# Why does the repair loop keep producing defects? — six hypotheses, measured

**Measurement only. Nothing was fixed, nothing landed, no flag moved.** Frozen at both ends and
verified by `sha256sum -c`:

| file | at open | at close |
|---|---|---|
| `index.html` | `3cf9a22d321892e5…` | OK |
| `tools/probe/probe-snippet.html` | `e239370cfb042232…` | OK |
| `REQUIREMENTS.md` | `43cfea0359b6cb4b…` | OK |
| `staging/index.html` | `17a3b4d4756c2eea…` | OK |
| `staging/probe-snippet.html` | `3718f7b31b695484…` | OK |
| `staging/REQUIREMENTS.md` | `8d0ceca510f1622c…` | OK |

**Method.** 28 agents: nine measurers (one per hypothesis, plus a separate denominator and a
separate assertion-defect-rate reader), sixteen adversarial refuters over the H3 findings, two
independent re-derivations of the two decisive counts, and a completeness critic. No claim rests on
a suite result; the suite was not run. Every agent verified the freeze hashes at start and end.

---

## Verdicts

| | hypothesis | verdict | the number that decides it |
|---|---|---|---|
| H1 | too coupled for one reader | **NOT SUPPORTED** | coupling ranges **overlap**: misses 2–7, passes 1–3 |
| H2 | finding-driven repair is the wrong unit | **NOT SUPPORTED** | **3 of 3** missed sites were already inside the repairer's own field of view |
| H3 | findings ∝ reading effort, not defect density | **CANNOT BE COMPARED AS POSED** | but findings **per reader** are flat: 4.0, 3.4, 3.4 |
| H4 | the suite is a second system with its own defect rate | **SUPPORTED, on a weak number** | 35 of 81 recent tags defective = **43.2%**, over the **7%** of the suite anyone has read |
| H5 | severity flattened by the money-path label | **SUPPORTED for pass 7, NOT for pass 8** | pass 7: **0** bite today of 17. pass 8: **7–9** of 25 |
| H6 | flag-gated code cannot be verified while the flag is off | **SUPPORTED — strongest number in the set** | **5** of 106–109 flag-gated assertions can reach the armed state = **4.7%** |

---

## H1 — NOT SUPPORTED. Coupling does not separate the misses from the passes.

Fourteen semantic subsystems, defined operationally (a subsystem owns one decision; a read is
counted in the body that contains it, never in that body's callers). Per repair, subsystems touched
plus distinct other subsystems reading what it changed:

- **class misses:** repair 3 = 2, repair 2 = 6, repair 8 = 7. Mean **5.0**, range **2–7**.
- **passes:** repair 5 = 1, repair 6 = 1, repair 7 = 2, repair 9 = 2, repair 1 = 3, repair 4 = 3.
  Mean **2.0**, range **1–3**.

**No separating threshold exists.** A cut would need to be ≤2 and >3 simultaneously. The overlap is
not marginal: **repair 3, a class miss, scores 2 — tied with two passes and strictly below two
others.** A rule reading "above this coupling, review harder" would have waved repair 3 through as
one of the four simplest repairs in the batch.

Repair 3 scores low because its defect is **inbound**, not outbound: `cutoverSetFrom` *reads*
`ITEM_OPS` and `VOL5_UNIVERSE` without changing them. Counting inbound too gives misses 6/4/7 and
passes 3/4/2/1/3/2 — still overlapping, repair 3 (miss, 4) tying repair 4 (pass, 4).

**And the geometry contradicts the framing.** The 51 `index.html` hunks span 95.3% of the file's
extent but form **8 regions with a median inter-hunk gap of 75 lines** — each repair is locally
clustered. What spans the file is the *batch of nine*, not any one repair.

**Batch size is untestable from this data**, and this must be said plainly because it is already
ruled as a change: all nine repairs were in one pass, so repair count has zero variance here and
cannot separate anything. The ruled fix rests on argument, not on this measurement.

---

## H2 — NOT SUPPORTED. All three missed sites were already in view.

**3 of 3 required no wider spatial unit.**

- **Repair 2** — both halves of the missed defect are **added lines in the repair's own diff**
  (`staging/DIFF.patch:329` for `opsWrite`, `:387–407` for `itemOpsReconcile` and the `DB.itemOpsV2`
  latch). `grep -n 'itemOpsV2' index.html` returns nothing; it exists only in the repair.
- **Repair 3** — the missed site is **quoted by name in the repair's own added comment**
  (`staging/index.html:6637`, *"`updateVol5Streaks` writes `S.vol5Low` only for `vol5Population()`"*),
  **28 lines above** the guard that disagrees with it.
- **Repair 8** — the three missed budget keys are **unchanged context lines 988–990 of the diff, one
  line above changed line 991**. And the correct membership test was already written at the top of
  the new table; a legacy call list was used one paragraph later.

**The miss was of a QUESTION, not of a REGION** — temporal for repair 2 (which latch has fired when
the flag flips), injection-parity for repair 3 (does the guard's value reach the mechanism it
describes), membership-key for repair 8 (what does this value do, not what did it used to share).

Repair 8 is separately evidence *for* the cold-review mechanism, not against the repair unit: the
ledger reads SENT BACK, found from the diff alone, before the adversarial pass ran.

**UNTESTABLE FROM HERE:** whether a subsystem-scoped rewrite would in practice have *asked* those
questions. No subsystem-scoped rewrite exists in this repo to measure. What would test it: run one
repair both ways, blind, on the same defect.

---

## H3 — the cheap test ran, and the comparison it was meant to settle is not admissible as posed.

**The subsystem: the thesis sleeve.** Chosen because every mention of "sleeve" across all eight pass
reports is incidental (a probe fixture name, `DB.sleeve` inside a store enumeration,
`sleeveMaxPos`/`sleeveBudget` as settings keys). **No finding has ever been filed against sleeve
logic**, and it commits real capital, so findings there are money-path by construction.

**The result.** 313 call sites read (explicit counting rule, ±30–40 depending on whether
`DB.catalysts`/`DB.volIndex` count). **18 findings filed; 16 adversarially verified; 1 refuted, 10
survived downgraded, 5 survived intact.** The reader filed **9 as BITES TODAY; the verifiers left 1**.
Five survive as money-path.

**Pass 8's denominator:** 289 call sites (union across six code readers; 296 by sum), 28 findings, 25
money → **9.69 findings and 8.65 money-path findings per 100 call sites**.

**Sleeve:** ~5.7 filed and ~1.6 surviving-money per 100.

**Why this cannot be read as "the rates are comparable" or as "they differ".** The two denominators
count different things — the sleeve's 313 is *lines containing an identifier read cold*; pass 8's 289
is lines in a *diff-shaped scope chosen because code had just changed there*. There is no shared unit.
The honest comparable number is **findings per reader**, and it is flat:

| pass | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|
| money findings | 0 | 3 | 8 | 17 | 24 |
| readers | 2 | 2 | 2 | 5 | 7 |
| **per reader** | 0 | 1.5 | **4.0** | **3.4** | **3.4** |

The rising money-finding series tracks **reader count**, not repair difficulty. And it is not a time
trend at all: **all five passes are the same calendar day.**

**One thing the sleeve read does settle.** A never-read subsystem, read cold at pass-8 depth,
produced one surviving finding that bites today after refutation — not zero, and not eight. So
"comes back clean" is not currently a demonstrated state for any subsystem, but the unread parts are
not obviously as defect-dense as the just-repaired parts either.

---

## H4 — SUPPORTED, and the number that supports it is the weakest in the set.

**Product vs assertion findings, passes 5–8:**

| pass | scope | product | assertion | share |
|---|---|---|---|---|
| 5 | `num()` sweep / `validateImport` | 5 | 2 | 20.0% |
| 6 | pass 5's repairs | 11 | 4 | 20.0% |
| 7 | the cutover surface | 29 | 2 | 6.5% |
| 8 | the nine staged repairs | 26 | 9 | 25.0% |

**Non-monotonic.** The share dips at pass 7 — the one pass whose scope was a production surface
rather than a diff containing probe hunks — and rises at pass 8, the one pass that assigned a reader
to the new assertions as their whole scope. **Both inflections coincide exactly with a scope change.**
There is no trend to report.

The one comparable measure: **defects per NEW assertion shipped by the previous round.** Pass 6 found
defects in 2 of the 8 new tags pass 5 shipped = **25%**. Pass 8 found defects in 7 of the 19 new tags
the staged repairs shipped = **37%**. On n=8 and n=19 that is a comparison, not a trend.

**The assertion defect rate.** Of the last **81** tagged assertions, **35 were later found defective
= 43.2%**. Of those, **8 were caught by the author's own seeding and 27 by a later reader — 23% / 77%.**

**Two measurements that make 43.2% the number most likely to flip a verdict:**

1. **Passes 5, 6 and 8 cite zero assertions below §94.** The tree holds **1,078** tagged assertions
   in §<94 and **78** in §≥94. So **93% of the suite has never been examined by any pass that
   produced the 43.2% figure.** If that rate held over the unread part it would mean ~466 defective
   assertions; nobody knows.
2. **The unit is not the same unit.** Mean assertion-label length: **§<94 = 99.9 chars (n=1050);
   §≥94 = 334.1 chars (n=78)** — 3.3× longer, making several checkable claims each. A per-tag rate
   over 334-character labels is not comparable to a per-tag rate over 100-character ones.

**So 43.2% cannot distinguish "new assertions are worse" from "we only read new assertions."**

**Three suite-integrity facts found while measuring this, none previously recorded:**

- **105 assertions carry no `[R#]` tag** (1,261 total, 1,156 tagged). `reqpair.sh` maps tags to rows
  in both directions; an untagged assertion is outside both maps by construction. **8.3% of the
  suite is invisible to the ledger that exists to keep it honest.**
- **Scan 14's own number in CLAUDE.md is stale by 2.3–4.6×.** The strong-claim grep flags **458 of
  1,261** labels today; the constitution says "on the order of 100–200 of 958".
- **The two dormancy registers in `REQUIREMENTS.md` disagree.** `R29.6` declares itself
  *Dormant-gated* and §81's own citation list does not include it — a row claiming membership of a
  set that does not claim it back, which is the direction the pairing check cannot see.

---

## H5 — SUPPORTED for pass 7, NOT SUPPORTED for pass 8. The composition flipped with the scope.

**Pass 7 (17 money-path findings):**

| BITES TODAY | ARMED | RESTORE-ONLY | LATENT-CONDITIONAL | excluded as not-money |
|---|---|---|---|---|
| **0** | 12 | 0 | 0 | 5 |

**Pass 8 (25 money-path findings), two independent classifications:**

| | BITES TODAY | ARMED | RESTORE-ONLY | LATENT-CONDITIONAL | excluded |
|---|---|---|---|---|---|
| first classifier | 9 | 10 | 2 | 3 | 1 |
| independent re-derivation, against the **shipped tree** | **7** | 9 | 4 | 4 | 1 |

**So severity WAS flattened in pass 7 and is NOT in pass 8**, and the reason is scope: pass 7 was
scoped to a surface that does not exist until a flag flips, so every finding it could make was ARMED
by construction. Pass 8's scope reached shipped code, and 7–9 of its findings cost something today.

**The two that matter most, verified line by line against `index.html` (not staging) by two
independent readers and by me:**

- **4.1 — an offline first refresh, or any HTTP 200 carrying an empty `data` payload, deletes the
  entire seasoning store and benches the whole watchlist for about a day.** Every link holds:
  `S` initialises `latestAt: 0, hourAt: 0` and `S.qualStamp` is session-only, so the stamp guard
  passes at boot; `doRefresh` runs `renderAll()` from its `finally`; `renderAll` reaches
  `renderHomeVitals()` on every tab; that calls `buildPlan()` inside a bare `try`; `buildPlan` calls
  `updateQualStreaks(all)` with no guard; `candidateFor` returns `failed:"no live price in /latest"`
  for every row; the loop deletes and `save()`s. **The narrowing neither pass stated:** a mid-session
  network *failure* does **not** fire it — `loadLatest` throws before both assignments, so the stamp
  is unchanged and the guard early-returns. The two live triggers are exactly *(i)* the first refresh
  of a session failing and *(ii)* a 200 with `{}`, because `S.latestAt = Date.now()` runs
  unconditionally on the success path. The second one shows no error banner at all.
- **4.4 — `qualExemption` reads a flip's `id` as its date, and the no-import route is the ordinary
  one.** `#lDate` is a plain user-editable date input; logging a trade you actually did two months
  ago stamps `id = Date.now()` and the exemption reads it as *"logged round trip in 30d"*. Ordinary
  log-lag does it in weaker form. Two predicates over the same question exist in the file — 16531 and
  16574 use `f.date` correctly, `qualExemption` uses `f.id`. The direction is one-way: it only ever
  over-grants the waiver.

**A cross-finding interaction neither pass records:** 4.4's over-broad exemption is what limits 4.1's
blast radius, and 4.1 maximises 4.4's population — after a wipe, every item with a flip inside the
30-day window funds through a gate that just reset for everyone else.

**A method finding about H5 itself:** pass 8's own key marks **13 of 28 findings `[R]` — never
independently re-derived** — and H5 bucketed them by severity anyway. A severity assigned to an
untraced finding inherits the original reader's framing, which is the flattening H5 exists to
measure, one layer up.

---

## H6 — SUPPORTED. The strongest and best-bounded number in the set.

**5 of 106–109 flag-gated assertions can reach the armed state of the flag they are about = 4.7%.**
Two independent enumerations landed on the same 5 by different routes; the totals differ by ±1–3 on
definition only, and the critic settles the total at **109** (the first two both missed `R29.6`).

**The bound is structural, not sampled.** `run.sh` concatenates the app verbatim and appends the
snippet; it performs no source substitution. The probe contains **zero** `defineProperty` / `eval` /
`new Function` / `globalThis` writes. A module-level `const` therefore cannot be flipped, so **the
only route to a non-shipped branch is a parameter** — and there are exactly three parameterised entry
points in the whole file: `opsOf(id, armed)`, `planCandidates(armed)`, `poolControlsHTML(x, armed)`.

**Only 2 of the 7 build-time flags have any injection surface at all.** `VOL5_UNIVERSE`, `MM_BENCHED`,
`SCORER_CAPTURE_GRADED`, `SLICE_SAMPLING_RETIRED` and `REGIME_RACE_RETIRED` have none.

**The cutover subset, which is what the hypothesis is really about:**

| flag | assertions | armed-reachable |
|---|---|---|
| `CUTOVER_POOL` | 9 | 2 |
| `ITEM_OPS` | 12 | 3 |
| `VOL5_UNIVERSE` | 22 | **0** |
| `SCORER_CAPTURE_GRADED` | 3 | **0** |
| **total** | **46** | **5 = 10.9%** |

**And the three prerequisites the conformance gate names separately are the three with no armed path
at all.**

**Two harder facts underneath the headline:**

- **32 assertions in the shipped suite never execute in any run.** They sit inside `if (!FLAG)` blocks
  on a flag that is `true` — the live forms of the two retired features. Of the 48 strictly-gated
  assertions, **0 reach a non-shipped branch.** This was found by a hand read of all thirteen flag
  blocks; the automated brace-tracker got it wrong and the critic verified the hand read line by line.
- **3–4 HOLLOW INJECTIONS — a parameter that arms the gate and not the body.** The confirmed one in
  the shipped tree: `poolControlsHTML(x, armed)` checks `armed` at its guard and then calls
  `opsOf(x.id)` with **one** argument, so the store read resolves `ITEM_OPS = false` and every field
  comes back null. Both armed assertions pass on a skeleton — seeding
  `DB.itemOps[950001] = { tierOv: 2, bands: tierBandsNow() }` leaves them green. The source comment
  claims the opposite in as many words. Repair 3 adds two more in staging, including a `s.ops` member
  of the flag set that **nothing anywhere reads** (`grep -n '\.ops\b' staging/index.html` → one hit,
  the construction), so `[R107.2]`'s 470-character label discriminates on a dimension the code does
  not read.

**And the fixture for repair 2's own class miss destroys the state the defect lives in.**
`staging/probe-snippet.html:12999` sets `DB.itemOpsV2 = 0;` immediately before calling
`itemOpsReconcile()`. The defect is that the latch is *spent*; the fixture hand-clears it.

**A counterexample to H6's own framing, which fired during this pass.**
`index.html:12623` reads `const SELL_ABS_BAND_RETIRES = Date.UTC(2026, 7, 20);` and 12639 reads
`if (Date.now() >= SELL_ABS_BAND_RETIRES) return "";`. **Today is 2026-08-20 UTC — that branch flipped
sides today**, and `grep -n SELL_ABS_BAND_RETIRES tools/probe/probe-snippet.html` returns nothing.
Zero assertions on either side. It is unverifiable and it is *not* flag-gated: the unverifiable class
is wider than H6 names.

---

## A seventh explanation, which the evidence supports better than any of the six

**Verification depth rose sharply on one day, and has been aimed almost entirely at the ~7% of the
codebase written under the new standard, with no committed baseline against which "new" and
"pre-existing" can be separated.**

Grounding numbers, all re-derivable:

- **All eight adversarial passes are dated 2026-08-19.** One calendar day.
- **Six days, zero commits** (last commit 2026-08-14, after a run of 15–41 commits/day). Every pass
  ran against a tree with no intermediate revisions to diff against.
- **The verification-and-governance layer grew 4,092 lines against the product's 2,406 — 1.70 : 1.**
  `probe-snippet.html` alone out-grew `index.html` in absolute lines (+2,876 vs +2,406); assertions
  1,099 → 1,261; `MISTAKES.md` ×1.35; `CLAUDE.md` ×1.19.
- **The money-finding series tracks reader count, not repair difficulty** (flat at ~3.4 per reader
  for the last three passes).
- **The passes only ever read new code** — zero tags below §94 in passes 5, 6 and 8.
- **The closest thing to a control condition points the same way.** Pass 4 deliberately assigned a
  reader to code that did *not* change, and produced **0 findings that bite today**.
- **The decisive one: a repair-scoped pass found its worst defect outside the repairs.** Pass 8's
  highest-cost finding, 4.1, is pre-existing in the tree and no repair touched it. Only **9 of 28**
  pass-8 findings carry a NEW or AMPLIFIED label at all — **at most 32% of what a repair-scoped pass
  finds is attributable to the repair.**

**The prompt's other candidate — the same reader writing both the repair and its test — is also
supported and is secondary.** H4b's split is 8 caught by the author's own seeding against 27 by a
later reader (23% / 77%). That describes who catches a defect, not why the population is where it is.

---

## What the diagnostic cannot distinguish

**H3 and H4b are the pair.** H3 says the finding rate rises with effort; H4b says new assertions carry
a 43.2% defect rate. Both are measured only on recent, heavily-read code, and neither has a base
rate. **If the old suite carries the same 43.2%, H4b is measuring effort and not assertion quality.**
One measurement decides it and has not been made.

**H1 and H2 are NOT the same and the evidence separates them cleanly** — they get opposite answers on
the same repair. Repair 2 is the widest-coupled of the nine (H1's best case) *and* its missed defect
was entirely inside the narrow unit (H2's worst case).

---

## What would falsify the top-ranked explanation

Three measurements, each a single number:

1. **Read 80 randomly-sampled tags from §1–§93 at pass-8 depth and report the defect rate.** Below
   43.2% → the newest assertions really are worse. At or above → the rate is a property of the
   reading. Needs a per-claim normalisation, because the labels are 3.3× shorter.
2. **Run one seven-reader pass scoped to a region of `index.html` no repair touched and that predates
   2026-08-14.** Findings near 3.4/reader → coupling and repair-unit are not the drivers. Near pass
   4's zero-that-bite-today → the repairs really are where the defects are.
3. **Commit the tree and re-run one pass against a two-commit diff.** Every NEW / PRE-EXISTING label
   is currently a hand judgment applied to 12 of 28 findings. With a baseline it is mechanical.

---

## Measurements that were needed and do not exist

- **H1 has no null model.** Nothing measures what an ordinary, uncontested change scores on the same
  fourteen-way partition, so "4 of 14" has nothing to be large or small relative to.
- **H4b has no base rate** over §1–§93.
- **H5 assigned severity to 13 findings that were never independently re-derived.**
- **Passes 5, 6 and 7 did not preserve their patches**, so the by-line apparatus share can be computed
  for pass 8 only. For pass 8 it is **8.9% by hunk and 45.4% by line** (probe hunks average 95.8
  lines; product hunks average 11.3). Whether "the suite is a second system" looks marginal or
  co-equal is entirely a choice of denominator, and the hunk denominator is the one that minimises it.
