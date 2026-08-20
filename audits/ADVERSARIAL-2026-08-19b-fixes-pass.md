# Adversarial pass — cutover-critical assertions, against a frozen tree

**2026-08-19. Nothing applied. Findings unmerged, ordered by consequence.**

## Freeze record

| file | at launch | at close |
|---|---|---|
| `index.html` | `95ff1f25929861ff` | `95ff1f25929861ff` |
| `tools/probe/probe-snippet.html` | `bad7f9bf6bcdc8d9` | `bad7f9bf6bcdc8d9` |
| `REQUIREMENTS.md` | `7a36a35de2d70219` | `7a36a35de2d70219` |
| `probe-report.txt` | `434ae1436f593707` | `434ae1436f593707` |

**The freeze held.** No file changed between launch 01:01:38Z and close 01:23:34Z. Suite at freeze: PROBE-PASS, 1,181 assertions.

## Shape of the pass

12 agents — 6 read-only finders, 6 adversarial verifiers, pipelined so each scope verified as it found. 0 errors, 0 empty results. ~20 min wall, 2.0M subagent tokens, 601 tool calls.

| scope | assertion bodies read | ~min | findings |
|---|---|---|---|
| `series-resolver` | 31 | 38 | 9 |
| `money-path-new-assertions` | 12 | 38 | 7 |
| `pool-branch-and-ops` | 40 | 38 | 6 |
| `horizon-term-and-regressions` | 34 | 38 | 8 |

**48 findings — 46 CONFIRMED by an independent verifier, 1 REFUTED, 1 UNCERTAIN.** Every verifier was instructed to default to REFUTED without independent tracing, told that a real line quoted out of its guard is the commonest way a false finding survives, and required to name the files it opened and the text it matched.

**Governance held:** no sub-agent wrote, edited, seeded, ran the suite, or committed. Findings returned as findings; the one genuinely unsettleable question returned UNCERTAIN with what would settle it.

---

## 1. [MONEY-PATH] [R96.1] asserts three of the four consumers it names — `vt`, the volume-dying restraint, is printed in the evidence string and never checked

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** 8 label overclaims (a universal exercised against a subset) + coverage hole
- **Assertion:** [R96.1] with an ARCHIVE series and NO spark — the post-transition state of a pool item — EVERY chart-derived reading on the live chain is FED, so no consumer can be left behind while its neighbours are wired
- **Condition:** `cd96 && cd96.mo && cd96.mo.state !== null && cd96.stw && cd96.stw.drifty !== null && cd96.tr !== null`

**Evidence.**

The correction's own scope statement names four: "So this feeds FOUR things from one series: `tr`, `vt`, momentum and drift." The chain computes all four — `const tr = ser.pts.length ? trendPct(ser.pts) : null;` and `const vt = ser.vols.length ? volTrendPct(ser.vols) : null;`. The assertion's condition tests `mo.state`, `stw.drifty` and `tr`. `vt` appears ONLY in the third argument, the evidence string: `JSON.stringify({ momentum: ..., drift: ..., tr: cd96 && cd96.tr, vt: cd96 && cd96.vt })` — evidence is not a condition. The discriminating half has the same omission: `cd96b && cd96b.mo && cd96b.mo.state === null && cd96b.stw && cd96b.stw.drifty === null && cd96b.tr === null`. Nothing else in the suite covers it. §94's `[R94.2]` asserts the READER, not the chain (`chartVols(1).join(",") === "7,8"`), on a 2-element vols array that `volTrendPct` (`if (!vols || vols.length < 48) return null;`) could never feed. §74's two chain-vs-core assertions pass the chain's own value into the core on both sides (`volGate: cand74.volGate, tr: cand74.tr, vt: cand74.vt, moState: cand74.mo.state`), which is tautological for vt. Grep for `volTrend|volTrendPct` across probe-snippet.html returns only §94's copy regex and a key-list at line 9808. If `vt` were reverted to `sp ? volTrendPct(sp.vols) : null`, the fixture (no spark) gives vt = null, the assertion's condition is untouched, and the suite stays green — while the "volume dying" gate goes vacuous for every archive-fed item, with no mask in front of it (see the next finding).

**Production cited.**

```js
const vt = ser.vols.length ? volTrendPct(ser.vols) : null;
```

