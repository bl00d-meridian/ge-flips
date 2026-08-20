# The repair ledger — one row per repair, with the property named twice

**Ruled Aug 19 2026.** Every repair that goes through the staged cold-review pass lands a row here.
The proposal is `audits/PROPOSAL-2026-08-19-cold-repair-review.md`; the mechanics are
`tools/stage/*.sh` and the `PROBE_SRC` / `PROBE_SNIPPET` / `PROBE_REQ` overrides in
`tools/probe/run.sh`.

## Why the property is recorded twice

A repair made under the pressure of a just-delivered finding gets scoped to that finding's
**spelling**. Three instances in one week, each the repair for the one before it (MISTAKES M170).
The separation that works is not time — the same reader an hour later still has the finding in
front of it — but a **cold** reader, shown the diff and not the finding, and asked what property
the repair is about rather than whether it fixes the reported case.

**The user's addition to the proposal, and it is what makes this file worth keeping:** record the
cold reviewer's answer beside the repairer's own. If a later pass finds the same property somewhere
else, the two answers say which of two different failures happened —

- the **property was named too narrowly** (both answers are narrow, and the search was faithful to
  a bad definition), or
- the **search was run too narrowly** (the answers are right and the grep did not reach every site).

Those need different fixes, and with only one answer on record they are indistinguishable.

**The columns are deliberately not merged.** If the reviewer's wording is just a paraphrase, say so;
if it is genuinely a different property, that is the interesting case and it goes in as written.

## Ledger

