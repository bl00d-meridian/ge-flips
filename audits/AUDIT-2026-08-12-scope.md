# AUDIT 2026-08-12 — constitutional scope: adoption, detectors, open findings

Records the adoption of the scope-audit rulings (Aug 12 2026): the prophylactic, ten
widened rules, the BINDING/DOCTRINE split, and the three live consequences. Written
because a ruling with no record of what it changed is a ruling that gets re-litigated.

---

## 1. What was adopted

The prophylactic sits at the top of `CLAUDE.md`, above the rule list, because it governs
how rules are written rather than what they say:

> When writing a ruling, name the property first; list the surface only as the example
> that produced it. The incident is the example; the reasoning is the rule.

Ten rules widened, each carrying its escaping instance. The constitution is split into
**BINDING** (mechanically checkable; violations are audit findings) and **DOCTRINE**
(practices with no test, explicitly not audited), with the design-philosophy principles,
"every layer ships with a detector", "'done' requires the integration exercise" and "the
constitution accretes case law" moved into DOCTRINE. The rationale recorded there: *a
rule that looks binding and isn't is the same defect class as a detector that cannot
fire.*

The advisory/membership contradiction is resolved in place — the advisory rule now names
its own supersession, its date, and the carve-out (coherence DROPS still queue, because a
drop loosens a cap and that is deployment), with an instruction that the two rules are
read together and neither quoted alone.

---

## 2. Detector coverage — which of the ten are now checkable

Required by the ruling: *a widened rule with no detector is a DOCTRINE entry wearing
BINDING clothes.* Two new integration-audit scans were added so three of these have
detectors rather than good intentions.

| # | Widened rule | Detector | Status |
|---|---|---|---|
| 1 | Interrogability — screens **and artefacts** | Scan 5 (widened to exports); probe `[R48.2]`, `[R49.1]` | **Checkable.** Scan extended this commit; sell-leg parity shipped and probe-proven |
| 2 | Observed time — denominators count only observed occasions | probe `[R51.1]` `[R51.2]` | **Checkable.** New; both assertions proven by seeding |
| 3 | Restraint/deployment — removal counts as deployment | **Scan 6, restraint-lift scan** (new) | **Checkable by scan.** The enumeration is the deliverable. §4 below is the first run; it has a live finding |
| 4 | File-as-press — and no strategy parameter by any channel | Import ignores `action:"ratify"` (probe-covered); the new clause is **not** probe-covered | **Partly checkable.** Gap named in §5 |
| 5 | Never pool — rate, median, count, verdict, score alike | **Scan 8, pooling scan** (new); `rateBlend()` for rates | **Checkable by scan.** Two live findings in §5 |
| 6 | Test-suite root: green can mean *ran and passed for the wrong reason* | The seeding practice + `blendFrag()` scoping helper | **Checkable.** `[R49.2]` fixed and the defect demonstrated (§3) |
| 7 | Entity state — every entity the user can see, not only allocator-touched | **Scan 2 extended** to entity state | **Checkable by scan.** One live finding in §5 |
| 8 | Automated decisions state their reason inline | Scan 2 + decision-log `auto` stamps | **Checkable by scan** |
| 9 | Corrections ship their landing path, for any artefact already read | No mechanical detector for *arbitrary* artefacts; per-instance probes only (`[R48.1]` asserts this one landed) | **Weakly checkable — FLAGGED, on one attempt.** Stays BINDING with the flag; the next integration audit gets exactly one try at the candidate detector (*every artefact type the user has read has a defined update path, enumerated*). If it cannot produce a check, it moves to DOCTRINE without further argument (user ruling, Aug 12 2026) |
| 10 | Metric honesty — copy claims what it computes, **asked or not** | **Scan 7, claims-vs-computation scan** (new) | **Checkable by scan.** Deliberately a reading of copy against code; no probe can assert this |

Honest summary: **6 of 10 have a mechanical (probe) detector or gained one; 3 more are
covered only by a named audit scan, which is a disciplined reading rather than a test; 1
(corrections) is weaker than its BINDING placement implies.** #9 is flagged rather than
quietly kept — if the next audit cannot make it mechanical, it should move to DOCTRINE
rather than continue to look enforceable.

