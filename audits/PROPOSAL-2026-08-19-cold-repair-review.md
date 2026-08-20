# Proposal — a repair pass ends with the repairs written and unshipped

**User ruling, Aug 19 2026: stop fixing and sweeping in the same session.** The mechanism is
visible and the evidence is three-for-three.

## The mechanism, stated so the fix can be aimed at it

**A repair made under the pressure of a just-delivered finding gets scoped to that finding's
spelling.** Three instances, all this week, all mine:

1. Pass 4 named the item store's cleared override. The repair swept `validateImport` for **`num(`**
   — the helper the finding mentioned — and missed five `>= 0` guards and two bare `+`.
2. Pass 5 named those two bare `+s.tier` sites. The repair ran
   `grep -nE '\[0, ?1, ?2, ?3\]\.includes\(\+s\.tier\)'` — **the finding's exact expression** — and
   missed a third instance three lines below one of them.
3. Pass 5 named `partCapPct` and `clusterCapPct`. The classification was drawn from **the 23 keys in
   the object literal those two sit in**, and missed `slots` and `watchCap`, which bound funding just
   as hard and live elsewhere.

Each time the finding supplied a *search string*, and the search string was mistaken for the
property. **The reader who has just been handed a finding is the worst-placed person to decide what
the finding is an instance of** — the specific instance is vivid, and generalising away from it
takes an effort that the urgency of a live defect actively discourages.

## What separates the two, and what does not

**Time alone does not.** The same agent, an hour later, still has the finding in front of it.
**A cold reader does** — one that reads the repair without having read the finding that provoked it,
and is asked what property the repair is about rather than whether it fixes the reported case.

## The mechanics

**1. A repair pass writes to a staged copy, not to the tree.**
`staging/index.html` and `staging/probe-snippet.html`, produced by copying the current files and
editing those. `index.html` is untouched for the whole pass.

**2. The suite runs against the staging copy, so the repairs are fully verified before they land.**
This needs one small tooling change: `tools/probe/run.sh` currently hardcodes `$ROOT/index.html`.
Add `PROBE_SRC` and `PROBE_SNIPPET` overrides —

```bash
SRC="${PROBE_SRC:-$ROOT/index.html}"
SNIP="${PROBE_SNIPPET:-$HERE/probe-snippet.html}"
```

— so `PROBE_SRC=staging/index.html PROBE_SNIPPET=staging/probe-snippet.html bash tools/probe/run.sh`
runs the full suite, seeds included, without the tree moving. **Seeds are applied to the staging
copy**, which also removes the `git checkout --` hazard entirely: the thing being edited is a copy,
and `index.html` is the second copy that has never existed before.

**3. The pass ends with four artefacts and no landing.**
The staged files · a diff · the seed log · a written record naming, for each repair, **the property
it is about** (not the finding it answers). `index.html` still hashes to what it did at the start,
and the freeze check proves it.

**4. The next session opens by reviewing that diff cold, before anything else.**
The reviewer is given the diff and the repairs' claimed properties. It is **not** given the findings
that provoked them — that is the whole point, and it is the same discipline as pass 6's reader B,
who was forbidden the diff so that it could not be led by what changed.

**5. The cold review asks one question per repair**, and it is the question that would have caught
all three instances above:

> **Name the property this repair is about. Now find every site in the file with that property —
> not every site matching the text of the finding. List what you find.**

A repair whose property-scoped search returns sites the repair did not touch fails the review and
goes back, unshipped.

**6. Only then does staging replace the tree**, and the suite runs again on the real files to
confirm the move was clean.

## What this costs, stated plainly

- **A repair takes two sessions instead of one.** For a live money-path defect that is a real cost,
  and the escape hatch should be explicit rather than improvised: **a repair may land in one session
  if it is a single-site fix with no generalisation available** — the `flush()`/`save()` swap is the
  example. The moment a repair implies "and everywhere else like it", it stages.
- **One tooling change**, about six lines in `run.sh`, and it needs its own verification: the first
  staged run must be proven to actually read the staged file (stage a deliberate defect, watch the
  suite go red, confirm `index.html` unchanged).
- **`staging/` is gitignored**, like `inbox/`. It is a work area, not a deliverable.

## What it does not fix

**It does not stop the first defect** — only the second one, introduced while fixing the first.
Passes 5 and 6 each found the previous pass's repairs defective; this is aimed squarely at that,
and at nothing else.

And a caveat about this session: **under this rule, today's work would have been split three ways.**
The three fixes shipped this session (the persist race, the record-level tier, the quantity box)
were made in the same sitting as the pass that found them, and two of the three needed an assertion
rewritten mid-flight — one because it was pointed at the wrong function entirely, which a cold
reader would have caught before it shipped. That is the rule's own case, made against the session
proposing it.

---

## Batch size: the three-per-batch ruling is ARGUMENT, not evidence (user ruling, Aug 20 2026)

**The ruling stands as a working practice.** What changes is its epistemic status, and it is being
labelled rather than weakened.

`audits/DIAGNOSTIC-2026-08-20-repair-loop.md` tested the coupling hypothesis — that a batch spans
more than one reader can hold — and it is **NOT SUPPORTED**. The coupling ranges of the three class
misses and the six that passed **overlap**: misses 2–7, passes 1–3. No separating cut exists, because
one would have to be ≤2 and >3 at once. Worse for the hypothesis, **repair 3 — a class miss — scores
2, tied with two passes and strictly below two others**, so a rule reading *"above this coupling,
review harder"* would have waved it through as one of the four simplest repairs in the batch.

And **batch size itself is untestable from that data**: all nine repairs were in one pass, so repair
count has zero variance and cannot separate anything. There is no measurement here either for or
against three-per-batch.

**The geometry points somewhere else.** The 51 hunks span 95.3% of the file's extent but form **8
regions with a median inter-hunk gap of 75 lines** — each repair is locally clustered, and what spans
the file is the *batch*, not any one repair. That is an argument for smaller batches on
reviewability grounds, which is what the ruling actually rests on. It is not an argument that smaller
batches would have caught these three, and **H1 says they would not have.**

So: keep the practice, and when it is cited, cite it as a judgment about how much one cold reader can
hold — never as a finding about what caused the class misses. The recorded cause of all three was a
**question** that went unasked, not a **region** that went unread: all three missed sites were already
inside the repairer's own field of view, one of them quoted by name in the repair's own comment
twenty-eight lines above the guard that contradicts it.