| # | date | repair | property, as the REPAIRER named it | property, as the COLD REVIEWER named it | sites the reviewer's property returned | sites the finding named | verdict |
|---|---|---|---|---|---|---|---|
| 1 | 2026-08-19 | every path that creates a leg stamps its horizon (`hzH`) | *Every code path that creates a leg — a position or a standing quote — records the fill horizon in force when that leg was PLACED; a path that splits or re-tracks an existing leg carries the ORIGINAL's stamp rather than re-deriving one from the current schedule.* | *Any record that is later AGED against a horizon carries the horizon in force when the underlying ORDER was placed; a record derived from an existing one — split, remainder, undo, re-list — inherits rather than re-derives; and a record whose real placement moment is unknown gets no fabricated stamp unless the record already declares that same approximation in another field.* | **8 creation sites across 4 record types** — 4 `DB.positions.push`, 1 `w.quotePlaced`, 2 paper-book trips, 1 scorer trip — plus 5 carry-by-identity paths (3 undo splices, the `{...qp}` snapshots, `validateImport`'s conditional carries). All 8 stamped in the staged file; **nothing untouched and defective.** Wider than the repairer's, which stopped at *a position or a standing quote*; the 2 extra record types were already correct. **One divergence, and theirs is better:** my phrasing would have left `trackExistingOffer` ABSENT; their argument — its own `placedAt: Date.now()` already declares *ages from now*, and the fallback is a second silent approximation — wins, and I withdraw mine. | 2 | PASS |
| 2 | 2026-08-19 | operator state has one owner in each direction | *The six operator-state fields (`tBuy`, `tSell`, `tAt`, `qty`, `tierOv`, `t2Grad`) have exactly one owner in each direction: `opsOf`/`opsFor` for every read, `opsWrite` for every write. No site reads or writes any of them off a watch row directly.* | *A field whose authoritative LOCATION can move under a flag has exactly one term resolving reads and one resolving writes; no site touches either location directly, and a caller already holding the row passes it rather than re-finding it by id.* | **21 live accesses** — 6 writes (all through `opsWrite`), 15 reads (all through `opsOf`/`opsFor`). Returned and NOT defective: `opsSet` called directly by the two pool controls (reachable only in the armed regime, where `opsWrite` routes there anyway — a layered pair, not a second owner); `itemOpsMigrate` / `itemOpsReconcile` / `validateImport` (they read the row AS the row). Returned and out of scope BY DESIGN: `invTarget` and `scoutTier`, which the file's own overlay comment lists beside the six — one owner each (the row) in both regimes, so they satisfy the property rather than breaching it. | 4 | PASS |
| 3 | 2026-08-19 | the three cutover flags stop being independent | *Wherever two or more deployment-class flags can be ruled separately, the combinations they produce are enumerated, and any combination that WIDENS what the allocator may fund is refused outright and says which flag is missing.* | *A const naming a RULED intent and a term naming what is IN FORCE are different values. Every consumer that acts on, records or describes the state reads the in-force term; the const is read only where the question is literally "what was ruled".* | **7** — 6 in-force consumers all re-pointed, plus 1 correct const read (`cutoverFaultWarn`'s *was it armed?*). I also enumerated the combinations in BOTH directions rather than taking the widening one on trust: of 8, only `pool && !vol5` widens; `!pool && vol5` was checked and only ever SHRINKS a size, so refusing it would be restraint refusing restraint. | 1 (the vol5 pairing) | PASS |
| 4 | 2026-08-19 | seasoning distinguishes absent from failed | *A gate verdict may reset a streak only for an item that was actually EVALUATED. An item not evaluated this cycle neither breaks a streak nor credits one, and absence is never filed as failure.* | *A counter driven by per-cycle verdicts distinguishes three states — passed, failed, not evaluated — and acts only on the two that are verdicts. Where the population reaching the verdict loop is a SUBSET of the population the counter governs, the complement is not-evaluated and needs its own record.* | **3 per-cycle counters** — `DB.qual` (fixed here), `S.vol5Low` (already three-stated: `counted ? n : null`), `DB.poolSeen` (already a pass/observation pair with a named `not-scored` state). I also checked the CADENCE seam the property implies: the fail set is written in the same scorer pass as the pass set and the plan consumes it faster — over-consumption is idempotent, under-consumption cannot occur. Nothing untouched. | 1 | PASS |
| 5 | 2026-08-19 | NEXT UP carries the separation | *Any rendered ordering of candidates that mixes populations whose scores are not comparable shows the separation — and never claims an ordering the funding path does not have.* | *A rendered list must not imply a grouping or ordering the mechanism lacks — and must not hide one the mechanism has. Both directions, because the second is how a real split gets rendered as a flat queue.* | **4 rendered candidate lists** — funded picks (grouped), NEXT UP (grouped, disclaimer withdrawn because it stopped being true), Qualifying (deliberately ungrouped, reason recorded at the site), Benched (carries no ordering claim, so there is nothing to show). Paraphrase of the repairer's, widened to the second direction. | 1 | PASS |
| 6 | 2026-08-19 | the `qualV1` ruling recorded at its site | *A restraint may not be lifted by a file: a restored file's rows season from scratch.* | *No value a file carries may LIFT a restraint the importing browser would otherwise apply — and a one-shot migration flag IS such a value, because its carried value decides whether a restraint-applying migration runs.* | See row 9 — same property, and row 9 is where the wider search lands. **Repair 6's own two sites are complete.** | 1 | PASS |
| 7 | 2026-08-19 | A1 — the funding walk splits the two populations (ruled, deployment-class) | *Wherever the plan orders candidates, one comparator owns the order, populations whose scores are not comparable never interleave, and an explicit operator override crosses every boundary.* | *Exactly one comparator owns the order of a candidate set; every render of that set reads it; populations whose sort keys are not comparable never interleave; and an explicit operator override crosses every boundary.* | **8** — 6 fixed, 2 returned and named in the source (`applyFamilyRule`'s `x.score > cur.score`, and the raw `sort(b.score - a.score)` pre-sort feeding it). **The interaction is worth stating and is not in PASS.md:** family-winner selection runs on raw score BEFORE `planOrder`, so A1's guarantee is not yet whole — after the cutover a pool item can still BENCH a pin by winning its family, which is displacement arriving one stage earlier than the funding sort. Seen and queued, not missed. | 1 | PASS |
| 8 | 2026-08-19 | the boot merge gets the cap rule from one table | *"What is a legal value for a capacity setting" has exactly one owner, and every path that writes `DB` reads that owner.* | *A value's legality rule has exactly one owner — and MEMBERSHIP of that rule is decided by what the value DOES (does it bound what may be funded, sized or admitted), never by which object literal, which previous helper, or which earlier version of the rule it happened to share.* | **12, not 11.** The nine in the table, plus **`t1Budget`, `t2Budget`, `sleeveBudget`** — untouched. Each bounds what may be funded more directly than `slots` does (`pools = { 1: Math.min(t1Budget, deployable) }`); each resolves a present-but-unreadable value to its LOOSE default (60m / 30m / 60m) where the table's own rule says tight; and none is reached by `clampCapKeysAtLoad`, so the boot path still has for budgets the exact hole this repair closed for caps. The classification is also internally inconsistent: `sleeveMaxPos` (the sleeve's COUNT cap) is in the table while `sleeveBudget` (the same subsystem's MONEY cap) is not. **This is the repair's own recorded failure mode one generation later** — its comment says v1 *missed `slots` and `watchCap` because it was drawn from the 23 keys that happen to share one object literal*; v2 was drawn from the 9 keys that happened to share `impCap`. | 2 paths | **SENT BACK** |
| 9 | 2026-08-19 | `DB.qual` is not carried (the user's correction to their own ruling) | *A restraint may not be lifted by a file, by any route — and a completed seasoning streak lifts one whether it arrives by re-running the grandfather migration or verbatim in the file.* | *Same as row 6 — no value a file carries may LIFT a restraint, by any route, including a carried migration flag.* | **Property named RIGHT, search run NARROW** — which is the distinction this column exists to record. The repairer's wording is already the wide property; the grep was scoped to `qual`. Two instances the wider search returns, both untouched: (a) **`shadowExceptions` carries `status: "waived"`**, a standing per-item gate waiver, on the one-line rationale *these are RULINGS* — the identical argument the user overruled for `DB.qual`; (b) **`slotsSRA1`/`slotsSRA2` carry as `d.x ? 1 : 0`**, so an older backup lacking them writes an explicit **0** over the importing browser's 1 and re-runs the pair on the next boot — with a stored `slots: 6`, SRA1 no-ops and SRA2 raises it to **7**. Both sit inside the queued restore track, so this is PASS with the carry-forward named rather than SENT BACK. | 1 | PASS |

## The cold review of 2026-08-19 — what the two columns actually said

**Eight PASS, one SENT BACK.** The one that failed is row 8, and it failed the same way its own
comment says its predecessor failed: **membership drawn from where the keys live rather than from
what the keys do.** v1 was drawn from the 23 keys sharing one object literal and missed `slots` and
`watchCap`; v2 was drawn from the 9 keys that had shared `impCap`, and missed the three budgets.
The fix is three rows in `CAP_KEYS`, not new machinery — which is exactly what makes it worth
sending back rather than waving through, because a one-line fix that nobody makes is still absent.

**Two rows carry a genuinely different property rather than a paraphrase**, and they are the ones
worth reading:

- **Row 8** — the reviewer's property makes MEMBERSHIP part of the rule; the repairer's makes
  ownership the whole rule and treats membership as an input to it. Only the first phrasing can
  fail.
- **Row 9** — the property was named RIGHT and the search was run NARROW. This is the first
  recorded instance of that half of the diagnostic, and it is the half the ledger was built to be
  able to see. The remedy is different from row 8's: nothing about the wording needs changing, the
  grep does.

**Rows 1 and 7 record a divergence that resolved in the repairer's favour**, which is also worth
keeping: on row 1 the reviewer's stricter *absence stays absence* reading would have made
`trackExistingOffer` worse, and the repairer's argument from the record's own `placedAt` is the
better one. A ledger that only ever recorded the reviewer catching the repairer would be a ledger
nobody trusted.

**One thing the mechanism itself got wrong, reported rather than fixed:** `staging/PASS.md` is on
the reviewer's READ list and contains, for repairs 1 and 2, a section headed *"The finding that
provoked it (for the record; the cold reviewer is NOT shown this)"*. The reviewer was shown it. The
searches for those two rows were run property-first regardless — repair 1's returned 8 sites where
the finding named 2, and repair 2's returned 21 where it named 4 — but the contradiction should be
closed by moving those blocks to a sibling file the READ list excludes, or by writing them only
after the review lands.

## Escape hatch, as scoped by the user

A **single-site fix with no generalisation available** may land in one session — the `flush()`/
`save()` swap is the example on record. **The moment a repair implies "and everywhere else like
it", it stages.** A repair that takes the escape hatch does not get a row here; if it later turns
out to have had a generalisation after all, that is a MISTAKES entry, not a retroactive row.

## Addendum after the adversarial pass — the reviewer's own search was narrow on row 4

**Recorded here rather than quietly corrected, because the ledger's value is that it records the
misses too.** The pass over these nine repairs
(`audits/ADVERSARIAL-2026-08-19h-pass8-staged-repairs.md`) found that **an offline boot, or one
`/latest` response with an empty payload, deletes the entire seasoning store** — `updateQualStreaks`
is the only accrual path with no live-data precondition, `renderAll()` runs from `doRefresh`'s
`finally`, and `candidateFor` returns `failed: "no live price in /latest"` for every row, which the
pass loop reads as a gate failure and resets on.

That is row 4's property exactly, in the reviewer's own words: *"acts only on the two that are
verdicts."* A failure caused by missing DATA is not a verdict. **The property was named right and
the search was run narrow** — it checked the three counters for how they handle *absence from the
candidate list* and never asked what else can set `x.failed`.

So the pair on row 4 now reads the same way row 9's does, and the diagnostic points at the search
discipline rather than at either wording. The concrete lesson for the next property-scoped search:
**when a property is about how a signal is CLASSIFIED, enumerate every producer of that signal, not
only the consumers of it.** Row 4's search enumerated consumers.

Row 1 also resolved against the reviewer, and the pass reversed that: the cold review withdrew its
*absence stays absence* clause for `trackExistingOffer` in the repairer's favour, and the pass showed
the withdrawal was wrong for a reason neither naming stated — `legHorizonH`'s fallback has a
one-hour floor and `placementHzH()` has none, so the new stamp is a strict regression in the
near-touch case. **Both namings were incomplete in the same direction**, which is the third cell of
the diagnostic and the one neither column can fill on its own.