---

## 3. Live consequence (c): R49.2 fixed, and the defect demonstrated

`[R49.2]` matched `/watchlist 100% of 2/` against the whole of `paperGateSection()` — a
container broader than the blend under test. Fixed with `blendFrag(html, key)` in the
probe, which locates the one `data-drill="<key>"` element and the inline decomposition
span `rateBlend()` emits after it; every per-surface pooling assertion now matches inside
that fragment only.

**Proving it required fixing the fixture too, and that is the more useful finding.** The
first seed — delete the split from the ROI-floor blend — failed *both* the old and new
forms, because the fixture contained only one blend, so a whole-section match had nothing
else to satisfy it. That would have been recorded as proof and would have proved nothing.
The fixture now carries **two gates with identical cohort splits**; under the same seed
the whole-section match passes while the scoped match fails. A permanent assertion holds
the fixture to it, so the scoping test cannot silently become untestable again.

Generalised into the constitution: *match against the narrowest container that still
contains the property. If the assertion would pass with the property deleted from its
subject but present elsewhere, the container is too broad.*

---

## 4. Live consequence (b): intel auto-expiry — audited, then RULED AND BUILT

Reported first, as the ruling required; the shape was then adopted in full on the same
day and built. The audit as reported is kept below the ruling, because the enumeration is
the deliverable and a later reader needs to see what was found, not only what was done.

### The enumeration (scan 6, first run) — every path that lifts a restraint

| Path | Where | Lifts what | User press? |
|---|---|---|---|
| Dismiss warning record | `data-inteldis` button | the caution and its haircut | **Yes** |
| Dismiss via imported `disposition` | `importIntelligence` | the caution | **Yes** (file-as-press) |
| Toggle haircut off | `data-intelteeth` | the 0.5× sizing haircut | **Yes** |
| **Ratified record reaches `validUntil`** | `intelExpired()` via `intelActive()` | **the whole caution: tags, deflation-flag sleeve refusal, and any haircut** | **NO — calendar only** |
| **Pending record reaches `validUntil`** | `intelSweep()` | an unruled caution, auto-dismissed | **NO — calendar only** |
| Anomaly-flag dismissal | `data-anomdismiss` | the briefing reminder only (explicitly *not* a pump defense) | Yes, and correctly scoped |
| 30-day retention prunes | `anomalyFlags`, `gateLog`, `dieOffLog` | flags and ledger evidence age out | No — retention, not a lift of an active caution |

### What the widened rule now classifies as a finding

Two paths, both real:

1. **`intelExpired()` on a ratified caution.** A `promotion-warning`, `watch-note` or
   `deflation-flag` stops applying at midnight on `validUntil`. Its item tags vanish, the
   sleeve stops refusing the item, and a `teeth` haircut lifts — all with no press. Under
   the old wording this was fine (nothing was *armed*); under the widened rule it is
   deployment, because it widens what the allocator may fund.
2. **`intelSweep()` auto-dismissing a pending record.** Milder — the record was never
   armed — but it converts "you have not ruled on this" into "dismissed" by the calendar,
   and the anomaly panel's own copy at `index.html:11074` already advertises the
   behaviour: *"lifted by dismissal or expiry of the record"*.

There is a third, subtler one worth naming: **the pump defense's stated lift path is
contradicted by expiry.** The constitution says a flagged pump caution's *only* lift path
is the user dismissing the record — "nothing else". `validUntil` is something else.

### RULED AND BUILT (user ruling, Aug 12 2026)

The proposed shape below was adopted in full, plus the third finding fixed in both
directions. What shipped, against what was proposed:

- **Lapsed state** — built. A ratified caution past `validUntil` keeps applying and asks
  once. `intelLapsedOut()` is now the only path by which the calendar stops a record
  applying, and a record that restrains anything is never in it.
- **One batched walk-up line** — built, with a refinement the proposal did not have:
  only the restraint-preserving action is bulk. "Extend all 30d" keeps every caution in
  force; there is deliberately no "drop all", because dropping lifts a caution per item
  and a bulk press cannot carry per-item judgment. Dropping stays per-record, needs a
  stated reason, and is logged as a deployment.
