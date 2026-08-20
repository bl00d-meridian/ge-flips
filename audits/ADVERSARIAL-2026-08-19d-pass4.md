# Pass 4 — zero money-path findings that bite today

**2026-08-19. Two independent readers, frozen tree, both hashes verified unchanged at close.**

## The number you asked for

| pass | money-path findings | where they were |
|---|---|---|
| 2 | **7** | inside pass 1's fixes |
| 3 | **1** | inside pass 2's fixes |
| **4** | **0 that bite today** | — |

Two findings are money-path *in shape* — a restraint that lifts on a value the operator deleted, and
an import that resurrects a cleared override as a funding-blocking one. **Neither can change what is
funded today**, because both need the item store armed, and one of them additionally needs a writer
that does not exist. They are reported first anyway, because both are the drift-shape the earlier
passes each found, and both arm at the same ruling.

**One finding was LIVE and is fixed:** a counter on the plan surface that could no longer fire.

## Did either reader lean on a suite result?

**No.** Every finding in both reports is traced from quoted source to its consumer. Neither cites a
run, green or red, as evidence for or against anything. This matters because the cold-profile defect
found earlier the same day means **every green before that fix was a warm green** — but nothing here
rests on one, so nothing needed re-checking. The main reader also ran the accumulated-state check
explicitly and reports no assertion in its scope resting on unseeded browser state.

## Freeze

| file | at launch (13:36:11Z) | at close |
|---|---|---|
| `index.html` | `93c58194593c73ce` | `93c58194593c73ce` |
| `tools/probe/probe-snippet.html` | `9d39469e3e805fc8` | `9d39469e3e805fc8` |

Two readers, deliberately non-overlapping. One read the recent changes; the other was told **not** to
read the diff at all, and to read the code that did **not** change but now receives different values.
Between them: **106 and 61 call sites read in full**, ~55 min each.

---

## LIVE, and fixed — the plan stopped explaining itself

`#planSub` renders *"N charts still loading — verdicts will improve"*. It counted bench rows by
matching the phrase `still loading` against the bench **sentence**. The readiness repair rewrote that
sentence to name the point counts and the thresholds, and **the phrase left the file entirely** — so
the count was permanently zero and the note never rendered.

It bites on every cold boot, which is exactly when it matters: before price history arrives, every
otherwise-clean item benches as unreadable, and `#planSub` read *"0 pass the gates, of 43 scored"*
with the explanation deleted. The bench rows still carried their reasons, so this was degraded rather
than silent.

**The shape is the one worth carrying:** a counter keyed on rendered copy breaks the next time the
copy is improved. It now keys on the gate's identity. The sibling consumer — the function that maps a
bench sentence back to a gate name — *was* kept aligned, so one of two readers was swept and the
other was not.

**And the assertion I wrote for it did not bite.** The first form computed the count in the probe and
passed it into the copy builder, so reverting production's counter changed nothing it could see. That
is re-implementing the thing under test, committed while writing an assertion about a counter. It now
renders the plan and reads the number off the surface.

---

## Money-path in shape, latent, both fixed

**A cleared test date could release a bench.** `provenLoser` read
`opsOf(id).tAt || (w && w.tAt) || 0`. But `opsOf` already falls back to the watch row, through
`opsPick` — the function rewritten this session so that a **cleared** override returns null instead
of resurrecting the row's value. The second `||` read that null as falsy and went to the row anyway,
reinstating the exact path one level up, in the one reader of nine that added its own fallback. And
it lifts a restraint: a resurrected test date unbenches a proven loser. The limb was redundant for
every production caller, so deleting it is behaviour-identical today.

**An import turned a cleared override into a funding block.** The item-store import used `num()`,
which is `Number.isFinite(+v) ? +v : null` — and `+null` is 0, which is finite. So a cleared override
(a present key holding null) restored as the **value zero**. Zero on that field means untiered:
`itemTier` reports a live manual override and the allocator benches the item, with copy claiming a
decision the operator had deliberately removed.

**The guard for this exact hazard is written out a few lines below**, for a different field, in as
many words — *"NOT `num()`, which maps null → 0"*. It was not applied to the store that grew a
null-bearing state in the same session.

The same branch also had **no range check**, while the watch-row branch has always had one. A
hand-edited `tierOv: 7` survived import, reached a budget pool that does not exist, and produced a
funded line with a **NaN quantity** — which the `qty <= 0` guard cannot catch, because NaN fails
every comparison.

---

## The structural repair worth naming

The two history gates are a partition, and the scout's eviction guard is supposed to answer the same
question — *was this item judged?* — for the same item. It answered with its own arithmetic, and the
two drifted: the guard called an item judged at **3** finite points while the chain benched it
unreadable until **24**. An item in that window was therefore evictable *and* benched on a verdict
the chain could not reach, so it never refreshed its pass timestamp and was removed after 48 hours
for *"no full-gate pass"* — a verdict with no trial behind it, which is what the unknowable-gate rule
exists to forbid.

**`historyVerdict` now owns all three answers**, and `judged` is the exact complement of the two
benches. The guard and the gates cannot disagree by construction rather than by maintenance. This is
the third time in four passes that a paired condition drifted; the answer each time has been to make
it one term.

---

## Also fixed

- **Two deployment-class constants were unpinned.** The chart day count was bounded only loosely, so
  a silent change from 7 to 5 would have lifted the chart mask two days early and stayed green — and
  that mask is the fourth cutover prerequisite. Pinned by value, with the coverage window and all
  four readability thresholds.
- **The four readability thresholds live twice** — in the mask's constant and inside each consumer.
  If a consumer's own minimum rises, the mask over-reports and that restraint reads unknown with
  nothing benching it, which is the defect the mask was built to close arriving from the other side.
  Now checked at each boundary and one below it. Neither the drift term nor the constant had any
  assertion anywhere in the suite before this.
- The hour weight's reported source now comes from the resolver rather than being hardcoded.

## Recorded, not fixed

- **Two denominators in one sentence** in the pool copy (*"3 of 10 pool items … momentum on 3 of 8"*)
  — both true, and the pair invites reading them as one population. Renders nothing today.
- **A fallback branch in the held-block header cannot be reached**, because membership in that block
  guarantees one of the two named weights is unfed.
- **The printed plan order diverges from the screen order** in the copy and checklist views, which
  render in allocator order rather than group order. Funding and sizing identical; only the printed
  order differs. Pre-existing in kind, widened by the third group.
- **One test block still captures two caches and tears them down with a blind delete** — the pattern
  swept in four other blocks this session, missed in this one.
- **One teardown conjunct compares an array with itself** after the restore assigns the same object,
  so it witnesses that the restore line exists rather than that it worked.
- **A sizing call site was reassociated** when it was folded into the shared horizon term; float
  multiplication is not associative, so it can differ from the original by one unit. The operand
  order was ruled normative, so this is recorded rather than proposed.

---

## Suite

`PROBE-PASS — 1,242 assertions, COLD PROFILE, both viewports, pairing clean both directions
(469 tags / 481 rows / 469 cited)`. **Cold and warm runs compared: identical, assertion for
assertion.** Seeds S123–S128, one at a time, restore-green between; S123 exposed the re-implemented
assertion above and was re-run against the repaired form.
