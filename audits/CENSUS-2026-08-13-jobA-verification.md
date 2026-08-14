# Job A — verification-layer census, ordered synthesis

2026-08-13 · assembled BY HAND after the synthesis agent died twice (connection loss, then session limit).
Rows recovered from the workflow journal. **Nothing applied from this list except where noted.**

## Provenance and its limits

- **981 assertions enumerated** across 12 slices (independent count of the file: 928 `ok(` + 30 `out.push` = 958; the excess is slice-overlap double-counting).
- **134 raw findings -> 133 after dedupe** by (label, face). Only one true slice-overlap duplicate.
- **All 133 anchored by exact label text** against the current probe file. Three needed fuzzy matching and NONE was genuinely missing: two were adjacent labels the agent concatenated, one was a template literal (`\...last \ + EST_FLOW_HOURS + \ hours...\`) rendered as literal text. **0 unlocatable.**
- **Line numbers below are CURRENT**, resolved by text. The census's own line numbers are unreliable: 24 of 51 agents finished after this session's edits began landing, and reads are not timestamped.
- **No adversarial pass ran on Job A.** Every row is a single-agent claim unless marked otherwise. These are candidates, not verdicts.

## Counts, kept unpooled

| tier | n | could-pass yes | unknown | no |
|---|---:|---:|---:|---:|
| money | 6 | 4 |  |  |
| fill | 45 | 40 | 2 | 3 |
| gates | 15 | 13 | 0 | 2 |
| other | 67 | 58 | 3 | 6 |

| face | n |
|---|---:|
| face2 | 35 |
| face9 | 32 |
| face7 | 18 |
| face8 | 11 |
| STALE | 7 |
| CLAMP | 7 |
| face11 | 6 |
| face1 | 6 |
| face3 | 5 |
| face12 | 4 |
| face5 | 2 |

---

# TIER: MONEY

### `probe:111` — face7 — could-pass: **yes** — confidence: high

**Label:** the allocator's horizon term is asserted at the source, not through a cap that pins it

**Evidence.** Probe line 112: `planHorizonUnits(50000, 1e9) === Math.floor(50000 * GATE.capture * FILLH())`. Production, index.html:2768: `const planHorizonUnits = (volGate, qty) => Math.min(qty, Math.floor(volGate * GATE.capture * FILLH()));`. The probe's right-hand side is a CHARACTER-FOR-CHARACTER copy of the production body's second Math.min argument. The tell the seventh face names â€” a probe line that COMPUTES rather than CALLS â€” is present in the one assertion written to repair the clamp-absorption defect recorded as MISTAKES.md M119. The equality can fail only if index.html:2768 is edited and the probe is not; it cannot fail for any defect the copied expression shares. Concretely, the M118 defect recurs here: seed `FILLH()` -> `DB.fillHorizonH` at index.html:2768 and nothing changes, because line 65 of the probe sets `DB.touchWindows = []`, so `scheduleOn()` is false (index.html:2858), `gapHoursAt` returns `Math.max(1, DB.fillHorizonH || 4)` (index.html:2895) and `FILLH()` === `DB.fillHorizonH` === 4. Production computes 30000, the probe's expectation computes 30000, green. That is exactly M118 ('paper sizing reverting from the fixed horizon to the schedule changed no output at all') reappearing at the assertion built to prevent it. Secondary, and the reason I did not file it separately: `qty = 1e9` is not a shape any production call site produces â€” index.html:4170 passes `planCap`, which on this fixture is bounded by `c.limit * limitWindows()` = 25000 and by the one-third clamp, i.e. always BELOW the 30000 horizon term, so production's real call at this fixture is always pinned by the qty argument. The extraction stopped one layer short: the extracted 'term' still contains the `Math.min`, so the term is reachable only by neutralising the clamp with an argument production never passes.

**Could it pass with the property absent?** Seeding the horizon input (FILLH() -> DB.fillHorizonH) at index.html:2768 leaves the assertion green, because the probe's own expectation reads the same two interchangeable values and the empty-schedule fixture makes them equal. Seeding GATE.capture likewise moves both sides together. The only defect class this conjunct can catch is an edit to the production line that the probe author does not mirror â€” a change detector, not a property test.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Split index.html:2768 so the clamp is not inside the extracted term: `const horizonUnits = volGate => Math.floor(volGate * GATE.capture * FILLH());` with `Math.min(qty, horizonUnits(volGate))` at the call site (index.html:4170). Then assert the term by SCALING rather than by copied equality â€” `horizonUnits(2*v) === 2*horizonUnits(v)` within floor tolerance, and `horizonUnits(v)` doubling when the horizon doubles â€” and assert the horizon dependence under a REAL schedule (a block with `DB.touchWindows` set to two or more windows) so `FILLH()` and `DB.fillHorizonH` are distinguishable values rather than the same 4. Keep a separate thin wiring assertion that the call site clamps: `planHorizonUnits(v, 12) === 12`.

### `probe:1854` — face2 — could-pass: **yes** — confidence: high

**Label:** [R7.3] recent wins never graduate a pump flag â€” the wins are the bait
**Requirement:** R7.3

**Evidence.** Assertion: `!!pPump && itemWins(9051) >= 3 && !pPump.cautionProven`. Production computes the property at index.html:4181 â€” `cautionProven: !pump && !!cat && wins >= 3` â€” where `cat = cautionCat(c.name)` (index.html:4156) and `cautionCat` matches only the four CAUTION_CATS name patterns at index.html:3317-3327 (`/\bseeds?$/i`, `/impling jar$/i`, `/^ensouled .+ head$/i`, `/^bird nest\b/i` or `/^crushed nest$/i`). The probe item under test is 9051 = "Probe sleeve second" (probe-snippet.html:1014, re-used at 1663/1671), which matches none of them, so `cat === null` and `!!cat` is false. The conjunction is already pinned false by the OTHER term; `!pump` is not what makes the assertion pass. The three seeded wins at 1671-1672 satisfy `itemWins(9051) >= 3`, so the label's premise is present, but the term the label names is inert.

**Could it pass with the property absent?** Delete `!pump &&` from index.html:4181 and the expression becomes `!!cat && wins >= 3` = `false && ...` = false for item 9051, so `!pPump.cautionProven` still holds and the assertion stays green. The pump-graduation guard â€” the one thing the BINDING rule 'a manipulation defense never relaxes on the manipulator's chosen evidence' turns on â€” is unprotected by this assertion. Determined by reading index.html:3317-3327, 4156, 4181 and the fixture's item name at probe-snippet.html:1014; no run required.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Two halves, both needed. (a) Fixture: the item under test must carry a caution category so `!!cat` is true and `!pump` becomes the deciding term â€” either point this block at an item whose name matches a CAUTION_CATS pattern (e.g. a "Probe ranarr seed") or add such an item with the same pump flag and 3+ wins. (b) Extraction, per the clamp/re-implementation remedy: pull the expression at index.html:4181 into a named `cautionProvenFor(pump, cat, wins)` and point the assertion at that, so the pump term is assertable without depending on which other conjunct happens to dominate. Then seed by deleting `!pump &&` and confirm it goes red â€” the current form will not.

### `probe:116` — CLAMP — could-pass: **yes** — confidence: medium

**Label:** uncapped item funded full

**Evidence.** Probe line 116 asserts `gamma.allocQty === 5000`. The probe's own comment at lines 105-110 states that 5000 IS the per-item cap and that the horizon term computes 30000 for gamma, and MISTAKES.md M119 records both this assertion and line 98 as clamp-absorption instances, with the ruled remedy being the extraction now asserted at line 111 while 'the caps keep their own assertions, which are worth having as clamp tests'. Line 98's label ('funded member cluster-clamped with note') correctly names what it tests and I do not report it. Line 116's label does not: it claims the item is 'uncapped' and 'funded full' when the asserted number is a cap and the unclamped size is six times larger. Under the deciding question, the property in the label â€” full funding â€” is absent from the subject and the assertion passes anyway. This is the residual of M119 rather than a new instance: the clamp half is on the register and ruled, the misdescribing label is not.

**Could it pass with the property absent?** The item is not funded full â€” 5000 is the per-item exposure cap (measurable as ~10% of a 200m working stack at a 4000gp buy; the cluster-cap assertion at line 125 gives `clusterExposure === 16e6` = 8% of the same stack, which fixes the stack at 200m). A defect anywhere in the sizing term that feeds the cap leaves 5000 unchanged, which is precisely why line 111 was written.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. No behaviour change â€” rename the assertion so it claims what it tests, e.g. 'item outside the cluster cap lands at the per-item cap (a CLAMP test; the sizing term itself is asserted at line 111)'. The clamp-absorption rule's finding is an assertion whose SUBJECT is a clamped output while its label claims the term; naming it as a clamp test removes the false claim without removing the test.

### `probe:1329` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R4.3] intel cannot touch blacklist / reserve / gate constants
**Requirement:** R4.3

**Evidence.** The snapshot at probe-snippet.html:1230-1231 is taken, then exactly one record is ratified and activated: `DB.intel[0]` (probe-snippet.html:1232-1233), which is r-1 from `mkRec` whose default type is "demand-context" (probe-snippet.html:1202). `activateIntel` (index.html:14267-â€¦) branches by type â€” watch-note returns a string with no writes; catalyst / catalyst-update / long-catalyst push or mutate DB.catalysts (index.html:14270-14289); cluster-membership pushes DB.clusterCands (index.html:14290-14297). The demand-context branch is the one with no side-effect path at all. So the universal claim in the label ('intel cannot touchâ€¦') is exercised against the single record type that structurally cannot touch anything, while the types that DO write are activated elsewhere (lines 1250, 1260, 1274) with no sacred-set snapshot around them.

**Could it pass with the property absent?** If the catalyst or cluster-membership branch of activateIntel wrote to DB.blacklist, DB.reserve, DB.shadowReserve, GATE.roi, DB.tickFloor or GATE_CHAIN_ORDER, this assertion would still pass, because that branch never runs inside the snapshot. Determined by reading index.html:14267-14297 and the fixture's activation calls at probe-snippet.html:1232-1233 vs 1250/1260/1274.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Hoist the sacred-set snapshot to wrap EVERY activateIntel call in the Â§R4 block rather than one â€” capture `sacred` once before the first activation and re-compare after the catalyst, catalyst-update, cluster-membership and deflation-flag activations too. Cheapest durable form: a small `sacredSnapshot()` helper in the probe called before and after each activation, so a new record type added to activateIntel inherits the check instead of needing a new assertion. The rule is universal over record types; the assertion should be too.

### `probe:1392` — CLAMP — could-pass: **unknown** — confidence: low

**Label:** [R4.2c] teeth toggle halves the final size with the ruling stated inline
**Requirement:** R4.2c

**Evidence.** Assertion: `pT.allocQty === Math.max(1, Math.floor(q0 / 2)) && (pT.sizeNotes || []).some(s => s === "sized down 0.5Ã—: news risk (my ruling)")`. Production applies the haircut at index.html:4557-4561 â€” `p.allocQty = Math.max(1, Math.floor(p.allocQty / 2))` â€” after every cap and pour, as the comment at index.html:4552-4556 states. The `Math.max(1, â€¦)` floor is the clamp: at q0 === 1 the expected value collapses to 1, which is also the unhaircut value, so the halving becomes unobservable and only the note conjunct remains live. The sibling assertion for the pump halving at probe-snippet.html:1690 carries exactly this guard â€” `qPumpOff != null && qPumpOff > 1` â€” and was hardened for this on Aug 13 2026 per the comment at 1679-1685; the teeth assertion at 1297 has no equivalent guard.

**Could it pass with the property absent?** It turns entirely on whether q0 (the unhaircut allocQty for item 9001 at probe-snippet.html:1288) can be 1 in this fixture. I could not compute it: it comes from buildPlan's full cap chain (per-item cap, one-third stack clamp, buy-limit clamp, cluster cap, tier pools) and I am forbidden to run the suite. The fixture's inputs (l = 25000 at probe-snippet.html:76, buy â‰ˆ 4000, t1Budget 100e6) make a large q0 likely, so the defect is probably not live today â€” but the assertion carries no guard that keeps it from becoming live, which is the finding. If q0 ever lands at 1, the halving could be removed from index.html:4559 while the note at 4560 still rendered, and this assertion stays green.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the same guard its sibling carries â€” `q0 > 1 &&` inside the condition â€” so the assertion goes red if the fixture ever degenerates to a size where the floor clamp pins both readings, rather than passing silently. Cheap and exactly the precedent set at line 1690.

### `probe:1224` — face7 — could-pass: **no** — confidence: low

**Label:** [R1.4b] rung exit records qty/price and nets tax vs cost
**Requirement:** R1.4b

**Evidence.** probe-snippet.html:1130 asserts `ex1.net === 50 * (1200 - geTax(1200, 9052) - 1000)`. Production is index.html:12858: `const net = pos.basis > 0 ? qty * (px - geTax(px, pos.itemId) - pos.basis) : null;`. The probe line reproduces that expression operand-for-operand with the fixture's literals substituted â€” the named tell, 'a probe line that computes rather than calls'. The one mitigation, and it is why I grade this low: the probe DOES call the production path (recordSleeveExit at probe-snippet.html:1127) and reads its output, so a unilateral change to index.html:12858 â€” dropping the tax term, dropping the basis, mis-ordering the subtraction â€” makes the two expressions diverge and turns this red. The exposure is co-drift (an editor changing both to the same wrong shape) plus the general cost the seventh face names: the probe carries a parallel implementation of the money formula.

**Could it pass with the property absent?** Determined by reading index.html:12838-12864 and comparing the expressions term by term. Removing the tax netting from production changes net by 50*geTax(1200,9052) while the probe's expectation still includes it, so the assertion goes red. The property named in the label ('nets tax vs cost') is therefore genuinely covered today. I am reporting it because the named tell is present and the case law asks for the enumeration, not because I believe it is currently a live defect â€” grading this any higher would be exactly the confident-report-from-unconfident-input failure the governance forbids.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN, and possibly not worth doing. If it is done, the case law's remedy for an equality that would re-implement is a scaling property rather than a shared extraction (a shared sleeveExitNet() called by both sides would make this tautological): assert instead that net scales linearly in qty at fixed price, that net is strictly less than the untaxed qty*(px-basis) by an amount equal to qty*geTax(px,id), and that net is null when basis is absent â€” each of which pins a structural claim without restating the formula.

---

# TIER: FILL

### `probe:2481` — face2 — could-pass: **yes** — confidence: high

**Label:** [R29.1] the stratum rotation is a pure function of the price cycle â€” stable within one, advancing across, every stratum on a lap
**Requirement:** R29.1

**Evidence.** `stratAt = c => { S.latestAt = c * POLL_MS; return currentStratum().k; }` (probe 2318). The 'stable within one' clause is `stratAt(7) === stratAt(7)` â€” the SAME injected value on both sides, which tests determinism, not within-cycle stability. Production is `const cyc = Math.floor((S.latestAt || 0) / Math.max(1000, POLL_MS)); return STRATA[cyc % STRATA.length]` (index.html:2639-2642), STRATA.length = 21 (index.html:2599-2621), POLL_MS = 60e3 (index.html:1154). Stability within a cycle is the claim that every S.latestAt in [c*POLL_MS, (c+1)*POLL_MS) maps to one stratum; the fixture only ever samples the left endpoint.

**Could it pass with the property absent?** Worked counterexample: seed the divisor to POLL_MS/2 (rotate twice per cycle â€” the property gone). Then stratAt(c) = STRATA[(2c) mod 21]. stratAt(7)===stratAt(7) passes (identical input); stratAt(7)=14 !== stratAt(8)=16 passes; and gcd(2,21)=1 so the 21-entry lap is still all-distinct and `new Set(lap18).size === STRATA.length` passes. All three clauses green with the named property false. (I checked the cruder divide-by-1000 seed too â€” that one WOULD go red on the lap clause, gcd(18,21)=3, which is why the /2 case is the honest demonstration.)

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Inject two DIFFERENT instants inside one cycle and assert they agree: `stratAt(7) === stratAtMs(7*POLL_MS + POLL_MS - 1)`, plus the existing cross-cycle inequality and lap coverage. The same weakness sits at probe line 1798 ('sample is stable within one price cycle') which re-renders with S.latestAt unchanged â€” just outside this slice, reported in adjacent.

### `probe:2505` — face8 — could-pass: **yes** — confidence: high

**Label:** [R18.2] no print at-or-below the bid = no fill; observed time accrues capped
**Requirement:** R18.2

**Evidence.** The fixture at probe 2336 sets `lastObs: Date.now() - 5 * 60e3`. Production accrues `const dt = Math.min(Math.max(0, now - (p.lastObs || now)), SHADOW_OBS_CAP)` (index.html:6642) with `SHADOW_OBS_CAP = 10 * 60e3` (index.html:5683). A 5-minute gap against a 10-minute cap means the Math.min's cap arm can never be selected in this fixture. The assertion's cap clause is `sb2.obsMs <= 10 * 60e3`, which the uncapped 5-minute accrual satisfies on its own.

**Could it pass with the property absent?** Delete the `Math.min(..., SHADOW_OBS_CAP)` wrapper at index.html:6642 and obsMs is still ~5min, still > 0 and still <= 10*60e3 â€” green. The word 'capped' in the label is untested here. This is the trim-over-60-behind-a-cap-of-24 shape: neither number is wrong alone, the defect is in the relationship between the fixture's 5-minute gap and the 10-minute cap. Note also that 10*60e3 is a literal in the probe rather than SHADOW_OBS_CAP, so raising the production cap would not go red either. I did not determine whether another slice of the suite reaches the cap; grep for SHADOW_OBS_CAP in the probe file returned no hits, which suggests it does not, but assertions can reach it by literal.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the accrual as `obsAccrual(now, lastObs)` returning `Math.min(Math.max(0, now - lastObs), SHADOW_OBS_CAP)` and assert it directly: equals the elapsed gap below the cap, and equals SHADOW_OBS_CAP (the constant, not a literal) for a gap of, say, 30 minutes. Keep the tick-level assertion for the wiring, stated against SHADOW_OBS_CAP rather than 10*60e3.

### `probe:2519` — CLAMP — could-pass: **yes** — confidence: high

**Label:** [R18.2] a print at-or-below the bid fills volume-weighted (capture-capped)
**Requirement:** R18.2

**Evidence.** The subject `sb2.buyQ` is written by `p.buyQ = Math.min(q, (p.buyQ || 0) + cr.oper)` (index.html:6590). In this fixture cr.oper = `Math.max(1, Math.floor(4000 * GATE.capture))` = floor(4000 * 0.15) = 600 (index.html:6580-6583, GATE.capture at index.html:2830) against a trip qty of 10, so the Math.min is pinned by the OTHER input by a factor of 60. The assertion checks `sb2.buyQ === 10`.

**Could it pass with the property absent?** Any change to the volume-weighted term that leaves it >= 10 â€” a different capture constant, the wrong volume side, dropping the volume weighting entirely and crediting a flat number â€” produces buyQ === 10 and a green line. The 'volume-weighted (capture-capped)' half of the label is entirely absorbed by the qty clamp. MITIGATION, stated so this is not double-counted downstream: the probe's own comment at 2361-2367 acknowledges exactly this, and [R59.7] at 2368-2381 asserts the PRE-clamp term through buyTrace, which is the prescribed remedy already applied. The residual finding is that this line's own label still claims the unclamped property.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Narrow this label to what it can see ('the buy leg completes to qty') and let the volume-weighted claim rest on the trace assertions at 2368-2381 and on buyAbsorption().offered, which are already downstream of nothing.

### `probe:3500` — face2 — could-pass: **yes** — confidence: high

**Label:** [R53.2] the verdict counts what the register says, through production â€” not a probe-side recount
**Requirement:** R53.2

**Evidence.** All three conjuncts are forced by the fixture state the PRECEDING assertion pins. index.html:12484-12488 â€” paperCleanFrom() returns null whenever paperDefectsOpen().length is non-zero. index.html:12499-12502 â€” paperTripClean() returns false unconditionally when from == null. So `clean = trips.filter(paperTripClean)` (index.html:12537) is [] for ANY trips array, hence v.clean.n === 0. `ready: clean.length >= GAP_BAND_VERDICT_TRIPS` (index.html:12553) then follows as false. And `bar: GAP_BAND_VERDICT_TRIPS` (index.html:12553) makes `v.bar === GAP_BAND_VERDICT_TRIPS` a literal identity that cannot be false. The assertion immediately above, probe 3273-3277, asserts /open defects/ appears in the copy â€” i.e. it pins the register into exactly the state that forces all three.

**Could it pass with the property absent?** Replace `trips.filter(paperTripClean)` with a hardcoded [] and this assertion is bit-for-bit unchanged. Its own label claims the verdict 'counts what the register says' â€” a counter wired to always return zero satisfies every limb. Honest mitigation, which I checked rather than assumed: the clean-count path IS exercised elsewhere, at probe 6877-6885 ([R64.4]), where trips stamped with the current clrGen yield vPost.clean.n === 8. So the property is not globally uncovered; this specific assertion is the one that cannot fail, and it occupies the slot on the gap-band surface.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Fixture repair, not a probe recount: build the trips array with records stamped `clrGen: paperClrGen()` and `t >= paperCleanFrom()` under a temporarily cleared register (the [R64.4] block at probe 6873-6885 already shows the pattern), then assert clean.n and contaminated.n are the two non-zero halves that sum to trips.length. Drop the `v.bar === GAP_BAND_VERDICT_TRIPS` conjunct or replace it with a check that the RENDERED copy states the same bar â€” as written it is a self-comparison. Prove by hardcoding clean = [] and watching the new form go red.

### `probe:3515` — face9 — could-pass: **yes** — confidence: high

**Label:** [R54.2] the four named surfaces carry it: gate health's paper columns, per-stratum sim P&L, the hours paper stream, the gap band
**Requirement:** R54.2

**Evidence.** Probe 3293-3298 tests /downstream of the paper book/ against the ENTIRE output of paperGateSection(), prospectingInline(), hoursStreamsNote() and gl53. index.html:5907 â€” provTag(false) emits the literal text 'not downstream of the paper book', which CONTAINS the asserted substring. Three of the four named surfaces render BOTH tags: paperGateSection at index.html:9546 (provTag(true)) and 9548 (provTag(false)); prospectingInline at index.html:12356 (true) and 12358 (false); hoursStreamsNote at index.html:9776 (false) and 9777 (true). Only gapBandInline carries provTag(true) alone (index.html:12562, via gapBandVerdictLine), so only that limb discriminates.

**Could it pass with the property absent?** Delete provTag(true) from the paper columns, the per-stratum sim P&L line and the hours paper stream â€” the exact property this assertion names â€” and each surface still emits provTag(false), whose text satisfies the regex. The assertion stays green on real production output. The companion at line 3299 does not rescue it: that one requires 'not downstream', i.e. the clean label, so it stays green too. The pair cannot detect removal of the contaminated-side disclosure on three of the four surfaces.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Cheapest correct narrowing: match /">downstream of the paper book/ â€” provTag(true) emits '">downstream' and provTag(false) emits '">not downstream', so the pattern discriminates. Better, per the ninth face's generalisation: extract each surface's provenance note into a named production function (paperColsNote(), prospProvNote(), hoursProvNote()) and point each limb at that one fragment, so the container is the note rather than the section. Prove it by deleting provTag(true) from paperGateSection alone and confirming the new form fails while line 3299 stays green â€” that is the tenth face's discrimination requirement.

### `probe:3842` — CLAMP — could-pass: **yes** — confidence: high

**Label:** [R28.3] eviction: lowest-score scanner position yields to a better-scored candidate; watch-cohort positions never evicted
**Requirement:** R28.3

**Evidence.** The condition is `open28.length <= SHADOW_MAX_OPEN && !open28.some(p => p.itemId === 81000) && open28.filter(p => p.cohort !== 'scanner').length === SHADOW_MAX_OPEN - 1`. Production (index.html:6336-6354): at the cap it finds the lowest-scored scanner position, refuses if its score is not beaten, splices it out (6340), and THEN pushes the new position (6343). The label's load-bearing verb is 'yields TO a better-scored candidate' â€” evict AND admit. The assertion never checks that anything was admitted: the fixture seeds SHADOW_MAX_OPEN-1 non-scanner opens plus one scanner open (probe:3611-3616), so a seeded defect that splices the evictee and then falls through without pushing leaves length = 39 (<= 40, passes), itemId 81000 absent (passes), non-scanner count = 39 (passes). The first conjunct is the capped output â€” SHADOW_MAX_OPEN pins it from above whatever the eviction logic does â€” and the `extra` string at 3623 even computes the scanner count that would have caught this, without asserting it.

**Could it pass with the property absent?** Traced against index.html:6336-6354. Removing the admission half of the eviction path changes none of the three conjuncts. Also unchecked: that the admitted position is the better-scored candidate rather than an arbitrary one.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the eviction decision out of the scan closure into a named function (e.g. `scannerEvictee(candidateScore)` returning the position that must yield, or null when the cap holds) and point an assertion at that; then add the missing conjunct on the observable side â€” assert `open28.length === SHADOW_MAX_OPEN` and that exactly one scanner position is open and its itemId is the better-scored candidate, not 81000. Do not reproduce the ranking in the probe.

### `probe:4411` — STALE — could-pass: **yes** — confidence: high

**Label:** [R37.1] the floor is 25% of the fill horizon, and the three states are distinct
**Requirement:** R37.1

**Evidence.** mk37 (probe:4183-4188) builds trips with `obsMs: Math.round(H37 * obsFrac)` where `H37 = FILLH() * 3600e3` (probe:4182) and stamps NO hzH. Production: `shadowObsShare = p => Math.min(1, (p.obsMs||0) / Math.max(1, legHorizonH(p) * 3600e3))` (index.html:5713), and `legHorizonH(rec)` returns `rec.hzH` when finite, else `Math.max(1, DB.fillHorizonH || 4)` (index.html:2928-2931) â€” a fallback whose own comment says it is for 'records written before this feature'. DB.fillHorizonH is declared 'FALLBACK ONLY since the cadence build' (index.html:1240) and the probe fixture sets it to 4 with an empty schedule (probe:65). Every paper trip production opens stamps `hzH: PAPER_HORIZON_H` where PAPER_HORIZON_H = 6 (index.html:6062, 6203, 6346), and the book's copy states it 'no longer models your cadence at all' (index.html:9250) with `const hz = PAPER_HORIZON_H; /* the book's own horizon, never the schedule's */` (index.html:6112). Concretely: mk37(...,0.25) gets obsMs = 1h; against the fallback 4h that is share 0.25 and `shadowCounts` is true, which is what the assertion demands. Give the same record the horizon production stamps (hzH: 6) and share is 1/6 = 0.167, `shadowCounts` returns FALSE and this assertion goes red. The boundary it proves exists only on the vestigial path. The same missing stamp runs through mk35 (probe:3820) and mk27 (probe:3498), so the whole slice's paper-book fixture family shares the shape; only this assertion's boundary cases flip on it.

**Could it pass with the property absent?** The named property is 'the floor is 25% of the fill horizon'. The horizon the assertion actually divides by is DB.fillHorizonH, not the horizon any live paper trip carries. Ratify PAPER_HORIZON_H from 6 to any other value â€” a live behaviour change reclassifying counted/thin trips across the whole book â€” and nothing in this assertion moves, because its records have no hzH to read. That is the 'ratification that breaks no test' shape verbatim.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Stamp the fixture with the shape production writes: add `hzH: PAPER_HORIZON_H` to mk37 (and to mk35/mk27) and compute obsMs from PAPER_HORIZON_H rather than FILLH(). Expect the 0.25/0.24 boundary cases to need recomputation against 6h, and expect the [R37.1] count assertion at 4203 (n===4, thin===3) to be re-verified â€” I checked and those two counts survive the change, but the boundary pair at 4191-4192 does not. Separately, no assertion I found anywhere binds a paper trip's stamped horizon to PAPER_HORIZON_H; probe:4718-4721 exercises shadowObsShare with hzH 4 and 9.5, which are schedule gaps, not the book's constant.

### `probe:4447` — face9 — could-pass: **yes** — confidence: high

**Label:** [R37.2] every excluded count opens to the trips behind it â€” on the gate tree, the cohort ledger and the hours table
**Requirement:** R37.2

**Evidence.** The condition matches `/data-drill="thin:gate:ROI floor Â· pre-stamp"/` against gateStreamsSection() and `/data-drill="thin:coh:watchlist"/` against paperCohortSection(). The hours table is named in the label and never touched. Production calls thinNote() from exactly three places: index.html:9662 (cohort, key 'coh:'+c), 9831 (hours table, key 'hour:'+r.h) and 12031 (gate stream, key 'gate:'+g); thinNote builds the drill at 5771 as `drill('thin:' + key, ...)`. So `thin:hour:<h>` is a real, renderable key that no assertion in this slice requires. Delete the thinNote() call from index.html:9831 and this assertion â€” the only one whose label claims the hours table carries it â€” stays green, because the property survives on the two surfaces it does match.

**Could it pass with the property absent?** Traced all three thinNote call sites in production. The third of the label's three named surfaces has no corresponding conjunct.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the missing conjunct against the hours surface â€” seed at least one thin trip in a specific hour and assert `/data-drill="thin:hour:<h>"/` inside that hour's row in #hoursTable â€” and scope each of the three matches to the surface it names rather than to the whole section string, so a deletion on one surface cannot be masked by the others.

### `probe:4479` — face2 — could-pass: **yes** — confidence: high

**Label:** [R37.4] the regime ledger's daily snapshot excludes thin trips â€” a fast fill cannot argue for a gate change
**Requirement:** R37.4

**Evidence.** Fixture (probe 4253-4256): DB.shadowBook = [mk37(9001, "filled", 500000, 0.02, null, { regimes: ["current"] })] â€” ONE trip, thin (obsFrac 0.02) â€” then shadowTick(), then asserts snap37.cur === 0. Production (index.html:6807-6809): `const reg = r => DB.shadowBook.filter(p => shadowCounts(p) && (p.regimes || []).includes(r)).reduce(...)`. The assertion cannot separate the two conjuncts: cur is 0 when shadowCounts() excludes the thin trip AND equally when the `.includes(r)` membership leg never matches anything. That second reading is not hypothetical â€” it is the exact incident recorded in CLAUDE.md's 'never-fed aggregate' case law, where the regime race reported three zero curves for an entire epoch because no trip had ever been assigned a regime. I grepped every DB.shadowDivLog fixture in the probe (lines 2420, 2426, 2478, 3525, 5206, 5374, 5469): all of them ASSIGN the ledger literally. Only 4253-4256 computes it through shadowTick, and it computes zero â€” so no assertion in the suite demonstrates that reg() can return a non-zero number at all.

**Could it pass with the property absent?** Determined by reading the producer at index.html:6807-6809 and by enumerating all shadowDivLog fixtures in the probe. With the thin-exclusion leg (`shadowCounts(p) &&`) deleted the assertion fails â€” that seed bites. With the membership leg broken the assertion still passes, which is the reason-other-than-the-property half of the root.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the positive control the fixture lacks: a second, OBSERVED trip carrying regimes:["current"] with a distinct net, and assert the pair â€” snap.cur equals exactly the observed trip's net, not 0 and not the sum. That one change makes the assertion fail on both the exclusion defect and the never-fed-membership defect, and it is the same repair shape the case law prescribes for a zero that could mean two opposite things.

### `probe:4994` — face2 — could-pass: **yes** — confidence: high

**Label:** [R40.7] a bucket the series has no data for credits nothing
**Requirement:** R40.7

**Evidence.** The assertion calls reconReplay({â€¦state:"open"}, [], base40, Date.now()) === 0 â€” an EMPTY series, not a series containing a bucket without data. Those are different inputs and only the second can test the label's property. Production: reconReplay (index.html:6432-6437) does `for (const b of pts){ if (b.t < from || b.t > to) continue; covered += M5_MS; â€¦}` â€” the credit is unconditional on the bucket having data. The series builder recon5m (index.html:6394-6399) maps EVERY /timeseries point through, emitting `lo: Number.isFinite(p.avgLowPrice) ? p.avgLowPrice : null` and the same for hi â€” so buckets with lo:null, hi:null, lv:0, hv:0 are in pts and reach the loop. With an empty array the loop body never executes, so the return is 0 whatever the credit rule is.

**Could it pass with the property absent?** Delete any data test from the credit path (there is none to delete today) and the assertion still returns 0, because zero iterations produce zero coverage regardless. The assertion's own extra string says "no buckets, no credit" â€” which is what it actually tests â€” while its label says "a bucket the series has no data for", which it does not reach.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the data test into a named production predicate â€” e.g. `bucketHasData(b)` returning `b.lo != null || b.hi != null` â€” have reconReplay credit only when it holds, and point the assertion at a mixed fixture: a 4-bucket series where 2 carry prices and 2 carry lo:null/hi:null, asserting coverage === 2 * M5_MS. Keep the empty-array case as a separate assertion with a label that says empty series. Per the tenth face, confirm the seed discriminates: removing the predicate must fail the mixed case while the empty-series case stays green. Note this fix would change production behaviour, so it is a ruling for the user, not a probe repair.

### `probe:5461` — face1 — could-pass: **yes** — confidence: high

**Label:** [R42.2] the tape credit is reported at all THREE reachability readings
**Requirement:** R42.2

**Evidence.** The third of the three readings is checked with `"buyCreditProvenReachable" in b`. That key is an unconditional literal in the object returned by `analysisTrip` (index.html:17725: `buyCreditProvenReachable: p.buyQStrict != null ? p.buyQStrict : null,`), so the `in` test is true for every trip the export can produce, whatever the value. The other two readings are checked by VALUE (`b.buyCreditOperative === 10 && b.buyCreditPossiblyReachable === 40`); only the proven reading is downgraded to key presence. The fixture compounds it: `mkTrip` (probe-snippet.html:5186-5191) never sets `buyQStrict`, so `buyCreditProvenReachable` is null in this run and the assertion passes over a null.

**Could it pass with the property absent?** Delete the value and keep the key â€” e.g. change index.html:17725 to `buyCreditProvenReachable: null,` â€” and the assertion stays green, while the export stops reporting the proven-reachability reading the label says it reports. The conjunct cannot go red for any change short of removing the key from the object literal.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Stamp `buyQStrict` in the `mkTrip` fixture with a value distinct from `buyQ` and `buyQFull` (the three readings must be mutually distinguishable, or a defect that collapses them is invisible), then assert the VALUE: `b.buyCreditProvenReachable === <that value>`. Keep an explicit assertion that a trip with no strict counter reports `null` rather than 0, since null-vs-zero is the proven/never distinction the reachability bracket rests on. Prove by seeding the literal at index.html:17725 to null.

### `probe:5574` — face7 — could-pass: **yes** — confidence: high

**Label:** [R43.1] the three ROI floors are ordered loose < current < tight, so membership nests
**Requirement:** R43.1

**Evidence.** The probe DEFINES its own copy of the production logic at probe-snippet.html:5345-5351 â€” `const regOf = eR => { const out=[]; if (eR >= GATE.roi) out.push("current"); if (eR >= GATE.roi*SHADOW_LOOSE) out.push("loose"); if (eR >= GATE.roi*SHADOW_TIGHT) out.push("tight"); return out; }` â€” which is a verbatim transcription of index.html:3077-3081 inside `regimesFor()`. Four of the six conjuncts in the assertion (`regOf(GATE.roi*SHADOW_TIGHT+0.01).length===3`, `regOf(GATE.roi+0.01).join()==="current,loose"`, `regOf(GATE.roi*SHADOW_LOOSE+0.001).join()==="loose"`, `regOf(GATE.roi*SHADOW_LOOSE-0.1).length===0`) call the PROBE's function, not production's. The probe's own comment at 5343-5344 says why â€” "regimesFor reads effMargin, so drive it through a real calc instead" â€” i.e. the author knew the production path was hard to reach and reproduced it rather than extracting it. This is the tell the seventh face names: a probe line that computes rather than calls.

**Could it pass with the property absent?** Seed the nesting defect in production â€” swap the pushes at index.html:3079/3080 so `GATE.roi*SHADOW_TIGHT` pushes "loose" and `GATE.roi*SHADOW_LOOSE` pushes "tight" â€” and this assertion stays green, because `regOf` is untouched. The two conjuncts that DO test real values (`GATE.roi*SHADOW_LOOSE < GATE.roi && GATE.roi < GATE.roi*SHADOW_TIGHT`) only test the constants' ordering, not their USE in `regimesFor`. The companion assertions do not close the gap either: [R43.1] line 5363 calls the real `regimesFor(calc(9001))` but only on a candidate that clears ALL three floors, so a swap still yields all three regimes and it stays green; line 5367 tests null-safety only. The boundary behaviour of `regimesFor` â€” the entire subject of the label â€” is asserted nowhere against production.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the threshold block from `regimesFor` (index.html:3077-3081) into a named function taking the effective ROI directly â€” e.g. `regimesForRoi(eR)` â€” have `regimesFor` call it, and point lines 5352-5357 at `regimesForRoi` instead of the probe-local `regOf`. Then delete `regOf`. This is the `strataCount()` / `calibWindow()` pattern: the extraction is the fix, not a convenience. Prove it by seeding the push-swap at 3079/3080 and confirming the assertion goes red; confirm the seed is observable first (the lines execute on every candidate stamp).

### `probe:5649` — CLAMP — could-pass: **yes** — confidence: high

**Label:** [R43.2] the same bucket credits a leg ONCE, however many polls present it
**Requirement:** R43.2

**Evidence.** The assertion's discriminating conjunct is `DB.shadowBook[0].buyQ === after1` (i.e. buyQ did not move across two further polls). `buyQ` is written only by `shadowCredit` at index.html:6590: `p.buyQ = Math.min(q, (p.buyQ || 0) + cr.oper)`. The fixture sets qty = 10 (probe-snippet.html:5405, `mkC2` â†’ `qty: 10`) while the per-bucket credit is large: `S.min5[9002].lowPriceVolume = 4000` (5410), `reachCredit` computes `tape = Math.max(1, Math.floor(v * GATE.capture))` = floor(4000 Ã— 0.15) = 600 (index.html:6580, GATE.capture = 0.15 at index.html:2830), and the bucket average low 3900 is strictly below the bid 4001 so `beyond` is true and `oper = tape = 600` (index.html:6583). So the first credit sets buyQ = Math.min(10, 600) = 10 and the clamp pins it there permanently. Every later credit, correct or duplicated, leaves buyQ at 10.

**Could it pass with the property absent?** Delete the once-per-bucket machinery entirely and let every poll re-credit the leg: buyQ still reads 10 after the roll and 10 after the two extra polls, because 10 is the qty ceiling. `beforeRoll === 0` is satisfied by the deferred-credit design (nothing credits while a bucket is current, index.html:6656-6696) and `after1 > 0` by any credit at all, so the only conjunct that could carry the ONCE property is the one the clamp absorbs. Secondary observation, same line: the once-ness actually delivered here comes from `p.pend = null` at index.html:6694 and the roll condition `p.pend.bkt !== bkt`, NOT from the `p.buyBkt !== q.bkt` guard at index.html:6659 that the code's own comment (6625-6626) names as the mechanism â€” so a seed in that guard would also change nothing observable. Reported in adjacent.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Size the fixture so the clamp cannot pin the term: set `mkC2`'s qty well above the per-bucket credit (e.g. qty 5000 against a 600-unit bucket credit), then assert the SCALING property â€” one bucket roll credits exactly one bucket's worth, and N rolls credit N Ã— that, so a duplicate credit moves the number. Alternative, if the fixture must stay small: point the assertion at the pre-clamp term that already exists â€” `p.buyTrace` rows carry `credited: cr.oper` explicitly BEFORE the clamp (index.html:6670-6677) â€” and assert that no bucket timestamp `t` appears twice in the trace. Either way the assertion must name the unclamped term. Prove by seeding a re-credit (remove the `p.pend = null` at 6694) and confirming red.

### `probe:5799` — face8 — could-pass: **yes** — confidence: high

**Label:** [R57.2] and the concurrency cap binds instead when families are plentiful
**Requirement:** R57.2

**Evidence.** paperCapacity computes wanted = watchCeil + sliceCeil + scanCeil and binding = wanted <= byCap ? 'per-cohort limits â€¦' : 'the 40-trip concurrency cap â€¦' (index.html:6129-6137). The constants make the comparison unconditional: POLL_MS = 60e3 (index.html:1154) â†’ cyclesPerDay 1440; SLICE_SHADOW_CAP = 5 (index.html:7123) â†’ sliceCeil 7200; SCOUT_EVERY = 10*60e3 (index.html:10352) â†’ scoutPerDay 144, SHADOW_SCAN_TOP = 8 (index.html:6292) â†’ scanCeil 2304; SHADOW_MAX_OPEN = 40 (index.html:5683) and PAPER_HORIZON_H = 6 (index.html:6062) â†’ byCap 160. So wanted >= 9504 > 160 for ANY family count, including zero. `binding` is always the concurrency string, `ceiling` is always byCap because Math.min(wanted, byCap) is permanently pinned by byCap, and `wanted > byCap` is always true. The fixture's 300 fabricated families (probe 5579-5580) change none of the three things the assertion checks.

**Could it pass with the property absent?** Set the fixture's book to zero families â€” or delete the watchFams term from `wanted` entirely â€” and all three conjuncts (`c.ceiling === c.byCap`, `/concurrency cap/.test(c.binding)`, `c.wanted > c.byCap`) still hold, because sliceCeil + scanCeil alone exceed byCap by 59Ã—. The stated condition 'when families are plentiful' is not what makes the assertion pass. The only conjunct the fixture actually drives is `c.watchFams === 300`, which tests the family counter, not the binding rule. Arithmetic done by hand from the five constants cited; I did not execute anything.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN, and the first half is a production question that is the user's ruling, not mine. (a) Establish whether the `wanted <= byCap` branch at index.html:6135-6136 is reachable at all under any settable configuration; on my arithmetic it is not, which makes its copy â€” 'per-cohort limits (cooldown on the watchlist, draw size on the rotating cohorts)' â€” a string that can never render, the same shape as the trim-over-60 rule behind a stored cap of 24. Per the eighth face the choice is whose promise it is: either the rotating-cohort ceilings should themselves be bounded by their share of the concurrency cap (making the comparison meaningful), or the ternary collapses to the one branch that can occur and the copy stops implying a state that cannot exist. (b) Whichever way that is ruled, re-point this assertion at the term that actually varies with family count â€” c.watchCeil, which moves 4.4 â†’ 660 between the two fixtures â€” and assert the binding string only in a fixture that can produce both branches. Before deleting the dead branch, note that this assertion is the only thing pointed near it: scan 13's rule applies, move the assertion first.

### `probe:6094` — face2 — could-pass: **yes** — confidence: high

**Label:** [R44.3] distribution rides beside it â€” median trip, top-5 share, and the outcome census
**Requirement:** R44.3

**Evidence.** The fixture is exactly four trips (probe 5866). paperEconomics computes top5 = nets.slice(-5).reduce(â€¦) over the sorted net array and top5Share = top5 / net (index.html:7722-7723, 7746). With n = 4 the slice(-5) is the WHOLE array, so top5Share === net/net === 1 identically, whatever the concentration logic does. The assertion's `eco.top5Share > 0.9` therefore cannot fail. The other two conjuncts are sound: median === 525 is the real median of [50,50,1000,100000] and outcomes.filled === 4 is a real census.

**Could it pass with the property absent?** Replace top5Share's computation with a hardcoded 1.0, or with top1/net, or with any function returning anything above 0.9, and the assertion is still green. The concentration property the field exists to carry â€” the case law's 'n is not sample size' and 'a share of a negative net is not a proportion' rulings both rest on it â€” is not under test at n=4. Confirmed by reading index.html:7722-7723 and counting the fixture's rows; not executed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Widen the fixture to at least six trips so the top-5 is a strict subset, and assert the exact share rather than a floor. Separately, nothing in this slice exercises the ruled withholding path: paperEconomics sets shareBasis and returns null shares when net <= 0 (index.html:7743, 7749-7751), and the gap-band incident that produced that rule is exactly a losing cell â€” a fixture whose net is negative, asserting top5Share === null and that shareBasis names the reason, would cover it. top1Share is already a strict subset at n=4 (100000/101100 = 0.989) and is a cheaper interim subject than top5Share.

### `probe:6511` — face9 — could-pass: **yes** — confidence: high

**Label:** [R47.5] the panel carries the same caveat where the lower bound is READ, not in a footnote
**Requirement:** R47.5

**Evidence.** All four regexes match against `zPanel = calibSection()` â€” the entire panel. 'Not in a footnote' is a position claim and no conjunct tests position; `teach()` (index.html:7581-7583) is exactly the footnote form the label forbids, and its body is part of the same string. The correct pattern already exists two hundred lines below in this same slice: [R60.2] at line 6431 strips the `details.teach` outerHTML and matches the remainder. This assertion does not.

**Could it pass with the property absent?** Wrap the self-comparison caveat in `teach(...)` â€” the precise relocation the label exists to forbid â€” and every regex still matches, because teach()'s body is inline HTML in the same returned string.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Reuse the [R60.2] pattern: parse the panel, remove every `details.teach` subtree, and assert the caveat text survives in the remainder â€” and, for the 'where the lower bound is READ' half, assert it sits within the same container element as the proven-reach row rather than merely outside disclosures.

### `probe:6536` — face8 — could-pass: **yes** — confidence: high

**Label:** [R48.1] the sell window opens where the BUY really finished â€” tape before that credits nothing
**Requirement:** R48.1

**Evidence.** The assertion is `sRow.trace.length > 0 && sRow.trace.every(x => x.minsIn >= 0)`. In `calibReplaySell` the loop skips every point before the window start â€” `if (b.t < start || b.t - start > H) continue;` (index.html:7976) â€” and only then pushes a trace entry whose `minsIn` is computed from that same `start`: `minsIn: Math.round((b.t - start) / 60e3)` (index.html:7981). A negative minsIn is therefore unreachable for ANY value of `start`. Re-anchor line 7971 from `e.buyDoneReal` to `e.buyAt` and this assertion is still green; the anchor is covered only by the separate verdict assertion at line 6272.

**Could it pass with the property absent?** Read the production loop directly. The relationship between the filter at 7976 and the arithmetic at 7981 makes the asserted condition an identity, not a property â€” the same shape as the trim-over-60 behind a cap of 24, one layer up.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract `sellWindowStart(e)` (the `reconWindowStart()` precedent), state the promise there, and assert `sellWindowStart(sW) === sW.buyDoneReal`. Then add tape that WOULD credit before buyDoneReal (hi above f.sell) and assert the credited total is unchanged â€” that is the 'credits nothing' half, which nothing currently tests.

### `probe:6716` — STALE — could-pass: **yes** — confidence: high

**Label:** [R59.1] a small negative gap with volume classifies as DILUTION, and carries the figures that decided it
**Requirement:** R59.1

**Evidence.** Two-argument call again, and the inner condition reads the retired constant directly: `c.medGapPct >= -SELL_DILUTION_GAP_PCT`. Under the live path the deciding term is `relBand` (index.html:8123, 8129) and the reason string is built from the spread: index.html:8131-8133 renders 'inside a third of this item's own ' + Math.round(spreadPct*100)/100 + '% spread'. With spreadPct undefined that renders 'NaN%'; with the 0 that production passes when bid or ask is missing (index.html:8239, 8260) it renders 'own 0% spread (1%)'. The assertion's regex only matches the tail phrase `/prints above the ask are plausible/`, so it is green over both readings. Neither `c.relBandPct` nor `c.spreadPct` â€” the fields the ratification added at index.html:8127-8128 â€” is asserted anywhere in the slice.

**Could it pass with the property absent?** The label claims the classification 'carries the figures that decided it'. The figure that decides it since Aug 13 is relBandPct, which the assertion never reads; and the copy that names it can render NaN or a self-contradicting 0% while the assertion passes on a phrase from the sentence's tail. This is also the eleventh face â€” presence of the right phrase with no negative match on the contradicting one.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Pass a spread; assert `c.relBandPct === spreadPct/3` and `c.spreadPct === spreadPct`; and add a negative match forbidding `/NaN/` and `/own 0% spread/` in `c.why`, so a reason that names a band it did not use fails.

### `probe:6749` — STALE — could-pass: **yes** — confidence: high

**Label:** [R59.1] a large gap that is NOT sustained is not mislocation â€” a window containing a dip is not a wrong window
**Requirement:** R59.1

**Evidence.** Same two-argument call shape: `classifySellFailure(mixed, 1200)` where `mixed` is 3 buckets at âˆ’12% and 7 at âˆ’2.5%, median âˆ’2.5%. Production line index.html:8123 falls back to SELL_DILUTION_GAP_PCT = 1.0 (index.html:8051) only because no spread was supplied; âˆ’2.5 < âˆ’1.0 â†’ not dilution, sustainShare 0.3 < SELL_MISLOC_SUSTAIN 0.7 (index.html:8054) â†’ 'unclassified'. Supply a spread of 7.5% or more â€” well inside the 3.28%â€“19.17% range the ratification note itself cites at index.html:8116 â€” and relBand becomes â‰¥ 2.5, so the same buckets classify as DILUTION and the asserted outcome inverts.

**Could it pass with the property absent?** The label's property is about the mislocation bar's sustain requirement, but the assertion's discriminating outcome is decided by the dilution band it never supplies. The assertion cannot distinguish 'not mislocated' from 'the fallback band answered', and would pass identically with the spread-relative band removed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Supply a spreadPct low enough that the dilution branch cannot claim the case (e.g. 3), so the assertion isolates the sustain requirement it names; add a second reading at a high spread showing the case moves to dilution, which is the ratified behaviour.

### `probe:6753` — STALE — could-pass: **yes** — confidence: high

**Label:** [R59.1] NEITHER-FITS is a real outcome â€” a gap between the bands surfaces rather than being forced into a bucket
**Requirement:** R59.1

**Evidence.** Probe calls `classifySellFailure(mkB(-3, 500, 10), 1200)` â€” two arguments. Production's signature is `classifySellFailure(buckets, ask, spreadPct)` (index.html:8084) and the live dilution band is `const relBand = spreadPct > 0 ? spreadPct * SELL_SPREAD_REL_FRACTION : SELL_DILUTION_GAP_PCT` (index.html:8123), tested at index.html:8129. Both production call sites pass a third argument: `calibSellCases` (index.html:8238-8239) and `paperSellCases` (index.html:8259-8260). With the argument omitted, `spreadPct > 0` is false and the retired flat 1.0% band answers, so a âˆ’3% median gap reads 'unclassified'. Under the ratified band, âˆ’3% on any item whose own spread is â‰¥ 9% classifies as DILUTION â€” which is precisely the reclassification the Aug 13 ratification (commit b11cf9a, reasoning at index.html:8113-8122) was for. The assertion holds the superseded expectation on a path production no longer takes at this call site.

**Could it pass with the property absent?** The property named in the label is that a gap between the bands surfaces as its own outcome. Delete the spread-relative band entirely (revert index.html:8123 to the flat constant) and this assertion is unchanged â€” it is already only ever exercising that constant. Equally, the ratification that DID happen changed the live behaviour for this input class and left the assertion green.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Pass the spread as production does, and assert the band rather than only the class: call `classifySellFailure(mkB(-3,500,10), 1200, 6)` (relBand 2.0 â†’ unclassified) and `classifySellFailure(mkB(-3,500,10), 1200, 12)` (relBand 4.0 â†’ dilution), asserting `c.relBandPct` in each. The two-arg fallback deserves its own separate assertion naming itself as the no-spread fallback.

### `probe:6812` — STALE — could-pass: **yes** — confidence: high

**Label:** [R59.5] the dilution threshold is FROZEN â€” it does not follow the ROI floor it was derived from
**Requirement:** R59.5

**Evidence.** Both classifications inside the IIFE are two-argument calls, so both land on the fallback at index.html:8123, and the assertion pins `SELL_DILUTION_GAP_PCT === 1.0`. Since the Aug 13 ratification the live band for any item with a spread is `spreadPct * SELL_SPREAD_REL_FRACTION` (index.html:8168) and SELL_DILUTION_GAP_PCT answers only when spreadPct <= 0. The freeze property that now matters â€” that SELL_SPREAD_REL_FRACTION does not track GATE.roi â€” is not asserted anywhere in the slice. Separately, `a === b` cannot differ for the stated reason: SELL_DILUTION_GAP_PCT is a module-level `const` fixed at load (index.html:8051), which is the seeding precondition's own worked example of a change that computes the same value anyway; the comparison only bites if someone rewrites the band to read GATE.roi at call time.

**Could it pass with the property absent?** Make SELL_SPREAD_REL_FRACTION derive from GATE.roi â€” the exact defect the label forbids, on the term that is now live â€” and this assertion stays green, because it never touches the relative band.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Re-point the freeze test at the live band: classify the same buckets with a fixed spread before and after moving GATE.roi, assert the returned `relBandPct` is unchanged, and keep the SELL_DILUTION_GAP_PCT check as an explicitly-labelled fallback-path assertion rather than as the headline.

### `probe:6827` — face12 — could-pass: **yes** — confidence: high

**Label:** [R59.6] and once the sample exists it reports the spread distribution and what WOULD reclassify â€” without changing anything
**Requirement:** R59.6

**Evidence.** The probe hands `sellShapeReport` case objects it builds itself: `{ spreadPct: 15, medGapPct: -3, cls: 'unclassified' }` Ã—5 and `{ spreadPct: 1.5, medGapPct: -0.5, cls: 'dilution' }` Ã—5. Production never constructs those objects by hand â€” it builds them as `Object.assign({â€¦}, classifySellFailure(â€¦, spreadPct))` at index.html:8238 and index.html:8259, so `cls` IS the classifier's output. For spreadPct 15 and medGapPct âˆ’3 the classifier returns 'dilution' (relBand 5, index.html:8123/8129), not 'unclassified'; the fixture's `cls` is a value production cannot produce for those inputs. The consequence the fixture masks: `sellShapeReport` filters to `c.spreadPct > 0 && c.medGapPct != null` (index.html:8180) and then compares `sellRelClassOf(c)` (index.html:8173-8178) against `c.cls` â€” but for every surviving case the classifier already applied that identical comparison, so `wouldReclassify` is now identically 0 on any real population. The assertion asserts `wouldReclassify === 5` and `SELL_DILUTION_GAP_PCT === 1.0`, and its own label still says 'without changing anything', which is pre-ratification framing.

**Could it pass with the property absent?** I traced both production constructors and the report's filter. Whatever the shape report does on real data, this assertion is decided entirely by hand-built `cls` values, so it would pass unchanged if the report were tautological on every real population â€” which, as far as I can determine from index.html:8129 vs 8175, it now is.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Build the cases through `classifySellFailure` (bucket fixtures plus a spread) exactly as calibSellCases/paperSellCases do, then feed those to `sellShapeReport`. If wouldReclassify then reads 0 by construction, that is the finding, and the report needs re-pointing at the retired absolute band rather than the live one â€” a production change, ruled separately.

### `probe:6955` — face2 — could-pass: **yes** — confidence: high

**Label:** [R62.3] the curve names where it STOPS being evidence rather than drawing into an empty population
**Requirement:** R62.3

**Evidence.** The condition is `fillCurveEvidenceTo(cv) === null && FILL_CURVE_MIN_AT_RISK === 8`. Production is index.html:8959-8963: `let last = null; for (const c of curve) if (c.atRisk >= FILL_CURVE_MIN_AT_RISK) last = c.h; return last;`. The fixture (probe 6659-6662) is six trips, and the sibling assertion at probe 6666 pins the maximum at-risk column at 6 (`at(1).atRisk === 6`). Six is below the bar of eight, so the loop body â€” the assignment that IS the 'names where it stops' behaviour â€” never executes on this fixture. Only the null path is exercised.

**Could it pass with the property absent?** Seed `last = c.h` to `last = null` at index.html:8961, or delete the assignment entirely, and the function still returns null on this fixture, so the assertion stays green. I confirmed the fixture's population ceiling from the assertion at probe 6666, which is asserted against production's own curve. Some defects ARE caught (widening the comparison to `c.atRisk >= 0` would make it non-null and fail), so this is a partially-blind assertion rather than a wholly dead one â€” which is why I rate it high on the reasoning and note the partial coverage honestly.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a second cohort to the fixture with at least eight trips whose windows reach a known hour, and assert the POSITIVE branch alongside the null one: `fillCurveEvidenceTo(paperFillCurve(bigCohort)) === <that hour>`. Keep the null case â€” the two together are what make the assertion able to fail in both directions. Do not raise or lower FILL_CURVE_MIN_AT_RISK to reach the branch; per the eighth face's ruling, decide which layer owns the promise and give the guard real work rather than moving the bar to the fixture.

### `probe:6959` — face9 — could-pass: **yes** — confidence: high

**Label:** [R62.3] every cell renders its own population beside the percentage, and cohorts are never pooled
**Requirement:** R62.3

**Evidence.** The subject is `const ch = paperFillCurveHTML()` (probe 6674) â€” the whole section, which at index.html:9001-9002 also appends paperCreditAbsorptionLine and paperCadenceRead, so the container is wider still. All four matched strings live OUTSIDE the cells: `/fill% \/ trips at risk/` is the legend at index.html:8998; `/No hour yet has 8 trips at risk/` is the header copy at index.html:8976; `/never pooled into one curve/` is the legend at index.html:8998-8999. The per-cell population the label is about is at index.html:8985: `Math.round(c.pct * 100) + '%<span class="dim">/' + c.atRisk + '</span>'`. The one structural check, `/data-drill="paper:curve:watchlist:6"/`, tests only that a drill key exists â€” the key is drill()'s first argument (index.html:8984) and is unaffected by the cell's face text.

**Could it pass with the property absent?** Delete `'<span class="dim">/' + c.atRisk + '</span>'` from index.html:8985 and every cell renders a bare percentage with no population â€” the exact defect named in the label â€” while all four regexes continue to match the legend, the header and the drill key. The pooling half is equally unprotected: the copy string 'never pooled into one curve' survives any change to the one-row-per-cohort structure at index.html:8996.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Use the blendFrag pattern the ninth face's repair established (probe 19-28): locate the `[data-drill="paper:curve:watchlist:6"]` element and assert its OWN text carries the population â€” e.g. that it matches `/%\s*\/\s*4$/` against the production-computed `at(6).atRisk`, not against a literal. For the pooling half, assert structurally: count `<tr>` rows in `#paperCurveTable` and hold it equal to the number of distinct paperCohortOf values in the fixture, so collapsing two cohorts into one curve goes red.

### `probe:7300` — face2 — could-pass: **yes** — confidence: high

**Label:** [R65.2] concentration is measured against GROSS movement, so a negative net cannot fake a proportion
**Requirement:** R65.2

**Evidence.** The condition is a RANGE check, not a value check: `!!cl && cl.top1 > 0 && cl.top1 <= 1 && cl.top2 >= cl.top1 && cl.top2 <= 1` (probe 7007). Production computes the shares against gross at index.html:9404-9410: `const gross = nets.reduce((s, v) => s + Math.abs(v), 0); ... top1: gross > 0 ? Math.abs(nets[0] || 0) / gross : null`. The fixture's separating trips (probe 6990-6993) are -1437762, -777735, -411180, +39412: gross 2,666,089 and sepNet -2,587,265 â€” both negative-dominated with the top contributor also negative. Under the seeded defect the rule exists to catch (a signed-net denominator), top1 = -1437762 / -2587265 = +0.556 and top2 = (-1437762 + -777735) / -2587265 = +0.856. Both land in (0, 1] and top2 >= top1, so every conjunct still holds. This is the case law's own worked example â€” 'a share of a negative net is not a proportion' â€” and the fixture is built so it cannot express itself.

**Could it pass with the property absent?** I computed both readings from the fixture's own numbers against index.html:9409-9410. The gross reading is 0.539/0.831 and the signed-net reading is 0.556/0.856; the assertion's bounds admit both. It would also admit an unsigned-net reading. Only a fixture whose separating net is positive-mixed (or whose top contributor has the opposite sign to the net) makes the two denominators diverge outside (0, 1].

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Two changes, both needed. (1) Assert the VALUE against production's own gross, not a range: `Math.abs(cl.top1 - 1437762 / 2666089) < 1e-9`. (2) Add a discriminating fixture case â€” a separator set whose signed net is small or positive while its gross is large (e.g. -1,400,000 and +1,450,000 and +39,412) so a net denominator yields |top1| > 1 or a negative share and the range check fails outright. Per the tenth face, the seed must discriminate: the gross form passes, the net form fails.

### `probe:7317` — face7 — could-pass: **yes** — confidence: high

**Label:** [R65.2] rows are ordered by absolute net, so the trip carrying the difference is first
**Requirement:** R65.2

**Evidence.** The condition is an IIFE that does its OWN sort and never reads the production ordering: `const seq = cl.only.slice().sort((x, y) => Math.abs(y.net || 0) - Math.abs(x.net || 0)).map(p => p.net); return seq[0] === -1437762 && seq[seq.length - 1] === 39412 && seq.every((v, i) => i === 0 || Math.abs(seq[i - 1]) >= Math.abs(v));` (probe 7024-7027). `regimeSepRows()` appears ONLY in the `extra` argument at 7028, which is the failure message and is never evaluated as part of the condition. Production does the ordering at index.html:9420 â€” `function regimeSepRows(trips){ return trips.slice().sort((x, y) => Math.abs(y.net || 0) - Math.abs(x.net || 0)).map(p => ({...}))` â€” and that sort is exactly the term the probe duplicates. The last conjunct is additionally tautological: `seq.every(...)` asks whether a just-sorted array is sorted. This is the tell the seventh face names verbatim â€” a probe line that COMPUTES rather than CALLS.

**Could it pass with the property absent?** Delete `.sort((x, y) => Math.abs(y.net || 0) - Math.abs(x.net || 0))` from index.html:9420 and this assertion is unchanged: cl.only comes from regimeSeparators (index.html:9401, an unordered filter), the probe re-sorts it locally, and the two endpoint checks and the sortedness check all hold. The seed lands on code the assertion never touches, which is the seventh face's founding shape.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Point the condition at the production output instead of a local sort: `const rows = regimeSepRows(cl.only); return rows.length === 4 && rows[0].net === gp(Math.round(-1437762)) ...` â€” or, to avoid depending on gp()'s formatting, have regimeSepRows carry the raw `_net` sort key it already sorts on and assert `regimeSepRows(cl.only).map(r => r._net)` is non-increasing in absolute value with -1437762 first and 39412 last. Keep the probe's own sort out of the condition entirely. Per the seventh face, do not reproduce the comparator in the probe.

### `probe:7402` — face9 — could-pass: **yes** — confidence: high

**Label:** [R66.2] the panel names the falsification test rather than only its inputs
**Requirement:** R66.2

**Evidence.** The subject is `const html = sellDiscriminatorHTML(null)` (probe 7107) and the condition is `/falsification test/i.test(html)` â€” the whole panel. The phrase is emitted UNCONDITIONALLY at index.html:8655, in the dim span that follows every verdict branch: `' <span class="dim">The live book is the falsification test: its sell leg accrues forward...'`. The FALSIFIED verdict branch the assertion's own comment names (probe 7104: 'a falsified prediction reads as a result. Driven through the real verdict builder by seeding the two populations' splits') lives at index.html:8638-8646 and is reached only when calS/liveS disagree. Compounding it: the claimed seeding does not happen. `const keepBk = DB.shadowBook, keepCal = DB.calib;` is saved at probe 7106 and restored at 7124, and NOTHING is assigned to either between those lines â€” so the two populations are whatever the previous section left, and the verdict branch actually taken is unknown to the assertion.

