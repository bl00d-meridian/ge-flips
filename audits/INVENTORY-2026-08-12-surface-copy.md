# Surface copy inventory — Aug 12 2026

**Report before cutting, as directed. Nothing has been changed.** This is the measurement
and a proposed classification; the edit waits on a ruling.

## The total

Measured by extracting every persistent explanatory block (`class="note"` and
`class="plan-note"` — the two classes that render standing prose), stripping markup and
counting visible characters.

| | |
|---|---|
| Persistent copy blocks | **79** |
| Visible characters | **22,608** |
| Approx. phone lines (38 char/line) | **~594** |
| Glossary entries already holding this material | 88 |

594 lines of standing explanation across four tabs. For scale, the walk-up attention
budget is **7 decisions**; the copy surrounding those decisions is roughly eighty screens
of phone text.

**The diagnosis matches yours: this is composition, not content.** Every block is
individually correct and individually justified. The failure is that they all render at
the same weight, always, so nothing is louder than anything else — and the two blocks
that should be loudest (contamination register, stall line) are 549 and 279 characters
sitting in a field of 22,608.

## Per surface

| Surface / function | Chars | Blocks |
|---|---|---|
| Static HTML — settings help, sizing help, glossary-adjacent copy | 7,552 | 36 |
| `calibSection` (calibration panel) | 2,218 | 3 |
| `gateExcSection` (exception lane) | 1,347 | 2 |
| `freshnessInline` (data freshness) | 1,155 | 3 |
| `shadowEpochNote` (epoch banner) | 907 | 1 |
| `prospectingInline` (per-stratum map) | 861 | 3 |
| `calibSellHTML` (sell leg) | 790 | 1 |
| `gateStreamsSection` | 777 | 2 |
| `gateDieOffSection` | 769 | 1 |
| `paperRegimeSection` | 747 | 2 |
| `intelRecordHTML` (per record — **repeats per row**) | 707 | 4 |
| `paperGateSection` | 489 | 2 |
| `paperCaveat` (**repeats per citation**) | 410 | 1 |
| `paperHeadlineBody` | 408 | 1 |
| `hoursStreamsNote` | 406 | 1 |
| remainder (11 surfaces) | 3,762 | 21 |

## Classification, and the proposed rule per class

### A. STANDING TRUTHS — always true, so they teach nothing after the first read

Proposed: collapse to a badge or one short line **once per surface**, full text behind the
glossary term. These are the biggest win because they are the most repeated.

| Block | Where | Chars | Why it exists |
|---|---|---|---|
| `paperCaveat` — "screening tool, not evidence…" | every paper citation, **repeats per row** | 410 × n | Paper-book epistemic status (ruled Aug 11) |
| Self-comparison caveat | `calibSection` | 980 | Aug 12 ruling — the proven bound is depressed by construction |
| Capture-share-ungraded note | `calibSection` | 566 | The 15% constant is unvalidated |
| "Watchlist + slice only, populations never mix" | `paperGateSection` | 285 | Never-pool rule |
| "Net per cohort, never blended" | `paperHeadlineBody` | 408 | Never-pool rule |
| "Two streams, different natures" | `hoursStreamsNote` | 406 | Market vs paper provenance |
| Stratum classifier caveat | `prospectingInline` | 349 | Approximate-machinery tripwire |
| "Every logged real round trip…" | `calibSection` | 672 | Metric honesty |
| Row-dot legend | static | 598 | Indicator vocabulary |
| Lots-are-FIFO explanation | static | 518 | — |
| **Subtotal** | | **~5,200 + per-row repeats** | |

`paperCaveat` is the worst offender by a distance: 410 characters re-rendered at **every**
paper citation on a surface that can carry a dozen.

### B. CONDITIONAL WARNINGS — true only in a state

Proposed: render **only** in that state, at full weight, and vanish otherwise. Most
already do; three do not, and those three are why the real ones get missed.

| Block | Chars | Currently state-gated? |
|---|---|---|
| Contamination register / `provTag(true)` | ~120 × 6 surfaces | Partly — the badge renders always, correctly, but its long form repeats |
| Stall line (`shadowScanStateLine`) | 279 | **No — renders always by design.** Keep the always-on *short* form; the explanatory tail should gate on the stall |
| Build-stamp staleness | ~90 | Yes — correct |
| `paperStaleHostNote` | ~300 | Yes — correct |
| Epoch banner (`shadowEpochNote`) | 907 | Yes, retires when the book matures — but 907 chars is long for a persistent banner |
| Die-off auto-void note | 769 | **No — renders whenever episodes exist** |
| Exception "basis void — re-rule" | 863 | Yes |
| Streams-disagree finding | 547 | Yes |
| Corrected-caveat note (`calibSellHTML`) | 790 | **No — permanent once written** |

### C. TEACHING NOTES — explain a concept you now know

Proposed: move behind a "why this works" disclosure. The glossary already holds all of
this; the surfaces repeat it.

| Block | Chars |
|---|---|
| Cluster/basket explanation ("one story, many tickers…") | 1,086 |
| Pump-window settings help | 807 |
| Suspected-pump mechanics | 730 |
| Regime-race explanation | 717 |
| Accrual/observation explanation (`freshnessInline`) | 549 |
| Exception-lane preamble | 484 |
| Margin/tax primer | 409 + 382 |
| Sleeve "judged at exit" | 392 |
| Catalyst entry-watch mechanics | 372 |
| Anomaly-scan explanation | 316 |
| **Subtotal** | **~6,200** |

## Projected effect

| | Now | After |
|---|---|---|
| Persistent chars | 22,608 | **~7,400** |
| Phone lines | ~594 | **~195** |
| Reduction | | **~67%** |

Nothing deleted: standing truths move behind glossary terms that already exist, teaching
notes behind a disclosure, conditional warnings behind their state. Every caveat stays
reachable, and the exports keep their honesty blocks in full — a file read cold has
different needs than a screen read four times a day.

## What must not be touched (hard constraints)

NOW lines · rulings-pending digest · armed sleeve rungs · stall detection (short form) ·
contamination register badges · build-stamp staleness · `paperStaleHostNote`.

## The risk this edit carries, named before it runs

**Moving a caveat behind a tap is a metric-honesty violation if the tap does not reach
it.** The claims-vs-computation rule binds after the edit exactly as before, so the
interrogability and claims-vs-computation scans have to run over the result — this is
precisely the kind of edit that silently strands a caveat, and a stranded caveat is worse
than the noise it removed.
