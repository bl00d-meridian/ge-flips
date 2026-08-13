# MISTAKES.md — the evidence layer

Every incident on record, newest first. This is **evidence**, not law: an entry here is a
thing that went wrong once. Law lives in [CLAUDE.md](CLAUDE.md), and an entry graduates
into it only under the promotion rule recorded there — **three occurrences, or one with a
mechanical detector.**

Written as a backfill on 2026-08-13, reconstructed from `audits/`, CLAUDE.md's case law
and both sections, [HANDOFF.md](HANDOFF.md), [REQUIREMENTS.md](REQUIREMENTS.md)
(including withdrawn rows), [PROBE.md](PROBE.md), [IMPROVEMENTS.md](IMPROVEMENTS.md),
[FRICTION.md](FRICTION.md) and the commit history. **Every entry cites where it was
substantiated so a reader can check it.** Where an entry could only be inferred, it says
so in place rather than being reported as found.

## How to read an entry

```
### M0NN · title
DATE · found by: <seeding | inspection | audit scan | review | use | user>
pattern: <root-cause tag>

What happened / root cause / consequence / the rule that would prevent a repeat.
Substantiated from: <sources>
```

**IDs are stable.** They were assigned oldest-first at backfill; the file is ordered
newest-first, so a new incident takes the next unused number and goes at the top.

## Pattern tags (root causes, not surfaces)

| Tag | The property that was violated |
|---|---|
| `TEST-SUITE` | A green result meant the test never ran, or ran and passed for a reason other than the property it names |
| `REIMPL` | An assertion carried a parallel implementation of the thing under test (a face of `TEST-SUITE`) |
| `CLAMP` | An assertion's subject was computed downstream of a clamp that could absorb the defect (a face of `TEST-SUITE`) |
| `SILENT-STATE` | A component reported nothing where it should have reported that it *has* nothing |
| `POOLING` | A statistic pooled populations that answer different questions |
| `UNOBSERVED` | A denominator counted time or occasions nothing had looked at |
| `INTERROGABILITY` | A number shipped without the rows that produced it |
| `CLAIMS-VS-CODE` | Rendered copy claimed something the code does not compute |
| `COMPOSITION` | A defect in the seam between two individually-correct subsystems |
| `ORPHAN` | Data written and never read, or a surface read and never fed |
| `SCOPE-NAMING` | A rule or spec named the surface it was found on rather than the property |
| `LEDGER-ONE-WAY` | A cross-reference between two artefacts was checked in one direction only |
| `RESTRAINT-LIFT` | A caution stopped applying with no user press |
| `CONSENT` | A strategy parameter moved without an explicit ruling |
| `CAUSALITY` | A simulator credited a leg from tape that printed before it existed |
| `EVIDENCE-ROUTING` | A finding was read as evidence for a change it was not about |
| `REMOVAL-SWEEP` | A deleted feature's mentions survived it |
| `STALENESS` | A long-lived client judged fresh data against stale inputs, or could not see its own age |

## Which patterns are now law

Counted by tag on 2026-08-13 and ruled the same day. `TEST-SUITE` (34 across eleven named
faces), `CLAMP` (6), `POOLING` (10), `SILENT-STATE` (16), `COMPOSITION` (26),
`UNOBSERVED` (5), `INTERROGABILITY` (4), `STALENESS` (4), `CAUSALITY` (4), `ORPHAN` (4),
`LEDGER-ONE-WAY` (3) and `CLAIMS-VS-CODE` (12) are BINDING rules in CLAUDE.md with
detectors. `RESTRAINT-LIFT` (2) is BINDING on the detector limb (scan 6). `REIMPL` (4) is a
face of `TEST-SUITE`, not a separate law, and `CLAMP` is both a face and a law in its own
right — counted once, in `TEST-SUITE`'s 34, and reported separately.

Still evidence, and why: `SCOPE-NAMING` (2) is the prophylactic at the top of CLAUDE.md,
which governs how rules are written rather than what any rule says, so it sits above the
split rather than inside it. `EVIDENCE-ROUTING` (1) and `CONSENT` (1) are one instance from
the count limb and have no detector. `REMOVAL-SWEEP` (1 tagged, 2 in substance — M110 is
the same root filed under `LEDGER-ONE-WAY`) is the closest to promotion: **one more and it
qualifies.**

---

# 2026-08-13

### M141 · Every export class but one had no collector, for a week
2026-08-13 · found by: user, after paying the cost every session · pattern: `COMPOSITION`

The browser cannot write to the repo, so every export the tool produces costs a hop:
find it in Downloads, move it, delete the browser's ` (1)` copies. **A collector was
built for exactly one class — `flags-pending` — because that was the class the briefing
procedure happened to need**, and the five other classes the tool exports were left to
be carried by hand. Root cause: the collector was specified as a step inside one
workflow rather than as a property of the export mechanism, so it covered the caller
that prompted it and nothing else. The Downloads folder had accumulated **19 stale
copies across six classes**, of which the sweep deleted 18 on its first run.

Substantiated from: BRIEFING.md run-procedure step 0 as it stood (flags only);
`tools/inbox/sweep.sh` first run, which reported 7 older duplicates for
`analysis-paper` alone; CLAUDE.md, *Downloads auto-collect*.

### M140 · The assertion manufactured the only state in which the guard could run
2026-08-13 · found by: the deletion failing an existing assertion · pattern: `TEST-SUITE`

Deleting `reconReplay`'s unreachable causality guard (M137) turned `[R43.2]` red — so the
dead line **was** asserted. The assertion called `reconReplay` **directly**, handing it a
window starting before the trip's own `t`, which is a call production cannot make: the
caller clamps the window first. So the probe was constructing the only input under which
the guard could execute, and reporting a dead line as covered.

**GRADUATED to the test-suite family as its TWELFTH FACE** (user ruling, Aug 13 2026),
with **scan 13** as its detector. It is the cousin of the reimplementation trap: there the
probe re-derives the *answer*, here it manufactures the *state* — and both produce a green
run on real production code that proves nothing about production. The tell is its own:
**an assertion that reaches its subject by a call path the product does not have.** It is
also why the dead guard survived a full day of scans: it was green, and green on a line
that cannot run reads exactly like green on a line that works.

**It changed how the dead-guard rule is applied, which is the load-bearing consequence:
before deleting an unreachable guard, check whether an assertion is holding it alive.** A
dead guard with a green assertion pointed at it is the normal case rather than the
surprising one, the deletion will turn that assertion red, and **the red is information —
it names the artificial call path** rather than reporting a regression. Move the assertion
to the layer production uses before the guard goes. Fixed here by extracting
`reconWindowStart()`, stating the promise there, and seeding it against the input the old
guard pretended to defend against.

Substantiated from: the `[R43.2]` failure on the deletion (probe report,
2026-08-13); `tools/probe/probe-snippet.html`, the re-pointed assertion and its comment;
`audits/AUDIT-2026-08-12-scope.md` §8, corrected in place.

### M139 · A difference was rendered as a level, and disagreed with its own drill-through
2026-08-13 · found by: user · pattern: `CLAIMS-VS-CODE`

The paper vitals tile read **+2.64m vs current**; the drill underneath it read **−2.4m**.
Both the sign and the magnitude differed, and **both numbers were arithmetically correct**:
the headline was `tight − current` (a DIFFERENCE) presented as though it were a level, and
the drill was `current` itself. Nothing was wrong with either figure; the sentence was
wrong about which figure it was.

Root cause: the line was hand-rolled as `label + gp(|d|) + " vs current"`, and "vs current"
is not enough — it names the base without printing it, so the reader cannot reconcile the
two numbers they are looking at. Fixed at the renderer, not the call site: `deltaVs()` is
the sanctioned form and **cannot emit the difference without both operands**, the
`rateBlend()` shape applied to differences.

**The general rule, which is the durable part: a figure that is a difference states what it
is a difference from, in the sentence, not in a tooltip** — the number is read in the line
and not in the hover.

**A widening was proposed and is HELD** (user ruling, Aug 13 2026): *a decomposable
aggregate must reconcile to its decomposition, and the check is mechanical.* The existing
interrogability rule guarantees a number can be **opened**; it has never required that what
opens **agrees** with what was opened.

**Held because this incident is not an instance of it, and that is the right reason to
hold a rule.** The two figures were different quantities, each correctly computed, one
mislabelled — a reconciliation check comparing `tight − current` against rows summing to
`current` would have **fired on a correct pair** and reported a defect that was not there.
A rule adopted on the back of an incident it would have mis-handled is a rule with no
evidence under it, which is the defect the promotion bar exists to catch. **It graduates
when something actually fails to reconcile.** This entry stays as the evidence that the
question was asked and answered, not as the instance.

Substantiated from: user report, 2026-08-13; REQUIREMENTS.md R65.1; `deltaVs()` and
`paperDivLead()` in `index.html`.

### M138 · An audit's conclusion inherited a guard's authority without checking it could fire
2026-08-13 · found by: graduation audit's scan 11 · pattern: `TEST-SUITE`

`AUDIT-2026-08-12-scope.md` §8 traced every path that can close a paper trip and ranked
`reconReplay` the least likely cause of the sub-second trips, reasoning in part that it
"has causality (`bt < p.t` skips)". **That guard could never execute.** The audit read the
line, credited it, and passed its authority into a conclusion — and the conclusion then
sat in the record for a day as settled.

The reasoning was not careless: reading a guard and believing it is the normal way to audit
code. What was missing is the question the dead-safeguard rule already asks of *guards* and
nobody was asking of *arguments* — **can this line run?** An audit that cites a guard is
making a claim about behaviour, and a claim about behaviour has to clear the same
reachability bar as the code it rests on.

Consequence and the fix: the ranking may still be right, because the other reason given
(buckets are five minutes apart) is real and independent — but the causality half is worth
nothing and is **withdrawn in place**, in the audit where it was recorded, rather than
noted only in the newer report. A correction that lands somewhere the reader will not look
is not a correction.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §8, correction block;
`audits/AUDIT-2026-08-13b-scans-10-11.md` S11-F1.

### M137 · `reconReplay`'s causality guard cannot fire
2026-08-13 · found by: audit scan (11, information horizon — first run) · pattern: `TEST-SUITE`

`if (bt < p.t) continue;` — the only line in the reconstruction path that states the
causality rule, carrying the comment that asserts it. Its caller clamps first:
`replayFrom = Math.max(p.lastObs || p.t, oldest)`, so every bucket reaching the guard
already satisfies it. **Unreachable by its own upstream limits** — the dead-safeguard shape
(M080), and worse than that instance because the **Aug 12 instant-trip audit reasoned from
this guard**, rating `reconReplay` the least likely cause of sub-second trips on the
strength of a line that cannot execute. Also untestable by construction: any assertion
written against it would be a dead seed. Proposed both ways (delete and assert the upstream
guarantee, or keep it and give it a direct-call fixture); not applied.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S11-F1; `index.html:6412` and
`:6480–6486`; `audits/AUDIT-2026-08-12-scope.md` §8.

### M136 · Two runtime fields written and never read
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `ORPHAN`

`S.reconLast` captures `shadowRecover()`'s return and discards it. `S.anomMkt` captures the
market-index reading beside `S.anomSuppressed` and `S.anomRaw`, **both of which render**,
while it does not — and the reading it holds is already persisted as `DB.volIndex` and
rendered with its control rows. The correct fix for the second is **deletion, not wiring**:
wiring it would create a second source for one number, which is the redundancy scan's own
finding shape. Recorded because a write-only field is a claim that something is being
tracked.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F3/S10-F4;
`index.html:2173`, `:13086`.

### M135 · The 40% cap's explanation is composed and never rendered
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `SILENT-STATE`