**Could it pass with the property absent?** Delete the entire FALSIFIED branch at index.html:8638-8646 and the assertion still passes off index.html:8655. I read both sites to confirm the unconditional emission. The narrow reading â€” that the property is only 'the string appears somewhere on the panel' â€” is satisfied by boilerplate rather than by the verdict, which is precisely the ninth face's 'ran, on real production output, and would have passed with the property gone'.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Two parts. (1) Actually build the fixture the comment claims: seed DB.shadowBook and DB.calib so calS and liveS disagree, driving index.html:8638. (2) Narrow the container to the verdict element â€” extract the verdict string from sellDiscriminatorHTML into a named term (e.g. `sellVerdictOf(calS, liveS)`) and assert against that term, not against the assembled panel, so the always-emitted dim span at 8655 cannot satisfy it. Then assert the falsified wording specifically: `/prediction is FALSIFIED/` plus the counts it names.

### `probe:2528` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R59.7] the tick writes the PRE-CLAMP term into the trace â€” 60x what the trip could take
**Requirement:** R59.7

**Evidence.** The fixture's crediting bucket has avgLowPrice 3900 against a bid of 4001 (probe 2354, 2334), so `beyond` is true at index.html:6568. On the beyond branch reachCredit returns `oper: tape` and `lenient: tape` â€” the same number (index.html:6580-6584) â€” and the participation haircut `Math.max(1, Math.floor(tape * shadowPart()))` on the ambiguous branch is never evaluated. The trace records both: `credited: cr.oper || 0, full: cr.lenient || 0` (index.html:6677). The probe also computes the expectation as `Math.floor(4000 * GATE.capture)`, reproducing production's `tape` expression rather than calling it.

