# Pass 6 — EIGHT money-path findings. Worse than pass 5, and the pattern is now the finding.

**2026-08-19. Two non-overlapping readers, per-finding adversarial verification on three lenses, a
completeness critic. 49 agents. Frozen tree, all seven hashes identical at both ends.**

## The number, first

| pass | money-path | where |
|---|---|---|
| 2 | 7 | inside pass 1's fixes |
| 3 | 1 | inside pass 2's fixes |
| 4 | 0 that bite today | — |
| 5 | 3 | two inside pass 5's own session |
| **6** | **8** | **six inside pass 5's repairs; two the critic found in the restore path nobody had enumerated** |

**Six survived three independent refuters each with none refuted. Two more come from the completeness
critic, which runs after the verify phase and so is single-reader — I confirmed one of those two by
hand.** One finding was refuted 3 of 3.

## Freeze

| file | at launch | at close |
|---|---|---|
| `index.html` | `2a917648b2f6c90f` | `2a917648b2f6c90f` |
| `tools/probe/probe-snippet.html` | `3bd1b2b34af2f8f8` | `3bd1b2b34af2f8f8` |
| `REQUIREMENTS.md` | `de38d71ea7656425` | `de38d71ea7656425` |
| `CLAUDE.md` | `6ec199c21ef16292` | `6ec199c21ef16292` |
| `MISTAKES.md` | `203a0fd13ce2e340` | `203a0fd13ce2e340` |
| `audits/SWEEP-2026-08-19-num-null.md` | `21b4bb2f4e5cf594` | `21b4bb2f4e5cf594` |
| `audits/ADVERSARIAL-2026-08-19e-pass5.md` | `caa03899dacf0759` | `caa03899dacf0759` |

Scope: the repairs made in response to pass 5 — 14 production hunks, 3 probe hunks. **The base was
reconstructed by applying pass 5's own diff to the pre-session tree and verified by hash against
pass 5's freeze**, so the delta is exactly the repair commit and nothing else. Reader A had the
diff; reader B was forbidden it. 16 and 44 call sites read in full. Neither ran the suite.

---

# THE FINDING BEHIND THE FINDINGS

**I made the same error twice in a row, and the second time was inside the fix for the first.**

Pass 5's root cause was: *the sweep was scoped to the helper's NAME (`num`) rather than to the
PROPERTY — a coercion that maps null to zero.* The repair for that was to fix the two `+s.tier`
sites pass 5 named. **I found them by running `grep -nE '\[0, ?1, ?2, ?3\]\.includes\(\+s\.tier\)'`
— a grep for the exact expression, not for the property.** Three lines below one of them sits

```
      : ([0, 1, 2, 3].includes(+raw.sourceTier) ? +raw.sourceTier : null);
```

the record-level tier, same coercion, same consequence, untouched. **The repair for "you scoped to
the spelling" was itself scoped to the spelling.** That is finding A1, and it is the most useful
thing in this report.

The same shape appears twice more: `hzH` was repaired in the *carry* while two production paths
still create positions that never stamp it (B1, C6), and the caps were classified from the list of
23 keys the settings block happens to contain, missing `slots` and `watchCap` which live elsewhere
and bound funding just as hard (A3).

---

# MONEY-PATH — verified, three refuters each, none refuted

## A1 · A third bare-`+` tier coercion, three lines from the two that were repaired
**Bites today. Confirmed by hand.** `importIntelligence` resolves a record-level `sourceTier` with a
bare unary plus, and `+null` is 0. Tier 0 is the **most authoritative** source class, so an unrated
record restores as an official one — and passes the catalyst admission gate the code says it must
fail. **Proposal:** `nz(raw.sourceTier)`; and this time enumerate every `includes(+` and every bare
`+x` on a field, not the one expression a grep was written around.

## A2 · The seven caps resolve ABSENT to their tight end, and absent was never the defect
**Bites today. This is a consequence of the ruling, not a deviation from it** — the ruling said *"for
a cap, absent must mean the tightest value, not the default."* The measured cost: **restoring any
backup that predates one of the seven fields silently rewrites seven strategy constants** —
`scoutT1Cap` and `scoutT2Cap` to 0 (the scout stops adding), `sibPerSeed`/`sibTotal` to 0,
`partCapPct` and `clusterCapPct` to 1%, `sleeveMaxPos` to 1. The *null* case was the defect pass 5
found; *absent* was always resolving to the default and never misbehaved. **This is a ruling to
re-take now that the cost is on the table**, and the two halves can be separated: null → tight,
absent → default.

## A3 · `slots` and `watchCap` are caps and were not classified
**Bites today as a false claim.** `slots` bounds how many lines the plan funds; `watchCap` bounds
the watchlist. Both still resolve a null to their loose default. `[R104.4]`'s label says *"a
settings key arriving NULL or ABSENT resolves CAPS to their tight end"* — **false as stated**, and
the classification was drawn from the 23 keys that happen to sit in one block rather than from what
each key does.

## B1 · A partial fill creates a position with no `hzH`
**Bites today. Confirmed by hand.** The split writes
`DB.positions.push({ id, itemId, name, qty: p.qty - n, buy, placedAt: p.placedAt, stage: "buying" })`
— `placedAt` is carried forward and `hzH` is not, so the remainder ages against the 4h legacy
fallback while the original leg keeps its 9.5h. **The carry was repaired and the writer was not.**