`S.cohNote` builds the sentence *"N statistical candidates withheld by the 40% cap: …"* and
nothing reads it. Its sibling `S.cluMsg`, twelve lines below, is read and rendered by
`renderClusters()` — so the module's convention is exactly the one this was written to and
then missed. **Not merely an orphan:** the cap is an automated decision that withholds
candidates, and *every automated decision states its reason inline where the user reads it*
is BINDING. The reason exists, fully composed, and reaches no surface. It is also the
stranded caveat the surface-copy inventory named as that edit's risk — stranded at birth
rather than by a move.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F2; `index.html:3729`.

### M134 · The contamination register and the cleanliness clock have no writer between them
2026-08-13 · found by: audit scan (10, seam inventory — first run) · pattern: `COMPOSITION`

`paperCleanFrom()` returns `DB.paperDefectsClearedAt || 0` and **nothing in the product
ever writes that field.** `PAPER_DEFECTS` is a hardcoded source array whose entries leave
the register when a developer deletes one and ships; the timestamp is persisted runtime
state. The two live in different worlds and the field joining them has a reader and no
writer.

Today the register is non-empty, so the function returns `null` and everything reads
contaminated — the safe direction, which is why nothing has surfaced. **The defect fires
the instant the last entry is struck:** `from` becomes 0, and every trip in the book,
including every trip that closed while the defect was live, is reclassified as clean
evidence in one step with nothing said. Deployment direction, flatters the book, triggered
by a build change rather than a press. The commit that clears the register both releases
the scanner proposal's hold and retroactively supplies the clean evidence the hold was
waiting for.

**The epoch-1 lesson inverted** (M097): a corrupt population that cannot be identified by a
field must be discarded rather than partitioned, and the answer then was to stamp
`FILL_MODEL_V`. Here the partition field exists in the reader and was never given a writer.

Substantiated from: `audits/AUDIT-2026-08-13b-scans-10-11.md` S10-F1; `index.html:5872`,
`:6043`, `:12052–12056`.

### M133 · A BINDING rule claimed recurrence it could not evidence
2026-08-13 · found by: graduation audit · pattern: `CLAIMS-VS-CODE`

*"Known repeated bug class: gates that re-punish what sizing already priced in."* The
backfill searched the whole repo and found **zero** substantiated instances — every
`double-count` in the tree is a different defect (bank-plus-realized sizing, the funnel's
negative residual, the attention denominator). Root cause: the entry was written from
recollection at a moment when there was no evidence layer to check it against, and a
constitution with no ledger under it cannot tell a remembered defect from an observed one.
Consequence: unearned authority — the phrase *known repeated* is the strongest claim the
constitution makes about its own history, and it was resting on nothing. The claim was
**struck** rather than merely demoted; the underlying guidance survives without it.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2b; `grep -rin "double-count"`
over the repo returns four hits, none of them this defect.

### M132 · One root was written in three places, so its sixteen instances never accumulated
2026-08-13 · found by: graduation audit · pattern: `SCOPE-NAMING`

*A component reports nothing where it should report that it HAS nothing* lived as a BINDING
entity-state rule, a never-fed-aggregate case-law section, and a stalled-generator finding
in an audit report. Each read as a separate lesson, so no entry ever carried more than a
handful of instances and the pattern's real size — **16, the largest behind any single
rule** — was invisible until the incidents were tagged by root cause. Root cause: the
prophylactic ("name the property, not the surface") governs how a *new* rule is written and
says nothing about **merging rules already written about the same property from different
angles.** Consolidated into one BINDING entry carrying all five shapes and all sixteen
instances.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2c; CLAUDE.md BINDING (the
consolidated entry) and the two case-law sections that now defer to it.

### M131 · The test-suite face list had eleven shapes and ordinals reaching eight
2026-08-13 · found by: graduation audit · pattern: `LEDGER-ONE-WAY`

Two ordinals ("seventh", "eighth") appeared out of file order, one face was unnumbered, and
the highest ordinal was three short of the list's own length. **The count is the whole use
the list is put to** — a graduation argument rests on how many times a shape has recurred —
so a numbering that does not match its own list cannot support the argument it exists for.
Same defect class as the requirements pairing (M110/M111): a ledger nobody checked in one
direction. Renumbered against file order, with the two out-of-order bullets physically
swapped so the ordinals and the list agree.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §2c; CLAUDE.md Verification,
the renumbering note.

### M130 · The integration-audit scan list had no scan 9
2026-08-13 · found by: graduation audit · pattern: `LEDGER-ONE-WAY`

The list ran 1–8, then 10, then 11. A BINDING rule cited "integration-audit scan 10 below"
as its detector, so **the citation named a position rather than a check** — and a position
in a list with a hole in it is not a stable reference. Nothing was missing operationally;
the clamp scan existed and ran. But a detector cited by number, in a list whose numbers
skip, is one renumbering away from pointing at the wrong scan. Renumbered contiguously and
every citation re-pointed.

Substantiated from: `audits/AUDIT-2026-08-13-graduation.md` §3; CLAUDE.md integration-audit
preamble.

### M129 · Analysis exports carrying the trading record sat loose in the repo tree
2026-08-13 · found by: inspection · pattern: `COMPOSITION`

Three `analysis-paper-2026-08-13*.json` files — curated reads of the user's own paper
book — were downloaded into `briefings/` and were untracked but not ignored. The hard
boundary ("nothing in this repo ever contains user trading data") held only because
nobody ran `git add -A`. Root cause: the export feature shipped with a documented
purpose (hand the file to an analyst in chat) and no rule about where the file lands,
and the browser puts a download wherever it likes. Fixed by ignoring `analysis-*.json`
and `gef-backup*.json` **in any directory**, with the reasoning written into
`.gitignore` itself. Never committed — verified with `git log --all -- 'briefings/analysis-*.json'`, which is empty.

Substantiated from: `.gitignore` (the ANALYSIS EXPORTS block); commit `5f67395` body
("Analysis exports gitignored; the repo carries the tool, not the data"); `git ls-files briefings/`.

### M128 · The near-miss line recited the bar instead of naming each item's standing
2026-08-13 · found by: review · pattern: `INTERROGABILITY`

The exception lane's near-miss surface printed the qualification bar rather than where
each candidate actually stood against it — a verdict whose stated reason named no items
and no thresholds, which is the interrogability scan's own definition of a finding.
Replaced with every item's standing against all seven clauses.

Substantiated from: commit `5f67395` body ("the near-miss ranking replaces the
bar-recitation line with every item's standing against all seven clauses"); REQUIREMENTS.md §63.

### M127 · The exception lane's span counted calendar days, not observed ones
2026-08-13 · found by: audit scan · pattern: `UNOBSERVED`

`spanD` measured the exception's evidence window in wall-clock days while the app may
have been closed for several of them. Same defect as `daysBenchedBy` (M094), on a
different surface, **one day after the observed-time rule was widened to reach every
denominator counting time or occasions.** Fixed to count observed days.

Substantiated from: commit `5f67395` body; REQUIREMENTS.md §63; CLAUDE.md BINDING,
observed-time entry.

### M126 · Seed J — the assertion required the right sentence and never forbade its contradiction
2026-08-13 · found by: seeding · pattern: `TEST-SUITE` (eighth face)

`[R62.6]` checked that the export's touch-ledger note says the schedule is "unverified
rather than false" when no walk-ups are recorded. The seed rewrote the note's **first**
half to claim *"the configured schedule is being followed"* — the exact opposite of the
rule — and left the asserted phrase in the second half intact. The suite stayed green
while the file asserted the contradiction. Root cause: an assertion about what copy
*claims* was written as a presence test only. Not a weak assertion and not a dead seed:
it ran, on real output, and permitted the contradiction. Fixed by adding the negative
match; the old form passes the seed and the new form fails it. Found while seeding, not
by suspecting it.

Substantiated from: CLAUDE.md Verification, "Presence of the right phrase is not absence
of the wrong one"; commit `5f67395` body.

### M125 · Seed G — a multiline substitution silently did not apply
2026-08-13 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 1)

A seed intended to break a rule matched nothing and left the file untouched. The suite
then ran green against unmodified code. The **precondition check caught it before the
result was read**, which is the only reason it is recorded as a caught near-miss rather
than as a false proof. Root cause: a scripted substitution across multiple lines has a
silent-failure mode, and "the command exited 0" is not "the text changed".