**Could it pass with the property absent?** For the label's headline property (pre-clamp, not post-clamp) the answer is no â€” writing the clamped 10 would fail. But for the property the field name carries, yes: swap `credited: cr.oper` to `credited: cr.lenient` at index.html:6677 and this fixture cannot tell, because oper === lenient === tape on the beyond branch. The participation haircut â€” a named clamp in this product â€” is never on the path this assertion exercises, so no defect in shadowPart() or in the ambiguous branch is visible here.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a second crediting bucket in the AMBIGUOUS class â€” bucket average on the wrong side of the bid with a live instabuy touch (L.low <= p.bid), i.e. `beyond` false, `at` true â€” so oper and lenient diverge by shadowPart(), then assert the trace's `credited` follows the operative reading and `full` the lenient one. Separately, replace the probe-side `Math.floor(4000 * GATE.capture)` with a call that reads the trace's own recorded inputs back through production: `credited === reachCredit(b.lo, p.bid, b.lv, "buy", b.tch).oper`.

### `probe:2543` — face8 — could-pass: **yes** — confidence: medium

**Label:** [R43.2] the bucket that completed the buy cannot also fill the sell â€” no instant round trip
**Requirement:** R43.2

**Evidence.** Probe 2382-2385 asserts `sb2.state === "open" && sb2.sellQ === 0` with NO shadowTick() between line 2382 and the assertion â€” line 2382 only mutates S.latest[9002].high, so the state asserted is exactly the state left by the roll at line 2358. In production (index.html:6659-6693) the buy and sell credits are an if / else-if pair keyed on `!p.buyDone`, and `p.buyDone` is not assigned until index.html:6712, AFTER the credit block. So on the tick that completes the buy, the sell branch is structurally unreachable regardless of the guard the label names: `q.bkt !== p.buyDoneBkt` (index.html:6679). The fixture never presents a bucket that is a live sell-credit candidate and equal to p.buyDoneBkt.

**Could it pass with the property absent?** Delete `q.bkt !== p.buyDoneBkt` from index.html:6679 and this assertion stays green: at the crediting tick the else-if is not entered at all (p.buyDone is still 0), and no later tick runs before the assertion. The property is being delivered by the if/else-if ordering, not by the named guard, and the assertion cannot distinguish the two. I could not determine a production call path that makes q.bkt === p.buyDoneBkt at all â€” the only candidate I found is a trip restored from storage with buyQ >= qty and buyDone unset, so that `p.buyDoneBkt = p.buyBkt || bkt` lands on the currently-pending bucket. That is a scan-13 question and I did not resolve it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the sell-credit eligibility predicate â€” e.g. `sellBucketEligible(p, q)` carrying the whole `p.buyDone && q.bkt >= p.buyDone && q.bkt !== p.buyDoneBkt && p.sellBkt !== q.bkt` conjunction â€” and point the assertion at it, asserting it returns false for `q.bkt === p.buyDoneBkt` and true for the next bucket. Per the eighth face's Aug 13 addendum, run scan 13 first: if no production caller can produce q.bkt === p.buyDoneBkt, the guard is decoration and the assertion currently holding its neighbourhood must move before anything is deleted.

### `probe:2575` — face11 — could-pass: **yes** — confidence: medium

**Label:** [R18.3] regime curves labeled simulated, never comparable to realized
**Requirement:** R18.3

**Evidence.** `/all three SIMULATED/.test(paperRegimeSection()) && /never compare to realized/.test(paperRegimeSection())` â€” two required phrases, no forbidden one. Both live in a single sentence at index.html:9489, and the container matched is the whole section return value. This is a copy-honesty assertion of exactly the class the eleventh face was written about (the R62.6 note whose FIRST half was rewritten to claim the opposite while the asserted phrase in the second half stood).

**Could it pass with the property absent?** A comparable-to-realized claim added anywhere else in paperRegimeSection() â€” a 'vs your realized net' line under the curves, say â€” leaves both required phrases intact and the assertion green while the section asserts the opposite of the rule it is policing. I checked and no contradicting copy exists in that section today, so this is a missing negative match rather than a live contradiction; the finding is that the assertion could not tell.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the absence half: forbid a realized-comparison claim in the same section, e.g. `!/(vs|against|compare[ds]? to|beside)[^.]{0,40}realized/i.test(paperRegimeSection())`. Per the tenth face the seed must discriminate â€” the old form passes it, the new form fails it â€” so the seed is 'add a comparable-to-realized sentence', not 'delete the SIMULATED label'.

### `probe:3701` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R18.5] a print EXACTLY AT the bid is ambiguous â€” haircut on the operative leg, nothing on the strict one, full on the lenient
**Requirement:** R18.5

**Evidence.** Probe 3463-3464 computes the expected credit itself: `const tape27 = Math.max(1, Math.floor(40 * GATE.capture));` and `const cons27 = Math.max(1, Math.floor(tape27 * 0.5));`. These reproduce production verbatim â€” index.html:6580 `const tape = Math.max(1, Math.floor(v * GATE.capture));` and index.html:6583 `oper: beyond ? tape : Math.max(1, Math.floor(tape * shadowPart()))` â€” with shadowPart() hardcoded as 0.5. The production term lives in the named, reachable function reachCredit(px, mine, vol, side, touched) (index.html, function head immediately above 6580), which the probe never calls. Line 3470 ([R18.5] print below the bid) carries the same re-derivation via tape27.

**Could it pass with the property absent?** Scoped answer, stated precisely because the two halves differ. The haircut's EXISTENCE is protected â€” probe 3481's ordering clause (buyQFull > buyQ > buyQStrict) goes red if the haircut is deleted, since GATE.capture = 0.15 gives tape=6 and oper=3 at v=40. The haircut's SIZE is not: (a) GATE.capture is read from production by the probe, so moving 0.15 to 0.30 moves expectation and subject together and nothing goes red; (b) refactoring index.html:6583 from Math.floor(tape * part) to Math.floor(v * capture * part) â€” a plausible refactor with genuinely different rounding â€” yields 3 under both forms at this fixture's numbers, so the probe cannot tell the two apart. The seventh face's fix pattern (extract, then point the assertion at the extraction) applies exactly, and the extraction already exists.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Point the assertions at reachCredit() directly â€” it is a real production function shadowTick calls with these shapes, so this is not a manufactured call path â€” and assert the RELATIONSHIP rather than a re-derived number: oper === Math.max(1, Math.floor(lenient * shadowPart())) computed from the SAME call's return, plus a scaling check (double the bucket volume, credit doubles until the qty clamp at index.html:6590-6592 binds). Choose fixture volumes that keep the credit clear of both the Math.max(1,â€¦) floor and the Math.min(q,â€¦) ceiling, and say so in a comment so the next clamp-absorption scan does not have to re-derive it.

### `probe:4928` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R40.5] each row names its FILL MODEL and stamps the evidence grade behind it
**Requirement:** R40.5

**Evidence.** The label states a PER-ROW property ("each row") and the condition matches three patterns against pgs40, the entire paperGateSection() string: /fill model v1<\/span>/, /fill model v2<\/span>/ and /1 live, 1 reconstructed|1 reconstructed, 1 live/. Production emits both the model badge (index.html:9562, todBadge(s.shape)) and the grade note (index.html:9563, evidenceNote(s.arr)) inside each row's first <td>. Nothing ties a match to the row it belongs to: a section where row A carried both model badges and row B carried none satisfies every pattern. This is the [R49.2] shape the ninth face was written about, and the fix the project already built for it â€” blendFrag(html, key), probe lines 19-28 â€” narrows exactly this kind of match and is not used here. The fixture also contains no decoy (only one row can produce the grade phrase), so per the tenth face the scoping is unproven either way.

**Could it pass with the property absent?** Read paperGateSection at index.html:9538-9605 to locate where the badge and grade are emitted, and confirmed both are per-row. I could not determine without running the suite whether any section-level element also emits a grade string; evidenceNote() is called only at 9563 in that function, which is per-row, so I believe the current fixture does discriminate â€” the finding is about the container, not about a present failure.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Locate each row by its own gate key (the same pattern as blendFrag: find the element whose data-drill starts with "paper:gate:<gate> Â· fill model v2:" and take its containing <tr>) and match the model badge and grade note inside that fragment only. Then, per the tenth face, rebuild the fixture with a SECOND v2-shaped row carrying an identical grade mix as the decoy, and add a standing assertion holding the fixture to it so the scoping cannot quietly become untestable.

### `probe:5782` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R57.2] the capacity ceiling is computed from families, horizon and cooldown â€” and names its BINDING constraint
**Requirement:** R57.2

**Evidence.** Two things. (a) The label's second clause â€” 'names its BINDING constraint' â€” has no corresponding conjunct: the assertion reads watchFams, cycleH, perFamPerDay, watchCeil, byCap, sliceCeil and scanCeil, and never touches c.binding. (b) The probe's own comment at 5565-5571 describes this fixture as the families-bound case ('2 families â€¦ â†’ 4.4/day by families; the 40-trip cap would allow 160/day'), but by the same arithmetic as finding 2 above, wanted = 4.4 + 7200 + 2304 = 9508.4 > byCap = 160, so this fixture is ALSO the concurrency-bound case. Both [R57.2] assertions land on the same branch and the comment misdescribes the state under test.

**Could it pass with the property absent?** For (a): delete the `binding` key from paperCapacity's return entirely and this assertion is unaffected; the neighbouring 5577 would catch it, but only for the one reachable branch. For (b): the fixture cannot demonstrate that the ceiling is 'computed from families' in the sense the label means, because the ceiling is Math.min(wanted, byCap) and byCap pins it regardless of the family term. The per-cohort conjuncts (watchCeil 4.4, perFamPerDay 2.18) are real and do test the family arithmetic â€” that half of the assertion is sound; it is the ceiling/binding half that the fixture cannot express.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Correct the probe comment so it does not assert a state the constants forbid â€” a comment claiming the families-bound case where the concurrency cap binds is what let finding 2 sit green. Then either add a `binding` conjunct here (which today can only be the concurrency string) or strike 'and names its BINDING constraint' from the label so the name matches the subject. The durable fix is whatever the user rules on the dead branch in finding 2.

### `probe:5908` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R43.3] and it renders â€” a 100% reading must be visibly a claim about zero counterexamples
**Requirement:** R43.3

**Evidence.** Two problems in one line. (a) The fixture is 2 filled + 1 unfilled in one hour (probe 5681), so the reading is 67% â€” the 100%/zero-counterexample case the label names is never rendered. The defect the case law describes ('fill rate 100%' with neverFilled 0 on every rollup) would return the moment the count were made conditional on unfilled > 0, and this assertion would not see it. (b) The match `/never filled/` is against the ENTIRE hoursLedgerInline() output, which contains that phrase from two independent renderers: the top-3 widest-hours summary (index.html:9793) and the per-hour table cell (index.html:9821). Deleting it from either one leaves the other satisfying the match.

**Could it pass with the property absent?** For (a): change index.html:9793/9821 to `r.unfilled ? (r.unfilled + ' never filled') : ''` and the fixture's row still has unfilled === 1, so the phrase renders and the assertion passes while every 100% row loses its counterexample count â€” the exact defect. For (b): delete the count from the table cell at 9821 and the summary at 9793 still satisfies the whole-output match. Read both renderers; not executed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Add a third fixture hour whose trips are all filled, and assert that hour's cell renders '0 never filled' â€” that is the 100% case the label claims. Scope the match to the row under test rather than the whole inline, in the blendFrag idiom already in the probe (probe 19-28): locate the hour's own element and match inside its fragment only.

### `probe:6052` — CLAMP — could-pass: **yes** — confidence: medium

**Label:** [R18.2] the bracket ordering survives at a scale where the clamp is binding
**Requirement:** R18.2

**Evidence.** The subject is p.buyQFull >= p.buyQ >= p.buyQStrict read after shadowCredit on a fresh {qty:10} with terms strict 0 / oper ~7500 / lenient 15000. shadowCredit (index.html:6590-6592) writes buyQ = Math.min(q, oper) = 10, buyQStrict = Math.min(q, 0) = 0, and buyQFull = Math.min(q, (p.buyQFull != null ? p.buyQFull : p.buyQ) + lenient) â€” where the fallback base is the ALREADY-CLAMPED p.buyQ, assigned two lines earlier. So buyQFull = Math.min(10, 10 + lenient) = 10 = buyQ for any lenient >= 0, and buyQ >= buyQStrict follows from Math.min being monotone in its second argument plus oper >= strict. The ordering is arithmetically unavoidable at this scale regardless of what reachCredit returns.

**Could it pass with the property absent?** Swap `oper` and `lenient` in reachCredit's return (index.html:6581-6584) so the bracket is inverted, and this assertion still reads 10 >= 10 >= 0. The pre-clamp ordering is genuinely tested at probe 5765, but only at v=100; at the clamp-binding scale this line names, it adds nothing. Determined by reading shadowCredit's three assignments and their evaluation order; not executed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. reachCredit is already the named pre-clamp term, so point the assertion at it: assert lenient >= oper >= strict on reachCredit(4000, 4000, VBIG, 'buy') â€” i.e. extend the existing 5765 bracket check to the large-volume case â€” and either drop this post-clamp line or restate its label as what it actually tests (that shadowCredit's fallback base does not invert the bracket), which is a narrower and honest claim.

### `probe:6090` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R44.3] the headline is a RATE â€” net per gp-day of simulated notional, not a total
**Requirement:** R44.3

**Evidence.** The numeric conjunct is `Math.abs(eco.rate - eco.net / eco.gpDays) < 1e-12`, which re-derives production's own definition (index.html:7744, `rate: gpDays > 0 ? net / gpDays : null`) from the same returned object's own fields. It is an identity that holds by construction. The denominator itself â€” gpDays = Î£ tripNotional(p) * tripDays(p) (index.html:7717) â€” is never pinned to a value: a grep of the whole probe file for gpDays|tripDays|tripNotional returns only lines 5869 and 5871, and 5871 is the failure-message payload, not a condition. The remaining conjunct `/per gp-day of simulated notional/` matches a static string in paperRateFace (index.html:7772-7773) and says nothing about how the denominator is computed.

**Could it pass with the property absent?** Make tripDays return 1 for every trip (dropping hold duration), or make tripNotional read the ask instead of the bid: rate changes, the identity rate === net/gpDays still holds exactly, the copy string is untouched, and the assertion stays green. The label's property â€” that the headline is per gp-DAY of notional â€” is asserted only by a sentence. The probe-wide grep is complete for this file (the suite is one file), so I am confident nothing else pins it; I mark medium rather than high only because a rendered percentage elsewhere could in principle pin it indirectly, and I did not read every rendered figure.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Assert a scaling property no re-derivation encodes: with the same nets, doubling every trip's hold duration must halve eco.rate, and doubling every trip's qty must halve it too. That holds production to a behaviour instead of to my arithmetic. If a point value is also wanted, the current fixture's gpDays is computable by hand (4 trips x 100 x 1000 notional x 1h = 4 x 100000/24 â‰ˆ 16666.7) â€” but the scaling form is the one the case law prescribes.

### `probe:6127` — face11 — could-pass: **yes** — confidence: medium

**Label:** [R44.4] the raw summed net survives ONLY in the regime comparison, labelled comparison-only
**Requirement:** R44.4

**Evidence.** Three presence-only regex checks against paperRegimeSection(): /Comparison only, not a magnitude/, /only the DIFFERENCE between these sums carries information/, /the level cancels out/. Nothing forbids a contradicting magnitude claim inside the same section, and â€” the load-bearing half â€” nothing at all asserts the word ONLY in the label: no absence assertion anywhere checks that a raw summed net does not render outside the regime comparison. The probe's own comment at 5906-5909 anticipates a stranding failure ('a caveat whose tap does not reach its full text') but the check written for it is still presence-only.

**Could it pass with the property absent?** Add a summed-net magnitude to the paper headline or the econ drill and every conjunct still passes, because all three read paperRegimeSection() and none reads any other surface. Equally, prepend a sentence to the regime section reading 'the summed net is X' and the three caveats survive untouched â€” the eleventh face exactly, and the project's own ruling that scoping rules are only verified by asserting where a thing must NOT appear.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Add the absence half: assert the summed-net figure does not appear in paperHeadlineSection() or in drillBoxHTML('paper:econ'), which is where the ONLY claim would break. Add a negative match forbidding a magnitude reading inside the regime section itself. Per the tenth face, whatever seed is used to prove it must fail the new form and pass the old one; a seed that fails both means the fixture cannot tell them apart.

### `probe:6704` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R60.2] the stall line's STATE renders always; only its rationale is gated on the stall
**Requirement:** R60.2

**Evidence.** The fixture sets `DB.shadowBook = []` and names the result `healthy`. In production `shadowScanState` computes `lastOpen = DB.shadowBook.reduce((a, p) => Math.max(a, p.t || 0), 0)` (index.html:6159), which is 0 on an empty book; `shadowScanStateLine` then computes `quiet = s.lastOpen ? Date.now() - s.lastOpen : null` and `stale = quiet != null && quiet > 2 * 3600e3` (index.html:6174-6175). So `stale` is false BY CONSTRUCTION on this fixture and the negative conjunct `!/A book that is not opening accrues nothing/` cannot fail. The gating property the label names â€” that the rationale DOES appear in the stall state â€” is never exercised anywhere in the slice.

**Could it pass with the property absent?** Delete the `stale ?` guard at index.html:6185 so the rationale renders unconditionally and this assertion goes red; but delete the rationale entirely, or make the stall branch unreachable, and it stays green. Only one direction of the gate is covered, and it is the direction the fixture forces.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a second reading with a book whose newest `t` is more than 2h old, asserting the rationale text and the âš  prefix DO appear there while 'Paper book: ' still renders â€” the state-always half and the rationale-gated half then discriminate against each other.

### `probe:7461` — face3 — could-pass: **yes** — confidence: medium

**Label:** [R67.1] the pair is never averaged into a point estimate â€” both bounds are carried
**Requirement:** R67.1

**Evidence.** The condition is `b.provenVol < b.possibleVol && b.totalVol === 1125` â€” two presence/inequality checks. The label's property is an ABSENCE: that no point estimate is emitted. Production honours it (index.html:8289-8301 returns provenVol and possibleVol as separate fields and computes no midpoint; index.html:8302-8304's comment states the rule: 'never averaged into a point estimate â€” a midpoint would be the share function wearing a different hat'), and index.html:8320-8325 renders both bounds. But nothing in the assertion forbids a midpoint being added. This is the absence half of the scoping ruling applied to a returned object rather than to a DOM surface.

**Could it pass with the property absent?** Add a `midpoint: (out.provenVol + out.possibleVol) / 2` field to the return at index.html:8291-8292, or a midpoint figure to sellBoundsHTML at index.html:8321-8328, and this assertion is unmoved: proven is still less than possible and totalVol is still 1125. I could not determine whether any OTHER assertion in the file forbids it â€” I did not search outside my slice, and I am not reporting an absence I did not verify.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the negative half, per the eleventh face: assert that the returned object carries no averaged field (`!('midpoint' in b) && !('estimate' in b) && !('pointEstimate' in b)`) and that sellBoundsHTML's output carries no midpoint copy (`!/midpoint|point estimate|on average .* reach/i.test(html)`). The existing positive checks stay â€” the pair of them is what discriminates.

### `probe:6838` — face11 — could-pass: **yes** — confidence: low

**Label:** [R59.4] both populations render SEPARATELY with their own n â€” never pooled
**Requirement:** R59.4

