# Audit — 2026-08-13: MISTAKES.md backfill and graduation

Two things at once: the evidence layer reconstructed from what the repo already held, and
the standing BINDING list checked against a bar that did not exist until this audit
recorded it. **§1–§2 report; §3–§4 record what the user then ruled.**

Distinct from the integration audit (composition defects in the product) and from the
constitutional scope audit of Aug 12 (rule *wording*): this one audits **which rules exist
at all, and whether the evidence under each justifies where it sits.**

---

## 1 · The backfill

`MISTAKES.md` did not exist — not in the working tree, and `git log --all -- MISTAKES.md`
is empty. It was created, not backfilled into.

**129 incidents**, 2026-08-08 → 2026-08-13, newest first, each citing its source:
`audits/` (11 prior reports), CLAUDE.md's case law and both sections, `HANDOFF.md`,
`REQUIREMENTS.md` including withdrawn rows, `PROBE.md`, `IMPROVEMENTS.md`, `FRICTION.md`,
and commit bodies.

Every entry carries a **root-cause tag rather than the surface it was found on.** That is
the single decision that made §2 possible: counted by surface, the file is 129 unrelated
stories; counted by root, it is eighteen shapes, four of which account for 62% of
everything that has gone wrong here.

**One entry is flagged as partly session-sourced** (M125, "seed G"): the *shape* is
substantiated by the seeding precondition's clause 1 and by its numbered analogue in
commit `46ffa0a`, but the letter designation appears nowhere in the repo. It says so in
place. Substantiation over completeness was the instruction, and this is what honouring it
looks like — the entry is kept because the incident is real and marked because the citation
is weaker than its neighbours'.

Four corrections made while writing rather than reproduced: three cross-references aimed at
the wrong entry, and the `probe-snippet` figure (the term is **30,000 units against caps of
4,000 and 5,000** — six times, stated precisely rather than as "six times larger").

---

## 2 · The audit

### 2a · Instances per pattern, grouped by root

| Root cause | Instances | Expectation on the desk | Verdict |
|---|---|---|---|
| **Test-suite family** (incl. `REIMPL` + `CLAMP`) | **34** across **11 named faces** | "around ten" | **Right on faces, 3× low on instances** |
| **`COMPOSITION`** | **26** | not anticipated | largest single group |
| **`SILENT-STATE`** | **16** | not anticipated | one root, three homes (§2c) |
| **`CLAIMS-VS-CODE`** | 12 | — | |
| **Rules named after the surface** | **12 widenings** | "five or six" | **2× low** |
| **`POOLING`** | 10 | — | |
| **`CLAMP` absorption** | **6** | "two or three" | **2× low** |
| **`UNOBSERVED`** | 5 | — | |
| **`REIMPL` trap** | **4** | "four or five" | **correct** |
| `STALENESS` · `ORPHAN` · `INTERROGABILITY` · `CAUSALITY` | 4 each | — | |
| `LEDGER-ONE-WAY` | 3 | — | |
| `SCOPE-NAMING` · `RESTRAINT-LIFT` | 2 each | — | |
| `REMOVAL-SWEEP` · `EVIDENCE-ROUTING` · `CONSENT` | 1 each | — | |

Of the four estimates offered, **one held.** The two that were low were low by the same
factor, in the same direction, which is worth naming as a property rather than as an error:
**the memory of a pattern tracks the number of times a RULE was written about it, not the
number of times the defect occurred.** Clamp absorption produced one ruling and six
incidents. Surface-naming produced one audit and twelve widenings.

### 2b · Graduation mismatches, both directions

**Direction 1 — BINDING on zero or one instance with no detector.** Eight entries:

| Entry | Instances | Detector |
|---|---|---|
| Gates that re-punish what sizing already priced in | **zero, and it claims recurrence** | none |
| Feedback edges tune ATTENTION, never AUTHORITY | 0 | none |
| Advisory layers stay advisory | 0 (as an incident) | none named |
| The blacklist is the user's alone | 0 | none verified |
| File-as-press — *final clause only* | 0 | **explicitly none** (`AUDIT-2026-08-12-scope.md` §5) |
| Disclosure-in-summary is not ratification | 1 (M028) | none |
| House convention (strategy layer) | shares M028 | none |
| Corrections ship their landing path | 1 (M070) | none — already self-flagged |