*Substantiation note:* the letter designation is the session's, not the repo's. The
shape is substantiated by CLAUDE.md's seeding precondition clause 1 and by its numbered
analogue, seed 34 in commit `46ffa0a` ("the first attempt's substitution silently
failed, which is the same class as a seed landing on unreachable code: the run was green
because nothing had changed"). The specific Aug 13 occurrence is recorded on the
strength of the session record and is flagged here as such.

### M124 · `shadowCredit`'s clamp discarded the pre-clamp term, so over-crediting was unreconstructible
2026-08-13 · found by: user question · pattern: `CLAMP`

`shadowCredit` stores `Math.min(qty, term)`. A per-bucket credit term larger than the
trip's own size was clipped and left no record anywhere. Asked whether the book had ever
over-credited, the only honest answer was *"cannot be reconstructed — the per-bucket
inputs are discarded at credit time — and bounded away from catastrophe only by the fact
that no trip ever filled inside a single bucket."* Consequence: over-crediting, the one
direction that would flatter every fill rate in the book, was **structurally
unobservable**, and the 75 trips already in the book are unanswerable rather than
favourable. Fixed by retaining a bounded buy-leg trace with the credit **before** the
clamp, including buckets that credit nothing. A trip with no trace reads UNKNOWN, never
as zero absorption.

Substantiated from: commit `9f5fdc6` body; REQUIREMENTS.md R59.7.

### M123 · `[R59.7]`'s first assertions read a hand-built trace — consumer asserted, producer unasserted
2026-08-13 · found by: seeding · pattern: `REIMPL`

Two of six seeds did not bite. The assertions constructed a trace object in the probe
and checked the consumer's arithmetic on it, so the code that *produces* the trace went
unchecked. Rewritten to assert through `shadowTick`, whose existing fixture is already
the over-credit case (4,000 low-side volume gives a 600-unit term against a trip of 10 —
clamped 60×). **This landed one turn after the clamp-absorption rule was written into
BINDING**, which is the sharpest available evidence that a freshly-written rule does not
protect the next thing you write.

Substantiated from: commit `9f5fdc6` body ("Two seeds initially did not bite — the
assertions read a hand-built trace, so they tested the consumer while the producer went
unchecked").

### M122 · `[R18.2]` was blind in the over-credit direction only
2026-08-13 · found by: audit scan (clamp sweep) · pattern: `CLAMP`

`p.buyQ = Math.min(qty, credit)`, and the assertion checked `buyQ === 10` where `qty` is
10. The qty clamp sat between the capture-capped term and every assertion about it, so
the probe could see **under**-crediting (it shows up as a short fill) and was blind to
**over**-crediting (it is clipped to qty and disappears). The fill model's entire claim
is that it is conservative, and nothing tested the half of it that could fail silently.
No extraction was needed — `reachCredit` was already named; the defect was purely in
what the assertions read. Fixed by asserting at a bucket volume 1,500× the trip size,
against the uncapped term, plus a **linearity** assertion — deliberately, because the
equality checks re-derive the term probe-side, which is the reimplementation tell, and a
scaling property is one no parallel implementation encodes.

Substantiated from: commits `29c6b73` (classified) and `e065431` (fixed); CLAUDE.md
BINDING, clamped-output entry.

### M121 · The `[R26.2]` repair was tautological — the guard could not evaluate false
2026-08-13 · found by: seeding · pattern: `TEST-SUITE`

Written **while deliberately fixing a weak assertion**, the first repair compared the
probation-granted plan against "the same plan with the grant lifted". Without the grant
the item does not fund at all, so the comparison is null and every guard against it
short-circuits to true: the repair passed with the halving deleted. Not a weak assertion
— a vacuous one. Root cause: the external-comparison technique that worked for the pump
caution (which has a fundable counterfactual) was reused on a path that has none. Fixed
by extracting `applySizeFactors()` and asserting it on its own arithmetic at a known
input, with no clamp in the way.

Substantiated from: commit `29c6b73` body; REQUIREMENTS.md R26.2.

### M120 · `[R7.3]` and `[R26.2]` asserted that a caution's note rendered, never that anything shrank
2026-08-13 · found by: seeding · pattern: `CLAMP`

The two paths that size real capital under a caution — a suspected pump, and a probation
grant funding an item a gate benched — were covered only by assertions that the
explanatory note appeared. Seeding confirmed both were unprotected: the multipliers could
be deleted and the suite stayed green. `applySizeFactors()` carries all four (caution,
probation, unproven T1, T2 ramp), which were **the only thing bounding capital on a
waived gate.**

Substantiated from: commit `29c6b73` body; REQUIREMENTS.md R7.3, R26.2.

### M119 · `probe-snippet.html:98`/`:105` both asserted clamped outputs, six times below the term
2026-08-13 · found by: audit scan (clamp sweep) · pattern: `CLAMP`

The two allocator sizing assertions read `allocQty === 4000` and `5000` — the **cluster
cap** and the **per-item cap**. Measured on the probe's own fixture the allocator's
horizon term computes **30,000 units**, so neither figure could see a defect in the
sizing that feeds them; the pair did not cover the gap as hoped. Both were written as
sizing coverage. Fixed by extracting `planHorizonUnits()` and asserting the term at
source; the caps keep their own assertions, which are worth having as clamp tests.

Substantiated from: `tools/probe/probe-snippet.html` lines 96–112 (the comment records
the finding in place); commit `29c6b73` body.

### M118 · Clamp absorption at `shadowHorizonUnits` — reverting the horizon changed no output
2026-08-13 · found by: seeding · pattern: `CLAMP`

Paper sizing reverting from the fixed horizon back to the schedule changed nothing
observable, because `planCap`'s buy-limit clamp pinned both readings to the same number.
This is the **second occurrence** of the shape and the one that graduated it to BINDING —
`strataCount` (M074) was the first. Fixed by extraction: pull the term into a named
function and point the assertion there.

Substantiated from: CLAUDE.md BINDING, clamped-output entry ("graduated to BINDING on
the second occurrence, which is the bar"); commit `5f67395` body.

### M117 · The recipe-basis copy still advertised a feature withdrawn two days earlier
2026-08-13 · found by: inspection · pattern: `REMOVAL-SWEEP`

The Prospecting surface's copy went on describing the recipe basis after the monitor was
removed whole on Aug 11. The removal commit swept code, `DB` keys, the poll call, the
freshness rows, the WHAT CHANGED line, the panel and the import sanitiser — and left the
prose. Same commit also caught §31's requirement rows still claiming probe coverage
(M110). **Deletion is the moment stale mentions are created**, and the artefact classes
have to be enumerated then, not discovered later.

Substantiated from: CLAUDE.md surface map ("the recipe basis was withdrawn Aug 11 2026
and the copy that still advertised it was removed Aug 13 2026"); REQUIREMENTS.md R35.4
("this clause WITHDRAWN Aug 13 2026"), R31.1–R31.2.

### M116 · A share of a negative net read exactly like a concentration figure
2026-08-13 · found by: analysis · pattern: `CLAIMS-VS-CODE`

`top5 / net` on a losing cell returns a percentage that looks like concentration: the gap
band's daytime cell yielded **13%**, which would have been read as "well spread". The
arithmetic was correct; the denominator's sign changed the meaning. Both concentration
figures now withhold, with the reason stated, wherever the net is not positive.

Substantiated from: CLAUDE.md case law, "routing is not coverage", third companion.

### M115 · `n` was treated as sample size where one trip carried the cell
2026-08-13 · found by: analysis · pattern: `POOLING`

The gap band's overnight cell showed 3 trips netting **+399k** — of which one
10.6m-notional trip is **+412k**, i.e. one result and two that offset it. The top-trip
share is **103%** of the cell's net. A trip count cannot show that and a rate cannot
either. Consequence: without the concentration reading, three trips would have read as a
finding. The top-trip share now renders per cell, and the routing bar treats a trip count
as necessary and not sufficient.

Substantiated from: CLAUDE.md case law, "routing is not coverage", second companion;
HANDOFF.md §1f.

### M114 · The dimension nothing rendered — a cohort whose halves disagreed in sign
2026-08-13 · found by: reading an export by hand · pattern: `POOLING`

The gap band printed **+399k on 3 overnight trips against −219k on 16 daytime ones** —
opposite signs inside one population. Nothing on screen split any cohort by horizon, so
seeing it required downloading the analysis export and grouping trips by hand; and the
export's own `byHorizonShape` tally pooled every cohort into two counts, which cannot
show a cohort whose halves disagree. Root cause: **a pooled statistic is at least visible
as a pooled statistic; a dimension no surface splits by is invisible to the reader and to
the pooling scan alike.** Scan 8 was extended to read artefacts and to check the
dimensions a population is *not* split by at all; the split got its own panel.

Substantiated from: CLAUDE.md case law, "routing is not coverage", first companion;
CLAUDE.md integration audit scan 8; HANDOFF.md §1f.

### M113 · Routing evidence nearly un-held a coverage proposal
2026-08-13 · found by: user ruling · pattern: `EVIDENCE-ROUTING`

The overnight/daytime split was striking enough to be read as support for the held T3
scanner proposal for the gap band. It is not: the evidence argues about **when** the
band's trips should be placed, not **how many** of its items should be watched.
Different change, different cost, different failure modes. Had it been read across, a
proposal would have been ratified by a finding that was never about it. The scanner
proposal stays held; routing was raised as its own question against the same bar.

Substantiated from: CLAUDE.md case law, "routing is not coverage" (user ruling);
HANDOFF.md §1f.

### M112 · The paper book priced every placement for a schedule the operator did not keep
2026-08-13 · found by: measurement against the walk-up log · pattern: `CLAIMS-VS-CODE`

Every paper placement sized and priced for the gap to the next **configured** touch.
Measured against the actual walk-up log: **1 of 18 sessions** fell within half an hour of
a configured touch, mean mispricing **2.20h**, systematically short in **13 of 17**
intervals. The tell was that three different verdicts came out of the same 75 trips in
one day, each from fixing a *label* rather than from new data — the dimension was
measuring bookkeeping, not the market. Fixed with `PAPER_HORIZON_H = 6`, derived from the
only uncensored window the book had, and `FILL_MODEL_V=2` to partition the populations.
Gap labelling retired in favour of time-of-day-opened.

Substantiated from: commit `5f67395` body; REQUIREMENTS.md §62, R62.5.

---

# 2026-08-12

### M111 · `[R61.x]` — six assertions tagged against requirement rows that were never written
2026-08-12 · found by: building the reverse check · pattern: `LEDGER-ONE-WAY`

Six assertions for the verdict-first work carried `[R61.x]` tags and no §61 rows existed.
The report printed `REQ PASS R61.1` against nothing for a day. **A requirement that does
not exist cannot fail, and the report said it passed** — the ledger lying in exactly the
direction it was built to prevent. Fixed by `tools/probe/reqpair.sh`, which lives outside
the page because it must read `REQUIREMENTS.md`, and which rewrites the report header so
`head -1` never says PROBE-PASS while a pairing failure stands.

Substantiated from: REQUIREMENTS.md R6.2; PROBE.md, the pairing-check section; CLAUDE.md
Verification, "The pairing is checked in BOTH directions"; commit `5f67395` body.

### M110 · §31's withdrawn rows claimed probe coverage after their assertions were deleted
2026-08-12 · found by: building the reverse check · pattern: `LEDGER-ONE-WAY`

The withdrawn crafting-spread rows went on citing `` probe `[R31.x]` `` after the
assertions were removed with the feature, and R35.4 cited one of them. **This is the
seasoning-gate shape (M017) with the arrow reversed** — a spec claiming an implementation
that is not there. Root cause: the ledger was only ever checked tag→row; nothing walked
row→tag, and that is where the drift accumulates, because nothing there ever goes red.

Substantiated from: REQUIREMENTS.md R6.2, R31.1, R31.2, R35.4 (all three now marked
"WITHDRAWN — no verification … until Aug 13 2026 this column still claimed probe
coverage").

### M109 · The surface-copy inventory's headline premise was mis-measured
2026-08-12 · found by: self-check while cutting · pattern: `CLAIMS-VS-CODE`

The inventory reported `paperCaveat` as the worst offender "by a distance" — 410
characters re-rendered at **every** paper citation. Wrong: `PAPER_NOTE()` appears only
inside `drill()` note fields, which already render behind a tap, and `paperCaveat()`
renders standing exactly once. The real standing offenders were the three ranked below
it. Consequence: the user ruled a priority order on a false premise. Handled by flagging
the premise and re-cutting in corrected order, rather than quietly re-planning.

Substantiated from: `audits/INVENTORY-2026-08-12-surface-copy.md` (the original claim);
commit `83edd09` body (the correction).

### M108 · 22,608 characters of standing prose against a 7-decision budget
2026-08-12 · found by: measurement on request · pattern: `COMPOSITION`

79 persistent explanatory blocks, ~594 phone lines across four tabs. Every block
individually correct and individually justified; the failure was that they all rendered
at the same weight, always, so nothing was louder than anything else — and the two blocks
that most needed to be loud (contamination register, stall line) were 549 and 279
characters in a field of 22,608. Three "conditional" warnings rendered unconditionally,
which is why the real ones got missed. Composition, not content.

Substantiated from: `audits/INVENTORY-2026-08-12-surface-copy.md`; commits `222c0d4`,
`83edd09`, `46ffa0a`.

### M107 · Seed 31 — a property asserted on an injected trace, not the tick that records it
2026-08-12 · found by: seeding · pattern: `REIMPL`

The zero-credit-bucket property was asserted against a trace the probe injected, so the
wiring that actually records it went unchecked; the seed did not bite. Fixed by adding a
wiring assertion driven through `shadowTick`.

Substantiated from: commit `1ac9ea2` body.

### M106 · Seed 22 — `paperEpoch2Reset` was unreachable from any test while inline in `load()`
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed)

The seed changed nothing the suite could see, which reads exactly like a weak assertion
and was in fact code no test could reach. Extracted as a named function so an assertion
can call it; the seed then bit.

Substantiated from: commit `ee5d737` body; `audits/AUDIT-2026-08-12-scope.md` §11.

### M105 · Seed 21 — the stall line was asserted through its function, never through the surface
2026-08-12 · found by: seeding · pattern: `TEST-SUITE`

`shadowScanState()` was covered; the rendering that puts it on the paper headline was
not. A real coverage gap, not a weak assertion. Fixed by adding the wiring assertion.

Substantiated from: commit `ee5d737` body.

### M104 · Seed 17 — prediction stamping had no assertion at all
2026-08-12 · found by: seeding · pattern: `TEST-SUITE`

The seed did not bite because nothing tested the property. Discovered only because the
seeding practice requires watching a seed fail. Fixed with both a value seed and a wiring
seed (the scan stops calling the stamper).

Substantiated from: commit `fb7f251` body.

### M103 · Seed 32 — a `const` is fixed at load, so a re-derived expression evaluated to the same number
2026-08-12 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 2)

Seeding a derivation that happened to evaluate to the original value changed nothing
observable. The line executed; the modification altered no behaviour. Re-seeded with a
differing value; it then bit. This is the worked example behind precondition clause 2.

Substantiated from: commit `83edd09` body; CLAUDE.md, the seeding precondition.

### M102 · Seed 34 — the substitution silently failed and the run was green because nothing changed
2026-08-12 · found by: seeding precondition · pattern: `TEST-SUITE` (precondition 1)

Same class as a seed landing on unreachable code, from the opposite direction: the file
was never modified. Re-applied correctly; it then bit.

Substantiated from: commit `46ffa0a` body.

### M101 · A deliberately weakened assertion, recorded rather than hidden
2026-08-12 · found by: build · pattern: `TEST-SUITE`

Whether a closed `<details>` zeroes its children's layout box is engine-dependent in
headless, so measuring height would have tested the renderer rather than the restructure.
The assertion was weakened to the structural property. Recorded here because a weakened
assertion that goes unrecorded is indistinguishable from one nobody noticed.

Substantiated from: commit `46ffa0a` body.

### M100 · The sell discriminator was ruled, shipped as traces, and reported as done
2026-08-12 · found by: self-correction on the record · pattern: `CLAIMS-VS-CODE`

The ruling asked for a **computed** classification. What shipped was per-bucket traces
plus a mechanism narrative — and reading a trace by eye is precisely what the ruling
ruled out. Reported as a correction in the next pass rather than absorbed silently, and
built as computation in `1ac9ea2`.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §9 ("I have to correct the record
on one point"); commits `fb7f251`, `1ac9ea2`.

### M099 · The fill model is bimodal per bucket, and it selects against fast legs
2026-08-12 · found by: hypothesis tested against the code · pattern: `CAUSALITY`

Two faults, together: **A** — a bucket credits only if its 5-minute *average* cleared the
ask, so a bucket whose average sat below it scores zero even though it certainly contained
prints above (that is what an average means, and the trader's own sale is one of them).
**B** — a bucket that does pass credits `floor(hv × capture)` on the bucket's *entire*
high-side volume, including prints below the ask that could not have filled the offer.
Zero-or-everything per bucket. A fast sell resolves inside one to three buckets, so a sell
into a brief spike — which is what a fast sell *is* — scores zero and reads "never-sold".
Consequence: the "1 of 43 completing" headline rests on this model, and is frozen. Fault A
was already documented as a bias on the BUY side and **was never carried on the sell
panel**, so a known bias went unnamed on the leg where it binds hardest.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §6 and §9; HANDOFF.md §1a.

### M098 · The analysis export shipped a rollup without its rows — in the first export built after the rule was widened
2026-08-12 · found by: audit scan (interrogability) · pattern: `INTERROGABILITY`

The interrogability rule was widened from screens to artefacts, and the very next export
built carried the sell-leg aggregate alone. Fixed to parity with the buy: per replayed
flip, window offsets, both verdicts, credited percentages on both bounds, the reach
census, the at-price count, and the bucket-by-bucket trace, with truncations declared.
Worth keeping because it shows how fast this particular defect regrows.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §6 ("This was the interrogability
rule violated in the first export built after widening it — the aggregate shipped alone").

### M097 · Epoch 1 was invisible until a field existed that could show it
2026-08-12 · found by: reasoning about the reset · pattern: `SILENT-STATE`

The corrupted epoch had to be **discarded** rather than partitioned, because nothing
recorded which build wrote each trip. The moment `openSeq` existed, a corrupt population
became identifiable by a field. Generalised: every trip now stamps `FILL_MODEL_V`, so a
future model fix partitions the epoch instead of invalidating it. Also: a per-trip
predicate can exclude *rows*, but the divergence ledger, the rolled counters and the
exception evidence are **cumulative** — no filter applied afterwards un-mixes a rolled
total, which is why the author's own interim (exclude the bad trips) was superseded.

Substantiated from: commits `ee5d737`, `325ecb6`; `audits/AUDIT-2026-08-12-scope.md` §11.

### M096 · The family cooldown fused two unrelated jobs, and the stall it caused was invisible
2026-08-12 · found by: diagnosis on report of a quiet book · pattern: `SILENT-STATE`

`shadowScan` blocked a family whose last trip was open **or** closed within `2 × FILLH()`.
`FILLH()` is the gap to the next touch, so at the evening touch the cooldown was
**nineteen hours** — longest exactly when the book has the most observation time and the
most to learn. Closing did not release a family, and family keys repeat, so once a wave
opened the book was quiet by construction. **The defect was that none of this was
visible:** a stalled generator and a quiet market are identical in every number on the
page. One constant was doing two jobs — concurrency (a property of being open, needing no
duration at all) and sample independence (a property of sampling, needing a fixed
interval) — and the fusion let the sampling rule inherit an exposure rule's scale.
`shadowScanState()` now computes the reason from the same values the scan gates on, and
the headline renders it whether or not anything is wrong.

Substantiated from: commits `ee5d737`, `eb26bae`; `audits/AUDIT-2026-08-12-scope.md`
§10 and §12.

### M095 · `estH` written onto every candidate and never read
2026-08-12 · found by: audit scan (orphan) · pattern: `ORPHAN`

Write-only data at `index.html:4060`. Recorded rather than removed, since removing
production fields was not what had been asked — flagged so it is a decision rather than
an oversight.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §7.

### M094 · `daysBenchedBy(id, gate, 7)` counted days nothing had looked at
2026-08-12 · found by: audit scan · pattern: `UNOBSERVED`

Gate-persistence proposals read "benched by this gate on 4 of the last 7 days" with a
denominator of 7 even when the app was closed for three of them. The numerator was always
honest — a ledger row exists only on a day a plan actually built — so the defect was
purely the denominator claiming a period nothing observed. **The 4-of-7 bar is the
standard that moves gate constants**, and a standard must not be read against an inflated
window. Fixed: `observedDaysIn()` is the ledger of days a plan built, `daysBenchedBy()`
returns the pair `{n, obs}` so no caller can render the numerator without its coverage.

Substantiated from: CLAUDE.md BINDING, observed-time entry; REQUIREMENTS.md §51,
probes `[R51.1]` `[R51.2]`.

### M093 · "None carry multi-day persistence" where the bar was arithmetically out of reach
2026-08-12 · found by: audit scan · pattern: `SILENT-STATE`

The gate-persistence pile reported no persistence when the truth was that fewer than four
days had been observed and the 4-day bar could not be met. **Unreachable is not absent**,
and on screen the two are indistinguishable. Second instance of the never-fed-aggregate
shape in the same review; the copy now says which.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", observed-time widening
paragraph.

### M092 · The fill-horizon estimator's copy and computation had drifted apart, four ways
2026-08-12 · found by: audit against the ruling as restated · pattern: `CLAIMS-VS-CODE`

(a) **Reach share was carried nowhere**, though the ruling asked for it as a reported
figure. (b) **The window count was picked silently and the comment claimed the ruling had
specified it** — it had asked for the count to be proposed with reasoning. (c) **"Median
of the last 6 hours" was computed over however many readings existed**, so with two
readings the basis string claimed a statistic the computation did not support. (d) Found
while fixing (c): **the plan line's tooltip still described the pre-Aug-12 formula** —
`qty ÷ (buy-side 1h flow × 15% capture)` — for as long as the corrected input had been
live. All four are one class.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §7; commit `a851974` body;
REQUIREMENTS.md R50.3, R50.4, R50.5.

### M091 · The 1.32× optimistic lean came from an oracle variant using future information
2026-08-12 · found by: measurement · pattern: `CLAIMS-VS-CODE`

The lean that a correction was going to be built around divided by *in-window* flow,
which is information the estimator cannot have at prediction time. With the shipped input
the median observed/predicted is 0.70× — slightly pessimistic. **There is no stable
offset worth correcting; the residual is spread, not bias.** Recorded so nobody goes
looking for it again.

Substantiated from: HANDOFF.md §1b ("Answered, negatively — do not go looking for it").

### M090 · A pump defense's stated single lift path was contradicted by four calendar paths
2026-08-12 · found by: audit scan (restraint-lift, first run) · pattern: `RESTRAINT-LIFT`

The standing rule says a flagged pump caution lifts on **one** path, the user's
dismissal, "nothing else". Four calendar paths contradicted it: `validUntil` deactivation;
`intelSweep()`'s pending auto-dismissal (and the fingerprint counts any warning not
dismissed, so that broom was a lift hiding behind queue hygiene); `rulingsSweep()`'s
30-day staleness broom; and — found while writing the fix — **the anomaly leg's own
window, which let a defense that had already fired un-fire itself as its evidence aged.**
Evidence ageing is not evidence against. Only the first was in the initial report; the
enumeration is what surfaced the rest.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §4; commit `a851974` body.

### M089 · Ratified cautions lifted by the calendar with no press at all
2026-08-12 · found by: audit scan (restraint-lift, first run) · pattern: `RESTRAINT-LIFT`

A ratified `promotion-warning`, `watch-note` or `deflation-flag` stopped applying at
midnight on `validUntil`: item tags vanished, the sleeve stopped refusing the item, and a
`teeth` haircut lifted. Under the old wording this was fine — nothing was *armed*. Root
cause: the restraint/deployment rule had been written about **arming** a deployment and
said nothing about a caution ending by the calendar. Fixed with a `lapsed` state — the
caution keeps applying and asks once, batched — and the bulk action is deliberately the
restraining one ("extend all", never "drop all").

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §4; CLAUDE.md BINDING,
restraint/deployment entry; REQUIREMENTS.md §52.

### M088 · Two constitutional rulings could not both be read literally
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `SCOPE-NAMING`

"Advisory layers stay advisory" and "Membership bookkeeping applies itself" were in
direct conflict; the membership ruling superseded the first in one place and did not say
so. Left unresolved for a day (flagged in HANDOFF.md as "one live conflict"), then fixed
in place: the advisory rule now names its own supersession, its date and the carve-out,
with an instruction that the two are read together and neither quoted alone.

Substantiated from: HANDOFF.md §4; `audits/AUDIT-2026-08-12-scope.md` §1; CLAUDE.md
BINDING, advisory-layers entry.

### M087 · Most constitutional rules named the surface where a defect was found, not the property violated
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `SCOPE-NAMING`

**Ten rules** were too narrow to reach the next instance of their own defect. The worked
example: a rule written as "never blend a *rate*" — itself already a generalisation of an
earlier rule written about *net* — did not reach a pooled *median* three days later.
Others: interrogability bound screens and said nothing about files; observed-time bound
the paper book's reconstruction only; restraint/deployment covered arming and not
expiry; entity-state covered only allocator-touched entities; metric honesty was written
as a response procedure and did not bind unprompted copy; corrections were scoped to
intelligence records. Fixed by widening all ten, each carrying its escaping instance, and
by the prophylactic: **name the property first; the surface is only the example.** The
companion ruling split the constitution into BINDING and DOCTRINE, because a rule that
looks enforceable and isn't is the same defect class as a detector that cannot fire.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §1–§2; CLAUDE.md, the prophylactic
at the top and the ten widened entries.

### M086 · The R49.2 repair's first seed failed both forms — the fixture could not tell them apart
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (seventh face)

Deleting the split from the one gate blend failed the whole-section match too, because
the fixture held only one blend, so a section-wide pattern had nothing else to satisfy
it. **That would have been recorded as proof and would have proved nothing.** Rebuilt
with two gates carrying identical splits, the seed separated them; a standing assertion
now holds the fixture to carrying the decoy, so the scoping test cannot quietly become
untestable again. Where the dead seed changes nothing, this one changes too much; both
report as proof.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §3; CLAUDE.md Verification,
seventh face.

### M085 · `[R49.2]` matched against the whole page — the broad-container assertion
2026-08-12 · found by: audit scan (constitutional scope) · pattern: `TEST-SUITE` (sixth face)

The assertion checked that a specific per-gate fill rate carries its cohort split by
testing `/watchlist 100% of 2/` against the entire page's HTML, which any other blend
anywhere on that page would have satisfied. **It ran, on real production output,
exercising real production code, and would have passed with the property deleted from its
subject.** This is the instance that forced the root property to be widened from "the
test never ran" to "…or ran and passed for a reason other than the property it names".
Fixed with `blendFrag(html, key)`, which scopes every per-surface pooling assertion to
the one `data-drill` element and its inline sibling.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §3; HANDOFF.md §4 ("A seventh face
… not yet in case law"); CLAUDE.md Verification.

### M084 · `[R40.1]`'s tolerance of 3.6 microseconds was asserting the clock, not the behaviour
2026-08-12 · found by: accident, while seeding an unrelated defect · pattern: `TEST-SUITE`

`planHorizonH()` reads the clock internally, so comparing it against `gapHoursAt(Date.now())`
at `1e-9` hours was comparing **two separate clock reads**; it passed only when both landed
in the same millisecond. Green for a day. Split per the intermittent-assertion ruling: the
behaviour is tested at one injected instant, the wiring keeps a tolerance of 3.6 *seconds*,
which is what "two reads moments apart" actually claims.

Substantiated from: CLAUDE.md Verification, "The simultaneity assertion"; commit `e0edba2`.

### M083 · Two seeds hid each other
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed, variant)

Commit `f8a0a73` seeded the ambiguous-reachability widening and the reconstruction
touch-history rule together. With the widening removed, passing a touch into a rule that
ignores touches changes nothing, so the second defect had no way to express itself and its
assertion stayed green. Neither seed was wrong; their interaction was. **Seed one at a
time; when a batch is unavoidable, re-run anything that did not fail in isolation.**

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `f8a0a73`.

### M082 · The calibration probe built its own replay window
2026-08-12 · found by: seeding · pattern: `REIMPL`

Seeding the window-anchor defect changed nothing the suite could see, because the probe
constructed the input the product would have constructed. **If a probe line constructs an
input the product would have constructed, the product's constructor is untested.**
Extracted as `calibWindow()` and `calibSummarise()` and re-seeded before it counted as
proof. Second instance of the reimplementation trap **in one day**.

Substantiated from: CLAUDE.md Verification, "The assertion that re-implements what it
tests" (the recurrence paragraph); commit `1f61df5`.

### M081 · The calibration window was anchored to the wrong end of the trip
2026-08-12 · found by: build review · pattern: `CAUSALITY`

The one calibration run performed before the fix (2-of-4) is **VOID** and, if
`DB.calib` still holds those numbers, they are wrong. Carried in HANDOFF.md as pending on
the operator, because the fix cannot reach a number already stored in the browser.

Substantiated from: commit `1f61df5`; HANDOFF.md §2 item 1.

### M080 · A dead safeguard: a 60-bucket trim behind a stored cap of 24
2026-08-12 · found by: seeding, then reading the two files against each other · pattern: `TEST-SUITE`

The calibration export trimmed any trace over 60 buckets to its first and last 20 — a rule
written into the requirements and rendered in the file's own truncation notice. The stored
trace cap was 24, so **the trim could never fire**. Nothing was wrong with either number
in isolation; the defect lived in the relationship, which no single reading of either file
surfaces. A guard whose trigger its own upstream limits forbid is decoration that reads as
protection. Fixed by raising the stored cap so the rule has work to do.

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `cff4655`.

### M079 · A second dead safeguard, and the dead seed that followed it
2026-08-12 · found by: seeding · pattern: `TEST-SUITE` (dead seed)

The same export carried a defensive fallback for an empty duration bucket while
`calibSplit()` already guaranteed both groups — unreachable. Seeding it changed no
behaviour, so the suite stayed green, **which reads exactly like "the assertion is weak"
and is in fact "the code you broke never runs."** Fixed the other way from the trim: the
dead branch was deleted and the assertion pointed at the upstream guarantee. *Choose by
asking which layer should own the promise, then make sure exactly one does.*

Substantiated from: CLAUDE.md Verification, "Dead safeguards and dead seeds"; commit `cff4655`.

### M078 · "A median 37% of intended size" was four populations averaged
2026-08-12 · found by: decomposition · pattern: `POOLING`

The figure read as a book-wide sizing problem. Split by cohort it is watchlist **100%**,
scanner T1 **37%**, scanner T2 **36.8%**, discovery slice **8.3%** — the items closest to
fundable fill completely. **On that sample it is evidence for the gates, not against
sizing**, which is the opposite conclusion. Fixed with `rateBlend()`, which emits the
blend and the split together so a caller cannot produce the first without the second.

Substantiated from: CLAUDE.md BINDING, never-pool entry; HANDOFF.md §1e; REQUIREMENTS.md §49.

### M077 · Two more pooled statistics that the rate-shaped rule did not reach
2026-08-12 · found by: audit scan (pooling, first run) · pattern: `POOLING`

`paperEconomics`' **median trip net** pooled four cohorts, and calibration's **median
share credited when wrong** pooled fast and slow legs. Neither is a rate, so `rateBlend()`
never saw them and the rule as written did not classify them. This pair is what forced the
second widening — from "never blend a rate" to "never pool a statistic, rate, median,
count, verdict or score alike".

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §5; CLAUDE.md BINDING, never-pool
entry.

### M076 · "Fill rate 100%" everywhere, with `neverFilled` zero in every rollup
2026-08-12 · found by: external analysis of the exports · pattern: `SILENT-STATE`

Every stratum and every hour reported 100%. A model built on the premise that
would-never-have-filled is the finding was finding it never. Root cause: **a rate with no
counterexample count reads as a claim when it is a default.** Every rate now renders its
counterexample count.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", second companion;
REQUIREMENTS.md §43.

### M075 · A ratio whose denominator was filtered by its own numerator
2026-08-12 · found by: external analysis of the exports · pattern: `POOLING`

The per-stratum sampling counter sat **after** the near-miss filter, so it counted only
items that had already qualified: near-misses were 577 of 578 sampled items — 100% by
construction — and contradicted the funnel's own attribution. *Count the population where
the test runs, not where it passes.*

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", third companion.

### M074 · The probe re-implemented `strataCount` and passed with the bug fully intact
2026-08-12 · found by: seeding · pattern: `REIMPL` + `CLAMP`

The assertion that the per-stratum sampling counters summed correctly **computed the
counts itself, in the probe**, rather than calling the production path — so it passed with
M075's bug live in `index.html`, because the bug was in code the assertion never touched.
The same instance is also the first occurrence of clamp absorption: the counter sat behind
the near-miss filter, so the probe's own arithmetic could not see it. The tell is a probe
line that *computes* rather than *calls*. Fixed by the extraction pattern — pull the logic
into a named function and point the assertion there.

Substantiated from: CLAUDE.md Verification, "The assertion that re-implements what it
tests"; CLAUDE.md BINDING, clamped-output entry (`strataCount` named as the first of the
two instances).

### M073 · Causality: the simulator filled legs from tape that printed before they existed
2026-08-12 · found by: external analysis of the exports · pattern: `CAUSALITY`

The fill model credited a leg from a trailing five-minute aggregate on the leg's **first
tick**, and re-credited the same bucket every poll. **182 of 272 trips opened and closed
in under a second (median 55ms), all "filled", booking 52% of the headline net** from tape
that predated them. Rules now: a simulated leg may only be filled by tape that printed
after it was placed, each bucket counted once, and a trip that resolves in its opening
cycle is a bug rather than a fill.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate", first companion;
commit `d305c2f`; REQUIREMENTS.md §43.

### M072 · The regime race reported three zero curves for a whole epoch while nothing had ever fed it
2026-08-12 · found by: external analysis of the exports · pattern: `SILENT-STATE`

The machinery that exists to answer whether the 1.2% ROI floor is right spent an entire
epoch reporting three zero curves and a two-day all-zero divergence ledger while **not one
of 272 paper trips had ever been assigned to a regime.** Four of six entry paths hardcoded
an empty set instead of evaluating, and in that epoch those four were 96% of the book.
Root cause: membership was a **label individual entry paths had to remember to attach**
rather than a property of the candidate evaluated once centrally. Consequence: a stat that
renders 0 because nothing FEEDS it is indistinguishable on screen from one that renders 0
because nothing QUALIFIED, and the two mean opposite things.

Substantiated from: CLAUDE.md case law, "the never-fed aggregate" (user ruling); commit
`d305c2f`.

### M071 · Instant trips: the export could not answer the question asked of it
2026-08-12 · found by: diagnosis on request · pattern: `SILENT-STATE`

Asked to explain sub-second paper trips, every close path was traced and **no path in the
current code can produce one**. The real defect was that the file could not settle it:
`openedAt`/`closedAt` are ISO strings, which truncate to the second, so "resolved in under
a second" and "resolved within the same second" are indistinguishable; and the rule is
stated in **poll cycles** while the file carried no cycle at all. Shipped as
instrumentation (`resolvedInMs`, `openPollSeq`) rather than as a fix — a null
`openPollSeq` *is* the diagnosis. One latent gap recorded rather than claimed as the
cause: `reconReplay` is the one close path where the minimum-life rule was never written.

Substantiated from: `audits/AUDIT-2026-08-12-scope.md` §8; commit `fb7f251` body.

### M070 · Re-importing an already-ratified record was silently absorbed
2026-08-12 · found by: shipping a correction · pattern: `COMPOSITION`

Withdrawing the contaminated Jul-24 numbers from a brief exposed it: **eleven corrected
records would have left the wrong numbers on screen while the brief claimed they were
fixed.** Root cause: the import path treated re-arrival of a known record as a no-op, so
there was no landing path for a correction to an artefact the user had already read.

Substantiated from: CLAUDE.md case law, "the Jul 24 volume artifact", third corollary;
`briefings/BRIEF-2026-08-12.md` ("A defect found while shipping the corrections, and
fixed").

### M069 · A data-feed methodology change was read as market signal for four sweeps
2026-08-12 · found by: normalising against a control · pattern: `POOLING`

On 2026-07-24 reported GE volume stepped ~5–7× across the entire market at once, prices
flat. The accumulation-anomaly scan compares each item against **its own** volume 2–3
weeks earlier, so every baseline straddling that date showed a several-hundred-percent
gain; the scan raised seven flags reading "+418%", "+546%", "+930%". Four went to the
analyst desk for up to four sweeps hunting a story that did not exist, generating
watch-notes and a suspected-pump escalation off a number that measured the API.
Normalised against a control band, **not one flagged item showed item-specific growth;
three were below market.** Root cause: self-comparison cannot distinguish "this item
moved" from "the ruler changed length". Fixed with `VOL_INDEX_BASKET`. Two corollaries
cost something too: suppression means **not flagged**, not flagged-on-half (the
accumulation signature is price AND volume; flagging on price alone invents the missing
half); and the index is itself an aggregate whose one failure mode is visible only in its
control rows, so the panel opens to them.

Substantiated from: CLAUDE.md case law, "the Jul 24 volume artifact" (user ruling);
commit `4b104aa`; `briefings/BRIEF-2026-08-12.md`.

---

# 2026-08-11

### M068 · The observation floor disqualifies the strategy the schedule exists to enable
2026-08-11 · found by: audit scan (cadence impact, before the build) · pattern: `COMPOSITION`

`shadowTick` credits observation as `min(now − lastObs, SHADOW_OBS_CAP)` with the cap at
10 minutes, so a closed tab collapses an entire gap to one capped credit. An overnight
paper trip against a 9.5h horizon accrues **~1.7% observed share**, and the 25% floor
excludes it. **Every overnight paper trip would be excluded as "insufficient
observation."** Neither component was malfunctioning; the defect was entirely in their
interaction, and it fell on exactly the strategy the four-touch shape was adopted for.
Reported with three options and no recommendation smuggled in, because it is a strategy
parameter.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §0.

### M067 · `limitWindows()` was a constant 2, overstating daytime sizing by up to 2×
2026-08-11 · found by: audit scan (cadence impact) — **not in the brief** · pattern: `COMPOSITION`

`limitWindows() = floor(DB.horizonH / 4)` = 2 at the default 10h day horizon, and it
multiplies the buy-limit cap in three sizing paths. A 5h daytime placement can roll only
**one** 4h buy-limit window. Daytime sizing on buy-limit-bound items was overstated by up
to 2× — the most concrete "tuned for a long sit, misbehaves at 5h" case in the audit, and
a real capital consequence rather than a display one. Found by sweeping for constants that
divide by a hardcoded 4h or assume two touches, which is a scan nobody asked for.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §5.

### M066 · `staleBuyInfo` split the day at a hardcoded 15:00
2026-08-11 · found by: audit scan (cadence impact) · pattern: `COMPOSITION`

A literal two-touch convention baked into a constant. Under four windows it is simply
wrong. Same class: the ladder rungs measured against a global horizon rather than the
leg's own, so an evening leg would hit rung 2 at 05:00 while still mid-sit.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §5; CLAUDE.md cadence section
("A leg ages against the horizon it was PLACED under").

### M065 · Seasoning qualified twice as fast because the cadence changed underneath it
2026-08-11 · found by: audit scan (cadence impact) · pattern: `COMPOSITION`

`updateQualStreaks` is poll-driven but effectively visit-driven at a ~6-minute touch, so
doubling the touches halved the time to clear "3 passes spanning ≥2h" — from ~1.5 days to
inside one day, **with nobody changing the rule.** Whether that is acceptable depends on
what the rule was buying, so it was reported as needing a ruling rather than rescaled.
Re-expressed as 3 passes, one per touch, spanning ≥1 calendar day.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §4 and the build report.

### M064 · The couch-minute metric halved for a bookkeeping reason
2026-08-11 · found by: audit scan (cadence impact) · pattern: `CLAIMS-VS-CODE`

`touchSessions()` counts `DB.touchLog.length`; four touches a day is four sessions rather
than two, so at an unchanged minutes-per-visit the gp/attention-minute metric halves for
the same daily gp. Arithmetically correct and directionally misleading — **the number
falls because attention is counted more finely, not because it got worse.** Rule: when a
metric's denominator changes because the cadence changed, show both sides and state the
change in place.

Substantiated from: `audits/AUDIT-2026-08-11g-cadence.md` §1; CLAUDE.md cadence section,
final bullet.

### M063 · Forced exits priced at the moment we noticed, booking days of drift as simulated P&L
2026-08-11 · found by: pre-absence audit · pattern: `CAUSALITY`

Paper trips whose horizon expired during a closed tab were force-exited at **today's**
price. Consequence: the whole counterfactual baseline argued for **looser** gates on
evidence of fills that never happened, and had to be discarded — this is the defect that
caused the epoch reset. Fixed properly later (Aug 11g) by pricing forced exits at the
series value **at the horizon**, which is correct on a perfect host too.

Substantiated from: commit `828f526` body; commit `0ea4791` (the purge);
`audits/AUDIT-2026-08-11g-cadence.md`, build report.

### M062 · Scout wiped the watchlist on the first open after 48h away
2026-08-11 · found by: pre-absence audit · pattern: `SILENT-STATE`

The 7-day chart cache is in-memory and empty on a cold boot, so every item failed "chart
still loading", no `lastPass` refreshed, and the eviction fired **with a demonstrably
false reason.** A cold cache was read as evidence about the items. Fixed: nothing may be
culled unless its chart actually loaded; same guard on the sibling washout.

Substantiated from: commit `828f526` body.

### M061 · The chart never refreshed in a long-lived tab
2026-08-11 · found by: pre-absence audit · pattern: `STALENESS`

Trend, momentum and volume-trend gates judged today's prices against a chart fetched at
boot — potentially a fortnight stale. A long-lived client has to notice its own staleness;
nothing did. `fillSparks` now rides the poll.

Substantiated from: commit `828f526` body.

### M060 · Regime evidence said "4 of the last 7 days" while reading 7 rows that can span a month
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

**A full day before the observed-time rule existed, and the same defect that recurred in
`daysBenchedBy` (M094) on Aug 12 and in the exception lane's `spanD` (M127) on Aug 13.**
Fixed locally at the time: it now says *readings*, and names the span. The general rule
was not written until the third occurrence.

Substantiated from: commit `828f526` body ("Regime evidence said '4 of the last 7 days'
while reading 7 rows that can span a month after an absence").

### M059 · Seasoning counted a five-day gap as a pass
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

A gap is not an observation. Same root as M060, in the same sweep.

Substantiated from: commit `828f526` body.

### M058 · Die-off counted unobserved windows as the gate being right
2026-08-11 · found by: pre-absence audit · pattern: `UNOBSERVED`

"Still under the floor at +24h" was credited to the gate when nobody had looked. Now "not
confirmed recovered", which is what was measured. Third instance of the same root in one
commit — a signal that should have produced the general rule and did not.

Substantiated from: commit `828f526` body.

### M057 · `/timeseries` had no backoff and no negative caching
2026-08-11 · found by: pre-absence audit · pattern: `STALENESS`

An endpoint rejecting timeseries while `/latest` stayed healthy would be re-hit thousands
of times a day, unattended, with nothing on screen. Circuit breaker, visible banner and
stale-cache fallback added.

Substantiated from: commit `828f526` body; REQUIREMENTS.md §32.

### M056 · A row with paper history rendered nothing below 3 closed trips
2026-08-11 · found by: pre-absence audit · pattern: `SILENT-STATE`

The row's expand view showed the trips while the row itself showed nothing — **"the F18
defect in a new place"**, in the author's own words at the time. Any paper activity now
renders an accruing state.

Substantiated from: commit `828f526` body.

### M055 · Two indicator dots were both green filled circles meaning different things
2026-08-11 · found by: use · pattern: `SILENT-STATE`

Adjacent, identical, different meanings. Fixed by making **shape** carry identity (paper
is circle-in-circle, test stays plain) and colour carry state within it, with fixed slots
so a missing dot leaves its space, self-naming tooltips and a legend showing every state
side by side. Also: the test dot moved to neutral steel, because verified-vs-stale is not
good-vs-bad.

Substantiated from: commit `828f526` body.

### M054 · Accrual was coupled to a render path that "happened to run"
2026-08-11 · found by: trace on request, before an unattended run · pattern: `COMPOSITION`

Every plan-driven ledger — gate-health rows, die-off episodes, qualification streaks,
paper positions, the per-stratum sampling ledger and the hourly funnel bucket — was
written from inside `renderDeploy`, reached through the vitals renderer. That happened to
run on all four tabs, so nothing was broken that day. **"Happens to be called from the
current layout" is exactly the coupling that produced the reorg accrual bug (M025), and it
fails silently the next time a surface moves.** Accrual now rides the poll directly.

Substantiated from: commit `b9c8add` body; REQUIREMENTS.md R34.1.

### M053 · Granted exceptions survived the purge that destroyed their evidence
2026-08-11 · found by: reasoning about the purge · pattern: `SILENT-STATE`

Exception grants are **rulings**, so nothing revokes them by machine — but a ruling that
survives its own justification would have persisted by inertia with nothing saying so.
Each now raises its own walk-up line until deliberately settled, and the decision log
keeps re-made-on-new-evidence and re-made-on-judgment apart, because they are different
claims that would otherwise read alike.

Substantiated from: commit `fcfb2dd` body; REQUIREMENTS.md R26.5.

### M052 · The glossary advertised a gesture nothing implemented
2026-08-11 · found by: rewriting the glossary · pattern: `CLAIMS-VS-CODE`

The old glossary said "on the phone, tap any badge for its explanation" and **nothing
implemented it** — a claim in copy with no machinery behind it. Absorbed by the rewrite
rather than left standing beside the new work.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2.

### M051 · Nineteen glossary entries covered ~19 of ~150 rendered terms, and two of them were stale
2026-08-11 · found by: audit scan (glossary coverage, first run) · pattern: `CLAIMS-VS-CODE`

Coverage was roughly 13%. Two surviving entries made **location or authority claims** that
had gone false the same day: per-basket P&L "reported in the review" (it had moved to the
Sleeve tab) and "candidates never cap anything until you ratify them" (superseded by the
auto-apply ruling). Both now regression-asserted, **because a stale claim about where
something lives is the shape this file will keep producing.** Rewritten to 70 entries in 7
groups, generated from a `GLOSSARY` data structure so coverage is checkable rather than
eyeballed.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, glossary addendum.

### M050 · Glossing a control that already explains itself
2026-08-11 · found by: use · pattern: `COMPOSITION`

The ⚠ caution chip is a **button** whose press opens the row's expand view with every
caution and its reason; a definition popover on top of it competed with the thing being
reached for. Same for the expand view's own caution lines, which already render their
`why` inline. Rule: **gloss vocabulary, never an affordance.** Found by using the tool, not
by the suite.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, defect 2.

### M049 · The hover bridge — dead space closed the popover before its link could be reached
2026-08-11 · found by: use · pattern: `COMPOSITION`

Crossing the gap between a term and its popover fires `pointerout` with a relatedTarget
that is neither element. Closing is now deferred ~260ms and cancelled if the pointer
arrives at the popover or returns to the term. Recorded with M050 because neither was
catchable by any assertion that would have been written first — they are now.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, defect 1.

### M048 · `[R39.8]` failed against correct app code — an ambient event from an earlier block
2026-08-11 · found by: seeding/diagnosis · pattern: `TEST-SUITE`

Dismiss-on-scroll was right; a scroll event left over from earlier fixture activity was
closing the popover mid-measurement. **An async ambient event from an earlier block
landing inside a later block's measurement window** — a sibling of the clock-dependence
already in case law, diagnosed the same way: disable the suspected mechanism, confirm the
assertion passes, restore. The fixture now settles scroll position and drains pending
events.

Substantiated from: `audits/AUDIT-2026-08-11f.md`, Addendum 2, "A fixture finding".

### M047 · `[R18.1]` failed at random, roughly 1 run in 7
2026-08-11 · found by: repeated suite runs · pattern: `TEST-SUITE` (fifth face)

It compared the whole paper book's length across a rescan, folding the dedup rule it
claimed to test together with the discovery slice's draw — whose family key embeds the
first-failing gate and whose stratum comes from the price cycle, both functions of the
clock. **A test that fails at random teaches the operator to ignore failures, which is the
same damage as a test that cannot fail.** The ruled fix is the durable part: **never
stabilise by pinning the ambient input** (pinning the fixture clock would have traded a
flaky assertion for a silently-wrong one everywhere `S.latestAt` carries staleness
meaning). Instead inject the varying input, or assert the property that holds across all
its values; if neither is possible, split the assertion in two.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5 (the open finding);
`audits/AUDIT-2026-08-11f.md` §6 (the fix); CLAUDE.md Verification.

### M046 · The epoch-banner assertion was vacuously true
2026-08-11 · found by: seeding · pattern: `TEST-SUITE`

`!shadowEpochYoung() || …` passes whenever the banner is not due, and the fixture never
made it due. Now forces the young state, asserts, and restores.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5.

### M045 · The hours-table assertion had an escape hatch, and the fixture took it
2026-08-11 · found by: seeding · pattern: `TEST-SUITE`

It read "if the panel has hour data, check the two streams, else pass" — and the fixture
had no hour data, so it passed vacuously. The fixture now seeds `roiHour` readings and the
guard is gone. Same shape as M043: a detector written for the right property with a fixture
that prevented the property from expressing itself.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §5.

### M044 · A probe line ending `… || true`
2026-08-11 · found by: reading the suite · pattern: `TEST-SUITE` (first face)

Written to check the poll calls the accrual step. It passed unconditionally and asserted
nothing whatever. The plainest possible instance of the root, and the one the case-law
section opens with.

Substantiated from: CLAUDE.md Verification, "The `|| true` assertion".

### M043 · The R29.4 durability detector was built so its own defect could not express itself
2026-08-11 · found by: seeding · pattern: `TEST-SUITE` (second face)

It seeded a closed record, rolled it, **then** aged it past the retention window — so it
passed whether the roll happened before or after the prune, which was the entire property
under test. **It was written specifically to catch that bug and still could not.** Rewritten
to start from a record already past the window. This is why the seeding practice binds every
new assertion, not only detectors written for known bugs.

Substantiated from: CLAUDE.md Verification, "The R29.4 durability detector".

### M042 · `[R24.2]` — "target top in viewport" passed with the title hidden under sticky chrome
2026-08-11 · found by: use, then seeding · pattern: `TEST-SUITE` (fourth face)

Which is precisely how the deep-link offset bug shipped green. DOM position is not visible
position. Fixed by asserting the first **visible** title sits below the chrome's bottom edge,
with `scroll-margin` derived from measured sticky chrome.

Substantiated from: CLAUDE.md Verification; commit `f9848ff`.

### M041 · `[R22.2]` — existence assertions cannot test a scoping rule
2026-08-11 · found by: user report of the regression · pattern: `TEST-SUITE` (third face)

The assertions checked `querySelector("#tab-home #homeRulingsPanel")`, which succeeds
whether or not CSS hides the element. **A display-layer bug was structurally invisible to
an existence-based test**, and the prior report's claim of "verified" was true of structure
and false of the screen. Rewritten to assert the negative — `offsetParent === null`,
`getComputedStyle(...).display === "none"` — on the surfaces that must be clean, and then
**proven against the original defect** by reintroducing the bad selector and watching it
fail with exactly the reported symptom.

Substantiated from: `audits/AUDIT-2026-08-11d.md`, "Why the probe passed"; CLAUDE.md
Verification.

### M040 · An ID selector silently overrode the tab gate, rendering Home on every tab for a day
2026-08-11 · found by: user report · pattern: `COMPOSITION`

`#tab-home{display:flex;flex-direction:column}` outranks `section.tab{display:none}`, so the
Home section computed `display:flex` on **every** tab from commit `959aee9` onward. The
scoping work shipped two commits later was applied to the correct render branch and was
reported as verified; the CSS gate it depended on had already been overridden. Fixed with
`#tab-home.on{...}` so the layout composes with the gate instead of overriding it.

Substantiated from: `audits/AUDIT-2026-08-11d.md`, "The miss, explained (both halves)".

### M039 · Deep links landed on the review's *discussion* of a surface, not the surface
2026-08-11 · found by: user report, then generalised · pattern: `COMPOSITION`

Four call sites carried `review#ckstep-shadowbook` (the paper-book vitals tile, the NOW-bar
accrual line, two WHAT CHANGED lines) and one carried `review#ckstep-recipes`. The reported
defect generalised into a class, every destination was audited, and **the probe now asserts
the negative**: no deep link anywhere may point at a checklist step standing in for a real
surface.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §5.

### M038 · I4/I5/I6 — the observation floor's exclusion counts were bare numbers
2026-08-11 · found by: audit scan (interrogability, re-run) · pattern: `INTERROGABILITY`

**A count of what a verdict threw away is itself an aggregate**, and "3 excluded" that
cannot be opened is exactly the number the operator cannot audit. Three instances (gate
tree, cohort ledger, hours table), all introduced by the same build that introduced the
floor. Fixed in `thinNote()` itself rather than at the three call sites, so the next
aggregate reporting an exclusion inherits the drill-down.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §2.

### M037 · I1/I2/I3 — three bare counts on the three new sub-views
2026-08-11 · found by: audit scan (interrogability, first run) · pattern: `INTERROGABILITY`

Prospecting's **Filled** column, Gate Health's **funded lines** count, and the paper
stream's **"(N at 100%)"** reading were openable nowhere or only on a different surface.
All three shipped in the same commit as the primitive that exists to prevent them — the
collection layer outrunning the display layer, in one build.

Substantiated from: `audits/AUDIT-2026-08-11e.md` §4.

### M036 · The recipe-basis monitor terminated in prose
2026-08-11 · found by: answering "what decision does this change?" · pattern: `ORPHAN`

It sized nothing, capped nothing, benched nothing, and fed no gate, no scout nomination and
no paper trip — the break rendered a sentence, and acting on it meant hand-carrying an item
name to the watchlist. Its manipulation-tell half duplicated `suspectedPump`, which is
already wired to auto-arm restraint. Ten hardcoded recipes is also a fixed, tiny universe
beside the stratified slice. Cut entirely rather than relocated; **if it returns it should
return wired**, which is a new capability with its own price tag.

Substantiated from: `audits/AUDIT-2026-08-11f.md` §7; REQUIREMENTS.md R31.1 (WITHDRAWN).

### M035 · F15 — probe-profile state leaked between runs
2026-08-11 · found by: a probe failing only after another run · pattern: `TEST-SUITE`

The headless profile's localStorage persists across runs, so a prior run's review
engagement leaked into the next run's early assertions. In the app the persistence is
correct; in the suite it is pollution. Noted at the time because the failure mode — "test
passes alone, fails after another run" — will recur for any future per-visit state that
skips the clean-fixture block.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F15.

### M034 · F14 — a new standing decision would have dodged the attention budget
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

The review-ready line is a decision point ("start review or not") that did not count
against the ≤7 budget — **exactly the double-standard the budget exists to prevent.** Now
counted, with the R13.1 fixture pinned so its exact-6 expectation still measures what it
always measured.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F14.

### M033 · F13 — the NOW bar could point into a hidden walkthrough
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

`nextMove` suggested "Walk-up · step N" from the raw checklist regardless of collapse
state, and knew nothing about an engaged review — the "two checklists demand attention"
state the ruling forbids, one layer up. Fixed by having `nextMove` read `ckEffectiveList`,
the same list the renderer draws, so the two surfaces cannot disagree.

Substantiated from: `audits/AUDIT-2026-08-11b.md`, F13.

### M032 · F18 — held and mm-owned items passed every gate and appeared in no bucket
2026-08-11 · found by: audit scan (auto-promote walk) · pattern: `SILENT-STATE`

No badge, no reason, no bucket. The auto-promote machinery was **working** — `buildPlan`
refunds from the ranked pass list on every recompute — and felt press-gated purely because
of display. **An unexplained state reads as a broken feature even when the machinery
underneath is correct.** This is the incident the entity-state rule is written from, and
the shape recurred at M056 (a row with paper history), M072/M093 (never-fed aggregates) and
M096 (a stalled generator).

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 4; CLAUDE.md BINDING, entity-state
entry.

### M031 · F17 — audit deep-links landed on the tab top, nine steps above the target
2026-08-11 · found by: audit scan (ruling-path walk) · pattern: `COMPOSITION`

"Rule it in the review's audit" navigated to the Review tab top. Fixed by anchoring.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 3.

### M030 · F16 — rulings made from the Home digest appeared to do nothing
2026-08-11 · found by: audit scan (ruling-path walk) · pattern: `COMPOSITION`

The ratify/edit-ratify/dismiss handlers re-rendered the Sleeve queue and the watchlist but
never the digest or the ⚖ badge: pre-reorg those handlers served the Sleeve cards, and the
reorg made the digest the primary ruling surface **without adding it to their render set.**
A ruling appeared to do nothing until the next poll — so "ratification actions not
findable" was the ruled line still sitting there after being ruled.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 3.

### M029 · The collapse control's first tap did nothing
2026-08-11 · found by: user report · pattern: `COMPOSITION`

Neither suspect was right. Every render pass rebuilt the checklist header via `innerHTML`
even when the markup was byte-identical, and a rebuild landing inside the tap window
(pointerdown on the old node, pointerup on its replacement) produces **no click event at
all**. Boot data arrives ~1s after open — right when a walk-up's first tap lands — and the
60s poll re-renders thereafter, which is why "works later or after reload" was the
signature. Fixed with `setHTML`, a content-diffed write.

Substantiated from: `audits/AUDIT-2026-08-11c.md`, Item 1.

### M028 · F12 — visit state does not survive export→import (accepted, stated)
2026-08-11 · found by: audit scan (orphan) · pattern: `COMPOSITION`

The delta clock and end-of-visit snapshot are attention state and sit outside the export
sanitizer, so a restored browser says "first visit with the delta tracker" instead of
diffing against a foreign baseline. Recorded rather than fixed **so the omission is a
decision and not an accident** — the alternative was considered and not recommended.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F12.

### M027 · F11 — stale feature-touch keys would have poisoned the dormancy report
2026-08-11 · found by: audit scan · pattern: `ORPHAN`

After the tab rename, `tab:watch`/`tab:shadow`/`tab:routine` stopped being written; in 90
days the dormancy report would have proposed demoting surfaces that are alive under the new
keys. A rename creating a **future** false signal, caught before the window elapsed. Fixed
with a one-time key migration.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F11.

### M026 · F10 — the rulings digest rendered twice on one screen
2026-08-11 · found by: audit scan (redundancy), caught mid-walk · pattern: `COMPOSITION`

Home's digest block and the walk-up checklist's "Rule on what's pending" step both rendered
`rulingsInline()` — the same interactive lines, twice. On Home the step is now a pointer.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F10.

### M025 · F9 — the boot-tab change would have silently starved the ledgers
2026-08-11 · found by: audit scan, caught mid-walk · pattern: `COMPOSITION`

The funnel ledger and the entire paper book were side-effects of `renderDeploy`, which ran
because the old boot tab was Watchlist. With Home as the boot surface, **sitting on Home
would have starved both** — and the paper book only fills while observed. Caught before the
build was called done. The general coupling was fixed later at M054.

Substantiated from: `audits/AUDIT-2026-08-11-reorg.md`, F9.

---

# 2026-08-10

### M024 · A strategy parameter was applied in-flight and disclosed in the summary
2026-08-10 · found by: user ruling · pattern: `CONSENT`

Entry-watch DISCOUNTED was set to ≤ −2% mid-build and mentioned in the summary; it was
ratified after the fact. **Judgment thresholds and verdict boundaries discovered mid-build
are strategy parameters** — propose them and leave them unapplied. Applying one and
mentioning it is a near miss, not compliance.

Substantiated from: CLAUDE.md BINDING, "Disclosure-in-summary is not ratification" (the
incident named in place).

### M023 · F8 — the funnel swallowed a negative residual
2026-08-10 · found by: audit scan · pattern: `SILENT-STATE`

The residual row rendered only when `N − stage kills − funded > 0`. A negative residual
would mean a stage double-counted a kill — **so the one number that could catch a funnel
accounting bug hid itself exactly when it fired.** Now renders an explicit accounting-error
row. It should never appear; that is what makes it a detector.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F8.

### M022 · F7 — `S.depProposalCount` was a stale sensor computed as a render side-effect
2026-08-10 · found by: audit scan · pattern: `COMPOSITION`

Set only inside `renderDeploy` (Watchlist tab) and read by the walk-up's RULINGS PENDING
line on another tab, so it reflected the last visit — including the boot render, which runs
before price data arrives and yields 0. A funnel proposal earned overnight was silent until
the user happened to render the Watchlist. Fixed with a timestamp and honest copy rather
than a recompute: **"as of Nm ago" is a true sentence; a fresh-looking stale number isn't.**

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F7.

### M021 · F6 — the plan and the quote cycle both owned inventory-mode items, and `committed()` could not see quote legs
2026-08-10 · found by: audit scan (money path) · pattern: `COMPOSITION`

`buildPlan`/`candidateFor` contained no reference to `invTarget`, so an inventory-mode item
could be funded as an allocator-sized plan BUY while the quote cycle proposed its own buy
leg for the same item. Worse, `committed()` counted positions only — **gp locked in a
standing quote buy leg was invisible to plan sizing, so the one-third rule and tier pools
could double-spend it.** Ruled both halves: inventory items bench from the plan, and
unfilled quote buy legs count at cost. *Gp standing in an offer is deployed gp* — a
principle later reapplied to attention state (a standing quote is an open book).

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F6; `audits/AUDIT-2026-08-11b.md`
(the reapplication).

### M020 · F5 — the self-cross guard was built one-directional against a universal spec
2026-08-10 · found by: audit scan (money path) · pattern: `COMPOSITION`

`crossWarn` read `standingOrders` → `DB.positions` only, so a reprice on a position could
cross a standing quote BUY leg and a plan leg could cross a standing quote SELL leg, with
no CANCEL-FIRST warning either way. Quotes saw positions; positions did not see quotes.
**The original spec was universal** ("whenever any reprice/undercut action is proposed…
check for my standing opposite-side order") and the build dropped half of it — **and the
spec itself was never rowed in REQUIREMENTS.md, so the ledger detector had nothing to catch
it with.** Row R9.4 closes both gaps.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, F5 and its ruling.

### M019 · The meta-finding: 252 green assertions could not see two money-path defects
2026-08-10 · found by: user, for the record · pattern: `TEST-SUITE`

M020 and M021 are composition defects between two individually-correct subsystems
(positions-world and quotes-world), invisible to parts-level probes because each side
passes its own tests. **Parts-level verification and composition-level audit are different
detectors; a green suite is not a clean bill.** This is the finding that establishes the
integration audit as a standing discipline rather than an occasional exercise.

Substantiated from: `audits/AUDIT-2026-08-10b.md`, meta-finding and verdict.

### M018 · F1–F4 — four connectivity defects, two of them born in that day's build
2026-08-10 · found by: audit scan (orphan/redundancy, first run) · pattern: `ORPHAN`

**F1** `estWindow` write-only: a `long-catalyst`'s estimate-window flag was stamped and
read by nobody, so an estimated window presented with dated confidence. **F2**
`flagArchive`'s `storyType`/`storyConf`/`retracePct` written and never consulted, while the
lag note said "signature matches…". **F3** a ratified watch-note never reached its flag's
row, so the row still asked for an escalation that had already happened. **F4** two
daily-series caches over one endpoint. The user's note on F3 is the durable part: this is
the clusters-class defect (a surface not wired to the workflow), **caught by audit in one
day instead of by the user's irritation in four.**

Substantiated from: `audits/AUDIT-2026-08-10.md`, findings and rulings.

### M017 · The seasoning gate was specified and never built under any name
2026-08-10 · found by: history search while implementing · pattern: `LEDGER-ONE-WAY`

The spec'd gate — "fundable only after 3 consecutive full-gate passes spanning ≥2h,
first-time passers shown as qualifying N/3" — did not exist; the closest artifact was
`w.lastPass`, which only feeds scout eviction. **A spec claiming an implementation that is
not there, with nothing checking the direction.** Recovered and built as ordered. The same
shape reappeared with the arrow reversed at M110, and that pair is what produced
`reqpair.sh`.

Substantiated from: commit `85cd734` body ("dropped spec, recovered"); REQUIREMENTS.md R6.2
("that is the seasoning-gate shape").

### M016 · `candidateFor` recorded only the first gate failure
2026-08-10 · found by: building marginal-gate attribution · pattern: `SILENT-STATE`

The else-if chain kept only `fails[0]`, so "which gates does each benched item fail" — the
question marginal-gate attribution needs — **was unanswerable from the data.** Every gate is
now evaluated independently into `fails[]`; the headline bench reason is unchanged, and the
gate-health ledger deliberately keeps first-fail semantics because its audit buckets are
defined against the reason the user actually saw.

Substantiated from: commit `85cd734` body.

---

# 2026-08-09 to 2026-08-10 (friction session)

### M015 · A repriced leg kept its old price and old clock, so the same advice fired forever
2026-08-10 · found by: use · pattern: `SILENT-STATE`

The aging ladder instructed a cancel-and-relist with nowhere to record it. Every walk-up
then repeated the same instruction against a leg that had already been actioned. Recording
a reprice now restarts the leg clock, **because a relisted offer is a new offer.**

Substantiated from: FRICTION.md, 2026-08-11 00:17 entry; commit `b9c8add` body.

### M014 · The volume gate rode the /5m extrapolation and flapped between refreshes
2026-08-10 · found by: use · pattern: `CLAIMS-VS-CODE`

A `✗ GATE` tag appeared on divine battlemage potion while the plan was recommending the
buy, and elsewhere a buy was suggested for an item the scanner said was excluded. Root
cause: one fill in a quiet window extrapolates to "12/h", so the gate flapped and two
surfaces disagreed about the same item **because they were reading the same noisy input at
different instants.** Fixed by ruling: the 5m sample binds only at ≥5 units AND 2
consecutive below-floor refreshes, with its status labelled everywhere (noise / n-of-2 / 5m
pending). Placed rows now also announce when an item stops passing rather than going silent.

Substantiated from: FRICTION.md, 2026-08-10 09:50 and 09:51 entries; commits `1758e55`,
`952d7a2`.

### M013 · Four smaller friction defects from the same session
2026-08-10 · found by: use · pattern: `COMPOSITION`

A partial buy had no correction path and a wrong quantity was knowingly carried to a sell
listing (both fixed by **fix qty…**); the export NOW tooltip could not be dismissed; promote
demanded a demotion despite 7 open slots; and already-dismissed thesis candidates were
re-suggested as re-detected variants. Grouped because each is a single missing affordance
rather than a distinct root.

Substantiated from: FRICTION.md, Resolved — 2026-08-10; commits `3273f29`, `e6635d8`,
`e5fbaa4`.

---

# 2026-08-08 (inbound critical review of the original build)

These twelve were found by a single inspection review of `index.html` before any of the
verification machinery existed. They are listed because several are the **earliest
instances of roots that were not written down as rules until days later** — which is
exactly what §2b of the graduation audit is looking for. Only 1.1 was confirmed live at
the time of writing; the rest were read from the code. All were implemented by 8 Aug 2026.

### M012 · `gp()` deleted significant digits on nine-figure numbers — **verified live**
2026-08-08 · found by: inspection · pattern: `CLAIMS-VS-CODE`

`.replace(/\.?0+$/,"")` strips trailing zeros even with no decimal point:
`100,000,000 → "1m"`, `250,000,000 → "25m"`, `790,000,000 → "79m"`. It bit only values
≥100m whose millions digits end in zero, which is why `792m` looked fine and the bug
survived — **and the one place a nine-figure number is read is the Shadow Fund tab**, so
the live price, "still needed" and every gear target were understating by up to 10×.

Substantiated from: IMPROVEMENTS.md §1.1 (measured outputs quoted in place).

### M011 · Bank + realized profit double-counted the stack, and the error grew with the log
2026-08-08 · found by: inspection · pattern: `POOLING`

`stack() = DB.bank + realized()`, where the bank figure is read off the in-game bank, which
already contains every logged flip's profit. Two populations added as though disjoint.
`stack()` drives the one-third clamp, so **positions were sized too large**, and the error
was self-worsening.

Substantiated from: IMPROVEMENTS.md §1.2.

### M010 · The liquidity gate summed both sides of the book
2026-08-08 · found by: inspection · pattern: `POOLING`

`c.vol = highPriceVolume + lowPriceVolume`. To buy you need people selling into your offer
— one side, not the sum. The `volume ≥ 4× plan qty` gate and the scanner's volume floor
overstated available liquidity by roughly 2× on a balanced item and much worse on a
lopsided one. **The wrong-side-of-the-book root recurs at M099 Fault B** (total flow used
where reaching flow is meant) four days later.

Substantiated from: IMPROVEMENTS.md §1.3.

### M009 · Margin was computed from two unrelated instants
2026-08-08 · found by: inspection · pattern: `POOLING`

`/latest` gives the last high trade and the last low trade, which may be hours apart and
may each be a one-off, so a "margin" built from them can be an artifact that never existed
as a simultaneous spread. Named at the time as the mechanism behind most `check me` rows.

Substantiated from: IMPROVEMENTS.md §1.4.

### M008 · Tax exemptions matched by name and failed silently — and had already broken once
2026-08-08 · found by: inspection · pattern: `SILENT-STATE`

`EXEMPT_SET` keys on exact lowercased `/mapping` names. Seven teleport tablets carrying a
`(tablet)` suffix were taxed when they should not have been, and **nothing in the app would
have said so** — margins were just quietly 2% low. A wiki rename re-breaks it at any time.
Fixed with a count assertion and a visible banner, which is the first detector in the
project's history.

Substantiated from: IMPROVEMENTS.md §1.5.

### M007 · The sparkline silently mixed two different series
2026-08-08 · found by: inspection · pattern: `POOLING`

`p.avgHighPrice ?? p.avgLowPrice` — when an hour has no high trades it substitutes the low
price, injecting a fake drop of exactly the spread width, and that series feeds the trend
gate. **Three days before "never pool" was ruled, and the same property.**

Substantiated from: IMPROVEMENTS.md §1.7.

### M006 · `trendPct` was endpoint-to-endpoint
2026-08-08 · found by: inspection · pattern: `CLAIMS-VS-CODE`

`(last − first) / first` over 7 days: an item that crashed 20% and recovered reads as a flat
chart, and a single bad final point flips the gate. **The gate meant to keep you off knives
was the shallowest calculation in the file.**

Substantiated from: IMPROVEMENTS.md §1.6.

### M005 · Shadow price staleness was invisible behind a global freshness claim
2026-08-08 · found by: inspection · pattern: `STALENESS`

Tumeken's Shadow trades ~27/hour, so its `/latest` entry can be hours old while the header
says "prices 12s ago" — true of the *fetch*, not of *that item*. The denominator of the
headline progress bar could be badly stale with no indication.

Substantiated from: IMPROVEMENTS.md §1.8.

### M004 · Two different clocks presented as one
2026-08-08 · found by: inspection · pattern: `STALENESS`

`/1h` volume can be 60 minutes old while the freshness filter is also 60 minutes, so an
item passes "data age ≤ 60 min" on price while its volume is an hour old and the market has
since died.

Substantiated from: IMPROVEMENTS.md §1.9.

### M003 · "No chart yet" conflated *loading* with *no data exists*
2026-08-08 · found by: inspection · pattern: `SILENT-STATE`

Items with no timeseries were benched forever with a message implying they would resolve on
their own. **This is the never-fed-aggregate root (M072) on Aug 8**, four days before it was
ruled: a component reporting nothing where it should report that it *has* nothing.

Substantiated from: IMPROVEMENTS.md §1.10.

### M002 · The checklist date rolled only when the Routine tab rendered
2026-08-08 · found by: inspection · pattern: `COMPOSITION`

`DB.checks.date !== today()` was checked inside `renderRoutine`, so leaving the app open
overnight on another tab kept yesterday's ticks. **State coupled to a render path** — the
same root as F9 (M025) and the accrual coupling (M054), three days earlier.

Substantiated from: IMPROVEMENTS.md §1.11.

### M001 · The flip log stored the item name at log time
2026-08-08 · found by: inspection · pattern: `COMPOSITION`

Renamed items produce two rows in the per-item table. Cosmetic; `itemId` is what is used
for tax. Recorded for completeness.

Substantiated from: IMPROVEMENTS.md §1.12.