- **Context records keep expiring freely** — unchanged, as proposed.
- **Pending auto-dismissal survives with corrected copy** — an unruled record was never
  armed, so nothing it was doing has stopped; the log now says it is queue hygiene rather
  than a restraint lift.
- **The third finding — the pump-defense contradiction — closed in both directions.**
  This was the important one. The standing rule says a flagged pump caution lifts on ONE
  path, the user's dismissal, "nothing else"; **three** calendar paths contradicted it,
  not the one first reported:
  1. `validUntil` deactivation via `intelActive()`.
  2. `intelSweep()` auto-dismissing a pending warning — and the fingerprint counts any
     warning that is not dismissed, so this was a second lift hiding behind queue hygiene.
  3. `rulingsSweep()`'s 30-day staleness broom, the same defect a third time.
  All three now carve out pump-defense records. `promotionWarningsFor()` additionally
  dropped its import-window and expiry clauses, which lifted the defense two more ways.
  **And a fourth, found while writing the fix:** the anomaly leg tested for a flag within
  `pumpWindowD` days of *now*, so a defense that had already fired un-fired itself as its
  own evidence aged. The firing is now stamped on the record — which leaves the detection
  rule (a strategy parameter) untouched while removing the lift. Evidence ageing is not
  evidence against.
  The copy stops claiming what the code did not do: "lifts when the warning record is
  dismissed or expires" is gone from the pump line, the anomaly panel and the watch-note
  activation line.

**Attention cost, as agreed:** +1 walk-up decision on days when cautions lapse, against
the budget of 7. The probe still asserts the bound.

### The shape as proposed — kept for the record

The distinction that keeps this from becoming noise: expiry should stop *asserting* a
caution without *lifting* it.

- On expiry, a **restraint-bearing** record (`promotion-warning`, `watch-note`,
  `deflation-flag`, or any record with `teeth`) moves to a new `lapsed` state: it keeps
  applying, and surfaces in the walk-up as a single line — *"this caution reached its
  expiry date; drop it or extend it"* — which is one press, batched with other lapsed
  records so the attention budget takes one decision, not one per record.
- **Context-bearing** records (`demand-context`, `catalyst`, `catalyst-update`,
  `long-catalyst`) keep expiring on the calendar exactly as now. They restrain nothing,
  so nothing is being deployed when they lapse; the restraint/deployment line puts them
  outside this rule entirely.
- `intelSweep()`'s auto-dismissal of **pending** records stands, with its copy corrected:
  an unruled record was never armed, so nothing is being lifted. It is a queue-hygiene
  rule, not a restraint lift, and should say so where it renders.
- The anomaly panel's "lifted by dismissal or expiry" copy is wrong the moment this
  lands, and is part of the same change.

**Cost, stated because every proposal here states one:** up to one extra walk-up decision
on days when cautions lapse, against a budget of 7. It displaces nothing, so under the
zero-based complexity rule it needs either a ruling that the safety is worth the slot or
a consolidation to pay for it. My recommendation is that it is worth the slot, because
the failure it prevents is silent and asymmetric: a lapsed pump caution costs whatever
the pump extracts, and a lapsed context record costs nothing.

---

## 5. Open findings recorded but NOT acted on

These are live violations of rules as widened today. They are recorded rather than fixed
because the ruling's "act on these" list named three consequences and these were not
among them; scaling the work up is the user's call, not mine.

- **Never-pool, two instances.** `paperEconomics`' median trip net pools four cohorts;
  calibration's median share credited when wrong pools fast and slow legs. Neither is a
  rate, so `rateBlend()` never saw them. Both need their decomposition rendered beside
  the figure.
- **Entity state.** A paper trip in the *unobserved* state renders as a hole with no
  explanation. The paper book is not allocator-touched, so the pre-widening wording
  excused it.
- **Automated decisions.** Auto-applied coherence membership adds and auto-voided die-off
  episodes state their reason in the decision log but not inline where the user reads the
  result.
- **Corrections.** A corrected glossary entry and a revised requirement row have no
  landing path in general. Two instances were given one by hand this commit (the
  `4+ of the last 7 days` glossary line now carries a `caveat` naming what changed; R47.5b
  records the falsified sell-side prediction as its own row rather than an edit) — but
  that is authorship, not a mechanism.