The first is the finding, not merely the first row. **"Known repeated bug class" is the
strongest claim the constitution makes about its own history, and there is nothing under
it** — the repo-wide search returns four `double-count` hits and none of them is this
defect. The claim was written from recollection at a time when no evidence layer existed to
check it against, which is the general hazard the backfill removes: *a constitution with no
ledger beneath it cannot distinguish a remembered defect from an observed one.*

Three entries clear the bar on the **detector limb** with thin counts, and stay: pump-bait
(1 + scan 6), walk-up ≤7 (1 + probe), concur-recommended (0 + probe).

One rule misstated the standard in its own text: the clamp entry read *"graduated to
BINDING on the second occurrence, which is the bar."* Two is not the bar. It survives on
the detector limb — and on recount it now has six instances, so it clears the count limb
too.

**Direction 2 — three or more instances that never became a rule.** Four:

| Pattern | Instances | Where it lived |
|---|---|---|
| `COMPOSITION` | **26** | nowhere binding; the audit's *cadence* was a ruling, the discipline sat in DOCTRINE |
| `CAUSALITY` | 4 | a companion bullet inside case law — neither BINDING nor DOCTRINE, so no enforceable home |
| `STALENESS` | 4 | nowhere; the machinery shipped, the rule never did |
| `ORPHAN` | 4 | scan 2 since Aug 10, with no rule stating what the scan checks for |

`COMPOSITION` is the largest gap in the file by a factor of six over the next unruled
pattern. Its founding instance is the Aug 10 meta-finding — **252 green assertions could
not see two money-path defects** — which was recorded, acted on, and never turned into a
rule, because the response was to institute an audit rather than to state a property. An
audit with no rule under it is a habit.

### 2c · One root or many laws

