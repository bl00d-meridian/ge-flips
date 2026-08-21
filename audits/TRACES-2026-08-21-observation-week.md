# TRACES-2026-08-21 — observation-week walk-up traces, each mismatch traced to its term

The standing instruction for the observation week: walk-up reports every touch, and every
mismatch is traced to its term before anything is proposed. This file is the durable record of
those traces and their ruled classifications. One entry per trace, newest last.

**Method boundary (ruled 2026-08-21):** a trace may transcribe production arithmetic and run
it outside the app — one-shot fetches, constants assumed at defaults, caveats stated — and
that is fine FOR TRACES and never for assertions. An assertion that re-implements production
is the re-implementation face of the test-suite rule: it tests the transcription twice and
the product zero times. The trace's transcription is investigation; the moment a claim needs
to be *verified*, it points at production code through the suite.

**Watch item for the week (ruled 2026-08-21 — note only, build nothing):** Clockwork's
imbalance leg sits on the 0.85 edge, so re-entry and oscillation are live. An edge item
flickering in and out of the cell resets its seasoning streak on every scored failure —
CORRECT per the ruling — but if the week shows an item cycling clear/fail/clear on one
flickering gate, capture the trace here BEFORE anyone proposes hysteresis. A re-entering
Clockwork inside one long session is exactly trace 3 finding 2's scenario; the ruled age
disclosure is what makes it observable.

---

## Trace 1 (morning, user's walk-up) — bench copy renders the mechanism's internal zero instead of the governing cause

**Classification (ruled by the user, 2026-08-21): defect.** The "chart still loading" bench
detail (`index.html:5886`) renders `rdy.pts`/`rdy.vols` — *"the series feeds 0 price points…"*
— for a pool item below chart coverage, where the zero is the deliberately-empty cache's
internal value, not a reading of the item. Three worlds rendered as one measured zero: below
coverage (the era is the cause — nothing is consulted), at coverage with the item absent from
the archive (no trades observed in the trailing window), and a series actually fed by the
item's own fetch (the only case where a points count is honest).

**Term:** the bench sentence at `chk(hv.loading, "chart still loading", …)` reads the
readiness object's counts; nothing in the sentence branches on the coverage owner.

**Disposition:** MISTAKES **M180**; fix staged 2026-08-21 as batch-1 repair 2 (one coverage
owner; the bench copy branches three ways on it). Landed with that batch.

---

## Trace 2 (morning, user's walk-up) — a sparked pool item cleared the gates before archive maturity