## B2 · Clearing the quantity box writes a manual size of ZERO, not "auto"
**Bites today, with no import involved at all.** `const typed = Math.max(0, clampNum(q.value, 0));`
then `w.qty = typed;` — an emptied box gives `clampNum("", 0)` = 0, so the row gets a manual size of
zero, `planQty` returns 0, and the item benches on `sizing` **with a reason blaming working capital
or a missing buy limit**. This is the exact defect the import fix was written for, on the writer
instead of the reader. **And the correct pattern is three lines above it in the same handler** —
`h.paid = v > 0 ? v : null;   // clearing the field clears the cost basis`. That is M169's shape for
the third time in one file.

## B3 · An import repaints two settings inputs out of ~30
**Latent.** After a restore the settings screen renders every other constant's **pre-import** value,
and the next edit to any of them writes that stale value back into `DB`. With the caps now able to
land at their tight end, the screen would show the old number while the allocator uses the new one.

---

# MONEY-PATH — from the completeness critic, single-reader

## C1 · A whole-state restore is never written to localStorage by the import path
**Confirmed by hand, and the most alarming thing in this report.** The import handler's only
persistence call is `flush()`, which begins `if (!dirty) return true;`. **`dirty` is set in exactly
one place — inside `save()` — and `DB = Object.assign(DB, v.db)` does not call it.** So on a tab
where nothing is pending, the restore lives in memory and is never persisted; it survives only if
some later unrelated `save()` happens to run. That is a race, which is worse than a clean failure.
**Proposal:** `save()` (or set `dirty`) at the import, not `flush()`.

## C3 · The funding queue survives a restore and reorders what the plan funds
`planPriority`, `planDemoted` and `planDate` are not written by the sanitizer, so
`DB = Object.assign(DB, v.db)` leaves **the importing browser's** promotions and demotions in place,
applied to the imported watchlist. This is the queued `DB`-key enumeration arriving early, and it is
the same restore path that dropped `hzH` and turned `qty: null` into zero.

## C6 · A second position-creating path leaves `hzH` unstamped
The bought-stage quantity correction, whose output is a standing BUY read by `staleBuyInfo` rather
than by the sell ladder.

---

# NOT MONEY-PATH, all verified

- **A4** — both canonical pointers to "the property detector" cite `[R104.4]`, which is the caps
  assertion. The detector is `[R104.8]`. A wrong cross-reference in the two places a reader would
  follow.
- **A5** — `itemTier` still carries the false universal about withholding an override that this pass
  corrected in the two other places it appears. **Three homes, two fixed.**
- **A6** — `[R104.8]` reads only `validateImport` and only **17 of the stores it sanitizes**, while
  its label claims "a row per store" and that it cannot be defeated by an unenumerated spelling. The
  first claim is false and the second is true only within the fixture's reach.
- **A7** — the allow-list is checked in one direction only: paths that appear and are not allowed
  are caught, but an allow-list entry that stops appearing is not. The REQUIREMENTS row claims **set
  equality**. This is the both-directions rule, on the list written to enforce a rule.
- **A9** — the "every optional field ABSENT" fixture builds keys **present with the value
  `undefined`**, which the sanitizer's `hasOwnProperty` branches read as PRESENT. So the absent case
  is not tested where it matters most.
- **A8** — `[R104.2]` is described as asserting "the branch that turns the stamp into a sell
  instruction". It asserts `legHorizonH`. **No assertion anywhere covers `sellAgeInfo`,
  `staleBuyInfo` or `quoteLegAge`** — the branches that actually issue the instruction. The
  assert-at-the-consumer rule, missed in the commit that cites it.
- **A10, A11** — a doc comment contradicting its own function, and a count in HANDOFF that is the
  `validateImport`-only figure quoted as a file-wide one, next to a definition of `nz` that is no
  longer the one that ships.
- **C2** — `clrGen` is missing from the shadowBook carry **that this pass edited**, so after any
  restore no paper trip can ever be clean and two held strategy proposals read as un-evidenced.
- **C4** — seven browser-scoped provenance keys survive an import that replaces the populations they
  describe, so the epoch banner and the analysis export state a generation and a start date
  belonging to the importing browser.
- **C5** — the allow-list files two measured percentages as counters "whose zero is the documented
  start of the count", while the same carry preserves a sibling measurement's null three lines later.

# REFUTED

**B5** (3 of 3) — that `nz` turns `""`, `false` and `[]` into 0 and is therefore narrower than its
own comment claims. The refuters established the comment's stated property is about null and absent,
and the other falsy coercions are `num`'s documented behaviour at call sites where 0 is the default.

# COVERAGE, as declared

Reader A: 16 call sites in full, and a long list of brief questions that **came back clean** — no
other `nz` identifier exists anywhere, the inlined expression is character-identical to `num`'s body
for every input it checked, no temporal-dead-zone path reaches `nz` before initialisation, the intel
site has it in scope, none of the seven tight values divides or empties a set, `impTight` is on
exactly the seven intended keys, and M169's corrected count is accurate. It did **not** read the ~19
stores absent from `[R104.8]`'s fixture at full depth, the IndexedDB stores, or the probe outside
§103/§104.

Reader B: 44 call sites. It did **not** read the scorer's read surfaces, the weekly review,
gate-health or prospecting renderers.
