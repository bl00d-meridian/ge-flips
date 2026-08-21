# STAGERECORD-2026-08-21C — durable copy of the batch-2 staged-pass record

Byte-level diff preserved at audits/DIFF-2026-08-21C-batch2.patch (the M182 lesson: the
pre-batch tree exists nowhere once landed, so the pass diff is the only byte-level record).
Report headers: 1200 and 390 both 'PROBE-PASS [STAGED: staging/index.html]', pairing 533/545/533.

═══════════ staging/PASS.md ═══════════

# Staged repair pass 2026-08-21·C — ruled-queue batch 2 of 3 (F5 · one comparator + family seat · the pool header)

**Opened:** 2026-08-21 (restart session) · **Tree frozen at:** see `BASELINE.sha256`

All three repairs execute standing rulings from the restart directive's queue (items 2e, 2f, 2g).
Repair 2 also lands the substance of the **A1 funding-order ruling (Aug 19 2026, deployment-class,
REPAIR-LEDGER row 7)** — ruled and cold-review-passed then, never landed because repair 8 blocked
that batch's landing; the ruled fix queue's family-winner item presupposes it ("planCmp — the one
comparator that already owns display and funding"), and `planCmp` was in no shipped tree until now.
Built fresh against the current tree with the Aug 19 staged form as reference, not lifted from
`staging-held/`.

---

## Repair 1 — one owner for "free gp" (F5, queue item 2e)

**The finding that provoked it:** (surface audit F5 — cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> Each capital figure has exactly one owning term, every render and every sizing path reads the
> owner, and the shadow reserve is never spendable in any figure anywhere — a second spelling of
> the same figure is where two numbers on one tab come to differ by exactly the reserve.

**The property-scoped search:** every arithmetic combining `stack()`/`committed()`/
`DB.shadowReserve`; every render of a "free" or "working" figure. Returned: `available()`
(stack − committed — counts the reserve as free; ONE caller, `#posSub`); the `#watchStack` inline
`max(0, st − committed())`; the funding walk's inline `avail`; TWO inline respellings of the
working figure (`have − shadowReserve` on the capital tile and in `#shStats`' "Working capital"
row, both with `have = stack()` — byte-equivalent to `workingStack()`); `workingCapital()`
(sleeve/paper capacity, bank − shadowReserve − reserve); the plan foot's committed render.

**Sites touched:** `available()` DELETED with the reason at its old site; `freeGp()` added beside
`workingStack` as the one owner; `#posSub` renders free of WORKING with the exclusion stated;
`#watchStack`'s free reads `freeGp()`; the walk's `avail = freeGp()` (the return's `st` field now
`workingStack()` — no reader found, kept for shape); both working-figure respellings folded to
`workingStack()`.
**Sites returned but deliberately NOT touched:** `workingCapital()` — a different question
(post-incidentals sleeve capacity), reserve correctly excluded; its `DB.bank`-vs-`stack()` base is
a pre-existing hazard outside this property, recorded for the drift register, not fixed here. The
plan foot's `committed()` render — renders committed, not free.

**Seeds:** SC1 (posSub reverted to the stack base) → `[R116.1]` first limb red alone; SC2 (walk
base reverted to stack − committed) → `[R116.1]` second limb red alone.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"Each capital quantity — working, free — has exactly
  one owning term; every surface that renders it and the funding walk's deployable base read that
  term, and the shadow reserve is excluded once, at the owner, never re-subtracted per site. A
  second spelling of the same quantity is where two figures on one screen come to differ."*
- Sites returned beyond the repair's: **`workingCapital()`** and the paper book's
  capital-feasibility render — a second spelling of the working figure under the exact label the
  owner carries, with a `DB.bank` base that ignores realized flips since the stamp and an inline
  reserve re-subtraction. The repair's sweep caught the `stack()`-spelled instances and missed
  the `DB.bank`-spelled one — scoped to the finding's spelling, not the property.
- Verdict (first review): SENT BACK — `workingCapital()` is the same property, unfixed.

**AMENDMENT (repairer, same session, before the second review):** `workingCapital()` now reads
the owners — `Math.max(0, workingStack() − (DB.reserve || 0))`, the base the funding walk deploys
against — with the fold reason at the site; the feasibility label claims what it computes
(*"against deployable working capital … (working stack minus the incidentals reserve)"*), and the
block comment names the owners. New `[R116.2]` (discriminating: a flip logged after the bank
stamp makes the two bases different numbers, and the difference must equal the realized profit).
**Seed SC11 (workingCapital reverted to the `DB.bank` form) → `[R116.2]` red alone, staged tree
hash-restored after.**

**SECOND COLD REVIEW (2026-08-21, second fresh agent, amended diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"Free and working capital each have exactly one owning
  term — `workingStack()` = stack minus the shadow reserve, `freeGp()` = working stack minus
  committed — and every figure that renders or spends free/working capital reads the owner, so
  the shadow reserve is subtracted once, at the owner, and is never spendable in any figure
  anywhere."*
- Their search confirmed: no orphaned `available()` caller; no surviving inline respelling; every
  capital reader routes through the owners; the four `Math.min(shadowReserve, stack())` display
  clamps are a different question (displaying the excluded amount), recorded as an observation.
- Verdict (round 2): SENT BACK — the `met-capfeas` GLOSSARY entry still described the OLD
  `workingCapital` ("bank less reserve and Shadow Fund"), so the panel and its own popover gave
  two definitions of one number. Also noted: `[R116.2]`'s row claimed the rendered label, which
  no probe checks; `[R116.1]` pins values, not spellings (a stated limit).

**AMENDMENT 2 (repairer, same session):** the `met-capfeas` entry now describes exactly what
`workingCapital()` computes (working stack — stamp plus realized flips and game gp since, minus
the Shadow reserve — minus the incidentals reserve); the R116.2 row narrows its label claim to
inspection; the R116.1 row states the values-not-spellings limit.

**COLD REVIEW (final)** — recorded by the second reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 2) *"Free and
  working capital each have exactly one owning term — `workingStack()` = stack minus the shadow
  reserve, `freeGp()` = working stack minus committed — and every figure that renders or spends
  free/working capital reads the owner, so the shadow reserve is subtracted once, at the owner,
  and is never spendable in any figure anywhere."*
- Confirmation: *"Glossary entry corrected to the owner's arithmetic; R116.2 narrowed to
  inspection and refiled under §116; values-not-spellings limit recorded."* Standing note carried:
  "the same base the funding walk deploys against" is loose (the walk further subtracts
  committed) — saved by the exact formula beside it.
- Verdict: PASS     <!-- final, round 2b -->

---

## Repair 2 — one comparator owns the funding order, the display, the print, and the family seat (queue item 2f + A1 + F3)

**The finding that provoked it:** (the family-winner ruling; F3 — cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> The question "which candidate comes first" has one owning term, total over the whole candidate
> set, and every site that orders, prints, counts positions in, or breaks a tie over candidates
> reads it — and the value key never compares across populations, because a weighted score from
> operator history and an unweighted core from none are different evidence answering one sort.

**The property-scoped search:** every `.sort(` over plan candidates, every comparator or ordering
expression, every render or artefact that shows candidate order, every pairwise winner selection.
Returned: the pre-family raw-score sort; the walk's local rank/tier/score sort; `planGroups`' three
per-group sorts; `applyFamilyRule`'s raw-score winner; the copy button's print (walk-order,
label-less — the recorded F3 instance); the review checklist's inline plan print; NEXT UP's
ungrouped render and the picker's unconditional "plan is full" blame; `renderFamilyDebug` (F2).

**Sites touched:** the ordering block (`planRank` · `planPopGroup` · `planTierGroup` ·
`planSortKey` · `planCmp` — total, with the population key INSIDE the comparator, the one
deliberate change from the Aug 19 form, which settled cross-group order by concatenation and so
had no pairwise total order for a family seat to read — · `planGroups` with the promoted group ·
`planOrder` as one flat sort, identity with the concatenation asserted); the pre-family sort
deleted; the walk reads `planOrder`; `applyFamilyRule` selects by `planCmp` (bench copy unchanged);
the funded render's promoted block; NEXT UP grouped by `planGroups` with the queue-position blame
(`qAhead`/`pinsAhead`) in the full branch; `planCopyText` extracted as the button's only ordering
source, deriving from `planGroups` with group labels; three stale comments updated in the same
edit (the "display-only" split claims and "highest score wins").
**Sites returned but deliberately NOT touched, each with the reason (also recorded in source where
it lives):** `applyFamilyRule` still runs BEFORE the mm/untiered filters — moving it would let a
family fund its second member where today it funds neither, a WIDENING that is its own
deployment-class ruling (stated in the function's comment). The review checklist's inline plan
print — its sequence is the walk's picks order, which now IS `planOrder` by construction; group
labels there are display polish for the display batch. `renderFamilyDebug` (F2) — assigned to
batch 3 by the ruled queue; reads `DB.watch` while the rule runs over the whole pass set.

**Seeds:** SC3 (walk reverted to the old sort) → `[R117.1]` red, propagation to `[R117.6]` (the
picker's row funds under the old order, so no picker renders); SC4 (winner by raw score) →
`[R117.2]` red alone; SC5 (population key dropped from `planCmp`) → `[R117.3]` red, propagation
to `[R117.1]`/`[R117.2]`; SC6 (promotion key demoted below population) → `[R117.4]` red alone;
SC7 (`planCopyText` reverted to the flat label-less map) → `[R117.5]` red alone; SC8 (full-branch
blame reverted to the unconditional sentence) → `[R117.6]` red alone.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"One comparator owns the question 'who funds first':
  the funding walk, every rendered ordering, every printed plan, and every pairwise seat decision
  read `planCmp`; no site keeps its own rank arithmetic, and heterogeneous scores are never
  compared across populations because the population key settles first."*
- The mechanism, renders and assertions were found sound; the review confirmed all six new
  assertions discriminate and that the walk/concatenation identity holds under sort stability.
- Verdict (first review): SENT BACK — on claims, not code: (1) a THIRD copy of the "render
  grouping only" claim above `pickGroups` that the diff's own stale-claim sweep missed; (2) the
  edited R92.3 row's clause "the within-group sorts this row describes are unchanged" is false —
  `planCmp` puts the tier key ahead of the value key WITHIN groups. Owed besides: the checklist
  inline print needs its deliberate-directness recorded at the site.

**AMENDMENT (repairer, same session, before the second review):** the `pickGroups` comment
rewritten to the landed truth (the grouping is the funding order; sizing untouched); R92.3's
clause corrected — within-group order is now tier-then-value by the ruled money order, and the
VALUE keys are what is unchanged; the checklist inline print carries the recorded reason at the
site (sequence = the walk's own order; if it ever grows labels or reordering it reads
`planGroups`/`planCopyText`). The reviewer's related note on the `[R92.3]` probe label ("tenured
sorts by score", passing on a tier-less fixture) is corrected in the same edit.

**SECOND COLD REVIEW (2026-08-21, second fresh agent, amended diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"Every ordering or pairwise preference over plan
  candidates — the funding walk, the on-screen groups, NEXT UP, the printed plan, the
  queue-position claims a picker cites, and the family-seat decision — is decided by the single
  total comparator `planCmp` (promotion, then population, then tier, then the value key the
  item's evidence supports); no second sort and no raw-score comparison over plan candidates
  exists anywhere."*
- Their search classified all ~100 sorts in the file (plan-candidate sites all on the owner;
  scanner/paper/sleeve/user-column sorts are other populations); confirmed no stale
  render-grouping claims survive; confirmed the assertions discriminate.
- Verdict (round 2): SENT BACK on two RENDERED-COPY sites inside the repair's own edits: the
  promoted header's *"clear them in the plan controls"* named a control that does not exist (the
  real lifts are the press-time undo toast and the daily reset), and the queue blame's *"a
  demotion frees a slot for the first of them, not for this"* promised a consequence the walk
  does not guarantee — a freed slot funds the first row ahead WHOSE OWN OTHER BINDS CLEAR, so
  the sentence was false exactly where every row ahead carries an unclearable bind, in the
  direction of denying a true remedy.

**AMENDMENT 2 (repairer, same session):** the promoted header claims the real lifts
(*"promotions reset with tomorrow's plan (undo is offered at press time)"* — the reachable-remedy
property, reason at the site); the consequence clause claims the walk's actual rule (*"a freed
slot goes to the first of them whose other binds clear before it can reach this one"*), with the
mechanism comment at the site; `[R117.6]` re-pinned to the new copy, forbidding both old forms.
A NaN-falls-through comment added at `planCmp` (reviewer's future-reader hazard). **Seed SC8
re-anchored and re-run against the amended copy.** Round 2b returned ONE more row — the R117.6
requirement row still stated the superseded consequence sentence the probe now forbids (the same
spec-contradicts-suite shape as the §113 rows, recreated in the amendment batch) — fixed the same
session; the reviewer verified spec, copy and suite now agree with one owner.

**COLD REVIEW (final)** — recorded by the second reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 2) *"Every
  ordering or pairwise preference over plan candidates — the funding walk, the on-screen groups,
  NEXT UP, the printed plan, the queue-position claims a picker cites, and the family-seat
  decision — is decided by the single total comparator `planCmp` (promotion, then population,
  then tier, then the value key the item's evidence supports); no second sort and no raw-score
  comparison over plan candidates exists anywhere."*
- Confirmation: *"Promoted header names the real lifts, queue blame claims the walk's rule,
  `[R117.6]` forbids both superseded forms, the NaN fall-through is documented, and the R117.6
  requirement row now agrees with the copy and the suite."*
- Verdict: PASS     <!-- final, round 2b/2c -->

---

## Repair 3 — the pool surfaces state the whole pool inventory (queue item 2g)

**The finding that provoked it:** (the ruled header form; the Clockwork trace — cold reviewer is
NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> A surface announcing a population states that population's full inventory during the era it
> exists for — a member in a state the surface's count cannot express (funded, while the count
> says waiting) is invisible from the surface that announced it, and no member is claimed to be
> in a state it is not in.

**The property-scoped search:** every render deriving a count or claim from the pool population
(`cutoverPoolRows`, `poolWaiting`, pool-src bench filters). Returned: THE POOL group's header
(waiting-only count); the scorer tile's lead (`cutoverPoolRows().length + " pool candidates
waiting on coverage"` — claims a funded sparked item is waiting, the same defect on a second
surface); `#benchSummary`'s "(+N pool, shown above)" (counts bench-pile-moved rows only — exact
as written); the NOW line's first-clear announcement (a record, not a count); `poolDrill`
(persistence states, not era claims — and its departed-item gap is M181, assigned to batch 3).

**Sites touched:** the header — *"THE POOL — N items · M funded · K waiting on chart coverage"*,
funded + waiting from the one build this render draws from, locator clause for the funded rows,
group renders whenever either count is nonzero during the waiting era; the tile lead — the same
three counts, funded from `buildPlan().picks` filtered by pool provenance.
**Sites returned but deliberately NOT touched:** `#benchSummary` (its claim is about the bench
pile and stays exact); the NOW line (announces an event, counts nothing); `poolDrill`'s departed
items (M181, batch 3 by the ruled queue).

**Seeds:** SC9 (header reverted to the waiting-only form) → `[R118.1]` red, propagation to
`[R113.3]` (re-pointed to the new form); SC10 (tile lead reverted to the waiting-only count) →
`[R118.2]` red, propagation to `[R113.4]` (re-pointed).

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"During the waiting era, every pool candidate is
  counted in exactly the state it is in, all count surfaces derive those states from one term,
  and no surface claims a member is waiting on coverage when coverage is not what is binding
  it."*
- The finding: **"waiting" had two owners with a real disagreement region** — the header counted
  the benched pool rows, the tile subtracted funded from the whole cell, and a sparked pool item
  in NEXT UP or mid-seasoning (the ordinary states of exactly the item this repair is about) was
  claimed "waiting on coverage" by the tile and missing from the header's total. Secondary: the
  header labelled market-gate-benched pool rows as waiting-on-coverage — position in the pile
  read as cause. Also: the tile's new `buildPlan()` call should degrade per the renderHome tile
  convention; and the repair used two spellings of "is a pool pick".
- Verdict (first review): SENT BACK — one owner for the per-member state, covering all states.

**AMENDMENT (repairer, same session, before the second review):** `poolInventory(P)` is the one
owner — every pool member of the build in exactly one state: FUNDED, WAITING on the chart gate
(bench rows whose first-binding gate is the chart, by `gateName`), or OTHER (the remainder by
construction, so the three always sum). The header and the tile both render its counts and no
others; the header gains the other-states clause; the tile degrades to a stated could-not-read
on a build failure; one pool predicate (`src === QUAL_SRC_POOL`) at both count sites via the
term. The fixture gained a market-benched pool member (the disagreement region), `[R118.1]` and
`[R118.2]` re-pinned to the split counts plus a partition-sums limb. **Seeds SC12 (tile waiting
reverted to subtraction) → `[R118.2]` red alone; SC13 (header waiting reverted to the bench-pile
length) → `[R118.1]` red alone; SC9/SC10 re-run against the amended form.**

**SECOND COLD REVIEW (2026-08-21, second fresh agent, amended diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"During the waiting era, every rendered count of the
  pool population reads one owner — `poolInventory(P)`, which files every pool member of one plan
  build into exactly one of funded / waiting-on-the-chart-gate / other — so no surface derives
  'waiting' by different arithmetic, and no member is claimed waiting while it is funded or
  benched for another reason."*
- Their search confirmed both surfaces render the owner's numbers and no others; `poolWaiting`
  (row selection) and `#benchSummary` are different questions, correct as-is.
- Verdict (round 2): SENT BACK — two STALE REQUIREMENT ROWS (`R113.3` and `R113.4` still quoted
  the header and tile forms the code no longer renders, while the suite asserts one of those
  forms ABSENT — spec and suite asserting opposite things about one string, invisible to the
  pairing check); and the header's other-states clause enumerated a closed list over a REMAINDER
  bucket (an ignored row or a held position lands there too).

**AMENDMENT 2 (repairer, same session):** both §113 rows updated to the inventory forms with
§118 cross-references; the other-states clause de-enumerated (*"— each states its own where it
renders"*), reason at the site. The reviewer's noted gap on `[R118.2]`'s degrade (a restraint
with no fires-when-it-should drive) closed: a poisoned build in the fixture must yield the
STATED could-not-read lead (new `[R118.2]` limb; **seed SC14** — degrade made silent → red
alone). The unrestored `DB.fillHorizonH` fixture write now saves/restores. **Seed SC9
re-anchored and re-run against the amended header.**

**COLD REVIEW (final)** — recorded by the second reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 2) *"During
  the waiting era, every rendered count of the pool population reads one owner —
  `poolInventory(P)`, which files every pool member of one plan build into exactly one of
  funded / waiting-on-the-chart-gate / other — so no surface derives 'waiting' by different
  arithmetic, and no member is claimed waiting while it is funded or benched for another
  reason."*
- Confirmation: *"§113 rows updated to the inventory forms, other-states clause de-enumerated
  with the remainder reason at the site, the tile's degrade gained its fires-when-it-should
  drive, and the fixture leak is closed."*
- Verdict: PASS     <!-- final, round 2b -->

---

## Re-pointed assertions (the flip-is-working redness, each deliberate)

- `[R113.3]` — the pool group header regex, old form → *"3 items · 0 funded · 3 waiting on chart
  coverage"* (its fixture funds nothing, so it now also pins the zero-funded form).
- `[R113.4]` — the tile lead regex → the three-count form.
- `[R113.2]`'s maturity absence check → `!/pool candidates/` (the lead's whole vocabulary, not one
  phrasing of it).