- **File-as-press, final clause.** Nothing asserts that a settings or strategy block
  arriving in `intelligence.json` is ignored. The import happens not to read one today,
  which is a fact about the current code rather than a guarantee.

---

## 6. Sell-leg calibration — parity shipped, mechanism reported (user-directed, Aug 12 2026)

### Shipped

The sell leg now exports at parity with the buy: per replayed flip, the window offsets
against the real buy-completion anchor, both verdicts, credited percentages on both
bounds, the reach census, the at-price count, and the bucket-by-bucket trace with each
bucket's relative price, high-side volume, credited units and reason. Truncations are
declared like the buy's. This was the interrogability rule violated in the first export
built after widening it — the aggregate shipped alone.

### The falsified prediction (recorded, per the user's note)

Self-comparison does **not** bite harder on sells: zero at-price buckets, bounds
identical. Mechanism for the falsification: the at-price test requires the 5m bucket
*average* to equal the fill, which requires the trader's print to dominate its bucket. On
a liquid item it is one print among many. The consequence is stronger than the
retraction — the sell bounds diverge only on at-price or live-touched buckets, and a
historical replay can produce neither, so **their identity is a property of the harness,
not a measurement of the market.** Whatever is wrong with fast sells is real.

### The mechanism — hypothesis tested against the code, change NOT proposed

**Hypothesis: does the sell credit rule divide by TOTAL high-side flow rather than flow
reaching the ask, as the fill-horizon estimator did?**

**Not as stated — there is no division by flow on this path at all.** `calibReplaySell`
calls `reachCredit(b.hi, f.sell, b.hv, "sell", false)`, which is a per-bucket *gate*, not
a ratio. But the same structural fault is present in two places, and the second is the
hypothesis landing on the numerator instead of the denominator:

- **Fault A — the gate reads an average as if it described the interval.** A bucket
  credits only if its *average* high cleared the ask. A bucket whose average sat below it
  certainly contained prints above it — that is what an average means, and the trader's
  own sale is one of them. Those buckets score zero.
- **Fault B — a passing bucket credits the whole bucket's flow.** When the gate does
  pass, the credit is `floor(hv × capture)` on the bucket's *entire* high-side volume,
  including every print that was below the ask and could not have filled the offer. That
  is total flow used where reaching flow is meant — the hypothesis's fault, on the
  numerator.

Together the model is bimodal per bucket: zero or everything. **That is what selects
against fast legs specifically.** A fast sell resolves inside one to three buckets
(`H = max(0.25, sh × 2)` hours, so a 3-minute leg gets a 15-minute window ≈ 3 buckets),
and each is all-or-nothing on its average — so a sell into a brief spike, which is what a
fast sell *is*, scores zero across a short window and reads "never-sold". A slow leg
spans many buckets, needs only enough of them to clear, and Fault B means one clearing
bucket often covers the whole quantity.

**The falsifiable test the new traces answer.** If dilution is the mechanism, the failing
fast sells show `below-price` buckets with a SMALL negative `bucketAvgHighVsSellPct` —
roughly within the item's own 5-minute spread — and non-trivial `highSideVolume`. If
instead the gap is large and sustained across the whole window, the window is mislocated
and the mechanism is an anchoring bug rather than dilution. **The two have opposite
fixes, which is why no change is proposed until the traces are read.**

Note that Fault A is already documented for the BUY side, in the export's
"THIS COMPARISON BIASES PESSIMISTIC" honesty line. It was never carried on the sell
panel, so the same known bias went unnamed on the leg where it appears to bind hardest.

### Frozen (sell leg)

The 43-trip replay's "1 of 43 completing" headline rests on this sell model, which failed
calibration on 2 of 5 sell legs, both fast. **Not to be re-run until the mechanism is
understood** — a re-run now would launder the same defect into a new number. The freeze
is stated in the export's own honesty block, not only here, so the artefact carries its
own quarantine.

---

## 7. Fill-horizon estimator — it SHIPPED; three gaps closed; the regrade is blocked

### It shipped. Where.

