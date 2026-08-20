# The whole-`DB` key enumeration — what a restore silently keeps from the importing browser

**Queued by the user, Aug 19 2026, as the gate on the restore track: *"I am not restoring a backup
until it closes."*** Five read-only tracing agents plus a completeness critic, over a frozen tree
(`index.html` `3cf9a22d321892e5…`, unchanged at both ends). Every verdict below rests on quoted
source traced to a consumer; **no finding rests on a suite result.**

## The defect class

```js
function applyImport(v, persist){
  DB = Object.assign(DB, v.db);
  ...
}
```

`v.db` is built by `validateImport` (24499–25326) as a fresh object listing the keys it sanitises.
**`Object.assign` only overwrites keys the source object HAS.** Any `DB` key `validateImport` does
not write therefore **keeps the importing browser's own current value**, silently, while everything
around it is replaced by the file's.

The sanitiser already knows this about itself. From the `scorerT2` carry at 24774:

> *"carried explicitly, because this sanitizer enumerates keys and an unlisted key silently dies on
> restore (R68.9, applied before the fact rather than after)."*

It was applied before the fact for that one key. This enumeration is the same question asked of
every other one.

## The derivation, and the correction the critic forced

Union of `DB`'s declaration literal (~1240) and every anchored `DB.<ident>` reference in the file,
minus every key written inside the returned `db: { … }` literal.

**29 keys are never written by `validateImport`.** The first derivation said 30; `DB.open` was a
regex artifact of `indexedDB.open` at line 2120 and is struck. Two more —
`recipeLog`, `recipeFlags` — appear only inside a withdrawal comment at 14134 and no live code
writes them, so **27 are live keys** and those two are dead residue that an old localStorage blob
can still carry (the boot path has no pruner, so nothing will ever clear them).

| bucket | keys |
|---|---|
| **WRONG** — survives and changes a decision, makes a claim the data does not support, or leaves the restored `DB` inconsistent with the data that *did* restore | **17** |
| **HARMLESS** — survives, and a named recomputation erases the difference before anything reads it | **6** |
| **DELIBERATE** — describes THIS browser or THIS visit and must not travel | **6** |

---

# WRONG — 17 keys

## Bites today (12)

| key | what actually happens |
|---|---|
| `poolSeen` | **The pool-persistence ledger's numerator and denominator are split across the restore boundary.** `poolPersistence` computes `obs = (cell.cycles \|\| 0) - (r.c0 \|\| 0)` at 6276, where `cell` comes from `DB.scorerT2` (**carried**) and `r` from `DB.poolSeen` (**not carried**). The era guard at 6270 does not save it: the control hash is derived from `GATE.*` plus `DB.tickFloor` and `DB.filtersT1.vol`, both of which restore, so the same user restoring onto a second profile gets the same hash and the cross-browser arithmetic runs. Local `c0` above the file's `cycles` yields `obs = 0` and the badge on every funded plan row reads **"funded 4200 of 0 observed cycles"**; it does not self-correct, because 6239 leaves the row alone while the hash matches. |
| `calib` | The fill-model calibration result outlives the flips it was replayed over. |
| `planDate` · `planPriority` · `planDemoted` | The day-scoped plan-ordering triple. `resetPlanOverrides()` fires only when `DB.planDate !== today()` (5297) — and `planDate` is local, so a browser worked in **today** keeps its local hand ordering and applies it to the **file's** items. This is the pair the user already had on the owed list; `planDate` is the third leg and is why the reset never fires. |
| `prevOpenAt` · `homeSnapPrev` · `flatSince` | The WHAT CHANGED clock. `prevOpenAt` is the boundary every delta line filters imported rows against (21948), so a restore either announces **nothing** ("Nothing moved since your last visit", over a book that was just wholly replaced) or announces a week of another device's events as new — including *"⚠ escalated to SUSPECTED PUMP"*. `flatSince` counts the **file's** paper trips against **this** browser's flatness boundary. |
| `paperEpoch` · `shadowEpoch` | Epoch labels that outlive the population they name; the age renders wrong on screen and in every analysis export written afterwards. |
| `shadowPurgeV1` · `paperEpoch2` | **The one-shot migration flags, and this is the sharpest shape in the set.** `if (!DB.shadowPurgeV1){ … DB.shadowPurgeV1 = 1; }` (1401–1410) and `if (!DB.paperEpoch2) paperEpoch2Reset();` (1439). Restoring a **pre-migration** file into a browser that has **already run** the migration leaves the flag set, so the migration never runs on the imported data — **permanently**, because a one-shot flag that is already set has no path back. And `inbox/` is where such backups are collected by standing practice. |

## Latent (5)

`itemOpsV1` (armed by the `ITEM_OPS` ruling — an imported watch row never migrates into the item
store) · `qualEvict` (armed by `CUTOVER_POOL`) · `reorgV1` (armed by a **clock** — 90 days after the
newest old-key stamp in the imported file) · `paperClrGen` and `paperDefectsClearedAt` (armed by the
build that strikes the last entry from `PAPER_DEFECTS`).