**Verifier method.** Read tools/probe/probe-snippet.html lines around `[R96.1]` (whole §96 try-block), `[R74.3]`, `[R74.5b]`, `[R94.2]`. Read index.html `candidateFor`'s `ser`/`tr`/`vt` lines, `volTrendPct`, `marketGateEval`. Ran `grep -n 'volTrendPct(' tools/probe/probe-snippet.html` (exit 1, no matches) and `grep -n '\bvt\b|volTrend' tools/probe/probe-snippet.html` to enumerate every vt mention in the suite.

**Verifier says.** Traced and independently reproduced. Production: `const vt = ser.vols.length ? volTrendPct(ser.vols) : null;` sits directly under `const tr = ser.pts.length ? trendPct(ser.pts) : null;`, and the block comment above them says "tr, vt, momentum and drift all read `ser`". [R96.1]'s condition is exactly `cd96 && cd96.mo && cd96.mo.state !== null && cd96.stw && cd96.stw.drifty !== null && cd96.tr !== null` — three terms. `vt` appears only in the third argument: `JSON.stringify({ momentum: …, drift: …, tr: cd96 && cd96.tr, vt: cd96 && cd96.vt })`. The evidence argument to `ok()` is a report string, not a conjunct. The discriminating half has the identical omission. I then checked the whole suite rather than trusting the finder's grep: `grep -n 'volTrendPct(' tools/probe/probe-snippet.html` returns NOTHING — the term is never called by any assertion. `[R94.2]`'s `chartVols(1).join(",") === "7,8"` tests the reader on a 2-element array that `volTrendPct`'s `if (!vols || vols.length < 48) return null;` could never consume. §74's two chain-vs-core assertions pass `vt: cand74.vt` / `vt: candW.vt` — the chain's own value — into `marketGateFails` on the core side, so vt is tautologically equal on both sides of the set comparison whatever it is. Seed trace: revert to `sp ? volTrendPct(sp.vols) : null`; §96 deletes the spark (`S.spark.delete(9601)`), so vt goes 0 → null; no assertion's condition reads it; the §74 comparisons stay equal because both sides move together. Green, with the volTrend restraint reading `unknown` — and `marketGateEval` makes unknown a non-failure — for every archive-fed item.

**Correction to the finder.** Accurate as written, and slightly understated: it is not merely that [R96.1] omits vt — `volTrendPct` has zero direct coverage anywhere in the 1200-assertion suite. Adding `cd96.vt !== null` to the condition would close the label; the fixture already supplies 60 vols, so it bites immediately on the reverted form.

**Proposal — NOT APPLIED.** Add `&& cd96.vt !== null` to the first half and `&& cd96b.vt === null` to the second. The §96 fixture already supplies `vols: Array.from({ length: 60 }, () => 5000)` — 60 ≥ 48, recent and prior means both 5000, so vt computes to 0, which is non-null and satisfies a `!== null` check today. Better still: make the fixture's vols DECLINE so vt is a signed reading rather than a zero that a `!= null` test cannot distinguish from a fed-but-flat one, and state the pinning input. Then re-label: the current label claims a universal ("EVERY") that the condition does not exercise — either enumerate the four in the label or assert all four.

---

## 2. [MONEY-PATH] The "chart still loading" mask is keyed to the SHALLOWEST consumer (3 points) while drift needs 24 and volume-trend needs 48 — the resolver guarantees one SOURCE, not one READINESS

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** Production defect; the §96 acceptance criterion is false as stated and no assertion tests the region
- **Assertion:** [R96.1] with an ARCHIVE series and NO spark … EVERY chart-derived reading on the live chain is FED (fixture: arcPts length 30, vols length 60 — every threshold cleared at once, so the asymmetry cannot express itself)
- **Condition:** `cd96.mo.state !== null && cd96.stw.drifty !== null && cd96.tr !== null — on a fixture where pts=30 and vols=60`

**Evidence.**

The mask fires only on `tr`: `chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading")`. The four consumers have four different minima, all applied to the FILTERED array: `trendPct` — `const n = xs.length; if (n < 3) return null;` (finite points only, index-preserving); `momentumState` — `const pts = (rawPts || []).filter(Number.isFinite); if (pts.length < 5 || buy == null) return { state: null, q: null };`; `sitRisk` — `const pts = (rawPts || []).filter(Number.isFinite); if (pts.length < 24 || !(margin > 0)) return null;`; `volTrendPct` — `if (!vols || vols.length < 48) return null;`. The archive path makes short finite series routine: `chartCacheLoad` computes `const mid = (Number.isFinite(hi) && Number.isFinite(lo)) ? (hi + lo) / 2 : Number.isFinite(hi) ? hi : Number.isFinite(lo) ? lo : NaN;` and unconditionally does `p.push(mid)` — an hour with no print on either side contributes NaN, which every downstream filter drops — while the volume side pushes `(b.hv[i] || 0) + (b.lv[i] || 0)`, a real 0 that is NOT filtered. So an illiquid item with 20 printing hours out of 168 buckets gets: tr FED (20 ≥ 3, mask lifts), momentum FED (20 ≥ 5), drift UNKNOWN (20 < 24, `stabilityWeight` returns `drifty: null`, and `chk(stw.drifty && walkGapH > 24, "drift bench", …)` is falsy on null), vt fed from 168 zeros. Reverse the sparsity (few buckets, all printing) and vt is the one that starves. `marketGateEval` confirms the consequence — `add("volTrend", st.vt, cfg.volDecline, st.vt == null ? "unknown" : …)` and momentum's `st.moState == null ? "unknown"` — unknown is not failing. That is the exact failure the repair's own header forbids: "the moment chart coverage flips, the mask lifts on the live chain — and if drift is still spark-fed, a pool item passes it on an empty series with no bench standing in front of it." Changing the SOURCE did not close it, because the mask was never keyed on readiness. The §96 fixture (`arcPts` length 30, `vols` length 60) clears 3, 5, 24 and 48 simultaneously — fixture prevents expression.

**Production cited.**

```js
chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading");
```

**Verifier method.** Read index.html: `itemSeries` (the resolver), `candidateFor`'s gate block containing the two `chk` lines quoted, `trendPct`, `volTrendPct`, `momentumState`, `sitRisk`, `stabilityWeight`, `chartCacheLoad`, `t0Pack`, `marketGateEval`. Read tools/probe/probe-snippet.html §96 in full (the `k96` fixture through the `[R96.2]` restore) and matched the fixture array lengths against each threshold by hand.

**Verifier says.** Every quoted line matches, and every threshold checks out. The mask is `chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading")` — keyed on `tr` alone. The four minima differ and each is applied to a FILTERED array: `trendPct` — `const n = xs.length; if (n < 3) return null;` after `(pts||[]).forEach((v,i)=>{ if (Number.isFinite(v)){...} })`; `momentumState` — `const pts = (rawPts || []).filter(Number.isFinite); if (pts.length < 5 || buy == null) return { state: null, q: null };`; `sitRisk` — same filter then `if (pts.length < 24 || !(margin > 0)) return null;`; `volTrendPct` — `if (!vols || vols.length < 48) return null;` with NO finite filter. The asymmetry is not theoretical: `chartCacheLoad` does `const mid = (Number.isFinite(hi) && Number.isFinite(lo)) ? (hi+lo)/2 : Number.isFinite(hi) ? hi : Number.isFinite(lo) ? lo : NaN;` then `p.push(mid)` unconditionally, while the volume side pushes `(b.hv[i]||0)+(b.lv[i]||0)`. I traced the upstream: `t0Pack` writes `hi[i] = Number.isFinite(d.avgHighPrice) ? d.avgHighPrice : NaN; ... hv[i] = d.highPriceVolume || 0;` over `Object.keys(S.hour)` — the /1h response, which carries an entry per item whether or not it printed. So a thin item gets 168 pts of which few are finite, and 168 vols of which most are a real 0 that nothing filters. At 20 printing hours: tr fed (mask lifts), momentum fed, drift `null`, and `chk(stw.drifty && walkGapH > 24, "drift bench", …)` is falsy on null. `marketGateEval` confirms unknown is not failing — `add("volTrend", st.vt, cfg.volDecline, st.vt == null ? "unknown" : …)` and `add("momentum", null, null, st.moState == null ? "unknown" : …)`. That is precisely the outcome the repair's own header names as worse than leaving both masked: "if drift is still spark-fed, a pool item passes it on an empty series with no bench standing in front of it." Changing the SOURCE did not close it. The fixture-prevents-expression half also holds: `const arcPts = Array.from({ length: 30 }, ...)` and `vols: new Map([[9601, Array.from({ length: 60 }, () => 5000)]])` clear 3, 5, 24 and 48 simultaneously, so [R96.1]'s three-term condition cannot distinguish one-source from one-readiness. Note this is a pre-existing gap the resolver did not create — the same asymmetry exists today on a 3-point spark — which is what makes the §96 acceptance criterion's wording ("EVERY chart-derived reading … is FED") the overclaim.

**Correction to the finder.** The finding is accurate. One framing point to carry into the fix: the resolver's promise is 'one series', which it keeps; the acceptance criterion asserts 'one readiness', which no single-source resolver can deliver while the consumers hold different minima. The remedy is a readiness term the mask reads (the max over the consumers actually gating), not more wiring — and a fixture that clears 3 and 5 but not 24 or 48 is the seed that would prove it.

**Proposal — NOT APPLIED.** The mask must be keyed on the WEAKEST-fed consumer, not the strongest-tolerant one: extract a `seriesReadiness(ser)` term returning per-consumer fed/unfed, and bench "chart still loading" while ANY gate-bearing consumer is unfed (or render the specific unfed restraints as inert, which is what `planInertLine` already does for the pool). Would need a seed to confirm the funding consequence end-to-end, but no seed is needed to establish the arithmetic: 3 < 5 < 24 < 48 against a single `tr == null` mask. Add three fixtures at pts lengths 4, 10 and 30 with vols matching, and assert which restraints report unfed at each — the enumeration is the deliverable, per scan 9's shape.

---

## 3. [MONEY-PATH] `hourWeight`'s neutral-from-absence enters the TENURED score-sorted ranking the moment the mask lifts — and the exclusion's promised documentation does not exist

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** Production defect created by removing the mask; violates the ruled "a default weight is not a measurement" constraint
- **Assertion:** [R92.3] the two groups never interleave, tenured sorts by score and pool by the UNWEIGHTED core — a pool item's four history weights all default to 1.0, so one ranked list would place it mid-field on no evidence at all
- **Condition:** `gs.tenured.map(x => x.id).join(",") === "3,1" && gs.pool.map(x => x.id).join(",") === "4,2" && gs.pool.every(x => x.src === QUAL_SRC_POOL) …`

**Evidence.**

`hourWeight` is the one chart-derived reading NOT routed through the resolver: `const hw = hourWeight(sp);` — the raw spark, while `tr`, `vt`, `mo` and `stw` all read `ser`. Its absence value is indistinguishable from a measurement: `if (!sp || !sp.byHour || !sp.byHour.some(v => v > 0)) return { w: 1, why: null };` versus a measured-balanced item's `Math.max(0.7, Math.min(1.3, (s / HOUR_WINDOW_H) / mean))` = 1.0. `hw.w` multiplies the plan score: `score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * (1 + Math.min(wins, 5) * 0.1) * hw.w * stw.w * rel.w`. The two-group split does NOT protect this population: `const planTenured = x => (x && x.src === QUAL_SRC_POOL) ? false : true;` and `src` is stamped only at `watch.concat(cutoverPoolRows().map(p => markSrc(candidateFor(p), QUAL_SRC_POOL)))` — every watch-derived candidate has no `src` and lands in the score-sorted tenured group. TODAY that is harmless because a watch item with no spark has `tr == null` → the mask benches it → `failed` is set → `score` is 0 → it sinks. Post-transition the archive feeds `tr`, the mask lifts, and the item enters `pass` carrying `hw.w = 1` FROM ABSENCE, ranked against items whose hw is a real 0.7–1.3 measurement. Reachable without the cutover: the /timeseries breaker (`TS_FAIL_TRIP = 8, TS_PAUSE_MS = 30 * 60e3`), a per-id negative cache (`TS_NEG_TTL`), or a cold boot before `fillSparks`. The exclusion is also undocumented despite a comment promising otherwise — candidateFor says "`hourWeight` is deliberately NOT on it and says so below", and there is no such statement below: the call site carries only "/* Absence-tolerant weights (computed even when benched, for display). */", and `hourWeight`'s own definition carries no note. Relatedly, `itemSeries` builds a `byHour` field on every return (`byHour: sp.byHour` / `byHour: null` / `byHour: sp ? sp.byHour : null`) that NO production caller reads — a scan-2(a) orphan sitting exactly where the missing wiring would go.

**Production cited.**

```js
const hw = hourWeight(sp);
```

**Verifier method.** Read index.html: `candidateFor`'s weight block, `hourWeight`, the `score:` expression, `planTenured` / `planGroups` / `planPoolSortKey` and the design comment above them, `planCandidates` (both stamp sites), `sparkFor` and the TS breaker constants, `fillSparks`. Ran `grep -n 'hw.w|hourWeight|planTenured|QUAL_SRC_POOL|markSrc' index.html` and `grep -n byHour index.html` to enumerate every reader.

**Verifier says.** The mechanism is real, but one load-bearing sentence of the evidence is wrong and must not be carried forward. CONFIRMED parts: `const hw = hourWeight(sp);` reads the raw spark while `tr`, `vt`, `mo` and `stw` all read `ser` — it is the one chart-derived reading off the resolver. Its absence value is indistinguishable from a measurement: `if (!sp || !sp.byHour || !sp.byHour.some(v => v > 0)) return { w: 1, why: null };` versus a measured-balanced `Math.max(0.7, Math.min(1.3, (s / HOUR_WINDOW_H) / mean))` = 1.0. It multiplies the score: `score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * (1 + Math.min(wins,5)*0.1) * hw.w * stw.w * rel.w`. `planTenured = x => (x && x.src === QUAL_SRC_POOL) ? false : true;` routes every non-pool candidate into `tenured.sort((a,b) => b.score - a.score)`, so a watch item with no spark is ranked by a score carrying a neutral-from-absence multiplier against items whose hw is a real 0.7–1.3. The plan's own design comment states the property it fails to cover: "a weight of 1.0 from no data and a weight of 1.0 from balanced data are indistinguishable in an ordering and mean opposite things" — and the split keys on `src`, not on whether the weight was fed. Today the mask protects the population (no spark → tr null → benched → `failed` → score 0); post-transition `ser` resolves to the archive, tr is fed, the mask lifts, and the item enters `pass` with hw defaulted. Reachability confirmed at the source: `sparkFor` throws under the breaker (`TS_FAIL_TRIP = 8, TS_PAUSE_MS = 30*60e3`), under the per-id negative cache (`TS_NEG_TTL`), and `fillSparks` runs after the first scout pass on a cold boot. The comment-promise half is also confirmed: line reading "`hourWeight` is deliberately NOT on it and says so below" is followed only by `/* Absence-tolerant weights (computed even when benched, for display). */`, and `hourWeight`'s definition carries no note — the promised statement does not exist. The `itemSeries` byHour orphan is confirmed too: all three returns carry a `byHour` field, and `grep -n byHour index.html` shows every production reader goes through `sp.byHour` / `(S.spark.get(x.id)||{}).byHour` — nothing reads it off an `itemSeries` result.

**Correction to the finder.** REFUTE one factual claim inside the evidence: "`src` is stamped only at `watch.concat(cutoverPoolRows()...)` — every watch-derived candidate has no `src`" is FALSE. `planCandidates` reads `const watch = DB.watch.map(w => markSrc(candidateFor(w), QUAL_SRC_WATCH));` — watch candidates ARE stamped, with `QUAL_SRC_WATCH`. The conclusion survives unchanged because `planTenured` is written as `src === QUAL_SRC_POOL ? false : true`, so `"watch"` routes to the score-sorted tenured group either way. Fix the sentence before this becomes a MISTAKES entry; a finding whose stated mechanism is wrong invites a fix aimed at the wrong line.

**Proposal — NOT APPLIED.** Two separable decisions, and they should be ruled separately. (1) DOCUMENTATION: either write the promised statement at the `hourWeight` call site, or delete the false claim that one exists. (2) BEHAVIOUR: give `hourWeight` a third state — return `{ w: 1, fed: false, why: null }` on absence — so the score's caller can keep unfed items out of one ranked list the way `planTenured` already does for the pool, and so `[R96.1]` can assert the fourth reading it currently excludes by silence. Feeding byHour FROM the archive is the deployment-class option (bucket keys are hour timestamps, so `new Date(k).getHours()` would build it) and is a separate ruling. The orphan `byHour` field on the resolver result should be removed or wired in the same pass.

---

## 4. [MONEY-PATH] TESTED_TTL_MS's VALUE is pinned nowhere; both §95 TTL fixtures derive their 'stale' timestamp FROM the constant, so any value passes

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `money-path-new-assertions`
- **Failure mode:** fixture-relative-to-the-constant (failure mode 1: the fixture makes the comparison true by construction)
- **Assertion:** [R95.3] a FRESH re-test releases the proven-loser bench and a STALE one does not — the discriminating pair, and the only assertion anywhere that exercises TESTED_TTL_MS  /  [R95.4] ... the 16h TTL asserted for the first time
- **Condition:** `[R95.3] `!fresh95.includes("proven-loser bench") && stale95.includes("proven-loser bench")`, with the stale arm built as `tAt: Date.now() - TESTED_TTL_MS - 60e3`. [R95.4] `cFresh.buy === 3000 && cFresh.sell === 5000 && cFresh.tested === true && cStale.buy === 4000 && cStale.sell === 4400 && !cStale.tested`, stale arm again `Date.now() - TESTED_TTL_MS - 60e3`.`

**Evidence.**

Production: `const TESTED_TTL_MS = 16 * 3600e3;` — grep over BOTH files returns exactly four production uses (`calc`'s `const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;`, `provenLoser`'s `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`, a toast, and the declaration) and three probe uses — all three in the fixture arithmetic, none in an assertion condition. No assertion anywhere evaluates the constant's value. Set `TESTED_TTL_MS = 90 * 86400e3` and every one of [R95.3], [R95.4] and the whole suite stays green, because both fixtures move their own goalposts with it. Consequence is deployment-class in the constitution's own sense — a longer TTL widens what the allocator may fund on two independent paths at once: a stale tested pair keeps overriding live prices inside `calc()` (so sizing and every gate downstream read a snapshot instead of the market), and a proven-loser bench stays released longer. The project already has the remedy as precedent two blocks earlier: `[R94.3] VOL5_UNIVERSE === false and pinned` and `[R89.1]` pinning `CUTOVER_POOL`.

**Production cited.**

```js
const TESTED_TTL_MS = 16 * 3600e3;   ...   const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;   ...   if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;
```

**Verifier method.** Grepped `TESTED_TTL_MS` across index.html and tools/probe/probe-snippet.html and read every one of the seven hits in place. Read index.html's `const TESTED_TTL_MS = 16 * 3600e3;` with its comment, calc()'s `const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS; if (tested){ buy = OPS.tBuy; sell = OPS.tSell; }`, and provenLoser's TTL line. Read §95's four ok() calls verbatim. Grepped the probe for `16h|16 \* 3600` — the single hit is [R95.4]'s label string, no condition. Matched [R89.1] and [R94.3] as the pinning precedents.

**Verifier says.** Mechanically confirmed. `grep -n TESTED_TTL_MS` over both files returns exactly seven hits: four in index.html (`const TESTED_TTL_MS = 16 * 3600e3;`, calc's `const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;`, provenLoser's `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`, and a toast) and three in the probe — 10711 `tAt: Date.now() - TESTED_TTL_MS - 60e3`, 10722 the same expression, and 10713 the [R95.3] LABEL text. Not one is inside an assertion condition. Both stale arms are the constant minus 60s and both fresh arms are `Date.now()`, so the comparison is true by construction at any positive TTL: set it to 90 days and [R95.3]/[R95.4] stay green. The precedents the finder cites are real and I matched them: `ok("[R89.1] CUTOVER_POOL is FALSE and pinned...", CUTOVER_POOL === false, ...)` and `ok("[R94.3] VOL5_UNIVERSE is FALSE and pinned...", VOL5_UNIVERSE === false ...)`. Both consumers are money-path: a longer TTL keeps a stale tested pair overriding live prices inside calc() (so every downstream gate and the sizing read a snapshot), and keeps a proven-loser bench released.

**Correction to the finder.** Two corrections to the finding as written. (a) The title's "any value passes" is false: the fresh arms use `Date.now()` read microseconds before the comparison, so a TTL of 0 or negative WOULD turn both red. The true statement is that any positive value passes. (b) Severity is not money-path. The assertions do bite for the BEHAVIOUR they name — delete `(Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS` from calc and cStale.buy becomes 3000 not 4000, red; delete the TTL conjunct from provenLoser and the stale arm releases, red. What is unpinned is the magnitude only, so this is a coverage/label finding, and its sharpest form is that [R95.4]'s label says "the 16h TTL asserted for the first time" while 16 is asserted nowhere.

**Proposal — NOT APPLIED.** Would need a seed to confirm the direction, but the arithmetic is decisive without one. Add the pin in the [R94.3]/[R89.1] shape — assert `TESTED_TTL_MS === 16 * 3600e3` alongside the mechanism assertions — and say in the labels that [R95.3]/[R95.4] test the EXPIRY BRANCH, not the 16 hours. As written the labels and REQUIREMENTS rows R95.3/R95.4 both name '16h' and neither the assertions nor anything else in the suite reads it.

---

## 5. [MONEY-PATH] The blacklist ruling shipped with ZERO assertions and zero REQUIREMENTS rows — three new guards on the constitutional veto, all invisible to the suite

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `pool-branch-and-ops`
- **Failure mode:** no assertion exists (the §95 shape, recurring inside the same session that created §95)
- **Assertion:** (none — grep of tools/probe/probe-snippet.html for `exc.gate`, `excFor`, and `shadowExceptions` inside any `validateImport(...)` fixture returns nothing; REQUIREMENTS.md ends at §98 with no row for any of the three)
- **Condition:** `(none)`

**Evidence.**

Three production lines landed this session and nothing watches any of them. Delete all three and the suite stays green — the exact `[R7.3]` failure §95 was created to close, recurring in the same commit. The vector is live, not theoretical: `load()` is `const raw = localStorage.getItem(K); if (raw) DB = Object.assign(DB, JSON.parse(raw));` — NO validation on boot. A `gate: "blacklist"` record imported before the fix, or written into localStorage by any means, survives every boot forever and is never re-validated, so `buildPlan`'s two guards are the LIVE guard, not a belt over the import check. `excFor` matches `e.status !== "revoked"`, so such a record is found; without the guards, `x.fails.every(f => f.g === exc.gate)` is satisfied for an item whose only fail is `blacklist`, `delete x.failed` runs, `x.exception` is set, and the item is funded — and it additionally clears seasoning via `qualExemption(...) || (x.exception ? "probationary exception is your explicit ruling…" : null)`. Separately confirmed: the third guard is not a no-op either — `GATE_CHAIN_ORDER` is a strict superset of everything `fails[].g` can carry (all 15 `chk(...)` gate keys in `candidateFor` are members; the 16th, `"no live price"`, is on the early-return path that never builds a `fails` array), so the enumeration drops nothing legitimate and its correctness rests entirely on that superset relation — which no test pins.

**Production cited.**

```js
buildPlan: `if (exc && exc.gate === "blacklist") continue;` and `if (exc && isBlk(x.id)) continue;` — validateImport: `if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;`
```

**Verifier method.** Read index.html 1355-1385 (load), 5320-5345 and 5375-5395 (candidateFor early return + chk chain), 5488-5500 (full return), 6150-6200 (buildPlan exception block), 6300-6325 (qualExemption bypass), 7692-7695 (GATE_CHAIN_ORDER), 10637 (excFor), 24290-24325 (validateImport shadowExceptions stanza). Read tools/probe/probe-snippet.html 10660-10780 (§95). Ran: grep -n 'gate: *"blacklist"' (empty), grep -n 'validateImport' (18 sites, none with shadowExceptions), grep -n 'GATE_CHAIN_ORDER' probe (1 hit, payload only), grep R95/R96/R97/R98 REQUIREMENTS.md (ends R98.5), git diff -U0 index.html | grep '^+' (all three lines added), awk over 5320-5620 extracting chk() gate literals.

**Verifier says.** Every limb independently traced and true.

(a) All three lines are NEW and uncommitted. `git diff index.html` shows `+    if (exc && exc.gate === "blacklist") continue;`, `+    if (exc && isBlk(x.id)) continue;` and `+            if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;` as added lines.

(b) Nothing watches any of them. `grep 'gate: *"blacklist"'` over tools/probe/probe-snippet.html returns EMPTY — no fixture anywhere constructs an exception record on the blacklist gate. `grep GATE_CHAIN_ORDER` over the probe returns exactly one hit, line 1444, and it is a payload field in [R4.3]'s `sacredNow()` snapshot (`gates: GATE_CHAIN_ORDER`), not an assertion of the import enumeration. None of the 18 `validateImport(...)` call sites in the probe passes a `shadowExceptions` key at all. REQUIREMENTS.md ends at R98.5 (line 561-562); there is no row for any of the three.

(c) The §95 counterweight does not cover it. §95 asserts `[R95.1]` — the blacklist bench inside `candidateFor` — via `DB.blacklist = [9501]; blk95.includes("blacklist")`. That is the gate that WRITES the fail. The three new lines are the exception-override path in `buildPlan` and the import writer, which §95 never reaches: §95 sets `DB.blacklist` and never touches `DB.shadowExceptions`.

(d) The persistence vector is live, as claimed. `function load()` at index.html:1360 is `const raw = localStorage.getItem(K); if (raw) DB = Object.assign(DB, JSON.parse(raw));` followed only by an `Array.isArray` coercion loop that includes `"shadowExceptions"`. No per-row validation on boot. A record with `gate: "blacklist"` persisted by any means is never re-validated, so the two `buildPlan` guards are the live guard, not a belt over the import check.

(e) The funding path is real. `const excFor = id => (DB.shadowExceptions || []).find(e => e.id === id && e.status !== "revoked");` finds it. `chk(isBlk(w.id), "blacklist", …)` at index.html:5381 puts `blacklist` into `fails[].g`, so `!x.fails.every(f => f.g === exc.gate)` is satisfied for an item whose only fail is blacklist; `delete x.failed; x.exception = exc;` runs. The seasoning bypass is confirmed verbatim at index.html:6310-6311: `const qex = qualExemption(x.id, x.c) || (x.exception ? "probationary exception is your explicit ruling — seasoning would only delay the adjudication it exists for" : null);`

(f) The third guard is not a no-op. I enumerated every `chk(...)` gate literal in `candidateFor` (index.html 5320-5620): 15 names — blacklist, proven-loser bench, ROI floor, margin floor (ticks / 3× tax), book skew, flow imbalance, no history, chart still loading, trend, volume trend, sizing, volume floor, momentum, fill history, drift bench. `GATE_CHAIN_ORDER` (index.html:7692) holds all 15 plus "no live price", which is on the early-return path `return { id:w.id, name: itemName(w.id), failed:"no live price in /latest" };` that builds no `fails` array. Strict superset confirmed; the enumeration drops nothing legitimate, and no test pins that relation.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** A §99 with (1) the discriminating pair at the CHAIN that decides funding, not at the term: seed `DB.shadowExceptions = [{id, gate: "blacklist", status: "active", …}]`, put the id in `DB.blacklist`, build the plan, assert the item is in `bench` with the blacklist reason and NOT in `picks` — then flip `exc.gate` to `"ROI floor"` on a non-blacklisted item and assert it does fund, so the guard is proven to refuse selectively rather than to refuse everything; (2) the second guard asserted independently of the first by giving the record a non-blacklist gate while `isBlk(x.id)` is true, otherwise `fails.every(...)` alone would explain the refusal and either guard could be deleted with the pair still green; (3) `validateImport({ shadowExceptions: [...] })` in the [R87.5] idiom, asserting `"blacklist"` and an unrecognised gate are both dropped while every one of the 15 real `fails[].g` names survives — that last half is what pins the superset relation; and (4) a REQUIREMENTS §99 row for each, or `reqpair.sh` will not see the gap either.

---

## 6. [MONEY-PATH] The money-path horizon call site gained the term but no detector — [R72.1]–[R72.3] still guard only the function, never the sizing site that spends

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** coverage gap (no assertion exists on the subject)
- **Assertion:** [R72.1] the horizon term SCALES with its inputs — asserted by proportion, never by restating the formula / [R72.2] the call site CLAMPS the term to qty — asserted as wiring, apart from the term itself
- **Condition:** `[R72.1]: `const a = horizonUnitsFor(50000), b = horizonUnitsFor(100000); … return a > 0 && Math.abs(b - 2 * a) <= 1 && Math.abs(c - 2 * a) <= 1;`  [R72.2]: `planHorizonUnits(50000, 12) === 12 && planHorizonUnits(50000, 1e9) === horizonUnitsFor(50000)``

**Evidence.**

[R72.2] names "the call site", but the call site it exercises is `planHorizonUnits`, whose only production caller is `const horizonUnits = planHorizonUnits(volGate, qty);` inside candidateFor — the scoring copy. Nothing in the suite reaches `sizeLine`. Grep of tools/probe/probe-snippet.html for `byLiquidity`, `preRamp`, `slow-fill` and `fit this touch` returns zero hits; §98 ("ONE ALLOCATOR FIXTURE, FIVE UNASSERTED CAPS") builds real plans but asserts only the family rule, the worth-a-slot floor, committed()'s positions limb and clusterExposure's lots limb. [R7.3] test: re-inline `sizeLine`'s byLiquidity as, say, `Math.floor(x.volGate * FILLH() * GATE.capture / 2)` and every [R72.x] assertion stays green, because none of them calls buildPlan. Worse, §98's own fixture cannot bite even by accident: `mk98` sets highPriceVolume/lowPriceVolume 50000 and `l: 25000`, so byLiquidity ≈ 50000·0.15·FILLH() ≈ 37,500 against a 25,000 buy limit — the buy-limit clamp inside planCap pins qty, and the horizon term is the non-binding input in every plan the suite builds. The extraction is correct and the duplication is genuinely gone; what did not ship in the same commit is the detector that keeps it gone. This is the conformance gate's own rule ("Detectors shipped in the same commit as the surfaces they watch") applied to the one change in this session that moves position sizes.

**Production cited.**

```js
index.html, buildPlan/sizeLine: `const byLiquidity = horizonUnitsFor(x.volGate);` — its own comment says the replaced form was `Math.floor(x.volGate * FILLH() * GATE.capture)` and that this is "the path that SIZES REAL CAPITAL, while [R72.1]-[R72.3] guarded the copy that only feeds the score".
```

**Verifier method.** Read index.html lines 3560–3620 (horizonUnitsFor/planHorizonUnits/planCap/applySizeFactors), 5470–5500 (candidateFor's planHorizonUnits call), 6265–6300 and 6330–6370 (sizeLine, pass 1, the predicted-slow-fill branch), 5125–5150 and 7810–7830 (the mmVerdict and relocNote call sites). Read tools/probe/probe-snippet.html lines 110–180 (the full [R72.1]–[R72.3] block) and 10887–11018 (§98 in full). Grepped both files for horizonUnitsFor/planHorizonUnits/byLiquidity/preRamp/sizeLine/allocQty and traced each allocQty assertion to the input that pins it.

**Verifier says.** Traced and confirmed as a coverage gap. Production `index.html` line reads `const byLiquidity = horizonUnitsFor(x.volGate);` inside `sizeLine`, and `horizonUnitsFor` is `const horizonUnitsFor = volGate => Math.floor(volGate * GATE.capture * FILLH());`. `planHorizonUnits` — the only subject of [R72.2] — has exactly one production caller, `const horizonUnits = planHorizonUnits(volGate, qty);` in `candidateFor`, which feeds `score` and `estH`, not `allocQty`. Grep of `tools/probe/probe-snippet.html` for `byLiquidity|preRamp|sizeLine|slow-fill|fit this touch|wouldQty|participation-capped` returns ZERO hits. [R7.3] traced against every assertion that could see a size: `allocQty` appears on six probe lines and none is sensitive. Line 111 `inCl[0].allocQty === 4000` is pinned by the CLUSTER CAP; line 184 `gamma.allocQty === 5000` is pinned by the PER-ITEM CAP (the probe's own comment states the horizon term computes 30,000 for gamma, so it is the non-binding input); lines 1539/1543 and 1937 compare `pT.allocQty === q0` and `=== Math.floor(q0/2)` — ratios against a baseline recomputed under the same defect, insensitive by construction; line 1278 compares two plans to each other. In §98, `mk98` sets `highPriceVolume/lowPriceVolume: 50000` and `l: 25000`, and §98's four assertions read `picks.length`, `bench` membership, `committed()` and `clusterExposure()` — never a size. So halving, doubling, or re-inlining `byLiquidity` leaves all 1200 green.

**Correction to the finder.** One narrowing of the finder's framing, which lowers the severity slightly: the M118-class defect (sizing silently reverting from the touch schedule to DB.fillHorizonH) is now structurally impossible at sizeLine, because sizeLine calls the one expression [R72.3] proves reads FILLH() rather than the fallback. The residual unguarded surface is narrower than 'the sizing term is untested': it is the ARGUMENT and the CALL (a future edit passing x.c.vol instead of x.volGate, dropping the term from the Math.min, or re-inlining it). That is still real and still money-path — the term is one of three inputs to `preRamp = Math.min(x.qty, byLiquidity, Math.max(0, byPart))` — but the finder's chosen seed (`… * GATE.capture / 2` re-inlined) overstates by implying the extraction bought nothing. Also note 'Nothing in the suite reaches sizeLine' is literally false — buildPlan is called ~40 times, so sizeLine EXECUTES constantly; what is absent is any assertion whose result the term can move.

**Proposal — NOT APPLIED.** An assertion that binds the sizing site, not the term: build a §98-style plan where the HORIZON is the pinning input — set the item's `l` (buy limit) far above `volGate * GATE.capture * FILLH()` and the working stack high enough that planCap's one-third limb does not bind — then assert `plan.picks[0].qty === horizonUnitsFor(volGate)` and, discriminating, that halving DB.touchWindows' gap halves the funded qty. State in the label WHICH input pins the output for that fixture (the clamp-absorption rule), because the current fixture's pinning input is the buy limit and any assertion written on it would be absorbed.

---

## 7. [MONEY-PATH] Both new blacklist-exception guards ship with zero assertions — the one constitutional boundary the constitution calls the user's alone

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** guard shipped without detector
- **Assertion:** nearest existing: [R26.1] a red flag (blacklist) bars the lane entirely
- **Condition:** ``exceptionEvidence(9320) === null` — the GRANT path only.`

**Evidence.**

Grep of the probe for `blacklist` intersected with `exc|except` returns only [R26.1] and three fixture resets (`DB.shadowExceptions = []`). [R26.1] asserts the grant path — `exceptionEvidence` refusing a blacklisted item — which is precisely the path the production comment says is NOT the hole: "The record cannot be produced through the UI — exceptionEvidence returns null for a blacklisted item — but it CAN arrive by import". Neither the import enumeration nor the funding-loop guard has an assertion. The consequence if either regresses: an exception record carrying `gate: "blacklist"` on an item whose only fail is the blacklist reaches `if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;` with `every()` TRUE, its bench is deleted, and a blacklisted item funds. The two guards are not redundant with each other — the import guard covers the state-backup file, and the funding guard covers a DB.shadowExceptions loaded straight from localStorage, which never passes through validateImport — so both are load-bearing and both are unwatched. [R7.3]: delete either line and 1200 assertions stay green.

**Production cited.**

```js
index.html, buildPlan's exception loop: `if (exc && exc.gate === "blacklist") continue;` and index.html, validateImport: `if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;`
```

**Verifier method.** Read index.html 6140–6185 (buildPlan's exception loop with both guards and the following `if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;`), 24290–24330 (validateImport's shadowExceptions branch), 1360–1385 (load()'s Object.assign and the array-coercion list), 10640–10700 (exceptionEvidence and its red-flag bar). Grepped probe-snippet.html for `blacklist`, `shadowExceptions`, `R26.`, `validateImport` and read the §26 block at lines 3927–4035.

**Verifier says.** Both guards exist and both are unwatched. Production: `if (exc && exc.gate === "blacklist") continue;` in buildPlan's exception loop, and `if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;` in validateImport's shadowExceptions sanitizer. Grep of the probe for `blacklist` yields 40 hits; intersected with exception machinery, the only one is `ok("[R26.1] a red flag (blacklist) bars the lane entirely", exceptionEvidence(9320) === null);` — the GRANT path, which the production comment explicitly identifies as the path that is NOT the hole ('The record cannot be produced through the UI … but it CAN arrive by import'). No probe line ever pushes a `shadowExceptions` record carrying `gate: "blacklist"`, and grep of `validateImport` in the probe returns 20 call sites, none passing shadowExceptions. The finder's independence argument also holds, and I verified it: `load()` does `DB = Object.assign(DB, JSON.parse(raw))` and then only coerces `shadowExceptions` to an array — no per-record gate validation — so a localStorage store never passes through validateImport, making the buildPlan guard load-bearing on its own. Deleting either line leaves 1200 green.

**Correction to the finder.** No correction to substance. One precision: the funding-loop guard's regression consequence is contingent on a malformed store reaching localStorage, and `excFor` records normally originate from `exceptionEvidence`, which refuses blacklisted items — so this is a defence-in-depth gap, not a live bypass. It ranks high because the constitution names the blacklist as the user's alone with no automated clearing path, and the guard that enforces it at the funding moment has nothing watching it.

**Proposal — NOT APPLIED.** Two assertions, each pointed at the layer that owns its promise. (1) `validateImport({ shadowExceptions: [{ id: 9, gate: "blacklist", status: "active" }, { id: 9, gate: "not a gate", status: "active" }] }).db.shadowExceptions.length === 0`, with a discriminating partner carrying `gate: "ROI floor"` that survives — otherwise the assertion passes on any total-rejection bug. (2) The funding assertion, which must bypass validateImport to reach the guard the way localStorage does: set `DB.shadowExceptions = [{ id, gate: "blacklist", status: "waived", … }]` and `DB.blacklist = [id]` directly, run buildPlan, and assert the item is in `bench` and absent from `picks`; seed by deleting the guard line and confirm it funds.

---

## 8. [CORRECTNESS] [R94.1]'s `||` short-circuits on its first limb — "unknown is not a pass" is never evaluated despite being the label's headline claim

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** 1 tautology/short-circuit (a disjunct already true pins the result)
- **Assertion:** [R94.1] and while it is accruing the copy says unknown is NOT A PASS, naming all four consumers — the mask the chart bench currently provides is exactly what makes the scope correction load-bearing
- **Condition:** `/trend, volume trend, momentum "?\n?\s*\+? ?"?and drift/.test(chartWireState({ observed: 93 }).why.replace(/\s+/g, " ")) || (/trend, volume trend, momentum and drift/.test(…) && /unknown is not a pass/i.test(…))`

**Evidence.**

`chartWireState`'s accruing branch produces `… " OBSERVED days accrued — trend, volume trend, momentum " + "and drift stay unknowable until " + CHART_MIN_DAYS + ", and unknown is not a pass"`. I verified the first limb matches that shipped text without executing the app: `printf '3.9 of 7 OBSERVED days accrued — trend, volume trend, momentum and drift stay unknowable until 7' | grep -cP 'trend, volume trend, momentum "?\n?\s*\+? ?"?and drift'` returns 1. Because limb A is satisfied, JavaScript's `||` never evaluates limb B, and limb B is the ONLY place `unknown is not a pass` is tested. Delete that clause from the production copy and the assertion stays green. The label names two claims; the condition can only ever check one of them. The four-consumer half is genuinely covered; the not-a-pass half is decoration.

**Production cited.**

```js
+ "and drift stay unknowable until " + CHART_MIN_DAYS + ", and unknown is not a pass" };
```

**Verifier method.** Read index.html `chartWireState` in full (all three branches). Read tools/probe/probe-snippet.html both `[R94.1]` assertions. Reconstructed the shipped accruing string into a file and ran `grep -cP 'trend, volume trend, momentum "?\s*\+? ?"?and drift'` against it to confirm limb A matches without executing the app.

**Verifier says.** Reproduced rather than reasoned. Production's accruing branch: `if (days < CHART_MIN_DAYS) return { ready: false, state: "accruing", days, why: Math.round(days*10)/10 + " of " + CHART_MIN_DAYS + " OBSERVED days accrued — trend, volume trend, momentum " + "and drift stay unknowable until " + CHART_MIN_DAYS + ", and unknown is not a pass" };`. The assertion is `A || (B && C)` where A = `/trend, volume trend, momentum "?\n?\s*\+? ?"?and drift/.test(why.replace(/\s+/g," "))` and C = `/unknown is not a pass/i.test(…)`. I built the exact shipped string and matched limb A against it with `grep -cP` — returns 1. Limb A is satisfied by the real copy, so JavaScript's `||` never evaluates the parenthesised group, and C is the only place the not-a-pass clause is tested anywhere in the condition. Delete `", and unknown is not a pass"` from production and limb A is untouched — green. The label names two claims ("the copy says unknown is NOT A PASS, naming all four consumers"); the condition can only ever check the second.

**Correction to the finder.** Accurate. The `||` looks like a defensive alternative for a copy variant that no longer exists; joining the two limbs with `&&` (or deleting limb A's escape hatches) restores the label's second claim.

**Proposal — NOT APPLIED.** Replace the `||` with a conjunction: `/trend, volume trend, momentum and drift/.test(w) && /unknown is not a pass/i.test(w)` against the whitespace-normalised string. The `"?\n?\s*\+? ?"?` alternation inside limb A exists to survive a source-level line break in the concatenation — that is a symptom of matching a string that was assembled across a `+`; normalising with `.replace(/\s+/g, " ")` (which the assertion already does) makes the alternation unnecessary. Per the eleventh face, also forbid the contradicting claim: assert the copy does NOT contain a form asserting the gates are satisfied.

---

## 9. [CORRECTNESS] [R92.5] and [R92.3] pin plan copy that becomes FALSE at the chart transition — an anti-tripwire pointing the opposite way from [R76.9]

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `series-resolver`
- **Failure mode:** 7 stale coverage (an assertion requires text that the transition invalidates, and holds it green)
- **Assertion:** [R92.5] the inert restraints are stated ONCE over the pool population — four unknowns stamped on every row would read as four problems with the item, which is the opposite of true
- **Condition:** `/^2 pool items carry restraints/.test(inertTxt) && /momentum and drift read UNKNOWN \(not steady\)/.test(inertTxt) && /5m die-off streak is not counted/.test(inertTxt) && /Unknown is not a pass/.test(inertTxt)`

**Evidence.**

`planInertLine` renders "… carry restraints the archive cannot feed yet: momentum and drift read UNKNOWN (not steady), the 5m die-off streak is not counted for them, and the chart gates are " + (days == null ? "still accruing" : "at " + days + " of 7 observed days") — the momentum/drift clause is UNCONDITIONAL; only the days string varies. The day the coverage gate flips, `itemSeries` resolves pool items to the archive, momentum and drift become real readings, and this line goes on telling the operator they read UNKNOWN — while rendering "at 7 of 7 observed days" in the same sentence, which contradicts it. [R92.5] hard-requires the false clause, so it stays green through the transition. Same shape at [R92.3]'s companion: it requires `/NOT FED/.test(PLAN_POOL_HEADER)` and `/wins, hour, stability, reliability/.test(PLAN_POOL_HEADER)`, and `PLAN_POOL_HEADER` reads "the history weights (wins, hour, stability, reliability) are NOT FED for these items and are not applied" — post-transition `stability` IS fed (it is `stw` off the resolver; "not applied" stays true, "NOT FED" does not). This is the exact inverse of the armed era tripwire the conformance gate relies on: `marketStatsFor().tr === null` inside [R76.9] goes RED at the transition and forces the accounting; these two go on being green while the copy they pin becomes wrong.

**Production cited.**

```js
+ " carry restraints the archive cannot feed yet: momentum and drift read UNKNOWN " + "(not steady), the 5m die-off streak is not counted for them, and the chart gates are "
```

**Verifier method.** Read index.html: `planInertLine` in full, `PLAN_POOL_HEADER`, `planPoolSortKey`, and the `#benchBody` render site to confirm the line is not readiness-gated. Read tools/probe/probe-snippet.html `[R92.3]` (both assertions, including the `mk()` fixture) and `[R92.5]` (both assertions) in full.

**Verifier says.** Both halves check out on the text. `planInertLine` builds its string as `pool.length + " pool item" + … + " carry restraints the archive cannot feed yet: momentum and drift read UNKNOWN " + "(not steady), the 5m die-off streak is not counted for them, and the chart gates are " + (days == null ? "still accruing" : "at " + days + " of 7 observed days")` — the momentum/drift clause is outside the ternary, so only the days string varies. Its render site is gated only on population, not on readiness: `const inert = planInertLine(PLAN), pdrill = poolDrill(PLAN); if (inert || pdrill) $("#benchBody").innerHTML = …`. [R92.5]'s condition hard-requires `/momentum and drift read UNKNOWN \(not steady\)/.test(inertTxt)`, so the day the archive matures and `itemSeries` resolves pool items to it — momentum fed at ≥5 finite points, drift at ≥24 — the line asserts a falsehood and the assertion requires the falsehood to stay. The companion is the same shape: `PLAN_POOL_HEADER = "sorted by expected gp per horizon — the history weights " + "(wins, hour, stability, reliability) are NOT FED for these items and are not applied"`, and the assertion requires `/NOT FED/` and `/wins, hour, stability, reliability/`. Post-transition `stability` is fed (`stw = stabilityWeight(ser.pts, …)` off the resolver); `hour` genuinely stays unfed (finding 3), and "not applied" stays true because `planPoolSortKey` uses only eMargin × horizonUnits. So the header becomes partly false and the assertion holds it. This is the inverse of the ruled era tripwire: `[R76.9]`'s `marketStatsFor().tr === null` goes RED at the transition and forces the accounting; these two go green through it.

**Correction to the finder.** One nuance to state when this is ruled: under the [R7.3] standard these assertions are not weak TODAY — delete the clause now and both go red. The finding is about a latent inversion, not a current false green. That is a different remedy: the clauses need a readiness condition in production (and the assertions need to follow it), not a stronger match.

**Proposal — NOT APPLIED.** Make `planInertLine` compute its clause list from the candidates' ACTUAL readings — the same values `[R96.1]` inspects (`x.mo.state == null`, `x.stw.drifty == null`, `x.tr == null`, `x.vt == null`) — rather than asserting the era. Then the copy self-corrects at the transition and the assertion can be written against a fixture in each era, which is the discrimination the tenth face demands. Same for `PLAN_POOL_HEADER`: split "NOT FED" (a per-reading fact that changes) from "not applied" (a sort-design fact that does not).

---

## 10. [CORRECTNESS] `chartedNow()` bypasses the resolver — an archive-fed item is permanently exempt from scout eviction and sibling washout

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** Production defect: two definitions of "the chart is loaded", one of which the repair did not sweep
- **Assertion:** (no assertion — grep of probe-snippet.html for `chartedNow` returns nothing)
- **Condition:** `n/a`

**Evidence.**

`const chartedNow = () => new Set(DB.watch.filter(w => S.spark.get(w.id)).map(w => w.id));` defines charted as SPARK PRESENCE. The gate chain now defines the same predicate as `tr != null` off `itemSeries`. Post-transition the two disagree: an item fully judged from the archive (mask lifted, every gate fed) is absent from `chartedNow()`. Both consumers then decline to act — the scout's `if (!charted.has(w.id)) return true; // never judged this pass (chart not loaded) — no evidence, no eviction`, and sibling washout's `if (!chartedSib.has(w.id)) return true;`. The guard's own stated precondition ("an item that could not be judged this pass is not evidence of anything") has become false for exactly the population it now protects. Direction matters: failing to evict WIDENS what stays on the watchlist and therefore what may be funded, which is the deployment side of the restraint line. Reachability is bounded — `fillSparks` normally supplies watch members with sparks, and pool items are not in `DB.watch` at all — so the population is watch items during a /timeseries outage or before the first fill, and it is unbounded in TIME once it occurs (the eviction clock never advances a verdict).

**Production cited.**

```js
const chartedNow = () => new Set(DB.watch.filter(w => S.spark.get(w.id)).map(w => w.id));
```

**Verifier method.** Read index.html: `chartedNow` and its header comment, `runScout`'s eviction filter in full (the five guards preceding the `SCOUT_EVICT_MS` test), the sibling washout filter, `SCOUT_EVICT_MS` / `SIB_WASHOUT_MS` context. Ran `grep -n 'chartedNow|chartedSib' index.html` and `grep -c chartedNow tools/probe/probe-snippet.html`.

**Verifier says.** Both definitions read as quoted, in their guards. `const chartedNow = () => new Set(DB.watch.filter(w => S.spark.get(w.id)).map(w => w.id));` — spark presence, with a header comment stating its purpose as evaluability ("an item that could not be judged this pass is not evidence of anything"). The chain now defines evaluability as `tr != null` off `itemSeries`, which resolves to the archive when no spark exists. Both consumers are early-returns inside `DB.watch.filter`: the scout's `if (!charted.has(w.id)) return true; // never judged this pass (chart not loaded) — no evidence, no eviction` sits after the src/sib/held/tBuy guards and before the 48h `SCOUT_EVICT_MS` test; sibling washout's `if (!chartedSib.has(w.id)) return true;` sits after `if (w.sib == null || protectedW(w)) return true;` and before the 5-day `SIB_WASHOUT_MS` test. So an item the chain judged from the archive returns `true` from both filters and is never culled, on a clock that never advances. `grep -c chartedNow tools/probe/probe-snippet.html` returns 0 — no assertion covers either guard, so the divergence cannot go red. Reachability is the same bounded set as finding 3 (breaker, negative cache, cold boot), and pool items are not in `DB.watch` at all, so the population is watch items only.

**Correction to the finder.** Downgrade the severity argument. The finder calls failing-to-evict 'the deployment side of the restraint line'. Eviction removes items with NO full-gate pass in 48h — items that are not being funded anyway, described in the code's own words as 'dead menu weight'. The funding effect is indirect (a watchlist held at cap by unevictable dead rows blocks scout top-ups), so this is correctness, not money-path. The defect — two live definitions of 'the chart is loaded', one swept and one not — is real either way.

**Proposal — NOT APPLIED.** Route it through the resolver: `DB.watch.filter(w => itemSeries(w.id, S.spark.get(w.id)).pts.length)`, or better through whatever readiness term the mask ends up keyed on (finding 2), so the eviction guard and the bench copy cannot disagree about whether an item was judged. Add an assertion in §96's shape — an archive series and no spark, then assert the item IS in `chartedNow()` — since the function currently has no assertion at all.

---

## 11. [CORRECTNESS] The `no history` bench reads `sp.noData` while every reading comes from the archive — it can bench an item the archive fully evaluated, claiming no history exists

- **Verdict:** UNCERTAIN · **Finder's bite call:** UNCERTAIN · **Scope:** `series-resolver`
- **Failure mode:** Production defect: an operator-visible claim that contradicts the data the same chain just used
- **Assertion:** (no assertion isolates the noData limb against an archive-fed fixture; §96 deletes the spark entirely, so `sp` is undefined and the limb is short-circuited by `!!(sp && sp.noData)`)
- **Condition:** `n/a — §96's fixture does `S.spark.delete(9601)`, making `sp` undefined and the noData limb unreachable for that block`

**Evidence.**

`chk(!!(sp && sp.noData), "no history", "no price history published for this item");` reads the spark record's `noData` flag, set at fetch time by `const rec = { at: Date.now(), pts, vols, lows, byHour, roiHour, series, noData: raw.length === 0 };`. `itemSeries` correctly falls through such a spark — `if (sp && Array.isArray(sp.pts) && sp.pts.length)` is false when pts is empty — and resolves to the archive. So `tr`, `vt`, `mo` and `stw` can all be real readings off 168 archive buckets while this gate benches the item with the sentence "no price history published for this item", which is false of the data the same chain just consumed. It is classified unknowable (`const GATE_UNKNOWABLE = f => f.g === "chart still loading" || f.g === "no history";`) so it does not corrupt the gate-attribution counts, but `failed = fails[0].detail` means it can be the headline bench reason. Direction is conservative (over-restraint, not widening), which is why I rate it below the three above. Reachability requires a spark whose /timeseries returned zero rows for an item the archive nevertheless carries — plausible for a thinly traded item, but I did not confirm the two conditions co-occur in practice.

**Production cited.**

```js
chk(!!(sp && sp.noData), "no history", "no price history published for this item");
```

**Verifier method.** Read index.html: the `no history` and `chart still loading` `chk` lines in order within `candidateFor`'s fails array, `sparkFor` in full (the `raw` slice through the `rec` construction), `itemSeries`'s spark guard, `GATE_UNKNOWABLE`, `chartCacheLoad`'s mid computation. Read tools/probe/probe-snippet.html §96's fixture setup to confirm `S.spark.delete(9601)` short-circuits the limb.

**Verifier says.** The code half is confirmed; the reachability half is not, and the finder is right to hold it there. Confirmed: `chk(!!(sp && sp.noData), "no history", "no price history published for this item");` reads the spark, not `ser`, and it precedes the mask in the `fails` array so it would be `fails[0].detail` and therefore the headline bench. `sparkFor` sets `noData: raw.length === 0` on a record whose `pts` is then `[]`, and `itemSeries`'s guard `if (sp && Array.isArray(sp.pts) && sp.pts.length)` is false on an empty array, so the resolver does fall through to the archive. Confirmed too that §96 cannot see it — the fixture does `S.spark.delete(9601)`, so `sp` is undefined and `!!(sp && sp.noData)` short-circuits on the first conjunct. What I could NOT establish: that the two conditions co-occur. It requires `/timeseries?id=…&timestep=1h` to return `data: []` for an item whose /1h archive rows carry finite `avgHighPrice`/`avgLowPrice` — both endpoints are the same wiki service. The near-miss case resolves the other way: if the archive carries the item with all-NaN mids, `chartPts` returns a non-empty array so `itemSeries` reports src `archive`, but `trendPct` filters to n=0 and returns null, so the item is genuinely unevaluated and the copy is not false. The finding needs the item to be BOTH noData on /timeseries AND finitely printed in the archive, and I have no evidence that happens.

**Correction to the finder.** What would settle it: a probe fixture setting `S.spark.set(id, { at: Date.now(), pts: [], vols: [], byHour: null, noData: true })` with `S.chartCache` ready and carrying ≥24 finite pts for that id, then asserting `candidateFor(w).failed` does NOT contain 'no price history published'. Expected today: it does, while `cd.tr`, `cd.mo.state` and `cd.stw.drifty` are all non-null — which is the contradiction, demonstrated without needing the real API to produce it. Direction is over-restraint, so severity stays low regardless.

**Proposal — NOT APPLIED.** Gate the limb on the resolver's verdict rather than the spark's: bench `no history` only when `ser.src === "none"` AND `sp.noData` — i.e. neither source has anything. Alternatively re-word to name the source honestly ("no /timeseries history for this item") and let the archive-fed reading stand. Either way this needs a fixture with `sp = { pts: [], noData: true }` plus a populated `chartCache`, which no block currently constructs.

---

## 12. [CORRECTNESS] The proven-loser bench's ENTRY CONDITION (net < 0, and n ≥ 3) is unasserted — only its firing and its release are

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `money-path-new-assertions`
- **Failure mode:** one-sided pair (the negative arm tests the RELEASE path, never the not-a-loser path)
- **Assertion:** [R95.2] three net-negative completed flips bench the item as a PROVEN LOSER — measurement outranking the live spread, and asserted for the first time here
- **Condition:** ``loser95.includes("proven-loser bench") && /proven loser/.test(candidateFor(DB.watch[0]).failed || "")``

**Evidence.**

Production `provenLoser` opens `const r = recentNet(id, 3); if (!r || r.net >= 0) return null;` and `recentNet` opens `if (fl.length < n) return null;`. The §95 fixture seeds exactly three flips, all losing (`mkflip(9501, …, 5000, 4000, 10)` — buy above sell). The only negative arm in the whole suite is [R95.3]'s `!fresh95.includes("proven-loser bench")`, and that arm reaches its `return null` through the RE-TEST branch (`tAt > r.lastAt && fresh`), not through the sign or count test. Delete `r.net >= 0` (or lower `recentNet(id, 3)` to `recentNet(id, 1)`) and [R95.2] stays green, [R95.3] stays green — no assertion anywhere pairs three net-POSITIVE flips against an absent bench, or two flips against an absent bench. I grepped both files for `provenLoser` / `recentNet` / `proven-loser`: the only other hits are [R74.x]'s forbidden-identifier list and a core-parity assertion that names the gate, not its condition. Consequence: a restraint that fires on profitable items — capital withheld from lines the log has proven — with nothing to catch it.

**Production cited.**

```js
function provenLoser(id, w){
  const r = recentNet(id, 3);
  if (!r || r.net >= 0) return null;
```

**Verifier method.** Opened index.html and matched `function provenLoser(id, w){`, `const r = recentNet(id, 3);`, `if (!r || r.net >= 0) return null;`, `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`, and recentNet's `if (fl.length < n) return null;`. Opened tools/probe/probe-snippet.html §95 (the block headed `§95 — THE MONEY-PATH GUARDS THAT HAD NO ASSERTION AT ALL`) and read the fixture and all four ok() conditions verbatim. Grepped both files for `proven.loser|provenLoser|recentNet` and read every hit, including the [R74.4] context around `!emitted.has("proven-loser bench")` and the [R74.5b] two-flip waiver fixture at `DB.flips = [ { ... itemId: 9742 ... } ]`. Checked candidateFor's `chk(!!loser, "proven-loser bench", ...)` to confirm the gate is fed only by provenLoser's return.

**Verifier says.** Traced and confirmed at the assertion level. index.html: `function provenLoser(id, w){ const r = recentNet(id, 3); if (!r || r.net >= 0) return null;` and recentNet's `const fl = DB.flips.filter(f => f.itemId === id).sort((a,b) => a.id - b.id); if (fl.length < n) return null;`. The §95 fixture seeds exactly three LOSING flips: `DB.flips = [mkflip(9501, 1e12 + 1, 5000, 4000, 10), mkflip(9501, 1e12 + 2, 5000, 4000, 10), mkflip(9501, 1e12 + 3, 5000, 4000, 10)]` (buy 5000 above sell 4000). Delete `r.net >= 0`, or weaken `recentNet(id, 3)` to `recentNet(id, 1)`, and both §95 assertions stay green by construction: [R95.2]'s `loser95.includes("proven-loser bench")` still holds, and [R95.3]'s only negative arm `!fresh95.includes("proven-loser bench")` reaches `return null` through the re-test branch `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`, not through the sign or the count. I grepped both files for `proven.loser|provenLoser|recentNet`: the complete hit list is line 8346 ([R74.x]'s forbidden-identifier array), 8413 (`!emitted.has("proven-loser bench")` — asserted over `marketGateFails`, which structurally cannot emit that key, so it covers the core's vocabulary and not this gate's condition), and lines 10704/10705/10713/10714, all inside §95. No assertion anywhere pairs a net-POSITIVE three-flip history, or a sub-three history, against absence of the bench. This is the limb with the consequence: a restraint that fires on profitable items withholds capital from lines the log has proven, and nothing names it.

**Correction to the finder.** One honest limit on the claim, which I could not settle under the freeze: deleting `r.net >= 0` would bench EVERY item with ≥3 flips, and §25's fixture (`DB.flips = [0, 1, 2].map(k => ({ ... itemId: 9001, buy: 5100, sell: 5450 ... }))` on a watched, rendered item) could go red as collateral. That would be propagation, not proof — an unrelated assertion failing for a reason its label does not name. The coverage gap for the property itself stands.

**Proposal — NOT APPLIED.** Add the missing arm to the same fixture — it already has `mkflip` and costs three lines: flip the fixture's buy/sell to make the three trips net-positive and assert `!gates95().includes("proven-loser bench")`, and a second arm with only two losing flips. Both are discriminating against the current code; would need a seed on `r.net >= 0` to prove the first bites.

---

## 13. [CORRECTNESS] [R98.5] claims the fixture 'cleans BOTH ends' — four persisted stores that buildPlan() writes are never snapshotted or restored, and save() persists them to a probe profile the snippet itself says survives across runs

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `money-path-new-assertions`
- **Failure mode:** label overclaims (a universal about 'the shared fixture' and 'the caches' exercised against 3 of 15 id×cache combinations and 0 of 4 leaked DB stores)
- **Assertion:** [R98.5] the shared fixture cleans BOTH ends — S.items returns to its original length and no 98xx id survives in the caches, so the next block cannot read probe items as production data
- **Condition:** ``S.items.length === k98.itemsLen && !S.byId.has(9801) && !S.byId.has(9803) && S.latest[9802] === undefined``

**Evidence.**

§98 calls `buildPlan()` four times (famPlan, floorPlan, once inside [R98.2]'s condition, once more inside its eagerly-evaluated evidence string). buildPlan's tail block writes stores the k98 snapshot does not contain: `if (!DB.obsDays.includes(dToday)){ DB.obsDays.push(dToday); logDirty = true; }`, `DB.gateLog.push(gateLogRow(dToday, b, g, v))` (the family-overlap bench falls through `gateName`'s chain to "plan gate", so a row lands with `id: 9801` or `9802`), `DB.gateLog.push(gateLogRow(dToday, p, "funded", null))` for 9803, `DB.dieOffLog.push(...)` on the die-off path, `fillGateSoftLog()` → `logDecision(...)` into DB.decisionLog, `S.lastPlanPicks = picks.map(p => p.id)` (which feeds the rdiff ledger), and then `save()`. k98 is `{ watch, qual, clusters, positions, invLots, anom, intel, flips, t1B, t2B, bank, bankAsOf, slots, minExp, stamp, itemsLen, shReserve, reserve }` — none of gateLog / obsDays / dieOffLog / decisionLog / lastPlanPicks. The snippet's own line 66 comment states 'the probe profile's localStorage persists across runs', and run.sh does `mkdir -p "$OUT/edge-profile"` with no rm, so save() carries probe rows forward. DB.gateLog is the ledger `daysBenchedBy(id, gate, 7)` reads to drive gate-persistence proposals — the 4-of-7 bar that moves gate constants. The condition also checks S.byId for 9801 and 9803 but not 9802, S.latest for 9802 only, and never touches S.spark, S.hour or S.min5 for any id — remove `delete S.min5[id]` from the restore loop and the assertion stays green, while `calc()` reads S.min5 for `vol5` on the very next block. REQUIREMENTS R98.5 repeats the claim in stronger form: 'every store is restored **by value** rather than by key-delete so a pre-existing row cannot be half-removed' — the restore two lines above the assertion is `for (const id of [9801, 9802, 9803]){ S.byId.delete(id); S.spark.delete(id); delete S.latest[id]; delete S.hour[id]; delete S.min5[id]; }`, which is key-delete on five caches with no snapshot of any of them.

**Production cited.**

```js
if (!DB.obsDays.includes(dToday)){ DB.obsDays.push(dToday); logDirty = true; }
      ...
      if (!have.has(k)){ DB.gateLog.push(gateLogRow(dToday, b, g, v)); have.add(k); logDirty = true; }
      ...
    if (logDirty){ ... save();
```

**Verifier method.** Read index.html's buildPlan tail (the block commented `Gate-health ledger: one row per item·gate·day`) line by line through `if (logDirty){ ... save(); }`, and `S.lastPlanPicks = picks.map(p => p.id);`. Read tools/probe/probe-snippet.html §98 in full: the k98 literal, mk98, reset98, all four buildPlan invocations, the restore block `S.items.length = k98.itemsLen; for (const id of [9801, 9802, 9803]){ S.byId.delete(id); S.spark.delete(id); delete S.latest[id]; delete S.hour[id]; delete S.min5[id]; }`, and [R98.5]'s condition. Read REQUIREMENTS.md row R98.5. Read tools/probe/run.sh lines 1-50 for the profile handling and `--host-resolver-rules="MAP * ~NOTFOUND"`.

**Verifier says.** The mechanism is real. buildPlan()'s tail block writes `if (!DB.obsDays.includes(dToday)){ DB.obsDays.push(dToday); logDirty = true; }`, `DB.gateLog.push(gateLogRow(dToday, b, g, v))` for every bench row, `DB.gateLog.push(gateLogRow(dToday, p, "funded", null))` for every pick, `DB.dieOffLog.push({...})`, and closes with `if (logDirty){ ... save(); }`. §98 calls buildPlan() four times (famPlan, floorPlan, and twice more inside [R98.2]'s condition and evidence string) with 9801/9802/9803 on DB.watch, so 98xx rows land in DB.gateLog and today lands in DB.obsDays. k98 is `{ watch, qual, clusters, positions, invLots, anom, intel, flips, t1B, t2B, bank, bankAsOf, slots, minExp, stamp, itemsLen, shReserve, reserve }` — none of gateLog, obsDays, dieOffLog, decisionLog. The persistence half checks out too: run.sh does `mkdir -p "$OUT/edge-profile"` with no removal, and the snippet's own comment reads "the probe profile's localStorage persists across runs". The assertion's coverage is as narrow as claimed: `!S.byId.has(9801) && !S.byId.has(9803) && S.latest[9802] === undefined` against a restore loop that touches five caches for three ids — S.byId for 9802, S.spark, S.hour and S.min5 for all three are unchecked, so deleting `delete S.min5[id]` leaves it green.

**Correction to the finder.** Severity must come down from 'correctness' to hygiene, on two grounds I verified. (a) The leak is confined to the probe's own edge-profile localStorage; DB.gateLog there is not the user's ledger, so nothing production reads it and daysBenchedBy() is never consulted on those rows outside the suite. (b) This is not new to §98 and not a claim §98 uniquely broke: no block in the suite restores gateLog around buildPlan — `grep -n gateLog` shows ~a dozen blocks that simply assign `DB.gateLog = []` wholesale, and the block at line 332 asserts buildPlan writes it. What is genuinely wrong is narrower than the title: the block comment's enumeration ("This writes DB.watch, DB.qual, DB.clusters, DB.positions, DB.invLots, DB.anomalyFlags, DB.intel, the budgets and the S.* item caches; all are snapshotted and restored") is incomplete, and REQUIREMENTS R98.5's "every store is restored **by value** rather than by key-delete" is false of the five S.* caches, which have no snapshot at all. The assertion itself bites for what it names — remove `S.byId.delete(9801)` and it goes red.

**Proposal — NOT APPLIED.** Two separable repairs. (1) Extend k98 to snapshot DB.gateLog / DB.obsDays / DB.dieOffLog / DB.decisionLog / S.lastPlanPicks and restore them by value, then extend the [R98.5] condition to assert no 98xx id survives in DB.gateLog — that is the one leak with a downstream reader that changes gate constants. (2) Either make the cache restore value-based (snapshot each of the five caches per id and set-or-delete, the shape §95 uses for S.byId and §91 uses for kIt91), or correct R98.5's wording — as it stands the requirement row asserts a property the code does not have. Note this is inert TODAY inside a single run (§98 is the last block) and inert against real user data (the probe universe is entirely synthetic 9xxx ids; no /mapping fetch reaches the network under --host-resolver-rules), which is exactly why it reads green.

---

## 14. [CORRECTNESS] [R89.2]'s survival assertion is a tautology, and its fixture never reaches a single line the label names

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `pool-branch-and-ops`
- **Failure mode:** tautology (failure mode 1) compounded by fixture prevents expression (failure mode 2)
- **Assertion:** [R89.2] and candidateFor SURVIVES a synthesised row — it produces a real candidate with a verdict, so every operator overlay reads absent rather than throwing on a row that has no fields
- **Condition:** `poolCands.every(c => c && c.id > 0 && typeof c.name === "string") && poolCands.every(c => Object.prototype.hasOwnProperty.call(c, "failed") || c.score != null)`

**Evidence.**

Every conjunct is guaranteed. `hasOwnProperty(c, "failed")` is true for EVERY object `candidateFor` can return — the early return has `failed:` literally, and the full-chain return is `{ id:w.id, name:c.name, …, failed, fails, … }` where `failed` is a shorthand property always present (possibly null). `typeof c.name === "string"` is guaranteed by `const itemName = (id, fallback) => (S.byId.get(id) || {}).n || fallback || ("item " + id);`. `c.id > 0` is the fixture's own ids, already asserted one line above by [R89.1]'s `poolCands.map(c => c.id).sort(…).join(",") === "9202,9203"`. Worse, the fixture cannot reach the property: the §87/§89 block sets `DB.watch = [{ id: 9201, name: "Pinned item" }]` and `S.scorerCtlPass = [9201, 9202, 9203]`, and grep confirms NO `S.byId.set` / `S.latest` / `S.hour` entry for 9201/9202/9203 anywhere in the probe (the base fixture builds only 9001/9002/9003). So `calc(9202)` hits `const meta = S.byId.get(id); if (!meta) return null;` and every synthesised candidate takes the three-line early return. Not one of the overlay reads the label names executes: `planQty(w, c)` → `opsOf(w.id).qty`, `provenLoser(w.id, w)` → `(w && w.tAt)`, `itemTier(w.id, c)`, `familyKey(c.name)` are all downstream of `calc` returning non-null. Change any of them to dereference a missing field on a bare `{id}` row and this assertion stays green. Honest counterweight, stated because it bounds the consequence: §95 runs the FULL chain on `DB.watch = [{ id: 9501, qty: null }]` with prices present, which is one key away from a synthesised row, so an outright throw would likely surface there — but by accident, under a label about the blacklist bench, and §95's row still is not the `{ id }`-only shape the pool actually produces.

**Production cited.**

```js
candidateFor: `const c = calc(w.id); if (!c || c.buy == null || c.sell == null) return { id:w.id, name: itemName(w.id), failed:"no live price in /latest" };`
```

**Verifier method.** Read index.html 3004-3014 (calc's byId guard), 5320-5330 (early return), 5488-5500 (full return with `failed,` shorthand), 1777 (itemName), 5869-5893 (cutoverPoolRows, planCandidates, markSrc). Read tools/probe/probe-snippet.html 10172-10214 (the whole §89 block) and 10662-10735 (§95 fixture). Ran grep -n '920[0-9]' over the probe — 7 hits, zero market-data writes.

**Verifier says.** Both failure modes traced and true.

TAUTOLOGY. `candidateFor` has exactly two return shapes. The early return at index.html:5323 is `return { id:w.id, name: itemName(w.id), failed:"no live price in /latest" };` — `failed` present as a literal. The full return at index.html:5488 is `return { id:w.id, name:c.name, c, qty, tr, vt, …, failed, fails, eMargin, …}` — `failed` as an ES6 shorthand, so the key always exists whatever its value. Therefore `Object.prototype.hasOwnProperty.call(c, "failed")` is TRUE for every object the function can return, and the `|| c.score != null` disjunct never has to be evaluated. `typeof c.name === "string"` is pinned by `const itemName = (id, fallback) => (S.byId.get(id) || {}).n || fallback || ("item " + id);` at index.html:1777 — the `("item " + id)` tail makes a string unconditional. `c.id > 0` is the fixture's own ids and is already asserted one line above by [R89.1]'s `poolCands.map(c => c.id).sort(…).join(",") === "9202,9203"`.

FIXTURE PREVENTS EXPRESSION. `grep -n '920[0-9]' tools/probe/probe-snippet.html` returns 7 hits and every one is either `DB.watch = [{ id: 9201, name: "Pinned item" }]`, `S.scorerCtlPass = [9201, 9202, 9203]`, or an id string inside an assertion condition. There is NO `S.byId.set`, no `S.latest[9202]`, no `S.hour[9202]` anywhere in the file for 9201/9202/9203. `function calc(id)` opens `const meta = S.byId.get(id); if (!meta) return null;` (index.html:3004-3005), so `calc(9202)` returns null and `candidateFor` takes the three-line early return. `planQty(w, c)`, the `opsOf` read-through, `provenLoser`, `itemTier` and `familyKey(c.name)` are all below that return and none of them executes. The label's claim — "every operator overlay reads absent rather than throwing on a row that has no fields" — names code the fixture cannot reach.

COUNTERWEIGHT VERIFIED AND CORRECTLY BOUNDED. §95 does run the full chain on a one-key-plus-null row: `mk95(9501, "Probe ninefive", 4000, 4400)` sets byId/latest/hour/spark, then `DB.watch = [{ id: 9501, qty: null }]`. So an outright throw on a nearly-bare row would surface — but under [R95.1]'s blacklist label, and on a row that still is not the `{ id }`-only shape `cutoverPoolRows` produces (`return ids.filter(id => !held.has(id)).map(id => ({ id }));`, index.html:5872).

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Give 9202/9203 real price data in the §87/§89 fixture (the `mk95` helper in §95 is the pattern) so the synthesised rows drive the whole gate chain, then assert the properties the label actually claims and that only a bare row can produce: `opsOf(9202).row === null`, `planQty({id:9202}, calc(9202)).auto === true` (no manual size), `opsOf(9202).tierOv === null`, `candidateFor({id:9202}).tier` computed with no override, and `fails` non-empty with a real gate key rather than `"no live price in /latest"`. Drop the `hasOwnProperty("failed")` conjunct entirely — it cannot fail. If the intent is genuinely 'does not throw', say so and wrap in try/catch with the catch asserted, because 'has a `failed` key' is not that claim.

---

## 15. [CORRECTNESS] `opsPick`'s `!= null` cannot express a CLEARED override — the third state the rest of §93 is built around

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `pool-branch-and-ops`
- **Failure mode:** third-state collision (absent and cleared are indistinguishable, and cleared falls through)
- **Assertion:** [R93.2] the read-through takes the store first and the row second — which is what makes the migration a COPY: an interrupted migration still answers from the row, so behaviour never depends on how far it got
- **Condition:** `through({ tierOv: 2 }, { tierOv: 1, qty: 7 }).tierOv === 2 && through({ tierOv: 2 }, { tierOv: 1, qty: 7 }).qty === 7 && through(null, { tierOv: 1 }).tierOv === 1 && through({}, {}).tierOv === null`

**Evidence.**

The tier button's third press writes `tierOv: null` into the store, meaning 'the operator cleared this'. `opsPick` treats `null` identically to absent and falls through to the watch row. Today that is inert twice over: `poolControlsHTML` returns `""` unless `x.src === QUAL_SRC_POOL`, and a pool item has no watch row, so the fallback finds nothing and the clear takes correctly. But `itemOpsMigrate` copies EVERY watch row's `tierOv` into `DB.itemOps`, so once `ITEM_OPS` arms, tenured items have BOTH a store row and a watch row carrying the same value — and the moment any control is offered on a tenured line (or a pool item is later pinned), 'clear' will silently not take: the row answers. This is the same absent-is-a-third-state discipline that [R87.2] and [R93.3] enforce elsewhere in the same build, missing from the one term both of them route through. I did not seed this; it is read from the code and I state it as a reachability argument, not a demonstrated failure.

**Production cited.**

```js
`const opsPick = (o, w, k) => (o && o[k] != null) ? o[k] : (w && w[k] != null ? w[k] : null);` — and the control handler: `const next = cur == null ? 1 : cur === 1 ? 2 : null; opsSet(id, { tierOv: next });`
```

**Verifier method.** Read index.html 5595-5615 (opsTierOv, tierBandsSame, opsPick), 5615-5638 (opsOf), 5642-5653 (opsSet's Object.assign and the `patch.tierOv != null` bands guard), 5586 (ITEM_OPS pin), 5684-5704 (itemOpsMigrate), 14726-14740 (poolControlsHTML guard), 19178-19190 (the pool tier handler), 23321-23330 (the legacy watch-row handler using `delete`), 5869-5873 (cutoverPoolRows held-set). Read tools/probe/probe-snippet.html 10490-10505 ([R93.2] `through` fixtures) and 10578-10596 ([R93.7]). Ran grep -n 'opsSet(' (4 call sites) and grep -n 'tierOv *=' (3 hits).

**Verifier says.** The code reading is exactly right, and I found a sharper piece of evidence than the finder cited. But the reachability claim needs one correction, so the severity is latent rather than armed-day.

THE MECHANISM, CONFIRMED VERBATIM. `const opsPick = (o, w, k) => (o && o[k] != null) ? o[k] : (w && w[k] != null ? w[k] : null);` (index.html:5614). The pool handler at index.html:19184-19185 is `const next = cur == null ? 1 : cur === 1 ? 2 : null; opsSet(id, { tierOv: next });`. `opsSet` does `Object.assign(r, patch)` — it STORES `tierOv: null` rather than deleting the key (and its `bands` stamp is guarded `patch.tierOv != null`, so a clear leaves no stamp either). `opsPick`'s `o[k] != null` is then false and control falls through to `w[k]`. Absent and cleared are indistinguishable, and cleared loses.

STRONGER EVIDENCE THE FINDER MISSED: the sibling writer for the SAME concept does it correctly. The legacy watch-row tier control at index.html:23327-23328 is `const next = w.tierOv == null ? 1 : w.tierOv === 1 ? 2 : w.tierOv === 2 ? 0 : null; if (next == null) delete w.tierOv; else w.tierOv = next;` — it physically removes the key. So this is not a style preference; it is two writers of one field disagreeing on how "cleared" is represented, and only the new one is unreadable through `opsPick`.

INERT TODAY, CONFIRMED THREE WAYS: `const ITEM_OPS = false;   // pinned by [R93.1]` (index.html:5586); `poolControlsHTML(x, armed)` opens `if (!armed || !x || x.src !== QUAL_SRC_POOL) return "";` (index.html:14727); and `cutoverPoolRows` excludes held ids (`const held = new Set(DB.watch.map(w => w.id)); return ids.filter(id => !held.has(id))…`), so a pool-provenance candidate never has a watch row for the fallback to find.

UNCOVERED, CONFIRMED: [R93.2] exercises `opsPick` only through `through({}, {}).tierOv === null` — an EMPTY store object, not one carrying an explicit `tierOv: null`. Adding `through({ tierOv: null }, { tierOv: 1 }).tierOv === null` is the assertion that would bite; today nothing does.

**Correction to the finder.** The finder's stated trigger — "the moment any control is offered on a tenured line" — overstates how close this is. `poolControlsHTML` already refuses tenured lines by construction, and [R93.7] asserts that refusal ("a TENURED item gets neither, because it still has its watch row and two writers for one field is the two-owners defect"). And a pool item that is later pinned acquires `src === QUAL_SRC_WATCH` from `planCandidates`, so its control disappears rather than misbehaving. Expressing the defect therefore requires a FUTURE surface change, not merely arming ITEM_OPS. It is a latent third-state collision with no live consequence — real, worth fixing at the term, but not a defect that arms with the flag.

**Proposal — NOT APPLIED.** Decide what `null` in the store means and record it, the way `src` and `bands` were: either use a sentinel (`tierOv: 0` or an explicit `cleared: 1`) so cleared is distinguishable from absent, or make `opsPick` fall through only on `undefined` (`Object.prototype.hasOwnProperty.call(o, k) ? o[k] : …`) and let `null` mean cleared. Then extend [R93.2] with the fourth case it is missing — `through({ tierOv: null }, { tierOv: 1 })` — which is the only case that discriminates the two designs and which the current four conjuncts do not reach.

---

## 16. [CORRECTNESS] huntSiblings' `calm` rewrite silently moved the drift threshold from ratio ≤ 2 to ratio ≤ 1, and closed the microstructure ring entirely for any candidate without 24 points — neither change is stated or asserted

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** unstated behaviour change + coverage gap in the changed band
- **Assertion:** [R97.1] sibling admission's ONE volatility restraint is real: a STEADY candidate is admitted through the microstructure ring and a DRIFTY one is refused — the fixture proves the ring can admit before it proves calm can stop it
- **Condition:** ``admSteady === true && admDrifty === false` with `steadyPts = 1000 + (i % 2 ? 2 : 0)` (median step 2 → daily 48) and `driftyPts = 1000 + (i % 2 ? 20 : 0)` (median step 20 → daily 480), against a fixture margin of roughly 127.`

**Evidence.**

Three behaviour changes rode this line; the production comment names only one. (1) UNKNOWN no longer passes — named, ruled, and asserted by [R97.1]'s second stanza. (2) THE BAND MOVED. Old calm accepted `r.ratio <= 2`. New calm requires `drifty === false`, which stabilityWeight returns only for `r.ratio <= 1`. An item whose typical daily wander is 100–200% of its margin was calm and is now not. The comment says only "Now it reads the resolver and the one honest term", which reads as a same-threshold swap. (3) THE RING CLOSED. Old code short-circuited `!sp ? true`; new code resolves through `itemSeries`, and `chartPts = id => (chartReady() && S.chartCache.pts.get(id)) || []` returns [] until the h1 archive matures, so for every sibling candidate without its own spark the points array is empty, `sitRisk` returns null on `pts.length < 24`, `drifty` is null, and `calm` is false. `microHit` requires `&& calm`, so ring 1 admits nothing at all for that population — the exact mirror of the inert restraint being fixed. The comment's own diagnosis ("the populations were disjoint by construction") says that population is most of the candidate set. Nothing renders it: line 15230 shows `<b>N</b> siblings watched · graduated · washed` and 16300 shows `No sibling watchers live.` — a count with no state, which is the never-fed-aggregate shape (scan 2(b), a generator that stopped). [R7.3] on [R97.1]: seed the OLD form back into production and `admUnknown` goes red (the fixture's null case), so the unknown half is genuinely proven. But `admSteady` (ratio ≈ 0.38) and `admDrifty` (ratio ≈ 3.78) both sit outside 1 < ratio ≤ 2, so the one region where old and new actually disagree for a spark-bearing item is untested — restoring `r.ratio <= 2` as the pass band would leave both stanzas green.

**Production cited.**

```js
OLD: `const calm = !sp ? true : (() => { const r = sitRisk(sp, Math.max(1, c.margin)); return !r || r.ratio <= 2; })();`  NEW: `const calm = stabilityWeight(itemSeries(it.i, sp).pts, Math.max(1, c.margin)).drifty === false;`  and in stabilityWeight: `if (r.ratio <= 1) return { w: 1, r, drifty: false, why: null };` / `return { w: r.ratio <= 2 ? 0.85 : 0.7, r, drifty: true, … };`
```

**Verifier method.** Read index.html 5255–5300 (sitRisk, stabilityWeight, all three drifty branches), 14404–14470 (huntSiblings' candidate loop, the calm line, microHit's conjuncts), 5210–5252 (itemSeries), 3925–3940 (chartReady/chartPts/chartVols), 3004–3035 (calc's margin), 1213–1218 (geTax). Ran `git diff -U2 index.html | grep sitRisk|calm` to recover the pre-change line verbatim. Read probe-snippet.html 10800–10886 (§97 fixture, mk97, runHunt, both [R97.1] stanzas) and grepped REQUIREMENTS.md/HANDOFF.md/MISTAKES.md for the band.

**Verifier says.** The band move is confirmed by diff and by arithmetic. `git diff -U2 index.html` shows the removed line verbatim: `-    const calm = !sp ? true : (() => { const r = sitRisk(sp, Math.max(1, c.margin)); return !r || r.ratio <= 2; })();` against the new `const calm = stabilityWeight(itemSeries(it.i, sp).pts, Math.max(1, c.margin)).drifty === false;`. In `stabilityWeight`, `drifty: false` is returned on exactly two branches — `if (r.ratio <= 0.5)` and `if (r.ratio <= 1)` — and `return { w: r.ratio <= 2 ? 0.85 : 0.7, r, drifty: true, … }` covers everything above 1. So the pass band moved from ratio ≤ 2 to ratio ≤ 1. Neither the production comment (which says only 'Now it reads the resolver and the one honest term' and 'UNKNOWN DOES NOT SATISFY the ring') nor REQUIREMENTS.md R97.1/R97.2 states it. The untested-region claim also holds: `calc()` gives margin = 1150 − 1000 − Math.floor(1150·TAX_RATE) = 127; steadyPts median step 2 → daily 48 → ratio 0.378; driftyPts median step 20 → daily 480 → ratio 3.78. Both sit outside (1, 2], so restoring `r.ratio <= 2` as the pass band leaves `admSteady === true && admDrifty === false` green and leaves the unknown stanza green too. The ring-closure mechanism is also confirmed: `chartPts = id => (chartReady() && S.chartCache.pts.get(id)) || []` returns [] while chartReady() is false, `itemSeries` then returns `{ pts: [], src: "none" }`, `sitRisk` returns null on `pts.length < 24`, `drifty` is null, `calm` is false, and `microHit` ends `&& calm`.

**Correction to the finder.** Two corrections to the finder's framing, both of which cut against the title's 'neither change is stated'. (1) The RING CLOSURE is not an unstated change — it is the direct and explicitly ruled consequence of the stated one: the production comment says 'UNKNOWN DOES NOT SATISFY the ring: an override on unknown widens what reaches the watchlist, so the conservative reading is the ruled one', and the second [R97.1] stanza asserts it (`admUnknown === false`). What is genuinely unrendered is the resulting INERTNESS — the discovery scoreboard prints `<b>N</b> siblings watched · graduated · washed` and the audit prints 'No sibling watchers live.', neither of which distinguishes 'ring 1 admitted nothing' from 'ring 1 found nothing', which is scan 2(b)'s stalled-generator shape. (2) The band move tightens admission (fewer candidates admitted), so it is restraint, not deployment — it does not cross the constitutional line the finder's 'money-path' instinct would imply, and siblings reach only the watchlist, where 'funding still passes every gate'. The confirmed defect is therefore: an unstated numeric threshold change with no assertion in the 1 < ratio ≤ 2 region where old and new disagree.

**Proposal — NOT APPLIED.** Two separable asks, both read-only until ruled. (a) Say whether the band move from ratio ≤ 2 to ratio ≤ 1 was intended; it is a strategy-parameter move in the restraint direction (so it may auto-arm) but it is not what the comment claims to have changed, and the claims-vs-computation scan reads comments as copy. (b) Add a third [R97.1] case at ratio ≈ 1.5 pinning whichever band is ruled — that is the only case that discriminates the two forms — and give the sibling panel a stated state for "ring 1 admitted nothing because drift is unreadable on N of N candidates", so the closed generator is not indistinguishable from a quiet market.

---

## 17. [CORRECTNESS] The `no history` gate still reads the spark directly, so the "one resolved series" promise is not kept by the two gates that decide whether the chart is usable — and [R96.1]'s fixture cannot see it

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** seam / fixture prevents expression
- **Assertion:** [R96.1] with an ARCHIVE series and NO spark — the post-transition state of a pool item — EVERY chart-derived reading on the live chain is FED, so no consumer can be left behind while its neighbours are wired
- **Condition:** ``cd96 && cd96.mo && cd96.mo.state !== null && cd96.stw && cd96.stw.drifty !== null && cd96.tr !== null`, run after `S.spark.delete(9601);  // NO spark — the pool item's state``

**Evidence.**

`noData` is set at the /timeseries writer as `noData: raw.length === 0`. Once `chartReady()` is true, an item whose own /timeseries came back empty — a genuinely history-less item, or one whose fetch hit a transient miss, since the flag is cached — resolves through `itemSeries` to `src: "archive"` and computes tr, vt, momentum and drift from real points, and is then benched anyway on `"no price history published for this item"`. The claim is false of that item: the archive has its history. The resolver covers four of the six chart-derived readings on the chain; the two that decide admission were not swept. [R7.3] on [R96.1]: its fixture calls `S.spark.delete(9601)`, so `sp` is undefined and `sp && sp.noData` is falsy — the assertion runs on real production code and passes, and would still pass with the noData limb wired to anything at all. Its label is honest ("and NO spark"), so this is a coverage gap rather than an overclaim, but the block's stated purpose — "A consumer left on `sp` returns its no-data value while its neighbours return real ones, and this goes red naming which one" — is exactly the property it cannot see. Latent today: `chartReady()` is false until the h1 archive matures (the constitution's fourth cutover prerequisite, 7 of 7 observed days), so nothing benches on this yet.

**Production cited.**

```js
index.html, candidateFor: `const ser = itemSeries(w.id, sp);` … `chk(!!(sp && sp.noData), "no history", "no price history published for this item");` and `chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading");` — with the resolver's own comment claiming "tr, vt, momentum and drift all read `ser`, so the chart-ready transition cannot feed one and starve another".
```

**Verifier method.** Read index.html 5320–5360 (candidateFor's sp/ser/tr/vt/mo/stw resolution and the resolver comment), 5405–5420 (both history chks), 2805–2825 (the spark writer and `noData: raw.length === 0`), 5210–5252 (itemSeries), 3925–3940 (chartReady/chartPts), 1189 (SPARK_TTL). Read probe-snippet.html 10737–10805 (§96 in full: the fixture, both [R96.1] stanzas, both [R96.2] stanzas).

**Verifier says.** The mechanism and the fixture blindness are both confirmed. Production `candidateFor` reads `const sp = S.spark.get(w.id);` then `const ser = itemSeries(w.id, sp);`, and the two admission gates read `sp` directly: `chk(!!(sp && sp.noData), "no history", "no price history published for this item");` and `chk(!(sp && sp.noData) && tr == null, "chart still loading", …)`. `noData` is written at the /timeseries writer as `noData: raw.length === 0`. So once `chartReady()` flips, an item whose own /timeseries came back empty but which has archive coverage resolves through `itemSeries` to `src: "archive"`, computes tr, vt, momentum and drift from real points — and is benched anyway on 'no price history published for this item', a claim the archive falsifies. [R96.1]'s fixture calls `S.spark.delete(9601);  // NO spark — the pool item's state`, so `sp` is undefined and `sp && sp.noData` is falsy; the assertion's condition `cd96.mo.state !== null && cd96.stw.drifty !== null && cd96.tr !== null` runs on real production code and would pass with the noData limb wired to anything. Its label is honest ('and NO spark'), so this is a coverage gap and not a label overclaim.

**Correction to the finder.** The finding's TITLE overclaims. The resolver's comment does not promise that the gates read `ser` — it says exactly 'tr, vt, momentum and drift all read `ser`, so the chart-ready transition cannot feed one and starve another', and that sentence is literally true of all four. So this is not a broken promise; it is an unswept adjacent surface. Two further narrowings: `SPARK_TTL = 30 * 60e3`, so a transient empty fetch is cached for at most 30 minutes, bounding the accidental case; and the whole thing is latent — `chartReady()` is false until the h1 archive matures, which the constitution names as the fourth cutover prerequisite (7 of 7 observed days), so nothing benches on this today.

**Proposal — NOT APPLIED.** Decide which reading owns "this item has no history" once the archive is a source — most likely `ser.src === "none"` rather than `sp.noData`, since the resolver is now the authority on whether a series exists — and extend the [R96.1] fixture with a third case: a spark carrying `noData: true` alongside a populated archive, asserting the chain does NOT bench on "no history". Seed by leaving the current limb in place; it should go red.

---

## 18. [CORRECTNESS] A pruned migrated item-ops row does not lose its value — it resurrects from the watch row, while the prune's warning tells the operator to re-set it

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** seam between a prune and a read-through fallback; latent behind ITEM_OPS === false
- **Assertion:** none — `itemOpsPrune` has no assertion; §93's ten assertions cover the flag, the pick, the bands partition, the migration, the writer and the carry
- **Condition:** `n/a`

**Evidence.**

The migration is a copy and the read-through falls back to the row, which is the property [R93.2] correctly asserts (`through(null, { tierOv: 1 }).tierOv === 1`). Compose that with the prune and the promise inverts: deleting a `src: "migrated"` row does not remove the value, it hands the read back to `w.tierOv` / `w.qty`, which are still there. The warning then makes a claim that is false for exactly those rows — nothing was lost, and re-setting is a no-op. The reachability is worse than incidental: `itemOpsMigrate` stamps `setAt: w.tAt || w.addedAt || Date.now()`, so a watch row added more than 90 days ago migrates already past `ITEM_OPS_RET_MS` and is pruned on the first `opsSet` call, while `DB.itemOpsV1 = 1` prevents the migration ever re-running. The probe touched the edge of this without asserting it — [R93.5] calls `opsSet(930010, { tierOv: 1 })` on a row stamped `setAt === 111`, which survives only because opsSet writes `r.setAt = Date.now()` before calling the prune, and the block ends with a bare `clearWarn("item-ops")`. Latent today: `const ITEM_OPS = false` and [R93.7] asserts the pool controls render nothing while it is off, so `opsSet` — the only caller of `itemOpsPrune` — is unreachable in production. It arms on the flag flip, which is a ruling.

**Production cited.**

```js
`for (const id of Object.keys(s)) if (now - (s[id].setAt || 0) > ITEM_OPS_RET_MS){ delete s[id]; dropped++; }` … `warn("item-ops", "⚠ " + dropped + " operator-state row… Each was a tested pair, a manual size or a TIER OVERRIDE you set by hand — re-set any you still want. This is a storage bound; an override does not expire.")` — against `const opsPick = (o, w, k) => (o && o[k] != null) ? o[k] : (w && w[k] != null ? w[k] : null);` and itemOpsMigrate's own comment: "WHAT HAPPENS TO THE WATCH-ROW ORIGINALS: they STAY, untouched".
```

**Verifier method.** Read index.html 5586–5720 in full (ITEM_OPS, ITEM_OPS_RET_MS, opsTierOv, tierBandsSame, opsPick, opsOf, opsSet, itemOpsPrune, itemOpsMigrate), 1386 (`try { itemOpsMigrate(); }` in load()), 14725–14745 (poolControlsHTML with `if (!armed || …) return ""`), 7516 (`poolControlsHTML(p, ITEM_OPS)`), 7360–7370 and 19170–19205 (all three opsSet call sites). Grepped both files for opsSet/itemOpsPrune/opsPick/ITEM_OPS.

**Verifier says.** Every link in the chain is in the file. `itemOpsMigrate` stamps `const r = { src: "migrated", setAt: w.tAt || w.addedAt || Date.now() };` and its comment states 'WHAT HAPPENS TO THE WATCH-ROW ORIGINALS: they STAY, untouched'. `itemOpsPrune` deletes on `if (now - (s[id].setAt || 0) > ITEM_OPS_RET_MS)` with `ITEM_OPS_RET_MS = 90 * 86400e3`. `opsOf` then falls back: `const opsPick = (o, w, k) => (o && o[k] != null) ? o[k] : (w && w[k] != null ? w[k] : null);` with `o = ITEM_OPS ? ((DB.itemOps||{})[id] || null) : null`. So deleting a migrated row hands the read straight back to `w.tierOv`/`w.qty` — the value survives — while the warning says 'Each was a tested pair, a manual size or a TIER OVERRIDE you set by hand — re-set any you still want', which is false for exactly those rows. The reachability arithmetic is correct too: a watch row whose `tAt`/`addedAt` predates 90 days migrates already past retention and is pruned on the first `opsSet`, and `DB.itemOpsV1 = 1` prevents the migration re-running. No assertion covers `itemOpsPrune` — grep of the probe finds only `opsSet(930010, { tierOv: 1 });` at line 10551, and that row survives because `opsSet` writes `r.setAt = Date.now();` BEFORE calling `itemOpsPrune()`.

**Correction to the finder.** Inert today, and more thoroughly than the finder states. All three `opsSet` call sites are gated: `if (ITEM_OPS) opsSet(x.id, { t2Grad: 1 }); else { w.t2Grad = 1; save(); }`, and the two UI handlers fire only on `[data-poolov]`/`[data-pooltest]`, which `poolControlsHTML(x, armed)` refuses to emit while `armed` is `ITEM_OPS === false`. So `itemOpsPrune` has no reachable caller in production; the defect arms on the flag flip, which is a ruling. Severity is therefore a latent copy-claim defect (the warning makes a false loss claim) plus a prune/read-through seam, not a live one — and the value is never actually lost, which makes this the mildest possible form of the failure.

**Proposal — NOT APPLIED.** Raise it as a delta for the stage that flips ITEM_OPS, not now. Either the prune deletes the watch-row original too (making it a real loss and the copy true), or the warning distinguishes `src: "migrated"` rows — "still in force from the watch row" — from operator-set rows, which are the only ones a prune actually loses. Either way it needs an assertion at the composition, since §93 asserts prune and fallback on opposite sides of the seam and neither can see the join.

---

## 19. [DISPLAY] Five display readers still on the spark — the row can show "chart loading" and no FALLING chip while the gate chain benches the same item for a falling chart

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `series-resolver`
- **Failure mode:** Production defect: the repair swept the gate chain and left the surface the operator rules from
- **Assertion:** (no assertion compares the row's rendered trend against the chain's `tr`)
- **Condition:** `n/a`

**Evidence.**

Enumerating every chart-derived reader that bypasses `itemSeries` (the direct answer to (a)): `rowRiskFlags` — `const tr = sp ? trendPct(sp.pts) : null;` driving the FALLING risk chip and its filter key; `renderWatch`'s sort map — `limit: c.limit, trend: sp ? trendPct(sp.pts) : null`; `renderWatch`'s row — `const tr = sp ? trendPct(sp.pts) : null;` and the sparkline `'<td class="sec">'+(sp ? sparkSVG(sp.pts) : '<span class="dim">…</span>')+'</td>'`; the holdings table's identical `sp ? sparkSVG(sp.pts) : '<span class="dim">…</span>'`; and the hour-of-day readers `hourVerdict(sp.byHour)` at three call sites plus `whyTag`'s `hourVerdict((S.spark.get(x.id) || {}).byHour)`. For an archive-fed item every one renders its no-data form: no FALLING chip, a dimmed "…" that reads as still-loading, and the trend column sorting to `-Infinity` (`const x = ra[ws.k] == null ? -Infinity : ra[ws.k]`) — while `candidateFor` benches the row with "falling chart — −9.3% over 7d". That is a component reporting nothing where it should report what it HAS, on the plan surface, about the very reading that benched the row. The hour-of-day readers are a different case: `byHour` genuinely has no archive equivalent today (see finding 3), so their "—" is honest; the trend and sparkline readers are not.

**Production cited.**

```js
const tr = sp ? trendPct(sp.pts) : null;
```

**Verifier method.** Read index.html: `rowRiskFlags` in full, both `renderWatch` reader sites and the sort comparator, the holdings sparkline line, `itemSeries`'s three returns. Ran `grep -n 'trendPct(sp.pts)|sparkSVG(sp.pts)|hourVerdict(' index.html` to confirm the enumeration is complete rather than a sample.

**Verifier says.** Every quoted reader exists and every one bypasses `itemSeries`. `grep -n 'trendPct(sp.pts)|sparkSVG(sp.pts)|hourVerdict(' index.html` returns exactly the enumerated set: `rowRiskFlags` — `const tr = sp ? trendPct(sp.pts) : null;` immediately followed by `if (tr != null && tr <= -5) push("falling", tr <= -8, "FALLING", …)`; `renderWatch`'s sort map — `limit: c.limit, trend: sp ? trendPct(sp.pts) : null`; `renderWatch`'s row — `const tr = sp ? trendPct(sp.pts) : null;` and `'<td class="sec">'+(sp ? sparkSVG(sp.pts) : '<span class="dim">…</span>')+'</td>'`; the holdings table's identical sparkline line; and `hourVerdict` at four call sites (`(S.spark.get(x.id)||{}).byHour`, and three `sp ? hourVerdict(sp.byHour) : null`). The sort's absence handling is as quoted: `const x = ra[ws.k] == null ? -Infinity : ra[ws.k]`. So for an archive-fed watch item the row renders no FALLING chip, a dimmed '…' that reads as still-loading, and sorts to the bottom of the trend column, while `candidateFor` benches the same row with "falling chart — …% over 7d" off the archive series. That is a component reporting nothing where it has something, on the surface the operator rules from. The finder's own distinction is correct and worth keeping: `byHour` has no archive equivalent (`itemSeries` returns `byHour: null` on the archive branch), so the hour readers' '—' is honest; the trend and sparkline readers are not.

**Correction to the finder.** Accurate, and display is the right severity — nothing here changes what is funded or at what size. Worth noting alongside finding 3: the same population (watch item, no spark, archive ready) drives findings 3, 6 and 8, so one wiring decision closes all three.

**Proposal — NOT APPLIED.** Route `rowRiskFlags`, the sort key and the row's `tr` through `itemSeries(w.id, sp)`; `renderWatch` already has `sp` in hand at each site, so it is a one-argument change per call. For `sparkSVG`, either draw the archive series or replace the bare "…" with a stated reason, since "…" currently claims still-loading about a series that has arrived. Then add one assertion in §96's fixture shape asserting the row's FALLING chip is present for the same item the chain benched — the narrowest container that contains the property, per the ninth face, not a page-wide match.

---

## 20. [DISPLAY] [R98.3] calls committed(9803) — production's committed takes no arguments and returns a book-wide total, so the label and the call shape read as item-scoped exposure that does not exist

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `money-path-new-assertions`
- **Failure mode:** label/call-shape overclaims (the assertion itself still bites)
- **Assertion:** [R98.3] committed() counts an OPEN POSITION's capital — the limb every cluster and budget fixture left empty, so deleting it changed nothing the suite could see
- **Condition:** ``cmt0 === 0 && cmt1 === 100 * 1000`, where `const cmt0 = committed(9803);` and `const cmt1 = committed(9803);``

**Evidence.**

Production is `const committed = () => DB.positions.reduce((a,p) => a + p.qty * p.buy, 0) + DB.watch.reduce((a,w) => { const qp = w.quotePlaced; return a + (qp ? Math.max(0, (qp.buyQty || 0) - (qp.buyFilled || 0)) * (qp.bid || 0) : 0); }, 0);` — a zero-parameter arrow. The `9803` argument is discarded. The pair still discriminates the positions limb correctly: with DB.positions empty and no watch row carrying quotePlaced, cmt0 is 0; with the seeded position, cmt1 is exactly 100×1000, and deleting `DB.positions.reduce(...)` drives cmt1 to 0 → red. So this is not a dead assertion. It is a claim finding: a reader of the probe, of the label, or of REQUIREMENTS R98.3 comes away believing an item-scoped `committed(id)` exists and is under test. It also silently couples the assertion to the quote-leg limb being zero — a future fixture that leaves a quotePlaced on a watch row turns it red for a reason the label does not name.

**Production cited.**

```js
const committed = () => DB.positions.reduce((a,p) => a + p.qty * p.buy, 0)
  + DB.watch.reduce((a,w) => {
      const qp = w.quotePlaced;
      return a + (qp ? Math.max(0, (qp.buyQty || 0) - (qp.buyFilled || 0)) * (qp.bid || 0) : 0);
    }, 0);
```

**Verifier method.** Grepped `committed` in index.html (33 hits) and read the one definition at the `/* Committed capital = positions at cost PLUS unfilled standing quote buy legs at cost */` comment. Matched the probe's `const cmt0 = committed(9803);` / `const cmt1 = committed(9803);` and [R98.3]'s condition `cmt0 === 0 && cmt1 === 100 * 1000`. Traced §98's reset98 (`DB.positions = []`) and the three watch rows `[{ id: 9801, qty: null }, { id: 9802, qty: null }, { id: 9803, qty: null }]` to confirm the quote-leg limb contributes 0 and the positions limb pins cmt1.

**Verifier says.** Production reads `const committed = () => DB.positions.reduce((a,p) => a + p.qty * p.buy, 0) + DB.watch.reduce((a,w) => { const qp = w.quotePlaced; return a + (qp ? Math.max(0, (qp.buyQty || 0) - (qp.buyFilled || 0)) * (qp.bid || 0) : 0); }, 0);` — a zero-parameter arrow, and `grep -n committed index.html` confirms it is the only definition of that name (the others are `sleeveCommitted`, copy strings and glossary text). The probe writes `const cmt0 = committed(9803);` and `const cmt1 = committed(9803);`; the argument is discarded. The finder's own concession is correct and I verified it: reset98 sets `DB.positions = []` and no §98 watch row carries quotePlaced, so cmt0 is 0 and cmt1 is exactly 100 × 1000, and deleting the positions reduce drives cmt1 to 0 → red. So the assertion is live; the defect is the claim, and it is repeated in REQUIREMENTS R98.3.

**Correction to the finder.** Severity is display/hygiene, correctly stated by the finder. The second half of the finding — that the assertion is silently coupled to the quote-leg limb being zero — is also true and worth carrying: a future §98 revision that leaves a `quotePlaced` on any of the three watch rows turns [R98.3] red for a reason its label does not name.

**Proposal — NOT APPLIED.** Drop the argument (`committed()`), and state in the label that the subject is the BOOK-WIDE total with the quote-leg limb held at zero by the fixture — which is what makes the delta attributable to the positions limb. This is scan 14's shape exactly: the call shape is copy, and copy claims what it computes.

---

## 21. [HYGIENE] [R91.1]'s behavioural form distinguishes "two interpreters that DISAGREE" — not "two that agree by coincidence"

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `series-resolver`
- **Failure mode:** Residual weakness after a genuine improvement; the empty-series half carries most of the discriminating power
- **Assertion:** [R91.1] the live chain and the instrument reach the SAME momentum verdict on the same series — asserted BEHAVIOURALLY, because a source-substring match survives any rewiring that keeps the identifier in the text
- **Condition:** `chainMo === instMo && chainMo !== null && chainMo !== "(no candidate)"`

**Evidence.**

This is a real improvement over `String(momentum).indexOf("momentumState")` and the rewrite's own comment is honest about what it tests ("the property is AGREEMENT, plus proof the fed path was reached at all"). But agreement over one fixture cannot exclude the failure it is named against. The fixture is a single series (`const knifeSeries = [130, 125, 120, 110, 100]`) at a single live buy price, fed to both sources deliberately identically, and the resulting state is deliberately NOT pinned ("pinning it would be asserting the fixture rather than the term"). A second interpreter reintroduced on the chain that implements the same rule with a different constant — say `q <= 0.20` instead of `momentumState`'s `if (q <= 0.25 && dir < 0) return { state: "knife", q };` — would agree here and on most fixtures. The genuinely discriminating half is the companion assertion on the empty series (`chainNull === null && instNull === null`), which catches a caller reverting to a reader that manufactures a passing verdict from nothing — the actual historical defect. So the pair is sound for the defect it was written for and weaker than "one interpreter" as a general claim. I am not asserting this is currently broken; I am asserting the assertion could not tell.

**Production cited.**

```js
if (q >= 0.75 && dir > 0) return { state: "chasing", q };
```

**Verifier method.** Read tools/probe/probe-snippet.html §91's `[R91.1]` pair in full, including the fixture setup (`kSp91`/`kCC91`/`kIt91` save, the two `S.chartCache` assignments and the restore) and the inline comment stating why the state is unpinned. Read index.html `momentumState` in full to identify the constants a divergent second interpreter would have to miss.

**Verifier says.** The characterisation is exact and the finder's own hedge is appropriate. The fixture is a single series at a single price fed deliberately to both sources — `const knifeSeries = [130, 125, 120, 110, 100];` written into `S.spark.set(9741, {pts: knifeSeries, …})` and `S.chartCache = {… pts: new Map([[9741, knifeSeries]]) …}` — and the condition is `chainMo === instMo && chainMo !== null && chainMo !== "(no candidate)"`, with the resulting state deliberately unpinned (the inline comment says pinning it "would be asserting the fixture rather than the term"). A second interpreter on the chain implementing the same rule with a shifted constant — `q <= 0.20` against `momentumState`'s shipped `if (q <= 0.25 && dir < 0) return { state: "knife", q };` — agrees on this series and on most, so agreement over one fixture cannot exclude the failure the surrounding comment names ('there is one interpreter'). The genuinely discriminating half is the companion, `chainNull === null && instNull === null` on an emptied spark and an emptied cache, which does catch a caller reverting to a reader that manufactures a verdict from nothing — the actual historical defect. So the pair is sound for what it was written to catch and weaker than 'one interpreter' as a general claim.

**Correction to the finder.** One label point in the assertion's favour, against failure-mode 8: the label claims 'reach the SAME momentum verdict', which is precisely what the condition tests — it does not overclaim. The 'one interpreter' claim lives in the surrounding comment, not in the label. So this is a scope-of-coverage observation, correctly rated hygiene, not a label-claim finding.

**Proposal — NOT APPLIED.** Sweep the pair across the state boundary rather than one point inside it: run the same chain-vs-instrument comparison over a small array of series chosen to sit either side of each threshold (`q` at 0.24/0.26, `dir` at ±1, the flat-range guard `hi - lo < Math.max(1, hi * 0.001)`, and pts length 4/5), asserting agreement at every one. A second interpreter has to reproduce all four boundaries to survive that, which is close enough to "one interpreter" to earn the label. Cheap — the fixture is already built and only the series varies.

---

## 22. [HYGIENE] [R97.2] and its requirement row make the same by-value claim; the S.* caches are key-deleted with no snapshot, and the assertion checks two of four caches for one id and one of four for the other

- **Verdict:** NO VERDICT · **Finder's bite call:** NO - proven inert · **Scope:** `money-path-new-assertions`
- **Failure mode:** label overclaims / partial coverage of a universal
- **Assertion:** [R97.2] the fixture cleans BOTH ends — S.items returns to its original length and no probe id survives in the item caches (the M152 discipline: a fixture that leaks reads as production data on the next block)
- **Condition:** ``S.items.length === k97.itemsLen && !S.byId.has(SEED97) && !S.byId.has(CAND97) && !S.spark.has(CAND97) && S.latest[CAND97] === undefined``

**Evidence.**

REQUIREMENTS R97.2 reads 'It writes DB.watch, DB.sibBorn (**persisted**), DB.scoutLog, DB.sibStats and the `S.*` item caches. Every one is snapshotted and restored by value'. The DB half is true — k97 captures all four and the fixture reassigns rather than mutates, so `DB.sibBorn = k97.sibBorn` genuinely restores. The S.* half is false: the restore is `for (const id of [SEED97, CAND97]){ S.byId.delete(id); S.spark.delete(id); delete S.latest[id]; delete S.hour[id]; }` — key-delete, and none of the four caches is in k97 (`{ watch, sibBorn, scoutLog, sibStats, bl, perSeed, total, itemsLen }`). The assertion covers S.spark and S.latest for CAND97 only, S.byId for both, and S.hour for neither: delete `delete S.hour[id]` from the restore and it stays green.

**Production cited.**

```js
for (const id of [SEED97, CAND97]){ S.byId.delete(id); S.spark.delete(id); delete S.latest[id]; delete S.hour[id]; }
```

**Verifier method.** (none)

**Verifier says.** 

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Same choice as R98.5 — snapshot the four caches per id and set-or-delete, or narrow the requirement row's wording to the DB stores it actually describes. If the assertion stays as-is, extend the condition to all four caches × both ids; it is four extra conjuncts on a line that already exists.

---

## 23. [HYGIENE] §95 captures k95.latest and k95.hour and then restores by key-delete — the capture is dead and the author's own intent is contradicted two lines later

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `money-path-new-assertions`
- **Failure mode:** dead capture / restore-by-key-delete where a pre-existing row would be lost
- **Assertion:** (no assertion — the §95 teardown; the block carries no cleanup assertion at all, unlike §97 and §98)
- **Condition:** `n/a — `DB.watch = k95.watch; DB.flips = k95.flips; DB.blacklist = k95.bl; DB.qual = k95.qual; DB.itemOps = k95.ops; DB.anomalyFlags = k95.anom; DB.intel = k95.intel; if (k95.byId) S.byId.set(9501, k95.byId); else S.byId.delete(9501); S.spark.delete(9501); delete S.latest[9501]; delete S.hour[9501];``

**Evidence.**

k95 is declared as `{ watch, flips, bl, qual, latest: S.latest[9501], hour: S.hour[9501], byId: S.byId.get(9501), ops, anom, intel }`. `k95.byId` is used correctly — set-or-delete. `k95.latest` and `k95.hour` are never read anywhere in the file (grep: they appear only in that object literal); the restore unconditionally deletes. `S.spark` for 9501 is not captured at all and is also key-deleted. So the block is internally inconsistent about a hazard it demonstrably knew about. Also worth noting: §95 has no equivalent of [R97.2]/[R98.5] — nothing asserts its own teardown, so this asymmetry has no detector. Inert today: 9501 is not seeded by any other block and the probe universe carries no real /mapping items.

**Production cited.**

```js
const k95 = { watch: DB.watch, flips: DB.flips, bl: DB.blacklist, qual: DB.qual,
                  latest: S.latest[9501], hour: S.hour[9501], byId: S.byId.get(9501),
                  ops: DB.itemOps, anom: DB.anomalyFlags, intel: DB.intel };
    ...
    S.spark.delete(9501); delete S.latest[9501]; delete S.hour[9501];
```

**Verifier method.** Read tools/probe/probe-snippet.html §95's k95 literal, mk95 (which sets S.byId, S.latest, S.hour and S.spark for 9501), and the teardown block verbatim. Grepped `k95\.` across the file and read all four hits (one is a false positive on `blk95.includes`).

**Verifier says.** Verified by grep and by reading. k95 is declared `{ watch: DB.watch, flips: DB.flips, bl: DB.blacklist, qual: DB.qual, latest: S.latest[9501], hour: S.hour[9501], byId: S.byId.get(9501), ops: DB.itemOps, anom: DB.anomalyFlags, intel: DB.intel }`. Grepping `k95\.` returns only the restore lines: `DB.watch = k95.watch; DB.flips = k95.flips; DB.blacklist = k95.bl; DB.qual = k95.qual;`, `DB.itemOps = k95.ops; DB.anomalyFlags = k95.anom; DB.intel = k95.intel;`, `if (k95.byId) S.byId.set(9501, k95.byId); else S.byId.delete(9501);` — `k95.latest` and `k95.hour` appear nowhere but the object literal, and the next line is the unconditional `S.spark.delete(9501); delete S.latest[9501]; delete S.hour[9501];`. S.spark for 9501 is set by mk95 and is not captured at all. The internal inconsistency is real: the same block gets byId right (set-or-delete) and the other three wrong. And §95 carries no teardown assertion at all, unlike [R97.2] and [R98.5], so nothing watches it.

**Correction to the finder.** Confirmed and correctly self-rated inert. Same reason as the §97 case: `--host-resolver-rules="MAP * ~NOTFOUND"` in run.sh means no real item 9501 exists in S.latest or S.hour to be destroyed, and no other block seeds 9501.

**Proposal — NOT APPLIED.** Restore latest/hour the way byId is restored (`if (k95.latest) S.latest[9501] = k95.latest; else delete S.latest[9501];`), capture S.spark alongside them, and add a §95 teardown assertion in the [R97.2]/[R98.5] shape so the block's cleanup has a detector like its two neighbours.

---

## 24. [HYGIENE] [R95.1]'s third conjunct is implied by its second, and clean95 is never asserted empty — the assertion proves the blacklist gate FIRES, not that it is what withholds funding

- **Verdict:** REFUTED · **Finder's bite call:** YES - looks sound · **Scope:** `money-path-new-assertions`
- **Failure mode:** implied conjunct (failure mode 1, weak form) + label slightly stronger than the fixture
- **Assertion:** [R95.1] a blacklisted item benches on the BLACKLIST gate in the plan chain — the user's veto, which had no assertion of any kind until the adversarial pass found it
- **Condition:** ``!clean95.includes("blacklist") && blk95.includes("blacklist") && /blacklisted by you/.test(candidateFor(DB.watch[0]).failed || "")``

**Evidence.**

The causal half is genuinely sound and I want to state that plainly: `clean95` and `blk95` are two `candidateFor` runs differing only in `DB.blacklist`, so the gate's membership in `fails` is attributed to `isBlk` by construction, and deleting `chk(isBlk(w.id), "blacklist", …)` turns it red. Two smaller things. (a) `chk(isBlk(w.id), "blacklist", …)` is the FIRST chk pushed in candidateFor and `const failed = fails.length ? fails[0].detail : null;`, so once `blk95.includes("blacklist")` holds, `/blacklisted by you/` on `failed` is guaranteed by array position — it adds copy coverage for the detail string but no independent evidence. (b) `clean95` is only checked for the absence of "blacklist"; nothing asserts it is EMPTY, and the §95 fixture never sets DB.bank / DB.reserve / DB.shadowReserve (it inherits whatever §94 left), so `chk(!(qty > 0), "sizing", …)` and other gates may sit in both arrays. The item may already be benched for other reasons in both runs, which makes 'benches on the BLACKLIST gate' a claim about gate membership rather than about the veto being the binding constraint — the first-match-attribution distinction this constitution names as scan 16's subject.

**Production cited.**

```js
chk(isBlk(w.id), "blacklist",
      "blacklisted by you — nothing automated can clear this, not even a margin test; remove it in the Blacklist box if you want it back");
```

**Verifier method.** Read index.html's candidateFor from `function candidateFor(w){` through the first six chk() calls, confirming `chk(isBlk(w.id), "blacklist", "blacklisted by you — nothing automated can clear this...")` is the first push and that nothing pushes to `fails` before it. Grepped `const failed = fails` and matched `const failed = fails.length ? fails[0].detail : null;`. Read §95's `const gates95 = () => (candidateFor(DB.watch[0]).fails || []).map(f => f.g);`, the clean95/blk95 pair and [R95.1]'s full condition. Also checked candidateFor's early exit `if (!c || c.buy == null || c.sell == null) return { id:w.id, name: itemName(w.id), failed:"no live price in /latest" };` — it precedes the blacklist chk, so a dead fixture would make conjunct 2 red rather than green, which is self-guarding.

**Verifier says.** Both sub-claims fail on the code. (a) The third conjunct is not implied by the assertion — it is implied only by a PRODUCTION FACT, and asserting a production fact is coverage, not redundancy. `chk(isBlk(w.id), "blacklist", ...)` is indeed the first chk pushed (I read candidateFor from `const fails = []; const chk = (cond, g, detail, gap) => { if (cond) fails.push(...) };` forward, and the only statement between them is the `mf`/`mfHas` computation, which pushes nothing), and `const failed = fails.length ? fails[0].detail : null;`. So `/blacklisted by you/.test(...failed)` asserts that the blacklist is the HEADLINE bench reason, which is strictly stronger than membership. Reorder chk so the ROI floor precedes the blacklist and conjunct 2 stays green while conjunct 3 goes red — that is exactly the discrimination the [R7.3] standard asks for, present rather than absent. (b) The 'clean95 not asserted empty' point does not weaken the attribution: clean95 and blk95 differ in `DB.blacklist` alone, so the gate's appearance is attributed to `isBlk(w.id)` by construction whatever else is in either array; and by (a) the assertion in fact establishes the veto as fails[0], not merely as a member. The finding's own closing sentence — that this is 'a claim about gate membership rather than about the veto being the binding constraint' — is the part that is wrong on the code.

**Correction to the finder.** The conjunct is not a tautology: it independently asserts chk-chain position (blacklist is fails[0]), and would go red on a reordering that left conjunct 2 green. The differential pair makes the causal attribution sound regardless of what else clean95 contains. No finding here.

**Proposal — NOT APPLIED.** Add `clean95.length === 0` as a conjunct (or assert `candidateFor(DB.watch[0]).failed === null` in the clean arm). That converts the assertion from 'the gate fires' to 'the gate is what benches an otherwise-fundable item', which is what the label and REQUIREMENTS R95.1 both say. It would also protect the fixture against inherited capital state from §94.

---

## 25. [HYGIENE] The §87/§89 block leaks `S.scorerCtlPass` into every later block — the M152 discipline the project cites in R97.2

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `pool-branch-and-ops`
- **Failure mode:** fixture leak (restore list omits a field the block writes)
- **Assertion:** [R89.1] the ARMED branch executes and stamps pool provenance …
- **Condition:** `S.scorerCtlPass = [9201, 9202, 9203]; const onPath = planCandidates(true);`

**Evidence.**

The block opens `const kQ = DB.qual, kW = DB.watch, kEv = DB.qualEvict, kStamp = S.qualStamp;` and closes `DB.qual = kQ; DB.watch = kW; DB.qualEvict = kEv; S.qualStamp = kStamp;` — `S.scorerCtlPass` is written twice inside (both at `S.scorerCtlPass = [9201, 9202, 9203]`) and restored nowhere. Contrast §84, which owns the field and does restore it: `const keep84 = { fr: S.scorerFrontier, ctl: S.scorerCtlPass, … }` … `S.scorerCtlPass = keep84.ctl;`. After §89 the three synthetic ids stand for the rest of the run. Consequence today is nil — I traced the two other readers (`cutoverPoolRows`, reachable only under the armed flag, and `scorerCtlFundedSection`'s `const ids = S.scorerCtlPass;`) and no later block renders that surface; §92 reads `DB.poolSeen`/`DB.scorerT2` instead. It is reported because R97.2 states this exact rule ('A fixture that leaks reads as production data on the next block — the M152 discipline') and because the next scorer-surface assertion added after §89 would silently inherit three ids with no market data.

**Production cited.**

```js
cutoverPoolRows: `const ids = Array.isArray(S.scorerCtlPass) ? S.scorerCtlPass : [];`
```

**Verifier method.** Read tools/probe/probe-snippet.html lines 10072 (snapshot), 10176 and 10187 (both writes), 10211 (restore), 9708 and 9817 (§84's matching snapshot/restore). Ran grep -n 'scorerCtlPass' on index.html (3 sites: 2385 writer, 5870 cutoverPoolRows, 10033 scorerCtlFundedSection) and awk NR>10214 + grep over the probe for any later reader (empty).

**Verifier says.** The leak is exactly as described, and the finder's own "consequence nil today" bound is correct — I re-derived it rather than accepting it.

THE LEAK. The block's snapshot is `const kQ = DB.qual, kW = DB.watch, kEv = DB.qualEvict, kStamp = S.qualStamp;` (probe-snippet.html:10072) and its restore is `DB.qual = kQ; DB.watch = kW; DB.qualEvict = kEv; S.qualStamp = kStamp;` (probe-snippet.html:10211). `S.scorerCtlPass` is written twice inside — line 10176 and line 10187, both `S.scorerCtlPass = [9201, 9202, 9203];` — and appears in neither list. Confirmed by reading both lines, not by trusting the quote.

THE CONTRAST HOLDS. §84 owns the same field and does restore it: `const keep84 = { fr: S.scorerFrontier, ctl: S.scorerCtlPass, … }` at line 9708 and `S.scorerCtlPass = keep84.ctl;` at line 9817. §84 runs BEFORE §87/§89, so its restore cannot clean up afterwards.

CONSEQUENCE BOUND, INDEPENDENTLY CHECKED. `grep -n 'scorerCtlPass' index.html` gives three sites: the writer at 2385 (`S.scorerCtlPass = ctlPass.slice();`), `cutoverPoolRows` at 5870, and `scorerCtlFundedSection` at 10033. `awk 'NR>10214' tools/probe/probe-snippet.html | grep -n 'scorerCtlPass|scorerCtlFunded|cutoverPoolRows|planCandidates'` returns EMPTY — no assertion after §89 touches the field or either reader. So the three synthetic ids stand for the rest of the run with nothing reading them.

Correctly filed as hygiene, and correctly justified: R97.2 states the rule in terms ('A fixture that leaks reads as production data on the next block — the M152 discipline'), so the next scorer-surface assertion added after §89 would silently inherit three ids that have no market data — which is precisely the condition that made [R89.2] vacuous.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Add `ctl: S.scorerCtlPass` to the block's keep object and restore it beside `S.qualStamp`. One line, and it removes the ordering dependency that currently makes §92's independence from this field load-bearing.

---

## 26. [HYGIENE] The gate-name enumeration is enforced at the import writer but not at the grant writer — two writers, two definitions of a valid gate

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `pool-branch-and-ops`
- **Failure mode:** two writers disagree (asymmetric validation on one store)
- **Assertion:** (none — no assertion covers either writer's gate vocabulary)
- **Condition:** `(none)`

**Evidence.**

`ev.gate` comes from `exceptionEvidence`, which derives it from `p.benchedBy` on paper trips: `for (const g of (p.benchedBy || [])) gates[g] = (gates[g] || 0) + 1;`. Every legitimate write of `benchedBy` is `[f.g]` or `[fl[0].g]` off `candidateFor`'s `fails`, so the vocabulary matches — but the import restores it free-form: `if (Array.isArray(p.benchedBy) && p.benchedBy.length) o2.benchedBy = p.benchedBy.map(g => String(g).slice(0, 60)).slice(0, 4);`. A hand-edited or stale state file can therefore seed an arbitrary `benchedBy` string, `exceptionEvidence` will propose it as the gate to waive, and `grantException` will write it into a store whose own comment calls its rows RULINGS — with no enumeration check on that path. The resulting record is inert for funding (`x.fails.every(f => f.g === exc.gate)` can never match a string no gate emits), but it is a real record the operator granted that the NEXT import silently drops. Also confirmed while checking this: the production comment's claim that a blacklist-gated record 'cannot be produced through the UI' is true but under-argued — it holds because `if (!fp.nearMiss || fp.nearMiss.g === "blacklist") continue;` keeps blacklist benches out of the paper book entirely, and because the slice path does `if (isBlk(c.id)) continue;`, not only because `exceptionEvidence` refuses a currently-blacklisted item.

**Production cited.**

```js
grantException: `DB.shadowExceptions.push({ id, gate: ev.gate, grantedAt: Date.now(), trips: 0, status: "active", …});` — validateImport: `if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;`
```

**Verifier method.** Read index.html 10819-10835 (grantException push), 10640-10651 (exceptionEvidence gate derivation and red-flag bar), 24297-24316 (validateImport shadowExceptions enumeration), 24183 (validateImport benchedBy free-form restore), 8468 and 8486 (the two paper-book blacklist filters), 6172 (the every() match). Ran grep -n 'benchedBy' index.html — 3 writer sites, all `[f.g]`-shaped.

**Verifier says.** The asymmetry is real and every link in the chain is present.

WRITER A, unchecked: `function grantException(id)` (index.html:10819) does `DB.shadowExceptions.push({ id, gate: ev.gate, grantedAt: Date.now(), trips: 0, status: "active", evidence: {…} });` — no enumeration of `ev.gate`.

SOURCE OF `ev.gate`: `exceptionEvidence` (index.html:10640) builds `for (const g of (p.benchedBy || [])) gates[g] = (gates[g] || 0) + 1;` then `const gate = Object.entries(gates).sort(…).map(x => x[0])[0];`. So the gate string is whatever `benchedBy` holds.

WRITER B, checked: validateImport's shadowExceptions stanza does `if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;` — DROPS anything unrecognised.

THE SEED PATH IS OPEN: validateImport's shadowBook stanza is `if (Array.isArray(p.benchedBy) && p.benchedBy.length) o2.benchedBy = p.benchedBy.map(g => String(g).slice(0, 60)).slice(0, 4);` (index.html:24183) — free-form, length-capped only. Legitimate writers are all `benchedBy: [f.g]` / `[fl[0].g]` off `candidateFor`'s `fails` (index.html 8470, 8503, 8605), so the vocabularies match on the honest path and diverge only on the import path — which is exactly the asymmetry claimed.

INERTNESS FOR FUNDING, confirmed: `if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;` can never match a string no `chk(...)` emits. So the consequence is the stated one — a record the operator granted, in a store whose own comment calls its rows RULINGS, that the next import silently drops. Hygiene, correctly rated.

THE SIDE-CHECK IS ALSO RIGHT: the production comment's "cannot be produced through the UI" holds for a stronger reason than it gives. `exceptionEvidence` bars a currently-blacklisted item via `if (suspectedPump(id) || isBlk(id) || toxicFor(id)) return null;` — but the deeper bar is that blacklist benches never enter the paper book at all: `if (!fp.nearMiss || fp.nearMiss.g === "blacklist") continue;` (index.html:8468) and `if (isBlk(c.id)) continue;   // the blacklist is the user's alone` (index.html:8486). So `gates["blacklist"]` can never accumulate. Confirmed as stated.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Either apply the same enumeration at the grant (`if (!GATE_CHAIN_ORDER.includes(ev.gate) || ev.gate === "blacklist") return null;` inside `exceptionEvidence`, so the lane never offers an ungrantable gate), or validate `benchedBy` against `GATE_CHAIN_ORDER` on import so the free-form string never reaches the lane. Pick one owner for the promise — the same choice the dead-safeguard rule demands — and assert whichever you pick.

---

## 27. [HYGIENE] `opsOf`'s `bands` row fallback is dead: nothing anywhere writes `w.tierOvBands`

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `pool-branch-and-ops`
- **Failure mode:** dead branch (a fallback whose trigger no writer can reach)
- **Assertion:** [R93.3] tierBandsSame carries three states — absent means PREDATES THE FIELD (applied, so the migration is behaviour-neutral), a matching pair applies, a different pair does not
- **Condition:** `tierBandsSame(null) === null && tierBandsSame([1, 2, 3]) === null && tierBandsSame([live[0], live[1]]) === true && tierBandsSame([live[0], live[1] + 1]) === false`

**Evidence.**

`grep -n "tierOvBands" index.html` returns exactly one line — that read. There is no writer: `opsSet` writes `r.bands = tierBandsNow()` into the STORE row, `itemOpsMigrate` deliberately omits `bands`, and `validateImport`'s watch stanza does not carry it. So the `(w ? w.tierOvBands : null)` limb can only ever evaluate to `undefined`, which `tierBandsSame` maps to the same `null` the literal alternative gives — behaviourally identical to writing `: null`. It reads as a partition the watch row participates in, and it does not. No assertion touches it either: [R93.3] calls `tierBandsSame`/`opsTierOv` directly, and [R93.1]'s `opsOf` fixture sets no `tierOvBands`, so deleting the limb turns nothing red.

**Production cited.**

```js
opsOf: `const bands = o ? o.bands : (w ? w.tierOvBands : null);`
```

**Verifier method.** Ran grep -n 'tierOvBands' across index.html and tools/probe/probe-snippet.html — one hit total. Read index.html 5595-5605 (tierBandsSame), 5615-5638 (opsOf), 5642-5653 (opsSet), 5684-5704 (itemOpsMigrate with its no-bands comment), 23870-23893 (validateImport watch whitelist in full). Read tools/probe/probe-snippet.html 10480-10520 ([R93.1] fixture and [R93.3] conditions).

**Verifier says.** `grep -n 'tierOvBands' index.html tools/probe/probe-snippet.html` returns exactly ONE line in the entire tree: index.html:5629, `const bands = o ? o.bands : (w ? w.tierOvBands : null);`. That is the read. There is no writer anywhere, in production or in the probe.

I checked the three plausible writers and all three are negative. `opsSet` writes `r.bands = tierBandsNow();` into the STORE row, never onto a watch row (index.html:5648). `itemOpsMigrate` copies only `["tBuy", "tSell", "tAt", "qty", "tierOv", "t2Grad"]` and carries an explicit comment that bands is deliberately not stamped (index.html:5689-5697). And validateImport's watch stanza (index.html:23870-23893) is a strict WHITELIST — `const o = { id, qty: num(w.qty) };` then a fixed list of conditional adds ending `if (w.sibGrad) o.sibGrad = 1;` — `tierOvBands` is not among them, so it cannot even arrive by import.

So the `(w ? w.tierOvBands : null)` limb evaluates to `undefined` for every reachable watch row, and `tierBandsSame` maps that to the same `null` the literal alternative would give: `const tierBandsSame = b => !Array.isArray(b) || b.length !== 2 ? null : (…)`. Behaviourally identical to writing `: null`, while reading as a partition the watch row participates in.

UNCOVERED, confirmed: [R93.3]'s condition calls `tierBandsSame(null)`, `tierBandsSame([1,2,3])`, `tierBandsSame([live[0], live[1]])`, `tierBandsSame([live[0], live[1] + 1])` — the term directly, never through `opsOf`. [R93.1]'s fixture is `DB.watch = [{ id: 930001, name: "Row value", tierOv: 1, qty: 7 }]` and sets no `tierOvBands`. Deleting the limb turns nothing red.

One nuance worth recording rather than disputing: `load()` performs no per-row validation, so a hand-edited localStorage blob could put `tierOvBands` on a watch row. That is not a product writer and does not rescue the branch — it is the same unvalidated-boot surface finding 1 rests on.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Delete the limb (`const bands = o ? o.bands : null;`) and state in the comment that a watch-row override has no band stamp by construction, which is what makes it APPLIED. If instead the intent is that migrated overrides should one day carry a stamp, that is a writer that does not exist and should be a named future stage rather than a fallback that reads as one.

---

## 28. [HYGIENE] `if (exc && isBlk(x.id)) continue;` is a dead safeguard — the very next line already continues in every case it can fire

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** unreachable guard (eighth face: decoration that reads as protection)
- **Assertion:** none — no assertion reaches this line
- **Condition:** `n/a`

**Evidence.**

`candidateFor` pushes the blacklist fail unconditionally: `chk(isBlk(w.id), "blacklist", …)`. Nothing between candidateFor and this loop mutates `x.fails` (the only writers are `fails.push` inside `chk`; every other `.fails` reference in index.html reads). So whenever `isBlk(x.id)` is true, `"blacklist"` is in `x.fails`. Two cases exhaust it: `exc.gate === "blacklist"` is already caught by the preceding line; `exc.gate !== "blacklist"` makes `x.fails.every(f => f.g === exc.gate)` false, so the following line continues anyway. The guard therefore never changes an outcome. It is harmless, but the constitution names this shape as a finding class precisely because "a guard whose trigger condition cannot be reached by its own upstream limits is not protection — it is decoration that reads as protection", and here it sits directly beneath a comment explaining why the blacklist checks are load-bearing, which is how one layer's real promise gets read as two.

**Production cited.**

```js
index.html, buildPlan: `if (exc && exc.gate === "blacklist") continue;` / `if (exc && isBlk(x.id)) continue;` / `if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;`
```

**Verifier method.** Read index.html 6155–6180 (the three consecutive lines in buildPlan's exception loop, in order), 5369–5385 (chk's definition and the unconditional blacklist chk), 5320–5325 (the early return that carries no fails array, filtered out by `if (!x.failed || !Array.isArray(x.fails) || !x.fails.length) continue;`). Grepped index.html for `\.fails` and classified all 24 sites as read or write.

**Verifier says.** The exhaustiveness argument holds and I verified both of its premises independently. Premise 1: `chk(isBlk(w.id), "blacklist", "blacklisted by you — nothing automated can clear this…")` is unconditional in candidateFor, so `isBlk(id)` true implies `{g:"blacklist"}` is in `fails`. Premise 2: nothing mutates `x.fails` between candidateFor and the loop — grep of `.fails` across index.html returns 24 hits and every one is a READ except `fails.push(…)` inside `chk` itself (line 2635's `e.fails.add(g)` is a different Set in the rdiff code, and 2439 slices). Given both, the case split is exhaustive: `exc.gate === "blacklist"` is caught by the preceding `if (exc && exc.gate === "blacklist") continue;`, and `exc.gate !== "blacklist"` makes `x.fails.every(f => f.g === exc.gate)` false at the following line, which continues anyway. Deleting the line changes no outcome, and no assertion reaches it.

**Correction to the finder.** One classification correction. This is NOT the eighth face (a guard whose TRIGGER condition its own upstream limits forbid). The trigger here is perfectly reachable — `exc` truthy and `isBlk(x.id)` true is a state the product can be in; what is unreachable is any DIFFERENT OUTCOME, because the guard's effect is subsumed by the line below it. That is redundancy / defence-in-depth, not decoration over dead code, and the remedy differs: the eighth face says decide which layer owns the promise and delete the other, whereas here the redundant line is a deliberate belt-and-braces against a future edit to the `every()` line. Hygiene at most; I would not remove it without noting that the line below is what actually holds the promise.

**Proposal — NOT APPLIED.** Either delete it and let the `every()` line own the promise (checking first, per the twelfth face, that no assertion is holding it alive — none is), or keep it and state in the comment that it is defence-in-depth against a future `fails` mutation rather than a live path. Do not write an assertion for it without first naming a production caller that can reach it — that would be the manufactured-state face.

---

## 29. [HYGIENE] sizeLine's rewrite REORDERED the multiplication where the other two preserved it — exact-arithmetic identical, IEEE-754 reassociated

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** arithmetic identity check (the scope's direct question)
- **Assertion:** [R72.1] the horizon term SCALES with its inputs — asserted by proportion, never by restating the formula
- **Condition:** ``Math.abs(b - 2 * a) <= 1` — a ±1 tolerance, which is wider than any reassociation error could be, so this assertion could not distinguish the two orders even if it reached the call site.`

**Evidence.**

Two of the three rewrites are byte-for-byte reassociations of nothing: mmVerdict and relocNote both computed `v * GATE.capture * FILLH()` before, which is `horizonUnitsFor`'s expression exactly, including the `|| 0` fallbacks which the term inherits unchanged (`horizonUnitsFor(c.volSide || 0)`, `horizonUnitsFor(x.volGate || 0)`). Both are identical, full stop. sizeLine is the exception: it computed `v * FILLH() * GATE.capture` and now computes `v * GATE.capture * FILLH()`. In exact arithmetic these are equal. In IEEE-754 they are `fl(fl(v·F)·C)` versus `fl(fl(v·C)·F)`, which is a reassociation, not a commutation, and can differ by roughly one ulp — enough to move `Math.floor` by one unit only when the exact product lands within about 1e-11 of an integer. With `FILLH() = Math.min(24, (n.at - ts) / 3600e3)` a continuous function of the wall clock, that is a measure-zero coincidence; where the horizon is a power-of-two constant the rounding is provably scale-invariant and the two agree. I could not execute a search for a witness — no Node on this machine and the tree is frozen — so I am reporting the shape, not a defect. I flag it because the scope asked for arithmetic identity and because the other two sites preserved the order while this one, the only one that spends capital, did not.

**Production cited.**

```js
sizeLine OLD: `Math.floor(x.volGate * FILLH() * GATE.capture)` → NEW: `horizonUnitsFor(x.volGate)` = `Math.floor(volGate * GATE.capture * FILLH())`. Compare mmVerdict OLD: `Math.floor((c.volSide || 0) * GATE.capture * FILLH())` and relocNote OLD: `Math.floor((x.volGate || 0) * GATE.capture * FILLH())` — both already in the term's exact operand order.
```

**Verifier method.** Ran `git diff -U0 index.html | grep` for the three pre-change expressions and matched each against horizonUnitsFor's body at index.html:3567. Read index.html 5137, 6275, 7823 (the three current call sites) and 3567–3568. Ran two awk double-precision searches (2M random samples, then a targeted sweep with h = u/(v·c)) to establish whether a divergence witness exists at all.

**Verifier says.** The factual claim is exactly right, and I went further than the finder could. `git diff -U0 index.html` shows the three removed lines verbatim: `-      Math.floor((c.volSide || 0) * GATE.capture * FILLH()),` (mmVerdict), `-    const u = Math.floor((x.volGate || 0) * GATE.capture * FILLH());` (relocNote), and `-    const byLiquidity = Math.floor(x.volGate * FILLH() * GATE.capture);` (sizeLine). Against `const horizonUnitsFor = volGate => Math.floor(volGate * GATE.capture * FILLH());`, the first two are operand-for-operand identical including the `|| 0` fallbacks, which the term inherits at the call site. Only sizeLine reassociated `(v·F)·C` to `(v·C)·F`. I searched for a witness numerically rather than accepting the theory: 2,000,000 random (v, h) draws over v ∈ [1, 200000], h ∈ (0.01, 9.51] with c = 0.15 produced ZERO disagreements, but a targeted search over h chosen to land the product on an integer produced witnesses immediately — e.g. v=1000, h=6.6533333333333333 gives int(v·h·c)=997 and int(v·c·h)=998; v=1685, h=15.782393669634025 gives 3988 vs 3989. So the two orders are provably not identical in IEEE-754, and the new order is the (marginally) larger one on every witness found.

**Correction to the finder.** Confirmed as a fact, but it is not a defect and should not be actioned as one. The witness set has measure zero in h: `FILLH() = planHorizonH()` is the continuous gap to the next touch, so hitting a witness requires the exact product to land within ~1 ulp (≈3.6e-12 relative) of an integer — 0 hits in 2M random draws. The consequence when it does hit is one UNIT of quantity in a term that is the non-binding input to `Math.min(x.qty, byLiquidity, Math.max(0, byPart))` in every fixture measured. Also note [R72.1]'s `Math.abs(b - 2 * a) <= 1` tolerance could not distinguish the orders even if it reached the call site, which the finder correctly states. Rank last.

**Proposal — NOT APPLIED.** No change needed if the answer is "one unit at 1e-11 probability is not a position size". If it matters, write the operand order at the sizing site to match what it replaced — or better, record in horizonUnitsFor's own comment that its operand order is normative, so the next extraction is checked against a stated form rather than against three different inline memories.

---

## 30. [HYGIENE] GATE_CHAIN_ORDER is complete for its new whitelist use today, but it changed job without changing its contract, and nothing pins it against the gate names it now polices

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `horizon-term-and-regressions`
- **Failure mode:** seam / list repurposed from display ordering to admission whitelist
- **Assertion:** none — the probe references GATE_CHAIN_ORDER once, as export payload: `roi: GATE.roi, tick: DB.tickFloor, gates: GATE_CHAIN_ORDER`
- **Condition:** `n/a — no assertion constrains the list's membership`

**Evidence.**

Answering the scope question directly: it IS complete now. I enumerated every `chk(cond, g, …)` in candidateFor — blacklist, proven-loser bench, ROI floor, margin floor (ticks / 3× tax), book skew, flow imbalance, no history, chart still loading, trend, volume trend, sizing, volume floor, momentum, fill history, drift bench — and all fifteen appear in GATE_CHAIN_ORDER; `chk` is the only writer of `fails`, and `benchedBy` is populated from `f.g` at all three paper-book writers, so `e.gate` can only ever be one of those fifteen. The sixteenth entry, `"no live price"`, corresponds to candidateFor's early `return { …, failed:"no live price in /latest" }`, which carries no `fails` array and so can never be a `g` — harmless in a whitelist. What changed is the failure mode of incompleteness. The funnel consumer explicitly TOLERATES an unlisted name by appending it; the new consumer DROPS the record. So the day a sixteenth gate is added to `chk` and not to this list, a stale display ordering becomes silent destruction of a user's exception ruling on import — in a store whose own comment calls its rows RULINGS and whose validator comment says "Unrecognised values are DROPPED, never smuggled". Nothing goes red at that moment.

**Production cited.**

```js
`if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;` (validateImport) against the pre-existing consumers `for (const g of GATE_CHAIN_ORDER) if (kills.get(g)) stages.push({ label: g, kill: kills.get(g) }); for (const [g, k] of kills) if (GATE_CHAIN_ORDER.indexOf(g) < 0) stages.push({ label: g, kill: k });`
```

**Verifier method.** Read index.html 7692–7706 (the array and the headline-vs-binding comment), 5369–5470 (chk's definition and all sixteen chk call sites in candidateFor), 5320–5325 (the no-live-price early return), 13834–13845 (the funnel's tolerant consumer), 24308 (the validateImport whitelist), 10640–10700 (exceptionEvidence's gate derivation from benchedBy), 3715–3740 (the ledger-keys-do-not-move comment). Grepped for benchedBy writers (8470, 8503, 8605 — all `f.g`) and for GATE_CHAIN_ORDER in the probe. Read probe-snippet.html 4979–4990 ([R38.2]) and gateName's full body.

**Verifier says.** I re-derived the enumeration independently and it matches. Every `chk(cond, g, …)` in candidateFor emits one of: blacklist, proven-loser bench, ROI floor, margin floor (ticks / 3× tax), book skew, flow imbalance, no history, chart still loading, trend (twice), volume trend, sizing, volume floor, momentum, fill history, drift bench — fifteen distinct names, all present in `GATE_CHAIN_ORDER`, whose sixteenth entry 'no live price' corresponds to the early `return { …, failed:"no live price in /latest" }` that carries no `fails` array. `const chk = (cond, g, detail, gap) => { if (cond) fails.push(…) };` is the only writer, and all three paper-book writers set `benchedBy` from `f.g`, so `e.gate` can only be one of the fifteen. The failure-mode divergence is real: the funnel appends unlisted names (`for (const [g, k] of kills) if (GATE_CHAIN_ORDER.indexOf(g) < 0) stages.push({ label: g, kill: k });`) while validateImport drops the record (`if (g === "blacklist" || !GATE_CHAIN_ORDER.includes(g)) return null;`). And nothing pins membership: the probe's only reference is the export payload `gates: GATE_CHAIN_ORDER`, and [R38.2] checks `gateName()`'s returns against the GLOSSARY, not against this array — which is a different set anyway, since gateName can return 'seasoning' and 'plan gate', neither of which is in GATE_CHAIN_ORDER.

**Correction to the finder.** No correction to substance; the finder's own answer to the scope question ('it IS complete now') is right. This is a forward-looking hygiene finding, not a present defect: nothing is dropped today. Worth stating precisely what would break and when — the day a sixteenth `chk` name is added without the array being extended, an imported exception record carrying that gate is silently dropped, in a store whose sanitizer comment says 'Unrecognised values are DROPPED, never smuggled'. Nothing goes red at that moment.

**Proposal — NOT APPLIED.** Pin the correspondence rather than the list: an assertion that every `g` produced by running `candidateFor` over a fixture set — or, more robustly, a small exported array of the chk names — is a member of GATE_CHAIN_ORDER, so adding a gate without listing it turns something red in the same commit. Seed by removing one name from the list.

---

## Cleared — read and judged sound, so the next run starts from a list

### series-resolver

CLEARED — checked and found sound, so they are not findings:

(1) §96's second half is genuine, not a false-unknown. With `chartCache.state.ready = false` and no spark, `itemSeries` returns `{ pts: [], vols: [], src: "none" }`; `tr` and `vt` are literally `null` by their ternaries, `momentumState([], buy)` returns `{ state: null }` and `stabilityWeight([], …)` returns `drifty: null`. No consumer among the three asserted can return a non-null value that merely looks like unknown. `momentumState`'s "flat" is the one value that WOULD look fed while meaning nothing — but it requires `pts.length >= 5`, so it is unreachable from an empty series. The genuine "looks like a measurement" value in the family is `hourWeight`'s `w: 1`, which is reported as finding 3.

(2) §96's early-return path is not a hole. `candidateFor` returns `{ id, name, failed }` with no `mo`/`stw` when there is no live price, so `cd96 && cd96.mo && …` evaluates falsy and the assertion goes red rather than passing vacuously. Both halves are guarded the same way.

(3) `[R97.1]`'s sibling pair is the strongest block I read. Three cases (steady/drifty/unknown) over one varying input, with an explicit anti-dead-fixture sanity case ("the fixture proves the ring can admit before it proves calm can stop it"), and `admUnknown === false` proves the conservative reading is the one that ships. It also covers the `huntSiblings` call site's use of `itemSeries` — via the spark branch only, which is a fixture gap rather than a defect.

(4) `trendPct` is robust to uniform compression of the archive series: it returns `(slope * (xs[n-1]-xs[0])) / Math.abs(fittedStart) * 100`, and shortening the window raises slope-per-index and lowers the span by the same factor, so the total fitted move is preserved. I started to write this up as a shape finding and the arithmetic killed it. It is NOT robust to non-uniformly clustered gaps (a 12h-a-day archive collapses each night's move into one index step), and `trendPct` preserves original index positions for the spark (`if (Number.isFinite(v)){ xs.push(i); ys.push(v); }`) while the archive path discards that information before `trendPct` ever sees it. At the ruled coverage (168 of 192 hours) the residual is small and its direction is not predictable, so I am recording it here rather than as a finding — but it is the one place where the resolver comment "Both are hourly; nothing here mixes resolutions" is true about resolution and unproven about ALIGNMENT.

(5) `sitRisk`'s "median hourly step × 24" survives the ruled coverage for the same reason: with at most 24 missing hours in 8 days, the median step is still a one-hour step. It breaks only under coverage the gate already forbids.

(6) `recon5m` / `seriesPxAt` / `reconReplay` read a 5m series from a separate cache for the paper book. Different resolution, different consumer, not part of this seam. `flipMarkouts` and `reachFlow` read `sp.series` and `sp.lows`, which the archive does not carry and `itemSeries` does not claim to resolve — correctly out of scope.

(7) `marketStatsFor`'s `chartReady() ? trendPct(chartPts(id)) : null` is redundant (chartPts already returns [] when not ready) but harmless — both paths yield null.

UNCERTAIN, stated as such rather than upgraded: how often a per-item archive series is short enough to split the four thresholds (finding 2). `t0Pack` packs `Object.keys(data)` from the raw `/1h` response, and `marketStatsFor`'s own `const volHigh = H ? (H.highPriceVolume || 0) : 0` shows the code treats `S.hour[id]` as possibly absent — so bucket-level absence is real. The NaN path is certain regardless of that question: `p.push(mid)` with `mid = NaN` when neither side printed, filtered by every consumer except `volTrendPct`. I could not measure the distribution without running the app, which is outside this scope.

NOT DONE, deliberately: no file was written, edited or seeded; the probe suite was not run; nothing was committed. Every claim above rests on quoted production text and quoted assertion conditions, plus one `grep -P` executed against a printf'd literal to verify the §94 short-circuit without touching the tree.

### money-path-new-assertions

Six of the twelve assertions I could not break, and the reasoning is worth recording so the next pass does not redo it.

[R97.1] — ARITHMETIC VERIFIED, the fixture isolates `calm` and the two arms land in genuinely different sitRisk buckets. steadyPts alternates 1000/1002 → all 29 diffs are 2 → median 2 → `daily = 2*24 = 48`. driftyPts alternates 1000/1020 → all diffs 20 → `daily = 480`. Margin: CAND97 is buy 1000 / sell 1150, `geTax = Math.min(Math.floor(1150*0.02), 5e6) = 23`, so `c.margin = 1150 - 1000 - 23 = 127`. Ratios are 48/127 = 0.378 (≤ 0.5 → `drifty: false` → calm true) and 480/127 = 3.78 (> 2 → `drifty: true` → calm false). Not adjacent buckets — the steady arm clears the 0.5 band with room and the drifty arm clears the 1.0 band by 3.8x. Both arrays are length 30, over sitRisk's `pts.length < 24` floor. The isolation claim holds under check: `calc()` never reads `S.spark` (I read it end to end — it reads S.byId, S.latest, S.hour, S.min5, opsOf, S.volRank), so every other conjunct of `microHit` (`c.buy` band, `seedFlow`/`flow` band, the 0.10 spread ratio) is identical across all three runs and the series is the only variable. famHit is false: `familyKey("Quokka trinket")` = "quokka trinket" vs `familyKey("Zephyr widget")` = "zephyr widget", no shared token. The unknown arm is honest — `mk97(..., null)` does `S.spark.delete(id)`, `itemSeries` falls through to `chartPts(9702)` which is empty, `sitRisk` returns null, `stabilityWeight` returns `drifty: null`, and `=== false` is false. Deleting `&& calm` from `microHit` turns both arms of [R97.1] red.

[R98.1] — familyKey trace confirmed by hand through the full replace chain. "Adamant arrowtips" → `s.replace(/\barrowtips?\b/g, "arrow")` → "adamant arrow"; "Adamant arrow" is untouched by every rule and ends "adamant arrow". Identical strings, so `bestByFam` really does hold two members, which is the premise the label rests on. "Quokka trinket" → "quokka trinket", distinct, and it is the control that proves the plan funds at all. Scores tie exactly (identical fixtures, wins 0, rel.w 1, hw.w 1, stw.w 1.15), `if (!cur || x.score > cur.score)` uses strict >, and Array#sort is stable, so 9801 wins deterministically. Delete `applyFamilyRule` at `pass = applyFamilyRule(pass, bench);` → both fund → `famFunded.length === 2` → red. Delete the arrowtips rule from familyKey → same. Both halves covered.

[R98.2] — the 1e12 worry does not land. `DB.minExpectGp` has exactly one consumer: `const minExpect = (DB.minExpectGp > 0) ? DB.minExpectGp : Math.max(1000, Math.round(effTotal * 0.001));`, and `minExpect` is read in exactly two places — `const tooSmall = cap > 0 && preRamp * x.eMargin < minExpect;` and the bench copy. There is no second guard for a huge number to route through. The pair is the same plan re-run with the floor at 0, so the delta is attributable. Delete `tooSmall` from the `if (full_ || blockedSeed || blockedT2 || blockedCluster || cap <= 0 || qty <= 0 || tooSmall)` disjunction → floorPlan funds → red.

[R98.4] — isolated. exp0 is 0 with both `DB.positions` and `DB.invLots` empty, exp1 − exp0 is pinned at exactly 50×1000 by `invCostGp`. Deleting the `for (const l of DB.invLots)` limb of `clusterExposure` drives exp1 to 0 and fails both conjuncts. One unexercised sub-property, not a finding: the `seen` Set that dedups multiple lots on one item is never tested (the fixture has one lot), but no label claims it.

[R95.4] — strong. The tested pair (3000/5000) is deliberately distinct from the live pair (4000/4400), so the override is observable in both directions, and it reads the LIVE path rather than a vestigial one: `ITEM_OPS` is `false` and pinned by [R93.1], so `opsOf`'s `const o = ITEM_OPS ? ... : null` makes the watch row the production reader — the fixture writing tBuy/tSell/tAt onto the row is exactly what a user press produces today. Deleting `(Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS` from `const tested = ...` makes cStale.buy 3000 → red. (The separate constant-pinning gap is finding 1.)

[R95.3] — the TTL is the only variable across the pair. `recentNet` returns `lastAt: fl[fl.length-1].id`, and the fixture's flip ids are `1e12 + 1..3` ≈ Sep 2001, far below Date.now() ≈ 1.787e12, so `tAt > r.lastAt` is satisfied in BOTH arms and cannot be what separates them. Both arms also set tBuy/tSell equal to the live prices (4000/4400), so `calc`'s `tested` flag flipping between arms changes no downstream number — `effMargin` returns 372-equivalent either way. Deleting `Date.now() - tAt < TESTED_TTL_MS` from provenLoser's release → stale arm unbenches → red. (Same constant-value caveat as above.)

ONE PROCEDURAL NOTE, not a finding: `ok(name, cond, extra)` evaluates `extra` eagerly, so [R98.2]'s evidence string runs a third `buildPlan()` and [R98.1]'s runs none extra — §98 therefore executes buildPlan four times, each with a `save()`. Cost only, but it multiplies the leak in finding 3.

### pool-branch-and-ops

(a) CLEAR — no silent arming path. `grep -n "planCandidates" index.html` returns six hits: three comments (the switch's own block, the qual-src warn copy, the funnel tile note), the definition, and exactly TWO production call sites, both argument-free: `const all = planCandidates();` in `buildPlan`, and `for (const x of planCandidates()){` in `runScout`. Neither passes anything, and the identifier is never used as a value (no `.map(planCandidates)` or callback form) so no index or event object can arrive as `armed`. `const on = armed === undefined ? CUTOVER_POOL : armed;` therefore reads the const in every production call today. The default is also covered rather than merely correct: changing it to default-true turns [R89.1]'s off-path assertion red, because `offPath.length === 1` becomes 3.

(b) CLEAR — [R89.1]'s armed assertion proves BOTH the concat and the stamp, and would NOT pass on a path that skipped `markSrc`. `poolCands` is DEFINED by `c.src === QUAL_SRC_POOL`, so removing `markSrc` from the pool leg drives `poolCands.length` to 0 against a required 2. Traced four seeds: drop `markSrc` on the pool leg → red; drop it on the watch leg → `onPath.filter(c => c.src === QUAL_SRC_WATCH).length === 1` → red; return only `watch` → `onPath.length === 3` → red; return only the pool → red. The `!held.has(id)` filter in `cutoverPoolRows` is pinned twice (`onPath.length === 3` and `poolRows.length === 2`). The one seed that survives is reordering the concat (`pool.concat(watch)`), which changes only tie-break order in a score-sorted list — noted, not raised.

(c) CLEAR on the completeness question. `GATE_CHAIN_ORDER` is a strict superset of everything `fails[].g` can carry, so no legitimate exception is dropped on import. Enumerated all 15 `chk(...)` calls in `candidateFor` — the only writer of `fails` in the file (`fails.push` appears once, inside `chk`) — and every key is present: blacklist, proven-loser bench, ROI floor, margin floor (ticks / 3× tax), book skew, flow imbalance, no history, chart still loading, trend (two limbs, one key), volume trend, sizing, volume floor, momentum, fill history, drift bench. `GATE_CHAIN_ORDER`'s 16th entry, `"no live price"`, sits on the early-return path that never builds a `fails` array, so it is a permitted-but-unmatchable value rather than a gap. `gateName()`'s extra returns (`"no live price"`, `"seasoning"`, `"plan gate"`) never reach `fails[].g` — seasoning benches in `buildPlan` into `qualifying`, and `"plan gate"` is a display fallback. `MARKET_GATE_KEYS` is a disjoint schema-key vocabulary (roi/margin/skew/…) consumed via `mfHas(...)` and translated to display names at the `chk` call; it never lands in `fails[].g` and `[R74.4]` already asserts no operator gate can appear in it.

(c) CLEAR on other bench-deletion paths. `delete x.failed` appears exactly once in the file, inside the guarded routing. Every other reader of an exception is downstream of `x.exception`, which only that routing sets: `applySizeFactors` (halves the cap under probation), the seasoning waiver at `qualExemption(...) || (x.exception ? … : null)`, and two display paths (`renderWatch`'s `excFor(w.id)` detail block, the t2-graduation loop). Only two writers touch `DB.shadowExceptions`: `grantException` (behind `exceptionEvidence`, which returns null on `isBlk(id)`, `suspectedPump(id)`, `toxicFor(id)` and on an existing grant) and `validateImport`. Note recorded above under finding 1: `load()` bypasses `validateImport` entirely, so the import fix does not reach records already in localStorage — which is why the `buildPlan` guards are load-bearing rather than belt-and-braces.

(d) ANSWER — only the first two. `planCandidates(armed)` is asserted by [R89.1]'s armed stanza (sound, per (b)) with REQUIREMENTS R89.1 updated to match. The §93 re-key is asserted by R93.1–R93.7 (ten assertions plus three on the controls) and those are broadly sound: [R93.1]'s off-path fixture sets `DB.itemOps = { 930001: { tierOv: 2, qty: 99 } }` against a row carrying 1/7 and asserts 1/7, so arming the read turns it red; [R93.2] and [R93.3] call the extracted production terms (`opsPick`, `opsTierOv`, `tierBandsSame`) rather than re-deriving them; [R93.4]'s idempotence half is genuinely discriminating (`n2 === 0 && qty === 42`); [R93.7] scopes its absence check to `#planList` rather than the page. The blacklist ruling — all three lines — is asserted by nothing, in either direction, with no REQUIREMENTS row, so `reqpair.sh` cannot see the gap either. That is finding 1.

DOCTRINE noted by inspection, not dressed as a check: `itemOpsPrune` is currently unreachable (its only caller is `opsSet`, whose only callers are the two pool-control handlers, which cannot fire while `poolControlsHTML` returns `""` under `ITEM_OPS === false`). Worth flagging at the arming ruling rather than now: the 90-day prune drops manual `qty` overrides, and `planQty`'s `wanted = mq == null ? cap : mq; qty = min(wanted, cap)` means dropping an `mq` smaller than the cap WIDENS the funded size — an expiry that loosens, which the restraint-lift rule reserves for a press. The code warns rather than presses, and R93.5 argues the storage-bound reading; I record it as a question for the arming stanza, not as a finding against a dead path.

### horizon-term-and-regressions

Four scope items came back clean, and I want them on record as checked rather than skipped.

`momentum(c, sp)` DELETION — clean. `grep -n "[^a-zA-Z]momentum("` over index.html and the probe returns exactly one hit, and it is the tombstone comment `/* momentum(c, sp) DELETED (Aug 19 2026)… */`. Every live call is `momentumState(pts, buy)`: `moState: momentumState(chartPts(id), buy).state` in marketStatsFor, `const mo = momentumState(ser.pts, c.buy);` in candidateFor, and five probe call sites, all passing arrays. No caller remains.

`sitRisk` / `stabilityWeight` SIGNATURE CHANGE — clean, no caller left on the spark object. The complete caller set from grep is three production lines and one probe block. Production: `const stw = stabilityWeight(ser.pts, eMargin != null ? eMargin : 0);` (candidateFor), `const calm = stabilityWeight(itemSeries(it.i, sp).pts, Math.max(1, c.margin)).drifty === false;` (huntSiblings), and `const r = sitRisk(rawPts, margin);` inside stabilityWeight itself. Probe: [R91.2] passes `undefined`, `[1,2,3]`, and two 30-element arrays. `sitRisk` has no other caller at all. Nothing would hit `(rawPts || []).filter` on an object. Note that `rowRiskFlags(w, c, sp, P)` still takes a spark parameter but never touches either function — I checked, it is a different consumer.

mmVerdict AND relocNote ARITHMETIC — identical, including the fallbacks. Both previously computed `Math.floor(v * GATE.capture * FILLH())`, which is `horizonUnitsFor`'s expression in the same operand order, and both kept their `|| 0` guards outside the call (`horizonUnitsFor(c.volSide || 0)`, `horizonUnitsFor(x.volGate || 0)`). No precedence or argument-order difference. Only sizeLine reordered, which is finding 6.

`sp` AFTER THE RESOLVER IN candidateFor — three uses, two of which are the seam in finding 5 and one of which is correct. `const hw = hourWeight(sp);` is deliberate and documented ("`hourWeight` is deliberately NOT on it and says so below") — it reads `sp.byHour`, a per-item hourly volume profile that `itemSeries` explicitly does not resolve, and `itemSeries` even preserves `byHour: sp ? sp.byHour : null` on its none-branch. That one the resolver should NOT own. The other two — the `no history` and `chart still loading` gates — are the ones it should, and that is finding 5.

ALSO CHECKED AND CLEAN, outside the stated scope but inside this session's diff: `planQty` was rewritten from `w.qty` to `const mq = opsOf(w.id).qty;`. This is bit-identical today, on two independent grounds — `const ITEM_OPS = false` makes `opsOf` skip the store entirely (`const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;`), and even with the flag on, `opsPick` falls back to the watch row. [R93.1] pins the flag and asserts the not-consulted property. `applyFamilyRule`'s change is copy-only (an appended clause on the bench string; the `bestByFam` selection is untouched). No new gate names entered `chk`.

ONE THING I COULD NOT RESOLVE UNDER THE FREEZE, stated so it is not mistaken for a clearance: I could not execute anything — no Node, no Python on this machine — so every claim above is from reading, and the float-reassociation question in finding 6 in particular is reasoned rather than witnessed. Findings 1, 3 and 4 are the ones I would most want confirmed by an actual seed, and each names the seed that would confirm it.