**The test-suite family is one law with eleven faces, and the grouping is honest.** The
root as stated ("a green result can mean the test never ran, OR that it ran and passed for
a reason other than the property it names") reaches all 34 instances; no instance needed
stretching to fit. Two qualifications, both recorded rather than smoothed over:

- **Clamp absorption is both a face and now a law.** It graduated out of the section into
  BINDING with its own detector. Its 6 instances are counted **inside** the 34 and reported
  separately — never added, which would have inflated both.
- **The list's own numbering did not match its own list**: eleven shapes, ordinals reaching
  "eighth", two out of file order, one unnumbered. Since the count is the entire use the
  list is put to in a graduation argument, this is not cosmetic. Fixed (§3).

**`SILENT-STATE` was one root written three times** — the entity-state BINDING rule, the
never-fed-aggregate case law, and the stalled-generator finding. Each read as its own
lesson, so no entry ever carried more than a handful of instances and the pattern's real
size (16, the largest behind any single rule) was invisible until the incidents were tagged
by root. **This is the prophylactic's blind spot:** "name the property, not the surface"
governs how a new rule is written and says nothing about merging rules already written
about one property from different angles.

### 2d · How incidents were found

| Method | Count (of 129) |
|---|---|
| Audit scan (integration, cadence, pre-absence) | 44 |
| Analysis / measurement / reasoning | 33 |
| **Seeding a defect and watching whether it bit** | **24** |
| User report, or the user simply using the tool | 14 |
| Inspection (the Aug 8 inbound review) | 14 |

On the denominator that matters — the **34 verification-layer incidents**:

> **24 of 34 were found by seeding. 71%.**

Nothing else found more than two of them. The next-largest contributors were the clamp
sweep (2) and a series of one-offs: a user report, a user question, a probe failing only
after another run, reading the suite. **Ten of the eleven named faces exist because a seed
was checked to bite**, and four incidents (M107, M110, M113, M123) exist *only* because a
seed failed to bite and that was treated as information rather than as noise.

The counter-number, against the doctrine that the user's irritation must never be the
detector: **it was, 14 times.**

### 2e · The case for the promotion rule, in two near-misses

Both are what "nobody counted" looks like, and neither was visible before the incidents
were tagged by root:

- **`POOLING` fired four times on 2026-08-08** — `stack()` adding bank to realized profit,
  the liquidity gate summing both sides of the book, margin built from two unrelated
  instants, and the sparkline substituting a low price for a missing high. **Three to four
  days before the first ruling**, which was then written about *net*, widened to *rate*
  three days later, and widened again to *statistic* the same week. Four instances of the
  general shape were sitting in `IMPROVEMENTS.md` the entire time, and each widening was
  argued from the one or two instances in front of it.
- **`UNOBSERVED` fired three times in a single commit** (`828f526`, Aug 11): seasoning
  counting a five-day gap as a pass, die-off crediting unobserved windows to the gate, and
  regime evidence reading "4 of the last 7 days" across rows that can span a month. All
  three were fixed locally, in one sitting, by one author. **The general rule was written
  the following day, after a fourth instance.** Three in one commit is the count limb
  satisfied inside a single afternoon, and nothing was counting.

The rule these argue for is not "write rules sooner" — it is that **the count has to live
somewhere a later reader can check**, because the person best placed to notice the third
instance is the one who fixed the first two and no longer finds them surprising.

---

## 3 · Ruled and applied (user ruling, 2026-08-13)

**Demoted to DOCTRINE**, into a new *Commitments without detectors* subsection: all eight
entries from §2b direction 1. They remain real commitments binding on conduct; they stop
looking mechanically checkable. Each returns to BINDING on a detector or a third instance.
The DOCTRINE preamble now distinguishes **commitments** (promises about what the tool may
do) from **practices** (things the work aims at) — both undetectable, not equally serious,
and a reader who takes the first group as aspiration has misread it.

**The recurrence claim struck, not merely relocated.** *"Known repeated bug class"* is gone
from the gates entry; the guidance survives without the claim, and starts its count at zero.

**Promoted to BINDING, each with a detector:**

| New rule | Instances | Detector |
|---|---|---|
| Correct parts do not compose into a correct product | 26 | **scan 10** (seam inventory) + `[R34.1]` for the render-coupling sub-class |
| A component reports nothing where it should report that it HAS nothing | 16 | **scan 2**, extended to carry all five shapes |
| A long-lived client detects and reports its own staleness | 4 | **scan 7**, extended to freshness claims, + the build stamp's three states |
| A simulation may use only information that existed when it claims to have acted | 4 | **scan 11** (information-horizon) |
| Data nothing reads, and surfaces nothing feeds, are defects | 4 | **scan 2** |

The `SILENT-STATE` consolidation is a merge, not an addition: the entity-state rule, the
never-fed case law and the stalled-generator finding become one entry carrying all five
shapes and all sixteen instances, and the two case-law sections stay as the incident record
and defer to it rather than being second and third homes.

**Numbering repaired in two places**, both the same defect class as the requirements
pairing — a ledger nobody checked in one direction:

- The eleven test-suite faces are numbered 1–11 in file order, with the two out-of-order
  bullets physically swapped and the internal cross-reference re-pointed.
- The scan list ran 1–8, 10, 11 with **no scan 9**, so a BINDING rule citing "scan 10" was
  citing a position rather than a check. Renumbered contiguously; the clamp scan is 9, and
  the two new scans are 10 and 11.

**Recorded in the evidence layer as this audit's own findings:** M130 (the missing scan 9),
M131 (the face ordinals), M132 (one root, three homes), M133 (the unevidenced recurrence
claim).

---

## 4 · Result

129 incidents on record. **Eight entries left BINDING, five entered it, one claim was
struck, two numberings were repaired, and two new scans exist** so that nothing promoted
today is a DOCTRINE entry wearing BINDING clothes.

The BINDING section is now **smaller in count and larger in coverage** than it was this
morning: it lost eight rules resting on 2 instances between them and gained five resting on
54.

No product code changed; `index.html` is untouched and the probe suite was not re-run.
Scans 10 and 11 are specified and have not yet had a first run — **their first runs are
owed**, in the same way scan 6's first run was the deliverable that found four calendar
paths lifting a restraint nobody thought was liftable.