---

# HARMLESS — 6 keys, each with its recomputation named

`homeSnap` (re-stamped by `renderNow` at 22530; the narrow exception is an **offline** restore
followed by a visit roll before live prices land) · `poolSeenEvict` (writing it needs 3000 rows) ·
`qualV1` (`updateQualStreaks` at 6561 rebuilds each row from live observation within one calendar
day) · `reviewEngagedAt` (cleared by `rollVisit()` at the next boot past the 2h gap) · `recipeLog`
and `recipeFlags` (dead residue — the harmlessness rests on the total absence of any reader, which
the tracing agent stated rather than inventing a refresh path for).

**Two of these are conditionally harmless and say so.** `poolSeenEvict` **becomes WRONG the moment
`poolSeen` is carried** — the counter and the store it explains must move together or stay together,
never split. And `reviewEngagedAt` is safe only because its partners `visitStartAt` and
`ckDismissAt` are also dropped; a one-sided sweep breaks it.

---

# DELIBERATE — 6 keys, and the finding is that only one of them says so

`lastOpenAt` · `visitStartAt` · `ckDismissAt` · `ckPref` · `watchSort` · `paperDefectsSeen`.

**The uniform recommendation is not a code change: it is to write the intent at the site.** A
deliberate omission recorded only in an audit is one the next reader will "complete" while
tidying — which is the standing rule about recording exceptions where they live. `paperDefectsSeen`
is the clean case: its correctness is *structural* (it is only ever compared against
`paperDefectsOpen()`, a build-time constant of the browser doing the comparing), and nothing in the
source says so.

---

# Six findings the key-by-key question could not have produced

These came from the completeness critic, and they are the reason a critic pass is worth its cost.

1. **The boot merge has no sanitiser at all.** Line 1363: `DB = Object.assign(DB, JSON.parse(raw))`,
   on **every boot**, with no clamping, no coercion, no cap rule. The import path clamps every field
   under a ruling that *an import may never loosen*; the load path applies none of it to the store
   that ruling's output was written into. **Two owners of "what is a legal `DB` value", and only one
   enforces it** — which is the constitution's own newest BINDING rule, found in the largest store
   in the app. Its clamp half is latent (armed by any build that tightens a cap constant, since the
   pre-existing store then reloads the loose value forever); its permanence half bites today.

2. **Five IndexedDB stores are outside the restore entirely** — `rdiff`, `t1`, `t1open`, `m5`, `h1`.
   `rdiff` is the **cutover gate's own evidence**, it accrues on every 5m arrival with no flag, and
   a restore splices another browser's book into a ledger that cannot tell that happened. Proposed
   fix is a partition, not a carry: stamp each row with a book identity, or write a restore marker
   row at `applyImport`, so the ledger can partition at the restore instead of pooling across it.

3. **`shadowBook[].clrGen` is a ROW-LEVEL omission the key-level derivation is structurally blind
   to**, and it defeats the very partition the `paperClrGen` finding rests on. A key-by-key
   enumeration cannot see inside a carried array.

4. **The visit-clock cluster's intent IS recorded at the site, and `Object.assign` does not
   implement it.** The comment at 21832–21835 describes a behaviour the merge cannot produce. That
   is worse than an unstated omission: the source asserts a property the code does not keep.

5. **`watchSort` is contradicted by its own sibling.** `DB.sort` is the same concept and **is**
   carried. One of the two is wrong; the current state, where two halves of one idea disagree, is
   not a defensible position either way.

6. **`qualV1`'s implied fix is deployment-class and must not ride a remediation commit.** Carrying
   it would grandfather restored rows past the seasoning gate — **a restraint lift**, which needs a
   ruling. This is exactly the trap a "treat the five migration flags as one class" sweep would walk
   into: four of them want carrying, and the fifth wants a ruling.

---

# What is owed, and what is not proposed

**Nothing here is fixed.** The user's instruction was to enumerate and sort, and the restore track
is the least urgent of the three — the backup is not being restored until this closes.

Two things to decide before any repair is written:

- **The remediation is not one commit.** Fourteen keys want carrying, six want a comment at the
  site, one wants a ruling, and two of the structural findings (the boot merge, the IndexedDB
  stores) are bigger than the import path. Repairing them as one "carry the missing keys" sweep is
  the M170 shape at scale — the property is not *"keys are missing"*, it is *"a restore must leave
  the DB internally consistent"*, and those imply different edits.
- **`poolSeen` interacts with the cutover.** It is the pool-persistence ledger, which is the
  evidence base for the seasoning measurement inside the cutover ruling. A restore performed before
  this closes corrupts the measurement the ruling depends on.

Full per-key reasoning, with every quoted line and every asymmetric case walked:
`.claude/…/subagents/workflows/wf_2e87decf-36f/journal.jsonl`.
