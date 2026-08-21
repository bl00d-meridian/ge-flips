# STAGERECORD-2026-08-21E — durable copy of the pass-E staged-pass record

Byte-level diff preserved at audits/DIFF-2026-08-21E-passE.patch (the M182 practice).
Final staged reports: 1200 and 390 both 'PROBE-PASS [STAGED: staging/index.html]'.
Landing verified by the new post-copy hash check (M184's fix, first real firing).

═══════════ staging/PASS.md ═══════════

# Staged repair pass 2026-08-21·E — the spark-age disclosure (ruled: DISCLOSE) · the unified per-item badge · the circles' retirement

**Opened:** 2026-08-21 · **Tree frozen at:** see `BASELINE.sha256`

Two rulings executed: trace-3 finding 2 (DISCLOSE, DON'T TIGHTEN — display only, seeds both
directions) and the badge-unification directive (display only — no funding, sizing, ordering or
gate change). **Batching call, recorded:** the badge unification lands NOW rather than folding
into maturity-day work, because its point 4 ("not funded by current rules" visible on pins) is
information the observation week itself wants, and maturity day already carries ITEM_OPS.
**Rider, no behavior change:** the 48h `QUAL_GAP_RESET` value moves PROPOSED → RATIFIED
(user ruling 2026-08-21) in the constant's comment and the R111.1 row.

---

## Repair 1 — a spark-fed reading states its age wherever it informs a verdict (§122)

**The finding that provoked it:** (trace-3 finding 2 and its ruling — cold reviewer is NOT
shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> A reading taken from a session-scoped fetch states the fetch's age beside every verdict it
> informs — the age is a property of the fetch, so an archive-fed reading never carries the
> clause — and the age comes from the one resolution the chain itself stamped, never a
> re-resolve. Display only: no verdict moves.

**The property-scoped search:** every verdict a spark-fed series informs (the five
chart-derived bench sentences — both trend forms, volume trend, momentum, drift — and the
funded provenance note); every consumer of the chain's series resolution (`serSrc` — gains
`serAt` beside it, one owner); every other surface rendering a spark-derived figure (the
wSpark chart itself — a picture of the series, not a verdict; the hours ledger — archive/pin
stream aggregates, not per-verdict).

**Sites touched:** `candidateFor` — the `sparkAge` clause (one term, appended to the five
sentences) and the `serAt` stamp beside `serSrc`; the walk's provenance note extended to the
ruled *"charted from its own fetch, 3h ago — ahead of the archive"*; `[R120.2]` re-pinned to
the aged form.
**Sites returned but deliberately NOT touched:** the row spark chart (renders the series
itself — a picture carries its own shape, not a verdict); the hours ledger and scorer bands
(archive/aggregate streams, not spark-fed verdicts); `SPARK_TTL`'s refetch behavior (the
ruling is display-only — no tightening).

**Seeds:** SE1 (the `sparkAge` term emptied) → `[R122.1]` bench-age limb red; SE2 (the
provenance note reverted to the un-aged form) → `[R120.2]` and the `[R122.1]` note limb red.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"A reading derived from a session-scoped fetch (a
  spark) states the age of that fetch beside itself wherever it informs a verdict the operator
  reads; the age comes from the one resolution stamped in `candidateFor`, never a re-resolve;
  an archive-fed reading carries no fetch clause because it has no fetch."*
- Verdict (round 1): SENT BACK — two in-property omissions: the **chart-still-loading bench's
  spark branch** (its point counts are the frozen spark's own, "still loading" promises an
  improvement a frozen spark never delivers — *"the strongest case of the property, sitting
  eleven lines above the comment that states the rule"*), and the **trend/volTrend SHORT gap
  strings** (the status-badge tooltip and scanner tag render short over detail, so the same
  frozen reading rendered ageless there — the caveat-placement rule). Plus a flagged judgment
  site: the FALLING risk chip ties the same reading to the bench threshold with no age and no
  recorded exclusion.

**AMENDMENT (repairer, same session):** the loading branch and both short strings carry the
clause; the FALLING chip reads the CHAIN'S OWN STAMP (`au.serAt`) when the candidate is in the
build — never a re-resolve — and is honestly absent otherwise, with the reason at the site
(this also removed the chip's pre-existing re-resolve pattern one step further than the ground
asked). New `[R122.1]` limbs for the loading branch and the short string; the R122.1 row
re-claims the full surface list. **Amendment seeds SE7 (loading-branch clause deleted) and SE8
(the falling-trend short's clause deleted) → each new limb red alone, hash-restored after.**

**COLD REVIEW (final)** — recorded by the reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 1, upheld)
  *"A reading derived from a session-scoped fetch (a spark) states the age of that fetch
  beside itself wherever it informs a verdict the operator reads; the age comes from the one
  resolution stamped in `candidateFor`, never a re-resolve; an archive-fed reading carries no
  fetch clause because it has no fetch."*
- Confirmation: *"All three grounds closed … the FALLING chip appends the clause only from the
  chain's own stamp … honestly absent when the item is outside the build. The two new
  [R122.1] limbs discriminate."* Residual note 1 (a relative age frozen into the durable
  `gapTxt`) closed post-verdict on the reviewer's own list: `gapTxtOf` strips the clause at
  all three store sites, reason at the term, row updated.
