# Operator state, re-keyed from rows to items — shape for ruling

**Step B. Report only; nothing built.** Deployment-class in its own right: a tier override
changes what the allocator may fund. The tier override lands **with** the flip, not after —
it is the escape hatch for the 66% of control-cell items that land untiered.

---

## §1 · One store, not six — and only four of the six migrate

**One store.** All of these answer the same question — *what has the operator said about
this item?* — and they share a lifecycle: they are the user's own input, they outlive any
particular pool membership, and they need the same retention and the same carry. Six stores
would mean six partition answers, six retention rules, six import-carry entries and six
chances to forget one. The one-flag-one-meaning rule argues for separate **fields**, never
separate stores.

```
DB.itemOps = { [id]: { tBuy, tSell, tAt, qty, tierOv, bands, t2Grad, setAt, src } }
```

**But two of the six do not belong in it**, and saying so is most of the value of this
report:

| field | disposition | why |
|---|---|---|
| tested prices (`tBuy`/`tSell`/`tAt`) | **migrates** | the operator's own price truth, item-scoped by nature |
| manual qty (`qty`) | **migrates** | an intent about an item, not about a list membership |
| **tier override (`tierOv`)** | **migrates — and is the one that must land with the flip** | the only re-admission path for the untiered 66% |
| t2 graduation stamp (`t2Grad`) | **migrates** | earned by realized round trips on the ITEM; today it is written onto a row that a pool item does not have, so it currently **cannot fire** and an item re-ramps for ever |
| scout provenance (`src`, `scoutTier`, `sib`, `sibAt`, `sibGrad`, `addedAt`, `lastPass`) | **DIES, does not migrate** | it records **how an item got onto the watchlist**. After the cutover there is no admission, so it describes nothing. It stays on watch rows while pins exist and retires with the scanner on the ruled retirement — migrating it would carry a vocabulary into a world that has no referent for it |
| inventory target (`invTarget`) | **belongs to its own ruling, excluded here** | the handoff already assigns it: *"frozen `invTarget` re-keys to pinned-item state or retires by ruling."* MM is benched, so nothing is lost by leaving it, and sweeping it in would pre-empt a decision you have already reserved |

**Four migrate. One dies. One is already spoken for.**

---

## §2 · The partition question, answered at birth

**What regime writes it: the OPERATOR, by hand, through a control. There is no automated
writer and there must never be one.** The press *is* the provenance — the `frictionLog`
precedent — so no `by` field is needed today. **If an automated writer ever appears, rows
gain `by` before it writes its first row**, per the `auto`/`by` ruling.

**What fields record the regime:**

- **`src`** — `"migrated"` (copied from a watch row by the one-time migration) or absent
  (set by the operator after the store existed). This matters because **the tested pair's
  16-hour TTL is measured from `tAt`, and a migrated `tAt` is genuinely old**: without the
  stamp, a migrated pair and a fresh one are indistinguishable at the moment the store is
  created, which is exactly when a reader would most like to know.
- **`setAt`** — when the operator last set any field on this row, so a stale override is
  visible rather than eternal.
- **`bands`** — **the live tier-band pair `(TIER1_MIN, TIER2_MAX)` in force when `tierOv`
  was set.** This is the partition answer that would otherwise bite silently: the tier
  override's *meaning* depends on the bands, the bands are a strategy parameter you may well
  move (see `audits/CEILING-2026-08-18-above-t2.md`), and an override recorded against the
  old bands may afterwards be a no-op or may be doing something different. A reader whose
  bands differ from the row's renders the override as **"set under different bands"** rather
  than applying it silently.

**On regime change:** rows are not restamped. A band change closes the meaning of every
`tierOv` recorded under the old pair; those rows still exist and still render, labelled.

**Retention:** `setAt` staleness against a **storage** bound plus a declared cap, the
`DB.qual` shape — and the same warning attached to the constant, that this is not a claim
that an override expires. **An override that expired silently would be a restraint lifting
with no press**, which is the constitutional line.

**The import carry takes every field**, in the R68.9 / `[R87.5]` shape: recognised values
carry, absent stays absent, unrecognised values are dropped rather than smuggled.

---

## §3 · Migration: **copy, do not move**

On first load, for every watch row carrying any of the four fields, write the value into
`DB.itemOps[id]` **if absent**, stamp `src: "migrated"`, and **leave the watch row's copy
in place.** Guarded by a one-time flag (`DB.itemOpsV1`), the `qualV1` precedent.

**Why copy rather than move**, and this is the load-bearing choice: a one-way move makes the
migration unrollbackable and puts the entire book behind one boot. Copy is **idempotent**,
the read-through fallback keeps behaviour bit-identical if the migration is interrupted
half-way, and the watch-row copies retire naturally with the admission machinery instead of
needing their own deletion pass. The cost is duplicated data for one era, which is cheap and
visible.

**Read order:** `itemOps[id]` first, watch row second. While the flag is off the store is
never written by a control and never contains anything the row does not, so the fallback
returns today's value every time.

---

## §4 · How the controls render for a pool item with no row

**They render on the ITEM, not on the row** — the plan line and its drill, which every pool
item has. A pool item with no `itemOps` entry renders each control in its **empty state with
a reason**, never blank:

- tier override → *"no override; untiered at 555,377 gp — above the 100k ceiling"*
- tested pair → *"never margin-tested"* (which is also why it has no seasoning exemption)
- manual qty → *"sized by the allocator"*

**The walk-up-budget objection, answered because it is the obvious one:** an override is a
**hand press on a control**, like a margin test — not a `pendingRulingItems` entry — so it
costs **nothing** against the ≤7 budget. The budget counts rulings the surface *presents*;
it does not count affordances the operator may choose to use. Adding a control is free under
it; adding a prompt is not, and this adds no prompt.

---

## §5 · The flag, and what "off" means

`ITEM_OPS = false`, pinned like `CUTOVER_POOL`.

- **Off:** the store may exist and the migration may have run, but `candidateFor` reads the
  watch row exactly as today. **Behaviour is bit-identical**, and the assertion says so by
  absence.
- **On:** `candidateFor` reads `itemOps` first. This is the deployment-class half and it is
  what your ruling arms.

**Two flags rather than one, deliberately:** `CUTOVER_POOL` and `ITEM_OPS` change different
things and one may be flipped without the other — in particular the re-key can be proven on
today's watchlist, where every value has a known correct answer, **before** the pool exists
to test it against. That ordering is the whole argument for building it now.

---

## §6 · What I would build, and the detectors that ship with it

1. `DB.itemOps` + the copy migration + the read-through, behind `ITEM_OPS = false`.
2. The four fields, with `src` / `setAt` / `bands`.
3. Retention + declared cap + warn, the `DB.qual` shape.
4. Import carry, all states.
5. Controls on the plan line and its drill, each with its empty state and reason.

**Detectors, one per property:** read-through returns the row's value while the flag is off
(asserted by absence of any `itemOps` read affecting output) · the migration is idempotent
(running it twice changes nothing) · `bands` renders the override as *set under different
bands* when they differ · a stale-pruned override warns and is never silent · the carry
preserves all states · **a pinned era fact that `ITEM_OPS === false`**, so the flip forces
its own accounting.

**The discriminating pair I would want most:** migration copies rather than moves — seeded
by changing it to a move, which must leave the read-through assertion green and turn the
interrupted-migration assertion red.
