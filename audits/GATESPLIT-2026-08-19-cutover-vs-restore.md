# The gate split — every pass-5 and pass-6 money-path finding, against what the cutover flips

**You have it right, and the consequence is sharper than "almost none".**

## What the cutover actually flips

`CUTOVER_POOL` (the plan's candidate pool reads the control cell) · `ITEM_OPS` (operator state reads
the item store) · `VOL5_UNIVERSE` (the 5m die-off streak counts universe-wide) · the chart coverage
gate at 7 of 7 observed days · plus the three decisions inside the ruling: the pool switch,
seasoning's shape for pool items, and the plan surface as approved.

## Every money-path finding from both passes

| # | finding | pass | subsystem | touches what the cutover flips? |
|---|---|---|---|---|
| 1 | `hzH` dropped from positions and quote legs | 5 | **restore** | no |
| 2 | settings caps resolved null to their loose default | 5 | **restore** | no |
| 3 | the `bands` withholding-direction claim | 5 | **cutover surface** | **claim only — zero behaviour** |
| 4 | record-level `sourceTier` bare `+` | 6 | **import** | no |
| 5 | caps resolved absent to their tight end | 6 | **restore** | no |
| 6 | `slots`/`watchCap` unclassified | 6 | **restore** | no |
| 7 | partial fill creates a position with no `hzH` | 6 | **live trading** | no |
| 8 | clearing the qty box writes a manual zero | 6 | **live trading** | no |
| 9 | an import repaints two settings inputs of ~30 | 6 | **restore** | no |
| 10 | `flush()` is a no-op, so a restore may not persist | 6 | **restore** | no |
| 11 | `planPriority`/`planDemoted` survive a restore and reorder funding | 6 | **restore** | no — import-triggered |
| 12 | a second position path leaves `hzH` unstamped | 6 | **live trading** | no |

**Eight restore/import · three live-trading · one claim-level on the cutover surface · zero
behaviour defects on the cutover path.**

## Finding 3 is the only one that even touches it, and it is not a behaviour

The `bands` withholding-direction sentence lives above `opsOf`'s band states, which `ITEM_OPS` arms.
But it is a **comment**, it was corrected in both places it appeared, and the code it describes did
not change. It cannot fund anything.

## One correction to the split, because a two-way split would drop three findings on the floor

**It is a three-way split, not two.** Findings 7, 8 and 12 are neither cutover nor restore — they are
**live trading-path defects that bite today with no import involved**. Clearing the quantity box
benches an item with a false reason right now; a partial fill creates a leg that ages against the
wrong horizon right now. A remediation plan with a cutover track and a restore track has no home for
them, and they are the ones that touch real money on an ordinary day.

**Also worth knowing before you rely on it:** the cutover surface is not adjacent to any of this.
`opsSet` — the only writer the cutover arms — is called with `tierOv`, `tBuy`/`tSell`/`tAt` and
`t2Grad`, and **never with `qty`**. A pool item has no manual size at all, which `planQty`'s own
comment states is the correct reading rather than a gap. So finding 8's defect has no counterpart
waiting on the other side of the flag.

## The consequence, and it cuts both ways

**Passes 5 and 6 had the cutover surface nowhere in their scope.** Pass 5 read my `num()` sweep;
pass 6 read my repairs to it. Both were confined to `validateImport` and its consumers. So the zero
in the table above is **evidence that nobody looked**, not evidence that the surface is clean — and
by the same token, neither pass counts as a strike against the cutover.

**The cutover has exactly one clean pass over its own surface: pass 4**, whose scope was the
cutover-critical assertion set (16 exact + 56 candidates) and which returned zero money-path
findings that bite today. **It needs a second pass scoped the same way** — the pool switch, the plan
surface, the operator store, the gates and the scorer — and that pass has not been run.

So the position is: the cutover gate is one clean cutover-scoped pass away, not five findings away.
The restore path gets its own track, and the live trading-path defects get a third.
