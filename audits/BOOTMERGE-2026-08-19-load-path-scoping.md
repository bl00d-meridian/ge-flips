# Scoping — the boot merge, and whether the import's sanitiser serves at load

**Directive 6, Aug 19 2026: *"THE BOOT MERGE IS ITS OWN TRACK, above restore in priority."***
Scoping only. Nothing is built and nothing is proposed for ratification; the two questions asked are
answered, and a recommendation is stated at the end.

## The two lines

```js
1363:  if (raw) DB = Object.assign(DB, JSON.parse(raw));          // every boot, no sanitiser
24482: DB = Object.assign(DB, v.db);                              // import, v.db from validateImport
```

Both merge into the same object. The import path clamps every field under a ruled rule — *an import
may never loosen* — and the load path applies none of it. **That is one question with two owners,
and only one of them enforces the answer**, in the largest store in the app, on the path that runs
every single boot rather than only when a backup is restored.

The load path is not naked: lines 1364–1372 already normalise **shape** — every array key is forced
to an array, every object key to an object, `filters` is merged over its defaults. What it does not
do is check a single **value**.

## Q1 — does `validateImport` serve at load? **No, and for four reasons that are not cosmetic**

**(a) It drops rows, by design.** Six `rejected++` counters and **22 `filter(Boolean)` passes** in
the returned `db` literal. Dropping is correct for a *foreign* file: a malformed row in something
carried in from elsewhere is not worth keeping. The store on disk is **the user's own trading
record**, and dropping there is destroying data with no press and no undo. The same code, same
input class, opposite correct behaviour.

**(b) It mints ids.** `const o = { id: id > 0 ? id : uid(), … }`, where `uid()` is
`Date.now() + seq++`. At boot, any row missing an id gets a **new id on every boot** — so anything
that joins on id (the fill telemetry, the decision log, `poolSeen`, `qual`) breaks, and the row's
identity changes daily. There are seven `uid()` sites in the literal.

**(c) It caps and slices.** Sixteen `.slice(-N)` calls inside the returned literal, including
`.slice(-4000)` on the gate ledger and `.slice(-500)` twice. At load those become a **retention
prune running on every boot** — an unruled, silent, irreversible trim of the user's own store, and
the retention rules were written for what a file may carry, not for what a store may keep.

**(d) The cap rule is import-specific by construction.** *Null → the tight end* exists because a
malformed or hand-edited **file** may not relax a restraint through a channel that may only ever
drop them. Applied at load it would silently tighten nine strategy constants on a store the user
never edited. And it is inert on healthy data anyway: **no path in the app writes null to any
settings key** — every setting goes through `clampNum`, which always yields a number — so the rule
would only ever fire on an already-corrupt store, where tightening is a guess rather than a policy.

**The general shape, and it is the reusable part: a sanitiser is written against a THREAT MODEL, not
against a schema.** `validateImport`'s threat is *this file may be wrong and is not mine*. The load
path's threat is *this store is mine and may have been written by an older build*. Same schema,
different threat, and the policies are opposites at every one of the four points above.

## Q2 — what would a load-path sanitiser cost?

**Runtime.** On a mature store the row-level work is dominated by `flips`, `shadowBook`, `gateLog`
(capped at 4,000), `deployLog`, `dieOffLog`, `scorerT2` and `qual` — on the order of **10–30k row
transforms**, on the critical path, before the first render, on a phone. Not fatal; not free; and
paid on every boot for a defect that fires only on corrupt data.

**Semantics.** It needs a *different policy*, not a reused one: **validate-and-quarantine** rather
than validate-and-drop. A row that fails at load is set aside and reported, never deleted. That is a
new store, a new surface to report on, and attention budget — under the zero-based complexity rule
it has to displace something.

**Coverage.** It would still not close the permanence half. Keys this build no longer writes
(`recipeLog`, `recipeFlags` — prose in a withdrawal comment, live in no code) merge in on every boot
forever, because **the load path has no pruner at all**. A sanitiser that enumerates keys would drop
them, which is the drop-vs-quarantine problem again, one level up.

## The recommendation — fix the defect where it lives, which is not "no sanitiser"

**The defect is that the clamp rule has two owners.** That is closable without a load-path sanitiser
and without any of the four hazards above:

1. **Extract the clamp rules into one term applied on both paths.** `impCap(o, k, tight, def)` and
   the nine-key cap set already exist and are pinned by name in `[R104.9]`. A boot-side call that
   clamps those nine keys **into range without dropping anything** is a bounded loop over nine
   scalars — no row work, no measurable cost, no data loss. One owner for the cap question.
2. **Extend the existing shape guard to values for those nine keys only**, beside the array/object
   normalisation already at 1364–1372, so the guard sits where the reader will look for it.
3. **Report unknown keys rather than deleting them.** A census at load — which keys are present that
   this build neither reads nor writes, and what they cost in bytes — surfaced once, with deletion
   on a press. That closes the permanence half without a build ever guessing that a key is dead.

**What this deliberately does not attempt:** row-level validation of the user's own store. The
honest position is that the store is trusted because it is theirs, and the one thing that must not
differ between the two paths is the rule about what a **legal value** is — not the rule about what a
legal **row** is, which is genuinely different for a file and for a store.

## What is owed before any of this is built

- **A ruling on 1 and 2**, because clamping settings at load changes behaviour on a corrupt store,
  and the direction is tightening. It is restraint, so it is the lighter class — but it is a
  behaviour change on the boot path and it is stated rather than assumed.
- **3 is a new surface** and costs attention; it needs the what-does-this-replace answer.
- Nothing here is urgent in the way the live-trading track was: the clamp half is latent (armed by
  any build that tightens a cap constant, since the pre-existing store then reloads the loose value
  forever) and the permanence half is a quota cost rather than a wrong number.

---

## RULED, Aug 19 2026 — items 1 and 2 approved and built; item 3 held

> **"Boot merge: items 1 and 2 of the recommendation approved (one clamp term, shape guard extended
> to the nine keys). Item 3 (the unknown-key census) needs its displacement answer first."**

**Built and staged** (`staging/PASS.md` repair 8, `[R107.14]`): `CAP_KEYS` owns the nine keys with
their tight ends and defaults; `capResolve` is the import's resolution and reads that table at all
nine call sites; `clampCapKeysAtLoad` is the load path's, placed beside the existing shape guard.
`impCap` was deleted rather than left unused, and `[R104.9]`'s subject moved from the call sites to
the table with a second limb requiring every key to be spent inside the sanitiser.

**The load rule is the smaller one, and its limits are recorded at the site:** a cap key present and
not a finite number resolves to its tight end, and nothing else. No range-clamping of a finite value
(`slots: 0` clamped up to 1 would widen on corrupt data), an absent key left absent, nothing dropped,
and the warn bar raised when it fires.

**Item 3 is held on its displacement answer, which is not yet written.** The honest statement of what
it would cost: the census is a new surface reporting which keys are present that this build neither
reads nor writes, and what they cost in bytes, with deletion on a press. Under the zero-based
complexity budget it has to replace something, and the candidate is not obvious — the nearest
existing surface is the state-backup panel on the Flip Log tab, which reports nothing about the
store's contents today. **What it buys is bounded and known**: two dead keys are on record
(`recipeLog`, `recipeFlags`, prose in a withdrawal comment and live in no code), and the quota cost
of an old blob carrying them is unmeasured. **Measuring that cost is the cheaper first step** and
does not need a surface at all — until it is measured, the census is a feature proposed against an
unknown benefit, which is the shape the complexity budget exists to refuse.