- Verdict: PASS     <!-- final, round 2 -->

---

## Repair 2 — one badge term feeds both plan groups (§123, badge unification points 1, 2, 4)

**The finding that provoked it:** (the badge-unification directive — cold reviewer is NOT
shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> One question — "does the instrument's own record fund this item, and how often" — has one
> renderer, read by every row that answers it, with population-specific WORDING derived inside
> the renderer (never passed, so a caller cannot mislabel); a no-history state renders as
> information in its own words, never as an empty slot; and realized figures sit beside
> simulated ones only in their own labelled column, never pooled.

**The property-scoped search:** every render site of a per-item verdict dot (the watch row's
tags, the scanner row's tags for watched items, the funded pool line); every reader of
`poolPersistence` (the badge, the drill, the departed loop); the realized/simulated boundary
in the drill's columns; the pin population's reach into `poolSeenAccrue` (it walks ALL of
`ctlPass`, so pins the cell funds already accrue rows — no accrual change needed).

**Sites touched:** the watch row and scanner row render `poolDot` (gated on
`PAPER_DOT_RETIRED`); `poolDot`'s not-scored branch gains the pin wording (**NOT FUNDED BY
CURRENT RULES** — visible, worth reading against why the pin exists; pinned-ness derived
inside); `poolDrill` gains the realized column ("Realized trips (YOUR log — never pooled with
the simulated columns)", dash for none); the dot legend rewritten to the persistence family.
**Sites returned but deliberately NOT touched:** slot B (pump exposure) is the caution chip
already on the line — R92.2's own ruling, one mark not two; `poolSeenAccrue` (already
population-complete); the funded pool line's `poolDot` (unchanged — the pin rows joined it).
Interpretation recorded in the R123.2 row: "per-capture fill outcomes" read as the drill's
existing six-gate/session columns; the scorer's per-capture econ buckets are a different
surface's grain.

**Seeds:** SE3 (the watch-row swap reverted to the circles) → `[R123.1]` red, propagation to
the `[R25.6]`/`[R25.7]` dormant form (rows would carry "Paper screen:"); SE4 (the pin
not-scored wording branch removed) → `[R123.1]` not-funded limb red; SE5 (the realized column
removed) → `[R123.2]` red.

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"One renderer (`poolDot`) owns the per-item
  persistence answer for every row population; population wording is derived inside the
  renderer, never passed by a caller; every no-history state renders as information in its own
  words; a pin's realized history renders beside, and never pools with, the simulated/gate
  columns."*
- Verdict (round 1): SENT BACK — the `plan-persist` GLOSSARY entry still described only the
  pool population while the badge's own popover now opens it from a pin's glyph, and the new
  status string appeared nowhere in it (the same-commit glossary rule). Plus the introduced
  defect below: **the pin tooltip claimed more than the code computes** — "has never funded
  this pin" from a fact (a missing ledger row) that a retention-window or store-cap eviction
  can also produce.

**AMENDMENT (repairer, same session):** the tooltip claims exactly the fact — *"no funded
cycle on record"*, with the eviction/retention qualifier in place and "never funded" gone
(asserted absent); the `plan-persist` entry renamed "Persistence (pins and pool)" and carries
the pin state, with a same-commit glossary limb added to `[R123.1]`; the settled fixture
genuinely exercises the green branch (cycles 20 ≥ the observation floor — the round-1 fixture
read ACCRUING while its comment claimed settled). **Amendment seed SE9 (the tooltip reverted
to the never-funded overclaim) → the `[R123.1]` exact-claim limb red alone, hash-restored
after.**

**COLD REVIEW (final)** — recorded by the reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 1, upheld)
  *"One renderer (`poolDot`) owns the per-item persistence answer for every row population;
  population wording is derived inside the renderer, never passed by a caller; every
  no-history state renders as information in its own words; a pin's realized history renders
  beside, and never pools with, the simulated/gate columns."*
- Confirmation: the glossary entry verified against the real GLOSSARY shape; the tooltip
  *"now claims exactly the computed fact"* with "never funded" surviving only in the comment
  explaining why it would overclaim, presence and absence asserted. Carried forward, recorded:
  the NON-pin NOT APPLICABLE wording renders `poolPersistence`'s own why — "has never funded
  this item" — which carries the same eviction gap the pin copy fixed; pre-existing, not a
  ground, queued for the next touch of that term.
- Verdict: PASS     <!-- final, round 2 -->

---

## Repair 3 — the paper circles retire to the dormancy lane (§123, point 3)

