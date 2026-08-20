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
| `search-pattern` | 14 | 48 | 2 |
| `ring-a-seam` | 16 | 38 | 9 |
| `ring-b-operator-log` | 84 | 48 | 7 |
| `ring-b-sizing-caps` | 95 | 55 | 9 |
| `ring-b-chart-overlays` | 54 | 55 | 8 |
| `new-session-assertions` | 60 | 38 | 13 |

**48 findings — 46 CONFIRMED by an independent verifier, 1 REFUTED, 1 UNCERTAIN.** Every verifier was instructed to default to REFUTED without independent tracing, told that a real line quoted out of its guard is the commonest way a false finding survives, and required to name the files it opened and the text it matched.

**Governance held:** no sub-agent wrote, edited, seeded, ran the suite, or committed. Findings returned as findings; the one genuinely unsettleable question returned UNCERTAIN with what would settle it.

---

## 1. [MONEY-PATH] [R74.2]'s source scan does not read the function that contains the core's logic — marketGateEval is not in coreSrc

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-a-seam`
- **Failure mode:** 7 (stale coverage) compounded by 2 (fixture prevents expression) on the functional half
- **Assertion:** [R74.2] the core is pure — ambient mutation changes nothing, and its source names no ambient state
- **Condition:** `JSON.stringify(outMut) === JSON.stringify(outA) && forbidden74.every(t => coreSrc.indexOf(t) < 0)`

**Evidence.**

Stage 1c extracted every comparison out of `marketGateFails` into `marketGateEval` (production comment: "ONE EVALUATOR OWNS THE COMPARISONS … `marketGateFails` DERIVES from it"). The source scan was never extended. `String(marketGateFails)` is now a two-line delegator containing no branch, no constant and no comparison; `marginNeedCfg` and `volFloorCfg` are three lines of pure arithmetic. So the source half of [R74.2] scans zero of the eight gate limbs.

The functional half does not cover the gap either: it mutates exactly three ambient values — `GATE.roi = 99; GATE.taxMult = 99; DB.tickFloor = 999;` — out of the ~10 ambient constants `liveMarketConfig()` reads, and none of the eight operator-state sources the forbidden list names (`exemptIds`, `itemWins`, `provenLoser`, `slowHistory`, `isBlk`, `workingStack`, `lastWalkupAt`, `calc(`). Adding `isBlk(st.id)` or `itemWins(st.id)` inside `marketGateEval` would be seen by neither half: the source scan never stringifies that function, and the functional fixture `st74` carries no `id` and no blacklist entry, so the mutation set cannot move the output.

REQUIREMENTS.md R74.2 is stale in the same way — it names "`String(fn)` over `marketGateFails` + `marginNeedCfg` + `volFloorCfg`" — and its own stated justification is exactly the coverage that has been lost: "The source half exists because a leak can be inert on one fixture and real on another — the functional half alone is exactly the kind of green the twelfth face warns about." That is now the suite's actual state.

This is the highest-consequence item in the ring: the pure core is the thing the control cell's verdicts rest on, and the pool switch is the deployment-class change. An operator-state leak into the evaluator makes the control cell's population a function of the user's blacklist/log, silently, with the assertion that exists to forbid it still green.

**Production cited.**

```js
probe: `const coreSrc = String(marketGateFails) + String(marginNeedCfg) + String(volFloorCfg);`

production, the ENTIRE body of marketGateFails:
`function marketGateFails(st, cfg){\n  return marketGateEval(st, cfg).filter(e => e.state === "fail")\n    .map(e => ({ g: e.g, have: e.have, need: e.need }));\n}`

production, where the gate logic actually lives:
`function marketGateEval(st, cfg){` … `add("roi", st.eRoi, cfg.roi, (st.eRoi == null || st.eRoi < cfg.roi) ? "fail" : "pass");` … `const mn = marginNeedCfg(cfg, !!st.exempt, st.tax || 0);` … `const vf = volFloorCfg(cfg.volBase, st.buy);` … `return rows;\n}`
```

**Verifier method.** Opened index.html and read the whole §1a block (`function marginNeedCfg` through `const liveMarketConfig`), matching the exact bodies of `marketGateFails`, `marketGateEval`, `marginNeedCfg`, `volFloorCfg` and `liveMarketConfig`. Opened tools/probe/probe-snippet.html §74 (the block from `const st74 = {` to the `[R74.5b]` ok) and matched the `coreSrc`, `forbidden74` and mutation lines. Ran `grep -n "String(marketGate\|marketGateEval" tools/probe/probe-snippet.html` — only the three call sites, no stringify. Matched REQUIREMENTS.md row R74.2 by grep.

**Verifier says.** The quote is real and in context. `const coreSrc = String(marketGateFails) + String(marginNeedCfg) + String(volFloorCfg);` is the exact probe line, and `String()` of a function returns only that function's own text. Production's `marketGateFails` is verbatim the two-line delegator the finder quoted: `return marketGateEval(st, cfg).filter(e => e.state === "fail").map(e => ({ g: e.g, have: e.have, need: e.need }));`. Every comparison — `add("roi", st.eRoi, cfg.roi, (st.eRoi == null || st.eRoi < cfg.roi) ? "fail" : "pass")`, the skew/imbalance/trend/volTrend/momentum limbs, and the `marginNeedCfg` / `volFloorCfg` call sites — lives in `marketGateEval`, which I grepped for across the entire probe: it appears only at three CALL sites ([R84.6] at `const ev84 = marketGateEval(stU, cfgE);` and two [R91.x] calls) and is never stringified anywhere. The functional half is exactly as narrow as claimed: `GATE.roi = 99; GATE.taxMult = 99; DB.tickFloor = 999;` — three of the ten ambient sources `liveMarketConfig()` reads (GATE.roi, GATE.taxMult, TICKF(), DB.filtersT1.vol, GATE.skewHard, GATE.balHardLo, GATE.balHardHi, GATE.trendSoft, GATE.falling, GATE.volDecline) — and `st74` carries no `id`, so an `isBlk(st.id)` or `itemWins(st.id)` leak inside `marketGateEval` moves nothing. Neither half of the assertion can see it. REQUIREMENTS.md R74.2 confirms the stale scope word-for-word: "Source: `String(fn)` over `marketGateFails` + `marginNeedCfg` + `volFloorCfg`", with its justification "a leak can be inert on one fixture and real on another".

**Correction to the finder.** One overstatement to trim: the source half does not scan "zero of the eight gate limbs" in the strict sense — `marginNeedCfg` (the margin gate's need term, including its `Math.max(byTax, byTick)` and the exempt halving) and `volFloorCfg` (the volume floor's need term) are still in scope, so two of the eight NEED derivations are still scanned. What is entirely out of scope is all eight COMPARISONS, all eight state assignments, and the null/unknown branching — i.e. every line where an operator-state read would naturally be written.

**Proposal — NOT APPLIED.** PROPOSE ONLY: add `String(marketGateEval)` to `coreSrc` (one token). While there, two widenings that cost nothing: (a) extend `forbidden74` with `Date.now`, `marketStatsFor`, `liveMarketConfig`, `chartReady`, `chartPts` and the bracket forms `GATE[` / `DB[` / `S[`; (b) widen the functional mutation set from three ambients to the full `liveMarketConfig()` vector plus `exemptIds`/`DB.blacklist`, over a fixture `st` that carries an `id`. Then update REQUIREMENTS.md R74.2's function list. Proof would need a seed I may not run: insert `if (isBlk(st.id)) return rows;` (or any `GATE.`/`DB.` read) into `marketGateEval` and confirm the current form stays green while the widened form goes red — that is the discriminating pair the tenth face demands.

---

## 2. [MONEY-PATH] [R74.3]'s set-equivalence is exercised on one item whose only market failure is the margin gate, and the core is fed the chain's own stats rather than the instrument's

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-a-seam`
- **Failure mode:** 2 (fixture prevents expression) with a 4/6 element — the probe hand-assembles the `st` the product assembles, so the stats-builder seam is never crossed
- **Assertion:** [R74.3] the live chain's market-gate verdicts ARE the core's at the live config — and this fixture passes the ROI floor
- **Condition:** `JSON.stringify([...new Set(candMarket)].sort()) === JSON.stringify([...new Set(coreLive)].sort()) && !candMarket.includes("ROI floor") && cand74.eRoi > 1.2 && cand74.eRoi < 2.2`

**Evidence.**

Two separate narrownesses.

(a) The fixture. Item 9741 is built at sell 4250 / buy 4100 with `highTime = now74-60`, `lowTime = now74-120`, hour volumes 60000/60000, and a 168-point flat spark. Walking `marketGateEval` on it: roi 1.585 ≥ 1.2 pass; margin 65 < need 255 FAIL; skew 1 min ≤ 60 pass; imbalance 0.5 in band pass; trend ≈0 pass; volTrend 0 pass; volFloor 60000 ≥ `volFloorCfg(1000,4100)` = 488 pass; momentum flat pass. So both sides of the set comparison are the single-element set `{"margin floor (ticks / 3× tax)"}`. Seven of eight gates contribute nothing on either side, and seven of the eight `MARKET_GATE_LABEL` value mappings the comparison is supposed to cross are unexercised. A divergence introduced in skew, imbalance, trend, volTrend, volFloor or momentum — including a wrong label string in the chain's `chk(...)` call, which would silently drop that gate out of `candMarket` via `marketLabelSet.has(f.g)` — is invisible here. (The ROI half of the assertion is sound and does bite: it is the routing seed's target, and a +1 on the core's ROI floor flips `candMarket` through code the probe never calls.)

(b) The input. The probe builds `coreLive`'s `st` by copying production's own field-selection expression out of `candidateFor` — the seventh face's tell, "if a probe line constructs an input the product would have constructed, the product's constructor is untested." More consequentially, it means the assertion compares the core against the core fed the CHAIN's stats. The actual cutover divergence is `marketStatsFor` (what the control cell scores) versus `calc`/`effMargin`/`volGateFor` (what the plan scores) — two separately-implemented builders, one of which production's own comment describes as "mirrors `calc()`'s arithmetic", and which already differ by design on `volGate` (1h thin side vs the 5m-aware `volGateFor`). Nothing in Ring A compares them; [R74.5a] compares one field (`stNoTest.buy === 4100`). The suite's only evidence about that seam is the rdiff ledger's empirical row count.

**Production cited.**

```js
probe: `const coreLive = marketGateFails({ buy: cand74.c.buy, tax: cand74.c.tax, exempt: cand74.c.exempt,\n      eMargin: cand74.eMargin, eRoi: cand74.eRoi, skewMin: cand74.c.skewMin, imbalance: cand74.c.imbalance,\n      volGate: cand74.volGate, tr: cand74.tr, vt: cand74.vt, moState: cand74.mo.state }, liveMarketConfig())`

production, candidateFor: `const mf = marketGateFails({ buy: c.buy, tax: c.tax, exempt: c.exempt, eMargin, eRoi,\n      skewMin: c.skewMin, imbalance: c.imbalance, volGate, tr, vt, moState: mo.state }, liveMarketConfig());`

production, the instrument's separate builder: `function marketStatsFor(id){` … `const eMargin = margin1h != null && margin1h < margin ? margin1h : margin;` … `volGate: Math.min(volHigh, volLow),`
against the chain's: `const vg = volGateFor(c);   // vol5 binds only on the ruled conditions` / `const volGate = vg.v;` and `const eMargin = effMargin(c);`
```

**Verifier method.** Read tools/probe/probe-snippet.html §74 from `const now74 = Math.floor(Date.now() / 1000);` through the `[R74.5b]` ok, including `mkItem74`'s spark construction and the 9741 `S.latest`/`S.hour` fixture. Read index.html `function marketGateEval` and `function marginNeedCfg`/`volFloorCfg` to walk each limb, `function trendPct` and `function volTrendPct` (lines quoted above) to establish tr≈0 and vt=0 on that spark, `function marketStatsFor` in full, and `candidateFor`'s `const mf = marketGateFails(...)` block. Ran `grep -n "marketStatsFor" tools/probe/probe-snippet.html` to enumerate every cross-builder assertion.

**Verifier says.** Both halves check out. (a) I walked item 9741 against `marketGateEval` by hand using the production constants: sell 4250 / buy 4100 → tax 85, eMargin 65, eRoi 1.585% ≥ 1.2 pass; margin need = max(3·85, 15) = 255 > 65 FAIL; skewMin = |(now-60)-(now-120)|/60 = 1 ≤ 60 pass; imbalance 60000/120000 = 0.5 inside [0.15, 0.85] pass; `trendPct` over the alternating 4199/4201 spark returns a near-zero slope > trendSoft −5 pass; `volTrendPct` over 168 flat 1000s returns 0 > −40 pass; volFloor `volFloorCfg(1000, 4100)` = round(1000·2000/4100) = 488 ≤ 60000 pass; momentum flat pass. So both sides of the set comparison are the one-element set {margin}, and seven of the eight `MARKET_GATE_LABEL` mappings the comparison is supposed to cross are unexercised — including the label-mismatch case, where a wrong string in the chain's `chk(...)` silently drops the gate via `marketLabelSet.has(f.g)`. (b) The probe line is real and is a field-by-field copy of production's: probe `marketGateFails({ buy: cand74.c.buy, tax: cand74.c.tax, exempt: cand74.c.exempt, eMargin: cand74.eMargin, eRoi: cand74.eRoi, skewMin: cand74.c.skewMin, imbalance: cand74.c.imbalance, volGate: cand74.volGate, tr: cand74.tr, vt: cand74.vt, moState: cand74.mo.state }, liveMarketConfig())` against `candidateFor`'s `const mf = marketGateFails({ buy: c.buy, tax: c.tax, exempt: c.exempt, eMargin, eRoi, skewMin: c.skewMin, imbalance: c.imbalance, volGate, tr, vt, moState: mo.state }, liveMarketConfig());`. And the two builders do differ as claimed: `marketStatsFor` computes `volGate: Math.min(volHigh, volLow)` from the 1h caches while the chain uses `volGateFor(c)`, and `marketStatsFor` has its own `const eMargin = margin1h != null && margin1h < margin ? margin1h : margin;` separate from `effMargin(c)`. Grepping `marketStatsFor` across the probe, the only cross-builder comparison is [R74.5a]'s `cTested.buy === 3000 && stNoTest.buy === 4100` (one field) — its `JSON.stringify(stNoTest) === JSON.stringify(stAfter)` is stats-vs-stats, not stats-vs-calc.

**Correction to the finder.** "PROBABLY NOT [bite]" is too pessimistic as a blanket statement. The assertion is not inert: the `!candMarket.includes("ROI floor")` conjunct is a live standing check that goes red if the chain's ROI verdict on this fixture flips (which is what the routing seed exploits), and a routing break on the MARGIN gate would break the set equality. The confirmed defect is the narrowness — 1 of 8 gates in the equivalence, and the seam the cutover actually rests on (marketStatsFor vs calc/effMargin/volGateFor) uncrossed. One addition in the finder's favour: `[R91.1]` does cross that seam for exactly one field, structurally, via `String(marketStatsFor).indexOf("momentumState") >= 0` — a source check, not a value comparison.

**Proposal — NOT APPLIED.** PROPOSE ONLY, two parts. (1) Widen the fixture so the equivalence carries more than one gate: add two or three more `mkItem74` items chosen to fail skew, imbalance and volFloor at the live config, and assert the set equivalence per item — a divergence in any gate then has somewhere to show. (2) Add the seam assertion the ring is missing: for a non-tested watch item, assert `marketGateFails(marketStatsFor(id), liveMarketConfig())` against the chain's `mf` for the gates both builders claim to compute, and where they deliberately differ (`volGate`), assert the difference is the DECLARED one rather than letting it be silent. Proof would need seeds I may not run: change one gate's label string in a `chk(...)` call and confirm the widened form goes red where the current form stays green.

---

## 3. [MONEY-PATH] The plan chain's blacklist bench has NO assertion — delete it and the suite stays green while a blacklisted pin gets funded

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-operator-log`
- **Failure mode:** 2 (fixture prevents expression) at the limit — every plan-level fixture clears DB.blacklist before building a plan, so the guard's true branch is never entered by any assertion; equivalently, no detector exists
- **Assertion:** (none exists for this guard). The eight blacklist assertions in tools/probe/out/probe-report.txt all guard OTHER call sites: "[R4.3] intel cannot touch blacklist / reserve / gate constants"; "[R26.1] a red flag (blacklist) bars the lane entirely"; "[R36.3] the blacklist is still the user's alone — no automated path admits an entry"; "[R76.10] a blacklisted clean-passer enters NO funded figure..."; "[R76.10b] and the SAME item is counted as the canary..."; "[R78.2] a blacklisted clean-passer gets NO trip at any horizon..."; "[R78.2b] blacklisting an item MID-TRIP voids its open trips at that cycle..."; "[R84.2] a blacklisted item is NEVER a member..."
- **Condition:** `n/a — nearest is [R74.4]'s `&& !emitted.has("sizing") && !emitted.has("blacklist") && !emitted.has("proven-loser bench")`, which asserts the gate is ABSENT from the pure core, i.e. the opposite direction. It stays green when the live chain's gate is deleted.`

**Evidence.**

Production, index.html candidateFor:
    chk(isBlk(w.id), "blacklist",
      "blacklisted by you — nothing automated can clear this, not even a margin test; remove it in the Blacklist box if you want it back");
with `const isBlk = id => (DB.blacklist || []).includes(id);`.

This is the ONLY thing standing between a blacklisted watchlist/pin item and `picks` in buildPlan. Every blacklist fixture in the probe either clears the list before planning or points at a different call site. The two nearest fixtures explicitly clear it: probe line ~60 `DB.clusters = []; DB.clusterCands = []; DB.blacklist = [];` and the R22.4 block `DB.positions = []; DB.planPriority = []; DB.planDemoted = []; DB.intel = []; DB.blacklist = [];`. The other call sites that DO have assertions are separate `isBlk` reads: `if (isBlk(c.id)) continue;` in sliceScan (covered by [R25.5]), `if (suspectedPump(id) || isBlk(id) || toxicFor(id)) return null;` in exceptionEvidence (covered by [R26.1]), autoApplyCohProps (covered by [R36.3]), and `const bl = isBlk(st.id);` in scorerCycle (covered by [R76.10]/[R78.2]/[R84.2]).

POOL QUESTION: after the cutover the pool itself is protected UPSTREAM — scorerCycle does `if (bl){ blCycle.add(st.id); ... c._blFunded++; ...; continue; }` BEFORE `if (c.control) ctlPass.push(st.id)`, and `cutoverPoolRows()` reads `S.scorerCtlPass`, so a blacklisted id never becomes a pool row. That makes the plan-chain gate's only remaining subject the PIN list — which is exactly where a blacklisted item can still sit, since a pin "keeps its own row, its overlays and its watch provenance". So the untested guard is the one that survives the cutover as the sole protection.

**Production cited.**

```js
    chk(isBlk(w.id), "blacklist",
      "blacklisted by you — nothing automated can clear this, not even a margin test; remove it in the Blacklist box if you want it back");
```

**Verifier method.** Grepped `isBlk` across index.html (17 sites) and read each in context via sed. Read `candidateFor`'s gate chain, `planCandidates`, and all of `buildPlan` from `function buildPlan()` through the pass-1 loop. Grepped `blacklist|blkAdd|DB.blacklist` across probe-snippet.html (32 hits) and read each fixture block (§25.5, §26.1, §36.3, §63.2, §74, §76.10, §78.2, §84.2) to check whether a blacklisted id was ever on `DB.watch` during a `buildPlan()`. Grepped `R74.5` across probe-snippet.html, probe-report.txt and REQUIREMENTS.md.

**Verifier says.** I traced every `isBlk` call site in production and every `blacklist` line in the probe, and the plan chain's gate has no detector in either direction.

Production, `candidateFor` in index.html:
    chk(isBlk(w.id), "blacklist",
      "blacklisted by you — nothing automated can clear this, not even a margin test; remove it in the Blacklist box if you want it back");
with `const isBlk = id => (DB.blacklist || []).includes(id);` and `planCandidates()` = `DB.watch.map(w => markSrc(candidateFor(w), QUAL_SRC_WATCH))` (+ `cutoverPoolRows()` when `CUTOVER_POOL`). `buildPlan` contains no `isBlk` read of its own — I grepped the whole file; the 17 `isBlk` sites are all elsewhere (sliceScan, exceptionEvidence, autoApplyCohProps, scorerCycle, scout, badges, cluster apply, mmVerdict, quote suppression).

The suite never puts a blacklisted id on `DB.watch` while a plan builds. Every `DB.blacklist` write in the probe is either a clear (`DB.blacklist = []` at the global fixture line `DB.clusters = []; DB.clusterCands = []; DB.blacklist = [];`, and again in the §22.4 block) or points at a different subsystem: 9316 → sliceScan (`[R25.5]`, and 9316 is created via `S.items.push` only, never `DB.watch`); 9320 → `exceptionEvidence` (`[R26.1]`, removed on the next line, no `buildPlan` between); 9004 → `autoApplyCohProps` (`[R36.3]`); 9330 → `excStanding` (`[R63.2]`); 9763 → `scorerCycle`/trip layer (`[R76.10]`, `[R78.2]`, and the watch there is `DB.watch = [{ id: 9762, qty: null }]` — 9762, not 9763); 9104 → the frontier (`[R84.2]`).

The nearest thing is `[R74.4]`, and it asserts the opposite direction: `&& !emitted.has("sizing") && !emitted.has("blacklist") && !emitted.has("proven-loser bench")` — i.e. the pure core CANNOT emit the key. Deleting the live chain's `chk` leaves that green.

Two pieces of corroboration the finder did not cite, and they are the strongest evidence: the probe's own comment at the head of the §74.5 group promises "(c) blacklist and (d) proven-loser: candidateFor benches, the core's stats-level view is unchanged" — but only `[R74.5a]` and `[R74.5b]` exist in the file, and the report carries exactly two lines (`PASS [R74.5a]`, `PASS [R74.5b]`). And REQUIREMENTS.md §R74.5 states outright: "Blacklist and proven-loser are covered by R74.4's inexpressibility" — a written claim that the wrong-direction assertion is the coverage.

The pool half of the finding also checks out: in `scorerCycle`, `if (bl){ blCycle.add(st.id); … c._blFunded++; … continue; }` sits BEFORE `if (c.control) ctlPass.push(st.id);`, `S.scorerCtlPass = ctlPass.slice();`, and `cutoverPoolRows()` reads `S.scorerCtlPass` — so a blacklisted id never becomes a pool row and the plan gate's live subject is the pin list.

**Correction to the finder.** None on the substance. One addition that strengthens it: the untested guard is not merely untested, it is documented as tested — the probe comment claims a `(c) blacklist` assertion that was never written, and REQUIREMENTS.md R74.5 records `[R74.4]`'s inexpressibility check as the coverage, which is the opposite direction.

**Proposal — NOT APPLIED.** PROPOSE ONLY: add a discriminating pair in the R22.4/plan fixture — blacklist one of 9001/9002/9003 that otherwise funds, assert (a) `buildPlan().bench.some(b => b.id === X && /blacklisted by you/.test(b.failed))` AND `!buildPlan().picks.some(p => p.id === X)`, and (b) the same item funds with the id removed from DB.blacklist. Seed by deleting the `chk(isBlk(w.id), "blacklist", …)` line; the pair must go red and every existing blacklist assertion must stay green (that green is the point — it is what proves the eight existing ones do not cover this). Would need a seed to confirm; I did not run it.

---

## 4. [MONEY-PATH] The proven-loser bench, its re-test release, and the fill-history bench have NO assertions anywhere in the suite

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-operator-log`
- **Failure mode:** No detector at all (the strongest form of mode 2 / mode 8): the labels that mention these gates are inexpressibility claims about a different subsystem, not tests of the gates
- **Assertion:** (none exists). The only occurrences of these names in tools/probe/probe-snippet.html are inside [R74.x] scaffolding: the token list `const forbidden74 = ["GATE.", "DB.", "S.", "exemptIds", "itemWins", "provenLoser", "slowHistory", "isBlk", "workingStack", "lastWalkupAt", "tickFloorFor", "TICKF",` and the label "[R74.4] the core's vocabulary is exactly the config-free market keys — no operator gate, no baked constant".
- **Condition:** `[R74.4]: `&& !emitted.has("sizing") && !emitted.has("blacklist") && !emitted.has("proven-loser bench") && !emitted.has("fill history") && !emitted.has("drift bench")` — asserts these gates CANNOT be emitted by marketGateFails. It says nothing about whether the live chain emits them when it should, and stays green if the live chain never emits them at all.`

**Evidence.**

grep for `provenLoser|recentNet|slowHistory|fillHistory|proven loser|historically slow|re-test` across tools/probe/probe-snippet.html returns only lines 8346/8347 (the forbidden-token array) and 8413/8414/8421 (the [R74.4] inexpressibility assertion and its comment). grep -i for "loser|slow fill|fill history" across tools/probe/out/probe-report.txt returns ZERO lines out of 1181 PASS rows.

The three untested behaviours are all money-path:
(1) the bench fires — `chk(!!loser, "proven-loser bench", …)` and `chk(!!sh, "fill history", …)`;
(2) the RELEASE is a restraint lift — `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`. Both limbs are load-bearing and untested: `tAt > r.lastAt` (the test must post-date the last loss) and the TESTED_TTL freshness clause, which is the entire point of the Aug 9 2026 hardening ("the old rule unbenched forever, so one test weeks ago let a proven loser resurface"). Delete the TTL conjunct and the pre-hardening bug is back, green;
(3) `tierProven(id)` also reads it — `if (provenLoser(id, DB.watch.find(w => w.id === id))) return false;` — so provenLoser silently governs T1 half-sizing too.

POOL QUESTION: both guards are correctly inapplicable to a pool item — `recentNet` returns null below 3 flips and `slowHistory` returns null below 2 timed flips, so no-history is genuinely not-a-loser and not-slow. These are NOT vacuous restraints. But note the production comment on the release path — "The re-test release reads the item store too — otherwise a pool item's fresh margin test could never unbench it" via `opsOf(id).tAt` — is currently false in effect, because `const ITEM_OPS = false;` makes `opsOf` read only the watch row. That errs toward the restraint STAYING ON (safe direction), and is a ruled staging state, not a defect today.

**Production cited.**

```js
function provenLoser(id, w){
  const r = recentNet(id, 3);
  if (!r || r.net >= 0) return null;
  const tAt = opsOf(id).tAt || (w && w.tAt) || 0;
  if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;
  return r;
}
…
    chk(!!loser, "proven-loser bench", …
…
    chk(!!sh, "fill history", …
```

**Verifier method.** Grepped the nine identifier/copy patterns across probe-snippet.html and probe-report.txt; read `recentNet`, `provenLoser`, `fillHistory`, `slowHistory`, `tierProven`, `opsOf` and the `ITEM_OPS` declaration in index.html via sed; read the `chk(!!loser, …)` / `chk(!!sh, …)` lines in `candidateFor`'s chain; grepped `proven` across probe-snippet.html to test for indirect coverage through `tierProven`/`itemTier`.

**Verifier says.** Grepping `provenLoser|slowHistory|recentNet|TESTED_TTL|proven-loser|proven loser|fill history|slow fills|tierProven` across tools/probe/probe-snippet.html returns exactly five hits, all inside the §74 scaffolding: the `forbidden74` token array (`"provenLoser", "slowHistory", …`), the `[R74.4]` conjuncts `!emitted.has("proven-loser bench") && !emitted.has("fill history")`, and the comment claiming `(c) blacklist and (d) proven-loser` are covered. There is no assertion of the gates themselves. Grepping the 1619-line report for `loser|slow fill|fill history|re-test|retest` returns zero lines.

Production quotes verified verbatim:
  function provenLoser(id, w){
    const r = recentNet(id, 3);
    if (!r || r.net >= 0) return null;
    …
    const tAt = opsOf(id).tAt || (w && w.tAt) || 0;
    if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;
    return r;
  }
with `const TESTED_TTL_MS = 16 * 3600e3;`, and in `candidateFor`:
    chk(!!loser, "proven-loser bench", …)
    chk(!!sh, "fill history", …)
and `function slowHistory(id){ const h = fillHistory(id); if (h.length < 2) return null; … if (med <= FILLH() || h[h.length - 1] <= FILLH()) return null; return { med, hist: h }; }`.

The release path is genuinely restraint-lifting and genuinely untested: delete the `Date.now() - tAt < TESTED_TTL_MS` conjunct and the pre-Aug-9-2026 "unbenches forever" bug is back with the suite green.

The third-order reader is real: `function tierProven(id){ … if (provenLoser(id, DB.watch.find(w => w.id === id))) return false; return true; }`, and `tierProven` feeds `itemTier(...).proven`, which feeds `groupOf` in `buildPlan`'s funding sort. I checked whether any assertion would catch a `provenLoser` deletion indirectly through tier: grepping `proven` in the probe shows the only tier-shaped use is the literal `const T1P = { t: 1, proven: true };` — no fixture pairs three net-negative flips with a tier assertion. So nothing goes red indirectly either.

The finder's staging note also checks out: `const ITEM_OPS = false;   // pinned by [R93.1]; the flip is a ruling` and `const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;` inside `opsOf` — so the production comment "The re-test release reads the item store too — otherwise a pool item's fresh margin test could never unbench it" describes a path that is currently inert, erring toward the restraint staying on.

**Correction to the finder.** None. Same corroboration as finding 1: the §74.5 comment promises a `(d) proven-loser` assertion that does not exist, and REQUIREMENTS.md R74.5 records `[R74.4]`'s inexpressibility check as its coverage.

**Proposal — NOT APPLIED.** PROPOSE ONLY: assert at the TERM, not through the chain (the strataCount pattern), because both are already extracted. Three assertions: (a) `provenLoser(id, w)` non-null on 3 net-negative flips and null on 3 net-positive; (b) the release DISCRIMINATES on both limbs — a test stamped BEFORE the last loss does not release, one stamped after and inside TESTED_TTL_MS does, and the SAME test aged past TESTED_TTL_MS does not (inject the TTL rather than reaching through the live constant, per the [R87.2] precedent); (c) `slowHistory` null at 1 timed flip, non-null when the median exceeds FILLH() with the last fill slow, and null when the LAST fill is fast — the "market woke back up" limb. Then one end-to-end assertion that each appears in `candidateFor(...).fails` with the right `g`. Seed each independently. Would need seeds to confirm.

---

## 5. [MONEY-PATH] The allocator sizes real capital with a SECOND, inline copy of the horizon term — the extracted term [R72.1–72.3] guard only feeds the SCORE

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** 3 clamp absorption + 7 stale/misdirected coverage (the assertion exercises a term the sizing path does not call)
- **Assertion:** [R72.1] the horizon term SCALES with its inputs — asserted by proportion, never by restating the formula
- **Condition:** `(() => { const a = horizonUnitsFor(50000), b = horizonUnitsFor(100000); const keepFH = DB.fillHorizonH; DB.fillHorizonH = keepFH * 2; const c = horizonUnitsFor(50000); DB.fillHorizonH = keepFH; return a > 0 && Math.abs(b - 2 * a) <= 1 && Math.abs(c - 2 * a) <= 1; })()`

**Evidence.**

`horizonUnitsFor` / `planHorizonUnits` are consumed at exactly three places — `score`, `estH: estFillH(Math.max(1, horizonUnits), c)`, and `hw, stw, rel, horizonUnits` exposed for the pool sort. The comment on the exposed field even says so: "exposed for the pool group's unweighted sort". NOTHING in the sizing path calls them. `sizeLine` recomputes the identical expression inline as `byLiquidity`. So the three [R72.x] assertions — written as the M118 repair and captioned in production with "sizing silently reverting from the touch schedule to the no-cadence fallback ... misprices the overnight buy leg by up to 2.4x with the suite green" — guard the RANKING term, not the term that bounds capital.

Arithmetic on the fixture, showing the sizing copy is absorbed twice over: for gamma (9003), x.qty = planCap = min(floor((200e6/3)/4000)=16666, limit 25000 x limitWindows()=1) = 16666; byLiquidity = floor(50000 * 4 * 0.15) = 30000; byPart = floor(100000 * 0.10) = 10000. `preRamp = Math.min(16666, 30000, 10000)` — **byPart pins the output at 10000**, then the unproven-T1 factor halves it to 5000, which is the number the one funded-size assertion checks. byLiquidity is 3x above the binding input, so any proportional defect in it is invisible. The other funded-size assertion (`inCl[0].allocQty === 4000`) is pinned by the cluster cap (clusterCapGp = floor(200e6*8/100) = 16e6 / 4000 = 4000). The remaining three size assertions ([R4.2c] teeth, [R7.3] halving, [R1.1] disjointness) are with/without RATIOS, so both sides move together.

And the specific M118-recurrence seed is arithmetically inert at the sizing line: the probe sets `DB.touchWindows = []; DB.fillHorizonH = 4;`, and `gapHoursAt` returns `Math.max(1, DB.fillHorizonH || 4)` when `!scheduleOn()`, so `FILLH()` and `DB.fillHorizonH` are the same 4. [R72.3] injects a real schedule ONLY inside its own IIFE and only calls `horizonUnitsFor` — it never calls `buildPlan`.

**Production cited.**

```js
const horizonUnitsFor = volGate => Math.floor(volGate * GATE.capture * FILLH());
const planHorizonUnits = (volGate, qty) => Math.min(qty, horizonUnitsFor(volGate));
... (candidateFor) const horizonUnits = planHorizonUnits(volGate, qty);
... score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * (1 + Math.min(wins, 5) * 0.1) * hw.w * stw.w * rel.w
... (sizeLine, inside buildPlan) const byLiquidity = Math.floor(x.volGate * FILLH() * GATE.capture);
    const byPart = Math.floor((x.c.vol || 0) * partCap());
    const preRamp = Math.min(x.qty, byLiquidity, Math.max(0, byPart));
```

**Verifier method.** Read index.html around the horizonUnitsFor/planHorizonUnits definitions and their extraction comment; grepped all six `horizonUnits` occurrences; read candidateFor's return object; read planPoolSortKey/planGroups; read buildPlan's sizeLine and the whole pass-1 block; read gapHoursAt/planHorizonH/FILLH/limitWindows/planCap/planQty/volGateFor/calc's volSide; read tools/probe/probe-snippet.html lines 55–200 (fixture + R72 block) and grepped every `buildPlan(` and `touchWindows` line in the probe; confirmed the suite is green via head -1 of tools/probe/out/probe-report.txt and the PASS lines for R72.1/R72.3.

**Verifier says.** The load-bearing claim is exact. `grep -n "horizonUnits" index.html` returns exactly six lines, and every consumer is a ranking/display path: `const horizonUnits = planHorizonUnits(volGate, qty);` inside candidateFor, feeding `score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * ...`, `estH: estFillH(Math.max(1, horizonUnits), c)`, the exposed field commented `/* exposed for the pool group's unweighted sort (step A.1) ... */`, and `planPoolSortKey = x => (x && x.eMargin > 0 ? x.eMargin : 0) * Math.max(1, (x && x.horizonUnits) || 1)` — whose own preamble says "The split is a RENDERING decision and stays display-only". The sizing path never calls it: `sizeLine` recomputes the expression inline as `const byLiquidity = Math.floor(x.volGate * FILLH() * GATE.capture);`. The arithmetic is confirmed from source: GATE.capture is `capture:0.15`, the fixture's `S.hour` gives volHigh=volLow=50000 so `volSide = Math.min(volHigh, volLow)` = 50000 and `vol` = 100000; `partCap()` defaults to 10/100; `planCap` = min(floor((200e6/3)/4000)=16666, 25000*limitWindows()=1). So byLiquidity=30000, byPart=10000, `preRamp = Math.min(x.qty, byLiquidity, Math.max(0, byPart))` = 10000 — byPart pins, byLiquidity is 3x clear. The M118 seed is inert at that line: the base fixture sets `DB.touchWindows = []; DB.fillHorizonH = 4;` and `gapHoursAt` returns `Math.max(1, DB.fillHorizonH || 4)` when `!scheduleOn()`, so FILLH() and DB.fillHorizonH are the identical 4. I enumerated every `buildPlan(` call in the probe (34 of them) and cross-checked against every `DB.touchWindows` assignment: no buildPlan call falls between lines 5260–5515 or 7456–7603, the only regions holding a real schedule. So the substitution changes no assertion.

**Correction to the finder.** Two small refinements, neither weakening the finding. (a) The extracted term feeds three ranking/display consumers, not just `score` — the pool sort key and `estH` (which drives the bench routing copy) also read it; "only feeds the SCORE" is narrower than the truth but in the same direction. (b) The finding's own quoted production comment shows the confusion originates in index.html, not the probe: "the term computes 30,000 units while the pick lands at 5,000" — 30,000 is byLiquidity in sizeLine, not planHorizonUnits(volGate, qty), which for gamma computes min(16666, 30000) = 16666. The author measured the sizing copy and then extracted the scoring copy.

**Proposal — NOT APPLIED.** Point `sizeLine` at the extracted term — `const byLiquidity = horizonUnitsFor(x.volGate);` — so the one function has one caller-visible definition and [R72.1]/[R72.3] genuinely cover the sizing path. Until that lands, the [R72.x] labels and the production comment above `horizonUnitsFor` should say the term feeds the SCORE, not the size, because they currently claim coverage of a path they do not touch. Separately, a funded-size assertion is needed on a fixture where byLiquidity is the pinning input (raise 1h volume so byPart > byLiquidity, and assert which input pins) — otherwise the clamped-output rule's "state WHICH INPUT PINS ITS OUTPUT" is unsatisfiable for every size assertion in the suite.

---

## 6. [MONEY-PATH] The seed/caution ONE-SLOT cap has no assertion at all, while REQUIREMENTS R7.3 cites [R7.3] as verifying it

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** Absent guard — no assertion exists (adjacent to 8, label/requirement overclaims coverage)
- **Assertion:** [R7.3] pump caution caps the plan line half-sized with the reason inline  (and its siblings — none of them touch the slot cap)
- **Condition:** `!!pPump && pPump.caution && pPump.caution.key === "pump" && !pPump.cautionProven && (pPump.sizeNotes || []).some(s => /half-sized: SUSPECTED PUMP/.test(s))`

**Evidence.**

grep over the whole probe for `catSlots`, `seedSlots`, `blockedSeed`, `slot until proven` and `whyKey` returns nothing for the seed limb — the only two `whyKey` assertions are `nuP.whyKey === "cluster"` and `nuR.whyKey === "budget"`. REQUIREMENTS.md R7.3 nevertheless reads "seed-style caution cap in the plan (half-size, **one slot**, wins never graduate it while flagged)" with `probe [R7.3]` in the verification column, and the pairing check passes because the TAG exists — so the row reports coverage for a limb nothing asserts. The fixture does reach the branch (in the [R70.2] block both 9051 and 9070 carry `caution.key === "pump"` unproven, so the second is slot-blocked) but [R70.2] deliberately searches every bucket — "a pump-flagged candidate may legitimately land in picks, bench, nextUp or qualifying ... which one it lands in is not the property under test" — so raising `GATE.seedSlots` to 99 leaves it green.

**Production cited.**

```js
const catSlots = {};    // one funded slot per caution category (unproven items only)
...
    const blockedSeed = rawCaution && (catSlots[x.caution.key] || 0) >= GATE.seedSlots;
...
           : blockedSeed ? x.caution.label + " category: only " + GATE.seedSlots + " slot until proven, already used"
...
    if (rawCaution) catSlots[x.caution.key] = (catSlots[x.caution.key] || 0) + 1;
```

**Verifier method.** Grepped the probe for catSlots/seedSlots/blockedSeed/'slot until proven'/whyKey (2 hits, both unrelated); read probe lines 1860–2030 (the entire R7 pump block) and every [R7.3] assertion body; read index.html's blockedSeed/catSlots/GATE.seedSlots lines and the nextUp whyKey ternary; read REQUIREMENTS.md line 54; read tools/probe/reqpair.sh lines 1–60 to confirm the pairing check's ID grain.

**Verifier says.** `grep -n "catSlots|seedSlots|blockedSeed|slot until proven|whyKey" tools/probe/probe-snippet.html` returns exactly two lines, both about other limbs: `nuP.whyKey === "cluster" && nuP.whyClusterId === 1` and `!!nuR && nuR.whyKey === "budget"`. Nothing asserts `blockedSeed`, `GATE.seedSlots` (defined as `seedSizeFactor:0.5, seedSlots:1`), the `catSlots` accumulator, or the nextUp reason `x.caution.label + " category: only " + GATE.seedSlots + " slot until proven, already used"`. I read all eight [R7.3]-tagged assertions: three test `suspectedPump()`, one the half-size NOTE, one the half-size ARITHMETIC (`pPump.allocQty === Math.max(1, Math.floor(qPumpOff / 2))`), one that wins don't graduate, one sleeve refusal, one dismissal. None touches the slot. REQUIREMENTS.md row R7.3 reads "seed-style caution cap in the plan (half-size, **one slot**, wins never graduate it while flagged)" with `probe [R7.3]` in the verification column, and tools/probe/reqpair.sh matches at ID grain — its CLAIMED set is `grep -oE '^REQ (PASS|FAIL) R[0-9]+\.[0-9]+[a-z]?$'` — so one passing [R7.3] assertion satisfies the row for every limb it names.

**Correction to the finder.** One sub-claim I could not confirm without running the suite: that the [R70.2] fixture actually REACHES blockedSeed (9051 funding first, 9070 slot-blocked second). That depends on both surviving the gate chain to the picks.push, which I cannot establish by reading alone. It does not affect the verdict — the finding is that no assertion exists, and that is established by grep — but it does affect the remedy: if the branch is not in fact reached, the fix needs a fixture as well as an assertion.

**Proposal — NOT APPLIED.** Add an assertion on a two-item same-category fixture: the first cautioned item funds, the second lands in nextUp with `whyKey === "seed"` and the copy naming `GATE.seedSlots`; and a discriminating partner showing a PROVEN-caution item is not slot-blocked. Removing a slot cap widens what the allocator may fund, so this is deployment-class and belongs under the [R7.3] tag the requirement already cites.

---

## 7. [MONEY-PATH] T2_MAX_CONCURRENT — the tier-2 concurrency cap — has no assertion, and no fixture ever reaches it

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** Absent guard — no assertion exists; the one funded T2 item runs 1 of 3 against the cap
- **Assertion:** (none — grep for T2_MAX_CONCURRENT / t2cap / "tier-2 concurrency" over tools/probe/probe-snippet.html returns zero hits)
- **Condition:** `n/a`

**Evidence.**

The only T2 items in the suite are 9020 ("Probe theta", buy 8000 — always benched to nextUp behind `DB.t2Budget = 0`, asserted with `whyKey === "budget"`) and the exception-lane pair 9320/9321 (buy 20000). At most two T2 lines are ever live, against a cap of 3, and `DB.positions` never holds a T2 item when a plan is built. Deleting `blockedT2` from the `if (full_ || blockedSeed || blockedT2 || ...)` chain, or raising the constant, turns nothing red. The `t2Live` counter's own limb (counting LIVE T2 POSITIONS before any new line is funded — the seam between the positions store and the allocator) is likewise never exercised, since no fixture holds a T2 position.

**Production cited.**

```js
const T2_MAX_CONCURRENT = 3;   // live tier-2 items at once (positions + funded picks)
...
  let t2Live = new Set(DB.positions.filter(p => itemTier(p.itemId, calc(p.itemId)).t === 2).map(p => p.itemId)).size;
...
    const blockedT2 = x.tier.t === 2 && t2Live >= T2_MAX_CONCURRENT;
...
           : blockedT2 ? "tier-2 concurrency cap — " + T2_MAX_CONCURRENT + " live T2 items already (ramp rule)"
```

**Verifier method.** Grepped both files for the four identifiers (zero probe hits); read index.html's TIER1_MIN/TIER1_MAX/TIER2_MAX, tierFromPrice, itemTier, the t2Live initialiser, blockedT2, the whyKey ternary and `if (x.tier.t === 2) t2Live++`; read the probe's 9020 fixture (lines 772–790) and the 9320/9321 exception-lane fixture (lines 3913–3930); enumerated all 12 `DB.positions = [{` assignments in the probe.

**Verifier says.** `grep -n "T2_MAX_CONCURRENT|t2Live|blockedT2|t2cap" index.html tools/probe/probe-snippet.html` returns eight index.html hits and ZERO probe hits. Production: `const T2_MAX_CONCURRENT = 3;`, `let t2Live = new Set(DB.positions.filter(p => itemTier(p.itemId, calc(p.itemId)).t === 2).map(p => p.itemId)).size;`, `const blockedT2 = x.tier.t === 2 && t2Live >= T2_MAX_CONCURRENT;`. Tier is `(px > TIER1_MAX && px <= TIER2_MAX) ? 2` with `TIER1_MAX = 5_000`, so a probe item is T2 only if calc's buy exceeds 5000: 9020 "Probe theta" (`S.latest[9020] = { high: 8800, low: 8000 ... }`) and 9320/9321 (`S.latest[id] = { high: 20100, low: 20000 ... }`). 9020 appears in `DB.watch = [{id:9003,qty:null},{id:9020,qty:null}]` in a block that also sets `DB.t2Budget = 0`; 9320/9321 are the exception-lane pair. I enumerated every `DB.positions = [{` fixture in the probe: itemIds are 9001 and 9002 only, and itemTier reads `c.buy` from calc (live price 4000), not the position's stored `buy: 27000` — so t2Live is 0 in every plan. With at most 2 T2 candidates and t2Live starting at 0, `t2Live >= 3` cannot become true.

**Correction to the finder.** One strengthening correction to the finder's arithmetic: even a plan holding three T2 candidates would not fire the guard, because t2Live is incremented only AFTER a T2 line is funded (`if (x.tier.t === 2) t2Live++`), so `t2Live >= 3` needs a fourth T2 candidate or a pre-existing T2 position. The bar is higher than '2 against a cap of 3' suggests.

**Proposal — NOT APPLIED.** Fixture three T2 passers plus one T2 open position and assert (a) the fourth lands in nextUp with `whyKey === "t2cap"` and the copy naming the constant, and (b) the held position alone consumes a slot — that second half is the seam `t2Live` exists for and is the part a picks-only fixture cannot see.

---

## 8. [MONEY-PATH] committed() is inert on the plan: `pools` is pinned by the tier budgets in every fixture, and [R16.1] exercises only the quote-leg limb

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** 3 clamp absorption (Math.min(t1Budget, deployable) — t1Budget pins) + untested limb
- **Assertion:** [R16.1] committed() counts the unfilled quote buy leg at cost
- **Condition:** `committed() === 80 * 4000`

**Evidence.**

Two separate holes. (a) The assertion runs with `DB.positions = []` (set two lines above it in the same block), so `DB.positions.reduce(...)` contributes 0 — deleting the positions limb entirely leaves `committed() === 320000` and the assertion green. The label says "counts the unfilled quote buy leg", which is honest about what it tests, but no other assertion in the suite calls `committed()` at all. (b) The plan-level effect is absorbed: workingStack is 200e6, the largest `committed()` any fixture produces is the cluster block's 4000 x 4000 = 16e6, so deployable = 200e6 - 16e6 - 3e6 = 181e6, while t1Budget + t2Budget = 150e6. `Math.min(t1Budget, deployable)` is pinned by t1Budget by a 31e6 margin in every plan the suite builds. `committed()` could return 0 and no asserted plan output would move. The BINDING-adjacent claim this guard was built for — "gp standing in an offer is deployed gp — the one-third rule was lying by omission" — is therefore verified only as an arithmetic identity on one watch row, never as a constraint on capital.

**Production cited.**

```js
const committed = () => DB.positions.reduce((a,p) => a + p.qty * p.buy, 0)
  + DB.watch.reduce((a,w) => {
      const qp = w.quotePlaced;
      return a + (qp ? Math.max(0, (qp.buyQty || 0) - (qp.buyFilled || 0)) * (qp.bid || 0) : 0);
    }, 0);
...
  const st = workingStack(), avail = Math.max(0, st - committed());
  const deployable = Math.max(0, avail - (DB.reserve || 0));
  const pools = { 1: Math.min(t1Budget, deployable) };
  pools[2] = Math.min(t2Budget, Math.max(0, deployable - pools[1]));
```

**Verifier method.** Read index.html's `const committed = ...` definition in full and its call sites (available(), buildPlan line 6160, three display sites); read probe lines 2405–2450 for the [R16.1] fixture and assertion; grepped the probe for `committed()` (one call site), `t1Budget|t2Budget|deployable|DB.reserve`, and `available()|watchStack` (no display assertions); read the base fixture's `DB.bank = 500e6 ... DB.shadowReserve = 300e6; DB.reserve = 3e6; DB.t1Budget = 100e6; DB.t2Budget = 50e6`.

**Verifier says.** Limb (a): the probe sets `DB.positions = [];` on the line immediately preceding, then asserts `committed() === 80 * 4000` against a watch row carrying `quotePlaced: { ... bid: 4000, buyQty: 100, buyFilled: 20 ... }`. (100−20)×4000 = 320000 comes entirely from the watch reduce; `DB.positions.reduce((a,p) => a + p.qty * p.buy, 0)` contributes 0, so deleting that limb leaves the assertion green. It is the only `committed()` call in the whole probe. Limb (b): `const st = workingStack(), avail = Math.max(0, st - committed()); const deployable = Math.max(0, avail - (DB.reserve || 0)); const pools = { 1: Math.min(t1Budget, deployable) }; pools[2] = Math.min(t2Budget, Math.max(0, deployable - pools[1]));`. workingStack = 500e6 bank − 300e6 shadowReserve = 200e6; the largest committed() any plan fixture produces is the 4000×4000 = 16e6 position at probe line 188; deployable = 200e6 − 16e6 − 3e6 = 181e6 against t1Budget = 100e6. `Math.min(t1Budget, deployable)` is pinned by t1Budget by 81e6, and pools[2] = min(50e6, 81e6) is pinned by t2Budget. The one block that varies a budget sets `DB.t2Budget = 0`, which pins harder still. committed() could return 0 and no asserted plan output would move.

**Correction to the finder.** The label is not overclaiming — "[R16.1] committed() counts the unfilled quote buy leg at cost" names exactly the limb it tests, and it does bite for that limb. The defect is a coverage gap plus clamp absorption at the plan level, not a false label. Also worth noting for the remedy: `migrateQuoteCommit()` re-implements the quote-leg sum independently of `committed()`, so the [R16.1] migration assertion's `/320000 gp/` match would survive a defect in committed() too.

**Proposal — NOT APPLIED.** Two assertions. First, extend [R16.1]'s fixture to hold a position AND a standing quote leg so both limbs contribute and the sum discriminates. Second, a plan-level assertion with committed() driven above `workingStack - reserve - 150e6` (e.g. bank 200e6 with a 60e6 position), asserting that `deployable` — and therefore `pools[1]` — falls below t1Budget and the funded sizes shrink. Without the second, the tier budgets absorb the guard.

---

## 9. [MONEY-PATH] The T2 ramp (one-third size) is asserted nowhere; the unproven-T1 half is asserted only incidentally by a label that names neither

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** Absent guard for the T2 limb; 8 label overclaims for the T1 limb (the one assertion covering it names a different cap)
- **Assertion:** [R26.2] the probation grant HALVES the size — asserted on the factor, with no clamp in the way
- **Condition:** `applySizeFactors(1000, { exception: { status: "active", gate: "g", trips: 0 }, tier: T1P }, false).cap === 500 && applySizeFactors(1000, { exception: { status: "waived", gate: "g" }, tier: T1P }, false).cap === 1000 && applySizeFactors(1, { exception: { status: "active", gate: "g", trips: 0 }, tier: T1P }, false).cap === 1     // where const T1P = { t: 1, proven: true }`

**Evidence.**

`applySizeFactors` carries four capital-shrinking factors. The caution half is covered end-to-end ([R7.3] with/without comparison) and the probation half at the term ([R26.2]) — but every [R26.2] call passes `T1P = { t: 1, proven: true }`, which is precisely the tier shape that makes BOTH ramp limbs dead for that call. grep over the probe for `unproven`, `T2 ramp`, `tierProven`, `itemTier`, `tierFromPrice` returns zero hits. The T1-unproven limb survives only by accident: gamma's `allocQty === 5000` is byPart 10000 halved by it, so deleting it makes gamma 5357 (then poured to 10000) and turns that assertion red — but the assertion's label is "item outside the cluster cap lands at the PER-ITEM cap", which names neither the participation cap nor the tier ramp, so the coverage is invisible and one fixture edit would silently remove it. The T2 limb has no such accident: the only funded T2 items are 9320/9321 in the exception lane, and the assertion there (`pick26.sizeNotes.some(s => /PROBATIONARY EXCEPTION/.test(s))`) checks a note, not a size, so `cap / 3` can be deleted with the suite green.

**Production cited.**

```js
  if (x.tier.t === 1 && !x.tier.proven){ cap = Math.floor(cap * 0.5); notes.push("unproven T1 — half size until 2 net-positive round trips"); }
  if (x.tier.t === 2 && !x.tier.proven){ cap = Math.max(0, Math.floor(cap / 3)); notes.push("T2 ramp — one-third size until 2 clean logged trips, then auto-graduates"); }
```

**Verifier method.** Read probe lines 3940–3972 (the full [R26.2] block including the T1P declaration and all four applySizeFactors calls); read index.html's applySizeFactors body in full; read tierProven/itemTier/tierFromPrice and TIER1_MIN/TIER1_MAX/TIER2_MAX; read the 9320/9321 fixture (probe 3913–3930) and every 9320/9321 assertion; grepped the probe for the six tier-ramp terms (zero hits) and for allocQty/capQty (nine hits, none on 9320/9321).

**Verifier says.** Both halves verified. `grep -n "unproven|T2 ramp|tierProven|itemTier|tierFromPrice|half size until" tools/probe/probe-snippet.html` returns ZERO hits. All four [R26.2] calls to applySizeFactors pass `const T1P = { t: 1, proven: true };`, which makes `if (x.tier.t === 1 && !x.tier.proven)` and `if (x.tier.t === 2 && !x.tier.proven)` both dead for those calls — so the assertion labelled "the probation grant HALVES the size — asserted on the factor, with no clamp in the way" exercises only the exception limb. `grep -n "allocQty|capQty"` over the probe returns nine lines and none of them names 9320 or 9321: the exception-lane assertion is `pick26.sizeNotes.some(s => /PROBATIONARY EXCEPTION/.test(s))`, a note check. 9320/9321 are the only funded T2 items (buy 20000 > TIER1_MAX 5000) and `tierProven` requires 2+ logged flips, which they lack at P26 — so `cap = Math.max(0, Math.floor(cap / 3))` executes and nothing observes its output. The T1-unproven incidental coverage checks out: gamma (9003, buy 4000, DB.flips = [] so tierProven false) has preRamp 10000 → halved to cap 5000, and `qty = Math.max(0, Math.min(cap, Math.floor(Math.min(perSlot, pool) / x.c.buy)))` with perSlot = floor(150e6/7)/4000 = 5357 gives 5000. Delete the halving and cap becomes 10000, qty 5357, then the pass-3 pour raises it toward capQty — either way ≠ 5000, so `gamma.allocQty === 5000` goes red under a label reading "item outside the cluster cap lands at the PER-ITEM cap".

**Correction to the finder.** None on substance. One precision on the incidental T1 coverage: the pour makes the exact post-deletion number uncertain (extra = min(capQty − allocQty, floor(pool / buy)) with cluster headroom), but every candidate value differs from 5000, so the bite is certain even though the reported number is not.

**Proposal — NOT APPLIED.** Extend the [R26.2] term assertions to the two ramp limbs at a known input with the same discriminating shape already used there: `applySizeFactors(1000, {tier:{t:1,proven:false}}, false).cap === 500` vs `{t:1,proven:true} === 1000`, and `{t:2,proven:false}.cap === 333` vs `{t:2,proven:true} === 1000`, plus the `Math.max(0, ...)` floor case. Also rename the gamma assertion to state its pinning input (participation cap x unproven-T1 ramp), per the clamped-output rule's qualification.

---

## 10. [MONEY-PATH] applyFamilyRule — one funded position per item family — has no assertion of any kind

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** Absent guard — no assertion exists; the fixture item names make the rule a no-op
- **Assertion:** (none — grep for applyFamilyRule / familyKey / "family overlap" over the probe returns zero hits; the [R18.1]/[R57.1] "family" assertions are the PAPER book's own family concurrency, a different mechanism)
- **Condition:** `n/a`

**Evidence.**

Every allocator fixture item is named "Probe alpha" / "Probe beta" / "Probe gamma" / "Probe theta" / "Probe except 9320", and `familyKey` normalises those to distinct strings ("probe alpha", "probe beta", ...), so `bestByFam` never holds two members and the loop is a pass-through in every plan the suite builds. Deleting the whole function body down to `return pass;` turns nothing red, and the result is that two members of one family could both be funded — the exact over-concentration the cluster cap is separately asserted against. The score-tiebreak half (`x.score > cur.score` picks the winner) is equally unexercised, so which member survives is untested.

**Production cited.**

```js
function applyFamilyRule(pass, bench){
  const bestByFam = new Map();
  for (const x of pass){
    const cur = bestByFam.get(x.fam);
    if (!cur || x.score > cur.score) bestByFam.set(x.fam, x);
  }
  ...
    else bench.push({ ...x, failed: "family overlap with " + winner.name
...
  pass = applyFamilyRule(pass, bench);
```

**Verifier method.** Grepped both files for applyFamilyRule/familyKey/'family overlap'; read the full applyFamilyRule body and familyKey's normalisation chain in index.html; grepped the probe for 'family' (30 hits) and read each to classify it as paper-book or glossary; enumerated all mkItem names and inline `n:` item names in the probe.

**Verifier says.** `grep -n "applyFamilyRule|familyKey|family overlap" tools/probe/probe-snippet.html` returns ZERO hits; the same grep on index.html returns the definition, the call `pass = applyFamilyRule(pass, bench);`, and six unrelated call sites. I checked the probe's "family" mentions individually: [R18.1] ("one shadow per family — no family is open twice, whichever stratum the slice drew"), [R57.1] ("an OPEN trip blocks its family regardless of age") and [R38.2] (glossary "family entry") are the paper book's own concurrency rule and the glossary — a different mechanism, as the finder says. I enumerated every fixture item name via `grep -on 'mkItem([0-9]*, "[^"]*"'` plus the inline `n: "Probe ..."` items and ran each mentally through familyKey's substitutions (`s.replace(/\b(?:seed|weed|leaf)\b/g, " ")` etc.): alpha/beta/gamma/delta/epsilon/zeta/theta/'sleeve item'/'sleeve second'/rungs→rung/deflated/'ranarr seed'→'probe ranarr'/gapband/widecap/'ring slice'/'except NNNN'/markout/'scorer X|Y|Z bl|W|P pump' — all distinct. So `bestByFam` never holds a contested key, `winner.id === x.id` is always true, and the `else bench.push({ ...x, failed: "family overlap with " + winner.name ... })` branch never executes in any plan the suite builds.

**Correction to the finder.** None. I would add that the score-tiebreak half is doubly unexercised — with every family a singleton, `if (!cur || x.score > cur.score)` always takes the `!cur` branch, so the comparison operator itself is never evaluated against a real rival.

**Proposal — NOT APPLIED.** Add two same-family fixture items (e.g. "Probe seed" and "Probe seeds", or a (4)/(3) dose pair) with different scores and assert: exactly one funds, it is the higher-scored one, and the loser benches with `failed` matching /^family overlap with /. One assertion covers both the rule and its tiebreak.

---

## 11. [MONEY-PATH] clusterExposure's inventory-lots limb is never exercised — every cluster fixture runs with DB.invLots empty

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** 2 fixture prevents expression
- **Assertion:** exposure math
- **Condition:** `clusterExposure(DB.clusters[0]) === 16e6`

**Evidence.**

The fixture is `DB.positions = [{ id: 1, itemId: 9001, name:"Probe alpha", qty: 4000, buy: 4000, ... }]` with `DB.invLots = []` (reset at the top of the block). 4000 x 4000 = 16e6 comes entirely from the positions loop; deleting the `DB.invLots` loop leaves the assertion at exactly 16e6. The only fixture that populates invLots alongside a cluster does not exist — the [R79.x] mm block sets `DB.invLots = [{ itemId: 9001, qty: 40, cost: 4000 }]` but with `DB.clusters` untouched from a prior block and no cluster assertion in it. Consequence: inventory held at cost would not count against a ratified basket's exposure cap, which widens what the allocator may fund inside a cluster — the same over-concentration the cap exists to prevent, by another door (and the `seen` de-dup guard against double-counting a multi-lot item is likewise untested).

**Production cited.**

```js
function clusterExposure(cl){
  let gp = 0;
  for (const p of DB.positions) if (cl.members.includes(p.itemId)) gp += p.qty * p.buy;
  const seen = new Set();
  for (const l of DB.invLots)
    if (cl.members.includes(l.itemId) && !seen.has(l.itemId)){ seen.add(l.itemId); gp += invCostGp(l.itemId); }
  return gp;
```

**Verifier method.** Read index.html's clusterExposure body in full; grepped the probe for clusterExposure (one hit, line 193) and DB.invLots (all assignments, with line numbers, to establish ordering); read probe lines 55–195 and 9236–9295 (the R79 mm block) in full.

**Verifier says.** The ordering is decisive and I checked it by line position. The base fixture at probe line 59 sets `DB.flips = []; DB.positions = []; DB.invLots = []; DB.watch = [];`. The only clusterExposure assertion is at line 193, `ok("exposure math", clusterExposure(DB.clusters[0]) === 16e6, ...)`, five lines after `DB.positions = [{ id: 1, itemId: 9001, name:"Probe alpha", qty: 4000, buy: 4000, placedAt: Date.now() }];`. DB.invLots is not repopulated until line 557 — after. So 16e6 is entirely `for (const p of DB.positions) if (cl.members.includes(p.itemId)) gp += p.qty * p.buy;` (4000×4000), and deleting the `for (const l of DB.invLots)` loop with its `seen` de-dup leaves the assertion at exactly 16e6. The one block that populates invLots against item 9001 is the R79 mm block (`DB.invLots = [{ itemId: 9001, qty: 40, cost: 4000, t: Date.now() }]`), and I read it in full: its two buildPlan calls assert the mm bench reason, no cluster assertion appears, and the item is benched from the plan by the mm rule before any cluster arithmetic could be observed.

**Correction to the finder.** None.

**Proposal — NOT APPLIED.** Add `DB.invLots` rows for a cluster member — two lots on the same item, to exercise the `seen` de-dup — to the existing exposure fixture, and assert the summed figure plus the nextUp cluster block that follows from it.

---

## 12. [MONEY-PATH] The tested-price TTL is asserted nowhere: deleting the 16h expiry from calc() leaves the suite green

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 2 — fixture prevents expression (every tested-pair fixture in the suite carries a FRESH tAt, so the expiry branch is never the deciding term)
- **Assertion:** [R74.5a] the instrument's stats ignore tested-price overrides — calc() moves, marketStatsFor does not
- **Condition:** `cTested.tested === true && cTested.buy === 3000 && stNoTest.buy === 4100 && JSON.stringify(stNoTest) === JSON.stringify(stAfter)`

**Evidence.**

Three fixtures in the whole suite set tBuy/tSell: probe line `w22.tBuy = 4000; w22.tSell = 4400; w22.tAt = now22;` (fresh, and deleted again by `delete w22.tBuy; delete w22.tSell; delete w22.tAt;`); `DB.watch = [{ id: 9741, qty: null, tBuy: 3000, tSell: 5000, tAt: Date.now() }];` (fresh); and `{ id: 930010, name: "A", tierOv: 2, qty: 5, tAt: 111, tBuy: 10, tSell: 20 }` in §93, which has no S.byId meta so calc(930010) returns null and never reaches the branch. `grep -n "TESTED_TTL" tools/probe/probe-snippet.html` returns nothing. The one place the suite exercises an expired test is testDot, and it does not compute expiry — it is HANDED the answer: `testDot({ id: 9001, tBuy: 4000, tSell: 4400, tAt: 0 }, { tested: false })`, against `function testDot(w, c){ ... : c.tested ? ... }`. The same TTL governs the proven-loser release — `const tAt = opsOf(id).tAt || (w && w.tAt) || 0; if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;` — and `grep -n "provenLoser\|recentNet\|unbench" ` finds no assertion of that branch either. Change `const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;` to `const tested = hasTest;` and a months-old operator test pair becomes price truth for margin, roi, every gate and sizing, permanently — with nothing red. This is the exact defect the Tarromin forensics comment says was already fixed once ("the old rule unbenched forever, so one test weeks ago let a proven loser resurface").

**Production cited.**

```js
const hasTest = !!(Number.isFinite(OPS.tBuy) && Number.isFinite(OPS.tSell) && OPS.tBuy > 0 && OPS.tSell > 0);
  const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;
  if (tested){ buy = OPS.tBuy; sell = OPS.tSell; }
```

**Verifier method.** Opened index.html and read `calc()` in full (the `hasTest`/`tested`/`if (tested){ buy = OPS.tBuy; sell = OPS.tSell; }` block) plus `provenLoser` and `testDot`. Ran `grep -n "TESTED_TTL" index.html tools/probe/probe-snippet.html` (4 hits, all production), `grep -n "tBuy" tools/probe/probe-snippet.html` (6 hits — lines 3363, 3397, 3661, 3662, 8424, 10474 — each read in context), `grep -n "tested" tools/probe/probe-snippet.html` (only `cTested.tested === true` reads calc's flag), `grep -n "provenLoser\|recentNet" ` in both files (probe hit is only the forbidden-token list inside [R74.2]), and `grep -n "outranks live prices\|16h\|EXPIRED" tools/probe/probe-snippet.html` (no hits). Read the §93 block 10420–10520 to confirm 930010 is never given S.byId meta and never rendered.

**Verifier says.** I traced the whole population of tested-pair fixtures and none of them can express an expiry. Production is `const tested = hasTest && (Date.now() - (OPS.tAt || 0)) < TESTED_TTL_MS;` in `calc()`. The only assertion that reads `calc().tested` is `[R74.5a]`, whose fixture is `DB.watch = [{ id: 9741, qty: null, tBuy: 3000, tSell: 5000, tAt: Date.now() }]` — a FRESH stamp, so it asserts `cTested.tested === true` and stays true with the TTL term deleted. The §22 fixture (`w22.tBuy = 4000; w22.tSell = 4400; w22.tAt = now22;`) is also fresh and is torn down (`delete w22.tBuy; …`). The §93 fixture `{ id: 930010, name: "A", tierOv: 2, qty: 5, tAt: 111, tBuy: 10, tSell: 20 }` carries a genuinely stale `tAt`, but 930010 is never registered in `S.byId` (no mkItem for it anywhere in the probe) so `calc()` returns at `const meta = S.byId.get(id); if (!meta) return null;` before reaching the branch, and nothing renders that watchlist between its assignment and the restore `DB.watch = kW93`. The one expired-state exercise is `testDot({ id: 9001, tBuy: 4000, tSell: 4400, tAt: 0 }, { tested: false })` — production's `testDot(w, c)` branches on `c.tested`, which the probe HANDS it, so no expiry is computed. The second consumer of the same constant, `provenLoser`'s `if (tAt > r.lastAt && Date.now() - tAt < TESTED_TTL_MS) return null;`, is called by nothing in the probe at all. So a seed replacing the term with `const tested = hasTest;` has no assertion positioned to see it, and its consequence is money-path: a months-old operator pair becomes price truth for margin, ROI, every market gate and sizing.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Two assertions, both at the term. (a) Extract the expiry decision — `testedNow(OPS, now)` returning {tested, ageMs} — and assert it directly at fresh, at TESTED_TTL_MS − 1ms and at TESTED_TTL_MS + 1ms, with `now` INJECTED rather than read from the clock (the sixth face: a boundary asserted against Date.now() is testing the clock). (b) One end-to-end discriminator: a watch row with tBuy/tSell and `tAt = Date.now() - TESTED_TTL_MS - 1` whose calc().buy equals the LIVE low and calc().tested === false, next to the existing fresh case, so the two are distinguished on the same fixture. Same pair for provenLoser: a losing item with a stale re-test must still bench.

---

## 13. [MONEY-PATH] [R94.2] claims one series feeds FOUR consumers including drift; production wires three fields on one surface and drift is not wired at all

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 8 — label overclaims (a universal the fixture never exercises), compounded by 4 — the third assertion composes the two functions in the probe instead of calling the production wiring
- **Assertion:** [R94.2] and when it IS ready the same readers serve the universe-wide series — one series feeding FOUR consumers (tr, vt, momentum, drift), which is the corrected scope: wiring only tr and vt would have removed the mask without feeding the two restraints under it
- **Condition:** `chartReady() === true && chartPts(1).join(",") === "1,2,3,4,5" && chartVols(1).join(",") === "7,8" && chartPts(999).length === 0`

**Evidence.**

`grep -n "chartPts\|chartVols" index.html` returns exactly three consumer lines, all inside marketStatsFor — the three quoted above. There is no fourth: drift is `stabilityWeight(sp, margin)` → `sitRisk(sp, margin)` → `const pts = ((sp && sp.pts) || []).filter(Number.isFinite);`, and its only caller is the live chain, `const sp = S.spark.get(w.id); ... const stw = stabilityWeight(sp, eMargin != null ? eMargin : 0);` — S.spark is filled by `sparkFor(id)` from `/timeseries?id=`, a per-item watchlist fetch. marketStatsFor does not return a drift field at all, and MARKET_GATE_KEYS has no drift gate (see [R84.6]: `["margin", "skew", "imbalance", "trend", "volTrend", "volFloor", "momentum"]`). The live chain's OWN tr/vt/momentum are also unwired — `const tr = sp ? trendPct(sp.pts) : null; const vt = sp ? volTrendPct(sp.vols) : null;` and `const mo = momentum(c, sp);` — which matters because the "chart still loading" mask the requirement argues about lives in that chain: `chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading");`. So the stated correction (feed the two restraints the mask hides BEFORE removing the mask) is not implemented for either restraint on the surface where the mask sits. The assertion cannot see this: its condition names only chartReady/chartPts/chartVols. The companion assertion that claims to prove the momentum half — `[R94.2] momentum reads that series through its one shared term — the correction proven at the term rather than asserted in a comment`, condition `momentumState(chartPts(1), 1).state !== null && (S.chartCache.state.ready = false, momentumState(chartPts(1), 1).state === null)` — COMPOSES chartPts and momentumState in the probe. Delete `moState: momentumState(chartPts(id), buy).state` from marketStatsFor entirely and this assertion is unmoved (only [R91.1]'s source-text check `String(marketStatsFor).indexOf("momentumState") >= 0` bites, and it bites on a substring, not on a call). Its second half is additionally a restatement of [R91.1]'s already-asserted `momentumState([], 100).state === null` composed with the already-asserted empty-when-not-ready reader. REQUIREMENTS.md R94.2 carries the same four-consumer claim in bold: "ONE SERIES FEEDS FOUR CONSUMERS — `tr`, `vt`, MOMENTUM AND DRIFT — AND THAT IS THE CORRECTION."

**Production cited.**

```js
/* CHART WIRING (step C): all four from the one universe-wide series, and
       all four return exactly what they returned before while the coverage
       gate is not ready — so this build is inert until the clock says
       otherwise. `[R76.9]`'s armed era fact goes red the moment it is. */
    tr: chartReady() ? trendPct(chartPts(id)) : null,
    vt: chartReady() ? volTrendPct(chartVols(id)) : null,
    moState: momentumState(chartPts(id), buy).state };
```

**Verifier method.** index.html: read the `marketStatsFor` body end-to-end including its return object and the CHART WIRING comment; read `sitRisk`/`stabilityWeight`; read `candidateFor` lines around `const sp = S.spark.get(w.id);` through `chk(… "chart still loading" …)`; read `chartReady/chartVols/chartPts` definitions and `chartCacheLoad`. greps: `chartPts|chartVols` (3 consumers), `stabilityWeight|function sitRisk`, `trendPct(|volTrendPct(|momentumState(|momentum(`, `MARKET_GATE_KEYS =`. probe-snippet.html: read the whole §94 block (10553–10605) and the [R91.1] block (10255–10285). REQUIREMENTS.md row R94.2 read verbatim.

**Verifier says.** `grep -n "chartPts\|chartVols" index.html` returns the two definitions, one comment, and exactly three consumer sites — all inside `marketStatsFor`: `tr: chartReady() ? trendPct(chartPts(id)) : null,` `vt: chartReady() ? volTrendPct(chartVols(id)) : null,` `moState: momentumState(chartPts(id), buy).state };`. There is no drift consumer: drift is `stabilityWeight(sp, margin)` → `sitRisk(sp, margin)`, whose first line is `const pts = ((sp && sp.pts) || []).filter(Number.isFinite);`, and its only production caller is `const stw = stabilityWeight(sp, eMargin != null ? eMargin : 0);` inside `candidateFor`, where `const sp = S.spark.get(w.id);` — the per-item `/timeseries` cache. `marketStatsFor`'s returned object (which I read in full) carries no drift field, and `MARKET_GATE_KEYS = ["roi", "margin", "skew", "imbalance", "trend", "volTrend", "volFloor", "momentum"]` has no drift gate. The live chain's own tr/vt/momentum are likewise still spark-fed (`const tr = sp ? trendPct(sp.pts) : null;`, `const vt = sp ? volTrendPct(sp.vols) : null;`, `const mo = momentum(c, sp);`), and the mask the design argument is about lives in that same chain: `chk(!(sp && sp.noData) && tr == null, "chart still loading", "no chart yet — history still loading");`. So the claim in the label and in REQUIREMENTS R94.2 ("ONE SERIES FEEDS FOUR CONSUMERS — tr, vt, MOMENTUM AND DRIFT") is false of this tree: three fields on one surface, drift zero, and the mask untouched. The assertion cannot see any of it — its condition is only `chartReady() === true && chartPts(1).join(",") === "1,2,3,4,5" && chartVols(1).join(",") === "7,8" && chartPts(999).length === 0`. The companion momentum assertion does compose in the probe: `momentumState(chartPts(1), 1).state !== null && (S.chartCache.state.ready = false, momentumState(chartPts(1), 1).state === null)` calls the two terms itself rather than reading `marketStatsFor(...).moState`.

**Correction to the finder.** One scoping point the finder already states but that must not be lost: deleting `moState: momentumState(chartPts(id), buy).state` from `marketStatsFor` DOES turn something red — `[R91.1]`'s `String(marketStatsFor).indexOf("momentumState") >= 0`. That is a source-substring check, not a behavioural one, so it survives any rewiring that keeps the identifier in the text; the finder's claim that the [R94.2] momentum assertion itself is unmoved is correct.

**Proposal — NOT APPLIED.** Either the label and the requirement row are wrong, or production is — decide which before the pool switch, because the fourth cutover prerequisite is a clock and this is the thing the clock is waiting for. If drift is meant to be fed: give marketStatsFor a drift field built from the same series (`stabilityWeight({ pts: chartPts(id) }, eMargin)`), and assert it the way momentum is claimed to be — by calling marketStatsFor(id) with a ready cache and checking the returned field changes, never by composing the two functions in the probe. If drift is deliberately deferred: strike "and drift" from the label, the requirement row and the `all four` comment, and record the deferral as a named future stage so scan 2 re-reports it. Either way the momentum assertion should read `marketStatsFor(id).moState` with the cache ready and not-ready, so deleting the wiring goes red.

---

## 14. [MONEY-PATH] The bands withhold is asserted at the extracted term but never at its call site, and the row-path bands limb is dead code that can never carry a value

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 6 — manufactured state / dead safeguard: the withhold is reachable in the assertion only through opsTierOv directly; opsOf's use of it is never exercised, and the row limb it reads has no writer anywhere
- **Assertion:** [R93.3] an override under DIFFERENT bands is withheld and flagged stale, while one with absent bands still applies — declining to apply NARROWS what the allocator may fund, which is the direction that may auto-arm
- **Condition:** `const stale = opsTierOv(2, [live[0], live[1] + 1]); const absent = opsTierOv(2, null); const match = opsTierOv(2, [live[0], live[1]]); return stale.tierOv === null && stale.stale === true && absent.tierOv === 2 && absent.stale === false && match.tierOv === 2 && match.stale === false;`

**Evidence.**

`grep -n "tierOvBands" index.html tools/probe/probe-snippet.html REQUIREMENTS.md` returns ONE line — the read quoted above. Nothing writes w.tierOvBands: the watch-row tier control writes only the value (`const next = w.tierOv == null ? 1 : ... ; if (next == null) delete w.tierOv; else w.tierOv = next;`), and the import carries only the value (`if ([0,1,2].includes(num(w.tierOv))) o.tierOv = num(w.tierOv);   // manual tier override`). So on the row path `bands` is permanently undefined → `tierBandsSame(undefined)` → null → applied. On the store path `const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;` and `const ITEM_OPS = false;`, so o is permanently null. The withhold therefore cannot fire in the product today by either limb, and no assertion calls opsOf with bands present — [R93.1] sets DB.itemOps but proves the flag-off path (`off93.tierOv === 1 && off93.qty === 7`), [R93.2] calls opsPick, [R93.4]–[R93.6] read DB.itemOps and validateImport directly. Seed `const ov = { tierOv: rawOv, stale: false };` inside opsOf — i.e. defeat the withhold entirely at the one place it is consulted — and every [R93.x] assertion stays green, because the only assertion of the property calls the extracted term rather than the caller. That is the exact inverse of the extraction the comment above opsTierOv claims to have made ("Twice in one build is the tell that the rule is EXTRACT, not re-derive"): the term was extracted and asserted, and the wire from opsOf to it was not. Direction of harm is the one the constitution singles out: an override that should be withheld instead applies, and an override WIDENS what the allocator may fund. itemTier compounds it — `grep -n "itemTier\|tierOvStale\|tierFromPrice\|tierBadge" tools/probe/probe-snippet.html` returns NOTHING, so the function that turns O.tierOv into a T1/T2 budget pool, a half-size/ramp state and the T2 concurrency cap has no assertion at all.

**Production cited.**

```js
const bands = o ? o.bands : (w ? w.tierOvBands : null);
  const rawOv = pick("tierOv");
  const ov = opsTierOv(rawOv, bands);
```

**Verifier method.** index.html: read the whole ITEM_OPS block (`ITEM_OPS`, `tierBandsNow`, `opsTierOv`, `tierBandsSame`, `opsPick`, `opsOf`, `opsSet`, `itemOpsPrune`) and `itemTier`'s first 18 lines; read the tier-override click handler at the `data-tierov` block and the `watch` branch of `validateImport`. greps: `tierOvBands|function opsOf|function opsTierOv|ITEM_OPS *=|function opsSet|function opsPick|tierBandsSame` across index.html/probe/REQUIREMENTS; `w.tierOv = |\.tierOv = |delete w.tierOv`; `itemTier|tierOvStale|tierOv` in the probe. probe-snippet.html: read §93 in full, 10420–10520.

**Verifier says.** `grep -n "tierOvBands" index.html tools/probe/probe-snippet.html REQUIREMENTS.md` returns exactly one line in the entire repo — the read `const bands = o ? o.bands : (w ? w.tierOvBands : null);` inside `opsOf`. Nothing writes it: the row control is `const next = w.tierOv == null ? 1 : w.tierOv === 1 ? 2 : w.tierOv === 2 ? 0 : null; if (next == null) delete w.tierOv; else w.tierOv = next;` (value only), and the watch import is a whitelist that carries `if ([0,1,2].includes(num(w.tierOv))) o.tierOv = num(w.tierOv);` and no bands field. The store limb is unreachable too: `const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;` against `const ITEM_OPS = false;`. So on both limbs `bands` is null/undefined, `tierBandsSame` returns null via `!Array.isArray(b) || b.length !== 2 ? null`, and `opsTierOv` applies the override with `stale: false` — the withhold cannot fire in the product today. On the assertion side, `[R93.3]` calls `opsTierOv(2, [live[0], live[1] + 1])` etc. directly; `[R93.1]` calls `opsOf(930001)` but proves the flag-OFF path (`off93.tierOv === 1 && off93.qty === 7`); `[R93.2]` calls `opsPick`; `[R93.4]`–`[R93.6]` read `DB.itemOps`/`validateImport`. No assertion anywhere reads `opsOf(...).tierOvStale` or passes bands through `opsOf`, so defeating the withhold at its one call site is invisible. And `grep -n "itemTier" tools/probe/probe-snippet.html` returns nothing — the consumer, whose `if (O.tierOvStale)` limb produces the not-applied verdict and whose `O.tierOv != null` limb sets the T1/T2 pool, has no assertion at all.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** (a) One assertion on opsOf itself with the store injected and ITEM_OPS passed as a PARAMETER — the pattern already used for poolControlsHTML in [R93.7] ("The flag is a PARAMETER of poolControlsHTML, not a const it reads") — asserting that a store row with mismatched bands yields tierOv null / tierOvStale true THROUGH opsOf, not through opsTierOv. (b) Decide the row-path limb: either give w.tierOvBands a writer and a carry, or delete `(w ? w.tierOvBands : null)` and let the row path read null explicitly — scan 13 applies, so check first that no assertion is holding the limb alive (none is, here). (c) Add at least one itemTier assertion covering the three branches: manual override applied, override withheld as stale, and price band, since the stale branch's copy is the surface where the withhold explains itself.

---

## 15. [MONEY-PATH] [R89.1]'s claim that BOTH paths are exercised is false — the armed pool branch never executes, and candidateFor is never called on a synthesised pool row

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `new-session-assertions`
- **Failure mode:** 6 (manufactured/unreached path: the assertion reaches the guarded TERM by a call path that skips the guarded BRANCH) compounded by 8 (the requirement's universal claim is exercised against zero instances)
- **Assertion:** [R89.1] with the flag OFF the pool contributes nothing — the watchlist path is bit-identical to today's, asserted by ABSENCE of any pool-stamped candidate
- **Condition:** `offPath.length === 1 && offPath[0].id === 9201 && !offPath.some(c => c.src === QUAL_SRC_POOL)`

**Evidence.**

REQUIREMENTS.md R89.1 states: "**Both paths assert:** the watchlist path is bit-identical to today's while the flag is off, and the pool path is exercised by driving the flag under a fixture, so the branch that will carry the money is not first executed on the day it carries it". The probe does the opposite and says so in its own comment: "/* The ON path, exercised through the term the flag guards rather than by mutating a const: `cutoverPoolRows` is what the branch calls ... */". `CUTOVER_POOL === false` is a const, so the `watch.concat(...)` line is dead in every run of the suite. Three things on that line are therefore unexercised by anything: the `concat` composition itself, `markSrc(..., QUAL_SRC_POOL)` (nothing anywhere produces a candidate stamped `pool` — [R87.1]/[R87.4] hand-write `src: QUAL_SRC_POOL` into DB.qual rows instead), and `candidateFor({ id })` on a one-key synthesised row. That last is the load-bearing one: R89.2's stated property is "every operator overlay `candidateFor` reads off `w` — manual qty, `invTarget`, tier override, the tested pair, the admitting scanner's tier — is absent", but the assertion only inspects the ROW (`poolRows.every(r => Object.keys(r).length === 1 && r.id > 0)`); `candidateFor` is never called with such a row, and it immediately does `const { qty } = planQty(w, c);` and `provenLoser(w.id, w)` on it. Whether those return absent or invent a default on a bare `{id}` is untested, and on cutover day that path runs for every pool item.

**Production cited.**

```js
function planCandidates(){
  const watch = DB.watch.map(w => markSrc(candidateFor(w), QUAL_SRC_WATCH));
  if (!CUTOVER_POOL) return watch;
  /* ... */
  return watch.concat(cutoverPoolRows().map(p => markSrc(candidateFor(p), QUAL_SRC_POOL)));
}
```

**Verifier method.** Read tools/probe/probe-snippet.html §89 block (assertions labelled "[R89.1] CUTOVER_POOL is FALSE and pinned", "[R89.1] with the flag OFF the pool contributes nothing", "[R89.2] the pool synthesises the MINIMUM watch row") and its inline comment. Read index.html `const CUTOVER_POOL = false;`, `function cutoverPoolRows()`, `function planCandidates()`, `function candidateFor(w)`, `function planQty(w, c)`, `function provenLoser(id, w)`. Read REQUIREMENTS.md row R89.1. Grepped the probe for `markSrc`, `QUAL_SRC_POOL`, `candidateFor(`, `planCandidates(`.

**Verifier says.** The central claim holds. `const CUTOVER_POOL = false;` (index.html) is a const, and `planCandidates()` returns at `if (!CUTOVER_POOL) return watch;` on every run, so `return watch.concat(cutoverPoolRows().map(p => markSrc(candidateFor(p), QUAL_SRC_POOL)));` is dead in the whole suite. The probe's own comment admits it: "The ON path, exercised through the term the flag guards rather than by mutating a const: `cutoverPoolRows` is what the branch calls". REQUIREMENTS.md R89.1 states the opposite — "the pool path is exercised by driving the flag under a fixture, so the branch that will carry the money is not first executed on the day it carries it" — and no fixture drives the flag. Grep confirms `markSrc` appears nowhere in the probe and every `QUAL_SRC_POOL`-stamped object in the suite is hand-written into DB.qual/DB.gateLog fixtures, never produced by production. So the concat composition and the pool stamping are unexercised. CORRECTION on the sub-claim about `candidateFor({id})`: it is literally true that no probe call passes a bare `{id}`, but the exposure the finder describes is much narrower than stated. [R87.3] calls `planCandidates()` with `DB.watch = [{ id: 9105, name: "Probe stamp row" }]` — a row with no qty, no invTarget, no tierOv, no tBuy/tSell, no scoutTier — so candidateFor already runs on a near-minimal row. And the two overlay reads the finder names do not read `w` at all: `planQty` reads `const mq = opsOf(w.id).qty;`, and `provenLoser` reads `const tAt = opsOf(id).tAt || (w && w.tAt) || 0;` — explicitly `w`-guarded. The bare-`{id}` risk is therefore small; the real, verified defect is the requirement's false universal and the dead concat/markSrc line.

**Correction to the finder.** The `candidateFor` half is overstated: [R87.3] already exercises candidateFor via planCandidates on `{ id: 9105, name }`, and the overlay reads go through `opsOf(w.id)` and a `(w && w.tAt)` guard rather than off `w`, so production tolerates a bare `{id}` by construction. What is genuinely unexercised is the `watch.concat(...)` composition and `markSrc(..., QUAL_SRC_POOL)`.

**Proposal — NOT APPLIED.** PROPOSE ONLY: apply the same extraction pattern the author already used twice this build (opsPick, opsTierOv, and poolControlsHTML's `armed` parameter). Make the composition a term that takes the flag — e.g. `planCandidatesFrom(armed)` with `planCandidates = () => planCandidatesFrom(CUTOVER_POOL)` — and assert both values against the same fixture, so the concat, the pool stamp and `candidateFor` on a synthesised row all execute. Separately assert `candidateFor(cutoverPoolRows()[0])` directly and pin what each overlay reads (qty/invTarget/tierOv/tBuy/tSell/scoutTier absent, not defaulted). Would need a seed to confirm the extraction bites: delete the `markSrc(..., QUAL_SRC_POOL)` wrapper and confirm the armed assertion goes red while the off assertion stays green (the discriminating pair).

---

## 16. [CORRECTNESS] FOURTH INSTANCE (mirror shape): huntSiblings' `calm` restraint reads S.spark over S.items — for a sibling candidate the entry can never exist, so absence renders as "measured calm" and the only chart-based restraint on sibling admission is structurally inert

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `search-pattern`
- **Failure mode:** Mirror of the named pattern (a watch-populated cache read by a loop over a WIDER population), compounded by mode 1 (short-circuit: `!sp ? true` pins the conjunct) and mode 7 (stale coverage: a second, now-superseded interpreter of sitRisk). No assertion mode applies because NO ASSERTION EXISTS — this is a production finding under the named search pattern.
- **Assertion:** (none — grep of tools/probe/probe-snippet.html for /sibling|microstructure|huntSiblings|calm/ returns only [R?] seed/sibling AUTO-EXECUTION and RETIRE-prune assertions at probe lines 293, 307, 4752, 4798; nothing touches the admission predicate. Deleting `calm` from the microHit conjunction entirely would turn NOTHING red.)
- **Condition:** `n/a — no assertion asserts any condition over this term`

**Evidence.**

THE POPULATIONS ARE DISJOINT BY CONSTRUCTION. The candidate loop runs over `S.items` (~4,497 ids) and explicitly SKIPS every watchlist member (`have.has(it.i) || continue`, where `have = new Set(DB.watch.map(w => w.id))`). `S.spark` is filled by `fillSparks`, whose population is exactly `[...DB.watch.map(w => w.id), ...DB.holds.map(h => h.itemId)]`. So for the fillSparks-fed portion of the cache, `sp` is null for EVERY sibling candidate, always — the intersection is empty by the loop's own filter. `calm` is therefore `true` for every such candidate, and `microHit`'s last conjunct is pinned regardless of how volatile the item is.

IT IS NOT UNIFORMLY DEAD — WHICH IS WORSE. Two other paths write S.spark for non-watch items: `runScout` (`try { await sparkFor(x.id); } catch(e){...}`, bounded by `SCOUT_EVAL_PER_TIER = 12` per tier per cycle) and `scannerShadowScan` (`try { await sparkFor(x.id); } catch(e){}`, same bound). So `calm` binds for an arbitrary ≤~36-item-per-cycle subset selected by scanner ranking — nothing to do with drift. Two items with identical price behaviour get different admission treatment depending on whether an unrelated subsystem happened to fetch one's chart this session. Membership in the restraint is not a property of the candidate; it is an artefact of fetch order. That is the exact shape CLAUDE.md's never-fed-aggregate rule names ("Membership in a race must be a property of the CANDIDATE, evaluated once centrally, never a label individual entry paths remember to attach").

THE SECOND INTERPRETER. `!r || r.ratio <= 2` collapses sitRisk's UNKNOWN into PASS. `sitRisk` returns null on `pts.length < 24 || !(margin > 0)`. On Aug 18 2026 the user ruled exactly this collapse a defect and fixed it in `stabilityWeight` — three states, `drifty: null` for unknown — with [R91.2] asserting it ("stabilityWeight carries THREE states on drifty — null when the series is too short to read..."). The same-day momentum ruling states the principle: "the honest reader is now the ONLY reader... a future absence cannot be interpreted two ways because there is only one interpreter." `huntSiblings` is a second reader of `sitRisk` that was not swept, and it interprets the same absence the opposite way. Even WITH a spark present, a series under 24 points reads as calm.

UNBOUNDED STALENESS ON THE PATH WHERE IT DOES BIND. `S.spark.get(it.i)` here performs no TTL check. `fillSparks`/`sparkFor` gate on `Date.now() - c.at < SPARK_TTL`, but nothing refreshes a non-watch id, so on the ~0.8% of candidates where `calm` is live it is evaluated against a series of arbitrary session age with no freshness state — the long-lived-client rule, in a restraint.

WHAT IT COSTS. Sibling admission is the ONE admission path in the tool that does not require a full-gate pass: the scout top-up path fetches a spark and demands `if (cand.failed) continue;` before `DB.watch.push`, while the sibling path pushes on scanner-level sanity (`c.margin > 0`, two-sided, `volSide >= 2`) plus family/microstructure ring plus `calm`. So `calm` is the only volatility restraint at that gate, and it is unfed. Bounded by the fact that funding still passes every plan gate (the code says so at the push site) — hence `correctness`, not `money-path` — but siblings consume watch slots (`sibPerSeed` 10 / `sibTotal` 20 / `watchCap` 25), can EVICT other siblings hardest-first, and enter the plan denominator.

**Production cited.**

```js
function huntSiblings(seedId, now){
...
  const have = new Set(DB.watch.map(w => w.id));
  const cands = [];
  for (const it of S.items){
    if (!it.l || it.i === seedId || have.has(it.i) || isBlk(it.i)) continue;
...
    const sp = S.spark.get(it.i);
    const calm = !sp ? true : (() => { const r = sitRisk(sp, Math.max(1, c.margin)); return !r || r.ratio <= 2; })();
    const microHit = c.buy >= sc.buy * 0.3 && c.buy <= sc.buy * 3
      && seedFlow > 0 && flow >= seedFlow * 0.2 && flow <= seedFlow * 5
      && (c.sell - c.buy) / c.buy >= 0.10 && calm;
    if (!famHit && !microHit) continue;

[the writer of the cache it reads]
async function fillSparks(force){
  /* Watchlist first (it drives the plan), then long-term holds. */
  const ids = [...new Set([ ...DB.watch.map(w => w.id), ...DB.holds.map(h => h.itemId) ])];

[the admission it gates]
    DB.watch.push({ id: x.id, qty: null, src: "scout", sib: seedId, sibAt: now,
                    sibRing: x.ring, sibClose: x.close, addedAt: now });

[the superseded interpreter it duplicates — index.html, stabilityWeight]
  if (!r) return { w: 1, r: null, drifty: null, why: null };
```

**Verifier method.** Opened index.html and read `function huntSiblings` in full (sed -n 14320,14390p) plus its caller `for (const id of seedIds) huntSiblings(id, now);`; read `fillSparks` and `sparkFor` in full (sed -n 15035,15060p; 2755,2822p) and grepped every `S.spark` reference and every `sparkFor(` call site (4 hits: 2757 def, 8503 scannerShadowScan, 14207 runScout top-up, 15050 fillSparks); read `sitRisk` and `stabilityWeight` in full (sed -n 5225,5255p); read the scout top-up block and `const SCOUT_EVAL_PER_TIER = 12;` (sed -n 14185,14225p); read scannerShadowScan's fetch budget (sed -n 8493,8505p); grepped `DB.holds` across index.html. Opened tools/probe/probe-snippet.html and grepped /huntSiblings|sitRisk|calm|microstructure/ (zero hits), /sib/ (fixtures only), and read the [R91.2] block at 10286–10300 verbatim.

**Verifier says.** The mechanism is real and I traced every link myself. (1) The production quote is exact and in context: inside `function huntSiblings(seedId, now){` the loop is `for (const it of S.items){` with `if (!it.l || it.i === seedId || have.has(it.i) || isBlk(it.i)) continue;` where `const have = new Set(DB.watch.map(w => w.id));`, and the term is verbatim `const sp = S.spark.get(it.i);` / `const calm = !sp ? true : (() => { const r = sitRisk(sp, Math.max(1, c.margin)); return !r || r.ratio <= 2; })();`, consumed only as the final conjunct of `microHit`. (2) `fillSparks` is exactly `const ids = [...new Set([ ...DB.watch.map(w => w.id), ...DB.holds.map(h => h.itemId) ])];` — so its watch half cannot intersect the candidate loop, which skips watch members by its own filter. (3) The only other writers of S.spark are `sparkFor`, called from `runScout`'s top-up (`try { await sparkFor(x.id); } catch(e){ /* offline/miss → gate says "no chart yet" and we skip */ }`, bounded by `evaluated >= SCOUT_EVAL_PER_TIER` with `const SCOUT_EVAL_PER_TIER = 12;`) and from `scannerShadowScan` (`try { await sparkFor(x.id); } catch(e){}`, bounded by `fetches >= SCOUT_EVAL_PER_TIER`) — both over non-watch items ranked by scanner score, i.e. selection unrelated to drift. `runSiblings(now)` runs in the same cycle, after the top-up. So `calm` is fed for an incidental subset, and membership in the restraint is an artefact of fetch order rather than a property of the candidate. (4) The UNKNOWN→PASS collapse is real and is the second interpreter: `function sitRisk(sp, margin){ const pts = ((sp && sp.pts) || []).filter(Number.isFinite); if (pts.length < 24 || !(margin > 0)) return null;` and huntSiblings' `!r || r.ratio <= 2` reads that null as pass, while the swept reader `stabilityWeight` returns `{ w: 1, r: null, drifty: null, why: null }` on the same `!r`, asserted by [R91.2] (`stabilityWeight(undefined, 100).drifty === null && stabilityWeight({ pts: [1, 2, 3] }, 100).drifty === null && ...`). A `sparkFor` record with `noData: raw.length === 0` is truthy with `pts: []`, so even a present-but-empty series reads calm. (5) No TTL is checked at the read site — `sparkFor` gates on `if (c && Date.now() - c.at < SPARK_TTL) return c;` and `fillSparks` on the same, but neither ever refreshes a non-watch/non-hold id and `S.spark.delete` appears exactly once (`if (force) S.spark.delete(id);` inside fillSparks), so on the path where `calm` does bind it reads a series of arbitrary session age. (6) The no-assertion claim holds: `grep -n "huntSiblings|sitRisk|calm|microstructure" tools/probe/probe-snippet.html` returns nothing at all, and `grep -n "sib"` returns only the sibAudit/RETIRE-prune fixtures at 271–307 and DB resets at 1663/3162. Deleting `&& calm` from the `microHit` conjunction would turn nothing red.

**Correction to the finder.** Two factual corrections, neither of which kills the finding. (a) THE TITLE OVERCLAIMS AND THE FINDER'S OWN BODY CONTRADICTS IT: `calm` is NOT "structurally inert" and the spark entry CAN exist for a sibling candidate — the body says so plainly ("IT IS NOT UNIFORMLY DEAD — WHICH IS WORSE"). The accurate statement is the body's: the restraint is fed for an incidental, fetch-order-determined subset, so two items with identical drift get different admission treatment. A reader who takes the title at face value would look for a dead branch and find a live one. (b) THE FILLSPARKS INTERSECTION IS NOT EMPTY BY CONSTRUCTION: the finder writes "the intersection is empty by the loop's own filter", but fillSparks' population is watch UNION holds (`...DB.holds.map(h => h.itemId)`), and the candidate loop skips only `have.has(it.i)` where `have` is watch ids — a Shadow Fund hold that is not on the watchlist is a legal sibling candidate WITH a fillSparks-fed spark. Small population, but the claim as written is wrong. (c) Worth adding rather than correcting: `calm` gates only `microHit`; the guard is `if (!famHit && !microHit) continue;`, so a FAMILY-ring sibling is admitted with no chart restraint at all. "The only chart-based restraint on sibling admission" is true of the microstructure ring only — the family ring has none, which makes the coverage gap wider than the finding states.

**Proposal — NOT APPLIED.** PROPOSE ONLY — no edit made. (1) Route the term through the one honest interpreter: replace the inline closure with `stabilityWeight(sp, Math.max(1, c.margin)).drifty` and decide the unknown case explicitly — `drifty === true` fails, `false` passes, `null` is a stated third state. That removes the second interpreter, which is the Aug 18 momentum/drift ruling applied to the reader it missed. (2) Decide, as a ruling, what UNKNOWN should mean at sibling admission. Admitting on unknown is the restraint-lift direction (it widens what reaches the watchlist), so the conservative reading is that unknown does not satisfy `microHit`; the alternative is to fetch the spark before evaluating, as `runScout` and `scannerShadowScan` both already do (`await sparkFor(x.id)`), which makes the restraint real at a bounded API cost. (3) Whichever is ruled, the scoutLog `why` string for a microstructure-ring admission should state which of the two it was — today it says only "microstructure ring". (4) Needs a seed to confirm the inertness claim empirically: build a fixture with a high-drift sibling candidate carrying NO spark and assert it is admitted, then the same candidate WITH a 24-point drifty series and assert it is not. Both halves are needed — the discriminating pair — because the first alone cannot distinguish "calm passed it" from "calm was skipped".

---

## 17. [CORRECTNESS] [R76.2] perturbs the hash's own key list, so a constant omitted from CFG_HASH_KEYS is untested and unhashed

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-a-seam`
- **Failure mode:** 1 (the tested set is defined by the implementation under test, so the interesting case is unreachable) — self-referential fixture
- **Assertion:** [R76.2] the config hash partitions on EVERY constant — a moved constant is a new population
- **Condition:** `CFG_HASH_KEYS.every(k => cfgHash(Object.assign({}, baseCfg76, { [k]: baseCfg76[k] + 1 })) !== baseHash76)`

**Evidence.**

The label's quantifier is "EVERY constant". The assertion's quantifier is "every key the hash already iterates". Those are the same set by construction, so the assertion cannot see a constant that is in the config vector but not in `CFG_HASH_KEYS` — which is precisely the failure the property exists to prevent.

Worked deletion: remove `"skewHard"` from `CFG_HASH_KEYS`. `cfgHash` stops partitioning on it. [R76.2] iterates the remaining 9 keys, all of which still move the hash → green. [R76.1] also stays green: `skewHard` is a constant across the grid (it lives in `SCORER_BASE` and no cell varies it), so no two of the 16 cells collide and `new Set(cells76.map(c => c.hash)).size === 16` still holds, as does `cells76.length === 16`. [R76.6]'s import carry re-derives through the same shortened list → green. Nothing in the suite goes red. The same holds for `tickFloor`, `balHardLo`, `balHardHi`, `trendSoft`, `falling`, `volDecline` — 7 of the 10. (Only `roi`, `taxMult`, `volBase` are backstopped, and only accidentally, by R76.1's distinct-hash count, because those three are the ones the grid varies.)

The consequence is the one R76.2's requirement row names: "an edited config is a NEW population, never a continuation — `FILL_MODEL_V` partitioning applied at the instrument's birth." With a key missing, a ruled change to `GATE.skewHard` would leave the control cell accruing under one hash across two regimes — a pooled population wearing a partition's clothes, in the store the cutover gate reads.

The forward-looking case is the same shape and more likely: `liveMarketConfig()` gains an 11th constant and `CFG_HASH_KEYS` is not extended. Nothing anywhere asserts that the two lists agree.

**Production cited.**

```js
`const CFG_HASH_KEYS = ["roi","taxMult","tickFloor","volBase","skewHard","balHardLo","balHardHi","trendSoft","falling","volDecline"];`
`function cfgHash(cfg){`
`  const s = CFG_HASH_KEYS.map(k => k + ":" + cfg[k]).join("|");`

`const liveMarketConfig = () => ({ roi: GATE.roi, taxMult: GATE.taxMult, tickFloor: TICKF(),`
`  volBase: (DB.filtersT1 && DB.filtersT1.vol) || 1000,`
`  skewHard: GATE.skewHard, balHardLo: GATE.balHardLo, balHardHi: GATE.balHardHi,`
`  trendSoft: GATE.trendSoft, falling: GATE.falling, volDecline: GATE.volDecline });`
```

**Verifier method.** Read index.html from `const SCORER_BASE = {` through `function scorerConfigs`, matching `scorerGrid`'s two loops and the `cfgHash` body; read `validateImport`'s `scorerT2:` sanitizer block in full. Read tools/probe/probe-snippet.html §76 from `const cells76 = scorerConfigs();` through `[R76.10c]`, matching each condition. Ran `grep -n "CFG_HASH_KEYS\|skewHard\|balHardLo\|trendSoft\|volDecline" tools/probe/probe-snippet.html` — four hits total, all accounted for.

**Verifier says.** The self-reference is exact: production `const CFG_HASH_KEYS = ["roi","taxMult","tickFloor","volBase","skewHard","balHardLo","balHardHi","trendSoft","falling","volDecline"];` and `function cfgHash(cfg){ const s = CFG_HASH_KEYS.map(k => k + ":" + cfg[k]).join("|");`, and the probe's condition is `CFG_HASH_KEYS.every(k => cfgHash(Object.assign({}, baseCfg76, { [k]: baseCfg76[k] + 1 })) !== baseHash76)`. The tested set IS the implementation's set. I traced the worked deletion of `"skewHard"` through every §76 assertion: [R76.2] iterates 9 keys, all still move the hash → green. [R76.1] — `scorerGrid()` returns 15 (5 taxMult × 3 volBase) + 1 = 16 cells varying only taxMult/volBase/roi, all of which stay in the list, so the 16 hashes stay distinct; removing a key from the hash makes the control's dedup MORE likely, not less, so `cells76.length === 16` holds → green. [R76.6]/[R76.9b]/[R76.10c] — `validateImport`'s sanitizer loops the same shortened `CFG_HASH_KEYS` (`for (const k of CFG_HASH_KEYS){ const v = num(r.cfg[k]); if (v == null){ rejected++; return null; } cfg[k] = v; }`) and the probe looks the row up by `cfgHash(impCfg)`, which reads only the surviving keys → same string → green. I grepped the whole probe: `CFG_HASH_KEYS` appears only at lines 8618/8619 ([R76.2] and its debug string), and §74's `cfgA` is a hand-written literal with no link to the list. Nothing anywhere asserts that `CFG_HASH_KEYS` and `liveMarketConfig()`'s key set agree.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: add the closure check the assertion is missing — `Object.keys(liveMarketConfig()).every(k => CFG_HASH_KEYS.includes(k)) && CFG_HASH_KEYS.every(k => k in liveMarketConfig())`, and the same both-ways check against `scorerGrid()[0]`. That converts "every key I hash moves the hash" (self-referential) into "every constant in the config vector is a key I hash, and every one moves the hash" (the stated property). Seed to prove: delete `"skewHard"` from `CFG_HASH_KEYS` and confirm the current form stays green while the widened form goes red.

---

## 18. [CORRECTNESS] [R84.6] asserts outputs on two fixtures but never asserts the derivation it is named for; "exactly the failing gates" checks 2 of the 7 gates that must be absent

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-a-seam`
- **Failure mode:** 8 (label overclaims) — the label names a structural property ("the one evaluator and its derived chain") that no condition tests
- **Assertion:** [R84.6] a momentum fail keeps the fails shape it has always had — have:null — and the derived chain reports exactly the failing gates
- **Condition:** `fk84.some(f => f.g === "momentum" && f.have === null && f.need === null) && !fk84.some(f => f.g === "roi") && !fk84.some(f => f.g === "margin")`

**Evidence.**

Neither [R84.6] call links the two functions. The first calls `marketGateEval` and asserts its three-state output; the second calls `marketGateFails` and asserts its output. If `marketGateFails` were re-implemented as an independent second evaluator — the exact "re-implementation trap in production" the production comment names — both would still pass, as would [R74.1] and [R74.4], provided the second implementation agreed on these fixtures. The requirement row's fallback ("the §74 assertions continue to pin the derived chain") does not close it: every §74 assertion also reads only `marketGateFails`'s output, so it is one implementation checked twice, never the two checked against each other.

Separately the label's "exactly" is not exercised. `stK = st84(9106, 10000, 10, 1500)` with `moState = "knife"` gives, walking `marketGateEval`: roi 10 pass, margin 10000 ≥ max(3·20, 15) = 60 pass, skew 5 ≤ 60 pass, imbalance 0.5 pass, trend null unknown, volTrend null unknown, volFloor 1500 ≥ `volFloorCfg(1000,1000)` = 1000 pass, momentum FAIL. So `fk84` is length 1. The condition asserts the presence of momentum and the absence of two of the seven others, and never asserts `fk84.length === 1`. A defect that let `trend` or `volTrend` (both `unknown` here) leak into the fails list — the "unknown is not failing" rule, on the fail side — would pass this assertion.

**Production cited.**

```js
`function marketGateFails(st, cfg){`
`  return marketGateEval(st, cfg).filter(e => e.state === "fail")`
`    .map(e => ({ g: e.g, have: e.have, need: e.need }));`
`}`

REQUIREMENTS.md R84.6: "**ONE EVALUATOR OWNS THE GATE COMPARISONS** — … `marketGateFails` DERIVES from it, so a pass-value display and the fail chain cannot disagree … The §74 assertions continue to pin the derived chain"
```

**Verifier method.** Read tools/probe/probe-snippet.html §84 from `const st84 = (id, m, roi, vg) => ({...})` through the two `[R84.6]` oks, matching both conditions and the `DB.filtersT1.vol = 1000` pin at the block head. Read index.html `function marketGateEval` / `function marketGateFails` verbatim and `volFloorCfg`. Matched REQUIREMENTS.md row R84.6's fallback clause "The §74 assertions continue to pin the derived chain" by grep.

**Verifier says.** Both halves verified. The two [R84.6] calls are structurally disjoint: the first does `const ev84 = marketGateEval(stU, cfgE);` and asserts states on `ev84`; the second does `const fk84 = marketGateFails(stK, cfgE);` and asserts on `fk84`. Neither compares one function's output to the other's, and `marketGateFails` is never stringified (I grepped). So an independent re-implementation of `marketGateFails` that agreed on these fixtures — the exact "re-implementation trap in production" production's own comment names — leaves both green, as do all §74 assertions, which read only `marketGateFails`'s output. I walked `stK = st84(9106, 10000, 10, 1500)` with `moState = "knife"` against the control cfg (`DB.filtersT1.vol = 1000`, `DB.tickFloor = 15` pinned at the block head): roi 10 ≥ 1.2 pass; margin need max(3·20, 15) = 60 ≤ 10000 pass; skew 5 ≤ 60 pass; imbalance 0.5 in band pass; tr null → unknown; vt null → unknown; volFloor `volFloorCfg(1000, 1000)` = round(1000·min(1, 2)) = 1000 ≤ 1500 pass; momentum knife FAIL. So `fk84` has length 1, the condition asserts presence of momentum plus absence of 2 of the other 7, and never asserts `fk84.length === 1`.

**Correction to the finder.** One scoping caveat on the named example. The finder's illustrative defect — unknown gates leaking into the fails list, e.g. the filter becoming `!== "pass"` — does pass [R84.6] as claimed, but it does NOT leave the suite green: [R74.1]'s `outA.length === 1` runs on `st74`, which carries `tr: null, vt: null`, so those two would leak and the length would become 3 → red. The finding stands exactly as scoped ("would pass this assertion"); the structural half — nothing links `marketGateFails` to `marketGateEval` — is the load-bearing part and has no backstop anywhere.

**Proposal — NOT APPLIED.** PROPOSE ONLY: (a) assert the derivation directly with the idiom this suite already uses elsewhere — `[R91.1]` does `String(marketStatsFor).indexOf("momentumState") >= 0` — so `String(marketGateFails).indexOf("marketGateEval") >= 0`, plus a value-level cross-check over the §74 fixture grid: `marketGateFails(s,cfg)` deep-equals `marketGateEval(s,cfg).filter(e=>e.state==="fail").map(...)` for every `s` in the [R74.4] sweep. (b) Tighten "exactly" to `fk84.length === 1`. Seed to prove (a): give `marketGateFails` its own inline copy of one limb and confirm the cross-check goes red where the current conditions stay green.

---

## 19. [CORRECTNESS] [R77.1]'s fixture cannot express the plan pick the control cannot score — such picks vanish from `missing` while still counting in `picksN`, so the cutover ledger reads them as agreement

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-a-seam`
- **Failure mode:** 2 (fixture prevents expression) — both fixture items are scoreable, so the third state is unreachable in the test
- **Assertion:** [R77.1] the diff records both directions with full fail sets — control-passes-unwatched, and plan-funded-control-fails
- **Condition:** `!!rrow && JSON.stringify(rrow.extra) === "[9761]" && !!rrow.plan && rrow.plan.picksN === 1 && rrow.plan.missing.length === 1 && rrow.plan.missing[0].id === 9762 && JSON.stringify(rrow.plan.missing[0].fails.slice().sort()) === JSON.stringify(["margin", "roi"]) && rrow.extra.indexOf(9763) < 0`

**Evidence.**

`missing` is populated only inside the `S.items` loop, after `if (!st) continue`. A plan pick for which `marketStatsFor` returns null — no live two-sided book at this bucket, item absent from `S.byId` at boot, or an item the plan funded off a tested price pair while `/latest` is one-sided — is never evaluated against the control config and never recorded. It still counts in `plan.picksN`. Any reader computing agreement as `picksN − missing.length` (which is the natural read of a two-number row, and the shape the history surface classifies over) scores it as the control AGREEING with the plan, when in fact the control could not form a verdict at all.

That is the never-fed-aggregate shape inside the one ledger the cutover gate rests on, and it is the opposite of the three-state discipline the same function applies one field over — `plan: null` with `planWhy` for an unobserved plan side. There is no equivalent for an unscoreable pick.

The fixture cannot show it: items 9761 and 9762 both have full `S.latest`/`S.hour` entries, so `marketStatsFor` returns non-null for both and the `continue` branch never runs against a plan pick. The assertion's `picksN === 1 && missing.length === 1` is consistent with every pick being scoreable.

I am reporting the assertion gap; the production behaviour is the reason the gap matters. I did not run the diff against real data.

**Production cited.**

```js
`for (const it of S.items){`
`    const st = marketStatsFor(it.i);`
`    if (!st) continue;`
…
`      if (c.control && planFresh && planPicks.includes(st.id) && fails.length)`
`        missing.push({ id: st.id, fails: fails.map(f => f.g) });`

and the row written:
`    plan: planFresh ? { picksN: planPicks.length, missing } : null,`

and `marketStatsFor`'s own null path:
`  if (buy == null || sell == null || buy <= 0 || sell <= 0) return null;`
```

**Verifier method.** Read index.html `function scorerCycle` in full from `if (!S.min5At || !S.latestAt || !S.items.length) return null;` through the `rdiffAccrueSafe({...})` call, matching the `missing.push`, the `if (!st) continue`, and the `plan: planFresh ? { picksN: planPicks.length, missing } : null` lines. Read `function marketStatsFor`'s null guard and `function calc`'s tested-override branch. Read tools/probe/probe-snippet.html §76 fixture setup (`S.latest = { 9761: ..., 9762: ... }`, `S.hour = {...}`) and the `[R77.1]` / `[R77.2]` bodies.

**Verifier says.** The production quotes are real and in their guard. In `scorerCycle`: `const planPicks = Array.isArray(S.lastPlanPicks) ? S.lastPlanPicks : null;`, then `for (const it of S.items){ const st = marketStatsFor(it.i); if (!st) continue;` and only inside that loop `if (c.control && planFresh && planPicks.includes(st.id) && fails.length) missing.push({ id: st.id, fails: fails.map(f => f.g) });`. The row written is `plan: planFresh ? { picksN: planPicks.length, missing } : null` — `picksN` is the raw pick count, `missing` is filtered by scoreability. So a plan pick for which `marketStatsFor` returns null is counted in the denominator and recorded nowhere, and `picksN − missing.length` reads it as agreement. The null path is exactly as quoted: `if (buy == null || sell == null || buy <= 0 || sell <= 0) return null;` reading only `S.latest[id]`. Reachability is real: `calc()` contains `if (tested){ buy = OPS.tBuy; sell = OPS.tSell; }`, so the plan can fund off a tested pair while `S.latest` is one-sided and `marketStatsFor` returns null — the finder's named path, confirmed by reading `calc`. The fixture cannot express it: items 9761 and 9762 both have complete `S.latest` and `S.hour` entries in the §76 block, so `if (!st) continue` never fires against a plan pick, and `picksN === 1 && missing.length === 1` is consistent with all picks being scoreable.

**Correction to the finder.** Nothing to correct in the finding. One adjacent observation the finder did not make, from the same read: the `missing.push` sits BEFORE the `if (bl)` branch inside the cell loop, so a blacklisted, plan-funded, control-failing item WOULD be pushed into `missing` — while REQUIREMENTS.md R77.1 states "Blacklisted items appear in neither." The §76 fixture cannot show this either (9763 passes the control, so `fails.length` is 0). I did not chase this further; it is a separate finding, not part of the one under verification.

**Proposal — NOT APPLIED.** PROPOSE ONLY, and the production half is a ruling not a fix I may make: add a third counter to the rdiff row — `unscoreableN` (or `notScored: [ids]`) — incremented where `if (!st) continue` skips an id that is in `planPicks`, so `picksN` decomposes as compared + unscoreable and no reader can silently score an absence as agreement. Then extend the [R77.1] fixture with a fourth item that is a plan pick and has no `S.latest` entry, and assert it appears in the new field and NOT as agreement. Seed to prove: with the counter in place, remove it and confirm the extended assertion goes red.

---

## 20. [CORRECTNESS] marginNeedCfg's tick limb and its tax-exempt halving are absorbed by Math.max(byTax, byTick) in every Ring A fixture — byTax pins the output everywhere

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `ring-a-seam`
- **Failure mode:** 3 (clamp absorption) — naming the pinning input, as the qualified clamp rule requires
- **Assertion:** [R74.1] the core is config-parameterized — the same stats fail one config and pass another
- **Condition:** `outA.length === 1 && outA[0].g === "margin" && outA[0].have === 3000 && outA[0].need === 6186 && outB.length === 0`

**Evidence.**

Naming the pinning input for each Ring A fixture that reaches the margin gate:
— [R74.1] `st74` at `cfgA`: byTax = 3 × 2062 = 6186, byTick = 15. byTax pins. The asserted `need === 6186` is byTax alone. At `cfgB`, byTax = 2062, byTick = 15 — byTax pins again.
— [R74.3] item 9741: tax 85, taxMult 3 → byTax 255, byTick 15. byTax pins.
— [R84.6] `stK`: tax 20, taxMult 3 → byTax 60, byTick 15. byTax pins.
— [R76.x] fixture Y (9762): sell 4160 / buy 4100, tax ≈83 → byTax ≈249, byTick 15. byTax pins.

So across the whole ring, `byTick` is never the selected input, and `exempt` is passed `true` in exactly one place — the [R74.4] vocabulary sweep, `{ buy: 100, tax: 0, exempt: true, eMargin: 2, ... }` — where only the KEY SET is asserted (`[...emitted].every(g => MARKET_GATE_KEYS.includes(g))`), never the value. Rewriting `byTick` to `cfg.tickFloor` unconditionally (deleting the exempt halving), or to `0`, changes no Ring A output.

I have NOT established whether an out-of-ring assertion covers the exempt limb through the live chain — `[R26.1]` ("the fixture fails ONLY the ROI floor (tax-exempt: margin clears, ROI cannot)") exercises a tax-exempt item and its margin verdict now routes through `mfHas("margin")`, so it may bite on some perturbations of the halving and not others depending on that fixture's `eMargin`. That is why this is marked UNCERTAIN rather than proven inert.

**Production cited.**

```js
`function marginNeedCfg(cfg, exempt, tax){`
`  const byTax = cfg.taxMult * (tax || 0);`
`  const byTick = exempt ? Math.max(1, Math.ceil(cfg.tickFloor / 2)) : cfg.tickFloor;`
`  return { need: Math.max(byTax, byTick), byTax, byTick, limb: byTax >= byTick ? "tax" : "tick" };`
`}`
```

**Verifier method.** Read index.html `function marginNeedCfg` verbatim. Read every Ring A fixture literal in tools/probe/probe-snippet.html: `st74`/`cfgA`/`cfgB`, the 9741 `S.latest`/`S.hour` block, `st84 = (id, m, roi, vg) => ({ id, buy: 1000, sell: 1030, tax: 20, exempt: false, ...})`, the §76 `S.latest`/`S.hour` fixture, and the four-element [R74.4] sweep array. Then resolved the finder's own UNCERTAIN by reading the two out-of-ring candidates: `grep -n "tickFloor" tools/probe/probe-snippet.html` (17 hits, all save/restore or the §73 comments) and `grep -n "marginNeedFor\|marginNeedCfg\|byTick\|\.limb" tools/probe/probe-snippet.html` (four hits).

**Verifier says.** I recomputed the pinning input for every Ring A fixture reaching the margin gate and the finder's arithmetic is right in each: [R74.1] st74 at cfgA byTax = 3·2062 = 6186 vs byTick 15 (the asserted `need === 6186` is byTax alone), at cfgB byTax 2062 vs 15; [R74.3] 9741 byTax 255 vs 15; [R84.6] stK byTax 3·20 = 60 vs 15; §76 fixture Y byTax ≈ 3·83 vs 15. `exempt: true` appears in Ring A only in the [R74.4] sweep entry `{ buy: 100, tax: 0, exempt: true, eMargin: 2, ... }`, and I checked the two candidate seeds against that assertion's actual condition: deleting the halving (byTick → 15) leaves eMargin 2 < 15, margin still fails, key set unchanged; deleting byTick entirely (need → byTax = 0) makes margin pass for that one entry, but `margin` is still contributed by st74 and by the third sweep entry, so `emitted.size >= 6` (the union is 8 gates) and `[...emitted].every(g => MARKET_GATE_KEYS.includes(g))` both hold → green either way.

**Correction to the finder.** The UNCERTAIN can be closed as CONFIRMED, and the scope is wider than Ring A. [R26.1] does NOT cover the exempt halving: its fixture is `S.latest[9320] = { high: 20100, low: 20000, ... }` with `exemptIds.add(9320)`, so tax = 0, byTax = 0, byTick = ceil(15/2) = 8, eMargin = 100 — byTick IS the pinning input there, but eMargin 100 clears 8, 15 and 0 alike, so neither seed flips `cand26.fails.length === 1 && cand26.fails[0].g === "ROI floor"`. The only other margin-limb assertion is [R73.2], whose condition explicitly asserts `justUnder.limb === "tax" && justOver.limb === "tax"` — it names the tax limb as pinning in both directions by design. So no assertion in the suite exercises byTick as the selected input, and none exercises the exempt halving's value.

**Proposal — NOT APPLIED.** PROPOSE ONLY: add one assertion in §74 that names its pinning input explicitly, in the [R73.2] style already used in this suite (`justUnder.limb === "tax"`). Two fixtures: a high-tickFloor / zero-tax config where `mn.limb === "tick"` and `need === cfg.tickFloor`, and its tax-exempt twin where `need === Math.max(1, Math.ceil(cfg.tickFloor / 2))` and `limb === "tick"`. What would settle the UNCERTAIN half without any new code: seed `byTick = exempt ? cfg.tickFloor : cfg.tickFloor` (halving deleted) and read which assertions, if any, go red across the full suite.

---

## 21. [CORRECTNESS] [R76.6]'s import carry silently drops one of two file rows whose configs hash alike — no rejected++, no assertion

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `ring-a-seam`
- **Failure mode:** 2 (fixture prevents expression) — the fixture carries a single row, so collision is unreachable
- **Assertion:** [R76.6] the import carry re-derives the hash and the distinct count — a hand-edited file cannot mis-file a population
- **Condition:** `!!impCell && imp.db.scorerT2["cWRONG"] === undefined && impCell.cycles === 3 && impCell.fundedItemCycles === 4 && JSON.stringify(impCell.ids) === "[7,9]" && impCell.distinct === 2`

**Evidence.**

The stored key is discarded (`([, r])`) and the row is re-keyed by `cfgHash(cfg)` — which is the property the label names and which the assertion does prove, since `imp.db.scorerT2["cWRONG"] === undefined` goes red if production trusted the file's key. What the assertion cannot see is the other consequence of re-keying inside `Object.fromEntries`: two file rows whose sanitized configs produce the same hash collapse to one, last-write-wins, with no `rejected++` and no note. Cycle counts, funded counts, hour bands and the ids stock of the losing row are gone from the restore with nothing said. The fixture passes exactly one row, so the collision branch is unreachable.

This is a smaller consequence than a mis-filed population but it is the same family: the label says "cannot mis-file", and silent loss on restore is not covered by either half of that claim.

**Production cited.**

```js
`scorerT2: (d.scorerT2 && typeof d.scorerT2 === "object" && !Array.isArray(d.scorerT2))`
`            ? Object.fromEntries(Object.entries(d.scorerT2).map(([, r]) => {`
…
`                return [cfgHash(cfg), { v: Math.max(1, num(r.v) || 1), cfg,`
```

**Verifier method.** Read index.html's `validateImport` `scorerT2:` block in full, from `scorerT2: (d.scorerT2 && typeof d.scorerT2 === "object" && !Array.isArray(d.scorerT2))` through `.filter(Boolean))`, matching both `rejected++` sites and the `Object.fromEntries` wrapper. Read tools/probe/probe-snippet.html's `const imp = validateImport({ scorerT2: { "cWRONG": {...} } });` fixture and the `[R76.6]` condition.

**Verifier says.** The production shape is exactly as quoted and reachable: `Object.fromEntries(Object.entries(d.scorerT2).map(([, r]) => { ... return [cfgHash(cfg), {...}]; }).filter(Boolean))`. The stored key is discarded by the `([, r])` destructure, so two file entries under different stored keys whose sanitized configs produce the same hash collapse to one inside `Object.fromEntries`, last-write-wins. The `rejected++` counter fires only on the two guard paths I can see — `if (!r || typeof r !== "object" || !r.cfg || typeof r.cfg !== "object"){ rejected++; return null; }` and the missing-constant path inside `for (const k of CFG_HASH_KEYS)` — never on a collision. Cycles, funded counts, hour arrays and the losing row's ids vanish silently. The fixture passes a single row: `validateImport({ scorerT2: { "cWRONG": { ... } } })`, so the collision branch is unreachable and the assertion's four conjuncts all read one cell.

**Correction to the finder.** None. The finder is also right that the assertion's `imp.db.scorerT2["cWRONG"] === undefined` conjunct is real coverage of the re-key property itself — the finding is correctly scoped to the loss-on-collision consequence, not to the re-key claim.

**Proposal — NOT APPLIED.** PROPOSE ONLY, and the production half is a ruling: merge-or-reject on collision rather than overwrite (summing the flow counters and unioning `ids` is the arithmetically correct merge for two rows of the same population; rejecting and counting into `rejected` is the conservative one). Then extend the [R76.6] fixture with a second entry under a different stored key but an identical `cfg`, and assert whichever behaviour is ruled — never the current silent drop.

---

## 22. [CORRECTNESS] [R7.3] "recent wins never graduate a pump flag" is STILL the tautology its own fix was written about — left in place, unchanged, beside [R70.1]

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-operator-log`
- **Failure mode:** 1 (tautology / short-circuit) + 8 (label overclaims a universal)
- **Assertion:** [R7.3] recent wins never graduate a pump flag — the wins are the bait
- **Condition:** ``!!pPump && itemWins(9051) >= 3 && !pPump.cautionProven``

**Evidence.**

`pPump.cautionProven` is `cautionProvenFor(pump, cat, wins)` = `!pump && !!cat && wins >= 3`, evaluated for item 9051, name "Probe sleeve second". `cautionCat` matches only four patterns — `/\bseeds?$/i`, `/impling jar$/i`, `/^ensouled .+ head$/i`, `/^bird nest\b/i|/^crushed nest$/i` — none of which "Probe sleeve second" matches, so `!!cat` is false and `cautionProven` is false regardless of the `!pump` limb. Deleting `!pump &&` from production leaves this assertion green.

This is not my inference: production states it as fact in the comment directly above the extracted term — "Its own named assertion, '[R7.3] recent wins never graduate a pump flag — the wins are the bait', tested it on probe item 9051 'Probe sleeve second', whose name matches NONE of the four CAUTION_CATS patterns — so `!!cat` was already false and pinned the conjunction. The `!pump` term was inert. Deleting `!pump &&` from the inline expression left the ENTIRE SUITE GREEN, including that assertion." The probe repeats it: "Seed by deleting `!pump &&` from cautionProvenFor: both go red, and the old form went green."

The repair shipped [R70.1] (the term) and [R70.2] (end-to-end on 9070 "Probe ranarr seed", where `!!cat` is true) — both of which are sound and would bite. But the diagnosed-vacuous assertion was NOT removed or repointed; it still stands verbatim, still reports PASS in the report (line for [R7.3] recent wins), and still carries a universal ("never"). Under the constitution's own rule a test that cannot fail occupies the slot where a real one would go and reports the feature as covered — here it reports the pump defense as covered a second time, on top of the coverage that actually exists.

CONSEQUENCE IS BOUNDED, and I want to be honest about that: the BINDING property ("a manipulation defense never relaxes on the manipulator's chosen evidence") IS covered by [R70.1]/[R70.2]. What survives is a false coverage claim, not an unguarded money path.

**Production cited.**

```js
const cautionProvenFor = (pump, cat, wins) => !pump && !!cat && wins >= 3;
```

**Verifier method.** Grepped `R7.3|cautionProven|cautionProvenFor` in probe-snippet.html; read the §7 pump block lines 1875–2010 including the `mkItem(9051, "Probe sleeve second")` fixture at line 1206 and the `let pPump = buildPlan()…` binding; read `CAUTION_CATS`, `cautionCat`, `cautionProvenFor` and the `cautionProven:` field in `candidateFor` from index.html; grepped `recent wins never graduate` in probe-report.txt.

**Verifier says.** The assertion stands verbatim in probe-snippet.html:
    ok("[R7.3] recent wins never graduate a pump flag — the wins are the bait",
       !!pPump && itemWins(9051) >= 3 && !pPump.cautionProven, JSON.stringify({ wins: itemWins(9051) }));
and the report carries `PASS [R7.3] recent wins never graduate a pump flag — the wins are the bait`.

`pPump` is `let pPump = buildPlan().picks.find(p => p.id === 9051);` and item 9051 is created by `mkItem(9051, "Probe sleeve second")`. Production: `cautionProven: cautionProvenFor(pump, cat, wins)` with `const cautionProvenFor = (pump, cat, wins) => !pump && !!cat && wins >= 3;` and `const cautionCat = name => CAUTION_CATS.find(c => c.test(String(name).trim())) || null;`. The four `CAUTION_CATS` tests are `/\bseeds?$/i`, `/impling jar$/i`, `/^ensouled .+ head$/i`, `/^bird nest\b/i || /^crushed nest$/i`. "Probe sleeve second" matches none — `second` does not satisfy `/\bseeds?$/i` — so `cat` is null, `!!cat` is false, and `cautionProven` is false whatever `!pump` evaluates to. Deleting `!pump &&` leaves the assertion green.

This is not inference. Production states it as recorded fact in the comment immediately above the extraction: "tested it on probe item 9051 'Probe sleeve second', whose name matches NONE of the four CAUTION_CATS patterns — so `!!cat` was already false and pinned the conjunction. … Deleting `!pump &&` from the inline expression left the ENTIRE SUITE GREEN, including that assertion." The probe repeats it in the block header.

The repair is real and sound — `[R70.1]` asserts the term with five discriminating cases including `cautionProvenFor({ why: "flagged" }, { key: "seed" }, 3) === false`, and `[R70.2]` runs end-to-end on 9070 "Probe ranarr seed" where `!!cat` is true. But the diagnosed-vacuous line was never removed or repointed, and it still carries the universal "never".

The finder's own severity discipline is correct and I endorse it: the BINDING property is covered by [R70.1]/[R70.2]. What survives is a false coverage claim occupying a slot, not an unguarded money path.

**Correction to the finder.** None.

**Proposal — NOT APPLIED.** PROPOSE ONLY: either delete this assertion (its property is fully carried by [R70.1] and [R70.2]) or repoint it at 9070, the item that genuinely carries a caution category, and relabel it so it does not claim a universal the fixture cannot exercise. If it is kept for the end-to-end path on 9051, the label must state what it actually tests — that a pump-flagged item with 3 wins is not cautionProven, on an item that has no caution category, which is a weaker claim than 'wins never graduate a pump flag'. This is exactly what scan 14 (label-claim) exists to catch, and it is one of scan 14's own founding examples.

---

## 23. [CORRECTNESS] reliability() has zero assertions and manufactures a silent neutral 1.0 from an empty input — the fourth unfed weight, and the one the §91 pass did not reach

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-operator-log`
- **Failure mode:** No detector (mode 2's shape at the population level) + the never-fed-aggregate reading: a no-data weight is indistinguishable from a measured-average one
- **Assertion:** (none exists for reliability). The sibling weight DID get one: "[R91.2] stabilityWeight carries THREE states on drifty — null when the series is too short to read, false when measured and steady, true when measured and drifty". Nearest reliability-adjacent labels are "[R92.3] the two groups never interleave, tenured sorts by score and pool by the UNWEIGHTED core — a pool item's four history weights all default to 1.0, so one ranked list would place it mid-field on no evidence at all" and "[R92.3] and the pool header says the history weights are UNFED and not applied, in those words".
- **Condition:** `[R92.3]: `gs.tenured.map(x => x.id).join(",") === "3,1" && gs.pool.map(x => x.id).join(",") === "4,2" && gs.pool.every(x => x.src === QUAL_SRC_POOL) && gs.tenured.every(x => x.src !== QUAL_SRC_POOL)` — asserts planGroups, which is the RENDER grouping only.`

**Evidence.**

Production, index.html:
  const REL_WINDOW_MS = 30 * 86400e3, REL_MIN_TRIPS = 4;
  function reliability(id){
    const fl = DB.flips.filter(f => f.itemId === id && f.id >= Date.now() - REL_WINDOW_MS);
    if (fl.length < REL_MIN_TRIPS)
      return { w: 1, n: fl.length, why: fl.length ? "thin history (" + fl.length + "/" + REL_MIN_TRIPS + " trips in 30d) — reliability weight off" : null };

At n = 0 (every pool item, and every never-traded pin) this returns w = 1 AND `why: null` — no string at all. A measured item can also land on w = 1.0 exactly: `const w = Math.max(0.7, Math.min(1.3, 0.7 + 0.6 * base));` is 1.0 at base = 0.5. So never-fed and measured-average are the same two values, and the no-data case is the one that renders nothing. That is the shape §91 fixed three times (momentum's manufactured "flat", drift's `false`-for-null, the 5m streak's 0-vs-not-counted) and did not fix a fourth time here.

Where it reaches capital: `score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * (1 + Math.min(wins, 5) * 0.1) * hw.w * stw.w * rel.w`, and buildPlan orders funding on that score — `pass.sort((a,b) => (rank(a) - rank(b)) || (groupOf(a) - groupOf(b)) || (b.score - a.score));`.

I want to be precise about what is and is not a defect here. The ALLOCATOR mixing pool and pin in one score is a RULED deferral, not an oversight: index.html says so in the block above planGroups — the pool split is "a RENDER grouping only: `buildPlan` decides what is funded and at what size, and neither moves — re-ordering the allocator would be deployment-class". `planInertLine` also names four inert restraints for the pool ("momentum and drift read UNKNOWN (not steady), the 5m die-off streak is not counted for them, and the chart gates are …") and deliberately does not name the score weights. So I am NOT reporting the deferral. I am reporting two things it does not cover: (a) `reliability` has no assertion of any kind — its weight, its band, its window and its thin-history state are all unexercised, so the term could be silently broken; (b) unlike momentum and drift it has no third state, so nothing distinguishes never-fed from measured-average, and PLAN_POOL_HEADER's "NOT FED" claim is a copy assertion about a value the code cannot itself tell apart.

**Production cited.**

```js
    return { w: 1, n: fl.length, why: fl.length ? "thin history (" + fl.length + "/" + REL_MIN_TRIPS + " trips in 30d) — reliability weight off" : null };
```

**Verifier method.** Grepped `reliability|rel\.w|rel\.why|rel\.n|REL_MIN|REL_WINDOW` across index.html and probe-snippet.html; read `reliability()`, `stabilityWeight()`, the `score:` expression in `candidateFor`, `planGroups`, `PLAN_POOL_HEADER` and the `scoreReason` bits (`if (x.rel && x.rel.why) bits.push(x.rel.why);`) in index.html; read the `[R91.2]` and `[R92.3]` bodies in probe-snippet.html.

**Verifier says.** Claim (a) — no assertion — is exact. Grepping `reliability|rel\.w|REL_MIN` across probe-snippet.html returns exactly one line, and it is a copy match, not a behaviour test:
    && /wins, hour, stability, reliability/.test(PLAN_POOL_HEADER),
inside `[R92.3] and the pool header says the history weights are UNFED and not applied, in those words`. Nothing calls `reliability()`. Its band (`Math.max(0.7, Math.min(1.3, 0.7 + 0.6 * base))`), its 30-day window, its `REL_MIN_TRIPS = 4` floor, the `clean`/`wins`/`speed` composition and the thin-history state are all unexercised.

Production quote verified verbatim:
  const REL_WINDOW_MS = 30 * 86400e3, REL_MIN_TRIPS = 4;
  function reliability(id){
    const fl = DB.flips.filter(f => f.itemId === id && f.id >= Date.now() - REL_WINDOW_MS);
    if (fl.length < REL_MIN_TRIPS)
      return { w: 1, n: fl.length, why: fl.length ? "thin history (" + fl.length + "/" + REL_MIN_TRIPS + " trips in 30d) — reliability weight off" : null };

And it reaches capital: `score: failed ? 0 : eMargin * Math.max(1, horizonUnits) * (1 + Math.min(wins, 5) * 0.1) * hw.w * stw.w * rel.w`, with `buildPlan` funding on `pass.sort((a,b) => (rank(a) - rank(b)) || (groupOf(a) - groupOf(b)) || (b.score - a.score));`.

Claim (b) — no third state — holds in effect. The sibling `stabilityWeight` was given exactly this treatment with a documented three-state comment and `[R91.2]`, and `reliability` was not. `w = 1.0` occurs at `base = 0.5` for a measured item and at `n = 0`, so the weight cannot distinguish them; the whole `[R92.3]` "NOT FED" header rests on a value the code has no distinguishing field for at the point of use.

The finder's ruled-deferral disclaimer is accurate — I read the block above `planGroups` and it does say "The split is a RENDERING decision and stays display-only … Merging them, or adding a scorer term to either, is deployment-class and is not done here."

**Correction to the finder.** One precision, which softens the wording but not the finding. The returned object DOES carry a distinguishing field: `n` is 0 for never-fed and ≥4 for measured. So "nothing distinguishes never-fed from measured-average" is true of every READER but not of the value itself — I grepped `rel.w|rel.why|rel.n|x.rel` and the only two consumers are `* rel.w` in the score and `if (x.rel && x.rel.why) bits.push(x.rel.why);` in the reason line. `rel.n` is written and never read, which is separately the orphan-data rule.

**Proposal — NOT APPLIED.** PROPOSE ONLY, two parts. (1) Give reliability the [R91.2] treatment: return a third state (e.g. `fed: false` / `w: null` handled by the caller as 1.0, or at minimum a non-null `why` at n = 0 saying NOT FED rather than nothing), so never-fed and measured-average are distinguishable at the term. (2) Assert it: w === 1 and the state is NOT-FED at 0 trips; the thin-history string at 1–3 trips; and the measured band — clean/wins/speed driving w to its 0.7 and 1.3 rails and to exactly 1.0 at base 0.5, which is the case that proves the three states are needed. Both are display/ordering-class only while CUTOVER_POOL is false; neither changes what funds today. Would need seeds to confirm.

---

## 24. [CORRECTNESS] Every end-to-end seasoning assertion runs on the SUPERSEDED no-schedule fallback, because the global fixture sets DB.touchWindows = []

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-operator-log`
- **Failure mode:** 7 (stale coverage) — the assertions exercise a now-fallback code path and read its answer as the product's behaviour
- **Assertion:** "3 passes spanning 2h qualify for funding" (untagged), with the same fixture behind "first-time passer seasons instead of funding", "pass an hour apart advances the streak", "same snapshot never double-counts a pass", "failed pass resets the streak", "logged round trip waives seasoning with stated reason", "plan renders the qualifying pipeline", and the suite-wide `qualified()` helper
- **Condition:** ``plS.picks.some(p => p.id === 9001) && plS.qualifying.length === 0`, after `DB.qual[9001] = { n: 3, firstAt: Date.now() - 3 * 3600e3, lastAt: Date.now() - 1800e3 };``

**Evidence.**

The suite's global fixture sets `DB.touchWindows = []; DB.fillHorizonH = 4;`, and `const scheduleOn = () => touchWindows().length >= 2;` — so `scheduleOn()` is FALSE for the entire suite except inside §40, §57 and §61, which set a schedule and restore it. Consequently `qualGapCleared` and `qualSpanned` are only ever evaluated on their legacy limbs (`(now - lastAt) >= QUAL_GAP_MS` and `(q.lastAt - q.firstAt) >= QUAL_SPAN_MS`).

The suite's `qualified()` helper is `({ n: 3, firstAt: Date.now() - 3 * 3600e3, lastAt: Date.now() - 3600e3 })` — a 2h span inside ONE calendar day. Under the shipped default (`touchWindows: [7, 12, 17, 21.5]`, i.e. scheduleOn true) that row does NOT qualify, because the ruled rule since Aug 11 2026 is "THREE passes, AT MOST ONE PER TOUCH, SPANNING AT LEAST ONE CALENDAR DAY". So every assertion resting on `qualified()` — which is most of the allocator suite — is describing a configuration the product does not ship in.

This is not an uncovered property: [R40.4] does exercise both schedule limbs at the term (that is why the finding above matters). What is uncovered is the seasoning GATE end-to-end — the buildPlan routing `const qs = qualState(x.id); if (!qs.qualified){ if (!qex){ qualifying.push(...); continue; } notes.push(...); }` — under the rule that actually runs. Delete the `scheduleOn() ?` branch from `qualSpanned` (reverting to the pre-Aug-11 duration rule) and only [R40.4] goes red; nothing at the plan level notices.

POOL QUESTION, checked and clean: seasoning is the one restraint in this ring that does NOT go vacuous on a pool item. `updateQualStreaks` creates a `src: "pool"` row, `qualRetain` keeps it ([R87.1]/[R87.2]), `qualExemption(id, c)` returns null because a pool item has no `c.tested` (no watch row → `calc` sets no tested pair) and no `DB.flips` rows, and `x.failed` (today, "chart still loading") resets the streak each cycle. The restraint fires, harder, for pool items. No vacuous-restraint finding here.

**Production cited.**

```js
const qualSpanned = q => scheduleOn()
  ? new Date(q.firstAt).toLocaleDateString("en-CA") !== new Date(q.lastAt).toLocaleDateString("en-CA")
  : (q.lastAt - q.firstAt) >= QUAL_SPAN_MS;
…
    const qs = qualState(x.id);
    if (!qs.qualified){
      if (!qex){ qualifying.push({ ...x, qual: qs }); continue; }
```

**Verifier method.** Grepped `touchWindows` across probe-snippet.html (all 30 hits) and read each schedule-setting block to confirm save/restore; read the global fixture lines around `DB.touchWindows = []` and the `qualified()` helper; read the seasoning block in full (`first-time passer seasons instead of funding` through `plan renders the qualifying pipeline`); read `QUAL_PASSES/QUAL_SPAN_MS/QUAL_GAP_MS`, `qualGapCleared`, `qualSpanned`, `qualExemption`, `scheduleOn`, `TOUCH_DEFAULT` in index.html; read `buildPlan`'s `qs`/`qex` routing; grepped `qualState|qualSpanned|qualGapCleared|updateQualStreaks|qualRetain` across the probe to enumerate what a seed would redden.

**Verifier says.** Every factual limb checks out.

The global fixture: `DB.touchWindows = []; DB.fillHorizonH = 4;` and, four lines later, `const qualified = () => ({ n: 3, firstAt: Date.now() - 3 * 3600e3, lastAt: Date.now() - 3600e3 });`. Grepping `touchWindows` across the probe shows a schedule is set in only four places — the §72.3 sub-test, §40, §57 and §61 — each of which saves and restores. Everywhere else `scheduleOn()` is false, so `qualSpanned` and `qualGapCleared` evaluate only their legacy limbs `(q.lastAt - q.firstAt) >= QUAL_SPAN_MS` and `(now - lastAt) >= QUAL_GAP_MS`.

The fixture and condition are quoted correctly:
    DB.qual[9001] = { n: 3, firstAt: Date.now() - 3 * 3600e3, lastAt: Date.now() - 1800e3 };
    S.qualStamp = null;
    plS = buildPlan();
    ok("3 passes spanning 2h qualify for funding", plS.picks.some(p => p.id === 9001) && plS.qualifying.length === 0, …);
A 2h span inside one local date. Under the shipped default `const TOUCH_DEFAULT = [7, 12, 17, 21.5];` — which CLAUDE.md names as the default cadence — `scheduleOn()` is true and that row does NOT satisfy the calendar-day rule.

The uncovered-path claim is right too. Grepping `qualState|qualSpanned|qualGapCleared|updateQualStreaks|qualRetain` across the probe: `qualSpanned` appears at exactly two lines, both inside `[R40.4]`; `qualGapCleared` at one, in `[R40.4]`'s companion; `updateQualStreaks`/`qualRetain` only in §87, which never touches the schedule. So deleting the `scheduleOn() ?` branch from `qualSpanned` reddens `[R40.4]`'s first conjunct (`6h >= 2h` → true → `!true` → false) and nothing else — the buildPlan routing `const qs = qualState(x.id); if (!qs.qualified){ if (!qex){ qualifying.push({ ...x, qual: qs }); continue; } notes.push(…); }` is never exercised under the rule that actually ships.

The pool half is also right: `qualExemption(id, c)` returns null for a pool item (`if (c && c.tested) return …` — no watch row means `calc` sets no tested pair — and `DB.flips.some(f => f.itemId === id …)` is empty), so seasoning is not a vacuous restraint there.

**Correction to the finder.** One label correction. This is not mode 7 (stale coverage) as the case law defines it — `(q.lastAt - q.firstAt) >= QUAL_SPAN_MS` is not a vestigial path; it is the live, supported "no cadence kept" configuration, which `[R40.1]`'s own empty-schedule assertion exercises deliberately. The accurate framing is narrower and still a finding: the seasoning GATE's end-to-end coverage runs only in a non-default configuration, so the ruled calendar-day rule is asserted at the term and nowhere in the routing. That is a coverage gap, not a stale assertion reading a dead path's answer as the product's.

**Proposal — NOT APPLIED.** PROPOSE ONLY: add ONE end-to-end seasoning assertion inside a schedule-on block (the §40 pattern: set sched40(), assert, restore) — a candidate with a same-calendar-day n=3 row lands in `qualifying`, and the same candidate with a rollover row lands in `picks`. Do not change the global fixture; `DB.touchWindows = []` is load-bearing for dozens of unrelated horizon assertions, and flipping it would be the tenth face (a seed that breaks forms the fix meant to preserve). Would need a seed on the `scheduleOn() ?` branch to confirm the new assertion discriminates.

---

## 25. [CORRECTNESS] An imported exception record's `gate` is an unvalidated free-form string, and buildPlan's exception routing has no blacklist check — nothing asserts the blacklist cannot be excepted

- **Verdict:** UNCERTAIN · **Finder's bite call:** UNCERTAIN · **Scope:** `ring-b-operator-log`
- **Failure mode:** No detector + defense-in-depth gap: [R26.1] tests only the PROPOSAL path (exceptionEvidence), never the ROUTING path that actually deletes the bench
- **Assertion:** [R26.1] a red flag (blacklist) bars the lane entirely
- **Condition:** ``exceptionEvidence(9320) === null` (asserted immediately after `DB.blacklist.push(9320)`, with the preceding assertion having established `!!ev26` before the push)`

**Evidence.**

[R26.1] itself is SOUND and would bite — the preceding assertion pins pump and toxic false, so blacklisting is the only thing that changes, and deleting `isBlk(id)` from `if (suspectedPump(id) || isBlk(id) || toxicFor(id)) return null;` turns it red. I verified that before writing this.

What it does not reach is the routing. buildPlan:
    const exc = excFor(x.id);
    if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;
    …
    delete x.failed;
    x.exception = exc;
There is no check that `exc.gate` names a real gate, and none that it is not "blacklist". An exception record carrying `gate: "blacklist"` on an item whose only fail is the blacklist would have its bench deleted and fund — breaching "The blacklist is the user's alone. No automated path may admit, fund, quote, or clear an entry."

The import sanitizer accepts any string: `const id = num(e && e.id), g = String((e && e.gate) || "").slice(0, 60); if (!(id > 0) || !g || !!["active", "waived", "revoked"].includes(e.status)) return null;` — status is enumerated, gate is not, and the block's own comment is "Exception-lane records are RULINGS — they survive the carry."

I am marking this UNCERTAIN rather than claiming a live hole, and here is exactly why: through the UI it is unreachable. `grantException` takes the gate from `exceptionEvidence(id)`, which returns null for blacklisted items, and the gate is derived from `p.benchedBy` on paper trips — and blacklisted items never shadow-trade ([R25.5]'s `!st.ids.includes(9316)`), so "blacklist" can never become the modal benchedBy. I also checked the ordinary sequence — exception granted on gate G, item blacklisted afterwards — and it is safe, because `fails` then contains "blacklist" ≠ G and `every()` fails. The only route is a state-backup import carrying a hand-edited or corrupted record. That is thin, and I am not going to inflate it.

**Production cited.**

```js
    const exc = excFor(x.id);
    if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;
…
          shadowExceptions: (Array.isArray(d.shadowExceptions) ? d.shadowExceptions : []).map(e => {
            const id = num(e && e.id), g = String((e && e.gate) || "").slice(0, 60);
            if (!(id > 0) || !g || !["active", "waived", "revoked"].includes(e.status)) return null;
```

**Verifier method.** Read the §26 fixture in probe-snippet.html around `const cand26 = candidateFor({ id: 9320, qty: null })` through `DB.blacklist = DB.blacklist.filter(x => x !== 9320)`, checking which conjuncts the preceding assertion pins; read `exceptionEvidence`, `excFor`, `grantException`, `adjudicateExceptions`'s caller, and the exception routing at the top of `buildPlan` in index.html; read `shadowScan`'s `fp.nearMiss.g === "blacklist"` skip and `sliceScan`'s `if (isBlk(c.id)) continue;`; read the `shadowExceptions` mapper inside `validateImport` and traced its only caller by grepping `JSON.parse` to `$("#lFile").onchange`, then read that handler including the `confirm(msg)` guard; grepped `blacklist:` to confirm `validateImport` carries the blacklist from the same file.

**Verifier says.** Every factual limb is true and I verified each one independently; what I cannot settle by reading is whether the consequence is a defect or an accepted trust boundary.

Verified: `[R26.1]` is sound and would bite. Its fixture pins the other two conjuncts before the blacklist is added — `ok("[R26.1] the evidence bar: ≥5 trips, ≥60% fill, net-positive, ≥7 days, no red flags → proposal", !!ev26 && ev26.gate === "ROI floor", …)` — then `DB.blacklist.push(9320);` and `ok("[R26.1] a red flag (blacklist) bars the lane entirely", exceptionEvidence(9320) === null);`. Deleting `isBlk(id)` from `if (suspectedPump(id) || isBlk(id) || toxicFor(id)) return null;` turns it red.

Verified: the routing has no such check. `buildPlan`:
    const exc = excFor(x.id);
    if (!exc || !x.fails.every(f => f.g === exc.gate)) continue;
    …
    delete x.failed;
    x.exception = exc;
with `const excFor = id => (DB.shadowExceptions || []).find(e => e.id === id && e.status !== "revoked");`. A record with `gate: "blacklist"` on an item whose only fail is the blacklist would satisfy `every()` and have its bench deleted.

Verified: the sanitizer enumerates status and not gate — `const id = num(e && e.id), g = String((e && e.gate) || "").slice(0, 60); if (!(id > 0) || !g || !["active", "waived", "revoked"].includes(e.status)) return null;`.

Verified: the UI cannot produce one. `grantException` writes `gate: ev.gate` from `exceptionEvidence`, which returns null on `isBlk`; and the gate is the modal `p.benchedBy`, which cannot be "blacklist" because `shadowScan`'s watch path does `if (!fp.nearMiss || fp.nearMiss.g === "blacklist") continue;` and `sliceScan` does `if (isBlk(c.id)) continue;`. The grant-then-blacklist sequence is safe as the finder says: `fails` then contains "blacklist" ≠ G and `every()` fails.

Why UNCERTAIN rather than CONFIRMED: I traced the only reachable route and it is narrower than the finding implies. The sanitizer at issue is inside `validateImport`, reached from `$("#lFile").onchange` — the state-backup restore — which sits behind `if (!confirm(msg)) return;` and then `DB = Object.assign(DB, v.db);`. And `validateImport` restores `blacklist: [...new Set((Array.isArray(d.blacklist) ? d.blacklist : []).map(x => num(x)).filter(x => x > 0))]` from the SAME file, so the blacklist and the exception record arrive together from one user-carried, user-confirmed artefact. That is the user's own press on their own state, not an automated path — which is the exact distinction the BINDING rule turns on. Whether an unvalidated `gate` inside a confirmed self-restore counts as "an automated path clearing an entry" is a ruling, not a reading.

**Correction to the finder.** The finding's own hedge understates one thing and overstates nothing. The import route is not merely "thin" — it is a `confirm()`-gated full-state replace in which the blacklist itself is re-read from the same file, so the record and the veto it would bypass have one provenance. The assertion-coverage half stands on its own and needs no reachability argument: nothing in the suite exercises the routing path's gate name at all, and that gap is real however the reachability question is ruled. What would settle the consequence half is a user ruling on whether a confirmed self-restore is an "automated path" — not a seed.

**Proposal — NOT APPLIED.** PROPOSE ONLY, cheapest form: make the routing state its own precondition rather than inheriting it — `if (!exc || exc.gate === "blacklist" || exc.gate === "proven-loser bench" || …)`, or better, gate on membership in a named set of exceptable gates (the market gates only), since the operator gates are all non-delegable by construction. Assert it directly: an exception record with `gate: "blacklist"` on a blacklisted item leaves it benched. Optionally tighten the import to drop records whose gate is not in GATE_CHAIN_ORDER. Settling the reachability question needs a read of every writer of DB.shadowExceptions plus the state-backup round trip; I did not attempt that.

---

## 26. [CORRECTNESS] Every allocator fixture sets DB.minExpectGp = 0 believing it disables the worth-a-slot floor; production then computes a LIVE 150,000 auto-floor, and nothing asserts the floor at all

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** 2 fixture prevents expression (and a fixture whose stated intent does not match production)
- **Assertion:** (none for the floor itself — the fixture line is `DB.minExpectGp = 0; DB.clusterCapPct = 8; ...`, repeated in six allocator blocks)
- **Condition:** `n/a`

**Evidence.**

`0 > 0` is false, so the setting-override branch is skipped and the AUTO floor is live in every probe plan: effTotal = pools[1] + pools[2] = 100e6 + 50e6 = 150e6, so minExpect = max(1000, round(150e6 * 0.001)) = **150,000**, not 0. The fixture items clear it by ~20x (preRamp 10000 x eMargin ~312 = 3.12e6), so `tooSmall` is never true and neither the bench routing it drives nor its copy is ever exercised — including the soft-fill-tag branch beneath it, whose `fillGateSoftLog()` is only ever called by the probe DIRECTLY ([R50.2]), never through `buildPlan`. Two live consequences: the floor that decides whether a qualifying line is worth a slot has zero coverage, and a change to the auto formula would silently start benching fixture items and surface as failures in unrelated assertions.

**Production cited.**

```js
  const minExpect = (DB.minExpectGp > 0) ? DB.minExpectGp : Math.max(1000, Math.round(effTotal * 0.001));
...
    const tooSmall = cap > 0 && preRamp * x.eMargin < minExpect;
...
           : tooSmall ? "expected only ~" + gp(Math.round(preRamp * x.eMargin)) + "/cycle even at full size — under your "
             + gp(minExpect) + " worth-a-slot floor (Min gp/cycle in the sizing row)"
```

**Verifier method.** Read index.html's minExpect / perSlot / tooSmall lines and the whole soft-fill-tag branch including its guard; read effMargin and calc's margin1h derivation; grepped the probe for minExpect/worth-a-slot/tooSmall/'Min gp/cycle' (seven fixture lines, no assertions) and for fillGateSoftLog in both files; read the base fixture's budget lines and the `ok("fixture clears margin gates", !!c1 && c1.margin === 312 ...)` line.

**Verifier says.** The mechanical claims all hold. `const minExpect = (DB.minExpectGp > 0) ? DB.minExpectGp : Math.max(1000, Math.round(effTotal * 0.001));` — `0 > 0` is false, so with `const effTotal = pools[1] + pools[2]` = 100e6 + 50e6 the auto floor is 150,000 in every probe plan, not 0. `const tooSmall = cap > 0 && preRamp * x.eMargin < minExpect;` with preRamp 10000 and eMargin 312 (the fixture asserts `c1.margin === 312`, and margin1h from avgHigh 4400 / avgLow 4000 is the same, so `effMargin` returns 312) gives 3.12e6 — 20.8x clear, so tooSmall is never true. `grep -n "minExpect|worth-a-slot|toosmall|tooSmall|Min gp/cycle"` over the probe returns only the seven fixture assignments; nothing asserts the floor, its bench routing, its `whyKey: "toosmall"`, or its copy. And `fillGateSoftLog` appears in the probe only at [R50.2] as a direct call — its single production call site sits inside the branch beneath tooSmall.

**Correction to the finder.** Three corrections, one of which strengthens the finding. (a) The count is seven `DB.minExpectGp = 0` lines, not six. (b) "believing it disables the floor" attributes an intent I cannot verify and production documents the opposite — the comment reads "Setting overrides; auto = 0.1% of the tier pools (~150k on 150m working capital)" — so 0 meaning auto is documented behaviour, not a hidden trap; the finding stands on the coverage gap, not on the fixture author's belief. (c) STRENGTHENING: the soft-fill branch is doubly unreachable. Its guard is `if ((tooSmall || cap <= 0) && !ramped && byLiquidity < x.qty && ...)` — for gamma byLiquidity is 30000 and x.qty is 16666, so `byLiquidity < x.qty` is false regardless of the floor. Fixing minExpect alone would not reach it.

**Proposal — NOT APPLIED.** Set `DB.minExpectGp = 1` where the intent is genuinely "floor off" (or add an explicit off state), and add a floor assertion with `DB.minExpectGp` set above the fixture's `preRamp * eMargin`: the item lands in nextUp with `whyKey === "toosmall"`, the copy quotes the floor, and — the load-bearing half — a RAMPED item is judged on `preRamp` not on the ramped `cap`, which is the double-count the comment says the term exists to avoid and which nothing currently checks.

---

## 27. [CORRECTNESS] [R32.2] the circuit breaker: one conjunct is an always-truthy Promise, and all four assertions run against a breaker state the probe set by hand — sparkFor is never called

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 1 — tautology (an async IIFE returns a Promise, which is always truthy), plus 6 — manufactured state (the trip, the pause window and the banner are all written by the probe, so no production line of the breaker executes)
- **Assertion:** [R32.2] a paused breaker serves stale cached series instead of re-requesting
- **Condition:** `(async () => true)() && !!S.spark.get(9001)`

**Evidence.**

`(async () => true)()` evaluates to a Promise object, which is truthy unconditionally — this is the first face in a new costume, and the assertion reduces to `!!S.spark.get(9001)`, i.e. "the fixture cache has an entry", which is setup rather than the property. sparkFor is never invoked: `grep -n "sparkFor\|fillSparks" tools/probe/probe-snippet.html` returns nothing. The breaker's state is manufactured immediately before the assertions that read it: `S.tsFail = TS_FAIL_TRIP; S.tsPauseUntil = now32 + TS_PAUSE_MS; warn("ts", "⚠ Price-history (/timeseries) requests are failing — probe-forced.");` — so the production trip block `if (S.tsFail >= TS_FAIL_TRIP){ S.tsPauseUntil = Date.now() + TS_PAUSE_MS; warn("ts", ...) }` and the per-id negative cache `S.tsNeg.set(id, Date.now()); S.tsFail++;` and the reset `S.tsFail = 0; S.tsPauseUntil = 0; S.tsNeg.delete(id); clearWarn("ts");` are all unexecuted. Delete the entire `if (tsPaused())` branch, the failure counter and the reset from sparkFor and all four [R32.2] assertions stay green — the requirement row claims four behaviours ("failures are remembered per item id", "8 consecutive failures suspends", "serving stale cached series meanwhile", "a success resets it") and the suite exercises none of them. The stated cost of the defect this guards is "thousands of rejected requests a day, unattended, with nothing on screen".

**Production cited.**

```js
async function sparkFor(id){
  const c = S.spark.get(id);
  if (c && Date.now() - c.at < SPARK_TTL) return c;
  /* Stale-but-real data beats a repeat request while the breaker is open. */
  if (tsPaused()){
    if (c) return c;
    throw new Error("timeseries paused — " + Math.ceil((S.tsPauseUntil - Date.now()) / 60e3) + "m left");
  }
```

**Verifier method.** probe-snippet.html: read lines 4400–4415 (the four [R32.2] ok() calls plus the setup and teardown) verbatim. index.html: read the breaker comment block and `sparkFor` in full including the catch/trip/reset, and `const tsPaused = () => S.tsPauseUntil && Date.now() < S.tsPauseUntil;`. greps: `R32.2|tsPaused|tsFail|TS_FAIL_TRIP|TS_PAUSE_MS|tsNeg` in the probe; `sparkFor|fillSparks` in both files (production call sites at 8503, 14207, 15039; zero in the probe). REQUIREMENTS.md row R32.2 read verbatim.

**Verifier says.** The probe line is verbatim `ok("[R32.2] a paused breaker serves stale cached series instead of re-requesting", (async () => true)() && !!S.spark.get(9001), "cache present for 9001");`. An async IIFE returns a Promise, which is truthy unconditionally, so the condition reduces to `!!S.spark.get(9001)` — the presence of the fixture's own cache entry, i.e. setup, not the property. `grep -n "sparkFor\|fillSparks" tools/probe/probe-snippet.html` returns NOTHING, so production's `if (tsPaused()){ if (c) return c; throw new Error("timeseries paused — "…); }`, the per-id negative cache `S.tsNeg.set(id, Date.now()); S.tsFail++;`, the trip `if (S.tsFail >= TS_FAIL_TRIP){ S.tsPauseUntil = Date.now() + TS_PAUSE_MS; warn("ts", …) }` and the reset `S.tsFail = 0; S.tsPauseUntil = 0; S.tsNeg.delete(id); clearWarn("ts");` are never executed. The other three assertions read only manufactured state: the probe itself writes `S.tsFail = TS_FAIL_TRIP; S.tsPauseUntil = now32 + TS_PAUSE_MS;` and calls `warn("ts", "⚠ Price-history (/timeseries) requests are failing — probe-forced.")`, so the "VISIBLE banner" assertion is matching the probe's own string. Deleting the whole breaker from `sparkFor` leaves all four green — the only one touching production is `/Price-history fetching is paused/.test(freshnessInline())`, and `freshnessInline` reads `tsPaused()`, which is a separate one-line const unaffected by the deletion. REQUIREMENTS R32.2 claims four behaviours (per-id memory, 8-failure trip, stale-serving, success reset); none is exercised.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Point the assertions at sparkFor with the network stubbed. Replace getJSON for the duration with a rejecting stub, call sparkFor TS_FAIL_TRIP times on distinct ids, and assert the trip happened as a RESULT (tsPaused() true, warnbox banner present) rather than setting it; then with a cached id assert sparkFor resolves to the cached record without a further stub call (count the stub's invocations — that is the "instead of re-requesting" claim, which nothing currently measures); then let the stub succeed and assert tsFail/tsPauseUntil/tsNeg reset. If stubbing getJSON is impractical, extract the trip decision (`tsTrip(fails)`) and the serve decision (`tsServe(cached, pausedUntil, now)`) as terms and assert those — but the counting and the reset then still need one call-site assertion, or the wiring is uncovered exactly as in finding 3. Delete the `(async () => true)()` conjunct outright; it can never be false.

---

## 28. [CORRECTNESS] [R91.2]'s 'does not newly bench' claim is a probe-side re-derivation of the bench predicate, and its first conjunct is a tautology

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 4 — re-implementation (the probe computes `drifty && true`, which is its own copy of production's `stw.drifty && walkGapH > 24`), plus 1 — the first conjunct is true for both null and false and so cannot discriminate the states named in the label
- **Assertion:** [R91.2] and unknown never reads as not-drifty — the bench stays falsy on null (it does not newly bench), but the value is now distinguishable from a measured steady item
- **Condition:** `!(stabilityWeight(undefined, 100).drifty && true) && stabilityWeight(undefined, 100).drifty !== false && stabilityWeight(steady, 100).drifty === false`

**Evidence.**

`!(null && true)` is `!null` is true, and `!(false && true)` is also true — the conjunct passes for the null state and for the pre-fix false state alike, so it discriminates nothing the previous assertion has not already established (`stabilityWeight(undefined, 100).drifty === null`). What remains — `drifty !== false` and `steady.drifty === false` — restates that same previous assertion. The load-bearing safety claim of the whole R91.2 change is the parenthetical: the change made drifty null where it used to be false, and the argument that this benches nothing new rests entirely on production's `chk(stw.drifty && walkGapH > 24, ...)` staying falsy. That expression is never evaluated by any assertion: `grep -n "drift bench" tools/probe/probe-snippet.html` finds only `!emitted.has("drift bench")` inside [R74.4]'s forbidden-key list for the pure core, which is a different claim (that the core cannot express the gate at all). Change production to `chk(stw.drifty !== false && walkGapH > 24, ...)` — the exact mistake the null state invites, and one that newly benches every unknown-drift item after a >24h absence — and the suite is green. REQUIREMENTS R91.2 states the promise in the same probe-side form: "`chk(stw.drifty && …)` is unchanged and still falsy on null, so nothing is newly benched".

**Production cited.**

```js
chk(stw.drifty && walkGapH > 24, "drift bench",
      "drifty pick benched — your last walk-up was " + (Number.isFinite(walkGapH) ? Math.round(walkGapH) + "h" : "a long time")
```

**Verifier method.** probe-snippet.html: read the two [R91.2] ok() bodies at 10286–10300 verbatim, and [R74.4]'s block at 8395–8416 to see the one `drift bench` mention in context. index.html: read `stabilityWeight`'s three-state block including its own comment `\`chk(stw.drifty && …)\` is unchanged and still falsy on null`, and the production `chk(stw.drifty && walkGapH > 24, "drift bench", …)` with its `const walkGapH = (Date.now() - lastWalkupAt()) / 3600e3;`. REQUIREMENTS.md R91.2 read verbatim. To test the finder's 'suite stays green' half I read `lastWalkupAt()` and grepped every `DB.touchLog` assignment in the probe.

**Verifier says.** The assertion body is `!(stabilityWeight(undefined, 100).drifty && true) && stabilityWeight(undefined, 100).drifty !== false && stabilityWeight(steady, 100).drifty === false`. `!(null && true)` is true and `!(false && true)` is also true, so the first conjunct passes for the new null state and for the superseded false state alike — it discriminates nothing, and what remains restates the immediately preceding assertion (`stabilityWeight(undefined, 100).drifty === null` … `stabilityWeight(steady, 100).drifty === false`). The `&& true` is the probe's own stand-in for production's second term; production is `chk(stw.drifty && walkGapH > 24, "drift bench", …)` and no assertion evaluates that expression — `grep -n "drift bench" tools/probe/probe-snippet.html` returns one hit, `!emitted.has("drift bench")`, which is inside [R74.4]'s pure-core vocabulary check ("the core's vocabulary is exactly the config-free market keys") and is a claim that the core cannot express the gate at all, not a claim about the chain's predicate. So the load-bearing safety claim of the whole R91.2 change — the parenthetical "it does not newly bench" — is asserted against the probe's copy of the predicate rather than the product's, and a seed changing production to `chk(stw.drifty !== false && walkGapH > 24, …)` is invisible to [R91.2].

**Correction to the finder.** One qualification on the 'suite would stay green' half, which I could only partly settle by reading. The seed `drifty !== false` fires only where `walkGapH > 24`, and the probe sets `DB.touchLog = [{d: today(), m: "walkup", t: Date.now()}]` at eleven section heads, so walkGapH is ~0 through nearly the whole suite. The one place it is large is §33, where `touchLog` and `flips` are both emptied (so `lastWalkupAt()` returns 0) and `buildPlan()` runs — but §33's assertions are shape-only (`Array.isArray(P.picks) && Array.isArray(P.bench) && Array.isArray(P.nextUp)`, no-throw, no NaN), so an extra bench would not turn them red. That supports 'probably not', not certainty; the finder's own verdict is PROBABLY NOT, which is the right strength.

**Proposal — NOT APPLIED.** Assert the bench at the chain, not at the value: build a candidate with a spark series too short for sitRisk and lastWalkupAt more than 24h back, run candidateFor, and assert no fail carries g === "drift bench"; pair it with a 30-point wandering series on the same walk gap that DOES produce the bench. That pair is the discriminator the label claims — one fixture where the bench must not fire and one where it must — and it exercises production's predicate rather than a copy of it. Drop the `!(x && true)` conjunct; it is inert.

---

## 29. [CORRECTNESS] chartPts's non-empty path is only ever a probe-built Map: the archive→series inversion is unexercised, and the series it will produce carries no time index while its consumers' copy claims hours

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 2 — fixture prevents expression (the ready cache is assigned directly, so chartCacheLoad never runs) and 8 — the surrounding labels claim the wiring is proven when only the accessors are
- **Assertion:** [R94.2] while the gate is NOT ready every reader returns exactly what it returned before the wiring — an empty series — so this build is inert until the clock says otherwise, even with a populated cache sitting behind it
- **Condition:** `chartReady() === false && chartPts(1).length === 0 && chartVols(1).length === 0`

**Evidence.**

Both non-empty assertions assign the cache by hand — `S.chartCache = { at: Date.now(), state: { ready: true, state: "ready" }, pts: new Map([[1, [1,2,3,4,5]]]), vols: new Map([[1, [7,8]]]) };` — so chartCacheLoad, t0Coverage, t0Keys, t0Get and the bucket inversion above never execute in the suite. The shape is production-shaped (so this is not a manufactured-state finding against the accessors), but the CONTENT is not: an item is appended to its series only for buckets in which it appears, and t0Pack packs only the keys the bulk response carried — `function t0Pack(data){ const ks = Object.keys(data), n = ks.length; ... id[i] = +ks[i];`. There is no timestamp per point and no per-item coverage stamp, so absent buckets are silently elided and every consumer reads array INDEX as time: trendPct fits on index (`(pts || []).forEach((v, i) => { if (Number.isFinite(v)){ xs.push(i); ys.push(v); } })`) under copy that says `"7d trend " + tr.toFixed(1) + "% vs the " + GATE.falling + "% knife line"`; momentumState takes `const last4 = pts.slice(-5);            // five hourly points = four hours of range`; volTrendPct requires `vols.length < 48` and compares `vols.slice(-24)` against the rest as if the last 24 entries were the last 24 hours. The archive accrues only while the app is open, so gaps are the expected case, not the edge — and for volTrend the elision runs the wrong way by construction: an item that stops printing drops out of the buckets rather than contributing zeros, which is precisely the "volume dying is visible before price moves" signal the gate exists for. I cannot confirm from the repo how often the /1h bulk response omits a zero-volume item — that part is UNCERTAIN and would need one real archive bucket to settle — but the elision itself is visible in the code above, and nothing asserts alignment either way.

**Production cited.**

```js
const keys = (await t0Keys("h1", now - CHART_PTS_CAP * 3600e3, null)).slice(-CHART_PTS_CAP);
    const pts = new Map(), vols = new Map();
    for (const k of keys){
      const b = await t0Get("h1", k);
      if (!b || !b.id) continue;
      for (let i = 0; i < b.n; i++){
        const id = b.id[i];
        ...
        let p = pts.get(id); if (!p){ p = []; pts.set(id, p); }
        p.push(mid);
```

**Verifier method.** index.html: read the CHART WIRING comment block, `chartWireState`, `chartCacheLoad` in full (coverage read, not-ready branch, keys slice, bucket inversion, catch), `chartReady/chartVols/chartPts`, `t0Pack`, `t0Coverage`, `trendPct`, `volTrendPct`, `momentumState`. probe-snippet.html: read the §94 block 10553–10605 including both cache assignments; grepped `chartCacheLoad|chartCacheEnsure|t0Coverage|t0Keys|t0Get|t0Pack` (t0Get/t0Keys appear only in §75/§78/§86 for m5/rdiff/t1open, never for h1 chart series).

**Verifier says.** Both halves check out. (1) `grep -n "chartCacheLoad\|chartCacheEnsure\|t0Coverage" tools/probe/probe-snippet.html` returns nothing for chartCacheLoad/chartCacheEnsure, and the probe assigns the cache by hand (`S.chartCache = { at: Date.now(), state: { ready: true, state: "ready" }, pts: new Map([[1, [1,2,3,4,5]]]), vols: new Map([[1, [7,8]]]) };`), so the inversion loop `for (const k of keys){ const b = await t0Get("h1", k); … for (let i = 0; i < b.n; i++){ … p.push(mid); … v.push((b.hv[i] || 0) + (b.lv[i] || 0)); } }` and the not-ready branch `if (!st.ready){ S.chartCache = { at: now, state: st, pts: new Map(), vols: new Map() }; return; }` never execute in the suite. (2) The elision is real in the code as quoted: an item gets a point only for buckets whose packed id array contains it (`t0Pack` packs `Object.keys(data)` of the bulk response), and no timestamp or per-item coverage rides the series — while `trendPct` fits on the array index (`(pts || []).forEach((v, i) => { if (Number.isFinite(v)){ xs.push(i); ys.push(v); } })`) under copy reading `"7d trend " + tr.toFixed(1) + "% vs the " + GATE.falling + "% knife line"`, `momentumState` does `const last4 = pts.slice(-5);            // five hourly points = four hours of range`, and `volTrendPct` gates on `vols.length < 48` and compares `vols.slice(-24)` against `vols.slice(0, -24)`. Nothing asserts alignment. The finder's own UNCERTAIN — whether the /1h bulk response omits zero-volume items — is correctly left open; it would take one real archive bucket to settle.

**Correction to the finder.** The mode-2 framing overreaches on one point and it should be said plainly: the quoted assertion DOES bite for the property its own condition names. Delete the `chartReady() &&` guard from `const chartPts = id => (chartReady() && S.chartCache.pts.get(id)) || [];` and `chartPts(1).length === 0` goes red against the populated-but-not-ready cache — that is a deliberately good fixture. What is unexercised is everything upstream of the accessors (the inversion, the coverage read, the not-ready branch inside chartCacheLoad) and the index-as-time assumption downstream; the finding is a coverage-and-content gap, not a dead assertion.

**Proposal — NOT APPLIED.** Two things, separable. (1) Coverage: assert chartCacheLoad against a seeded h1 store (the [R86.1] block already writes and deletes real T0 rows by key, so the pattern exists) — three buckets, two items, one item absent from the middle bucket — and check the produced series, the CHART_PTS_CAP slice and the NaN-mid handling. Without it the whole non-empty path ships unexecuted. (2) The alignment question is a design ruling, not a test: either carry a parallel key/timestamp array per item so the consumers can measure spans and state observed coverage (the no-claim-about-unobserved-periods rule applied to a series, which the archive already honours via t0Coverage), or pin the current era's fact in a test the way [R76.9] pins `marketStatsFor().tr === null` — an assertion that chartPts returns a bare number array — so the day a time index arrives the accounting is forced. Raise it before the pool switch: it is the same class as the six-gate coverage stamp.

---

## 30. [CORRECTNESS] [R93.4]'s 'leaves the watch-row originals untouched' compares against a snapshot taken AFTER the migration it is checking

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 2 — fixture prevents expression: the baseline is captured post-hoc, so a first-pass mutation is baked into both sides of the comparison
- **Assertion:** [R93.4] the migration COPIES the four fields, skips rows with none, and LEAVES THE WATCH-ROW ORIGINALS untouched — nothing reads them twice, because opsOf is the single reader
- **Condition:** `n1 === 2 && !DB.itemOps[930011] && DB.itemOps[930012].t2Grad === 1 && DB.itemOps[930010].tierOv === 2 && DB.itemOps[930010].tSell === 20 && rowsAfter === JSON.stringify(DB.watch) && DB.watch[0].tierOv === 2 && DB.watch[0].qty === 5`

**Evidence.**

The probe's ordering is `const n1 = itemOpsMigrate(); const rowsAfter = JSON.stringify(DB.watch);` — the snapshot is taken after the first migration, so `rowsAfter === JSON.stringify(DB.watch)` at assertion time proves only that the SECOND run left the rows alone, which is the idempotence claim already asserted by the next ok(). For the first run the only row-side coverage is the two explicit reads `DB.watch[0].tierOv === 2 && DB.watch[0].qty === 5`. Seed a move rather than a copy for the tested pair — append `delete w[k]` for k in ["tBuy","tSell","tAt"] inside the loop — and every [R93.4] assertion stays green while the operator's tested pair vanishes from the row. That matters precisely because ITEM_OPS is false: the store is not read (`const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;`), so a moved tested pair is unreachable by calc from either side until the flag arms, and the requirement's stated safety property — "an interrupted migration still answers from the row" — is exactly what the assertion means to hold.

**Production cited.**

```js
function itemOpsMigrate(){
  if (DB.itemOpsV1) return 0;
  ...
    const r = { src: "migrated", setAt: w.tAt || w.addedAt || Date.now() };
    for (const k of has) r[k] = w[k];
    ...
    DB.itemOps[w.id] = r;
```

**Verifier method.** probe-snippet.html: read 10472–10495 verbatim (the fixture, `const n1 = itemOpsMigrate(); const rowsAfter = JSON.stringify(DB.watch);`, the qty:42 mutation, `const n2 = itemOpsMigrate();`, and all three [R93.4] ok() bodies). index.html: read `itemOpsMigrate` in full including the `has` filter, the `DB.itemOps[w.id]` idempotence guard and the bands comment; read `opsOf`'s `const o = ITEM_OPS ? …` line and `const ITEM_OPS = false;`.

**Verifier says.** The probe's ordering is verbatim `const n1 = itemOpsMigrate();` then `const rowsAfter = JSON.stringify(DB.watch);`, and only afterwards `DB.itemOpsV1 = 0; DB.itemOps[930010].qty = 42; const n2 = itemOpsMigrate();`. So `rowsAfter === JSON.stringify(DB.watch)` inside the assertion spans the SECOND run only — which is the idempotence claim the very next `ok()` already makes (`n2 === 0 && DB.itemOps[930010].qty === 42`). For the first run, the row side is covered solely by the two explicit reads `DB.watch[0].tierOv === 2 && DB.watch[0].qty === 5`. Production copies six fields (`const has = ["tBuy", "tSell", "tAt", "qty", "tierOv", "t2Grad"].filter(k => w[k] != null); … for (const k of has) r[k] = w[k];`), so a partial move — deleting tBuy/tSell/tAt from the row after copying — satisfies every conjunct and leaves the assertion green while the operator's tested pair disappears from the row. That matters exactly because `const o = ITEM_OPS ? ((DB.itemOps || {})[id] || null) : null;` with `const ITEM_OPS = false;` means the store is not read: a moved pair is unreachable from both sides until the flag arms, which is the 'an interrupted migration still answers from the row' property the row-intact conjunct exists to hold.

**Correction to the finder.** Worth stating precisely so the fix is aimed right: a FULL move (all six fields) would be caught, by `DB.watch[0].tierOv === 2 && DB.watch[0].qty === 5`. The uncovered case is a partial move of the three fields nothing re-reads on the row — which is the plausible one, since the tested pair is the field group the migration's own comment fusses over.

**Proposal — NOT APPLIED.** Capture the baseline BEFORE the first migration (`const rowsBefore = JSON.stringify(DB.watch); const n1 = itemOpsMigrate();`) and compare against it, keeping the post-second-run comparison as the separate idempotence check. The full-JSON compare then covers all six fields instead of two, and the seed above turns it red.

---

## 31. [CORRECTNESS] [R93.7]'s absence check cannot see the flag — no candidate can carry pool provenance while CUTOVER_POOL is false, so the call site's `ITEM_OPS` argument is unproven

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `new-session-assertions`
- **Failure mode:** 2 (fixture prevents expression — the absence is guaranteed by a second, unrelated condition)
- **Assertion:** [R93.7] while ITEM_OPS is OFF the pool controls render NOTHING — a press that writes a store nothing reads is worse than an absent control, because it looks like it worked
- **Condition:** `poolControlsHTML(poolX, false) === "" && poolControlsHTML(tenX, false) === "" && document.getElementById("planList").innerHTML.indexOf("data-poolov") < 0`

**Evidence.**

The term-level half is sound (the flag is a parameter, the third extraction of the build). The call-site half is not. The only production call site is `+ poolDot(p.id) + poolControlsHTML(p, ITEM_OPS)`, and while `CUTOVER_POOL === false` `planCandidates` returns only `DB.watch.map(w => markSrc(candidateFor(w), QUAL_SRC_WATCH))` — so every `p` reaching that line has `src === QUAL_SRC_WATCH` and `poolControlsHTML` returns "" on the `x.src !== QUAL_SRC_POOL` limb regardless of `armed`. Seeding the call site to `poolControlsHTML(p, true)` therefore changes nothing in `#planList`, and the assertion stays green. The scoping fix the comment describes (planList rather than document.body — correct, and it fixed a real ninth-face defect) narrowed the container but did not make the subject reachable. R93.7's stated property is "While `ITEM_OPS` is OFF they render nothing, asserted by absence" — the absence currently proves the pool is empty, not that the flag is off.

**Production cited.**

```js
function poolControlsHTML(x, armed){
  if (!armed || !x || x.src !== QUAL_SRC_POOL) return "";
```

**Verifier method.** Read the three [R93.7] assertions and their scoping comment in probe-snippet.html; read `function poolControlsHTML(x, armed)` in full in index.html; read the sole call site line `+ poolDot(p.id) + poolControlsHTML(p, ITEM_OPS)`; grepped index.html for `ITEM_OPS` (`const ITEM_OPS = false;   // pinned by [R93.1]`) and `poolControlsHTML`; re-read `function planCandidates()`; read REQUIREMENTS.md row R93.7.

**Verifier says.** Confirmed for the conjunct the finder targets. `function poolControlsHTML(x, armed){ if (!armed || !x || x.src !== QUAL_SRC_POOL) return "";` has two independent early-return limbs. The only production call site is `+ poolDot(p.id) + poolControlsHTML(p, ITEM_OPS)` in the plan-line renderer, and while `const CUTOVER_POOL = false;` stands, `planCandidates()` returns only `DB.watch.map(w => markSrc(candidateFor(w), QUAL_SRC_WATCH))` — so every `p` on a plan line has `src === QUAL_SRC_WATCH` and the `x.src !== QUAL_SRC_POOL` limb answers regardless of `armed`. Seeding the call site to `poolControlsHTML(p, true)` therefore changes nothing in `#planList` and `document.getElementById("planList").innerHTML.indexOf("data-poolov") < 0` stays true. The absence proves the pool is empty, not that the flag is off, exactly as claimed.

**Correction to the finder.** Severity should be read down. The label's headline claim — "while ITEM_OPS is OFF the pool controls render NOTHING" — IS proven at the term by the first two conjuncts: `poolControlsHTML(poolX, false) === ""` with `poolX.src === QUAL_SRC_POOL` goes red if the `!armed` limb is deleted, which is the extraction pattern working as intended. Only the third, call-site conjunct is doubly guarded and inert, and it is the belt to the term's braces rather than the property's only guard.

**Proposal — NOT APPLIED.** PROPOSE ONLY: this is the same root as finding 1 and is fixed by the same extraction — once the armed pool path can be driven under a fixture, render a plan containing a pool-stamped candidate and assert `#planList` carries no `data-poolov` with ITEM_OPS off and does carry one with it on. Until then, the honest form is to drop the planList conjunct (it reports coverage it does not have) or re-point it at the call-site expression, e.g. assert the render function's source passes `ITEM_OPS` rather than a literal. Would need a seed to confirm: change the call site to `poolControlsHTML(p, true)` and check nothing goes red.

---

## 32. [CORRECTNESS] [R94.3] ships a live behaviour change today — the streak-eviction loop — and no assertion touches it

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `new-session-assertions`
- **Failure mode:** Uncovered behaviour change (the ratification-that-breaks-no-test shape): the property is stated in the requirement and in a production comment, and nothing exercises it
- **Assertion:** [R94.3] VOL5_UNIVERSE is FALSE and pinned, and the streak population is the WATCHLIST while it is — deployment-class, because a die-off bench that can newly fire on a pool item changes what the allocator may fund
- **Condition:** `VOL5_UNIVERSE === false && vol5Population().length === DB.watch.length && vol5Population().every(id => DB.watch.some(w => w.id === id))`

**Evidence.**

REQUIREMENTS.md R94.3 states the property in bold: "**An id that leaves the population loses its streak**, or a shrinking population would leave counters nothing updates". Grepping `vol5Low` across the whole probe returns only fixture resets (`S.vol5Low = new Map()`), two pre-existing streak-value reads at lines 451/473, and the [R91.3] block's three `S.vol5Low.set(4242, ...)` calls. Nothing calls `updateVol5Streaks()` with an id in `S.vol5Low` that is absent from `vol5Population()`, so deleting the eviction loop reddens nothing. This is not a flagged-off path: with `VOL5_UNIVERSE === false` the population IS `DB.watch.map(w => w.id)`, so the loop changed behaviour the day it shipped — an item removed from the watchlist now loses its 5m streak, where before its counter persisted untouched. Separately, the two conjuncts after the flag pin restate production's own off-branch expression (`vol5Population = () => VOL5_UNIVERSE ? S.items.map(it => it.i) : DB.watch.map(w => w.id)`), so `length === DB.watch.length` is an identity for any implementation that derives from DB.watch; it bites only on a wholesale replacement of the off-branch.

**Production cited.**

```js
function updateVol5Streaks(){
  const pop = vol5Population();
  const live = new Set(pop);
  /* An id that leaves the population loses its streak — otherwise a shrinking
     population leaves counters that nothing updates ... */
  for (const id of [...S.vol5Low.keys()]) if (!live.has(id)) S.vol5Low.delete(id);
```

**Verifier method.** Read the [R94.3] assertion in probe-snippet.html; read index.html `const VOL5_UNIVERSE = false;`, `const vol5Population = () => VOL5_UNIVERSE ? S.items.map(it => it.i) : DB.watch.map(w => w.id);` and the full `function updateVol5Streaks()`; read REQUIREMENTS.md row R94.3; ran `git show HEAD:index.html` to diff the prior body; grepped `vol5Low` and `updateVol5Streaks` across the probe and read the fixture block containing every call site (`DB.watch = [{id:9001, qty:null}]` … through the die-off assertions) and the [R91.3] block.

**Verifier says.** Verified against git: `git show HEAD:index.html` gives the prior body as `function updateVol5Streaks(){ for (const w of DB.watch){ ... } ...}` with NO eviction loop. The working tree adds `const pop = vol5Population(); const live = new Set(pop); ... for (const id of [...S.vol5Low.keys()]) if (!live.has(id)) S.vol5Low.delete(id);`. With `const VOL5_UNIVERSE = false;` the population is still `DB.watch.map(w => w.id)`, so the eviction is a behaviour change that is live TODAY, not behind the flag — an id dropped from the watchlist now loses its streak where before its counter persisted. REQUIREMENTS.md R94.3 states the property in bold ("**An id that leaves the population loses its streak**"). Grepping `vol5Low` across the probe returns only `S.vol5Low = new Map()` fixture resets (lines ~437, 646, 745, 820, 897, 1012, 1268, 1531, 1912, 2620), two streak-value reads inside the vol5 binding block, and the [R91.3] block's three `S.vol5Low.set(4242, …)` calls — and [R91.3] never calls `updateVol5Streaks`; it calls `volGateFor(thin)`. Every `updateVol5Streaks()` call in the suite runs under `DB.watch = [{id:9001, qty:null}]` with `S.vol5Low` freshly emptied, so no id is ever in the map and absent from the population. The second half of the finding is also right: `vol5Population().length === DB.watch.length && vol5Population().every(id => DB.watch.some(...))` restates production's own off-branch `DB.watch.map(w => w.id)`, so it bites only on a wholesale replacement.

**Correction to the finder.** One qualification the finder did not state: "deleting the eviction loop reddens nothing" is not fully provable by reading. S.vol5Low is reset at ten block boundaries but not all, so an incidental redness in a later block cannot be excluded without a seed. What IS proven by reading: no assertion targets the property, and the requirement's bolded claim is unasserted.

**Proposal — NOT APPLIED.** PROPOSE ONLY: add an assertion that seeds `S.vol5Low` with an id NOT in `vol5Population()`, calls `updateVol5Streaks()`, and asserts the key is gone while an in-population id's counter survives — the discriminating pair. That also makes the armed-flag population meaningful, since the same assertion run with a universe population is the natural seed. Would need a seed to confirm: delete the eviction loop and check the new assertion goes red.

---

## 33. [CORRECTNESS] [R94.4] claims the ledger STAMPS its population and IS BOUNDED; the assertion exercises neither the writer nor the cap

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `new-session-assertions`
- **Failure mode:** 8 (label overclaims — the label names two properties and the condition tests a third, the import carry) plus 2 (the writer and the slice are never reached)
- **Assertion:** [R94.4] the die-off ledger stamps WHICH POPULATION its streak was counted over, and is bounded — an episode opened while the counter ran over 43 items and one opened while it ran over ~4,500 are not the same evidence
- **Condition:** `DIEOFF_LOG_CAP === 1500 && (() => { const imp = validateImport({ dieOffLog: [ ... ] }).db.dieOffLog; return imp[0].pop === "universe" && imp[1].pop === "watch" && imp[2].pop === undefined && imp[3].pop === undefined; })()`

**Evidence.**

The single [R94.4] assertion tests (a) a constant equals 1500 and (b) `validateImport`'s carry of a field the probe hand-writes into its own fixture rows. Deleting `pop: VOL5_UNIVERSE ? "universe" : "watch"` from the push site leaves the assertion green — nothing in the suite reads a `pop` value that production wrote. Likewise the `slice(-DIEOFF_LOG_CAP)` line never executes: no fixture drives DB.dieOffLog past 1500 rows, so "and is bounded" rests entirely on the constant's existence. Contrast [R90.1], where the equivalent claim IS proven at the writer (`gateLogRow` is called directly), and [R87.4], which does drive the qual store past its cap. This is the same pattern the author got right twice and missed once.

**Production cited.**

```js
DB.dieOffLog.push({ d: dToday, id: b.id, t: Date.now(), rec: null, pop: VOL5_UNIVERSE ? "universe" : "watch" });
...
if (DB.dieOffLog.length > DIEOFF_LOG_CAP) DB.dieOffLog = DB.dieOffLog.slice(-DIEOFF_LOG_CAP);
```

**Verifier method.** Read the [R94.4] assertion in probe-snippet.html; read index.html `const DIEOFF_LOG_CAP = 1500;`, the die-off push site `DB.dieOffLog.push({ d: dToday, id: b.id, t: Date.now(), rec: null, pop: VOL5_UNIVERSE ? "universe" : "watch" });`, the cap line, and the validateImport `pop` carry; grepped probe-snippet.html for `dieOffLog` and `.pop` (all fixture-side); read REQUIREMENTS.md row R94.4; compared against [R87.4]'s `for (let i = 0; i < QUAL_ROW_CAP + 3; i++)` cap drive.

**Verifier says.** The single [R94.4] assertion is `DIEOFF_LOG_CAP === 1500 && (() => { const imp = validateImport({ dieOffLog: [ … ] }).db.dieOffLog; return imp[0].pop === "universe" && imp[1].pop === "watch" && imp[2].pop === undefined && imp[3].pop === undefined; })()`. The four rows it inspects are hand-written into the probe's own import fixture, and the import path is separate code (`...(dp === "watch" || dp === "universe" ? { pop: dp } : {}),` in validateImport). Grepping the probe for `pop` against dieOffLog returns hits only inside that fixture — every other dieOffLog assertion ([R8.2], [R43.5]) reads `.rec`, `.id`, `.void`, `.length`. So deleting `pop: VOL5_UNIVERSE ? "universe" : "watch"` from `DB.dieOffLog.push({ d: dToday, id: b.id, t: Date.now(), rec: null, pop: … })` leaves the suite green. Likewise `if (DB.dieOffLog.length > DIEOFF_LOG_CAP) DB.dieOffLog = DB.dieOffLog.slice(-DIEOFF_LOG_CAP);` — no fixture drives DB.dieOffLog past 1500 rows (the largest fixture is two entries), so "and is bounded" rests on the constant's existence. The contrast the finder draws is accurate: [R90.1] calls `gateLogRow(...)` directly at the writer, and [R87.4] does drive `DB.qual` past `QUAL_ROW_CAP + 3` and asserts which rows survive.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: either call the writer (drive a die-off episode open and assert the pushed row's `pop` against the flag's current value) or extract the row builder the way `gateLogRow` was extracted and assert it directly — the extraction is the fix, not a convenience. For the cap, the `qualEvictNote` precedent applies: extract the bound-and-report step so it is assertable without pushing 1500 rows. Would need a seed to confirm: strip `pop:` from the push and check nothing reddens.

---

## 34. [CORRECTNESS] [R91.2] proves 'the bench does not newly bench' with the probe's own arithmetic, not with the bench

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `new-session-assertions`
- **Failure mode:** 4 (re-implementation — the assertion COMPUTES the bench expression instead of CALLING the code that benches)
- **Assertion:** [R91.2] and unknown never reads as not-drifty — the bench stays falsy on null (it does not newly bench), but the value is now distinguishable from a measured steady item
- **Condition:** `!(stabilityWeight(undefined, 100).drifty && true) && stabilityWeight(undefined, 100).drifty !== false && stabilityWeight(steady, 100).drifty === false`

**Evidence.**

The subject named in the label is "the bench". The condition never reaches `candidateFor`'s `chk(...)`; it re-derives the guard as `drifty && true` inside the probe. The whole point of the §91 change is that `drifty` moved from a two-state to a three-state value, and the safety claim attached to it is that the live bench is unaffected — exactly the claim a probe-side re-derivation cannot make. If the bench were later written `chk(stw.drifty !== false && walkGapH > 24, ...)`, an item with an unread series would be newly benched (a restraint arming with no press, on the funding path) and this assertion would still be green. `stabilityWeight`'s own three states, the first conjunct-group and the third assertion of the block, are soundly asserted at the term — this finding is only about the bench half. Probe grep for `drift bench` returns one unrelated hit at line 8414 (`!emitted.has("drift bench")`), not the null case.

**Production cited.**

```js
    chk(stw.drifty && walkGapH > 24, "drift bench",
      "drifty pick benched — your last walk-up was " + (Number.isFinite(walkGapH) ? Math.round(walkGapH) + "h" : "a long time")
```

**Verifier method.** Read the [R91.2] assertions in probe-snippet.html; read the `chk(stw.drifty && walkGapH > 24, "drift bench", …)` call site in index.html's candidateFor and the `stabilityWeight` reference in the same function; read REQUIREMENTS.md row R91.2; grepped `drift bench` across both index.html and probe-snippet.html and read the one probe hit in context ([R74.4]).

**Verifier says.** The production bench is `chk(stw.drifty && walkGapH > 24, "drift bench", "drifty pick benched — your last walk-up was " …)` inside candidateFor. The [R91.2] assertion's condition is `!(stabilityWeight(undefined, 100).drifty && true) && stabilityWeight(undefined, 100).drifty !== false && stabilityWeight(steady, 100).drifty === false` — it never calls candidateFor and never reaches `chk`. `&& true` is the probe's own re-derivation of the guard's truthiness test, which is the seventh face verbatim: the tell is a probe line that computes rather than calls. The safety claim §91 attaches to the two-state→three-state change is precisely that the LIVE bench is unaffected, and a probe-side re-derivation cannot make that claim: rewriting the guard as `chk(stw.drifty !== false && walkGapH > 24, …)` would newly bench every item with an unread series — a restraint arming with no press, on the funding path — and this assertion stays green. I confirmed the finder's grep claim: `drift bench` appears in probe-snippet.html exactly once, at the [R74.4] market-gate vocabulary assertion (`&& !emitted.has("fill history") && !emitted.has("drift bench")`), which sweeps `marketGateFails` stat grids and has nothing to do with the null-drifty case. REQUIREMENTS.md R91.2 states the property as "`chk(stw.drifty && …)` is unchanged and still falsy on null, so nothing is newly benched" — naming the chk expression the assertion never touches. The finder's own scoping is right: the three-state assertion above it and the third conjunct here are soundly asserted at the term.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: assert through `candidateFor` — build a candidate whose spark series is too short and whose `walkGapH > 24`, and assert `fails` contains no `drift bench` entry; then flip the series to 30 wandering points and assert it does. That is the discriminating pair and it exercises the real guard. If `chk` is unreachable from the probe, extract the condition (`driftBenches(stw, walkGapH)`) and point the assertion there — the strataCount pattern, which this build already applied twice.

---

## 35. [CORRECTNESS] [R94.2] proves the readers and injects the cache — chartCacheLoad, the code that will actually build the series, is unasserted

- **Verdict:** CONFIRMED · **Finder's bite call:** UNCERTAIN · **Scope:** `new-session-assertions`
- **Failure mode:** 6 (the fixture manufactures the state the readers consume, so the producer that will manufacture it in production is never exercised)
- **Assertion:** [R94.2] and when it IS ready the same readers serve the universe-wide series — one series feeding FOUR consumers (tr, vt, momentum, drift), which is the corrected scope: wiring only tr and vt would have removed the mask without feeding the two restraints under it
- **Condition:** `chartReady() === true && chartPts(1).join(",") === "1,2,3,4,5" && chartVols(1).join(",") === "7,8" && chartPts(999).length === 0`

**Evidence.**

Grepping the probe for `chartCacheLoad` returns nothing; the only chart terms exercised are `chartWireState`, `chartReady`, `chartPts`, `chartVols`, all against a hand-built `S.chartCache = { at, state, pts: new Map([[1,[1,2,3,4,5]]]), vols: ... }`. The shape is right (it matches what `chartCacheLoad` assigns), so the readers are honestly covered and the inertness claim is real. But the archive inversion — the `CHART_PTS_CAP` slice, the hi/lo mid, the `hv+lv` total, the `NaN` limb that `momentumState` then filters, and the catch that writes `could-not-check` — has no coverage at all, and it is the code that first executes on the day the coverage gate turns ready. That is the same failure the R89.1 requirement names in words: a branch first executed on the day it carries the gates. Note `momentumState` filters non-finite points, so a `NaN` mid degrades silently into a shorter series and therefore into `state: null` — an unknown that reads as an archive problem, not a computation bug.

**Production cited.**

```js
const keys = (await t0Keys("h1", now - CHART_PTS_CAP * 3600e3, null)).slice(-CHART_PTS_CAP);
    const pts = new Map(), vols = new Map();
    ...
        const mid = (Number.isFinite(hi) && Number.isFinite(lo)) ? (hi + lo) / 2
                  : Number.isFinite(hi) ? hi : Number.isFinite(lo) ? lo : NaN;
```

**Verifier method.** Grepped probe-snippet.html for `chartCacheLoad`, `chartPts`, `chartVols`, `chartReady`, `CHART_PTS_CAP` (only reader-level hits, none for the loader or the cap); read the [R94.2] assertions and the injected `S.chartCache` fixture; read index.html `async function chartCacheLoad()`, `function chartCacheEnsure()`, the four reader consts (`const chartReady = () => !!(S.chartCache && S.chartCache.state && S.chartCache.state.ready);` etc.), and `function momentumState(rawPts, buy)`; read REQUIREMENTS.md row R94.2.

**Verifier says.** Grepping the probe for `chartCacheLoad` returns nothing; the only chart identifiers exercised are `chartWireState`, `chartReady`, `chartPts`, `chartVols`, `momentumState`, all against a hand-built `S.chartCache = { at: Date.now(), state: {...}, pts: new Map([[1, [1,2,3,4,5]]]), vols: new Map([[1, [7,8]]]) }`. That shape does match what `chartCacheLoad` assigns (`S.chartCache = { at: now, state: st, pts, vols };`), so the readers are honestly covered and the inertness claim is real. The uncovered producer is substantial: `(await t0Keys("h1", now - CHART_PTS_CAP * 3600e3, null)).slice(-CHART_PTS_CAP)`, the per-item inversion loop, `const mid = (Number.isFinite(hi) && Number.isFinite(lo)) ? (hi + lo) / 2 : Number.isFinite(hi) ? hi : Number.isFinite(lo) ? lo : NaN;`, the `(b.hv[i] || 0) + (b.lv[i] || 0)` total, and the catch that writes `state: { ready: false, state: "could-not-check", why: "the archive read failed (…)" }`. The NaN observation is confirmed: `momentumState` opens `const pts = (rawPts || []).filter(Number.isFinite);` then `if (pts.length < 5 || buy == null) return { state: null, q: null };`, so NaN mids silently shorten the series into `state: null` — an unknown that reads as an archive problem rather than a computation bug.

**Correction to the finder.** Framing, not fact: this is an uncovered-producer finding, not an inert assertion. REQUIREMENTS.md R94.2 claims only the reader/inertness property ("While the gate is not ready every reader returns exactly what it returned before — asserted with a populated cache sitting behind a not-ready gate"), which the assertion does honestly discharge. The label does not overclaim; the gap is that the code first executing on the day the gate turns ready has zero coverage.

**Proposal — NOT APPLIED.** PROPOSE ONLY: assert `chartCacheLoad` against seeded `h1` buckets in the T0 store — the §86 rdiff block already demonstrates the pattern of seeding IndexedDB rows and deleting them by key afterwards, so the fixture cost is known. Assert at minimum: the mid of a hi/lo pair, a hi-only and lo-only bucket, a bucket with neither (which must not silently enter the series), the `CHART_PTS_CAP` slice keeping the LAST 168, and the catch path yielding `could-not-check`. UNCERTAIN is honest here about severity, not about the gap: the gap is certain, its consequence depends on archive shapes I did not sample.

---

## 36. [CORRECTNESS] [R91.1]'s 'both callers route through the one term' rests on a source-text match for the marketStatsFor half

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `new-session-assertions`
- **Failure mode:** 4-adjacent (a source-text containment stands in for a behavioural check; it tests that an identifier appears, not that it is what answers)
- **Assertion:** [R91.1] both callers route through the one term — the live chain via momentum(c, sp) and the instrument via marketStatsFor, so an absence cannot be interpreted two ways
- **Condition:** `String(momentum).indexOf("momentumState") >= 0 && String(marketStatsFor).indexOf("momentumState") >= 0 && momentum({ buy: 100 }, { pts: knifePts }).state === "knife" && momentum({ buy: 100 }, undefined).state === null`

**Evidence.**

The `momentum` half is proven behaviourally (knife on a real series, null on an absent one). The `marketStatsFor` half is proven only by `String(marketStatsFor).indexOf("momentumState") >= 0`. `Function.prototype.toString` returns the source INCLUDING comments, and `marketStatsFor` carries a long comment block about this very change directly above the `moState:` line — so any future comment mentioning the identifier satisfies the check with the call gone. More directly: rewriting the line as `moState: chartPts(id).length ? momentumState(chartPts(id), buy).state : "flat"` re-introduces exactly the defect §91 exists to remove (an absence wearing a passing verdict) and keeps the assertion green. No other probe assertion reads `marketStatsFor(...).moState` — grep shows only `[R74.5a]`'s equality check and `[R76.9]`'s `marketStatsFor(9761).tr === null`.

**Production cited.**

```js
    moState: momentumState(chartPts(id), buy).state };
```

**Verifier method.** Read the three [R91.1] assertions in probe-snippet.html; read `function marketStatsFor(id)` in index.html in full including its comment block and the terminal line `moState: momentumState(chartPts(id), buy).state };`; ran `sed -n '3798,3850p' index.html | grep -n "momentumState"` (single hit, at the call); grepped probe-snippet.html for every `marketStatsFor` occurrence.

**Verifier says.** The condition is `String(momentum).indexOf("momentumState") >= 0 && String(marketStatsFor).indexOf("momentumState") >= 0 && momentum({ buy: 100 }, { pts: knifePts }).state === "knife" && momentum({ buy: 100 }, undefined).state === null`. The `momentum` half is proven behaviourally; the `marketStatsFor` half is a `Function.prototype.toString` containment check only. Confirmed by grep that no assertion anywhere reads `marketStatsFor(...).moState`: the probe's only `marketStatsFor` uses are [R74.5a]'s stats-equality check, [R76.9]'s `marketStatsFor(9761).tr === null`, one `scorerTripOpen` fixture, and this string match. So the finder's sharper seed stands: rewriting the line as `moState: chartPts(id).length ? momentumState(chartPts(id), buy).state : "flat"` re-introduces exactly the absence-wearing-a-passing-verdict defect §91 exists to remove, keeps the identifier in the source, and leaves the assertion green. `toString` does include comments, so a future comment mentioning the identifier would also satisfy it.

**Correction to the finder.** The finder's supporting evidence is wrong on one point: marketStatsFor's comment block above the `moState:` line does NOT currently contain the literal token "momentumState" — it reads "MOMENTUM ROUTES THROUGH THE SHARED TERM (Aug 18 2026)". A grep of the function body returns exactly one hit, the call itself. The structural weakness is real anyway; the comment-satisfies-the-check scenario is hypothetical rather than present.

**Proposal — NOT APPLIED.** PROPOSE ONLY: assert the behaviour — with `S.chartCache` unset or not-ready, `marketStatsFor(id).moState === null`; with a ready cache carrying five knife points for that id, `marketStatsFor(id).moState === "knife"`. That proves routing rather than mentioning, and it costs nothing beyond the fixture [R94.2] already builds two blocks later.

---

## 37. [DISPLAY] [R92.2]'s 'percentage only beside the pair' conjunct is satisfied by the conjunct before it

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-b-chart-overlays`
- **Failure mode:** 1 — tautology given the preceding conjunct: the negative-lookahead can only match at string position 0, and the first conjunct guarantees the lookahead fails there
- **Assertion:** [R92.2] slot A renders the pair `n of obs` and a percentage may appear only BESIDE it — 93 of 108 and 93% are different claims and only the first is rulable
- **Condition:** `/funded 42 of 60 observed cycles/.test(dot4) && /70%, shown beside the pair and never instead of it/.test(dot4) && !/^(?!.*42 of 60).*70%/.test(dot4)`

**Evidence.**

`^(?!.*42 of 60).*70%` is anchored with `^` and the flags are default (no /m), so the whole pattern can only attempt a match at offset 0. The first conjunct already requires "funded 42 of 60 observed cycles" to be present in dot4; wherever that text sits on the first line, `(?!.*42 of 60)` fails at offset 0 and the pattern cannot match anywhere, so `!test(...)` is true by construction. The only input under which the third conjunct adds information is one where the pair appears solely AFTER a newline while the percentage appears before it — a shape the tooltip string does not have. So the ordering property the label names ("beside it, never instead of it") is carried entirely by the second conjunct, which is a literal-string check on copy that already contains the word "beside".

**Production cited.**

```js
const dot4 = poolDot(770004);
```

**Verifier method.** probe-snippet.html: read the [R92.2] block at 10354–10365 verbatim, including `const dot4 = poolDot(770004);`. index.html: read `poolDot` in full — all four return branches — to confirm no newline is emitted into the tooltip string and that the pair and the percentage are adjacent in the same title attribute.

**Verifier says.** The third conjunct is `!/^(?!.*42 of 60).*70%/.test(dot4)`. The pattern is `^`-anchored with default flags (no /m), so it can only attempt a match at offset 0. I read `poolDot` in index.html: the returned string is one unbroken concatenation with no newline literals — the final branch builds `'…title="Pool persistence: funded ' + pair + ' observed cycles since it entered the pool' + (pct != null ? ' (' + pct + '%, shown beside the pair and never instead of it)' : '') + six + …'`. Since the first conjunct already requires `funded 42 of 60 observed cycles` to be present, and the string is single-line, the lookahead `(?!.*42 of 60)` necessarily fails at offset 0, the pattern cannot match anywhere, and `!test(...)` is true by construction. The only shape under which the conjunct could carry information is a pair appearing solely after a newline with the percentage before it, which `poolDot` cannot produce. So the ordering property in the label is carried entirely by the second conjunct, a literal match on copy that itself contains the word 'beside'.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** Assert the ordering by document position, the way [R73.10] and [R86.6] do it: `dot4.indexOf("42 of 60") >= 0 && dot4.indexOf("42 of 60") < dot4.indexOf("70%")`, and separately that a state with no observed denominator renders no percentage at all. Drop the lookahead — it reads as a strong absence check and is not one.

---

## 38. [DISPLAY] [R94.1]'s second assertion short-circuits past the 'unknown is not a pass' half it is named for

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `new-session-assertions`
- **Failure mode:** 1 (short-circuit — an `||` whose first branch always matches, so the branch carrying the named property never evaluates)
- **Assertion:** [R94.1] and while it is accruing the copy says unknown is NOT A PASS, naming all four consumers — the mask the chart bench currently provides is exactly what makes the scope correction load-bearing
- **Condition:** `/trend, volume trend, momentum "?\n?\s*\+? ?"?and drift/.test(chartWireState({ observed: 93 }).why.replace(/\s+/g, " ")) || (/trend, volume trend, momentum and drift/.test(chartWireState({ observed: 93 }).why) && /unknown is not a pass/i.test(chartWireState({ observed: 93 }).why))`

**Evidence.**

The accruing `why` renders "... — trend, volume trend, momentum and drift stay unknowable until 7, and unknown is not a pass". After `.replace(/\s+/g, " ")` the first regex matches: "trend, volume trend, momentum " then every quantified group (`"?`, `\n?`, `\s*`, `\+?`, ` ?`, `"?`) matches empty, then "and drift". So the left operand of the `||` is true on every run and the right operand — the ONLY place `unknown is not a pass` is tested — is never evaluated. Deleting ", and unknown is not a pass" from the copy leaves the assertion green, which is precisely the eleventh face (presence of the right phrase is not absence of the wrong one) with the required phrase itself unguarded. The odd first regex (optional quotes and a `+`) reads like a leftover from a match against concatenated source text rather than rendered copy.

**Production cited.**

```js
  if (days < CHART_MIN_DAYS) return { ready: false, state: "accruing", days,
    why: Math.round(days * 10) / 10 + " of " + CHART_MIN_DAYS + " OBSERVED days accrued — trend, volume trend, momentum "
       + "and drift stay unknowable until " + CHART_MIN_DAYS + ", and unknown is not a pass" };
```

**Verifier method.** Read both [R94.1] assertions in probe-snippet.html; read `function chartWireState(h1)` in index.html in full; reconstructed the exact accruing `why` string for `{observed: 93}` (93/24 = 3.875 → 3.9) and tested the probe's first regex against it with `printf … | grep -cP` (result: 1 match).

**Verifier says.** Verified mechanically rather than by eye. The accruing branch renders `why` = "3.9 of 7 OBSERVED days accrued — trend, volume trend, momentum and drift stay unknowable until 7, and unknown is not a pass" (from `return { ready: false, state: "accruing", days, why: Math.round(days * 10) / 10 + " of " + CHART_MIN_DAYS + " OBSERVED days accrued — trend, volume trend, momentum " + "and drift stay unknowable until " + CHART_MIN_DAYS + ", and unknown is not a pass" };`). I piped that exact string through `grep -cP 'trend, volume trend, momentum "?\n?\s*\+? ?"?and drift'` and it returned 1 — every quantified group matches empty between "momentum " and "and drift". So the left operand of the `||` is true on every run and the right operand, the only place `/unknown is not a pass/i` is tested, never evaluates. Deleting ", and unknown is not a pass" from the copy leaves the assertion green — the required phrase itself is unguarded, which is the eleventh face with the arrow reversed. The finder's read of the odd first regex (optional quotes, an optional `+`) as a leftover from a source-text match is plausible and I could not find another explanation.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: replace the `||` with a conjunction over the whitespace-collapsed string — require the four-consumer list AND `/unknown is not a pass/i`, and (per the eleventh face) forbid the contradicting claim. Would need a seed to confirm: delete the trailing clause from `chartWireState`'s accruing `why` and check the rewritten assertion goes red while the three-state assertion above it stays green.

---

## 39. [DISPLAY] [R87.4]'s eviction fixture cannot tell the running total from this cycle's count

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `new-session-assertions`
- **Failure mode:** 2 (fixture prevents expression — both arguments are 3, so the two fields and the two note slots are indistinguishable)
- **Assertion:** [R87.4] eviction is flagged and warned — it costs an item its streak, so it is a plan-behaviour event and never silent; the note names the count, the total and that watchlist rows are never evicted
- **Condition:** `DB.qualEvict && DB.qualEvict.n === 3 && DB.qualEvict.last === 3 && /evicted 3 least-recently-seen POOL row/.test(qualEvictNote(3, 3)) && /not housekeeping/.test(qualEvictNote(3, 3)) && /Watchlist rows are never evicted/.test(qualEvictNote(3, 3)) && qualEvictNote(5, 0) === null`

**Evidence.**

`DB.qualEvict` is reset to null before the fixture, so the first eviction makes the running total (`n`) and this cycle's count (`last`) both 3, and the assertion checks both against 3. Swapping them in production — `{ n: cut.length, last: (previous n) + cut.length }` — reddens nothing. The same collapse hits the note: the assertion calls `qualEvictNote(3, 3)`, so `full(justNow)` and `full(total)` render identically, and swapping the arguments at the production call site (`qualEvictNote(DB.qualEvict.n, cut.length)`, signature `qualEvictNote(total, justNow)`) also reddens nothing — yet "the note names the count, the total" is exactly what the label claims to distinguish. The pool-only/least-recently-seen half of the block (the assertion above it) is soundly discriminating and this finding does not touch it.

**Production cited.**

```js
DB.qualEvict = { n: ((DB.qualEvict && DB.qualEvict.n) || 0) + cut.length, at: now, last: cut.length };
    ...
    const note = qualEvictNote(DB.qualEvict.n, cut.length);
```

**Verifier method.** Read the [R87.4] fixture and both assertions in probe-snippet.html; read index.html `function qualEvictNote(total, justNow)` in full, the `DB.qualEvict = { n: …, at: now, last: cut.length }` writer, and the call `const note = qualEvictNote(DB.qualEvict.n, cut.length);`.

**Verifier says.** `DB.qualEvict = null;` is set before the fixture, and the fixture seeds `QUAL_ROW_CAP + 3` pool rows, so the single eviction makes `DB.qualEvict = { n: ((DB.qualEvict && DB.qualEvict.n) || 0) + cut.length, at: now, last: cut.length }` yield `n === 3` and `last === 3`. The assertion checks `DB.qualEvict.n === 3 && DB.qualEvict.last === 3`, which cannot distinguish the two fields; swapping them in production reddens nothing. The note collapse is the same: `function qualEvictNote(total, justNow)` renders `"… evicted " + full(justNow) + " least-recently-seen POOL row" … " (" + full(total) + " evicted in total)."`, and the assertion calls `qualEvictNote(3, 3)` three times, so `full(justNow)` and `full(total)` are the same character. Swapping the production call `const note = qualEvictNote(DB.qualEvict.n, cut.length);` to `qualEvictNote(cut.length, DB.qualEvict.n)` produces a byte-identical string under this fixture — while the label claims "the note names the count, the total". The finder's scoping is right: the sibling assertion above (`poolLeft.length === QUAL_ROW_CAP && !!DB.qual[8001] && !DB.qual[20000] && … && !!DB.qual[20003]`) is soundly discriminating and this does not touch it.

**Correction to the finder.** One conjunct is not collapsed: `qualEvictNote(5, 0) === null` genuinely exercises the `if (!(justNow > 0)) return null;` guard with a nonzero total, so a guard rewritten to test `total` would go red. The collapse is confined to the count/total pair.

**Proposal — NOT APPLIED.** PROPOSE ONLY: seed `DB.qualEvict = { n: 7, at: 0, last: 7 }` before the fixture so the post-eviction expectation is `n === 10 && last === 3`, and assert the note with distinct arguments (`qualEvictNote(10, 3)` matching /evicted 3 .../ and /10 evicted in total/). Both halves then discriminate.

---

## 40. [DISPLAY] [R92.6] claims 'the pin rename landed' but only the sub-tab label is asserted

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `new-session-assertions`
- **Failure mode:** 8 (label overclaims — a two-part rename is asserted in one part)
- **Assertion:** [R92.6] the pin rename and the tab label landed, and the old forms are ABSENT — a rename checked only by presence leaves the old form standing somewhere
- **Condition:** `document.querySelector('#tradeSubs button[data-sub="watch"]').textContent === "Plan & Pins" && document.getElementById("tradeSubs").innerHTML.indexOf("Watchlist") < 0`

**Evidence.**

REQUIREMENTS.md R92.6 names two renames: "`+ watch` becomes `+ pin`; the sub-tab reads **Plan & Pins** and the old string is asserted ABSENT". The condition covers only the sub-tab, scoped correctly to `#tradeSubs` (the container fix here is right, and I verified no stale "Plan & Watchlist" survives anywhere in index.html). The `+ pin` button label exists at two production call sites (both `data-add` cells) and nothing asserts either its presence or the absence of `+ watch`. R92.6 also names "the family and caution bench copy each gain their one word of context for a pool item", which no assertion in the block reaches. Consequence is copy-only, hence display.

**Production cited.**

```js
      + (watched.has(c.id) ? '✓' : '+ pin') + '</button></td>'
```

**Verifier method.** Read the two [R92.6] assertions and the scoping comment in probe-snippet.html; read REQUIREMENTS.md row R92.6; grepped index.html for `+ pin`, `+ watch`, `Plan &amp; Pins`, `Plan & Watchlist` (sub-tab at `<button data-sub="watch" … >Plan &amp; Pins</button>`, `+ pin` at two `data-add` cells, no surviving "Plan & Watchlist"); grepped probe-snippet.html for `+ pin`, `+ watch`, `MARKET offered two members`, `larger pool puts more items`.

**Verifier says.** The condition is exactly `document.querySelector('#tradeSubs button[data-sub="watch"]').textContent === "Plan & Pins" && document.getElementById("tradeSubs").innerHTML.indexOf("Watchlist") < 0` — the sub-tab only. REQUIREMENTS.md R92.6 names three things: "`+ watch` becomes `+ pin`; the sub-tab reads **Plan & Pins** and the old string is asserted ABSENT … the family and caution bench copy each gain their one word of context for a pool item". The `+ pin` label lives at two production sites, both `(watched.has(c.id) ? '✓' : '+ pin') + '</button></td>'`, and grepping the probe for `+ pin` / `+ watch` returns one unrelated hit ("[R21.2] … expand + pin-open") — so neither the presence of `+ pin` nor the absence of `+ watch` is asserted. Grepping the probe for the two pool-context bench strings ("MARKET offered two members", "larger pool puts more items") returns nothing, so the third clause is unasserted too. Consequence is copy-only.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: add presence/absence matches scoped to the scanner and prospecting row containers (not document.body — the ninth face the author already hit three times this build), and either assert the two bench-copy additions or drop that clause from the requirement row so the row does not claim coverage it has not got.

---

## 41. [HYGIENE] candidateFor's volume-floor bench copy re-reads `S.vol5Low.get(c.id) || 0` — the exact never-fed collapse [R91.3] fixed one function above, surviving in a second reader; inert today only because its branch guard implies streak ≥ 2

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `search-pattern`
- **Failure mode:** Mode 4 (re-implementation) in production rather than in a probe: the copy re-derives a value the evaluator already returned (`vg.streak`) instead of reading it, so the two can drift. Currently unreachable-false, i.e. a dead-safeguard-shaped duplicate.
- **Assertion:** [R91.3] an item the streak never counted reports streak NULL and says NOT COUNTED — it does not claim a counter that is not running
- **Condition:** `Asserted against `volGateFor(thin)` only (probe sets `S.vol5Low = new Map()`, then `S.vol5Low.set(4242, 0)` / `.set(4242, 99)` and reads the returned `streak` / label). The assertion's subject is `volGateFor`'s return value; it never renders or matches `candidateFor`'s bench detail string, so the second reader is outside its container entirely.`

**Evidence.**

WHY IT CANNOT MISFIRE TODAY, stated so the claim is checkable rather than assumed: the string is inside the `vg.bound === "5m"` arm, and `volGateFor` sets `bound: "5m"` on exactly one path — `if (n >= VOL5_BIND_REFRESHES)` with `VOL5_BIND_REFRESHES = 2` and `n = counted ? raw : 0`. A `null` (not-counted) entry yields `n = 0`, which cannot reach that branch. So `S.vol5Low.get(c.id)` is guaranteed non-null and ≥ 2 wherever this line executes, and `|| 0` can never render the false "0 consecutive refreshes" that [R91.3] exists to prevent. It is INERT, not wrong.

WHY IT IS STILL A FINDING. It is the identical expression the Aug 18 ruling named as the defect ("`|| 0` collapsed those two into one, and the label then stated '0/N consecutive refreshes — not binding yet', which claims a counter that is not running"), left standing in the one place a reader would look for it. The value is already in hand: `volGateFor` returns `streak: n` on that very branch, so `vg.streak` is the same number with the three-state discipline attached. Its safety depends on a constant in another function (`VOL5_BIND_REFRESHES`) staying ≥ 1 — precisely the two-constants-in-a-relationship shape CLAUDE.md's dead-safeguard case law describes ("Nothing was wrong with either number in isolation; the defect lived in the relationship between them"). It is also the reader most likely to be touched when `VOL5_UNIVERSE` flips, since that flag's whole purpose is to change who has a counted streak.

NO ASSERTION COVERS IT. [R91.3]'s subject is `volGateFor`'s return object; the bench detail string built in `candidateFor` is never matched. Deleting `vg`'s three-state handling would go red; changing this line would not.

**Production cited.**

```js
[the fixed reader — index.html, volGateFor]
    const raw = S.vol5Low.get(c.id);
    const counted = raw != null;
    const n = counted ? raw : 0;
...
    return { v: c.volSide, bound: "1h", streak: counted ? n : null,

[the unswept second reader — index.html, candidateFor]
    chk(mfHas("volFloor") && itemWins(w.id) < 2, "volume floor",
      (vg.bound === "5m"
          ? "volume " + gp(volGate) + "/h by the 5m sample — under the " + full(volFloorFor(c.buy))
            + "/h floor (price-scaled) for " + (S.vol5Low.get(c.id) || 0) + " consecutive refreshes; the 1h thin side says "
```

**Verifier method.** Opened index.html and read `function volGateFor(c)` in full including the Aug 18 three-state comment block (sed -n 4088,4122p); read the candidateFor volume-floor `chk` in full (sed -n 5385,5405p) and the head of `function candidateFor(w)` to confirm `const c = calc(w.id);` / `const vg = volGateFor(c);` (sed -n 5280,5300p); read `function calc(id)` through its return object to confirm the `id` field (sed -n 3004,3060p); grepped `VOL5_BIND_REFRESHES` (4 hits), `volGateFor(` (4 hits), `vol5Low` (all hits), and `bound: "5m"` (1 hit). Opened tools/probe/probe-snippet.html and read the [R91.3] stanza verbatim at 10302–10320.

**Verifier says.** Every link checks out, including the finder's own inertness argument, which I re-derived rather than accepted. The quoted production line is verbatim and in the context claimed: inside `chk(mfHas("volFloor") && itemWins(w.id) < 2, "volume floor",` the string is built as `(vg.bound === "5m" ? "volume " + gp(volGate) + "/h by the 5m sample — under the " + full(volFloorFor(c.buy)) + "/h floor (price-scaled) for " + (S.vol5Low.get(c.id) || 0) + " consecutive refreshes; ...` — so it is inside the `vg.bound === "5m"` arm. `grep -n 'bound: "5m"' index.html` returns exactly ONE hit, `return { v: Math.min(c.volSide, c.vol5), bound: "5m", streak: n,`, guarded by `if (n >= VOL5_BIND_REFRESHES)` where `const VOL5_MIN_UNITS = 5, VOL5_BIND_REFRESHES = 2;` and `const raw = S.vol5Low.get(c.id); const counted = raw != null; const n = counted ? raw : 0;`. An uncounted id yields n = 0 < 2 and cannot reach that branch, so wherever the copy executes `S.vol5Low.get(c.id)` is non-null and ≥ 2 and `|| 0` cannot fire. The identity of the key is real too: in candidateFor `const c = calc(w.id);` and `const vg = volGateFor(c);`, and `calc` returns `{ id, name: meta.n, ... }`, so `c.id` in both functions is the same id; the call is synchronous with no await between `vg` and the `chk`, so S.vol5Low cannot change underneath it. INERT, not wrong — as the finder states. The coverage claim also holds: [R91.3]'s two assertions read `volGateFor`'s return object directly off a synthetic `const thin = { id: 4242, buy: 100, volSide: 5000, vol5: 1, vol5units: 99 };` (`uncounted.streak === null && /NOT COUNTED for this item/.test(uncounted.label) && !/0\/\d+ consecutive refreshes/.test(uncounted.label) && uncounted.bound === "1h"` and `counted0.streak === 0 && /0\/\d+ consecutive refreshes/.test(counted0.label) && !/NOT COUNTED/.test(counted0.label) && bound.bound === "5m" && bound.streak === 99`). Neither ever invokes candidateFor or matches its bench detail string, so the second reader is outside the assertion's container entirely — changing that line would turn nothing red, exactly as the finder says.

**Correction to the finder.** None. The finding is accurately scoped and honestly classified — the finder states it is inert rather than dressing it as live, gives the constant relationship it depends on (`VOL5_BIND_REFRESHES` ≥ 1 in a different function), and correctly identifies that the value is already in hand as `vg.streak` on the very branch the copy renders. One thing to add: the fragility is sharper than stated, because `VOL5_UNIVERSE` is `const VOL5_UNIVERSE = false;   // pinned by [R94.3]; the flip is a ruling` and `const vol5Population = () => VOL5_UNIVERSE ? S.items.map(it => it.i) : DB.watch.map(w => w.id);` — flipping it changes WHO has a counted streak but not the 5m-arm guard, so the flip alone does not make this line misfire; it would take a change to `VOL5_BIND_REFRESHES` or to the branch structure. That makes it a dead-safeguard-shaped duplicate rather than a latent misreport, which is what the finder's `hygiene` severity already claims.

**Proposal — NOT APPLIED.** PROPOSE ONLY — no edit made. Replace `(S.vol5Low.get(c.id) || 0)` with `vg.streak`, which is the same number on that branch and carries the three states by construction — the one-owner fix, not a comment. This is a copy change with no behavioural effect today, so it does not ride the deployment gate. If it is left as-is, it should at minimum be listed in the clamp/dead-guard enumeration with the reason it cannot fire named (the `VOL5_BIND_REFRESHES ≥ 1` relationship), so the next reader does not have to re-derive the inertness — and so the `VOL5_UNIVERSE` flip has to account for it.

---

## 42. [HYGIENE] [R76.1]'s control-hash conjunct is a tautology — it compares cfgHash(liveMarketConfig()) against a value scorerConfigs assigned from that same call

- **Verdict:** CONFIRMED · **Finder's bite call:** NO - proven inert · **Scope:** `ring-a-seam`
- **Failure mode:** 1 (tautology / short-circuit — a conjunct that is already true regardless of the term under test)
- **Assertion:** [R76.1] the grid is 16 cells with exactly one control — the live config, deduped by hash
- **Condition:** `cells76.length === 16 && cells76.filter(c => c.control).length === 1 && cells76.find(c => c.control).hash === cfgHash(liveMarketConfig()) && new Set(cells76.map(c => c.hash)).size === 16`

**Evidence.**

Both branches of `scorerConfigs` guarantee the conjunct: the dedup branch sets `control` on the cell whose hash already equals `liveHash`, and the fallback branch pushes a cell constructed with `hash: liveHash`. `cfgHash` is pure and `liveMarketConfig()` is read twice within the same synchronous assertion, so the two reads cannot differ. The conjunct is true for any implementation of `scorerGrid` and any config. It does no harm — `length === 16` and the 16-distinct-hashes conjunct carry the real dedup claim — but it reads as a check on the control's identity and is not one. Worth naming so a later reader does not count it as coverage.

**Production cited.**

```js
`function scorerConfigs(){`
`  const cells = scorerGrid().map(c => ({ cfg: c, hash: cfgHash(c), control: false }));`
`  const live = liveMarketConfig();`
`  const liveHash = cfgHash(live);`
`  const dup = cells.find(x => x.hash === liveHash);`
`  if (dup) dup.control = true;`
`  else cells.push({ cfg: live, hash: liveHash, control: true });`
`  return cells;`
`}`
```

**Verifier method.** Read index.html `function scorerConfigs` in full plus `const liveMarketConfig` and `const TICKF = () => Math.max(1, DB.tickFloor || 15);`. Read tools/probe/probe-snippet.html §76's `DB.filtersT1.vol = 1000; DB.tickFloor = 15;` pin and the `[R76.1]` condition, checking for any interleaved mutation between `const cells76 = scorerConfigs();` and the `ok(...)` call — there is none.

**Verifier says.** Both branches of production guarantee the conjunct, as quoted and in context: `const dup = cells.find(x => x.hash === liveHash); if (dup) dup.control = true; else cells.push({ cfg: live, hash: liveHash, control: true });` — the dedup branch marks a cell selected BY hash equality with `liveHash`, and the fallback constructs the cell with `hash: liveHash`. So `cells76.find(c => c.control).hash === cfgHash(liveMarketConfig())` holds for any `scorerGrid()` and any config. The two `liveMarketConfig()` reads cannot differ within the assertion: it is `const liveMarketConfig = () => ({ roi: GATE.roi, ..., volDecline: GATE.volDecline })` over synchronously-read globals, with `TICKF` = `() => Math.max(1, DB.tickFloor || 15)`, and the probe pins `DB.filtersT1.vol = 1000; DB.tickFloor = 15;` at the block head. `cfgHash` is a pure string hash. Nothing between the two reads mutates GATE or DB.

**Correction to the finder.** None. The finder's own assessment is right that the surrounding conjuncts (`cells76.length === 16` and `new Set(cells76.map(c => c.hash)).size === 16`) carry the real dedup claim, so this is a slot-occupancy problem rather than a coverage hole — hygiene, correctly graded.

**Proposal — NOT APPLIED.** PROPOSE ONLY: replace it with a conjunct that can fail — e.g. assert the control cell's `cfg` deep-equals `liveMarketConfig()` field by field (which catches a dedup that matched on a hash collision rather than on the vector), or drop the conjunct and let `length === 16` carry the dedup claim alone.

---

## 43. [HYGIENE] [R77.3] deletes six rdiff fixture keys and asserts one of them absent; the label is plural

- **Verdict:** CONFIRMED · **Finder's bite call:** PROBABLY NOT · **Scope:** `ring-a-seam`
- **Failure mode:** 8 (label overclaims) — plural claim, single-instance check
- **Assertion:** [R77.3] rdiff fixture rows are cleaned up
- **Condition:** `(await t0Get("rdiff", S.min5At)) === undefined`

**Evidence.**

The cleanup targets six keys at 300e3 spacing back from the final `S.min5At`; the assertion reads back exactly one. The probe profile persists between runs (the §75 header states this explicitly: "The profile PERSISTS between runs"), so a spacing or arithmetic error in the delete loop leaves rdiff rows accumulating in the profile across runs with the cleanup assertion still green — the same accumulation risk [R75.4] guards against on the m5 side, where it is done properly by asserting `t0Keys(...).length === 0` over the whole fixture range.

Severity is hygiene rather than correctness because these are probe-profile leftovers, not user data; but the pattern is the one the suite already knows how to get right one block earlier.

**Production cited.**

```js
probe: `await (async () => { const d = await t0Open();\n      const os = d.transaction("rdiff", "readwrite").objectStore("rdiff");\n      for (let k = 0; k < 6; k++) os.delete(S.min5At - k * 300e3);\n    })();`
```

**Verifier method.** Read tools/probe/probe-snippet.html from the §75 header comment through `[R75.4]`, then the whole §76 block, tracking every `S.min5At` assignment and every `scorerCycle()` call to count rdiff writes; matched the delete loop and the `[R77.3]` condition. Read index.html `function scorerCycle`'s two early-return guards to confirm which cycles write nothing.

**Verifier says.** The cleanup and the assertion are as quoted: the loop is `for (let k = 0; k < 6; k++) os.delete(S.min5At - k * 300e3);` and the check is `(await t0Get("rdiff", S.min5At)) === undefined` — one key of six. I counted the §76 block's rdiff-writing cycles by tracing every `S.min5At` mutation from `S.min5At = day76 + bktH76 * 3600e3;` forward: run1 (the immediate re-run returns null at `if (S.scoredBucket === S.min5At) return null;` before any accrual), then five `S.min5At += 300e3` steps each followed by a scoring cycle — with the [R76.11] guarded call returning at `if (!S.min5At || !S.latestAt || !S.items.length) return null;` before the bucket is consumed or the row written, and the catch-up cycle writing that bucket. Six buckets, six rows, and the loop's span (k = 0..5 back from the final `S.min5At`) covers exactly those six — correct today, and unverified by the assertion. The contrast the finder draws is real: one block earlier, `[R75.4] fixture cleanup leaves no keys in the fixture range` asserts `leftover.length === 0` where `const leftover = await t0Keys("m5", T75, T75 + 1e9);`. The persistence premise is in the §75 header verbatim: "The profile PERSISTS between runs, so fixtures use run-unique keys ... and clean up after themselves".

**Correction to the finder.** Worth stating explicitly since the finder did not: the loop is currently CORRECT — six writes, six deletes, no orphan today. The finding is about the check, not a live leak, which supports the hygiene severity.

**Proposal — NOT APPLIED.** PROPOSE ONLY: match [R75.4]'s shape — assert `(await t0Keys("rdiff", firstBucket, S.min5At)).length === 0` over the block's whole bucket range instead of a single `t0Get`, and fix the label to match whatever range is actually checked.

---

## 44. [HYGIENE] [R40.4] "seasoning spans a CALENDAR DAY" is clock-intermittent — red on any run started between 00:00 and 06:00 local

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `ring-b-operator-log`
- **Failure mode:** Fifth face (the intermittent assertion) — an assertion whose result depends on an ambient input it neither injects nor holds invariant
- **Assertion:** [R40.4] seasoning spans a CALENDAR DAY — four touches cannot buy same-day qualification
- **Condition:** ``!qualSpanned({ firstAt: Date.now() - 6 * 3600e3, lastAt: Date.now() }) && qualSpanned({ firstAt: Date.now() - dayMs40, lastAt: Date.now() })``

**Evidence.**

Production:
  const qualSpanned = q => scheduleOn()
    ? new Date(q.firstAt).toLocaleDateString("en-CA") !== new Date(q.lastAt).toLocaleDateString("en-CA")
    : (q.lastAt - q.firstAt) >= QUAL_SPAN_MS;

The §40 block runs with a schedule on — `DB.touchWindows = sched40();` and the block's own [R40.1] asserts `scheduleOn() && …` — so the calendar-date limb is the live one. The first conjunct asserts that `now - 6h` and `now` are the SAME local date. Between 00:00:00 and 05:59:59 local they are different dates, `qualSpanned` returns true, the negation is false, and the assertion goes red for a reason unrelated to its claim. That is roughly a quarter of the clock.

The second conjunct (`now - 24h`) is safe — 24h earlier is always the previous local date. The companion "[R40.4] and counts at most one pass per TOUCH" is also safe: `sched40()` places its first window ~5h out, so `nextTouchAt(t0).at <= t0 + 60e3` cannot fire.

This matters here because the SAME block is the sole detector for the calendar-day rule (see the next finding), so a flake in it is a flake in the only coverage seasoning's ruled span has. The §40 block already knows the pattern — its own header comment says "The schedule is INJECTED relative to a known clock position throughout, per the standing rule about clock-dependent assertions", and [R40.1] was split for precisely this reason. The injection was simply not carried into [R40.4].

**Production cited.**

```js
const qualSpanned = q => scheduleOn()
  ? new Date(q.firstAt).toLocaleDateString("en-CA") !== new Date(q.lastAt).toLocaleDateString("en-CA")
  : (q.lastAt - q.firstAt) >= QUAL_SPAN_MS;
```

**Verifier method.** Read probe-snippet.html §40 in full (the `keepSched`/`hNow40`/`mk40`/`sched40` fixture through `[R40.4]` and the `at40` helper), matching the assertion text exactly; read `qualSpanned`, `qualGapCleared`, `QUAL_SPAN_MS`, `scheduleOn`, `touchWindows` and `TOUCH_DEFAULT` in index.html; traced `touchWindows()`'s `ws.length >= 2 ? ws : TOUCH_DEFAULT.slice()` fallback to establish `scheduleOn()` is unconditionally true in this block.

**Verifier says.** The assertion, verbatim:
    ok("[R40.4] seasoning spans a CALENDAR DAY — four touches cannot buy same-day qualification",
       !qualSpanned({ firstAt: Date.now() - 6 * 3600e3, lastAt: Date.now() })
       && qualSpanned({ firstAt: Date.now() - dayMs40, lastAt: Date.now() }),
       "same-day rejected, rollover accepted");
with `const dayMs40 = 86400e3;` above it.

Production, verbatim:
  const qualSpanned = q => scheduleOn()
    ? new Date(q.firstAt).toLocaleDateString("en-CA") !== new Date(q.lastAt).toLocaleDateString("en-CA")
    : (q.lastAt - q.firstAt) >= QUAL_SPAN_MS;

The schedule limb is the live one here, and I confirmed it two ways. `DB.touchWindows = sched40();` where `const sched40 = () => [mk40(hNow40 + 5), mk40(hNow40 + 10), mk40(hNow40 + 15), mk40(hNow40 + 20)].sort((a, b) => a - b);` gives four distinct hours, and `const scheduleOn = () => touchWindows().length >= 2;` — `touchWindows()` returns the set unless it is under 2, in which case it falls back to `TOUCH_DEFAULT` (also 4), so `scheduleOn()` is true here on any clock. `[R40.1]` in the same block asserts `scheduleOn() && …` directly. The schedule is restored to `sched40()` after the empty-schedule sub-test (`DB.touchWindows = []; … DB.touchWindows = sched40();`), so it is in force when [R40.4] runs.

So the first conjunct asserts that `now − 6h` and `now` fall on the same local calendar date. Between 00:00:00 and 05:59:59 local they do not, `qualSpanned` returns true, the negation is false, and the assertion goes red for a reason unrelated to its claim — roughly a quarter of the clock. The second conjunct (24h back) is safe on a normal day.

The finder's companion checks also hold: `[R40.4] and counts at most one pass per TOUCH` uses `nextTouchAt(t0).at + 60e3` against a schedule whose first window is ~5h out, so it cannot fire spuriously. And the block's own header states the discipline it then failed to apply here: "The schedule is INJECTED relative to a known clock position throughout, per the standing rule about clock-dependent assertions."

**Correction to the finder.** One edge the finder did not name, which does not change the verdict: the second conjunct is not unconditionally safe either. On a spring-forward DST day, `Date.now() − 86400e3` maps to a local time one hour later than the same wall clock, so a run at ~23:00 local can land `firstAt` on the same calendar date and redden that half too. Rare, but it is the same root — an assertion reading an ambient input it neither injects nor bounds.

**Proposal — NOT APPLIED.** PROPOSE ONLY: inject the instant rather than reading the wall clock — build both fixtures from a pinned local noon (e.g. `const noon = new Date(); noon.setHours(12,0,0,0);` then `firstAt: noon - 6h, lastAt: noon` for the same-day case and `noon - 24h → noon` for the rollover), matching what [R40.1] already does for the gap. Do NOT pin the ambient clock globally — the fifth-face ruling forbids that, and S.latestAt staleness depends on it being real. Would need a run at a 03:00 local clock to demonstrate the flake; I cannot run anything.

---

## 45. [HYGIENE] The one per-item-cap size assertion does not state which input pins it, and its own comment names the wrong term

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `ring-b-sizing-caps`
- **Failure mode:** 8 label overclaims / the clamped-output rule's "state WHICH INPUT PINS ITS OUTPUT" is unmet
- **Assertion:** item outside the cluster cap lands at the PER-ITEM cap (a clamp test; the sizing term is asserted separately)
- **Condition:** `!!gamma && gamma.allocQty === 5000 && !(gamma.sizeNotes || []).some(s => /cluster/.test(s))`

**Evidence.**

The assertion's own preamble says "5000 IS the per-item cap, and the horizon term for gamma computes 30000, so the item is neither uncapped nor funded full". The first half is imprecise in a way that matters: there is no "per-item cap" constant. 5000 is `byPart` (10,000 = floor(1h vol 100000 x partCap 0.10)) halved by the unproven-T1 ramp. `x.qty` (planCap = 16,666) and `byLiquidity` (30,000) are both non-binding, and the per-slot budget term `floor(min(perSlot, pool) / buy)` = floor(21,428,571 / 4000) = 5,357 is also non-binding. The assertion does bite for its own subject (removing either byPart or the T1 halving changes 5000), so it is sound as a test — but the constitution's qualification requires an assertion downstream of a clamp to name its pinning input, and this one names a cap that does not exist while the two terms that actually pin it go unnamed. That is how the byLiquidity gap above stayed invisible: the reader is told the horizon term is "asserted separately", and it is — for a different code path.

**Production cited.**

```js
    const byLiquidity = Math.floor(x.volGate * FILLH() * GATE.capture);
    const byPart = Math.floor((x.c.vol || 0) * partCap());
    const preRamp = Math.min(x.qty, byLiquidity, Math.max(0, byPart));
...
  if (x.tier.t === 1 && !x.tier.proven){ cap = Math.floor(cap * 0.5); notes.push("unproven T1 — half size until 2 net-positive round trips"); }
```

**Verifier method.** Grepped both files for 'per-item cap' (two comment hits, no code); read the probe's renaming preamble at lines 176–186 and the assertion body; read sizeLine, applySizeFactors, planCap, planQty, partCap and calc's vol/volSide in index.html; computed each of the four candidate pinning inputs from the fixture values I read.

**Verifier says.** `grep -n "per-item cap" index.html tools/probe/probe-snippet.html` returns exactly two lines, both comments — index.html's extraction preamble ("downstream of the per-item cap, the one-third clamp and the cluster cap") and the probe's ("5000 is the per-item cap"). There is no per-item cap constant or function in production. Traced from source, 5000 is byPart (`Math.floor((x.c.vol || 0) * partCap())` = floor(100000 × 0.10) = 10000, with `partCap()` defaulting to 10/100 since the fixture never sets DB.partCapPct) halved by `if (x.tier.t === 1 && !x.tier.proven){ cap = Math.floor(cap * 0.5); ... }`. The three other candidates are all non-binding: x.qty = planCap = 16666, byLiquidity = 30000, and the per-slot budget term floor(min(21428571, 100e6)/4000) = 5357. The assertion does bite for its own subject — deleting byPart gives 5357, deleting the T1 halving gives 5357-then-poured — so it is sound as a test; the defect is that the constitution's clamp qualification ("an assertion downstream of one must state WHICH INPUT PINS ITS OUTPUT") is unmet and the stated input is fictional.

**Correction to the finder.** One attribution correction: the imprecise term did not originate in the probe. index.html's own extraction comment says "the horizon term sat inline in candidateFor, downstream of the per-item cap, the one-third clamp and the cluster cap" — the probe comment inherited the phrase from production. Severity is right at hygiene, but this is the same root as finding 1: the author's mental model of the sizing chain names caps that do not exist while missing the two terms that actually bind.

**Proposal — NOT APPLIED.** Rename to name the pinning inputs and the ramp: e.g. "item outside the cluster cap lands at the participation cap halved by the unproven-T1 ramp (byPart 10,000 x 0.5; planCap 16,666 and byLiquidity 30,000 are both non-binding here)". No behaviour change — the test is worth having under its real name, exactly as the earlier scan-14 rename of this same line established.

---

## 46. [HYGIENE] [R92.2]'s third conjunct is inert — the negative-lookahead regex can only fire in a case the first conjunct already covers

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `new-session-assertions`
- **Failure mode:** 1 (a conjunct that cannot independently change the result)
- **Assertion:** [R92.2] slot A renders the pair `n of obs` and a percentage may appear only BESIDE it — 93 of 108 and 93% are different claims and only the first is rulable
- **Condition:** `/funded 42 of 60 observed cycles/.test(dot4) && /70%, shown beside the pair and never instead of it/.test(dot4) && !/^(?!.*42 of 60).*70%/.test(dot4)`

**Evidence.**

`dot4` is a single-line HTML string. With `^` anchoring and no `m`/`s` flag the regex is evaluated only at index 0, where the lookahead `(?!.*42 of 60)` fails because the string does contain "42 of 60" — so `test` returns false and `!test` is unconditionally true. It can become informative only if the pair vanishes entirely, which the FIRST conjunct already catches. So the label's "only" — a percentage may appear only beside the pair — is carried by a conjunct that adds nothing, and is exercised against one rendered instance. Not harmful, but it reads as protection and is not.

**Production cited.**

```js
    + '" title="Pool persistence: funded ' + pair + ' observed cycles since it entered the pool'
    + (pct != null ? ' (' + pct + '%, shown beside the pair and never instead of it)' : '')
```

**Verifier method.** Read the [R92.2] assertions in probe-snippet.html; read `function poolDot(id)` in index.html in full, including the terminal return with `' (' + pct + '%, shown beside the pair and never instead of it)'`, confirming the output is a single line.

**Verifier says.** `dot4 = poolDot(770004)` returns a single-line HTML string (`poolDot` concatenates one `<span class="dslot">…` with no newlines). `/^(?!.*42 of 60).*70%/` has `^` with no `m` and no `s` flag, so it is attempted only at index 0; there the lookahead `(?!.*42 of 60)` fails because the string does contain "42 of 60", and the regex fails outright. `test` returns false, `!test` is unconditionally true. It can become informative only if "42 of 60" disappears from the string entirely, which the first conjunct `/funded 42 of 60 observed cycles/` already catches. So the label's "only" — a percentage may appear only BESIDE the pair — is carried by a conjunct that adds nothing, and the property is exercised against the one rendered instance. Not harmful, correctly rated hygiene.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: either delete the conjunct as decoration, or make it a real ordering check — assert `dot4.indexOf('42 of 60') < dot4.indexOf('70%')` and that no `%` appears in the `first-cycle`/`accruing` tooltips where `pct` is not rendered beside a settled pair. Marked YES on wouldBite because the assertion as a whole does bite; only this conjunct is inert.

---

## 47. [HYGIENE] [R90.1]'s 'single writer for all four push sites' is exercised against the writer alone

- **Verdict:** CONFIRMED · **Finder's bite call:** YES - looks sound · **Scope:** `new-session-assertions`
- **Failure mode:** 8 (universal exercised against one instance — the claim is about the four call sites, the condition is about the function)
- **Assertion:** [R90.1] every gateLog row carries the CANDIDATE's own provenance — the row is about one item, so the day decomposes inside itself and not only between days
- **Condition:** `(() => { const r = gateLogRow("2026-08-18", { id: 5, src: QUAL_SRC_POOL }, "roi", 1.1); return r.d === "2026-08-18" && r.id === 5 && r.g === "roi" && r.v === 1.1 && r.src === "pool"; })()`

**Evidence.**

R90.1 states the property as "`gateLogRow` is the single writer for all four push sites (bench, funded, seasoning, die-off), so the stamp cannot be attached by three paths and forgotten by the fourth". I verified by grep that all four current pushes do route through it (`DB.gateLog.push(gateLogRow(dToday, b, g, v))`, `... p, "funded" ...`, `... x, "seasoning" ...`, `... b, "die-off detected" ...`), so the claim is TRUE today — but it is true by inspection, not by assertion. A fifth push written inline would satisfy every assertion in §90. Both [R90.1] assertions are otherwise sound and discriminating (the absent-src case checks `hasOwnProperty` rather than `undefined`, which is the right distinction).

**Production cited.**

```js
const gateLogRow = (d, x, g, v) => {
  const row = { d, id: x.id, g, v };
  if (x.src) row.src = x.src;   // absent = pre-stamp; never defaulted, for the same reason DB.qual's is not
  return row;
};
```

**Verifier method.** Read both [R90.1] assertions in probe-snippet.html; read `const gateLogRow = (d, x, g, v) => {…}` in index.html; ran `grep -n "gateLog.push\|gateLogRow" index.html` (five hits, enumerated above) and `grep -n "gateLog" probe-snippet.html | grep -i "src"`; read REQUIREMENTS.md row R90.1.

**Verifier says.** Independently verified. `grep -n "gateLog.push\|gateLogRow" index.html` returns exactly five hits: the definition `const gateLogRow = (d, x, g, v) => { const row = { d, id: x.id, g, v }; if (x.src) row.src = x.src; return row; };` and four pushes, all routed — `DB.gateLog.push(gateLogRow(dToday, b, g, v))`, `…(dToday, p, "funded", null)`, `…(dToday, x, "seasoning", null)`, `…(dToday, b, "die-off detected", null)`. So REQUIREMENTS.md R90.1's claim ("`gateLogRow` is the single writer for all four push sites … so the stamp cannot be attached by three paths and forgotten by the fourth") is TRUE today, by inspection, not by assertion: both [R90.1] conditions call `gateLogRow(...)` directly with probe-built arguments, and no assertion reads `.src` on a gateLog row that production wrote (the only other `src`-on-gateLog hits in the probe are [R90.3]'s hand-written import fixture). A fifth push written inline would satisfy every §90 assertion. Both [R90.1] assertions are otherwise sound and the absent-src case correctly uses `!Object.prototype.hasOwnProperty.call(r, "src")` rather than `=== undefined`.

**Correction to the finder.** _none_

**Proposal — NOT APPLIED.** PROPOSE ONLY: this is the enumeration half of scan 10 rather than a probe defect — either record the four sites in the requirement row as verified by inspection, or add a cheap source-shape assertion that `DB.gateLog.push(` appears only with `gateLogRow(` on the same expression. The second is a weak check and should be labelled as one if adopted.

---

## 48. [HYGIENE] [R92.4]'s negative conjunct cannot match the form it forbids

- **Verdict:** REFUTED · **Finder's bite call:** YES - looks sound · **Scope:** `new-session-assertions`
- **Failure mode:** 1 (a conjunct that is true by construction of the new implementation)
- **Assertion:** [R92.4] #planSub reads "N pass the gates, of M scored" and names its pool — never pass-over-watchlist-length, which after the flip renders an arithmetically impossible fraction like 9 of 3
- **Condition:** `/^9 pass the gates, of 412 scored \(watchlist\)/.test(planSubLine({ pass: new Array(9), all: new Array(412) }, 0)) && !/ of 3 pass the gates/.test(planSubLine({ pass: new Array(9), all: new Array(3) }, 0))`

**Evidence.**

The forbidden form was `pass.length + " of " + DB.watch.length + " pass the gates"` — it reads `DB.watch`, which `planSubLine` no longer touches, so the second call's `all: new Array(3)` cannot produce " of 3 pass the gates" under any implementation that reads its argument. A revert to the old form would be caught by the FIRST conjunct anyway. Harmless, but it is the presence/absence pairing done in a way that gives the absence half nothing to guard. The positive half is sound and correctly sourced from `planScoredN(P)`.

**Production cited.**

```js
function planSubLine(P, loadingN){
  const pass = (P && P.pass) ? P.pass.length : 0;
  return pass + " pass the gates, of " + planScoredN(P) + " scored"
```

**Verifier method.** Read the [R92.4] assertion in probe-snippet.html; read `function planSubLine(P, loadingN)` in index.html in full (`return pass + " pass the gates, of " + planScoredN(P) + " scored" + (CUTOVER_POOL ? " (pins + the control cell's pool)" : " (watchlist)") …`); ran `git show HEAD:index.html | grep -n "pass the gates"` to recover the pre-change form `$("#planSub").textContent = pass.length + " of " + DB.watch.length + " pass the gates · prices " + ago(S.latestAt)`; read REQUIREMENTS.md row R92.4.

**Verifier says.** The finder's stated reasoning does not hold. Their claim is that because the old form read `DB.watch`, "the second call's `all: new Array(3)` cannot produce ' of 3 pass the gates' under any implementation that reads its argument." That is false. An implementation reading its argument with the old WORD ORDER — `pass + " of " + planScoredN(P) + " pass the gates"` — renders exactly "9 of 3 pass the gates" for `planSubLine({ pass: new Array(9), all: new Array(3) }, 0)`, matching `/ of 3 pass the gates/` and turning the conjunct false. So the conjunct is reachable and does guard something: the fraction-shaped phrasing that produces the arithmetically impossible reading. The finder is right on the weaker point — the DB.watch-reading regression itself is caught by the FIRST conjunct, since `/^9 pass the gates, of 412 scored \(watchlist\)/` fails the moment the denominator stops coming from `planScoredN(P)`. That makes the negative conjunct partly redundant, not inert, and the distinction is the whole basis of the finding as filed.

**Correction to the finder.** The conjunct CAN fire: any implementation that reads `P.all` but keeps the old "N of M pass the gates" ordering renders "9 of 3 pass the gates" and turns it red. What is true is narrower — the specific `DB.watch`-length regression the requirement names is guarded by the first conjunct, not by this one, so the negative half is redundant for the stated property rather than dead.

**Proposal — NOT APPLIED.** PROPOSE ONLY: if the absence half is worth keeping, aim it at the real risk — set `DB.watch` to a 3-row fixture, call `planSubLine({ pass: new Array(9), all: new Array(412) }, 0)`, and assert the output contains no "3" as a denominator. That version fails on a revert and on any future call site that reaches back to `DB.watch`.

---

## Cleared — read and judged sound, so the next run starts from a list

### search-pattern

THE ENUMERATION IS THE DELIVERABLE. Everything below was read and judged SOUND for the named pattern, so the next run starts from a list rather than from the file.

=== (a) EVERY DB.watch ITERATION IN index.html, AND WHAT IT WRITES ===
Six `for (const w of DB.watch)` loops exist; there are no `DB.watch.forEach` loops. All other ~90 DB.watch references are `.find/.filter/.some/.map` reads.
1. `for (const w of DB.watch) if (!DB.qual[w.id]) DB.qual[w.id] = { n: 3, ..., src: QUAL_SRC_GRAND }` (inside `load()`, guarded by `DB.qualV1`) → writes DB.qual. KNOWN INSTANCE 3, one-time grandfathering.
2. `itemOpsMigrate()`: `for (const w of DB.watch){ ... DB.itemOps[w.id] = r; }` → writes DB.itemOps. NOT the pattern, and it is the pattern's REMEDY: the store it writes into is universe-wide, `opsOf(id)` reads store-first/row-second via `opsPick`, and the header comment states the copy-not-move design. Verified pool-safe: `planQty` reads `opsOf(w.id).qty` with the comment "a pool item has no row and therefore no manual size, which is the correct reading, not a gap"; `provenLoser` reads `opsOf(id).tAt || (w && w.tAt)`; `itemTier` reads `opsOf(id)` and guards the row with `w &&`; `calc()` reads `opsOf(id)` for the tested pair. One-time, idempotent, `DB.itemOpsV1` guarded.
3. `renderFamilyDebug()`: `for (const w of DB.watch){ ... fams.set(k, ...) }` → local Map, family-key display only. Not item-keyed, not persisted.
4. `hoursLedger()`: `for (const w of DB.watch){ const sp = S.spark.get(w.id); ... }` → local 24-hour arrays + `srcs` decomposition rows. Display; the panel's own copy scopes the MARKET stream to the watchlist and the SHADOW stream states its observation bias.
5. `runSiblings()` graduation loop: `for (const w of DB.watch){ if (w.sib == null) continue; ... w.sibGrad = 1; delete w.sib; }` → mutates watch rows themselves. Not a cache.
6. `huntSiblings()` weakest-sibling scan: `for (const w of DB.watch){ if (w.sib == null) continue; ... }` → local `weakest` selection for eviction. Not a cache.
Plus the two collection-scoped writers that are not `for...of DB.watch` but are the pattern's own definition: `fillSparks()` over `[...DB.watch, ...DB.holds]` → S.spark (KNOWN 1), and `updateVol5Streaks()` over `vol5Population()` → S.vol5Low (KNOWN 2). And the membership-keyed prune `if (!qualRetain(DB.qual[id], now, DB.watch.some(w => w.id === +id), QUAL_RET_MS))` → DB.qual (KNOWN 3).
No DB.holds / DB.invLots / DB.sleeve / DB.positions loop writes any item-keyed cache; their only cache contribution is the holds half of fillSparks.

=== (b) EVERY ITEM-KEYED S.* AND DB.* STRUCTURE, WITH ITS WRITER'S POPULATION ===
UNIVERSE-FED (cleared — writer runs over S.items or the bulk API, so absence is real absence):
- S.byId — `S.items` mapping loop.
- S.latest / S.hour / S.min5 / S.volumes — whole `/latest`, `/1h`, `/5m`, `/volumes` payloads.
- S.volRank — `Object.entries(S.volumes).sort(...).forEach(([id],i) => S.volRank.set(+id, i+1))`; whole volumes payload. Read as `c.crowdRank`, display only ("crowded #N — margin may compress").
- S.chartCache {pts, vols} — `chartCacheLoad()` inverts the T0 h1 archive's column-packed buckets over ALL ids. This IS the built remedy for S.spark's scoping; readers `chartPts`/`chartVols`/`chartReady` all return the pre-wiring shape until `chartWireState` says ready. Verified inert today (`CHART_MIN_DAYS = 7`, observed not wall).
- S.scorerIdSets / S.scorerItemHist / S.scorerTrips / S.scorerFrontier / S.scorerCtlPass / S.scorerBlCycle / S.scorerRdiffLast — all written inside `scorerCycle()`'s `for (const it of S.items)` pass.
- DB.scorerT2 — keyed by configHash, not item.
- DB.poolSeen — `poolSeenAccrue(ctlPass, ...)`, the control cell's own pass set. Its reader `poolPersistence(id)` is the anti-pattern implemented correctly: five named states, and `not-scored` renders "NOT APPLICABLE, which is a different claim from zero" rather than a number. Reader is the plan's slot-A badge + `poolDrill` — display.
- DB.itemOps — press-driven, any item (`opsSet` is the single writer; the pool tier-override control at the `poolov` handler proves a pool item can write one).
- DB.blacklist / DB.anomalyFlags / DB.intel / DB.flagArchive — universe-scoped by nature.
FLIP-LOG-FED (cleared — DB.flips absence means "never traded", which is DATA, not a measurement gap; this is the distinction that separates the pattern from honest absence): `itemWins`, `recentNet`/`provenLoser`, `fillHistory`/`slowHistory`, `fillStats`, `reliability`, `tierProven`, `seedCounts`, `DB.seedAt`, `DB.sibBorn`.
FETCH-ON-DEMAND (cleared — the reader populates the cache itself, so there is no scoped population): `slvDailyCache` (`slvDailyFor` fetches then sets), `dailyFor`'s map, `recon5mCache` (populated for the stale paper trips that are about to be replayed), `S.tsNeg` (failure stamps, written by `sparkFor` for whatever id was tried), `S.entryWatch` (keyed by catalyst id, rows fetched in the same loop).
UI/SESSION (cleared): S.drillOpen, S.drillUI, S.wDetail, DRILLS, `warns`, DB.featTouch, DB.nudgeSnooze, DB.rulingSnooze, DB.audRuled, DB.watchSort.
OTHER-KEYED (not item-keyed): DB.cohLog ("basket:item"), DB.entryWatchState ("cat:item"), DB.strataStats (stratum), DB.gateLog / DB.deployLog / DB.obsDays / DB.dieOffLog (row ledgers).

=== (c) THE INTERSECTION — item-keyed AND written only inside a watchlist-scoped loop ===
Exactly four members, three of them the known instances:
- S.spark → KNOWN 1.
- S.vol5Low → KNOWN 2. `vol5Population()` is now the single population term and `VOL5_UNIVERSE = false` is pinned by [R94.3]; the streak's third state ships ([R91.3]) with the label "the consecutive-refresh streak is NOT COUNTED for this item".
- DB.qual → KNOWN 3. Retention is now scoped by `qualRetain(q, now, watchHas, retMs)` with the pool branch on staleness ([R87.1], [R87.2]), and `markSrc` stamps provenance centrally in `planCandidates` with a standing warn on an unmarked candidate.
- DB.itemOps → cleared above (universe store; the watch loop is a one-time migration copy, not the feeding regime).
NO FOURTH INSTANCE OF THE PRIMARY SHAPE EXISTS. The one finding I report is the MIRROR shape on the already-known S.spark cache: a reader (`huntSiblings`) running over S.items whose candidate set is defined as the complement of the cache's population.

=== (d) READERS OF THE INTERSECTION MEMBERS, CLASSIFIED ===
S.spark readers, complete (`S.spark.get` = 14 sites): `sparkFor` (TTL self-check), `fillSparks` (TTL), `candidateFor` (tr/vt/momentum/hourWeight/stabilityWeight — KNOWN 1's benches), `reachFlow` → `estFillH`/`reachFlowPerH` (SIZE-ADJACENT but honest: `state: "no-series"` returns `flow: null`, `estFillH` declines rather than substituting, and `stampPrediction` records `predBasis` as ok|no-reach|thin|no-series on every paper trip — the honest-degradation ruling, cleared), `whyBits`' `hourVerdict((S.spark.get(x.id) || {}).byHour)` (display tag "quiet hour — fills may lag"), `hoursLedger` (display), `chartedNow` (watch-only by construction — the scout's evaluability guard, and correct: it asks "did we judge THIS watch row"), the freshness panel's `maxOf(DB.watch.map(w => (S.spark.get(w.id)||{}).at || 0))` (labelled "Hour-of-day (market stream)", watch-scoped by design), `renderWatch` ×2 and `renderHolds` (display), `markout` at the flip-log reader, and `huntSiblings` — the FINDING.
S.vol5Low readers: `volGateFor` (three-state, fixed) and `candidateFor`'s bench copy — FINDING 2 (inert).
DB.qual readers: `qualState(id)` → the seasoning gate; `qualSrcCensus`; `qualRetain`. Fixed.

=== MIRROR-SHAPE SWEEP: WATCH-FED CACHE READ BY A WIDER-POPULATION LOOP ===
- `scorerCycle()`'s `for (const it of S.items)` → `marketStatsFor(id)`: reads S.byId, S.latest, S.hour, `exemptIds` ONLY. Deliberately excludes the tested pair ([R74.5] seeds this), does not read the flip log, and takes `volGate: Math.min(volHigh, volLow)` — the 1h thin side, never `volGateFor`/S.vol5Low. `isBlk` is the only operator state and is read at the cycle layer, not in the core. CLEAN.
- `runScout()` top-up over `scanScreenTier`: calls `await sparkFor(x.id)` BEFORE `candidateFor`, then requires `if (cand.failed) continue;`. Populates the cache it is about to read. CLEAN.
- `scannerShadowScan()` over `scanScreenTier`: same discipline — `await sparkFor(x.id)` before `candidateFor({ id: x.id, qty: null })`. CLEAN.
- `huntSiblings()` over S.items: does NOT fetch. THE FINDING.
- `S.lastPlanPicks` (written at buildPlan over the plan population, read by the scorer's rdiff over the universe): explicitly three-stated — `planFresh` gate, `plan: null` with `planWhy` = "plan never built this session" / "last plan build is stale (>10m)". CLEAN and exemplary.
- `cutoverPoolRows()` synthesises `{ id }` and the header states every overlay is absent by design; `pass.filter` for inventory mode does `const w = DB.watch.find(v => v.id === x.id); if (!(w && w.invTarget > 0)) return true;` — a pool item correctly falls through. CLEAN.

=== CONSIDERED AND CLEARED WITH REASONING (so they are not re-raised) ===
- `planInertLine(P)` enumerates four restraints inert for pool items (momentum, drift, 5m streak, chart gates) and scopes its claim to "restraints the archive cannot feed yet ... they return when the archive does". Two FURTHER restraints are permanently inert for a pool item — the proven-loser bench and the fill-history gate, both fed by DB.flips — and are not named there. I did NOT raise this as a finding: DB.flips absence is real data (you have not traded it), not a measurement gap, so it is honest-by-construction and outside the pattern; and the line's stated scope is the archive, which it covers exactly. Flagging only so the next reader does not re-derive it.
- `DB.dieOffLog`: writer is `candidateFor`'s die-off tag path, so its population follows the plan's; it now carries `pop: VOL5_UNIVERSE ? "universe" : "watch"` (partition-at-birth) and `DIEOFF_LOG_CAP`. Readers are the watch-row badge, gate health and the freshness panel — display. CLEAN.
- `DB.gateLog` / `DB.obsDays`: written from `bench`, i.e. whatever `planCandidates()` returned, with the ruled `src` stamp per candidate ([R90.1]) and `pool` on deployLog ([R90.2]). `daysBenchedBy(id, g, days)` returns the `{n, obs}` pair; its readers are the near-miss pile and the gate-persistence PROPOSAL copy, never a gate. CLEAN.
- `exemptIds`: a Set of ids built from the mapping by name match, read by `geTax`/`tickFloorFor`/`marginNeedFor` — universe-fed, not watchlist-fed. CLEAN.
- `S.tsNeg` + the `/timeseries` circuit breaker: per-id failure stamps with TTL, read only to avoid re-hitting a failed id. A miss means "not recently failed", which is the correct reading. CLEAN.
- `excFor(id)` / DB.shadowExceptions: user-granted per item; absence = no exception granted, which is exactly true. `excStanding` even carries an explicit `watched: (DB.watch || []).some(w => w.id === id)` field rather than inferring. CLEAN.
- `clusterExposure` / `clustersInPlay`: keyed by cluster and fed from DB.positions + DB.invLots, which is the correct population for "capital already committed". CLEAN.

=== WHAT WOULD SETTLE THE ONE THING I COULD NOT SETTLE BY READING ===
For finding 1 I claim `calm` is inert for essentially the whole sibling candidate space. The disjointness is proven from the source (`have.has(it.i) || continue` vs fillSparks' population), but the residual live fraction — candidates whose spark exists because `runScout` or `scannerShadowScan` fetched it earlier in the SAME session — is a runtime property I cannot measure on a frozen tree. Settling it needs a seed: instrument `huntSiblings` to count `sp != null` over one real scout cycle, or build the discriminating fixture pair described in the proposal.

### ring-a-seam

Read and judged SOUND — a seeded deletion of the named property would go red; next run can start below these:

[R74.1] — config parameterization bites. Walked the fixture: at cfgA `marginNeedCfg` gives byTax 3×2062=6186 > eMargin 3000 → the single fail `margin`; at cfgB taxMult 1 gives byTax 2062 ≤ 3000 → empty. Every other gate passes or is unknown on `st74` (roi 3.0≥1.2, skew 5≤60, imbalance 0.5 in band, tr/vt null, volGate 5000 ≥ volFloorCfg(1000,100000)=20, moState "flat"). Making the core read GATE.taxMult instead of cfg.taxMult collapses A and B → red. Caveat carried as a separate finding: the tax limb pins `Math.max`, so the tick limb is not covered here.

[R74.4] — sound AS A KEY-SET CLAIM, which is what it says. Four fixtures sweep enough limbs to reach `emitted.size >= 6`, and `[...emitted].every(g => MARKET_GATE_KEYS.includes(g))` plus the five explicit `!emitted.has(...)` operator-gate names would go red if an operator gate name leaked into the core's vocabulary. `MARKET_GATE_KEYS.every(k => !/\d/.test(k))` genuinely forbids a constant baked into a key. It asserts no gate VALUES — correctly, that is [R74.1]'s job.

[R74.5a] — bites. `marketStatsFor(9741).buy === 4100` while `calc(9741).buy === 3000` with `tBuy` set on the watch row, and `JSON.stringify(stNoTest) === JSON.stringify(stAfter)` across the row's removal. Any path by which the instrument's builder reached `w.tBuy`/`w.tSell` moves `stNoTest.buy` to 3000 → red.

[R74.5b] — bites, and it is properly two-sided. Item 9742: buy 250 → `volFloorCfg(1000,250)` = 1000 against volGate 40, so the core reports `volFloor`; the chain's `chk(mfHas("volFloor") && itemWins(w.id) < 2, "volume floor", ...)` with two seeded profitable round trips forgives it. Deleting the `itemWins(w.id) < 2` overlay puts "volume floor" into `candW.fails` → red. Deleting the core's volume floor empties `coreW` → red.

[R76.6] — the re-derivation half bites: `imp.db.scorerT2["cWRONG"] === undefined` and `impCell.distinct === 2` (stored 99) both go red if production trusted the file's key or its stored distinct. (Its collision blind spot is filed as a finding.)

[R77.1b] — bites. `run4.rdiff.extraN === 1 && run4.rdiff.plan === 1` against production's `rdiff: { extraN: ctlPass.filter(id => !watchIds.has(id)).length, plan: planFresh ? missing.length : null }`. Removing the summary from the return → red.

[R77.2] — the never-built limb bites: `rrow2.plan === null && /never built this session/.test(rrow2.planWhy || "")` against `const rdPlanWhy = planFresh ? null : (planPicks == null ? "plan never built this session" : "last plan build is stale (>10m)")`. Collapsing the three-state to an empty comparison → red. Noted but not filed: the OTHER limb of `rdPlanWhy` (the >10m stale path) is never exercised anywhere in the ring — a cheap second fixture, not a defect in what this assertion claims.

[R84.4] — bites on the property its label emphasises. `rdSpec.rows.some(r => r._cohort === "plan-funded · control fails" && /roi, margin/.test(r.fails))` against production's `fails: esc(m.fails.join(", "))` — truncating to the first fail key → red. `/informational/i` and `/cutover gate/` are matched inside `rdSpec.head`, a narrow container, not the page. Two elements is a thin demonstration of "FULL", and the extra-side rows carry a fixed dim string rather than a fail set, so "both … with FULL fail sets" reads slightly wider than what is checked — not enough to file.

[R76.11] and the §76 cell/hour/stock assertions were read in passing as fixture context only; they are outside Ring A and I did not adversarially verify them.

### ring-b-operator-log

Read and judged SOUND — start here next run rather than re-reading:

BLACKLIST. [R26.1] "a red flag (blacklist) bars the lane entirely" — discriminating: the immediately preceding assertion establishes `!!ev26` with the item not blacklisted, so pump and toxic are both false and `isBlk` is the only limb that can move the answer. [R4.3] "EVERY activation left the sacred set untouched — not just the one branch that cannot write" — hardened correctly via `activateChecked`, and the second conjunct (`["demand-context","catalyst","catalyst-update","cluster-membership","long-catalyst"].every(t => sacredTypes.includes(t))`) is what stops it degenerating again; the one-branch [R4.3] at line ~1456 is now belt-and-braces rather than the whole claim. [R36.3] "the blacklist is still the user's alone" — real (asserts the member is NOT added and the prop stays pending). Scorer-side [R76.10]/[R76.10b]/[R78.2]/[R78.2b]/[R84.2] are a genuine discriminating set and the production owner is single and stated (`const bl = isBlk(st.id);` at the cycle layer, with `if (bl){ … continue; }` before `ctlPass.push`).

WINS WAIVER ON THE VOLUME FLOOR. Covered in BOTH directions and I could not break it. [R74.5b] "the wins waiver is a live-chain overlay — the core reports the volume floor, the plan forgives it" asserts `coreW.some(f => f.g === "volFloor") && !(candW.fails||[]).some(f => f.g === "volume floor") && candW.wins >= 2` — bites if the waiver is deleted. The opposite direction is held by the §vol5 block, which resets `DB.flips = []` with the comment "Reset log state so the 2-wins waiver can't mask the gate" — so "second below-floor refresh binds and benches with 5m-named reason" bites if the waiver is made unconditional. Pool: `itemWins` = 0 → `0 < 2` → the floor BINDS. Restraint holds, correct direction.

EXCEPTION / PROBATION LANE. [R26.2] "the probation grant HALVES the size — asserted on the factor, with no clamp in the way" is asserted on the extracted `applySizeFactors` with three inputs including the 1-unit rail, and the probe comment records that the naive end-to-end form was seeded and proved tautological. [R26.2] "a margin under the 2× tick floor benches WITH the probation reason" — I traced the fixture arithmetic: exempt item, `tickFloorFor` = ceil(15/2) = 8, 2× = 16, eMargin drops to 10 when `S.latest[9320].high` moves 20100 → 20010, and the margin gate still passes (10 ≥ 8, 3×tax = 0), so ROI stays the only chain fail and the probation floor is what benches. Bites. [R26.3]/[R26.4]/[R26.5], [R27.2] (markout-toxic revocation), [R63.1]/[R63.2] (the standings ranking, binding clause, ETA-only-where-it-accrues, unwatched marking) all read as real and discriminating.

SEASONING PROVENANCE AND RETENTION. §87 is the best-built block in this ring: [R87.1] is an explicitly discriminating pair with both seeds recorded, [R87.2] injects its retention window rather than reaching through QUAL_RET_MS, [R87.3] holds the absent-src third state, [R87.4] evicts pool-only least-recently-seen, [R87.5] carries all three states through import, [R87.6] fingerprints the grandfathered rows. I tried to break the absent-vs-pool branch and could not.

THE THREE ALREADY-FIXED VACUOUS RESTRAINTS (not re-reported, and confirmed genuinely fixed): [R91.1] momentumState null-vs-flat with the chain reading null as "unknown"; [R91.2] stabilityWeight's three states on drifty; [R91.3] the 5m streak's NOT-COUNTED vs measured-zero. Each is asserted at the term and each has a stated seed. §92's plan surface ([R92.1]–[R92.5]) is likewise solid, and `planInertLine`'s "Unknown is not a pass" line is the right shape.

POOL QUESTION, CLEARED PER GUARD (no fourth vacuous restraint found in this subject area): isBlk fires (id-keyed operator state, and pool ids are filtered upstream anyway); provenLoser and slowHistory are correctly inapplicable, not vacuous — no flips means genuinely not-a-loser and not-slow, and both err toward the restraint staying on; the wins waiver's absence STRENGTHENS the volume floor; seasoning fires harder on pool rows; qualExemption returns null (no `c.tested`, no flips); tierProven false → half-size ramp; `planQty` sizes correctly off `planCap` with no watch row; `suspectedPump` is intel-keyed and works for any id; `cautionProvenFor` returns false for a pool item, keeping the caution cap on. The only pool-shaped concern I found is reliability's silent neutral, reported above as a weight rather than a restraint.

FALSE LEAD WORTH RECORDING SO IT IS NOT RE-CHASED: `gateName(failed)`'s regex reverse-map misfiles the probation bench copy — "exception probation: margin … under the 2× tick floor" hits `/tick floor/` and returns "margin floor (ticks / 3× tax)". I chased it and it is display-only; `DB.gateLog` and the funnel both attribute from the structured `fails[0].g`, not from `gateName`, so no count is corrupted. Not reported.

### ring-b-sizing-caps

Read and judged SOUND — start the next run from here:

• [R7.3] \"and the size actually halves — the caution shrinks capital, not just the copy\" (`pPump.allocQty === Math.max(1, Math.floor(qPumpOff / 2))`). Verified arithmetically: 9051 is T1-PROVEN (3 winning flips), so cap = min(planCap, byLiq 30000, byPart 10000) = 10000; with the caution 10000x0.5 = 5000 and the pass-3 pour adds nothing (capQty == allocQty); without it allocQty starts at 5357 (per-slot) and the pour tops it to capQty 10000. 5000 === floor(10000/2). Delete `if (rawCaution) cap = Math.floor(cap * GATE.seedSizeFactor)` and both sides equal 10000 → red. The `qPumpOff > 1` guard also blocks the degenerate max(1,...) tautology. Good construction; the design note is right that a binding clamp makes this fail loudly rather than absorb.

• [R70.1] `cautionProvenFor` at the term — five discriminating cases including the founding tautology (`cautionProvenFor(null, null, 3) === false` and `({why:\"flagged\"}, {key:\"seed\"}, 99) === false`). Deleting `!pump &&` from `const cautionProvenFor = (pump, cat, wins) => !pump && !!cat && wins >= 3;` flips two of the five. Sound. [R70.2]'s end-to-end partner correctly searches every bucket and pins `!!cautionCat(...)` true so the `!!cat` conjunct cannot pin it.

• [R26.2] the probation half-size, asserted on `applySizeFactors` at a known input with a discriminating partner (active 1000→500 vs waived 1000→1000) and the `Math.max(1,...)` floor case (1→1). No clamp between the factor and the asserted value. Reachable-fixture check passes: `sizeLine` is the production caller and constructs exactly that argument shape.

• [R4.2c] teeth 0.5x haircut. The haircut runs AFTER every cap and the pour, so nothing absorbs it; q0 = 5000 on that fixture (not degenerate), so `floor(q0/2)` discriminates. Minor fragility only: unlike [R7.3] it carries no `q0 > 1` guard, so a future fixture with q0 = 1 would make it tautological.

• The cluster exposure cap, end to end. \"one cluster member funded\", \"funded member cluster-clamped with note\" (`allocQty === 4000`) and \"committed exposure blocks the cluster\" all bite: clusterCapGp = floor(200e6 x 8/100) = 16e6 → clLim = 4000, which IS the pinning input for that pick (cap 5000 and per-slot 5357 both sit above it). Deleting the clamp funds both members at 5000. The positions limb of `clusterExposure` is covered by the second plan (16e6 exposure exactly exhausts the cap → clRoom 0 → blockedCluster).

• THE SHADOW RESERVE is covered — incidentally but genuinely. `workingStack = Math.max(0, stack() - (DB.shadowReserve || 0))` = 200e6; if the reserve stopped being excluded, clusterCapGp becomes floor(500e6 x 0.08) = 40e6 → clLim 10000 → the funded member lands at 5000 not 4000 → \"funded member cluster-clamped with note\" goes red. Worth noting the coverage is nameless: no label mentions the reserve, so a fixture edit could remove it silently.

• The participation cap `partCap()` is likewise incidentally covered — it is gamma's pinning input — plus [R18.5] on the knob's [10,100]% clamp.

• [R22.4] targetSlots (`DB.slots = 2` → `picks.length === 2 && nextUp.length === 1` with `/plan is full at 2 offers/`) and [R22.5] the freed-slot auto-promote (held item skipped, order untouched). Both bite. Untested edges: the `Math.min(8, ...)` ceiling and the `DB.slots || 7` fallback.

• [R92.3] `planGroups` — the pool item carries score 999 and still sorts by the unweighted core (eMargin x horizonUnits: 27 vs 4), so a fixture that would pass under score-sorting is deliberately present. Discriminating; sound.

• [R93.1]–[R93.7] (opsOf / opsPick / tierBandsSame / opsTierOv). Asserted at extracted terms with three-state coverage (absent/matching/differing bands), and both extractions are documented as repairs of the seventh face. `ITEM_OPS === false` is pinned so a silent flip goes red. Sound.

• [R36.2]/[R36.3] the basket auto-apply bars. The blacklist proposal carries mclass \"t\" and the 40%-cap proposal carries \"s\", so the two guards cannot cover for each other — deleting either one admits its own item. Sound.

• [R16.1]'s quote-leg limb itself (`committed() === 80 * 4000`) is correct arithmetic on a real production call; only the positions limb and the plan-level effect are uncovered (reported above).

• [R9.1] invQuote leg sizing: capFlow = floor(120 x 0.5 x 0.15 x 4) = 36 binds against need 86, so `/participation cap/` is the true reason and `buyQty < need` discriminates. The `touches === Math.ceil(need/buyQty)` half is a mild re-implementation but is checked against production's own reported need/qty, so a formula change in production goes red.

• [R74.2] the scorer core's purity assertion (forbidden-identifier source scan over `String(marketGateFails)+...`, plus ambient mutation of GATE.roi/taxMult/DB.tickFloor) is the strongest construction I read in this ring.

NOT re-derived, left for a later pass: `capReason`'s first-match attribution (byLimit vs byThird) has no assertion and is a chain-shaped attribution surface that scan 16 would want bounded; `estFillH`/`estFillTip` sizing inputs; the sleeve budget/concurrency refusals ([R1.6]/[R1.1c]) which I read but did not do the arithmetic on.

### ring-b-chart-overlays

READ AND JUDGED SOUND — start here next run rather than re-reading these.

[R91.1] all three. momentumState's five states are asserted at the term on five separate point fixtures, and the null/flat split is the actual defect that was fixed; the chain limb is asserted through marketGateEval with moState injected both ways ("unknown" vs "pass") which discriminates cleanly; the wiring limb `String(momentum).indexOf("momentumState") >= 0 && String(marketStatsFor).indexOf("momentumState") >= 0` is a source-text check, weak in kind but it does bite — I grepped the body of marketStatsFor and the literal "momentumState" occurs only on the executable line `moState: momentumState(chartPts(id), buy).state`, not in any comment, so deleting the call turns it red. `momentum({ buy: 100 }, undefined).state === null` covers the live caller's absence path.

[R91.3] volGateFor's three states. Calls production, swaps S.vol5Low for a real Map and restores it, and the two states are separated by both a value check (`streak === null` vs `streak === 0`) and mutually-exclusive copy matches including a negative (`!/0\/\d+ consecutive refreshes/` on the uncounted case, `!/NOT COUNTED/` on the counted one). This is the eleventh face handled correctly — forbidding the contradicting claim, not merely requiring the right one.

[R94.1] both. chartWireState is a pure term taking the coverage pair, so the seven-day archive is injected rather than waited for; all three states are asserted with their own fixtures including the `chartWireState(null)` could-not-check limb and its "treat as unread, never as absent" copy. The second assertion's `||` between two regex forms is defensive about whitespace rather than about the property.

[R93.1] both. ITEM_OPS pinned false, and the flag-off read-through is discriminating: DB.itemOps carries tierOv 2 / qty 99 while the watch row carries 1 / 7, and the assertion demands 1 / 7 — arming the flag turns it red.

[R93.2] opsPick called directly with four argument shapes including the both-empty case; store-first-row-second would go red on a reversal. The comment records that an earlier form re-implemented the pick and stayed green when production reversed — the extraction is the fix and it is applied here.

[R93.5], [R93.6], [R93.7] all. opsSet's band stamp and cleared migrated mark are read off the real store after a real press; the import carry asserts five rows covering well-formed, absent, short-array and non-numeric bands plus a no-recognised-field row; [R93.7] passes the flag as a PARAMETER to poolControlsHTML (the extraction pattern, third application) and scopes its absence check to `#planList` rather than document.body, explicitly citing the ninth face.

[R92.1] four no-history states through poolPersistence with an era-closed hash — the partition doing its job; [R92.3] planGroups called with a fixture where score and the unweighted core DISAGREE in order (pool item 2 has score 999 and would sort first under one ranked list, and the assertion demands "4,2"), which is a real discriminator; [R92.4] and [R92.5] both call the production line-builders and [R92.5] asserts the empty-population case renders "" — the never-fed rule applied to copy.

[R84.6] both — marketGateEval with null inputs asserted gate-by-gate for unknown-not-failing, and the ROI null limb singled out as the one that fails.
[R43.4] failProfile's shared definition, including chart-pending not counting toward the single-gate test.
[R74.5a] is sound for the property in its own label (the instrument does not see the operator's tested pair, asserted by full-object equality before and after) — my finding against it is only that the suite has no OTHER assertion covering the TTL, not that this one overclaims.
[R22.6] gateTag's "gates pending chart" vs "✓ gates" on real candidates.
[R25.7] the dot families — shape, computed colour, tooltip prefix, fixed slots, legend. testDot is handed `c.tested` rather than computing it, which is correct for a renderer; it is the absence of a calc-level TTL assertion that is the gap, not this.

NOT COVERED BY ANY ASSERTION, checked and confirmed by grep, listed so the next run does not re-derive it: `itemTier` / `tierOvStale` / `tierFromPrice` / `tierBadge` (zero hits in the probe — folded into finding 3); `hourWeight` / `HOUR_WINDOW_H` (zero hits — a 0.7–1.3 ranking multiplier, clock-reading, and it still collapses never-fed to a neutral 1.0 the way momentum and drift did before [R91], though the pool header copy does disclose it); `t2Grad`'s live one-shot at `if (ITEM_OPS) opsSet(x.id, { t2Grad: 1 }); else { w.t2Grad = 1; save(); }` (covered only incidentally as a migrated field); the `chk(!!(sp && sp.noData), "no history", ...)` limb (only ever appears as a constructed string inside failProfile fixtures — the spark-exists-but-empty state is never built). None of these is a false assertion; they are absent ones.

ALSO NOTED, NOT A FINDING IN THIS RING: `push("falling", tr <= -8, "FALLING", "7-day drift ... (the plan benches under −5%)")` hardcodes −8 and −5 in copy beside `GATE.falling` / `GATE.trendSoft` — a second reader of the same threshold that would silently disagree if either constant moved. Production hygiene, no assertion either way.

### new-session-assertions

Read and judged SOUND — next run can start from this list rather than re-deriving it.

§87. [R87.1] both halves: the discriminating pair is real — 9102 (pool, absent from DB.watch) survives and 9104/9103 (watch-src and absent-src, both absent from DB.watch) die, driven through the real `updateQualStreaks([])` with `S.qualStamp` nulled so the early return does not swallow the call. Restoring the unscoped prune reddens the first only; deleting the prune reddens the second only. [R87.2] both: `qualRetain(q, now, watchHas, retMs)` is called with an INJECTED 1000ms window (the constant is separately pinned as `QUAL_RET_MS === 30*86400e3`, which is the right shape — pin the constant, inject the window), and the absent-src row is tested under BOTH membership values, which is what makes "absent means NOT-pool" checkable. [R87.3] both: `planCandidates()` is called for the stamp, and the unmarked case puts 9106 in DB.watch precisely so retention is not what is under test — the comment says so and it is correct. [R87.4] first assertion: drives the store to QUAL_ROW_CAP+3 real rows, asserts pool-only eviction, least-recently-seen order (20000/20001/20002 gone, 20003 kept) AND the hand-curated 8001 surviving as the oldest row of all — a genuinely discriminating fixture. [R87.5] and [R87.6] both: five-state import carry through real `validateImport`, and the grandfathered fingerprint tested at four rows that each break the shape a different way (span moved, n moved, already stamped).

§89. [R89.2] both: `cutoverPoolRows()` is a real production term reachable from `planCandidates`, `S.scorerCtlPass` is written by production (line 2385), and the pin-exclusion is discriminating (9201 held, 9202/9203 synthesised). The `Object.keys(r).length === 1` check is the right shape for "minimum row". Limitation folded into finding 1.

§90. [R90.1] both: the writer is CALLED, and the absent case uses `hasOwnProperty` rather than `=== undefined`, which distinguishes absent from present-and-undefined. [R90.2] both: driven through the real `stampDeployLog` with a P of production shape; `n === 5 && pass === 2 && n !== pass` cannot be satisfied by one field standing in for the other. [R90.3] both: real `validateImport`; `dp[2].poolRegime === undefined && dp[2].n === 4` proves the unrecognised value is dropped WITHOUT dropping the row or its sibling field, which is the interesting half.

§91. [R91.1] first and second: `momentumState` is called at five distinct fixtures (empty, 2 points, flat, knife, chasing) and the chain reading is proven through the REAL shared evaluator `marketGateEval` at `liveMarketConfig()`, comparing the momentum row's state unknown-vs-pass — `marketGateFails` derives from it and the live chain calls that, so this is the product's own chain. [R91.2] first: three states at the term, with 30-point steady and wander fixtures. [R91.3] both: `volGateFor` called at three streak states through a real `S.vol5Low` Map; not-counted/0-of-N/5m-bound are separated by streak value AND by label AND by `bound`, and the negative match `!/0\/\d+ consecutive refreshes/` is the eleventh-face discipline applied correctly.

§92. [R92.1] all four: `poolPersistence` called per fixture; the observed denominator is checked as a value (obs 0 / 4 / 60) against hand-set `c0`, and era-closed is driven by a genuinely different `ch`. [R92.2] second: the SIX-GATE clause is asserted present on the nc>0 row and ABSENT on the nc=0 row — a discriminating pair. [R92.3] both: `planGroups` sorts would give 2,4 by score and give 4,2 by the unweighted core, so the fixture separates the two orderings; `PLAN_POOL_HEADER` is matched at the constant. [R92.4] positive half. [R92.5] both: `planInertLine` called with pass+bench mixed populations, and the empty-population case asserts `=== ""` exactly. [R92.6] first: GLOSSARY entry matched by presence of the property AND absence of the superseded surface wording.

§93. [R93.1] both: the store is loaded with values that DIFFER from the row (tierOv 2/qty 99 vs 1/7), so "the store is not consulted" is discriminating rather than vacuous. [R93.2]: calls `opsPick` — the extraction the author made after the seed failed to bite; store-first, row-second and both-empty are all covered. [R93.3] both: `tierBandsSame` at four inputs including a malformed 3-element array, and `opsTierOv` called as the production withhold term at three band states. [R93.4] all three: real `itemOpsMigrate`, row-level idempotency proven by resetting `DB.itemOpsV1` so the `if (DB.itemOps[w.id]) continue` guard is what answers, originals proven intact by a JSON snapshot comparison, and `setAt === 111` proves the migrated stamp comes from `w.tAt` rather than now. [R93.5]: `opsSet` called; bands stamped from `tierBandsNow()`, migrated mark cleared, setAt advanced. [R93.6]: five import fixtures covering well-formed, absent, wrong-length and wrong-type band pairs plus a row with no recognised field. [R93.7] second and third: the flag-as-parameter extraction is exercised at both values and both provenances, and the bands contract copy is matched inside the returned fragment (narrow container).

§94. [R94.1] first: three states at the term with the coverage pair injected — the right pattern, and it is what lets this be tested without a seven-day archive. [R94.2] first, second and fourth: the readers are proven inert with a POPULATED cache sitting behind a not-ready gate (which is the non-obvious half and is done right), proven live when ready, proven to return empty for an unknown id, and the momentum consumer is re-checked across a live flip of the ready flag.

CROSS-CUTTING, checked and clean: no `document.body` or whole-page match survives in the in-scope blocks — the three the author caught are the three that existed; the two remaining DOM matches are scoped to `#tradeSubs` and `#planList`. No clamp-absorption candidate found in scope: `planPoolSortKey`'s `Math.max(1, hu||1)` and `poolPersistence`'s `Math.max(0, cycles-c0)` are non-binding for every fixture used (horizonUnits 1/2/3, cycles>c0), so no assertion's subject is pinned by a clamp's other input. Constants are pinned as constants (`QUAL_RET_MS`, `DIEOFF_LOG_CAP`, `CHART_MIN_DAYS` via 7*24) rather than re-derived into expectations.