**Classification (ruled by the user, 2026-08-21): legitimate, not a defect.** Clockwork, a
pool item, cleared the full chain days before the archive's 7-of-7 coverage because its chart
chain read its own session spark: `itemSeries` prefers a spark's points over the archive
(`src: "spark"`), a spark can exist for a non-pinned item (the scanner's paper-cohort scan and
the scout's top-up evaluation both call `sparkFor` on universe items), and the readiness mask
feeds from whatever series resolves. The data is real — the item's own `/timeseries` — and the
seasoning waiver was the logged-round-trip exemption (`qualExemption`: "logged round trip in
30d — measurement beats seasoning"), which is measurement outranking the clock, as ruled.

**The consequence noted with the ruling:** a pool item can therefore FUND during the benched
era, which is why the half-stack reserve press moved up (the user set `#szRes` to ~82m the
same day; pre-change value 3m, written down in the restart directive).

**Two provenance obligations attach to the ruling; both are now met:** the funded line's
waiver note exists (`notes.push("seasoning waived — …")`), and the ruled provenance copy —
*"charted from its own fetch, ahead of the archive"* — LANDED 2026-08-21 (batch 2026-08-21·D,
`[R120.2]`: reads the chain's own `serSrc`, pool-and-sparked-and-below-coverage only, presence
and absence asserted).

---

## Trace 3 (this session, restart) — where Clockwork went after the NOW announcement

**Question:** Clockwork was announced as the pool's first clear, then vanished from the pool
group while the group churned 2 of 3 members in ~30 minutes. Where is it?

**(a) It is OUT of the control cell this refresh — churned out on the market gates.**
Evaluated from the live wiki-prices API at 2026-08-21 ~16:18Z (`latest`/`1h` fetched to the
session tmp dir; Clockwork = id 8792, buy limit 11,000):

| input | value |
|---|---|
| latest low / high | 1,000 / 1,088 (trades ~6 min apart — skew fine) |
| 1h avgLow / avgHigh | 1,004 / 1,045 |
| 1h volume low / high side | 1,884 / 329 |

Full fail set through the control config's arithmetic (chain order):

- **margin** — live margin is 67 gp but the 1h-sustained margin is 21 gp post-tax; the
  conservative leg is what the gate reads, and the need is 3× tax = 63 gp. FAIL.
- **imbalance** — 85.13% of the hour's flow is on the low (instasell) side; the hard band
  tops at 85%. FAIL, by a hair — this one can flicker cycle to cycle.
- **volume floor** — the thin side is the instabuy side at 329/h against a floor of 1,000
  at its price. FAIL.

ROI passes (2.1% ≥ 1.2%) and skew passes. The picture is one-way selling into a collapsed
sustained spread — the spread the morning clear was priced on is gone. Consistent with the
measured ~6× frontier flow.

**Method caveats, stated:** this is the production arithmetic (`marketStatsFor` →
`marketGateEval`) transcribed and run outside the app on a one-shot fetch — not the app
executing; the control cell in the user's browser reads the same bulk endpoints at its own
scored buckets, so small timing drift is possible (the imbalance leg sits on the 0.85 edge).
Constants assumed at defaults where DB-dependent (`volBase` = 1000 from `DB.filtersT1.vol`,
tick floor 15); the margin and imbalance fails rest on code constants only and survive any
settings difference.

**(b) is therefore moot this refresh** — it renders nowhere because it is not a candidate.
Confirmed by code: `cutoverPoolRows()` derives from the current `S.scorerCtlPass`; leaving the
cell removes the item from candidates, bench, and THE POOL group in one refresh. The waiver
note and the provenance copy questions are answered under trace 2.

**(c) Which spark world:** unknowable from here — `S.spark` is in-memory session state in the
user's browser. Both worlds stated: if the morning session is still open, the spark record
persists indefinitely for reads (`SPARK_TTL` gates refetch only) and would judge a re-entering
Clockwork on morning data; after any reload, the spark is gone, the chain reverts to the
archive path, and a re-entering Clockwork benches on the coverage era. Either way it is out of
the cell right now on gates that read no chart at all.

**Surface confirmations asked with the trace:**
- The open-by-default pool group re-renders cleanly on churn — confirmed by code: the plan
  list is a full `innerHTML` rebuild from the current build each render; `poolWaiting` derives
  from the current bench; `[R113.x]` asserts each row renders exactly once.
- The first-clear event did not refire for the new arrivals — confirmed by code:
  `notePoolFirstClear` returns on `DB.poolFirstClear`'s presence (one-shot by the record, not
  a flag), and the NOW line reads only that one record. Code-level confirmation; the user's
  browser was not observable from here.

**Finding 1 (LANDED 2026-08-21, batch 2026-08-21·D — `[R120.1]`, REPAIR-LEDGER row 20; the
original line here claimed "fixed in batch 2" while batch 2 had never been opened, which is
MISTAKES M183): the announced item was findable nowhere afterward** — MISTAKES **M181**. The durable `DB.poolSeen`
row survives churn by design and had no reader for a departed item (`poolDrill` iterates the
current plan only). Fix shape per the directive: one findable line, not a tracking surface —
the pool-persistence drill carries departed items with pool history (state named from their own
ledger row), and the first-clear record renders its one line from `DB.poolFirstClear` wherever
the drill renders.

**Finding 2 — RULED 2026-08-21: DISCLOSE, DON'T TIGHTEN.** The spark stays authoritative and
the surface states the series age wherever a spark-fed reading informs a verdict — the funded
line, the bench reason, and the provenance copy extended to *"charted from its own fetch, 3h
ago"*. A spark is real observed data; the defect is silence about its age, and the staleness
rule asks for the age to be stated, not for the reading to be discarded. Tightening would
re-decide the sparked-clears precedent on zero observed harm. **The re-open condition,
recorded with the ruling:** if the observation week produces one clear or fund on a spark
older than ~12h whose verdict the archive would have refused, that is the evidence a
tightening ruling wants — and the age disclosure is precisely what makes it visible. Built
display-only, seeds both directions (age renders when spark-fed; absent when archive-fed) —
pass 2026-08-21·E. The original proposal follows as written:

**(original finding text): a session spark never goes stale for reads.**
`candidateFor` reads `S.spark.get(id)` with no age bound and `itemSeries` prefers any spark
with points, so in a long-lived session a pool item that leaves the scanner/scout candidate
stream keeps being judged on data frozen at its last fetch — trend, volume trend, momentum and
drift all read it, and nothing on the surface states the series' age. This is the staleness
rule's shape (a freshness claim must state the age of the thing it names) one step before the
claim: the reading itself ages silently. It bites only when a sparked pool item re-enters the
cell inside one long session (Clockwork's imbalance leg sits on the 0.85 edge, so re-entry is
live). Proposal for a ruling, not shipped: EITHER the chain prefers the archive once a spark's
`at` exceeds a bound (tightening — a re-entering stale-sparked item benches below coverage; by
the restraint rule this direction may auto-arm, but it re-decides what the ruled "sparked
clears are legitimate" precedent covers, so it is the user's call), OR the spark stays
authoritative and the funded/bench line states the series age (display-only, no verdict
change). The second is buildable without a ruling; the first is not.