**Evidence.** Four positive regexes against the whole of `sellDiscriminatorHTML(DB.calib)`: both population headings and both `data-drill` keys present, plus a no-window note. Nothing forbids a pooled figure. Adding a combined 'across both populations: 12 dilution / 4 mislocated' line beside them would leave all four conjuncts satisfied, and pooling is the property the label names. Minor: the alternation `/has NO window to place|no window to place/` is redundant â€” the second alternative is a substring of the first, so it can never be the deciding branch.

**Could it pass with the property absent?** 'Never pooled' is an absence property and this assertion contains no absence check. The pooling scan's own rule â€” a pooled figure may render only alongside its decomposition â€” has no mechanical expression here.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a negative match forbidding a combined count outside the two population containers: locate each `data-drill` element's container and assert every rendered split count lives inside one of them, so a third pooled row fails.

### `probe:4963` — face8 — could-pass: **unknown** — confidence: medium

**Label:** [R40.7] coverage stops when the trip closes â€” later buckets are not its life
**Requirement:** R40.7

**Evidence.** The label's property is enforced in production by two mechanisms and the assertion exercises only one. The live one is the per-path `break` after each state change (index.html:6467, 6469, 6481, 6490) â€” that is what produces covered40 === 10*60e3 here. The second is `if (p.state !== "open") break;` at index.html:6438, which I believe is UNREACHABLE: the only production caller shadowRecover iterates `shadowOpen()` (index.html:6501, 6517), so p.state is "open" on entry; every in-loop state mutation is followed immediately by break; and shadowFinishReadings (index.html:6603-6606) sets only strictFilled/lenientFilled, never state. It also sits AFTER `covered += M5_MS` on line 6437, so if it ever did fire it would credit five minutes to an already-closed trip â€” the opposite of the label. No assertion in this slice reaches it (all four reconReplay calls at 4729, 4763, 4768, 4773 pass state:"open").

**Could it pass with the property absent?** Traced the single production call path and every state mutation inside reconReplay. What I could NOT determine: whether some caller outside index.html:6498-6543, or in one of the eleven slices I was not given, passes a non-open trip to reconReplay. That is why this is 'unknown' rather than 'yes' â€” and per the twelfth face's standing consequence, an assertion elsewhere may be holding this guard alive, which must be checked before anyone deletes it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Run scan 13 (reachable-fixture) across the whole suite for reconReplay call sites BEFORE touching index.html:6438 â€” if an assertion is reaching it, that assertion moves to the layer production calls first. If nothing holds it alive, the dead-safeguard ruling's choice applies: either delete it and let shadowRecover's shadowOpen() filter own the promise (stated at the call site, the way reconWindowStart already states the causality promise), or move the credit line below the guard so the promise is enforceable where it is written.

### `probe:7181` — face12 — could-pass: **unknown** — confidence: low

**Label:** [R64.5] the replay window never starts before the trip existed, even with lastObs behind t  /  the floor holds for every lastObs a record could carry
**Requirement:** R64.5

**Evidence.** Both assertions (probe 6897-6903 and 6917-6919) call `reconWindowStart({ t: 5000, lastObs: 1000 })` and `reconWindowStart({ t: 5000 })` â€” a record whose lastObs precedes t, and a record with no lastObs at all. The probe's own SCAN 13 NOTE at 6904-6916 states plainly that neither is producible: 'Both open paths stamp `lastObs: now` at `t` and only ever advance it, so `lastObs < t` is not producible today.' That is scan 13's finding condition â€” an assertion reaching its subject by a call path no production caller can produce. I am reporting it because the enumeration IS the deliverable and a listed-and-dispositioned item must not read the same as one nobody traced.

**Could it pass with the property absent?** The reachable half of the input space IS exercised â€” `reconWindowStart({ t: 5000, lastObs: 9000 }) === 9000` at probe 6899 is the shape production produces, and it would fail if the floor were replaced by something that ignored lastObs. So the assertion is not dead. What I cannot determine without running the suite is whether the unreachable-input conjuncts are load-bearing for any seed, i.e. whether the reachable conjunct alone would catch every defect in reconWindowStart. I did not read reconWindowStart's body and I am not guessing at it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN â€” and the note at probe 6904-6916 may already be the correct disposition. Scan 13 offers two remedies and the note takes neither cleanly: it does not name a production caller (there is none) and it does not move the assertion. The honest options are (a) leave it exactly as is, treating the note as the standing disposition and this entry as the scan's record that it was traced, or (b) if reconWindowStart's `lastObs >= t` precondition is meant to be owned upstream, assert that upstream guarantee instead â€” the eighth face's 'decide which layer owns the promise' â€” and keep the adversarial sweep as documentation. This is the user's ruling, not mine.

### `probe:4991` — face12 — could-pass: **no** — confidence: low

**Label:** [R40.7] observation credit is SERIES COVERAGE â€” every bucket with data, for a trip still open
**Requirement:** R40.7

**Evidence.** openTrip40 (probe 4766-4767) is built with `hzH: 100` and `ask: 9e9`. Neither shape is producible by the product: hzH is stamped from planHorizonH(), which is gapHoursAt(), which returns `Math.min(24, (n.at - ts)/3600e3)` (index.html:2906) â€” so no production trip can carry a horizon above 24; and an ask of 9e9 exceeds any real item price. The devices exist to keep the trip open for all 24 buckets, and a side effect is that the horizon forced-exit branches (index.html:6462, 6483, both `bt - â€¦ > H` where H = legHorizonH(p)*3600e3) cannot fire during the replay. So the coverage figure is measured in a state the product cannot reach.