Both input changes are live and were built in commit **`f1a8de3`** ("Fill forecast: soft
tag now, corrected input, capture marked ungraded"), one commit before the scope audit:

| Change | Location | Requirement |
|---|---|---|
| REACH — divide by reaching flow, an hour above the bid contributing zero | `reachFlow()` / `reachFlowPerH()`, `index.html` | R50.1, probe `[R50.1]` |
| DRIFT — median of the last `EST_FLOW_HOURS = 6` hourly readings | same | R50.1, probe `[R50.1]` |
| Treatment untouched — the gate is still a soft tag | `fillGateSoftLog()`, the `softFillTag` branch | R50.2, probe `[R50.2]` |
| Linearity untouched — still `qty ÷ flow` | `estFillH()` | — |

The measured effect was recorded in the code comment at the time: **spread 518× → 24.6×,
wrongly-promised fits 12 → 9.**

### Three gaps against the ruling as restated, now closed

Auditing the shipped work against the four sub-requirements found three real gaps. All
three are the same defect class — the copy and the computation had drifted apart.

1. **Reach share was not carried anywhere.** The ruling asked for it as a reported figure
   alongside the estimate. Built: `reachFlow()` is now one evaluation returning flow,
   state, reach count and share together — so the figure and the account of the figure
   cannot come from separate reads — and `estReachInline()` puts `reach 25%, 3/6h` beside
   the estimate rather than inside a tooltip. R50.4.
2. **The window count was picked silently, and the comment over-claimed.** It read "which
   is what the ruling specified"; the ruling asked for the count to be *proposed with
   reasoning*. Now stated with its derivation (n=6 puts the median between the third and
   fourth readings against an IQR of 0.7–2.58× with tails to 45.6×; six hours is also the
   shortest window spanning the whole of the shortest touch gap) **and with its price**:
   a 6-hour median needs four bad hours to move, so a book dying at 09:00 reads healthy
   in this input until ~13:00 while the die-off tag confirms in ~2 minutes. The two
   disagree for up to four hours by construction. That is the right way round — the tag
   restrains and may act on thin evidence, the estimator funds and may not — and where
   they disagree the tag wins. R50.5.
3. **Degradation was a fallback, not a decline — and one case was a live
   claims-vs-computation defect.** `reachFlowPerH()` computed a "median of the last 6
   hours" over however many readings existed, so with two readings the basis string
   claimed a statistic the computation did not support. Built: below three readings, and
   with no series at all, the estimator DECLINES and says what it could not compute;
   `fmtEstH()` renders "unavailable" rather than a dash or an ∞ standing in for unknown.
   **Zero reaching flow is deliberately not a decline** — nothing printing at or below
   the bid for six hours is a reading, and the reading is that it does not fill. R50.3.

A fourth, found while fixing the third: **the plan line's tooltip still described the
pre-Aug-12 formula** — "qty ÷ (buy-side 1h flow × 15% capture)" — for as long as the
corrected input had been live. Copy claiming what it no longer computes, on the surface
where the number is read. Fixed and asserted.

One orphan noted, not touched: the `estH` field written onto every candidate at
`index.html:4060` is never read. Write-only data is an orphan-scan finding; recorded here
rather than removed, since removing production fields was not what was asked.

### The regrade — BLOCKED, and precisely on what

The regrade in the form the ruling demands **cannot be run from this repo.** The 43
replayed trips live in `DB.shadowBook` in the browser's localStorage; nothing in the
repository contains them, and nothing may — the flip log is user data and this repo never
carries it. The earlier "518× → 24.6×, 12 → 9" figures came from a session that had the
data in hand.

Worse, those earlier figures **do not satisfy the ruling as now stated**, and would be
the wrong thing to reuse even if I had them: they are pooled across all 43 trips, and the
never-pool rule binds here — the trips span four cohorts answering different questions.
A 24.6× spread pooled across watchlist, scanner, discovery-slice and gap-band trips is
the same error as the 0.7× median that hid a 518× spread, one level up.

**What is needed to unblock it:** `⭳ export for analysis` from the Paper Book tab (or
`export all three` in the weekly review), which now carries per-trip rows with their
cohort. With that file I can produce, per population rather than pooled:

- the full observed/predicted distribution — every value, not a median;
- whether the ~1.3× optimistic lean is a stable constant or dissolves into noise at this
  sample size, with the per-cohort n stated so "dissolves" is distinguishable from
  "never had enough trips to tell";
- false-fit counts before and after — predictions promising a fit inside the horizon for
  trips that never completed;
- the reach-share distribution across the 43.

Per the ruling, the band treatment and the hard bench are **not** re-proposed in this
pass, and the soft tag's reversion condition is untouched: it reverts on evidence, not on
the fix landing.

---

## 8. The instant-trip report (user-directed, Aug 12 2026) — diagnosis, no fix

**Reported before fixing, as directed. Nothing about the minimum-life rule was changed.**

### What I traced

Every path that can close a paper trip, and whether the minimum-life rule reaches it:

| Path | Closes via | Guarded by `sameCycle`? | Can it close sub-second? |
|---|---|---|---|
| `shadowTick` — buy fills, then sell fills | `state="filled"`, `closedAt = now` | Yes | No. Buy credit lands only on bucket ROLL, so both legs need ≥2 buckets (~10 min) |
| `shadowTick` — horizon expiry | `unfilled` / `partial` / `unobserved` | Yes | No. Requires `now − t > H`, and `H` falls back to ≥1h when `hzH` is 0 or missing |
| `shadowTick` — sell force-exit | `forced-exit`, `closedAt = now` | Yes | No. Requires `now − buyDone > H` |
| `reconReplay` — all four outcomes | `closedAt = bt` (a **bucket** time) | **No such rule exists here** | No. `bt ≥ p.t` is enforced, and buckets are 5 minutes apart |

Both open paths (`shadowScan`'s `add()` and `scannerShadowScan`) stamp `openSeq: S.pollSeq`, and `S.pollSeq` increments only in `doRefresh`. I checked the orderings that could defeat that — `renderDeploy` calling `shadowScan(P); shadowTick();` back to back, `accrueBackground` scanning after the tick, a render firing between polls — and the guard holds in each.

### The finding

**No path in the current code can produce a sub-second resolution.** So the 150 trips were produced by code that is not the code in `main`, or by the one path with no minimum-life rule at all. In likelihood order:

1. **The running app predates the causality fix.** The site deploys from `main` via GitHub Pages, but a browser can hold a cached page, and this app is a single file that also runs from disk. This is by far the most likely explanation for trips opened continuously across five hours.
2. **The records predate it** and are still inside the 30-day retention window. Ruled less likely, since the trips were opened today.
3. **`reconReplay` is genuinely unguarded** — it has causality (`bt < p.t` skips) but no minimum-life rule. It cannot produce sub-second closes today, but it is the one path where the rule was never written, and if bucket timestamps were ever wrong it would be the path that failed first. Recorded as a latent gap, not as the cause.

   > **⚠ CORRECTION, 2026-08-13 — the causality clause above was unsupported when
   > written.** Scan 11's first run found that `if (bt < p.t) continue` **could never
   > execute**: the caller clamps the replay window to at least `p.t`, so every bucket
   > reaching that line already satisfied it. This paragraph rated `reconReplay` the least
   > likely of three causes partly on the strength of a guard that was decoration. The
   > ranking may still be right — the *other* reason given, that buckets are five minutes
   > apart, is real and independent — but **the causality half of the argument was worth
   > nothing and is withdrawn.** The guard is deleted and the promise now lives in
   > `reconWindowStart()`, which production actually calls; see
   > `audits/AUDIT-2026-08-13b-scans-10-11.md` S11-F1 and MISTAKES.md M137 / M138.
   >
   > A second finding came out of the same line: the assertion covering it, `[R43.2]`,
   > called `reconReplay` **directly with a pre-open window** — manufacturing the only
   > state in which the guard could run. It passed, on real production code, and reported
   > a dead line as covered, which is why nobody noticed for a day. Corrected in place
   > rather than noted elsewhere, because **a conclusion resting on unexecutable code has
   > to be marked wherever it was recorded.**

### What was actually wrong: the file could not answer the question

The export carried `openedAt`/`closedAt` as **ISO strings, which truncate to the second** — so "resolved in under a second" and "resolved within the same second" are indistinguishable in it. And the rule is stated in POLL CYCLES while the file carried no cycle at all.

Shipped, as instrumentation rather than as a fix: `resolvedInMs` and `openPollSeq` on every exported trip. **A null `openPollSeq` is the diagnosis** — it means the record was written by code without the fix, which settles (1) and (2) against (3) from the file alone.

**Next step is one line from the operator:** re-export after a hard reload and check whether the sub-second trips carry `openPollSeq`. If they are null, the running app was stale and nothing in `main` needs changing. If they are populated, path (3) becomes the live suspect and the minimum-life rule gets written into `reconReplay`.

## 9. Sell-credit zero at scale — one investigation, two datasets

The live book (12 of 14 observed watchlist trips at zero sell credit, including trips with 100% buy credit and 8+ observed hours) and the calibration failures are being treated as **one defect with two datasets**, per the ruling.

**I have to correct the record on one point:** in the previous pass I reported the mechanism and shipped the sell traces at parity, but I did **not** build the discriminator as a reported figure, which the ruling had asked for. It is owed and is the next build, alongside the same classification over the live book's zero-credit trips. The split across both populations cannot be reported until that classifier ships and the export carries it — reporting it from the traces by eye is precisely what the ruling ruled out.

The mechanism named from the code stands and now has a second dataset consistent with it: `reachCredit` is bimodal per bucket — the gate reads a 5m AVERAGE as if it described the interval, and a passing bucket then credits the bucket's ENTIRE high-side flow. Zero sell credit on a trip with 100% buy credit and an 8-hour observed horizon is what that bimodality looks like when no bucket average clears the ask, and it is consistent with dilution rather than with a mislocated window — the live book's sell leg has no window to mislocate, since it accrues forward from `buyDone` in real time. **That asymmetry is itself evidence**: the calibration harness can mislocate a window and the live book cannot, so a defect present in both is one that does not depend on window placement. Stated as a hypothesis with its discriminator still to ship, not as a conclusion.

---

## 10. The opening stall — diagnosed, and it was not a bug

**Cause: the family cooldown, doing exactly what it was written to do, at a horizon
length that makes it enormous — and saying nothing.**

`shadowScan` blocks a family whose last trip is open OR closed within
`cool = 2 × FILLH()`. `FILLH()` is the gap to the NEXT touch, so around the evening touch
the gap is 9.5h and **the cooldown is nineteen hours**. Two consequences that together
produce exactly the observed pattern:

- **Closing does not release a family.** `recent` counts any family whose trip is open
  *or* closed inside `cool`, so the wave of closes running to 20:46 freed nothing.
- **Family keys repeat.** They are derived from the pick or the benched near-miss, so a
  stable watchlist regenerates the same keys every cycle. Once a wave opens, the book is
  quiet by construction until the cooldown drains.

Ruled out: the scanner throttle (it gates only the scanner cohort, not the plan-driven
scan); an empty candidate set (the plan was still producing picks and near-misses); and
backgrounding (polls continued — trips kept closing, which is the same tick).

**The defect is that none of this was visible.** This is the self-explaining-state rule
applied to the generator rather than to an entity: a book that stops opening accrues
nothing, and every aggregate below it goes on rendering as though it were live — a
stalled generator and a quiet market are identical in every number on the page. Shipped:
`shadowScanState()` computes the reason from the same values the scan gates on, so the
two cannot disagree, and the paper headline renders it **whether or not anything is
wrong**. A quiet spell over two hours is flagged rather than merely reported.

**Not applied, and it needs a ruling:** a cooldown that scales with the horizon is
longest exactly at the evening touch — which is when the book has the most observation
time available and the most to learn. Whether it should scale that way is a strategy
question.

## 11. Epoch 2 — reset built, and why discarding beat filtering

The interim I chose (exclude `openSeq`-null trips from verdicts) was **superseded by the
user's ruling to reset**, and on reflection the ruling is right for a reason my interim
missed: a per-trip predicate can exclude *rows*, but the divergence ledger's daily rows,
the rolled per-stratum counters and the exception lane's grounding evidence are
**cumulative** — they were computed by mixing good and corrupt trips, and no filter
applied afterwards can un-mix a rolled total. Excluding works on the book; it does not
work on anything derived from it.

Kept deliberately: realized streams, the market stream, and per-stratum **sampling**
history — counts of distinct items the gate chain ran on record *tests performed*, not
simulated outcomes, so no fill-model defect reaches them. Clearing those would destroy
real coverage to fix a simulated number. Sim outcomes and sampling counts live in the
same object, and only one of them is downstream of the fill model.

The reset runs once on load (following the existing `shadowPurgeV1` precedent), because
the data lives only in the user's browser and there is no other mechanism that can reach
it. `paperEpoch2Reset()` is extracted so an assertion can call it — inline in `load()` it
was unreachable, and a seeded defect on it changed nothing the suite could see, which
reads exactly like a weak assertion and was in fact code no test could reach.

---

## 12. The family cooldown, severed — and the capacity ceiling

**The ruling:** one constant was doing two unrelated jobs, and the fusion let the weaker
one inherit the stronger one's scale.

| Job | Real? | What it is a property of | What it needs |
|---|---|---|---|
| **Concurrency** — no two open trips in one family | Yes | being OPEN | nothing but the open trip; no duration at all |
| **Sample independence** — do not re-sample a family so fast the second trip is the first trip's conditions measured twice | Yes | *sampling* | a fixed interval, chosen for how fast the inputs refresh |

Fused at `2 × FILLH()`, the sampling rule got an exposure rule's scale. The paper book
holds no capital and carries no correlation risk, so there was never an exposure argument
for scaling it to the horizon at all — and scaling it there **inverted** the rule: ~19h
lockout at the evening touch, which has the most observation time and the most to learn,
against ~9h in the morning.

Now: an open trip blocks its family; a closed one releases it after a fixed cooldown.
Applied to the scanner cohort too, so the two cohorts are not sampling at different rates.

### The constant, proposed at 5h

Mechanism ruled, number proposed, decision-logged as an interim naming its own reversion.

- **Modal touch gap.** The gaps are 5.0 / 5.0 / 4.5 / 9.5, so 5h makes a family
  re-samplable about once per touch — re-sampling then rides the same cadence as the
  decision it informs, instead of a horizon that changes underneath it.
- **Five fresh hourly readings.** The inputs are the 5m tape and the hourly series; five
  hours means a re-sample is not the same reading twice, which is what independence means
  for *these* inputs rather than in the abstract.
- **Horizon-independent**, which is the whole point of the severance.

Shorter (2h) buys throughput but starts correlating consecutive samples of a family
through the same hourly readings. Longer (9.5h) reproduces the inversion just removed.

### The capacity arithmetic — computed, and it renders

Nobody had computed this, and it is the number that should govern how long to wait for
evidence. A family cycles: blocked while open (≈ one horizon), then the cooldown, then
re-samplable.

```
per family per day = 24 ÷ (horizon + cooldown)
ceiling            = min( families × per-family-per-day ,  40-trip cap × 24 ÷ horizon )
```

Worked at the current defaults — a 5h horizon and the proposed 5h cooldown, so a 10h
cycle, **2.4 trips per family per day**:

| Families in play | Ceiling (trips/day) | Days per 10 trips | Binding constraint |
|---|---|---|---|
| 5 | 12 | ~1 | family count |
| 10 | 24 | <1 | family count |
| 20 | 48 | <1 | family count |
| 84+ | 192 | — | the 40-trip concurrency cap |

**The family count binds, not the cap** — the cap would allow ~192/day at a 5h horizon,
and it only takes over above ~84 families. So sample size is governed by how many
distinct families the plan produces per cycle, which is picks plus single-gate
near-misses. On the old fused constant at the evening touch the cycle was 9.5 + 19 =
28.5h, i.e. **0.84 trips per family per day** — the severance roughly triples throughput
at the evening touch and leaves the morning largely unchanged, which is the right shape:
it buys the most where observation time is greatest.

`paperCapacity()` computes this from live values and `paperCapacityLine()` renders it on
the paper surface with the binding constraint named — a cap nobody can see is a cap
nobody accounts for.