**The finding that provoked it:** (the directive's removal-sweep point — cold reviewer is NOT
shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> A retired feature leaves by the dormancy lane: one flag production reads gates its render
> sites AND its assertions (a retired feature whose tests vanish is how it returns broken);
> every surface that names it is swept or rewritten in the same change; and what it showed is
> stated to remain reachable where it actually lives, so nothing reads as lost.

**The property-scoped search:** every render site of `shadowDot` (watch row, scanner row);
every surface naming the circles (the dot legend, the `ind-paperdot` glossary entry); every
assertion whose subject is the circles (`[R25.2]`'s dot limb, `[R25.6]`'s four dot limbs,
`[R25.7]`'s shape/tooltip/slot/legend limbs); the family-generic properties that survive the
family change (colour-within-identity, self-naming tooltips, fixed slots, the legend, the
primary-dot-leads-the-slot rule).

**Sites touched:** `PAPER_DOT_RETIRED = true` with the un-retire conditions stated at the
flag; both render sites gated; the legend rewritten (circle lines out, persistence family in,
the Paper-Book pointer stated); `ind-paperdot` marked DORMANT, kept readable, naming where the
history lives; the shadow-specific assertions gated behind the same flag with a dormant form
carrying both tags (rows circle-free, renderer still callable); the family-generic `[R25.7]`
limbs REWRITTEN LIVE against the persistence badge — with one deliberate delta stated in the
row: the persistence badge never leaves its slot empty, because its no-history states are
information (point 4).
**Sites returned but deliberately NOT touched:** `shadowCite` (the paper counterfactual in
BENCH sentences — a different feature, not the dot; stays live); `shadowSlice`/the paper
book's own surfaces (the stated home of what the circles showed); the `.sdot` CSS classes
(now the persistence family's — shared identity is the point).

**Seeds:** SE6 is the ERA DRIVE, not a defect seed: `PAPER_DOT_RETIRED` flipped to false —
RESULT, read from the run: exactly the two era-pinned `[R123.1]` limbs red; the GATED originals
(all four `[R25.6]` and the `[R25.7]` shape/tooltip/slots limbs) RAN AND PASSED under the
flipped flag — both eras drivable, the R18.4 standard. The live legend limb stayed green under
flag-off, which is exactly the un-retire condition stated at the flag (flipping back requires
restoring the legend's circle lines — the flag alone does not).

**FIRST COLD REVIEW (2026-08-21, fresh agent, diff + subsystem map only):**
- Property (reviewer's naming, verbatim): *"One flag (`PAPER_DOT_RETIRED`), the same one
  production reads, gates every render site of the retired circles and every assertion about
  them; every surface naming them is swept or dormant-marked; what the circles showed is
  stated to remain reachable on a real surface."*
- Verdict (round 1): SENT BACK (narrow) — two assertions the gating enumeration missed (its
  own comment listed "[R25.2]'s dot limb, [R25.6], [R25.7]" — the enumeration was the
  spelling, and the property-scoped search returned two more): `[R27.1]`'s row-dot limb
  (ungated, its label claiming a row property no row renders) and `[R39.7]`'s
  glossed-where-they-render limb (still asserting the retired glyph's gloss through
  `shadowDot`). Verified sound: both render sites are the only `shadowDot` callers; the legend
  state-for-state matches `poolDot`; the reachability claim is real (`shadowCite` correctly
  untouched — the citations are not the dot).

**AMENDMENT (repairer, same session):** `[R27.1]`'s dot limb gated behind the flag;
`[R39.7]`'s dot limb re-pointed to the LIVE badge's gloss (`plan-persist` through `poolDot`);
the reviewer's introduced-defect list closed in the same round — the "both eras drivable"
comment reworded to what the mechanism actually is (a const-gated dormancy driven by the
flag-flip seed at pass time), the stranded paper-dot doc comment dormant-marked, the test-dot
comment reworded to the primary dot, and the legend's circles-within-circles claim scoped to
the read states (the `·` no-history state is not a circle-in-circle).

**COLD REVIEW (final)** — recorded by the reviewer after verifying the amendments:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim, round 1, upheld)
  *"One flag (`PAPER_DOT_RETIRED`), the same one production reads, gates every render site of
  the retired circles and every assertion about them; every surface naming them is swept or
  dormant-marked; what the circles showed is stated to remain reachable on a real surface."*
- Confirmation: `[R27.1]` gated with the dormancy comment; `[R39.7]` re-pointed to the live
  badge's gloss, *"which its label's 'glossed where they render' now truthfully names"*; the
  settled branch genuinely exercised; the comment/legend corrections verified. Residual notes
  2–4 closed post-verdict on the reviewer's own list (9845 in the cleanup loop; the
  green→settled comment word; the R122.1 row's chip clause marked inspection).
- Verdict: PASS     <!-- final, round 2 -->

---

**Walk-up element accounting (the directive's before/after):** the badge swap replaces one dot
per row with one dot per row — element count unchanged on every surface; the drill gains one
column. The ≤7 walk-up decision bound is untouched (no new decisions; the probe's bound
assertion stays green).