**Could it pass with the property absent?** Traced hzH's provenance to gapHoursAt's Math.min(24, â€¦) at index.html:2906. I am reporting this at LOW confidence and answering 'no' to the one question deliberately: the property under test â€” one M5_MS credit per in-window bucket for an open trip â€” does not depend on the horizon being out of range, and a realistic hzH (9.5) over a 2h series would produce the same 24 buckets. The finding is that the fixture reaches its subject through an impossible state, not that the number is wrong.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Use a horizon the schedule can actually produce (hzH: 9.5, which comfortably exceeds the fixture's 2h series) and an ask the item's own price band can produce but the tape never reaches, so the trip stays open for a reachable reason. Per scan 13's remedy pair, if some caller genuinely can produce hzH > 24, name that caller in a comment instead so the next scan does not re-raise this.

### `probe:5976` — face7 — could-pass: **no** — confidence: low

**Label:** [R44.1] a print EXACTLY AT my bid is ambiguous â€” haircut operative, zero strict, full lenient
**Requirement:** R44.1

**Evidence.** The expected value is built probe-side as `Math.max(1, Math.floor(capT(100) * shadowPart()))`, where capT is itself the probe's copy of production's capture cap (probe 5746 vs index.html:6580) and the outer expression copies reachCredit's operative term verbatim (index.html:6583). The same re-derivation recurs at probe 5928 for [R45.1]. The probe's own comment at 5793-5797 names this tell for the [R18.2] block and answers it with a linear-scaling assertion at 5798 â€” but 5798 asserts scaling of `strict` only; the operative/haircut term has no scaling companion anywhere in the slice. Secondary: both re-derived Math.max(1, â€¦) floors would silently agree with production if either ever became binding; at the shipped defaults (GATE.capture 0.15, DB.shadowPartPct 50 â†’ shadowPart() 0.5, index.html:1253/5684) neither binds at v=100 (15 â†’ 7), so no clamp is absorbing anything today.

**Could it pass with the property absent?** This one does discriminate: change reachCredit's haircut and the probe's fixed expression no longer matches, so the assertion goes red. I answer 'no' honestly rather than inflating it. The residual defect is the one the seventh face names â€” it holds production to the probe's arithmetic rather than to a behaviour, and it would follow production silently into a regime where the Math.max(1, â€¦) floor pins the result (shadowPartPct at its 10 minimum gives floor(15*0.1) = 1 = the floor, at which point any haircut defect is absorbed). Low confidence that this warrants action.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Mirror 5798 for the operative term: assert that doubling the tape volume doubles reachCredit(4000, 4000, v, 'buy').oper at a scale well above the floor â€” a property no parallel implementation encodes â€” and keep the point equality only as a secondary check. Optionally assert separately that the Math.max(1, â€¦) floor is not binding in the fixture, so the assertion cannot quietly move into the regime where the clamp answers.

### `probe:6889` — face7 — could-pass: **no** — confidence: low

**Label:** [R62.1] a paper trip's SIZE does not move with the schedule either â€” the half-fixed case
**Requirement:** R62.1

**Evidence.** The first conjunct reproduces the production body character-for-character: the probe computes `Math.max(1, Math.floor(volGateFor(c61).v * GATE.capture * PAPER_HORIZON_H))` and production is `const shadowHorizonUnits = c => Math.max(1, Math.floor(volGateFor(c).v * GATE.capture * PAPER_HORIZON_H))` (index.html:5860). That is the seventh face's tell â€” a probe line that computes rather than calls â€” even though the extraction it sits on was the correct fix for the clamp-absorption case. The sound part of this assertion is the schedule-invariance conjunct at lines 6607-6610 (`a === b` across two cadences), which asserts a property rather than re-deriving a value; the third conjunct re-implements again against `planHorizonH()`.

**Could it pass with the property absent?** Because the probe's copy of the expression names PAPER_HORIZON_H explicitly, a production revert to FILLH() makes the two differ and this goes red â€” so it is not dead. The finding is the shape, not a demonstrated false pass: an equality against a re-derived expression is the form the case law says to replace with a scaling property, and it will silently track any future change made to both copies at once.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Replace the equality with a scaling assertion â€” double `PAPER_HORIZON_H` in a controlled reading and assert the unit count scales with it while the schedule is held fixed, and vice versa â€” keeping the existing `a === b` invariance conjunct, which is already the right shape.

---

# TIER: GATES

### `probe:442` — face2 — could-pass: **yes** — confidence: high

**Label:** [R43.5] a recovery beyond one touch gap is NOT voided â€” it is a real episode
**Requirement:** [R43.5]

**Evidence.** Probe line 437 back-dates the episode (`DB.dieOffLog[0].t = Date.now() - 6*3600e3`) so the recovery lands beyond 'one touch gap', then line 442 asserts `!DB.dieOffLog[0].void`. Production, index.html:3029-3034, states the ruled property in its own comment â€” 'The gap is the one in force when the episode OPENED, per-episode, never the current one' â€” and implements it as `const gapMs = gapHoursAt(e.t) * 3600e3;`. But the probe's fixture sets `DB.touchWindows = []` at line 65, so `scheduleOn()` is false (index.html:2858) and `gapHoursAt(ts)` returns `Math.max(1, DB.fillHorizonH || 4)` = 4 for EVERY ts (index.html:2895). The function is constant in its argument. The per-episode-vs-current distinction â€” the entire point of the ruling and of the comment â€” cannot be expressed by this fixture. The assertion tests only `rec - t <= 4h`, and the label's 'one touch gap' names a schedule that is not configured.

**Could it pass with the property absent?** Seed `gapHoursAt(e.t)` -> `gapHoursAt(Date.now())` at index.html:3031 â€” the exact defect the production comment forbids â€” and nothing changes: both return the same constant 4 under an empty schedule. Both [R43.5] assertions stay green with the ruled property fully removed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Run the two [R43.5] assertions under a REAL schedule (set `DB.touchWindows` to two or more windows for this block, restoring `[]` afterwards) chosen so the gap in force at the episode's `t` differs from the gap in force now â€” then a seed swapping `e.t` for `Date.now()` flips the void decision. Do not pin the clock to achieve this (fifth face); pick the two instants from the fixture's own schedule so the property holds at every wall-clock hour, or extract `episodeVoidGapH(e) => gapHoursAt(e.t)` in production and assert directly that it varies with `e.t` while `gapHoursAt(Date.now())` does not.

### `probe:453` — face2 — could-pass: **yes** — confidence: high

**Label:** [R43.5] an episode recovering inside one touch gap is auto-voided as noise
**Requirement:** [R43.5]

**Evidence.** Same mechanism as the finding at line 442, on the positive side of the same rule. Probe line 449 pushes an episode with `t: Date.now() - 60e3`, line 451 recovers it, line 453 asserts `DB.dieOffLog[1].void === 1`. Production index.html:3031 compares `e.rec - e.t` against `gapHoursAt(e.t)*3600e3`, which is the constant 4h under the probe's empty schedule (index.html:2858, 2895). A 60-second-old episode is inside four hours by three orders of magnitude, so the assertion holds for any void window between ~1 minute and 24h and for any argument passed to gapHoursAt. Reported separately from line 442 because it is a distinct assertion, but a fix to the fixture repairs both.

**Could it pass with the property absent?** The property named is 'inside ONE TOUCH GAP'. With no schedule configured there is no touch gap; the comparison is against a fixed 4h fallback. Replacing `gapHoursAt(e.t)` with `gapHoursAt(Date.now())`, with a literal 4, or with any constant in the ~0.02h-to-24h range leaves this assertion green.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. As for line 442: exercise this pair under a configured `DB.touchWindows`, with the two episodes' open times chosen so their gaps differ, so the assertion distinguishes the per-episode gap from the current one and from a constant.

### `probe:630` — face2 — could-pass: **yes** — confidence: high

**Label:** [R51.1] observedDaysIn unions the day-stamp with the ledger's own dates and ignores days outside the window
**Requirement:** R51.1

**Evidence.** Fixture (probe-snippet.html:632): DB.obsDays = [dm84(0), dm84(20)]; DB.gateLog = [{d: dm84(3)}, {d: dm84(0)}]; expected result is 2. Production is index.html:5550-5555 `observedDaySet`, which loops DB.obsDays (5552) and then DB.gateLog (5553) into one Set, and index.html:5557-5559 `observedDaysIn` which calls it with a 7-day cutoff. dm84 is defined at probe-snippet.html:575 as n-days-ago. Working the fixture: the union restricted to the window is {dm84(0), dm84(3)} = 2. The gateLog loop ALONE also yields {dm84(3), dm84(0)} = 2. dm84(0) is present in BOTH inputs and dm84(20) is out of window, so the obsDays half contributes nothing the ledger half does not already contribute. Delete line 5552 entirely and this assertion still returns 2 and stays green. The obsDays half is the load-bearing one: index.html:4574-4579 states its whole purpose is to stamp days that produced no ledger rows at all ('a plan that benched nothing, funded nothing and qualified nothing writes no row at all, and that day was still observed'), which is precisely the case this fixture omits. Only the reverse deletion (dropping the gateLog loop) is detected, which would return 1.

**Could it pass with the property absent?** Determined by reading index.html:5550-5559 and hand-evaluating the fixture against both loops separately. Removing the DB.obsDays loop leaves the answer at 2 â€” the asserted value â€” so the 'unions the day-stamp' half of the label is untested. The 'ignores days outside the window' half IS tested (dm84(20) would make it 3).

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add an in-window day that exists ONLY in the day-stamp, so each input is independently load-bearing: DB.obsDays = [dm84(0), dm84(5), dm84(20)]; DB.gateLog = [{d: dm84(3)...}, {d: dm84(0)...}]; expect 3. Then deleting the obsDays loop yields 2 (red) and deleting the gateLog loop yields 2 (red), and only the union yields 3. Per the seeding precondition this is unproven until both deletions have been seeded one at a time and watched fail.

### `probe:2974` — face9 — could-pass: **yes** — confidence: high

**Label:** [R22.4] every watchlist row leads with an explicit plan-status badge
**Requirement:** R22.4

**Evidence.** Probe 2751-2753: `const rows22 = Array.from(document.querySelectorAll("#watchBody tr:not(.wdet)"))` then `rows22.every(r => r.querySelector(".tags .badge"))`. The subject named in the label is the PLAN-STATUS badge. Production renders `.tags` with five slot emitters (index.html:11033-11039): `'<span class="badge ' + status.cls + ...'` (the plan-status badge), then `identityBadge(w, c)`, `riskChip(...)`, `shadowDot(...)`, `testDot(...)`. `identityBadge` has no empty return path â€” it always emits `return '<button class="badge ' + ...` (index.html:10764, return at 10772), rendering "untiered" when tv.t === 0. So `.tags .badge` is satisfied by the tier badge on every row regardless of the plan-status badge. (Contrast `tierBadge` at index.html:3958, which DOES return "" at t===0 â€” but that is the scanner's emitter, not the watchlist's.)

**Could it pass with the property absent?** Delete the plan-status `<span class="badge">` from index.html:11034 entirely and every row still contains `identityBadge`'s `<button class="badge">` inside the same `.tags` div, so `r.querySelector('.tags .badge')` is still truthy on all three rows and the assertion stays green. This is the R49.2 shape at element granularity rather than page granularity.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Point the match at the plan-status slot specifically and at production's own vocabulary for it: production already exposes `planStatusInfo(id, P)` (index.html:10759, called at 11031), so assert per row that `r.querySelector('.tags > :first-child')` carries `planStatusInfo(w.id, P).label` as its text and `.why` as its title â€” which calls production rather than re-deriving the label. Proving it requires a fixture where a second `.badge` is present in `.tags` (the tier badge already is), so the seed 'delete the plan-status badge' discriminates: the old form passes, the new form fails.

### `probe:3006` — face9 — could-pass: **yes** — confidence: high

**Label:** [R22.6] every slice row carries a gate tag and a one-tap +watch
**Requirement:** R22.6

**Evidence.** Probe 2783-2786: `const bnRows226 = Array.from(document.querySelectorAll("#beyondNetBody tr"))` then `bnRows226.every(r => r.querySelector(".badge") && r.querySelector("[data-add]"))`. The subject is the GATE TAG. `renderBeyondNet` (index.html:2728) builds each row with an unconditional STRATUM badge â€” `'<td><span class="badge b-ok" title="Structural stratum this row was drawn from...">' + esc(sLab) + '</span></td>'` at index.html:2738-2739 â€” and only then the gate cell `'<td style="text-align:left">'+gateTag(c.id)+'</td>'` at index.html:2743. `.badge` matches the stratum badge first.

**Could it pass with the property absent?** Delete `gateTag(c.id)` from the row template at index.html:2743 and every row still carries the stratum `<span class="badge b-ok">`, so `r.querySelector('.badge')` is truthy and the assertion stays green on real production output. The gate-verdict honesty this row-level assertion exists to protect (the 'gates pending chart' path, which is a self-explaining-state surface) would be entirely unguarded here â€” the two sibling assertions at 2775 and 2777 test `gateTag()` as a function but nothing then checks it reaches the row.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Scope the match to the gate cell rather than the row: assert `r.children[2].querySelector('.badge')` exists AND that its text is one of production's gate-verdict strings â€” best obtained by comparing the cell's innerHTML against `gateTag(c.id)` for the row's own item, which calls production instead of restating its vocabulary. The fixture already contains the decoy (the stratum badge), so the seed 'delete gateTag from the row' would discriminate: current form passes, scoped form fails.

### `probe:3606` — face2 — could-pass: **yes** — confidence: high

**Label:** [R26.4] cap semantics: a waived exception frees the active slot â€” 9321 may propose
**Requirement:** R26.4

**Evidence.** The subject is `ev21 = exceptionEvidence(9321)` (probe 3383) and the assertion is `!!ev21`. exceptionEvidence (index.html:7227-7237) reads shadowSlice thresholds, the red-flag set, excFor(id) and the benched-gate tally â€” it NEVER calls excActiveN() and never reads EXC_MAX_ACTIVE. The cap lives in exceptionProposals (index.html:7393) and grantException (index.html:7409). Second, independent problem: at probe 3383 DB.shadowExceptions holds exactly ONE record (9320, flipped to 'waived' at probe 3376) against EXC_MAX_ACTIVE = 2 (index.html:7210), so even if a waived record DID count as active the count would be 1 and a slot would still be free.

**Could it pass with the property absent?** Two ways it passes with the property gone. (a) Make excActiveN() count waived records as active â€” exceptionEvidence does not consult it, so ev21 is unchanged and the assertion is green. (b) Even after moving the assertion to the right subject (exceptionProposals), the fixture holds one waived exception against a cap of two, so the free slot exists either way and the property remains unfalsifiable. This is the label naming a cap and the subject never reading one.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Point the assertion at the layer that reads the cap â€” assert exceptionProposals() contains 9321 and that excActiveN() === 0 â€” AND seed TWO waived exceptions before it, so that counting a waived record as active would exhaust EXC_MAX_ACTIVE and empty the list. Only with both changes does a seeded defect in the cap accounting turn this red; the fixture change is the load-bearing half.

### `probe:5271` — face2 — could-pass: **yes** — confidence: high

**Label:** [R50.1] the window is the median of the last EST_FLOW_HOURS hours, so one quiet hour cannot swing it
**Requirement:** R50.1

**Evidence.** `EST_FLOW_HOURS = 6` (index.html:3137) and the windowing is `const last = sp.lows.slice(-EST_FLOW_HOURS)` (index.html:3173, inside `reachFlow`). The fixture at probe-snippet.html:5050-5051 supplies exactly SIX hourly readings. With n === EST_FLOW_HOURS, `slice(-6)`, `slice(0,6)`, `slice(-99)` and no slice at all return the identical array, so the 'last EST_FLOW_HOURS hours' half of the label is untestable on this fixture. Every other reachFlow fixture in the slice is also exactly six readings (5036-5037, 5072-5073, 5081-5082), so no assertion in this slice exercises the window at all. The label's second half ('one quiet hour cannot swing it') IS tested â€” the sixth reading carries lv: 1 and the median still returns 1000.

**Could it pass with the property absent?** Seed the window away â€” change index.html:3173 to `const last = sp.lows.slice();` or `sp.lows.slice(0, EST_FLOW_HOURS)` â€” and this assertion stays green, because the fixture array is exactly six long either way. A regression that let a stale 40-hour history feed the median (the very input whose 518Ã— error justified the interim gate downgrade logged at index.html:3151-3155) would be invisible to it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Build the fixture with MORE readings than EST_FLOW_HOURS and make the excess discriminating: e.g. eight readings where the two OLDEST carry a reaching flow far from 1000 (say { lo: 3000, lv: 100000 }), so an unwindowed or wrongly-windowed median returns a different number. Keep the existing quiet-hour reading so both halves of the label are covered. Prove by seeding the `slice(-EST_FLOW_HOURS)` removal at index.html:3173 and confirming red â€” and confirm first that the seeded line executes (it does; `reachFlow` is called on every plan line).

### `probe:2980` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R22.4] the NEXT UP row's badge says so on the watchlist
**Requirement:** R22.4

**Evidence.** Probe 2758-2759: `/NEXT UP #1/.test(document.querySelector("#watchBody").innerHTML)`. The label's subject is 'the NEXT UP ROW's badge' â€” a per-row claim â€” but the container is the whole table body. The string itself is specific (produced only at index.html:10741, `label: "NEXT UP #" + (nuIdx + 1)`), so a stray match from unrelated copy is unlikely; what the container cannot see is WHICH row carries it. The preceding assertion at 2755 has `P22.nextUp[0].id` in hand and does not use it here.

**Could it pass with the property absent?** The property the label names is that the badge lands on the next-up row. If `planStatusInfo` attached NEXT UP #1 to the wrong item â€” the funded pick, or the demoted one â€” the string is still somewhere in `#watchBody.innerHTML` and the assertion stays green. Row-to-badge attribution is exactly what the plan-status feature is for (an unexplained state reads as a broken feature), and this assertion cannot see it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Locate the next-up item's own row and match inside it: find the row whose item is `P22.nextUp[0].id` (rows already carry their id via the `[data-wdetail]`/`[data-add]` handles) and assert `/NEXT UP #1/` against that row's `.tags` fragment only â€” the same narrowing `blendFrag(html, key)` performs for pooling assertions at probe lines 19-28. Seeding requires a fixture with at least two rows carrying distinct plan statuses so a mis-attribution can express itself.

### `probe:4525` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R38.2] every gate name a bench reason can render has a glossary family entry
**Requirement:** R38.2

**Evidence.** probe 4300-4302 builds the population by regexing production SOURCE TEXT: `gateName.toString().match(/return "([^"]+)"/g)`. That is the probe constructing an input the product would have constructed â€” the sharper form of the seventh face. It works only because gateName (index.html:4191-4211) happens to be written as 18 literal `return "â€¦"` statements. Refactor it to a lookup table, a template literal, or `return GATE_NAMES.roiFloor` â€” all ordinary refactors â€” and the match returns null, gateNames38 becomes [], missing38 becomes [], and the assertion reports full glossary coverage over ZERO names. The count is carried in the `extra` argument (`checked: gateNames38.length`), but extras are only emitted on FAIL, so a vacuous pass shows the operator nothing.

**Could it pass with the property absent?** Read gateName in full at index.html:4191-4211 and confirmed the regex currently extracts all 18 returns, so the assertion is sound TODAY. What I could not determine is whether anything else in the suite would go red on such a refactor; I did not search the other eleven slices for a second consumer of gateName's source text. The 'yes' is about the assertion's own construction, not about a defect present now.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the registry into production â€” a `GATE_NAMES` array that gateName() itself reads and returns from â€” and point the assertion at that array rather than at a regex over source. Until then, at minimum add a floor to the population (`gateNames38.length >= 15`) so a silently-empty extraction fails by name instead of passing as full coverage.

### `probe:382` — face8 — could-pass: **yes** — confidence: low

**Label:** sub-5-unit window is labeled noise and never binds

**Evidence.** Probe line 383: `(S.vol5Low.get(9001) || 0) === 0`. `S.vol5Low` is reset to a fresh Map at probe line 369, so before this assertion the ONLY writes to it are the two `updateVol5Streaks()` calls at line 380 â€” the calls under test. Production, index.html:3006-3011, writes an entry for every watchlist item on every call (`S.vol5Low.set(w.id, below ? ... : 0)`). The `|| 0` therefore erases the difference between 'the streak loop ran and correctly declined to arm' and 'the streak loop never ran at all', which is the eighth face's root â€” a green result that can mean the test never ran. The other conjuncts of this assertion (`!cV.failed`, `cV.volGate === 50000`, `/noise, not measurement/`) are real and call production, so the assertion is not empty; only the streak conjunct is tolerant. The sibling at line 405 uses the same `|| 0` idiom but is safe, because line 397 has already proved the entry exists at 2.

**Could it pass with the property absent?** Seed a defect that skips the streak loop entirely (or that removes 9001 from the iteration) and `S.vol5Low.get(9001)` is `undefined`; `undefined || 0` is 0 and the conjunct passes. The property 'never arms the streak' would then be untested rather than confirmed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Drop the tolerance: assert `S.vol5Low.get(9001) === 0` strictly, which requires the loop to have executed and written a zero. Production guarantees the key exists for every watchlist item after any call (index.html:3010), so the strict form is safe here; the eighth face's guidance applies â€” decide which layer owns the promise and make exactly one own it.

### `probe:471` — face9 — could-pass: **yes** — confidence: low

**Label:** [R8.3] concur-recommended batch renders with the die-off defense
**Requirement:** [R8.3]

**Evidence.** Probe lines 470-474 take `depD = document.querySelector("#depBody").innerHTML` â€” the entire deploy body â€” and require `/Concur-recommended/`, `/binding side is the confirmed 5m sample/` and `/die-off detected/` to each match SOMEWHERE in it. The property in the label is co-location: that the die-off defense renders UNDER the concur-recommended header rather than as a pending ruling. Three independent whole-container matches cannot express co-location. The ninth face's remedy already exists in this very file â€” `blendFrag(html, key)` at probe lines 19-28 narrows a match to one `data-drill` element and its inline sibling â€” and nothing in lines 1-622 uses it. Mitigating, and the reason I rate this low: the very next assertion (line 475) requires `S.depProposalCount === 0`, which independently rules out the die-off line having become a pending ruling, so the pair is tighter than either half. I could not determine from my slice whether the concur block carries a stable container attribute to scope to; that is a production question I did not resolve.

**Could it pass with the property absent?** If the die-off defense rendered outside the concur batch while any other entry supplied the 'Concur-recommended' header, all three regexes still match the whole `#depBody`. The fixture happens to contain no such decoy (lines 411, 482 clear the gate and die-off ledgers), which is the tenth face's problem for PROVING this assertion, not evidence that the container is tight.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Scope the match to the concur block itself in the blendFrag idiom â€” locate the element carrying the 'Concur-recommended' header (adding a `data-concur` attribute in index.html if none exists) and match the two die-off phrases inside that element's subtree only. Per the tenth face, prove it with a fixture carrying a SECOND, non-concur proposal that also mentions the die-off tag, so the whole-container form passes while the scoped form fails.

### `probe:800` — face9 — could-pass: **yes** — confidence: low

**Label:** [R2.1] price+volume RAMPING / gate gaps carry have/need/short for the near-miss view

**Evidence.** probe-snippet.html:800-802: `cF.fails.every(f => f.detail) && cF.fails.some(f => f.have != null && f.need != null && f.short)`. The subject named in the label is 'gate gaps' â€” plural, the population â€” and the near-miss view the label cites is the one asserted at probe-snippet.html:841-842 as 'sustained ROI 1.15% vs 1.2% floor', i.e. it reads have/need off the ROI floor specifically. The fixture (probe-snippet.html:793-795) makes 9002 fail at least three gates: sustained ROI, flow imbalance, volume floor (asserted at 796-799). With `.some`, one of those three carrying have/need/short satisfies the whole clause â€” drop the numeric gap from the two others, or from the ROI floor itself, and the assertion is still green. This is the collection-level form of the broad-container tell: the quantifier is broader than the subject.

**Could it pass with the property absent?** Read from the assertion text alone plus the fixture at 793-795 and the companion assertion at 796-799 establishing that fails.length >= 3. I did NOT determine whether every gate in the chain is even capable of emitting have/need (a boolean gate legitimately would not), which is why `.some` may have been deliberate â€” that is the part I could not settle without reading every gate's failure record, and it is why confidence is low rather than medium. The 841 near-miss assertion does independently cover the ROI floor's gap copy, so the practical exposure is the other gates.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Name the gates that are contracted to carry a numeric gap and assert `every` over exactly those, rather than `some` over all fails â€” e.g. assert that the fail whose g is 'sustained ROI' and the one whose g is 'volume floor' each carry have/need/short, leaving genuinely boolean gates out of the quantifier. If the set of numeric gates is itself a production fact, extract it (a gateHasNumericGap(g) predicate) and quantify over that, rather than listing gate names in the probe.

### `probe:845` — face9 — could-pass: **yes** — confidence: low

**Label:** pipeline shows the seasoning item with an ETA

**Evidence.** probe-snippet.html:845: `/Probe gamma/.test(dep) && /qualifies at ~/.test(dep)`, where dep is the whole #depBody innerHTML (probe-snippet.html:835). The property in the label is a conjunction that must hold WITHIN one pipeline row â€” this item, with an ETA â€” but the two regexes are matched independently against a container that also holds the funnel, the near-miss split, the multi-gate list and the proposals block. Nothing in the assertion couples them. The fixture makes the decoupling unobservable because 9003 is the only qualifying item (probe-snippet.html:826-828), so there is exactly one pipeline row and the name and the ETA cannot end up on different rows â€” which is the tenth face's complaint about a fixture that cannot discriminate, arriving as the reason a ninth-face assertion currently looks fine.

**Could it pass with the property absent?** Determined structurally from the assertion and the fixture. With a single-item pipeline the two matches cannot decouple today, so the exposure is latent rather than live â€” hence low confidence. I did not exhaustively verify that 'Probe gamma' cannot render elsewhere inside #depBody; it is a qualifying item so it is absent from the funnel counts and the near-miss/multi-gate lists, but I could not rule out every proposal-copy path without reading all of renderDeploy.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Scope the conjunction to one row: parse dep into a div, select the pipeline row containing 'Probe gamma', and assert 'qualifies at ~' inside THAT element's outerHTML â€” the same narrowing blendFrag performs at probe-snippet.html:19-28. Separately, give the pipeline fixture a second qualifying item so the decoupled-row failure mode has something to express itself on; per the tenth face, a fixture holding only one row cannot demonstrate that the scoping works.

### `probe:2613` — face9 — could-pass: **no** — confidence: low

**Label:** [R19.2] streams agree â†’ change-proposal cites both, counts as a ruling
**Requirement:** R19.2

**Evidence.** Probe 2452-2456: `depHTML = document.querySelector("#depBody").innerHTML` then `/Realized overrides make the case and the paper screen concurs/.test(depHTML) && /\[real fills/.test(depHTML) && /\[simulated/.test(depHTML) && S.depProposalCount === 1`. The subject is one proposal; the container is the whole deploy panel. `#depBody` can carry several marker-bearing blocks: the concur lanes at index.html:10218 and 10222 both interpolate `dirs.shadow.txt` / `dirs.realized.txt` (which carry `[simulated â€” ...]` and `[real fills â€” ...]`, index.html:7548 and 7553), and the regime-divergence proposal at index.html:10243 emits its own `[real fills]`. The author's own `extra` argument (2456) slices depHTML from `indexOf("Proposals")` â€” i.e. the proposal fragment is the intended subject, and the condition does not use it.

**Could it pass with the property absent?** Not today, and I checked rather than assumed: the fixture empties `DB.shadowDivLog` at probe 2450, so `shadowRegimeEvidence()` returns null (index.html:6819-6820, `if (log.length < 7) return null`) and the regime proposal with its `[real fills]` marker never renders; the die-off and seasoning props carry no markers; and only one gate ('ROI floor') is seeded, so only one stream-bearing block exists. Deleting `dirs.shadow.txt` from index.html:10215 would therefore fail the assertion today. The finding is that nothing HOLDS this to be true â€” the tenth face's remedy (a standing assertion pinning the fixture to carrying a decoy) is absent, so a second gate in the fixture, or a seeded divergence ledger, silently converts this into the R49.2 defect.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Match the two stream markers inside the proposal block only â€” the `.plan-note` div under the 'Proposals' header (index.html:10258-10262) â€” rather than against `#depBody.innerHTML`, using the same fragment-locating idiom as `blendFrag` at probe lines 19-28. If the assertion is left page-wide, add a standing assertion that the fixture carries a SECOND marker-bearing block, so the scoping property cannot quietly become untestable.

### `probe:7063` — face12 — could-pass: **no** — confidence: low

**Label:** [R63.1] the retention ceiling is STATED where the span renders, not left to cap it silently
**Requirement:** R63.1

**Evidence.** The probe takes a real production object and overwrites two of its fields by hand: `const far = shadowSlice(9330, true); far.spanD = 41; far.spanCapped = true;` (probe 6780-6781). Production computes both together at index.html:7147-7159: `const spanD = (lastAt - firstAt) / 86400e3; ... spanCapped: spanD >= SPAN_RETENTION_D - 0.5`. The paper book itself prunes at 30 days (index.html:6801: `DB.shadowBook.filter(p => p.state === "open" || now - (p.closedAt || 0) < 30 * 86400e3)`), so a spanD of 41 with a live book is not a state shadowSlice can return â€” spanD tops out around the retention window.

**Could it pass with the property absent?** The asserted copy (index.html:7222) is gated on `s.spanCapped` alone and does not read spanD, so the unreachable value 41 is immaterial to what the assertion tests: delete the retention clause from spanDaysTxt and this goes red regardless. The unreachable field is decoration on an otherwise sound assertion. I am reporting it because scan 13's enumeration is the deliverable and the constructed argument shape is genuinely not one production produces, not because I think the assertion is blind.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Cheapest correct change: set `far.spanD` to a value production can actually reach (SPAN_RETENTION_D, or leave it untouched) and set only `far.spanCapped = true`, so the fixture states no impossible number. Better, if the reachability is genuinely in doubt: build the fixture through shadowSlice by seeding trips spanning the retention window, so the capped flag is produced by index.html:7159 rather than assigned.

---

# TIER: OTHER

### `probe:197` — face5 — could-pass: **yes** — confidence: high

**Label:** wed advisory fires only on Wednesdays

**Evidence.** Probe line 197: `ok("wed advisory fires only on Wednesdays", new Date().getDay() === 3 ? /probe-cluster/.test(wtxt) : wtxt === "", ...)`. Production, index.html:3409-3418: `const isUpdateDay = () => new Date().getDay() === 3;` and `function wedClusterAdvisoryText(extraIds){ if (!isUpdateDay()) return ""; ... }`. The probe re-implements the predicate rather than calling `isUpdateDay()`, and folds the ambient clock into the property it asserts: on six days in seven the assertion collapses to `wtxt === ""`, and the branch that checks the advisory actually names the cluster never runs. Today is 2026-08-13, a Thursday, so the content branch is dead on this run. Line 194 has already established that `clustersInPlay([])` returns probe-cluster, so the emptiness is caused by the day and not by an empty population â€” which means the whole body of the advisory (index.html:3419-3422) is unexercised six days a week. The fifth face also covers the mirror risk: the probe's `new Date()` and production's `new Date()` inside `isUpdateDay()` are TWO SEPARATE CLOCK READS, so a run crossing local midnight into or out of Wednesday disagrees with itself.

**Could it pass with the property absent?** On any non-Wednesday â€” including today â€” deleting the entire body of `wedClusterAdvisoryText` and returning "" unconditionally leaves this assertion green. The property in its own label ('fires ... on Wednesdays') is asserted on one day in seven and is untested on the other six.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Inject the varying input rather than pinning it: give the advisory an injectable day â€” e.g. extract `wedClusterAdvisoryTextOn(isUpdate, extraIds)` in index.html with `wedClusterAdvisoryText(ids) => wedClusterAdvisoryTextOn(isUpdateDay(), ids)` â€” then assert BOTH branches unconditionally (`...On(true, [])` names probe-cluster; `...On(false, [])` is ""), plus one thin wiring assertion that the live function equals `...On(isUpdateDay(), [])`. That runs the same on every weekday and removes the two-clock-read disagreement.

### `probe:1271` — face2 — could-pass: **yes** — confidence: high

**Label:** [R2.1] price+volume rising together = accumulation signature, RAMPING
**Requirement:** R2.1

**Evidence.** Production is index.html:13382-13384: `entryVerdict = st => ... : (st.accum || (st.priceVs != null && st.priceVs >= 5)) ? "RAMPING" : "neutral"` â€” RAMPING has TWO independent routes. The fixture at probe-snippet.html:1175 is mkSlvDays(40, i => i<26 ? 1000 : 1100, i => i<26 ? 100 : 220). Working it against index.html:13352-13381 (medians, not means): last7m = 1100, basem = median of the first 26 days = 1000, so priceVs = +10. That is >= 5, so the SECOND route fires on its own. Seed 'delete `st.accum ||` from index.html:13384' and entryVerdict(stRamp) is still "RAMPING" via priceVs, so the assertion stays green. The other conjuncts do not rescue it: `stRamp.accum === true` tests slvSeriesStats' accum computation (13377), not the verdict wiring, and `rise14p >= 4 && rise14v >= 25` are probe-side restatements of the same 13377 constants. So the specific property in the label â€” that the accumulation signature is what produces RAMPING â€” is the one thing not tested.

**Could it pass with the property absent?** Determined by reading index.html:13352-13384 and computing the fixture's priceVs by hand (medians over 26 flat days then 14 raised days give exactly +10%). The accumâ†’RAMPING edge can be cut with no red. The stats-side accum computation IS covered by the separate `stRamp.accum === true` conjunct; it is only the verdict wiring that is uncovered.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Move the fixture's price rise into the band where neither the DISCOUNTED nor the priceVs-RAMPING route can fire, so accum is the sole route: e.g. mkSlvDays(40, i => i<26 ? 1000 : 1045, i => i<26 ? 100 : 220) gives priceVs = +4.5 (below the >=5 leg) while rise14p = +4.5 (>= 4) and rise14v = +120 (>= 25), so accum is true and RAMPING can only have come from accum. Keep the existing +10% case as a second assertion for the priceVs route, so both disjuncts are separately pinned. Unproven until the `st.accum ||` deletion has been seeded and watched fail.

### `probe:1276` — face2 — could-pass: **yes** — confidence: high

**Label:** [R2.4] rank = discount Ã— proximity Ã— liquidity; zero past the window
**Requirement:** R2.4

**Evidence.** Production is index.html:13387-13393: `slvRankScore(st, runwayD)` returns `discount * proximity * liq` where `liq = st.gpVolDay > 0 ? Math.log10(1 + st.gpVolDay) : 0`. All four calls in the assertion (probe-snippet.html:1182-1184) use stats built by mkSlvDays with vn omitted, which hardcodes vol: 100 for every day (probe-snippet.html:1166). gpVolDay is medianOf(last 14 days of vol*mid) (index.html:13378), so stDisc gets 900*100 = 90000 and the deeper-discount series gets 800*100 = 80000 â€” liq 4.954 vs 4.903, a 1% difference against a 2x difference in the discount term. Hand-evaluating the seed 'replace liq with the constant 1': comparison 2 becomes 10 > 5 (passes), comparison 3 becomes 15 > 7.5 (passes), and slvRankScore(stDisc,-1) is still 0 via the runwayD<0 guard at 13388 (passes). Replacing Math.log10(1+gpVolDay) with raw gpVolDay also leaves all three comparisons true. The liquidity factor named in the assertion's own label can be removed or reshaped and this assertion stays green.

**Could it pass with the property absent?** Determined by reading index.html:13387-13393 and 13378, then evaluating each of the three sub-comparisons with liq held at a constant. Liquidity is a common factor on both sides of every comparison the assertion makes, so it cancels. The one defect it WOULD catch is gpVolDay going undefined/zero, because the ternary then zeroes every score and comparison 2 becomes 0 > 0 â€” but that is caught by accident, not by design.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a fourth comparison in which liquidity is the ONLY varying term: build two series with identical price paths (so discount is equal) at the same runwayD (so proximity is equal) but materially different vol â€” e.g. mkSlvDays(40, i => i<26?1000:900, () => 100) vs mkSlvDays(40, i => i<26?1000:900, () => 10000) â€” and assert the higher-volume one ranks strictly above. That is a scaling property, not a re-implementation of log10. Unproven until seeded by replacing liq with a constant and watched fail.

### `probe:1895` — face2 — could-pass: **yes** — confidence: high

**Label:** [R1.5] import keeps sleeve, exits, catalysts, intel, and the flags
**Requirement:** R1.5

**Evidence.** Assertion: `vSlv.db.sleeve.length === DB.sleeve.length && ... && vSlv.db.catalysts.length === DB.catalysts.length && ...`. Both of those comparisons are `0 === 0` at this point in the fixture. DB.sleeve is set to `[]` at probe-snippet.html:1697 and the very next sleeve write is refused â€” assertion 1701 asserts `DB.sleeve.length === 0` after saveSleeveFromForm() is benched under SUSPECTED PUMP â€” and nothing between 1700 and 1722 repopulates it. DB.catalysts is set to `[]` at probe-snippet.html:1622 and the R7 section imports catalyst-typed INTEL records (r-t3cat, r-t0cat) without ever calling activateIntel on them, which is the only path that pushes to DB.catalysts (index.html:14281). The other legs of the conjunction (sleeveExits.net === 8800, intel.length === 2, anomalyFlags.length === 1, rulingsCap === 4, recalV1/sleeveMigV1) use literals in the payload and are live.

**Could it pass with the property absent?** If validateImport dropped `sleeve` and `catalysts` entirely and defaulted both to `[]`, `0 === 0` still holds on both and the assertion stays green â€” the two named populations in the label are exactly the two the fixture cannot express. Determined by reading the fixture state between probe-snippet.html:1622 and 1722 and the only DB.catalysts writer at index.html:14281.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Put a non-empty sleeve position and a non-empty catalyst entry into the payload as literals (the way sleeveExits already does at 1723-1724), and assert a FIELD value that survived rather than a length â€” e.g. `vSlv.db.sleeve[0].basis === 1000` and `vSlv.db.catalysts[0].name === "..."`. Comparing an imported length against a live DB length is the shape that lets an empty population read as a passing round trip; compare against the literal you put in, not against a variable that can be zero.

### `probe:1951` — STALE — could-pass: **yes** — confidence: high

**Label:** [R11.2] slice renders sanity-passing rows with full stats and a manual +watch, â‰¤15 stratum + â‰¤5 gap
**Requirement:** R11.2

**Evidence.** The label states the ruled sample sizes as 'â‰¤15 stratum + â‰¤5 gap'. REQUIREMENTS.md:168 rules R29.2 as 'GAP-BAND SLICE: 5 items per cycle from 250kâ€“1m', and index.html:2679-2680's own comment still reads 'Five items per cycle'. The live constant is `const GAP_BAND_N = 10;` at index.html:2581. The assertion reads the symbol (`BEYOND_NET_N + GAP_BAND_N`), so the 5â†’10 change altered behaviour â€” twice as many gap-band items drawn, ledgered and shadow-scanned per cycle â€” and broke nothing in the suite. This is the ratification-that-breaks-no-test shape: nothing anywhere in my slice pins the gap-band draw to its ruled number; [R29.2] at line 1818 reads the same symbol.

**Could it pass with the property absent?** The property named in the label is the ruled sample size. Because the subject reads the constant symbolically, any value of GAP_BAND_N satisfies the assertion; the label's 'â‰¤5' is a claim the assertion has never checked and which the code has already contradicted. I could not determine from the repo whether the 5â†’10 move was a user ruling that REQUIREMENTS.md:168 and index.html:2679-2680 simply were not updated for, or a drift nobody ruled â€” that question is for the user, and it is why this is reported rather than reconciled.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. First a ruling is needed on which number is correct (spec says 5, code says 10). Then one assertion should pin it literally â€” `ok("[R29.2] the gap band draws the ruled N per cycle", GAP_BAND_N === <ruled>)` â€” so a future change to the constant goes red instead of being absorbed by every symbolic bound; and the labels at 1791/1818 should quote that same number rather than a stale one. Note this also touches REQUIREMENTS.md:168 and the production comment at index.html:2679-2680, which are outside my slice and reported as adjacent.

### `probe:1951` — face8 — could-pass: **yes** — confidence: high

**Label:** [R11.2] slice renders sanity-passing rows with full stats and a manual +watch, â‰¤15 stratum + â‰¤5 gap
**Requirement:** R11.2

**Evidence.** Assertion: `bnRows1 >= 1 && bnRows1 <= BEYOND_NET_N + GAP_BAND_N && /data-add=/.test(bnHTML1)`. Both numeric bounds are guaranteed by the code that produces the rows, so neither can ever fail. Lower bound: renderBeyondNet at index.html:2756-2757 writes `rows.length ? rows.join("") : '<tr><td colspan="11" class="empty">No sanity-passing items yetâ€¦'` â€” there is ALWAYS at least one `<tr>` in #beyondNetBody. Upper bound: rows = `pick.concat(gap.pick)` (index.html:2754-2755), and both come from `seededDraw`, which returns `pool.slice(0, Math.min(n, pool.length))` (index.html:2660-2667) with n = BEYOND_NET_N and GAP_BAND_N respectively â€” the sum cannot exceed BEYOND_NET_N + GAP_BAND_N by construction. Separately, 'full stats' in the label is not asserted at all: the only live conjunct is that some row somewhere in the tbody carries `data-add=`, which is also the whole-tbody container rather than a specific row.

**Could it pass with the property absent?** The two bounds are the caps' own arithmetic restated in the probe â€” a seeded defect in the sampling size cannot make either fail, exactly the trim-over-60-behind-a-cap-of-24 shape. The one live conjunct proves only that â‰¥1 real row (not the empty-state row) rendered with a watch button; the ten-column stat payload the label calls 'full stats' is never inspected. Determined by reading index.html:2660-2667 and 2728-2758.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Assert the row count against the samples that produced it rather than against the caps that already bound them: capture `const s = beyondNetSample(), g = gapBandSample()` at the same S.latestAt and assert `bnRows1 === s.pick.length + g.pick.length` â€” that is a live claim about the render layer and fails if renderBeyondNet drops or duplicates rows. Then assert 'full stats' by naming the columns on one identified row (buy, sell, margin, roi, limit, volSide, age all present and non-'â€”' for a known fixture id) instead of leaving the phrase in the label unbacked.

### `probe:1978` — face8 — could-pass: **yes** — confidence: high

**Label:** [R29.2] the gap-band slice samples 250kâ€“1m â€” the band between the T2 ceiling and the anomaly scan's >1m floor
**Requirement:** R29.2

**Evidence.** Assertion: `gb.pick.some(c => c.id === 9404) && gb.pick.every(c => c.buy >= GAP_LO && c.buy <= GAP_HI) && gb.pick.length <= GAP_BAND_N`. The third conjunct cannot fail: `gapBandSample()` returns `seededDraw(pool, GAP_BAND_N, 7919)` (index.html:2693) and seededDraw returns `pool.slice(0, Math.min(n, pool.length))` (index.html:2662-2667), so the length is â‰¤ GAP_BAND_N by construction. The first two conjuncts are live and good â€” `.some` guarantees the array is non-empty so the `.every` is not vacuous, and the band bounds are a real filter claim.

**Could it pass with the property absent?** For the size half of the claim: yes â€” the bound restates seededDraw's own Math.min, so no seeded defect in the draw size can make it red. For the band half: no â€” a broken GAP_LO/GAP_HI filter would make `.every` fail. The finding is confined to the third conjunct, which is decoration reading as protection. Determined by reading index.html:2660-2667 and 2683-2693.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Replace the tautological `<= GAP_BAND_N` with a claim about the draw the cap does not already guarantee â€” e.g. that when the pool exceeds the cap the draw is exactly GAP_BAND_N (`gb.poolN > GAP_BAND_N ? gb.pick.length === GAP_BAND_N : gb.pick.length === gb.poolN`), which is the property the cap actually implements and which a defect in seededDraw's k can break. Requires a fixture pool larger than the cap to be provable.

### `probe:2089` — face9 — could-pass: **yes** — confidence: high

**Label:** [R12.5] the export and the tape question both ask about the CATALYST
**Requirement:** R12.5

**Evidence.** The assertion is `/is the window moving up\?/.test(rampRow.detail) && tapeQuestionFlags().some(f => f.kind === "catalyst-ramping")`. `rampRow` comes from analystFlagsPending() (probe 1927-1928), whose question string is the literal at index.html:14989. tapeQuestionFlags() carries an INDEPENDENT literal at index.html:14955. The second clause only tests that a flag of that kind exists in the returned array â€” the question text of tapeQuestionFlags' own row is never read.

**Could it pass with the property absent?** Delete or rewrite the detail at index.html:14955 (say, to an item-level question) and this line stays green, because the required phrase is still present in the OTHER producer's row, which the first clause checks. That is the face-9 shape at the object level rather than the DOM level: the container matched is the flag list, and the property is present elsewhere.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Bind the second clause to the row's own text: `const tq = tapeQuestionFlags().find(f => f.kind === "catalyst-ramping"); ... !!tq && /is the window moving up\?/.test(tq.detail)`. Both producers then have to carry the catalyst question in their own words.

### `probe:2161` — face2 — could-pass: **yes** — confidence: high

**Label:** [R13.2] touch marks record first/last stamps
**Requirement:** R13.2

**Evidence.** Two `featTouchMark("tab:probe")` calls in immediate succession (probe 1999-2000), then `DB.featTouch["tab:probe"].first <= DB.featTouch["tab:probe"].last`. Production is `if (v) v.last = now; else DB.featTouch[key] = { first: now, last: now }` (index.html:18534). The two marks land in the same millisecond, or one apart.

**Could it pass with the property absent?** Seed the if-branch to `DB.featTouch[key] = { first: now, last: now }` â€” i.e. lose the first stamp entirely, which is the whole point of a first/last pair and the basis of the 90-day dormancy window â€” and `first <= last` still holds (they become equal). The relation asserted is true under every implementation that writes two non-decreasing clock reads; it cannot fail. The dormancy report at probe 2003 works around this by hand-writing a featTouch record with a 200-day-old first, so the production write path for `first` is asserted nowhere in this block.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Seed the record in the past and assert preservation, not ordering: `DB.featTouch["tab:probe"] = { first: t0, last: t0 }` with `t0 = Date.now() - 3600e3`, then `featTouchMark("tab:probe")` and assert `first === t0 && last > first`. Then the seed 'overwrite first' goes red.

### `probe:2399` — face7 — could-pass: **yes** — confidence: high

**Label:** [R17.5] â‰¥ +0.15 held for 3 of 4 resurfaces with both numbers in the copy
**Requirement:** R17.5

**Evidence.** The whole R17.5 block (probe 2229-2252) constructs the dismissal state by hand: `pR.status = "dismissed"; pR.ruledAt = Date.now(); pR.dismissedC = 0.52;` with the probe's own comment conceding it (`// what the dismiss handler stamps (last non-null reading)`). Production stamps that field in the dismiss handler at index.html:14681 â€” `if (p.kind === "add" && lastC != null) p.dismissedC = lastC;` â€” reached only through the `[data-cohdismiss]` button (index.html:11341, 14672-14674). Grep of the whole probe file for `cohdismiss` returns ZERO hits, so nothing in the suite presses it. The materiality bar the assertion tests reads `hit.dismissedC` at index.html:3678-3684.

**Could it pass with the property absent?** The property under test is the resurface rule reading the dismissal baseline. Seed the handler at index.html:14681 to stamp the FIRST reading, or the current reading, or nothing at all, and every assertion at 2232, 2235 and 2239 stays green â€” the probe supplies 0.52 itself, so the bar is measured against a number production never produced. The sharper form of the seventh face applies exactly: the probe constructs an input the product would have constructed, so the product's constructor is untested. Confirmed the field is real in production (it is not a face-12 fabrication) â€” only its writer is uncovered.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Produce the dismissal the way the product does: renderClusters(), then `document.querySelector('[data-cohdismiss="' + pR.id + '"]').click()`, and let the handler stamp dismissedC â€” the same shape already used for confirm at probe 2208-2211. The three materiality assertions then rest on production's own baseline.

### `probe:3319` — face9 — could-pass: **yes** — confidence: high

**Label:** [R25.7] no shared colour semantics: green/red belong to the shadow family, the test dot is neutral steel
**Requirement:** R25.7

**Evidence.** Probe 3101: `const tOff = col('.tdot')`, where col(sel) does `lg.querySelector(sel)`. querySelector returns the first match in DOCUMENT ORDER, and the legend markup at index.html:700-701 puts `<span class="tdot on">â—</span>` (line 700) BEFORE `<span class="tdot">â—‹</span>` (line 701). `.tdot` matches the 'on' element, so tOff === tOn on every run. Every clause mentioning tOff at probe 3105-3106 (`!isGreen(tOff)`, `tOff !== sPos`, `tOff !== sNeg`) merely restates the corresponding tOn clause. Note also tOff is deliberately excluded from the null-guard at probe 3102, which is consistent with the author expecting a second element that is never actually reached.

**Could it pass with the property absent?** Give the expired test dot (`.tdot` without `.on`) a green or a shadow-family colour and this assertion is unchanged, because the selector never resolves to that element. The expired state is one half of the family the label says is 'neutral steel', and it is untested.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. `const tOff = col('.tdot:not(.on)')` and add tOff to the null-guard at probe 3102 so a vanished expired dot fails rather than throwing. Prove by restyling `.tdot` (expired) to the shadow green and confirming the new form goes red while the old form stays green â€” that is the discrimination the tenth face demands.

### `probe:3806` — face2 — could-pass: **yes** — confidence: high

**Label:** [R28.4] â‰¥3 profitable scanner-cohort trips earn the scout attention boost â€” and only then
**Requirement:** R28.4

**Evidence.** Probe 3578 sets `DB.shadowBook = []`, then 3579-3580 pushes five scanner-cohort trips for 9331 ONLY. So when the assertion tests `!scannerShadowBoost().has(9002)`, item 9002 has ZERO trips of any cohort. index.html:6296-6298 â€” the boost set requires cohort === 'scanner' AND shadowResolved AND (p.net||0) > 0, then `n >= SHADOW_SCAN_BOOST_TRIPS` (=3, index.html:6293). The fixture supplies no item with one or two profitable scanner trips, and none with losing scanner trips.

**Could it pass with the property absent?** Change SHADOW_SCAN_BOOST_TRIPS from 3 to 1, or delete the `(p.net||0) > 0` filter entirely, and nothing observable changes: 9331 still qualifies, 9002 still has no trips at all. The 'and only then' half of the label is asserted against an item with an empty input population, which tests absence-of-data rather than a sub-threshold count.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add two discriminating decoys to the fixture: an item with exactly SHADOW_SCAN_BOOST_TRIPS-1 profitable scanner trips (asserts the count limb) and an item with 3+ scanner trips at net <= 0 (asserts the profitability limb), and assert neither is in the set. Prove by lowering the constant to 1 and watching the count decoy go red.

### `probe:3881` — face9 — could-pass: **yes** — confidence: high

**Label:** [R30.1] the panel separates the streams by nature and calls unobserved hours no-data, never bad hours
**Requirement:** R30.1

**Evidence.** The match `/no data|never observed/.test(hi30)` runs against the ENTIRE hoursLedgerInline() output. The subject named in the label is the unobserved-hour cell â€” index.html:9823, `'<span class="dim">no data â€” never observed</span>'`. But the same panel contains the phrase four other times, none of them the cell: hoursStreamsNote() prose at index.html:9776-9777 ('hours you never observe read "no data", never "bad hour"'), the widest-hours line at 9794 ('(shadow: no data â€” never observed)'), the bar tooltips at 9799 ('shadow: no data (never observed)'), and the legend at 9803 ('hours the paper book has never observed'). hoursStreamsNote() is pushed unconditionally (9790), so the pattern is satisfied by static prose before any cell renders. The other conjuncts do not narrow it: `/03:00/` only requires the table to list hour 3, and the fixture gives hour 3 four trips (probe:3650-3652) so that row renders a fill rate, not the no-data cell.

**Could it pass with the property absent?** Change index.html:9823 to render 'bad hour' or a bare dash and the assertion still passes on hoursStreamsNote()'s own prose. This is the R49.2 shape exactly â€” the property deleted from its subject but present elsewhere on the page.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Narrow to the cell, in the blendFrag idiom: locate the #hoursTable row for an hour with no paper trips and match the no-data copy inside that row's paper-fill-rate cell only. Add the negative match the label's 'never bad hours' demands â€” forbid /bad hour/ inside that cell â€” so a contradicting claim fails as well as a missing one (eleventh face).

### `probe:3964` — face9 — could-pass: **yes** — confidence: high

**Label:** [R32.1] event-driven rows say silence is a valid state rather than showing a false verdict
**Requirement:** R32.1

**Evidence.** The condition is `/event-driven â€” silence is a valid state/.test(fi32)` against the whole freshnessInline() output. Production emits that string PER ROW, inside the per-row loop at index.html:9949-9956 (`r.kind === 'event' ? 'event-driven â€” silence is a valid state' : esc(r.note)`), and freshnessRows() adds at least two event rows unconditionally (index.html:9925 'Die-off episodes', 9926 'Accumulation flags'). One surviving occurrence anywhere satisfies the match, so the tag could be lost from every event row but one â€” or wrongly attached to a scheduled row â€” with the assertion still green. The companion assertion at probe:3734 does check `fr32.filter(r => r.kind === 'event').every(r => r.stale === false)`, but that tests the DATA; this one claims the COPY and does not scope to it.

**Could it pass with the property absent?** Read from the per-row emission at index.html:9956 plus the unconditional event rows at 9925-9926. Removing the tag from all but one event row leaves the pattern satisfied.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Assert per row rather than per panel: parse the rendered rows out of freshnessInline() (or have the render carry a data attribute naming the stream, the way data-drill keys do for blendFrag) and assert that EVERY row whose freshnessRows() kind is 'event' carries the tag, and that no scheduled row carries it. The negative half is what makes it a scoping assertion rather than a presence check.

### `probe:3975` — face1 — could-pass: **yes** — confidence: high

**Label:** [R32.2] a paused breaker serves stale cached series instead of re-requesting
**Requirement:** R32.2

**Evidence.** The condition is `(async () => true)() && !!S.spark.get(9001)`. An async IIFE returns a Promise, which is always truthy, so the first operand asserts nothing; the condition reduces to `!!S.spark.get(9001)` â€” the fixture's own spark cache, populated at probe:83 and never touched by the breaker. Nothing in the assertion reads tsPaused(), calls the production accessor, or observes whether a request was issued. Production's actual behaviour is at index.html:2016-2023: `sparkFor(id)` returns the cache when fresh (2018), and only then, when paused, returns a stale cache rather than fetching (2020-2022). The extra string 'cache present for 9001' describes exactly what is asserted, which is not what the label claims.

**Could it pass with the property absent?** Delete the whole `if (tsPaused())` block at index.html:2020-2023 and this assertion still passes â€” S.spark.get(9001) is unaffected. Read directly off the probe line; no ambiguity.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Assert the production path: age the cached entry past SPARK_TTL (otherwise index.html:2018 short-circuits and the pause branch never runs â€” a dead seed waiting to happen), set the breaker paused, then `await sparkFor(9001)` and assert it returns the cached object AND that no /timeseries request was issued (count calls through the fixture's fetch/getJSON stub). Confirm the TTL short-circuit is genuinely bypassed before reading any result.

### `probe:4293` — CLAMP — could-pass: **yes** — confidence: high

**Label:** [R35.7] the walk-up attention budget is untouched: these are pull surfaces with no rulings on them
**Requirement:** R35.7

**Evidence.** Probe 4072 asserts `walkupDecisionCount() <= 7`. Production (index.html:14902-14913): `rulings = Math.min(pendingRulingItems().filter(x=>!x.snoozed).length, Math.min(10, Math.max(1, DB.rulingsCap || 5)))`, then `brf` is a 0|1 ternary (14907) and `rev` is a 0|1 ternary (14911); the return is `rulings + brf + rev`. With DB.rulingsCap = 5 â€” the app default (index.html:1313) and the value the probe fixture last set before this line (probe:2502, also 1418/1444/1980) â€” the maximum possible value of walkupDecisionCount() is 5 + 1 + 1 = 7. The failure condition (> 7) is arithmetically unreachable. This is face8's worked shape (a trim-over-60 rule behind a stored cap of 24) arriving through a Math.min, which is why I file it as CLAMP: the cap pins the output while the term the rule cares about â€” how many distinct decisions the walk-up actually presents â€” moves freely. A new surface stacking three decision lines that are not rulings/briefing/review is not counted by walkupDecisionCount() at all, and one that IS a ruling is absorbed by the min. CLAUDE.md names this bound as the ONE binding, probe-asserted instance of complexity governance, so the slot it occupies is load-bearing.

**Could it pass with the property absent?** Determined from arithmetic on production code I read: the three summands are bounded by 5, 1 and 1 with the fixture's rulingsCap. Delete the budget discipline entirely and add decision lines to the walk-up; the assertion still passes unless the new lines happen to be pendingRulingItems AND DB.rulingsCap has been raised above 5 (the settings clamp at index.html:15133 permits up to 10, but nothing in this fixture raises it).

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Two halves. (1) Point the bound at the pre-clamp term: extract the enumeration of decision-bearing elements the walk-up actually renders â€” walk the rendered #ckList / walk-up surface for ruling lines, the briefing reminder and the review-ready line rather than re-deriving from three known kinds â€” into a named function (e.g. `walkupDecisions()` returning the rows) and assert `walkupDecisions().length <= 7` on that. (2) Additionally assert the overflow relationship the clamp creates, so the cap cannot silently hide a breach: with DB.rulingsCap driven to its settings maximum of 10 and enough pending items, assert the surface DISCLOSES the overflow (index.html:17260 already renders 'capped at N lines') rather than counting it away. Neither half is proven until seeded, which I am forbidden to do.

### `probe:4367` — face2 — could-pass: **yes** — confidence: high

**Label:** [R36.4] PROMOTE is never auto-executed â€” naming a thesis cluster is a judgment, not bookkeeping
**Requirement:** R36.4

**Evidence.** The assertion is `!DB.decisionLog.some(x => x.auto && /promote/i.test(x.action))`. The fixture immediately before it (probe:4131-4135) sets DB.clusters = [], DB.cohProps = [], DB.decisionLog = [], DB.seedAt = {9001: now-40d}, DB.sibBorn = {9002: <a number>}, DB.flips = []. Production emits PROMOTE only from seedAudit at index.html:11797-11800, gated on `trading >= 3`, where `trading` counts lineage members with flips since their birth (11783-11787). With DB.flips = [] no member can trade, so `trading` is 0 and `rec` can only be RETIRE or KEEP. autoApplyAudits (index.html:11733-11755) has branches for KEEP and RETIRE only; the sibling loop (11756) reads sibAudit().rows, which filters `w.src === 'scout'` (index.html:11823) and the fixture's watch entries carry no src, so that loop is empty too. Seed the defect this assertion exists to catch â€” add an `else if (a.rec === 'PROMOTE')` branch to autoApplyAudits that logs an auto-promote â€” and nothing changes, because no audit row in this fixture can carry rec === 'PROMOTE'. That is the dead-seed limb of face8 arriving through the fixture, which is face2.

**Could it pass with the property absent?** Determined from production code: the PROMOTE recommendation requires trading >= 3 and the fixture makes trading identically 0. The assertion asserts the absence of an outcome the fixture cannot produce, so it passes unconditionally.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Build the fixture in the state where the defect would fire: seed DB.sibBorn with two correctly-shaped {seed: 9001, t} entries and DB.flips with a trade for the seed and each sibling since its t, so seedAudit() returns rec === 'PROMOTE'; assert both that seedAudit()[0].rec === 'PROMOTE' (proving the fixture reaches the branch) and that DB.decisionLog carries no auto entry for it. Per the seeding precondition, the fixture change must be confirmed to move seedAudit()'s output before the assertion is counted as proven.

### `probe:4447` — face2 — could-pass: **yes** — confidence: high

**Label:** [R37.2] every excluded count opens to the trips behind it â€” on the gate tree, the cohort ledger and the hours table
**Requirement:** R37.2

**Evidence.** The label names THREE surfaces. The condition checks two: /data-drill="thin:gate:ROI floor Â· pre-stamp"/ against gateStreamsSection(), and /data-drill="thin:coh:watchlist"/ against paperCohortSection(). The hours table is never rendered or matched. It exists and it has a drill key: index.html:9831 calls `thinNote(r.thin, "hour:" + r.h, r.thinTrips)`, and thinNote (index.html:5767-5776) builds `drill("thin:" + key, â€¦)` â€” so the key is `thin:hour:<h>`. Crucially thinNote line 5770 reads `if (!key || !trips) return ' <span class="dim">' + face + '</span>';` â€” dropping the key/trips arguments at the hours-table call site silently degrades that count to a BARE, unopenable figure, which is precisely the interrogability finding this assertion's label claims to police, and the assertion would stay green.

**Could it pass with the property absent?** Read the three thinNote call sites (index.html:9662 cohort, 9831 hours, 12031 gate) and matched them against the two regexes in the assertion. The hours one has no corresponding match anywhere in the slice.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extend the condition with the third surface â€” render the paper hours table with at least one thin trip in a known hour bucket and match /data-drill="thin:hour:<h>"/ inside that table's own element (not the page). Better per the case law's preference for one check over three: extract a production enumerator that lists every thinNote call site's key, and assert every key it returns resolves to a drill element â€” that way a fourth exclusion surface added later inherits the check instead of re-earning it.

### `probe:4578` — face11 — could-pass: **yes** — confidence: high

**Label:** [R38.4] and it states the auto-apply carve-out instead of the superseded 'never caps until you ratify'
**Requirement:** R38.4

**Evidence.** Condition: `/ADDS now apply automatically/.test(basket38.caveat||"") && /DROPS/.test(basket38.caveat||"") && /exposure cap/.test(basket38.caveat||"")`. Three positive matches, no negative. The label's word is INSTEAD â€” it claims the superseded rule is gone â€” but the superseded sentence 'never caps until you ratify' is nowhere forbidden. A caveat carrying both the new carve-out and the old contradicting claim passes green. This is the same shape as the [R62.6] instance that named the eleventh face: the asserted phrase survived while the copy's other half asserted the opposite. The immediate sibling at 4352 does carry its negative match, which makes the omission here look like an oversight rather than a decision.

**Could it pass with the property absent?** Read directly from the assertion's own condition at probe 4357-4358; no fourth term exists. Nothing else in the slice matches against basket38.caveat.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the absence half: `&& !/never caps until you ratify|caps nothing until you ratify/i.test(basket38.caveat||"")`. Per the tenth face, prove it by seeding the contradiction INTO the caveat alongside the correct text â€” the old form must pass and the new form must fail; if both fail, the fixture cannot discriminate and the fixture is what needs fixing.

### `probe:4696` — face2 — could-pass: **yes** — confidence: high

**Label:** [R39.5] a press outside closes it â€” and is not swallowed, so it still reaches what is beneath
**Requirement:** R39.5

**Evidence.** Condition: `beforeOutside && !popOn()`. That tests the first clause only. The label's second clause â€” the outside press is not swallowed and still reaches what is beneath â€” has no subject in the fixture at all: the press goes to document.body (probe 4473), there is no element beneath to receive it, no listener recording receipt, and no check of defaultPrevented or of propagation. A dismiss handler calling e.preventDefault() and e.stopPropagation() â€” the exact defect the clause names, and a common one â€” passes this assertion green.

**Could it pass with the property absent?** Read directly from the assertion's condition at probe 4474-4475. There is no second term.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Place a probe-owned target element under the press point, register a pointerdown listener on it, dispatch the outside press at that element, and assert BOTH that the popover closed AND that the listener fired with defaultPrevented false. That makes the clause's own defect expressible.

### `probe:5005` — face2 — could-pass: **yes** — confidence: high

**Label:** [R40.8] attention minutes are charged per touch, with the evening touch costing more
**Requirement:** R40.8

**Evidence.** The fixture writes DB.touchMins = [6, 6, 6, 10] at probe 4583. Production touchMins() (index.html:2365-2369) is `ws.map((w, i) => Math.max(1, Number(raw[i]) || (i === ws.length - 1 ? 10 : 6)))` â€” its OWN fallback for a four-window schedule is exactly [6,6,6,10]. So the assertion's checks (m.length===4 && m[3]===10 && m[0]===6) hold identically whether the function reads DB.touchMins or ignores it completely: the fixture's input is byte-identical to the default. This is the seeding precondition's second clause ("it runs and computes the same value anyway") baked into an assertion. Separately, the label's verb is CHARGED and nothing here charges anything â€” the assertion reads an array; no attention-minute denominator is exercised at this line.

**Could it pass with the property absent?** Determined by reading touchMins() at index.html:2365-2369 against the fixture write at probe 4583. Seeding `raw[i]` out of the expression would change nothing observable at this assertion.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Set the fixture to values the fallback cannot produce â€” e.g. [3, 4, 5, 17] â€” and assert touchMins() returns those, which proves the setting is read; keep a separate assertion for the default shape with DB.touchMins deliberately unset. For the 'charged' half, assert the denominator downstream: that the attention-minute total for a day of four logged touches equals the sum of the per-touch minutes, not a flat multiple.

### `probe:5528` — face8 — could-pass: **yes** — confidence: high

**Label:** [R42.5] a truncated section keeps the NEWEST rows and says so, with kept and total
**Requirement:** R42.5

**Evidence.** The trip truncation this assertion covers cannot fire in the product. `ANALYSIS_CAPS.trips = 500` (index.html:17616) is applied by `analysisCap(book, ANALYSIS_CAPS.trips, "closedTrips", â€¦)` at index.html:17850, where `book` is `(DB.shadowBook || []).filter(shadowResolved)` (index.html:17848) â€” a subset of `DB.shadowBook`. `DB.shadowBook` is hard-capped at 300 by `DB.shadowBook = DB.shadowBook.filter(â€¦).slice(-300)` at index.html:6801, which sits unconditionally in `shadowTick()`'s body (function opens at 6630, next function at 6818) and therefore runs on every poll. A population capped at 300 can never exceed a trim set at 500. This is the eighth face's own worked case with different numbers â€” the trim-over-60 rule behind a stored cap of 24. The probe reaches the branch only by mutating the constant: `ANALYSIS_CAPS.trips = 2` at probe-snippet.html:5303, restored at 5305 â€” a call path no production caller has, which is also the twelfth face's tell.

**Could it pass with the property absent?** The property the label names â€” 'a truncated section keeps the NEWEST rows and says so' â€” is exercised only under a constant the product never holds, so the assertion says nothing about whether trip truncation ever protects a real export. Its green is real (the code runs, on real production output) and uninformative about the product, which is exactly the shape the eighth face exists to explain. I did NOT verify the other three caps (`gateItems: 400` against `gateHealthAudit()`'s row count, `strataIds: 300`, `dieOff: 200`) â€” they may be reachable; only the trips cap is proven dead here.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN, and this is a ruling for the user rather than an edit: per the eighth face, decide which layer owns the promise. Either (a) lower `ANALYSIS_CAPS.trips` below the 300 retention cap so the trim has work to do and the assertion tests a live rule, or (b) delete the trip trim and point the assertion at the upstream guarantee â€” the 300-row retention prune at index.html:6801 â€” declaring it in the export header's truncation ledger as the cap that actually binds. Note scan 13's ordering rule: this assertion is currently the thing holding the dead branch alive, so if (b) is chosen, move the assertion to the retention layer BEFORE removing the trim, or the deletion will read as a broken test.

### `probe:6605` — face9 — could-pass: **yes** — confidence: high

**Label:** [R61.1] each surface opens with its QUESTION, answered in one sentence
**Requirement:** R61.1

**Evidence.** Three regexes matched against the whole of `paperVerdict()`, `gateVerdict()` and `prospectVerdict()`. The label's property is positional â€” 'opens with' â€” and nothing tests position. In production `paperVerdict()` prepends `loud` (the stale-host note plus the provisional banner) BEFORE `verdictHead(â€¦)` at index.html:18348-18352, so in that branch the question is already not first and the assertion is green over it. The second half of the label, 'answered in one sentence', is not asserted at all.

**Could it pass with the property absent?** Move the question to the bottom of the returned HTML and every regex still matches. The one production branch that already violates the literal reading of the label is invisible to it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Parse the returned HTML and assert the first `.vq` element's textContent is the question, and that no non-`loud` element precedes the `.vhead` â€” i.e. narrow the container to the opening element rather than the whole surface.

### `probe:6618` — face7 — could-pass: **yes** — confidence: high

**Label:** [R61.2] the count of elements ABOVE the first disclosure is small enough to hold in mind
**Requirement:** R61.2

**Evidence.** The probe assembles its own composite: `aboveFold(paperVerdict() + shadowScanStateLine(null) + fold('x','<div>y</div>'))`. Production assembles the same surface at index.html:18419-18422 â€” `setHTML('#paperRegime', paperVerdict() + shadowScanStateLine(null) + fold(â€¦paperHeadlineSection()) + fold(â€¦paperRegimeSection()) + fold(â€¦calibSection()))`. Insert a fourth element above the first fold at 18419 and the assertion never sees it. Worse, the stub `fold('x','<div>y</div>')` guarantees a `<details>` exists, whereas the real first fold returns '' when its body is empty (index.html:7606) â€” in which case everything becomes above-fold and `aboveFold` counts the whole surface. The fixture cannot express that case.

**Could it pass with the property absent?** The property is a bound on the rendered paper surface. The subject is a three-term string the probe wrote. Production's composition is one line away and is not read.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the composition at index.html:18419-18422 into `paperRegimeHTML()` and have both `setHTML` and the assertion call it â€” or call `renderPaperView()` and measure `$('#paperRegime').innerHTML`. Same for `#prospectStrata` (18438) and `#gateStreams` (18448) if the bound is meant to bind them too.

### `probe:6631` — face9 — could-pass: **yes** — confidence: high

**Label:** [R61.4] contamination and stall states stay ABOVE the fold â€” the stated exception
**Requirement:** R61.4

**Evidence.** `/Answers here are provisional/.test(v) && aboveFold(v) >= 1` â€” two conjuncts that never meet. The phrase is matched against the entire verdict string; `aboveFold(v) >= 1` is satisfied by any element preceding the first `<details>`, and `verdictHead()` (index.html:7598-7602) always emits one. Move the provisional banner inside a `<details>` and both conjuncts still hold. Secondary: the banner only renders when `paperDefectsOpen().length` is non-empty (index.html:18348), and the probe injects nothing to guarantee that â€” the assertion's subject depends on the app's live defect register, so it can go red for a reason unrelated to the fold property.

**Could it pass with the property absent?** The property is 'this specific text is above the fold'. The assertion is 'this text exists somewhere' AND 'something is above the fold'. Those are satisfiable independently, which is the ninth-face tell exactly.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add an `aboveFoldHTML(html)` helper beside `aboveFold` returning the concatenated outerHTML of the elements before the first `<details>`, and match the phrase inside that fragment only. Inject the open-defect state so the banner's presence is a fixture property rather than ambient.

### `probe:6660` — face7 — could-pass: **yes** — confidence: high

**Label:** [R61.5] a fold's label says what opening it would TELL you, not what kind of element it is
**Requirement:** R61.5

**Evidence.** `fold(label, innerHTML, open)` at index.html:7605-7609 interpolates `esc(label)` straight into `<summary>`. The probe passes the label string in and asserts the same string comes back out â€” it tests fold's passthrough, not any label the product actually renders. Production's real fold labels live at index.html:18420-18422, 18429-18432, 18439-18441 and 18449-18451. Rename every one of them to 'table' and this assertion is unaffected.

**Could it pass with the property absent?** The property is a claim about production's labels; the subject is a probe literal. There is no path by which a bad production label reaches this assertion.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Render the real surfaces (or extract the label list into a named function the render sites and the probe both read), parse every `<summary>` in `#paperRegime`, `#prospectStrata`, `#gateStreams` etc., and assert none matches /^(table|chart|details|more|data|rows)$/i â€” and that each is a question or names its contents.

### `probe:494` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R9.1] buy leg names its binding cap and the touch count
**Requirement:** [R9.1]

**Evidence.** Probe line 496: `q9.touches === Math.ceil(q9.need / q9.buyQty)`. Production, index.html:4965: `touches = Math.ceil(need / buyQty);`, with `need` and `buyQty` returned on the same object (index.html:4972). The probe re-derives the expected value with the identical expression over the identical two fields â€” the seventh face's tell, computing rather than calling. The sharper consequence here is that the conjunct is INVARIANT to defects in its own inputs: if `buyQty` were mis-sized (it is a `Math.min` of need, capFlow, capLimit and thirdCap at index.html:4953) or `need` mis-computed (index.html:4950), the probe recomputes the expectation from the same wrong values and the relationship still holds. The other two conjuncts of this assertion are sound â€” `buyQty < need` plus `/participation cap/` on the note is a real discrimination, because production only writes that phrase when `buyQty === capFlow` (index.html:4961), so the copy names which clamp bound the leg and the assertion checks the copy.

**Could it pass with the property absent?** For the touches conjunct only: any defect that corrupts `need` or `buyQty` propagates into the probe's own expectation, so the equality survives; and any change to production's touches formula that the probe author mirrors survives by construction. The conjunct can fail only on an inconsistency between `touches` and the two fields returned beside it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the walk-back term in production â€” `const walkBackTouches = (need, buyQty) => Math.ceil(need / buyQty);` â€” point a scaling assertion at it (halving buyQty at fixed need does not decrease touches and roughly doubles it; touches is 1 when buyQty >= need), and keep the equality against `q9.touches` only as an explicit WIRING assertion that says so in its label. Tier is 'other' because the defect I am reporting concerns the advisory touch count; the sizing half of this assertion (the participation cap on the buy leg) is money and reads sound to me.

### `probe:893` — face9 — could-pass: **yes** — confidence: medium

**Label:** matrix shows the co-moving pair strong

**Evidence.** The assertion is `/class="num pos"/.test(det)` where det is the entire #cluDetail innerHTML (probe-snippet.html:890). The subject named in the label is one cell â€” the 9001x9002 pair; the cluster under test is {9001, 9002, 9004} with 9004 the divergent member (probe-snippet.html:880-882). Production is index.html:11414-11427: the matrix emits `class="num pos"` for ANY pair whose correlation clears thr, once per ordered pair, so the matrix contributes up to six cells and the regex cannot say which one matched. Applying the ninth face's generalisation directly â€” 'if the assertion would pass with the property deleted from its subject but present elsewhere, the container is too broad' â€” a defect that transposed the pair indices in pairCorr (index.html:11404-11409) would move `pos` off the 9001x9002 cell and onto another and this assertion would still pass. I checked the rest of the container: the decay view emits `class="num"` without pos (index.html:11448) and the overlay emits no num classes at all (11473-11478), so today the matrix is the only source â€” but that is a property of the current fixture and renderer, not of the assertion.

**Could it pass with the property absent?** Determined by reading index.html:11398-11427 (matrix construction, symmetric double loop) and 11429-11479 (the other two views, which emit no `num pos`). The assertion cannot distinguish which cell is positive. Confidence is medium rather than high because in the CURRENT fixture 9004 is built to diverge, so the only pos cells are in fact the 9001x9002 pair â€” the assertion is de-facto specific by accident of the fixture, which is precisely the fragility the ninth face names.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Narrow to the cell, in the blendFrag idiom the probe already uses (probe-snippet.html:19-28): parse det into a div and read the matrix cell for the pair by position â€” tbody row index of 9001, cell index of 9002 â€” asserting that cell's classList contains 'pos'. Better still, follow the strataCount()/calibWindow() extraction pattern: pairCorr is a closure inside clusterDetailHTML (index.html:11404) and cannot be called from the probe, so extract it as a named clusterPairCorr(excess, a, b) and assert BOTH the returned value for the named pair and the rendered class of that pair's cell. Unproven until a transposition seed has been watched fail.

### `probe:1268` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R2.1] below-baseline series reads DISCOUNTED
**Requirement:** R2.1

**Evidence.** Production boundary is index.html:13383: `(st.priceVs != null && st.priceVs <= -2) ? "DISCOUNTED"`. The âˆ’2% figure is a ratified strategy parameter â€” CLAUDE.md records it under 'Disclosure-in-summary is not ratification' as M028, 'entry-watch DISCOUNTED set to â‰¤ âˆ’2% in-flight, ratified after the fact'. The fixture at probe-snippet.html:1172 is mkSlvDays(40, i => i<26 ? 1000 : 900), which gives last7m = 900 against basem = 1000, i.e. priceVs = exactly âˆ’10. The assertion's own guard is `stDisc.priceVs < -5`. The nearest assertion on the other side is stFlat at probe-snippet.html:1168-1170, priceVs â‰ˆ 0, asserted "neutral". So the boundary is pinned only at 0 from above and âˆ’10 from below: seed `<= -2` â†’ `<= -9` and both assertions stay green. I grepped the whole probe file for entryVerdict (hits at 1170, 1174, 1177, 1919-1924 only) â€” 1919-1924 pass the verdict string in as a literal to noteEntryVerdict and do not exercise the boundary at all, so nothing else in the suite pins it.

**Could it pass with the property absent?** Determined by reading index.html:13382-13384 and 13352-13358 (median-based baseline), computing the fixture's priceVs, and grepping every entryVerdict call site in the probe. A ratified constant can drift across an 8-point band with the suite green. Note this is exactly the 'ratification that breaks no test is not evidence' shape at one remove: the boundary that was ratified is not the boundary the fixture stands near.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Pin the boundary the way probe-snippet.html:1187 already pins the exit-liquidity one and 1097 pins the rung one: add a straddling pair just either side of âˆ’2 â€” a series yielding priceVs â‰ˆ âˆ’2.5 asserted DISCOUNTED and one yielding â‰ˆ âˆ’1.5 asserted neutral â€” and keep the âˆ’10 case as the clear-cut example. Do the same for the >= 5 RAMPING leg, which has the same 0-to-+10 unpinned band. Unproven until a one-point shift of the constant has been seeded and watched fail.

### `probe:1531` — face1 — could-pass: **yes** — confidence: medium

**Label:** [R5.2] priority: expiring intel â†’ sleeve rung â†’ cluster
**Requirement:** R5.2

**Evidence.** Assertion: `items5.findIndex(x => /^intel:/.test(x.key)) < items5.findIndex(x => /^rung:/.test(x.key)) && items5.findIndex(x => /^rung:/.test(x.key)) < items5.findIndex(x => /^clu:/.test(x.key))`. findIndex returns -1 when no element matches, and -1 compares less than every non-negative index. If the intel queue stopped contributing a line entirely, the first comparison becomes `-1 < rungIdx` = true and the assertion passes with its highest-priority subject absent. (The other two directions do fail correctly: a missing rung makes `intelIdx < -1` false, a missing cluster makes `rungIdx < -1` false.) Partial mitigation in the neighbouring assertion at line 1432, which requires `items5.some(x => /data-intelrat/.test(x.html))` â€” so an intel line vanishing would be caught there, by a different assertion with a different label.

**Could it pass with the property absent?** The property named is an ORDERING among three queue classes. With the intel class absent, no ordering has been demonstrated and the assertion is green. This is the sentinel making the interesting half unreachable rather than a fixture problem. Determined by reading the assertion form; no production read needed.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Bind the three indices to named consts and require each to be â‰¥ 0 before comparing: `const iI = â€¦, iR = â€¦, iC = â€¦; ok(â€¦, iI >= 0 && iR >= 0 && iC >= 0 && iI < iR && iR < iC, â€¦)`. That makes 'all three queues are present AND ordered' one claim, which is what the label says.

### `probe:1978` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R29.2] the gap-band slice samples 250kâ€“1m â€” the band between the T2 ceiling and the anomaly scan's >1m floor
**Requirement:** R29.2

**Evidence.** The exclusion half is `gb.pick.every(c => c.buy >= GAP_LO && c.buy <= GAP_HI)`. Production filters with the identical predicate on the identical constants: `if (c.buy < GAP_LO || c.buy > GAP_HI) continue;` (index.html:2689), with `GAP_LO = 250_000, GAP_HI = 1_000_000` (index.html:2582). The probe restates the product's own filter using the product's own symbols, so the clause is a tautology unless the filter is deleted outright. The fixture also adds only one in-band item (9404 at 500k, probe 2813-2815); every other probe item sits near 4,000gp, so there is no near-miss decoy the band has to exclude.

**Could it pass with the property absent?** The label names a literal band. Widen GAP_LO/GAP_HI to any range containing 500,000 and both clauses still pass â€” `some(c => c.id === 9404)` because 9404 is still in range, `every(...)` because it re-reads the widened constants. The rendered-copy assertion at probe 1823 does not save it either: that one requires the string 'gap band 250kâ€“1m' to be PRESENT, so a constant change with unchanged copy leaves both assertions green and the copy false â€” which is also a scan-7 claims-vs-computation exposure.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Two parts. (a) Pin the constants to the literals the copy and the label claim, once: `GAP_LO === 250_000 && GAP_HI === 1_000_000`, so a band change goes red beside the copy that names it. (b) Give the fixture the decoys and assert absence: seed one item just below GAP_LO and one just above GAP_HI into S.items and assert neither appears in gb.pick.

### `probe:2212` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R14.2] catalyst-attached basket badges its catalyst; catalyst-less basket reads standing
**Requirement:** R14.2

**Evidence.** `ledger14` is the entire `#cluBody` innerHTML with TWO baskets rendered (probe 2043-2050). The subject of the first half of the label is the attached basket's row, but the badge is matched as `/âš¡ Basket Event/.test(ledger14)` â€” anywhere in the ledger. Only the third clause is row-scoped, and it is scoped to the OTHER basket (`standing-basket</b> <span class="badge b-seed"...>standing`).

**Could it pass with the property absent?** Move the catalyst badge to the wrong row â€” render `âš¡ Basket Event` on standing-basket and drop it from attached-basket â€” and the assertion stays green: `/attached-basket/` still matches its name, `/âš¡ Basket Event/` still matches somewhere in the container, and standing-basket can carry both its standing badge and the stray catalyst badge. The fixture deliberately holds two baskets (which is right, per the tenth face it is the decoy that makes a scoping seed discriminate), and the assertion does not use it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add a row-locating helper in the same shape as blendFrag â€” locate the ledger row for basket id 21 and match `âš¡ Basket Event` inside that fragment only â€” and add the absence half: the badge must NOT appear in basket 22's row.

### `probe:2376` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R17.4] statistical member is excluded from catalyst-linked narratives but chips show Â·S
**Requirement:** R17.4

**Evidence.** The chip half is `/Â·S/.test(... document.querySelector("#cluBody").innerHTML ...)` â€” a two-character pattern matched against the entire cluster ledger body, with no binding to item 9004 whose class the label is about. Production renders the marker per member; the exclusion half of the assertion is correctly scoped (it calls catLinkedIds and names 9004 and 9001), so the two halves are held to different standards.

**Could it pass with the property absent?** Delete the Â·S marker from 9004's chip and the assertion passes as soon as any other element in #cluBody contains 'Â·S' â€” another statistical member, a legend, a note. In the fixture as built only 9004 is statistical (mclass reset at probe 2201), so today the fixture is what saves it, not the assertion; per the tenth face that also means a scoping seed here could not discriminate. I could not rule out a legend or caption in the ledger carrying the same glyph, having not read the full renderClusters output.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Locate 9004's own chip (its data attribute) in the same shape as blendFrag and match Â·S inside that fragment; add a thesis member as decoy and assert its chip does NOT carry the marker.

### `probe:2416` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R17.4] mclass, cohLog, and cohProps (with dismissal state) survive exportâ†’import
**Requirement:** R17.4

**Evidence.** `validateImport({...})` is called on a payload hand-written in the probe (probe 2253-2255); the export half of the round trip is never invoked. Production's export is `new Blob([JSON.stringify(DB, null, 2)], ...)` at index.html:19244, and the import mapping for these fields lives at index.html:19680-19703. The same shape covers [R17.5] at probe 2260-2262, which asserts dismissedC and the resurface copy survive using the same hand-built object.

**Could it pass with the property absent?** The label's subject is a round trip and only the return leg runs. If production wrote the field under a different name, or nested it differently, or stopped writing it, the probe's payload would still carry the name validateImport maps and the line would stay green while a real export lost the field. The risk is bounded â€” the exporter is a whole-DB JSON.stringify, so it cannot selectively drop a field â€” which is why I call this medium rather than high; the live exposure is drift between what production WRITES onto cohProps/clusters and what the probe hand-writes.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Build the state through production (upsertCohProp, the confirm press, the dismiss press), then round-trip the real object: `validateImport(JSON.parse(JSON.stringify(DB)))` and assert the fields survive. That exercises both legs and removes the probe as the payload's author.

### `probe:3032` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R22.7] no row renders more than four indicator slots (dots share the fourth; empty slots are not indicators)
**Requirement:** R22.7

**Evidence.** Probe 2804-2812 defines `slotCount` in the probe: `tags.querySelectorAll(".badge").length + (tags.querySelectorAll(".sdot, .tdot").length ? 1 : 0)`, then asserts `allRows22.every(r => slotCount(r) <= 4)`. The probe line COMPUTES the budget rather than CALLING anything â€” the four-slot scheme lives only as a comment and an emitter order in production (index.html:11028-11039), with no named function that enumerates or counts the slots a row renders. The probe therefore carries a private, closed list of what an 'indicator' looks like: `.badge`, `.sdot`, `.tdot`.

**Could it pass with the property absent?** The property is the â‰¤4 slot budget, which is a BINDING-adjacent attention constraint. Add a fifth indicator to `.tags` under any class the probe's list does not name â€” a `.memchip` (already used at index.html for baskets), a `.chip`, a bare `<span>` glyph â€” and `slotCount` returns 4 while the row renders 5, so the assertion passes with the budget breached. Separately, given today's emitter set the maximum reachable slotCount is exactly 4 (status badge + identity badge + riskChip = 3 `.badge` + 1 dot cluster), so the `<= 4` half is currently unfalsifiable by any change that does not add a `.badge`; only the companion `slotCount(row9001) === 4` can move.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Extract the slot inventory into production and render from it: a named function (e.g. `rowSlots(w, c, sp, P)`) returning the ordered list of slot fragments, with index.html:11033-11039 built by joining it, and the assertion reading `rowSlots(...).length <= 4`. That is the `strataCount()` / `calibWindow()` pattern â€” the extraction is the fix, not a convenience â€” and it makes a new indicator visible to the budget check by construction instead of by the probe remembering to add its class. Seed by adding a fifth slot to the production list and confirming the assertion goes red BEFORE counting it proven.

### `probe:3246` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R25.1] toxic-flow verdict: >=3 marked-out fills, adverse markout beyond the threshold
**Requirement:** R25.1

**Evidence.** Probe 3021-3025 seeds exactly three flips (`[0,1,2].map(...)`) against a crafted markout series and asserts `!!tox25 && tox25.n === 3 && tox25.adverse < 0`. Production `toxicFor` (index.html:7165-7176) carries TWO gates: `if (!mk || mk.n < 3) return null;` and `const toxic = marginPU > 0 && ((mk.avg30 != null && -mk.avg30 > mx * marginPU) || (mk.avg2h != null && -mk.avg2h > mx * marginPU))` with `mx = Math.max(0.05, DB.markoutX || 0.5)`. The label names both gates; the fixture contains only a case that clears both, and the slice holds no counterexample item.

**Could it pass with the property absent?** `tox25.n === 3` is a property of the fixture (three seeded flips), not of the `mk.n < 3` gate â€” delete that line and this assertion is unchanged. `tox25.adverse < 0` is a property of the crafted series, not of the `> mx * marginPU` comparison â€” set `mx` to 0, or drop the multiplier entirely, and the same fixture still returns a verdict with a negative adverse, so the assertion stays green with 'beyond the threshold' gone from the subject. I could not find a sub-threshold or two-fill counterexample anywhere in 2409-3030; one may exist outside my slice, which is why I have not called this high confidence.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the two counterexamples the fixture is missing, so each gate can express a defect: (a) an item with 2 marked-out fills and an identically adverse series â€” `toxicFor` must return null, which is the only thing that can kill the `mk.n < 3` gate; and (b) an item whose adverse markout sits just INSIDE `mx * marginPU` â€” `toxicFor` must return null, which is the only thing that can kill the threshold comparison. Assert the threshold's own arithmetic against `tox.mx` and `tox.marginPU`, which production already returns, rather than restating 0.5 in the probe.

### `probe:3458` — face7 — could-pass: **yes** — confidence: medium

**Label:** [R29.6] the per-stratum map carries the standing caveat, with counts derived from the strata table
**Requirement:** R29.6

**Evidence.** The middle conjunct at probe 3238 is `STRATA_APPROX_N === STRATA.filter(s => !!s.rx).length`. index.html:2633 is literally `const STRATA_APPROX_N = STRATA.filter(s => !!s.rx).length;`. STRATA is a build-time const array, so the probe is re-evaluating the definition and comparing it to itself: the conjunct is constant-true and cannot fail. The limb whose job is the label's 'counts derived from the strata table' is the one that performs no verification.

**Could it pass with the property absent?** Replace the derived STRATUM_CAVEAT (index.html:2634-2635) with a hardcoded string literal '19 of 21 strata are name-pattern approximations â€” directional, not a census.' and ALL THREE limbs stay green: the regex matches the literal, the self-comparison is still true, and STRATA.length === 21 is still true. Derivation â€” the exact property in the label â€” is therefore unverified. The assertion is not dead overall: adding a stratum breaks the hardcoded /19 of 21/ regex and the STRATA.length === 21 limb, so drift IS caught, just not by the limb that claims to catch it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Delete the self-comparison and build the expected copy from the production constants instead of hardcoding it: assert prosp25 contains STRATA_APPROX_N + ' of ' + STRATA.length + ' strata are name-pattern approximations'. That makes a hardcoded caveat string fail the moment STRATA changes, without requiring the probe to be edited alongside, and removes a conjunct that reads as proof of a derivation it never checks.

### `probe:3480` — face8 — could-pass: **yes** — confidence: medium

**Label:** [R53.1] the per-cycle sample is 10, and the copy states the number it actually draws
**Requirement:** R53.1

**Evidence.** The limb at probe 3266 is `gapBandSample().pick.length <= 10`. gapBandSample (index.html:2683-2693) admits only items whose calc().buy falls inside [GAP_LO, GAP_HI] = [250_000, 1_000_000] (index.html:2582), then returns seededDraw(pool, GAP_BAND_N, 7919) where seededDraw takes k = Math.min(n, pool.length) (index.html:2662). The suite runs with all external DNS blocked â€” tools/probe/run.sh:48, `--host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"` â€” so S.items holds only what the fixture pushed. Searching the whole probe file for prices in that band found exactly one seeded member: 9404 at buy 500_000 (probe 1813-1815). A pool of ~1 against a draw cap of 10 is the trim-over-60-behind-a-cap-of-24 shape: the cap has no work to do.

**Could it pass with the property absent?** Change index.html:2662 to Math.min(3, pool.length) and nothing observable changes here, because pool.length is ~1. The `<= 10` bound is also the wrong predicate for the claim in its own label â€” 'the number it actually draws' is an exact value, and a bound leaves the entire under-draw half unreachable, so even with a large pool it could not detect a draw of 3. I could not exhaustively enumerate every fixture item's buy price without running the suite; the ~1 figure rests on a text search of the probe for gap-band prices, which is why this is medium and not high.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. gapBandSample already returns poolN â€” use it: assert pick.length === Math.min(GAP_BAND_N, poolN), which is exact rather than bounded and needs no probe-side arithmetic. Then seed at least GAP_BAND_N + 1 items into the 250kâ€“1m band so the cap actually binds, and add a standing assertion that poolN > GAP_BAND_N so the fixture cannot quietly shrink back below the cap (the same guard the ninth-face repair put on its decoy blend). Same predicate appears at probe line 1820 and is reported as adjacent.

### `probe:3749` — face11 — could-pass: **yes** — confidence: medium

**Label:** [R27.3] regime divergence reads 'candidates earned probation slots', never 'the regime is right'
**Requirement:** R27.3

**Evidence.** The label states a prohibition ('never "the regime is right"') but every limb is a REQUIRED phrase: /earned probation slots/, /not proof the regime is right/, /moves only on your ruling/ against evd27.html. There is no forbidden-phrase limb. The contrast is two assertions later in the same slice: [R27.1] at probe 3510-3511 does carry a negative match (`&& !/evidence accruing/.test(...)`), so the pattern is understood elsewhere in this block and simply absent here.

**Could it pass with the property absent?** This is the R62.6 shape exactly: rewrite another sentence in evd27.html to claim the loose regime IS right, leave the three asserted phrases in place, and the suite stays green while the surface asserts the opposite of the rule it is policing. Note the obvious negative match is unavailable as written â€” the required phrase 'not proof the regime is right' contains the forbidden substring â€” which is probably why none was added.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Forbid the contradicting CLAIM rather than the substring: add `&& !/\b(the regime is right|regime is validated|regime proven)\b/.test(evd27.html.replace(/not proof the regime is right/g, ''))`, or restructure so the required sentence is matched inside its own element and the prohibition is scoped to the rest of the block. Prove by seeding a contradicting sentence into the first half of the note and confirming the old form passes and the new form fails.

### `probe:3960` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R32.1] the review panel names the stalled streams and states the open-and-visible dependency
**Requirement:** R32.1

**Evidence.** `/Shadow trips/.test(fi32)` runs against the whole freshnessInline() output. The label's subject is the stale banner, which names the stalled streams at index.html:9941-9944 (`stale.map(r => esc(r.name) + ' (' + ago(r.at) + ')')`). But every stream, stalled or not, is also listed by name in the per-row loop at index.html:9949-9951, so 'Shadow trips' is present whether or not the banner names anything. A defect that rendered the banner with an empty name list â€” `stale.length` still > 0 so `/streams? behind schedule/` still matches â€” would leave this green. The other conjuncts do not help: /VISIBLE/ and /skips entirely while the tab is hidden/ both come from the standing teach() block at index.html:9939-9940, which renders unconditionally on every call.

**Could it pass with the property absent?** Traced both emission sites. The banner's naming is the property; the per-row list is an independent satisfier of the same pattern.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Match 'Shadow trips' inside the banner element only â€” give the banner a data attribute and locate it the way blendFrag locates a drill face â€” rather than against the panel string. The companion data-level check already exists at probe:3730, so the copy assertion should be about the banner and nothing else.

### `probe:4188` — STALE — could-pass: **yes** — confidence: medium

**Label:** [R35.4] Prospecting carries the stratum map, the gap-band verdict, the hours ledger and the recipe basis, each on its own panel
**Requirement:** R35.4

**Evidence.** The label claims Prospecting carries 'the recipe basis, each on its own panel'. The assertion's fourth conjunct is `!document.querySelector('#prospectRecipePanel')` with an inline comment 'the recipe monitor was WITHDRAWN, not relocated (ruled Aug 11 2026)' â€” it asserts the panel's ABSENCE. CLAUDE.md's surface map records the same: 'the recipe basis was withdrawn Aug 11 2026 and the copy that still advertised it was removed Aug 13 2026'. I confirmed #prospectRecipePanel appears nowhere in index.html. The absence check itself is correct and is the scoping-by-absence discipline working; the defect is the assertion NAME, which is what the probe report prints. A green line reading 'Prospecting carries â€¦ the recipe basis' is a report making a claim about the product that is false â€” the metric-honesty rule applied to the suite's own copy. Secondary, same line: the third conjunct `/Two streams, different natures|No hour-of-day data yet/` permits the panel's empty state to satisfy it, an escape hatch the very next assertion (3973) explicitly refuses with `!/No hour-of-day data yet/`.

**Could it pass with the property absent?** The property named in the label (the panel carries a recipe basis) is not merely absent from the subject â€” the subject asserts its negation. There is no code change that could make the label true and the assertion pass.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Rewrite the label to state what is asserted, e.g. '[R35.4] Prospecting carries the stratum map, the gap-band verdict and the hours ledger, each on its own panel â€” and the withdrawn recipe monitor is absent, not relocated'. Separately, remove the empty-state alternation from the hours conjunct so this assertion cannot pass on a panel that rendered nothing; the fixture already seeds hour-of-day data at probe:3834-3837.

### `probe:4195` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R35.4] the hours table keeps the two streams distinct and unobserved hours read no data, never bad hour
**Requirement:** R35.4

**Evidence.** Same shape as the finding at line 3659, on the Prospecting copy of the panel. `/no data â€” never observed/.test(h)` runs against the whole #prospectHours innerHTML. That exact phrase is emitted from two places in production: the unobserved-hour cell (index.html:9823) and the widest-hours summary line (index.html:9794, '(shadow: no data â€” never observed)'). Which one satisfies the match depends on the fixture's clock: the R35 fixture seeds roiHour peaks at hours 3 and 11 (probe:3835) while all its trips land at the hour the suite happens to run (mk35 sets t from now35 minus whole days, probe:3822), so the top-3 market hours normally have n = 0 and the summary line carries the phrase regardless of what any table cell renders. This assertion does carry the negative match `!/No hour-of-day data yet/`, which correctly forbids the empty panel â€” the weakness is only in the positive match's container.

**Could it pass with the property absent?** Change the cell rendering at index.html:9823 and the widest-hours line at 9794 still satisfies the pattern. The clock dependence is a secondary tell (fifth face flavour): which container satisfies the match varies with the hour the suite runs.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Scope the positive match to a specific #hoursTable row known to have zero paper trips, and forbid /bad hour/ inside that row. Keep the existing negative match on the empty panel.

### `probe:4360` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R36.4] the seed audit's own recommendation is what executes â€” nothing is invented for it
**Requirement:** R36.4

**Evidence.** Two problems, one fixture. (a) The probe sets `DB.sibBorn = { 9002: now36 - 40 * 86400e3 }` (probe:4134) â€” a bare number. Production writes sibBorn as `{seed, t}` objects: declared 'itemId â†’ {seed, t}' at index.html:1260 and written as `DB.sibBorn[x.id] = { seed: seedId, t: now }` at index.html:10594. seedAudit reads it as `if (v && v.seed === id) kids.push(...)` (index.html:11777); a number is truthy but has no .seed, so kids is always empty and the spawned/graduated/washed limbs (11793-11794) never execute. (b) With DB.flips = [] (probe:4135), `trading` is 0 and `lastTrade` is 0, so `cold` is true and `lineage14` is 0 â€” seedAudit's branch order (index.html:11797-11809) pins rec to RETIRE deterministically. The assertion is written as a disjunction `(seedRec36 === 'RETIRE' && ...) || (seedRec36 === 'KEEP' && ...)`, so the KEEP arm is dead code that reads as coverage; and the KEEP arm is markedly weaker than the RETIRE arm (it requires only that a log entry exists).

**Could it pass with the property absent?** The named property is 'the audit's own recommendation is what executes'. It is proven on exactly one of the three recommendations production can emit, and the fixture's malformed sibBorn means the lineage limbs that distinguish the recommendations never run. I could not determine whether the malformed shape was deliberate shorthand or an unnoticed drift â€” the probe elsewhere (e.g. probe:1418) also assigns DB.sibBorn = {} wholesale, which gives no evidence either way.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Write sibBorn in the shape production writes ({seed: 9001, t}) so the kids limbs execute, then split the disjunction into separate assertions with fixtures that force each recommendation â€” RETIRE (cold, flat), KEEP (recent lineage P&L) and PROMOTE (three trading members, which also repairs the dead assertion at 4145) â€” asserting seedAudit()'s rec first so each fixture proves it reached the branch it claims to test.

### `probe:4601` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R38.7] the find box filters entries and keeps the groups it matched
**Requirement:** R38.7

**Evidence.** Condition: entry count > 0, entry count < glAllEntries.length, and /markout/i present in #glBody textContent. All three concern ENTRIES. The label's second clause â€” 'and keeps the groups it matched' â€” is about group containers surviving the filter, and nothing counts, locates or inspects a group element. A find implementation that flattened every match into a bare list, discarding the grouping the glossary is organised by, passes green.

**Could it pass with the property absent?** Read the assertion's three conjuncts at probe 4380-4382; none reference a group selector (compare 4334-4343, which does use #glgrp-* ids, so the selector exists and is available).

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the group half: assert that the surviving #glgrp-* containers are exactly the groups whose entries matched â€” count > 0, and every rendered .glent's group id is among them. Prove it by seeding a flattening change to the find handler; the entry-count conjuncts must stay green while the new one fails, which is the discrimination the tenth face demands.

### `probe:4660` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R39.3] no popover scrolls, at this viewport, for any glossed term
**Requirement:** R39.3

**Evidence.** The loop at probe 4431-4437 taps every glossary term and pushes to tall39 only when `p.scrollHeight > p.clientHeight + 1`. A popover that never OPENED has scrollHeight and clientHeight both 0 (the sibling assertion at 4490 asserts exactly that a closed popover paints a 0x0 box), so 0 > 1 is false and the term contributes nothing. tall39.length === 0 therefore means either 'no popover scrolled' or 'no popover opened', and nothing counts how many actually opened. The label says 'for any glossed term' â€” a per-term claim â€” so a single term whose popover silently fails to open is invisible here.

**Could it pass with the property absent?** Read the loop and the closed-popover geometry assertion at 4490 in the same fixture. [R39.1] at 4415 and [R39.6] at 4483 do prove the popover opens for gate-price and paper-book, so a total failure of the mechanism would be caught elsewhere; a per-term failure would not. That is why this is medium rather than high.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Count the opens in the same loop (`let opened = 0; if (popOn()) opened++;`) and assert `opened === glEntryById.size && tall39.length === 0`. A term that fails to open then fails by name rather than being counted as not-scrolling.

### `probe:4782` — face2 — could-pass: **yes** — confidence: medium

**Label:** [R39.9] nor are the expand view's caution lines, which already render their reason inline
**Requirement:** R39.9

**Evidence.** The condition is a single negative: `!/data-glt="ind-caution"/.test(h)` where `h = tr ? tr.innerHTML : ""` (probe 4563-4566). Two independent ways to pass without the property: the detail row does not render (h === "", the negative match trivially holds), or the row renders but the fixture item carries no caution lines at all, so there is nothing that COULD have been glossed. Neither is checked. Note also that grepping index.html for `ind-caution` returns exactly one hit â€” the GLOSSARY definition at index.html:16017 â€” and no render path emits data-glt="ind-caution" anywhere, so today the forbidden string is not producible by any code. The assertion's value is as a guard against a future change adding the gloss; that value is real, but it is unprotected against the fixture going empty underneath it. Its sibling at 4558 does carry a positive control (/data-wdetail=/), which makes the omission here look inadvertent.

**Could it pass with the property absent?** Read the IIFE at probe 4561-4566 and grepped index.html for ind-caution (one hit, the glossary entry). I could not determine without running the suite whether item 9001 in this fixture actually produces caution lines in the expand view â€” that is the specific thing I could not establish.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the positive control the absence claim needs: assert `!!tr` and that the row's HTML contains at least one caution line (the same marker riskChip uses, data-wdetail or the âš  reason element), THEN assert the gloss attribute is absent from it. This is the project's own absence-assertion discipline â€” an absence proved on an empty container proves nothing.

### `probe:5008` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R40.8] the equity panel shows gp/day BESIDE gp/minute, and states the denominator change
**Requirement:** R40.8

**Evidence.** Four regexes against #eqHero innerHTML. Three of them match template text that renderEquity emits UNCONDITIONALLY: index.html:15342 always writes 'gp per day â€” the throughput side' as a static <div class="k">, and index.html:15347-15349 always writes 'Denominator changed <b>Aug 11 2026 â€” cadence</b>â€¦'. Those three can fail only if someone edits the literal. Only /attention-minutes/ is state-dependent (index.html:15339, inside the `attMin ?` branch). So the label's 'shows gp/day BESIDE gp/minute' passes with the gp/day VALUE rendering 'â€”' (index.html:15343, the `perDay != null` guard), which is the never-pool rule's decomposition failing to render while the assertion reports it present.

**Could it pass with the property absent?** Read renderEquity at index.html:15335-15349 and mapped each of the four regexes to the line that produces it. The unconditional/conditional split is legible from the template.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Assert the VALUES, not the labels: locate the two <div class="v"> elements and assert each holds a formatted number rather than 'â€”' (the fixture must have both a logged flip and a logged day for that to be meaningful). Leave the denominator-change note as its own assertion with an honest label saying it checks that the standing note is present, since that is all a match on unconditional copy can claim.

### `probe:5518` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R42.5] every section declares its cap â€” including the ones that were NOT truncated
**Requirement:** R42.5

**Evidence.** The label says EVERY section; the condition is `Array.isArray(H.truncation) && H.truncation.length >= 1 && H.truncation.every(t => â€¦shapeâ€¦) && H.truncation.some(t => t.truncated === false && /\(complete\)/.test(t.note))`. The `every` runs over the rows that ARE present, so it checks the shape of declared rows, never that all capped sections declared one; the coverage claim rests on `length >= 1` plus a single `some`. There is a live counterexample in the export today: index.html:17930 truncates each gate item's flip list with `flips: (it.flips || []).slice(-ANALYSIS_CAPS.flips)` (cap = 12, index.html:17616) and pushes nothing into `trunc` â€” every other cap goes through `analysisCap` (index.html:17620-17629), which is what writes the ledger row. So a section is silently capped right now and this assertion is green.

**Could it pass with the property absent?** Remove the truncation row for any single section â€” or add a new capped section without a row, which is what already happened for `flips` â€” and the assertion still passes as long as one row survives and one of them is a complete/untruncated row. I read `analysisPaper` (17846-17850), `analysisGates` (17920-17936) and `analysisProspecting` (17971-17979) and found four `analysisCap` call sites plus the one un-ledgered `slice` at 17930; I did not enumerate every capped array in the payload, so the count of undeclared sections may be higher than one.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Assert set equality rather than presence: derive the expected section labels from the caps actually applied (the cleanest form is to route the `flips` cap through `analysisCap` too, so that `trunc` is by construction the complete list, then assert `H.truncation.map(t => t.section).sort()` equals the expected list for each view). That converts the claim 'every section declares its cap' into something a missing declaration can fail. Prove by seeding: drop one `analysisCap` call's sink push and confirm red â€” and confirm the seed is observable, since the current form would stay green for exactly that seed. Separately, the `flips` gap at index.html:17930 is a live interrogability finding and is reported in adjacent.

### `probe:5911` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R43.3] the export reports never-filled per hour and per stratum
**Requirement:** R43.3

**Evidence.** The condition is `analysisPayload('prospecting').hoursLedger.some(h => h.paperTripsNeverFilled === 1)`. Two gaps against the label. (a) The 'per stratum' half is never read â€” nothing in the condition touches a stratum rollup. (b) `.some()` over the 24-hour array accepts the count on ANY row, so a count attributed to the wrong hour satisfies it; the fixture's three trips are all in one known hour (probe 5678-5681) and that hour could be named.

**Could it pass with the property absent?** Drop never-filled from the per-stratum export entirely and this assertion is green, because it only reads hoursLedger. Mis-attribute the hour bucket and it is still green, because .some accepts any row. I did not read analysisPayload's prospecting branch to confirm a per-stratum never-filled field exists at all â€” if it does not, the label is claiming coverage of something unbuilt, which is the seasoning-gate shape; I could not determine that within this slice.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Match the specific hour row (find by h, then assert paperTripsNeverFilled === 1 on it) rather than .some over all 24. Then either add the per-stratum conjunct â€” asserting the stratum rollup carries its own never-filled count â€” or narrow the label to what is checked. Confirm first whether the per-stratum field exists; if it does not, this is a requirement claiming an implementation rather than a weak assertion.

### `probe:6640` — face3 — could-pass: **yes** — confidence: medium

**Label:** [R61.6] one tap opens a fold and the rows inside are then VISIBLE, not merely in the DOM
**Requirement:** R61.6

**Evidence.** The assertion computes `closedFirst = det.open === false`, `rowsInside = det.contains(btn)`, `openAfter = det.open === true` â€” all structural DOM state, as the in-probe comment at lines 6386-6391 openly concedes ('Structural, not measured'). The label claims the opposite: 'VISIBLE, not merely in the DOM'. The comment's justification is real (headless layout of a closed `<details>` is engine-dependent), but the closed case is the only one that is engine-dependent â€” visibility AFTER opening is measurable via `offsetParent`/`getComputedStyle` and is not asserted.

**Could it pass with the property absent?** A stylesheet rule hiding `.foldbody` unconditionally would leave `det.open`, `det.contains(btn)` and the open transition all true, and the rows invisible. That is the third face's exact failure mode, and the label is the half that claims otherwise.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Keep the structural checks for the closed state and add a computed-visibility check for the OPEN state only: after `det.open = true`, assert `btn.offsetParent !== null` and `getComputedStyle(btn).visibility !== 'hidden'`. Failing that, weaken the label to what is actually asserted, so the report does not claim visibility coverage it does not have.

### `probe:6692` — face9 — could-pass: **yes** — confidence: medium

**Label:** [R60.2] the load-bearing half stays VISIBLE â€” a conditional warning is never demoted to a disclosure
**Requirement:** R60.2

**Evidence.** The narrowing step removes only the FIRST disclosure: `const det = d.querySelector('details.teach'); const outside = c.replace(det ? det.outerHTML : '', '')`. `calibSellHTML` appends `sellDiscriminatorHTML(c)` at index.html:8537, which carries further teach blocks, so the correction marker could sit inside a LATER disclosure and the assertion would still find it in `outside`. Second-order: `c.replace(det.outerHTML, '')` string-matches a DOM-serialized fragment against the original source string; any normalization during the innerHTML round-trip makes the replace a silent no-op, and `outside` becomes the whole HTML â€” a broad container that reads as a narrow one, with no signal that the narrowing failed.

**Could it pass with the property absent?** Both holes admit a pass with the marker demoted into a disclosure â€” the exact property the label forbids. I did not verify whether calibSellHTML's output currently contains a second teach before the marker, so the first hole may be latent rather than open today.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Operate on the DOM rather than on strings: `[...d.querySelectorAll('details.teach')].forEach(e => e.remove())`, then assert against `d.innerHTML`. Add a guard asserting at least one teach was actually removed, so a failed narrowing reports rather than widening the container silently.

### `probe:185` — face3 — could-pass: **yes** — confidence: low

**Label:** [R36.1] both still live on the Sleeve tab â€” the machinery moved, it was not deleted
**Requirement:** [R36.1]

**Evidence.** Probe lines 184-188: `setTab("sleeve"); renderAll();` then `/probe-cluster/.test(document.querySelector("#clusterPanel").innerHTML) && /Sleeve stats|No sleeve positions/.test(document.querySelector("#slvHealth").innerHTML)`. This is the PRESENCE half of the [R36.1] absence/presence pair, and it is asserted on innerHTML, not on computed visibility. The third face's incident is the exact scenario this pair sets up: a CSS specificity bug rendered Home's blocks on every tab for a full day behind existence checks, and the ruling is to assert `offsetParent` / `getComputedStyle` on the surfaces whose visibility is the claim. The absence half at line 179 is sound as written â€” it checks for the ABSENCE of substrings in `#ckList`, which is stricter than an element query â€” so the finding is on the presence half only. I rate this low because the constitution's stated form of the rule binds the surfaces that must be CLEAN, and the word doing the work here is 'live'.

**Could it pass with the property absent?** A panel hidden by a CSS rule still carries its innerHTML, so both matches succeed while nothing is visible on the Sleeve tab. The assertion proves the machinery was not DELETED, which is half of what its label claims; it does not prove either panel renders.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add computed-visibility conjuncts to the presence half â€” `document.querySelector("#clusterPanel").offsetParent !== null` and the same for `#slvHealth` â€” alongside the existing content matches, so the assertion claims what its label claims. Prove it by hiding one panel with a style rule and confirming the innerHTML form stays green while the visibility form goes red.

### `probe:272` — face9 — could-pass: **yes** — confidence: low

**Label:** ruled cards rest

**Evidence.** Probe line 272: `ok("ruled cards rest", /rests a week/.test(ckHTML))`, where `ckHTML` (line 269) is the entire `#ckList` innerHTML for the weekly review. Two cards were ruled earlier in the fixture â€” the sibling prune at line 223 (`auditSibAction(9012, "confirm")`) and the seed promote at line 230 (`auditSeedAction(9001, "confirm")`) â€” plus the retire at line 238. One occurrence of the phrase anywhere in the review satisfies all of them. If the rest rule regressed for the seed audit while the sibling audit still rested, the assertion is green.

**Could it pass with the property absent?** The subject is 'ruled cards' plural but the match is a single unanchored phrase against the whole review body; deleting the rest treatment from any one of the three ruled cards leaves the phrase present via the others.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Scope per ruled card â€” locate each card by its ruling key (`seed:9001`, `sib:9012`) and assert 'rests a week' inside that card's own fragment, in the blendFrag idiom. Prove it by removing the rest treatment from exactly one card and confirming the whole-container form stays green while the scoped form goes red.

### `probe:1944` — face7 — could-pass: **yes** — confidence: low

**Label:** [R29.1] the rotation lands on the pinned stratum and the pool is stratum-filtered
**Requirement:** R29.1

**Evidence.** Assertion: `currentStratum().k === "equip:ring" && beyondNetSample().pick.every(c => /ring/i.test(c.name))`. The production membership predicate is the stratum's own regex at index.html:2606 â€” `rx: /\bring\b/i` â€” applied in stratumPool at index.html:2650 (`if (st.rx && !st.rx.test(it.n)) continue`). The probe does not call that predicate; it computes a looser one of its own, `/ring/i` with no word boundaries, which matches 'string', 'earring', 'herring', 'ringmail'. Second, smaller point: `.every` on an empty array is true, so if the ring pool were empty for any reason the filtering half is vacuous â€” the fixture does seed three ring items at probe-snippet.html:1782 via mkItem (buy 4000, volumes non-zero, so they clear stratumPool's band and volume sanity checks at index.html:2653-2654), so this is unlikely today, but nothing in the assertion requires pick.length > 0.

**Could it pass with the property absent?** Delete the word boundaries from index.html:2606 (`/\bring\b/i` â†’ `/ring/i`) and the stratum would start admitting 'string'-class items â€” a real widening of what the discovery slice samples â€” and this assertion would not notice, because the probe's own matcher is at least as permissive as the broken one. Determined by reading index.html:2599-2658 and probe-snippet.html:1776-1787.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Point the assertion at production's own predicate instead of re-deriving it: `const st = currentStratum(); â€¦ pick.every(c => st.rx.test(c.name))`, or extract a named `stratumMatches(st, name)` in index.html used by both stratumPool and the assertion, so the probe cannot drift looser than the filter. Add `pick.length > 0 &&` so the `.every` cannot pass vacuously, and â€” to make the extraction provable â€” put one decoy item in the fixture that the loose regex admits and the production regex rejects (e.g. 'Probe string alpha'), which is the fixture-must-contain-the-decoy rule from the ninth face.

### `probe:3453` — face9 — could-pass: **yes** — confidence: low

**Label:** [R29.3] the per-stratum map accumulates durably and names each region's verdict
**Requirement:** R29.3

**Evidence.** Three limbs, none of which touches a verdict: /equipment Â· ring/ and /id="strataTable"/ against the whole prospectingInline() output, and /Gap band 250kâ€“1m/ against gapBandInline(). The verdict the label names is rendered at index.html:12400-12403 as one of 'prospects', 'barren so far' or 'too few closed trips to say'. The stratum-name limb is also whole-section: any stratum row anywhere in the map satisfies /equipment Â· ring/.

**Could it pass with the property absent?** Delete the `edge` verdict column at index.html:12398-12403 and this assertion is unchanged â€” the stratum name, the table id and the gap-band header all still render. Honest mitigation: the verdict string is checked by the NEXT assertion at probe 3240-3245 ([R29.6]), which requires /prospects/, so the verdict rendering is not globally uncovered. That is why this is low and not medium: the defect is the label overclaiming what its own subject tests, and a reader auditing R29.3 coverage would be misled about which assertion holds it.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Either scope the match to the stratum ROW under test (locate the strataTable row for equip:ring and assert the verdict inside that fragment, the blendFrag pattern applied to a table row), or drop 'names each region's verdict' from the label and let [R29.6] own that property â€” the second is cheaper and removes a false coverage claim rather than adding a check.

### `probe:3628` — face3 — could-pass: **yes** — confidence: low

**Label:** [R26.5] a void-basis exception raises its own walk-up ruling line with both ways out
**Requirement:** R26.5

**Evidence.** The subject is `document.querySelector("#homeRulings").innerHTML` (probe 3405) â€” a DOM-text presence check for a walk-up line the user must READ and rule on. The same slice builds a dotVisible helper (probe 3038-3051) that checks offsetParent, getComputedStyle display/visibility/opacity and the bounding rect, with the comment at probe 3036-3037 stating why: 'the whole defect class here is a surface that exists but shows the user nothing'. That standard is not applied to the rulings digest. Same shape at probe 3332 ([R26.1] the grant proposal) and 3335 (the click target).

**Could it pass with the property absent?** A CSS specificity regression that hides #homeRulings â€” which is precisely the R22.2 incident, Home's blocks and a stylesheet â€” leaves every one of these green while the user sees no ruling line at all. Marked LOW deliberately: innerHTML presence is the house idiom for copy checks throughout the suite, so treating this one assertion as a defect may be out of proportion to how the suite is built, and the remedy is arguably a suite-wide convention rather than a fix here. I report it because the consequence class is higher than a copy check: a restraint the user is never shown is a ruling that never happens.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Reuse the existing pattern rather than inventing one: add a visibleFrag(sel) helper alongside blendFrag that returns a container's outerHTML only when offsetParent !== null and the computed display/visibility/opacity pass, then match the ruling-line regexes inside it. Applying it to the walk-up ruling surfaces first ([R26.1] 3332, [R26.5] 3406) keeps the change bounded. Prove by adding `#homeRulings{display:none}` and confirming the new form goes red where the current one does not.

### `probe:5390` — face9 — could-pass: **yes** — confidence: low

**Label:** [R49.2] and the assertion is scoped to THAT blend â€” the split is inside the fragment, not merely on the page
**Requirement:** R49.2

**Evidence.** The label claims 'the split is inside the fragment'. The condition is `gFrag.length < gs.length && gs.indexOf(gFrag.slice(0, 60)) >= 0` â€” it tests only that the fragment is shorter than the section and that its first 60 characters occur in the section. It never looks at the split text at all. The split-inside-the-fragment property is actually carried by line 5159 (`/watchlist 100% of 2/.test(gFrag) && /slice 0% of 2/.test(gFrag)`) and the decoy that makes the scoping meaningful is held by line 5165.

**Could it pass with the property absent?** Break `blendFrag` so it returns only the button and drops the inline decomposition sibling (probe-snippet.html:27) and this assertion still passes â€” the button alone is shorter than the section and its first 60 chars are still in it â€” while the property in its own label is gone. Line 5159 would go red, so the section as a whole still has coverage; this line specifically claims a property it does not test. Face fit is imperfect and I am flagging that rather than smoothing it: this is not literally a match against too broad a container, it is a condition that does not match the property at all. I am filing it under face9 because it belongs to the same half of the root â€” it ran, on real output, and passed for a reason unrelated to the claim in its name.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Either fold this line into 5159 (whose condition already proves the split is inside the fragment) and delete it, or give it a condition that matches its label â€” e.g. assert the split text is present in `gFrag` AND that `gFrag` is a strict subsequence of `gs`, so a `blendFrag` that silently widened to the whole section would fail. Whichever is chosen, the section keeps the 5165 fixture-decoy assertion, which is what the tenth face requires for the scoping test to remain testable.

### `probe:6212` — face9 — could-pass: **yes** — confidence: low

**Label:** [R45.3] the panel states its three limits rather than working around them
**Requirement:** R45.3

**Evidence.** The third conjunct is `/only ever measurable[\s\S]*going forward/.test(s)` against the whole calibSection() output. `[\s\S]*` is unbounded and crosses sentences, paragraphs and unrelated panels, so the two fragments need not belong to the same claim â€” any later occurrence of 'going forward' anywhere in the section satisfies the second half.

**Could it pass with the property absent?** Rewrite the sentence that begins 'only ever measurable' so it says the opposite of the limit it is stating, while leaving the words 'going forward' in any subsequent sentence, and the match still succeeds. This is the ninth face applied to copy: the container (the whole section, joined by an unbounded gap) is broader than the claim under test. The other two conjuncts, /ROLLING test/ and /36-hour retention/, are single distinctive tokens and are sound.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED and UNPROVEN. Bound the gap to a single sentence (match the literal clause, or use a non-greedy bounded gap that cannot cross a tag boundary), and add the negative match the eleventh face requires â€” forbid the contradicting claim that the measurement is available retrospectively, not merely require the correct phrase.

### `probe:1612` — face1 — could-pass: **unknown** — confidence: medium

**Label:** [R10.1] no qualifying window reverts to the weekly cadence automatically
**Requirement:** R10.1

**Evidence.** Assertion: `!b10 || b10.kind === "wed"`. At this point DB.lastBriefImportAt is `now10 - 4 * 86400e3` (set at probe-snippet.html:1511 and not changed before 1516) and the catalyst window has been pushed out to inDays(20)â€“inDays(30) at 1515. With four days of staleness and the standing weekly threshold, briefReminderInfo() most likely returns null â€” in which case the `!b10` disjunct satisfies the assertion and the positive claim in the label ('reverts to the weekly cadence') is never exercised. The contrasting form is right there at line 1593, which asserts positively: `!!b10 && (b10.kind === "wed" || b10.kind === "stale")`.

**Could it pass with the property absent?** Whether `!b10` is what carries this assertion depends on briefReminderInfo()'s behaviour at exactly 4 days of staleness with no window, which I could not determine without either running the suite (forbidden) or fully tracing briefReminderInfo's threshold arithmetic â€” I did not read that function, so I am not claiming the disjunct fires. What is certain from the assertion form alone is that IF nothing fires, the assertion passes without demonstrating any revert, and the label's claim would then be unbacked.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Make it positive in the shape line 1593 already uses: `!!b10 && (b10.kind === "wed" || b10.kind === "stale")`, after setting lastBriefImportAt far enough back that the weekly cadence must fire. If the intended claim is narrower â€” 'the catalyst trigger stops firing' â€” then the label should say that instead, and the current condition is correct for that narrower claim.

### `probe:5341` — face1 — could-pass: **unknown** — confidence: medium

**Label:** [R49.1] the blend is computed across the pooled population
**Requirement:** R49.1

**Evidence.** The condition is `/">45%/.test(rb) || /45%/.test(rb)`. The second pattern is a strict superset of the first, so the disjunction reduces to the loose substring match and the anchored form is dead. The anchored form is the meaningful one: `drill()` emits `â€¦data-drill="â€¦" title="â€¦">45%<span class="dcaret">â–¾</span></button>` (index.html:1760-1762), so `">45%` pins 45% to the FACE position of the blend, while `/45%/` matches the same digits anywhere in the returned string â€” including the inline decomposition `rateBlend` appends at index.html:8441-8443 and the drill button's title attribute.

**Could it pass with the property absent?** On THIS fixture the exposure is small and I could not construct a concrete pass-with-property-absent case: parts49 is watchlist 8/8 and slice 1/12, whose inline splits render as '100% of 8' and '8% of 12', so the digits '45%' currently appear only in the face. A defect that moved the pooled figure out of the face position would need some other '45%' on the string to survive, and none exists here. What I can state without qualification is that the first disjunct contributes nothing to the current condition â€” it can never be the deciding term â€” so the assertion is weaker than it reads, and the fixture, not the assertion, is what is holding it up.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Drop the `|| /45%/.test(rb)` disjunct and keep only the anchored `/">45%/` form, which is the one that asserts the pooled figure is the blend's FACE rather than a substring somewhere in its markup. If the anchored form is thought too brittle against `drill()`'s markup, the durable alternative is to match inside the `data-drill="t49"` element via the existing `blendFrag(rb, "t49")` helper (probe-snippet.html:19-28), which is the same narrowing the R49.2 repair adopted.

### `probe:6682` — face2 — could-pass: **unknown** — confidence: medium

**Label:** [R60.1] every relocated caveat's tap REACHES its full text â€” no summary without a body
**Requirement:** R60.1

**Evidence.** `surfaces.every(h => strandedIn(h) === 0)` where `strandedIn` (probe line 6409-6416) filters `details.teach` and counts the malformed ones. A surface containing ZERO `details.teach` returns 0 and passes vacuously â€” absence and data-of-absence rendered identically, in the test layer. The companion at line 6426 pins `teachCount` only for `calibSection()`, `paperRegimeSection()` and `freshnessInline()`; the other two members of the array, `calibSellHTML({rows:[], sellLeg:â€¦})` and `gateDieOffSection()`, are unpinned. `gateDieOffSection` returns a bare `<div class="dim">No die-off episodes in the last 30 daysâ€¦</div>` with no teach when there are no episodes (index.html:12092-12093), and its `voidLine` teach at index.html:12083 renders only when `d0.voided` is truthy.

**Could it pass with the property absent?** Structurally the vacuous pass is certain for any surface whose teach population is empty. Whether gateDieOffSection is in that state under the probe's fixture depends on `gateHealthAudit().dieOff`, which I did not trace and cannot run â€” so I can assert the hole exists but not that it is currently open.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Have `strandedIn` return `{teaches, stranded}` and require `teaches > 0 && stranded === 0` per surface, so a surface with no disclosures reports as not-covered rather than as clean â€” or extend the line 6426 teachCount pin to every member of the array.

### `probe:4525` — face1 — could-pass: **no** — confidence: high

**Label:** [R38.2] every gate name a bench reason can render has a glossary family entry
**Requirement:** R38.2

**Evidence.** probe 4301 ends: `.filter(g => g !== "plan gate" || true)`. `X || true` is unconditionally true, so the filter removes nothing and "plan gate" â€” gateName's fallback return at index.html:4210 â€” is included in the checked set. This is the literal first-face tell in the file. Reporting it with its consequence stated honestly: because a no-op filter BROADENS the population, it makes the assertion stricter, not weaker, and it is not hiding a defect today. The defect is that the line READS as a deliberate exclusion of the fallback name while doing nothing, so the next reader cannot tell whether 'plan gate' is required to have a glossary entry (it currently is, and it currently has one).

**Could it pass with the property absent?** The property under test â€” every gate name has a glossary entry â€” is if anything over-enforced by this line, so the assertion cannot pass with the property absent BECAUSE of it. Hence 'no'. It is reported as a face1 instance for the enumeration's sake, not as a coverage hole.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Either drop the filter entirely (the honest form, since 'plan gate' does have an entry and should be checked) or make it a real exclusion with a comment saying why the fallback name is exempt. Do not leave a predicate that reads as a rule and evaluates as a constant.

### `probe:4018` — face8 — could-pass: **no** — confidence: medium

**Label:** [R33.2] empty streams say so in words rather than rendering an empty-but-broken panel
**Requirement:** R33.2

**Evidence.** The third conjunct is `/No hour-of-day data yet|no two-sided price/.test(surfaces33.hours + surfaces33.recipes)`. Two dead parts. (a) `surfaces33.recipes` does not exist: the surfaces33 map is built from the list at probe:3775-3783, which has no 'recipes' entry (the crafting-spread monitor was withdrawn â€” index.html:9862 marks it 'WITHDRAWN â€¦ Removed entirely rather than relocated'). The expression concatenates the literal string 'undefined' onto the hours HTML. (b) The alternation arm 'no two-sided price' matches nothing in index.html â€” I grepped the whole file and it is absent; it was the withdrawn monitor's empty-state copy. So the conjunct is decided entirely by 'No hour-of-day data yet' (index.html:9784), which the cold store does produce. Note also that the sibling assertion at probe:3794 scans surfaces33 for the literal /undefined/, and cannot see this one because 'recipes' is not a key of surfaces33.

**Could it pass with the property absent?** The surviving arm does test a real property on a real surface, so the assertion is not vacuous â€” the hours panel must genuinely render its empty-state copy. What is dead is half the alternation and the entire second operand of the concatenation. Reported because it is the dead-safeguard shape and because it is the kind of leftover the removal-time sweep is meant to catch.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Drop `+ surfaces33.recipes` and the 'no two-sided price' alternation, leaving `/No hour-of-day data yet/.test(surfaces33.hours)`. If the intent was to cover a second cold surface, name a surface that exists and add it to the surfaces33 list at 3775-3783 so [R33.1]'s /undefined/ scan can see it too.

### `probe:903` — face5 — could-pass: **no** — confidence: low

**Label:** detail removal updates membership and re-renders

**Evidence.** probe-snippet.html:901-905: a click on [data-clrm="5:9004"], then `await new Promise(r => setTimeout(r, 1600))` with the comment 'openClusterDetail re-fetch pacing (cached, ~250ms/id)', then assertions on DB.clusters[0].members and the re-rendered #cluDetail. The wait is a fixed wall-clock budget against an async re-fetch whose duration is ambient â€” roughly 3x headroom for two members at the quoted pacing, but nothing in the assertion observes completion. Production already exposes a completion signal: index.html:11395 clears `cluDetailBusy` in a finally block. The fifth face's ruling is that the fix is to inject or observe the varying input rather than to accommodate it with a constant; a fixed sleep is the accommodation.

**Could it pass with the property absent?** This is not a false-green shape â€” if the property (removal updates membership and re-renders) were absent, the assertion would fail. The face that applies is the intermittency one: the assertion can go red for a reason unrelated to the product, under load or on a slower host, which is the damage the fifth face names (teaching the operator to ignore failures). I could not measure the actual re-fetch time without running the suite, which I am forbidden to do, so I cannot say how much headroom 1600ms really carries â€” that is the specific thing I could not determine.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Replace the fixed sleep with a bounded poll on the production completion signal â€” loop on `cluDetailBusy === false` (index.html:11395) with a short interval and a generous deadline, failing with a named message on timeout so a genuine hang reports as a hang rather than as a membership failure. Per the fifth face, instrumentation that makes a failure name its own cause stays even once the flake is gone.

### `probe:3060` — face3 — could-pass: **no** — confidence: low

**Label:** [R22.8] the minimized checklist is ONE line â€” no header, no title, no attention line, one summary row
**Requirement:** R22.8

**Evidence.** Probe 2839-2840: `(ph => !!ph && ph.style.display === "none")(document.querySelector("#ckPanel .ph"))` and `document.querySelector("#ckTitle").style.display === "none"`. `element.style.display` reads back the inline attribute production itself wrote three lines earlier â€” index.html:16756-16758, `if (ph) ph.style.display = min ? "none" : ""; $("#ckTitle").style.display = min ? "none" : "";`. The assertion verifies the WRITE, not the rendered result, on exactly the surface class (a block that must be clean) for which the project ruled computed visibility is the standard.

**Could it pass with the property absent?** An inline `display:none` is beaten only by a rule carrying `!important`, and I found no such rule for `.ph` or `#ckTitle`, so in practice a green result here does mean the header and title are invisible. What the assertion cannot see is the CSS-specificity failure mode the third face was written about (a stylesheet rule rendering the block anyway), and it is coupled to the implementation choice â€” if the minimize path ever moves from an inline style to a class, this goes red for a reason unrelated to the property. I am reporting it as a weaker-than-its-neighbours form, not as a live false pass; the sibling R22.2 assertions at 2712-2730 use `offsetParent`/`getComputedStyle` correctly and this block does not.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Use the same `vis22` helper the slice already defines at probe 2712 â€” assert `!vis22('#ckPanel .ph')` and `!vis22('#ckTitle')` (offsetParent-based) instead of reading back `.style.display`, so the assertion measures what the user sees rather than what production just assigned.

### `probe:4364` — face2 — could-pass: **no** — confidence: low

**Label:** [R36.4] every auto-execution states which ruling authorised it, in the record
**Requirement:** R36.4

**Evidence.** The condition is `DB.decisionLog.filter(x => x.auto).every(x => /Aug 11 2026 ruling/.test(x.reason || ''))`. Array.prototype.every returns true on an empty array, and the assertion contains no guard that any auto entry exists. In the fixture as written it is NOT vacuous: DB.decisionLog is emptied at probe:4131, autoApplyAudits() at 4137 takes the RETIRE branch (see the finding at line 4138), and index.html:11751-11752 logs it with a reason containing '(your Aug 11 2026 ruling)'. So today exactly one entry exists and the assertion has something to bite on. But the guard is one fixture change away from disappearing: if seedAudit's recommendation shifts to KEEP the branch at index.html:11737-11744 is throttled to once per 7 days by DB.audRuled, and if it shifts to PROMOTE nothing is logged at all â€” in either case this line goes silently vacuous and reads exactly like a passing test.

**Could it pass with the property absent?** As the fixture currently stands the array is non-empty, so stripping the ruling citation from index.html:11752 would fail this assertion. I verified that by reading autoApplyAudits' RETIRE branch. Reported as a latent face2 rather than a live defect, and the confidence field reflects that.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the non-empty guard the property implies: `const autos = DB.decisionLog.filter(x => x.auto); autos.length > 0 && autos.every(...)`. The same pattern is worth checking on probe:3734, which uses .every over `fr32.filter(r => r.kind === 'event')` â€” that one is currently safe because index.html:9925-9926 add two event rows unconditionally.

### `probe:7003` — face11 — could-pass: **no** — confidence: low

**Label:** [R62.6] the panel states what the fixed horizon buys AND what it costs, in its own words
**Requirement:** R62.6

**Evidence.** Two positive regexes and no negative match: `/tests <b>whether an offer fills<\/b>, not whether it fills before you get back/` and `/no longer models your cadence/`, both against `hs = paperShapeSection()` (probe 6718). Production emits both from one static sentence at index.html:9250. But paperShapeSection assembles many independent bits (index.html:9169-9255 â€” a never-fed note, a teach block on the retired overnight/daytime label, the concentration line, the anchor line, the shape-disagreement block, the routing question), and a contradicting claim about cadence appearing in any of those would not be caught. The [R62.6] tag is the tag on which the eleventh face was discovered, on a different assertion.

**Could it pass with the property absent?** For the property as literally labelled â€” the panel states the buy and the cost in these words â€” the assertion is sound: delete or reword index.html:9250 and it goes red. The gap is the one the eleventh face names: it requires the correct claim without forbidding the contradicting one, and the container is a multi-block section where a contradiction has somewhere to live. So this is a hardening candidate rather than a demonstrated blind spot, and I am rating it low accordingly.

**Proposed fix (UNAPPLIED, UNPROVEN).** UNAPPLIED, UNPROVEN. Add the negative half: `!/models your cadence(?! at all)/.test(hs)` is too clever and would be brittle â€” prefer forbidding the specific contradicting claims the panel could plausibly regrow, e.g. `!/sizes for the gap until your next touch/i` and `!/before you get back/.test(hs.replace(<the asserted sentence>, ''))`. Per the eleventh face the seed must discriminate: the old form passes a rewrite of the panel's OTHER half, the new form fails it.

