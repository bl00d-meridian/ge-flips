# Pass 5 — NOT clean. Three money-path findings, and most of the pass is about this session's own work

**2026-08-19. Two non-overlapping readers, per-finding adversarial verification, a completeness
critic. Frozen tree, all six hashes identical at both ends.**

## The number, first

| pass | money-path findings | where they were |
|---|---|---|
| 2 | 7 | inside pass 1's fixes |
| 3 | 1 | inside pass 2's fixes |
| 4 | 0 that bite today | — |
| **5** | **3** | **two inside pass 5's own session; one pre-existing and older than all of them** |

**The cutover does not get its second zero.** One of the three bites today on any state-backup
restore and is money-path in the strongest sense — it changes what the tool tells you to do with a
real open position.

## Freeze

| file | at launch | at close |
|---|---|---|
| `index.html` | `4f8797c9759ddb10` | `4f8797c9759ddb10` |
| `tools/probe/probe-snippet.html` | `546cfcc154e22f3a` | `546cfcc154e22f3a` |
| `REQUIREMENTS.md` | `8cb56a7c1d000af8` | `8cb56a7c1d000af8` |
| `CLAUDE.md` | `6ec199c21ef16292` | `6ec199c21ef16292` |
| `MISTAKES.md` | `460081764a651976` | `460081764a651976` |
| `audits/SWEEP-2026-08-19-num-null.md` | `453b54de8cab097b` | `453b54de8cab097b` |

sha256, first 16 hex. **Pass 4's algorithm was not recoverable**, so its recorded hashes are not
comparable with these; that is stated rather than glossed.

Scope: the delta since pass 4 left the tree — 21 hunks in `index.html`, 1 in the probe, all inside
`validateImport` plus probe §103. Reader A had the diff. Reader B was forbidden it and read the
consumers of the values that now arrive as `null` where they arrived as `0`. 33 and 45 call sites
read in full. **Neither reader ran the suite and no finding rests on one.**

13 findings raw (A 8, B 2, critic 3). **12 survived adversarial verification, 1 was refuted.**
Money-path claims got three independent refuters each, on separate lenses (quotes / mechanism /
blast radius).

---

# MONEY-PATH 1 — `hzH` is dropped from real positions and standing quote legs

**Live on any restore. Pre-existing — not from this session, and not in pass 4's scope either.**
Found by the completeness critic, which runs after the verification phase and so was **not**
adversarially verified by the workflow. **Verified by hand against the source before reporting.**

A leg stamps the horizon in force when it was placed:

```
                  hzH: Math.round(planHorizonH() * 100) / 100, stage: "buying" };
```

and a standing quote does the same:

```
  w.quotePlaced = { t: Date.now(), hzH: Math.round(planHorizonH() * 100) / 100, bid: q.bid, ask: q.ask,
```

**Neither carry in `validateImport` preserves it.** The positions carry enumerates
`id, itemId, name, qty, buy, placedAt, stage, ask, stageAt, buyH, qm, lad` — no `hzH`. The
`quotePlaced` carry enumerates `t, bid, ask, sellQty, buyQty, sellFilled, buyFilled` — no `hzH`.

The reader falls back:

```
const legHorizonH = rec => {
  const h = rec && Number(rec.hzH);
  return Number.isFinite(h) && h > 0 ? h : Math.max(1, DB.fillHorizonH || 4);
};
```

**So a leg placed at the 21:30 touch under a 9.5h horizon ages against 4h after a restore.** At
05:00 it is past 2× its supposed horizon, `sellAgeInfo` returns `rung: 2`, and the sell card reads
**UNDERCUT & EXIT** on a leg that is mid-horizon. That is the tool telling you to give up spread on
a position that is behaving exactly as placed.

**The same function already knows this is forbidden — and fixes it for the simulated book only.**
The paper-book carry does `put("hzH", fin(p.hzH))` under a comment that says, in these words:

> *"`hzH` gone falls back to DB.fillHorizonH and retro-applies a horizon to a leg placed under a
> different one, which the cadence ruling forbids in those words"*

The rule was enforced for paper trips and not for real ones. **Proposal — NOT APPLIED:** carry
`hzH` on `positions[]` and inside `quotePlaced`, with an assertion at `legHorizonH`'s consumer
rather than at the carry.

---

# MONEY-PATH 2 — the settings repair moved two CAPS off their restraining floor

**Mine, from this session. Latent — needs a file carrying an explicit null. Verified 3 of 3, none
refuted.**

`partCapPct` and `clusterCapPct` are clamped `Math.max(1, …)`. Before the sweep a null gave
`num(null) = 0` → clamped to **1%**. After it, a null takes the default — **10%** and **15%**.

**For a cap, the floor IS the restraint and the default is the permissive end.** A 1% participation
cap is maximally restrictive; 10% is ten times looser. The sweep's audit filed the whole
`Math.max(1, …)` group under *"land somewhere harmless"*, which is true of the schedule and window
constants in that group and **false of the two caps**.

This is the same mistake in miniature that the sweep was correcting: a group was judged by the shape
of its clamp rather than by what each member's clamp means.

**Proposal — NOT APPLIED, because it is a ruling.** Either accept the widening on the same argument
as the budgets (null and absent must behave alike), or special-case the caps so a malformed file
cannot loosen a restraint. The second is the restraint-rule-consistent answer and it is not mine to
take.

---

# MONEY-PATH 3 — the `bands` ruling's directional claim is not universal

**Mine, written this session. Verified 3 of 3. Does not bite: `ITEM_OPS` is false and this is a
claim in a comment, not a behaviour.**

Both the pre-existing `opsOf` comment and the new `bands` comment state the direction as a
universal:

> *"Not applying is the conservative direction: an override WIDENS what the allocator may fund, so
> declining to apply one narrows."*

**That fails for `tierOv: 0`.** Zero on that field means **untiered**, and an untiered item is
*benched*. Withholding a `tierOv: 0` override therefore **removes a bench** — it widens. The
direction is a function of the override's value, not a property of withholding.

The `bands` ruling itself still stands on its own terms; what is wrong is the sentence that
generalises it. **Proposal — NOT APPLIED:** qualify both comments, and say the direction depends on
which value is being withheld.

---

# THE BIGGEST FINDING IS NOT MONEY-PATH — five of the 106 conversions were cosmetic, and the detector is blind to them

**Reported independently by reader A, reader B and the critic. Verified 3 of 3. Confirmed by hand.**

**`null >= 0` is `true` in JavaScript.** So `nz(x) >= 0` admits a null exactly as `num(x) >= 0` did.
Five sites carry a bare `>= 0` with no `!= null` companion, and all five still collapse null to
zero:

```
            if (!/^\d{4}-\d{2}-\d{2}$/.test(dd) || !(nz(x.n) >= 0)) return null;
            if (nz(p.buyQFull) >= 0) o2.buyQFull = Math.max(0, nz(p.buyQFull));
            if (nz(p.sellQFull) >= 0) o2.sellQFull = Math.max(0, nz(p.sellQFull));
            if (nz(p.buyQStrict) >= 0) o2.buyQStrict = Math.max(0, nz(p.buyQStrict));
            if (nz(p.sellQStrict) >= 0) o2.sellQStrict = Math.max(0, nz(p.sellQStrict));
```

`Math.max(0, null)` is `0`. The five other `>= 0` sites pair a `!= null` first and are genuinely
fixed; these five were **renamed, not repaired.**

**And `[R103.6]` — the assertion that certifies the class closed — reports zero `>= 0` idioms,
because it greps for `num(x) >= 0` and these are now spelled `nz(x) >= 0`.** The detector was
written against the old spelling of the very code the sweep was rewriting. It is green, it is
reading live source, and it certifies a property that does not hold.

**The critic sharpened it further, and this half is worse.** The five were left on the stated ground
that *"the app does not write nulls to these"* — **true of `null` and false of ABSENT.** `nz` maps
`undefined` to null too, and `buyQStrict` / `sellQStrict` are **absent on every paper trip until its
first credit**. So the guard collapses *never measured* into *measured zero* on ordinary data, which
is the never-fed-aggregate defect arriving inside the fix for a different defect.

---

# THE SAME TRAP IS STILL LIVE ONE FUNCTION AWAY, SPELLED WITH A BARE `+`

Inside `validateImport`, on the intel sources array:

```
                if ([0,1,2,3].includes(+s.tier)) o2.tier = +s.tier;
```

`+null` is `0`, so a null source tier restores as **tier 0** — the most authoritative source class.
The same line exists on the `intelligence.json` import path:

```
        if ([0, 1, 2, 3].includes(+s.tier)) o.tier = +s.tier;
```

The sweep missed both because it was scoped by grepping for `num(`. `[R103.6]`'s enumeration regex
looks for `[0,…].includes(num(` and is blind to `includes(+`.

## The root, and it is the rule at the top of the constitution

**The sweep was scoped to the helper's NAME rather than to the PROPERTY** — *a coercion that maps
null to 0*. `num()`, a bare unary `+`, and `>= 0` are three spellings of one hazard; the sweep
addressed one spelling, and the detector inherited the same blindness because it was written from
the same list.

That is *name the property, not the surface* — the first rule in `CLAUDE.md` — broken while writing
a different rule into `CLAUDE.md` about paired code drifting apart. It is also the second rule's
shape: `nz` and the four remaining coercions are **two owners of one question**, which is the
"one question, one term" rule failing on the commit that introduced it.

---

# TWO NUMBERS I WROTE TODAY ARE WRONG

- **"274 `num()` call sites remain"** — the frozen tree has **268**. The 274 was taken with a
  comment filter that only stripped continuation lines, so it counted mentions inside the sweep's
  own block comments. Appears in `audits/SWEEP-2026-08-19-num-null.md`, MISTAKES M169 and a probe
  comment.
- **M169's "third occurrence of the same helper producing the same defect"** — two of the three
  cited priors are a different root. The friction ledger's `exp`/`res` and the qual store's `src`
  were fields the **carry dropped entirely**, and `src` is a string the helper never touched. Only
  the item-store override is the same root as this one. **The three-occurrence count that the
  entry's framing rests on is not sound as written.**

---

# REFUTED, AND UNCERTAIN

- **A4 (refuted 2 of 3).** The claim was that `REQUIREMENTS.md` R103.5 specifies a fixed-point
  property the assertion deliberately does not test. The row does describe the two-pass structure
  and the assertion does run two passes; what it does not do is assert equality, and the row says so.
  Not a finding.
- **A8 (uncertain, unresolved).** `[R103.2]` sizes against live working capital, which it neither
  injects nor pins, so an earlier probe section could in principle move its subject. The reader
  could not settle it without reading the sections before §103 and says so. **Left uncertain rather
  than rounded either way.**

# WHAT NEITHER READER COVERED

Both declared it. Reader A did not trace consumers for all 268 remaining `num(` sites, nor 15 of the
23 settings keys beyond the numeric direction of the change. Reader B did not read `paperEconomics`
internals, the reconstruction path, the analysis export builders end to end, or the IndexedDB layer
(which `validateImport` does not touch).

**One question reader B opened and deliberately left**, because it is a carry-completeness question
rather than a null-versus-zero one, and it is worth its own pass: `DB = Object.assign(DB, v.db)`
means **any `DB` key `validateImport` does not enumerate silently keeps the importing browser's
current value rather than the file's.** It confirmed at least `itemOpsV1` and
`shadowExceptions[].mkAdverse` are in that category. It is not claiming these are defects without
enumerating all ~111 default keys against the ~100 the sanitizer writes — and neither am I.

---

# THE REPAIRS — all six ruled items, shipped and seeded

`PROBE-PASS — 1,256 assertions, COLD PROFILE, both viewports, pairing clean both directions
(483 tags / 495 rows / 483 cited)`. Cold and warm compared: identical, assertion for assertion.
Seeds **S170a–S170g**, one at a time, tree restored byte-identical between each.

## 1. `hzH` rides the carry for real legs

Added to the `positions` carry and inside `quotePlaced`, guarded `num(p.hzH) > 0` — which is the
reader's own test (`Number.isFinite(h) && h > 0`), so a zero and an absent stamp already mean the
same thing to it. **Absent stays absent deliberately:** a leg placed before the field existed was
aged against the old global at the time, and inventing a stamp would be a different defect.

Asserted at the term AND at the branch: `[R104.1]` on the carry, `[R104.2]` on `legHorizonH` — the
function that turns the stamp into a sell instruction — and `[R104.3]` on the quote leg. Seeds
S170a (both position assertions red) and S170b (the quote one).

## 2. The sweep rewritten against the PROPERTY

**`nz` is now module-scope**, beside `clampNum`, carrying the full statement of the property: *any
coercion that turns an absent or null reading into the number 0 has manufactured a measurement.*
It had to move — the second `+s.tier` site lives on the `intelligence.json` import path, outside
`validateImport`, and **a term that owns a property cannot live inside one of its callers.**

**The five guards that were renamed, not repaired**, now carry a `!= null` companion:
`walkupLoad[].n`, `shadowBook[].buyQFull`, `sellQFull`, `buyQStrict`, `sellQStrict`. `null >= 0` is
**true**, so `nz(x) >= 0` had admitted null exactly as `num(x) >= 0` did. `[R104.7]`, seed S170f.

**`[R104.8]` is the replacement detector, and it tests behaviour rather than text.** It feeds the
sanitizer one row per store with every optional field NULL, then again with every optional field
ABSENT, collects every output path whose value is the number 0, and requires that set to equal a
stated allow-list. **The null and absent fixtures produce the identical 54-path set**, which is
itself the healthy reading.

**The allow-list is the deliverable** — 54 paths in seven named groups, each a reason rather than a
count: one-time migration flags (`x ? 1 : 0`, zero is false); counters and accruals (zero is the
documented start of the count); timestamps where zero means never; sentinel ids (every real id comes
from `uid()`, so 0 is unreachable and reads as "none"); two settings whose value is legitimately
zero (`bank` unrecorded, `minExpectGp` unset); the three filter `roi` defaults, which are not
coercions at all but a spread of a constant; and — listed last and separately — the four admission
caps whose zero is **this session's ruling** rather than a pre-existing default.

**Its seed was a spelling it has never been shown.** S170g replaced `nz(p.net)` with
`Math.round(p.net)` — a coercion that appears on no list, in the code, the comments or the
assertion. `Math.round(null)` is 0, the path appeared in the set, and **`[R104.8]` went red alone**:
nothing else in 1,256 assertions could see it, which is the demonstration that a text scan would
have missed it entirely.

**`[R103.6]` is kept and relabelled.** It enumerates the three KNOWN `num`-spelled idioms and no
longer claims to close the class — which is the honest reading of what it does and the reason it
certified a false green for a day.

## 3. Both `+s.tier` sites

`[0,1,2,3].includes(+s.tier)` — `+null` is 0 and tier 0 is the **most authoritative** source class,
so an unrated source restored as an official one. Fixed in `validateImport` and on the
`intelligence.json` import path. `[R104.6]`, seed S170e — which also reddened `[R104.8]`
independently, a useful cross-check that the property detector catches a real regression without
being told what to look for.

## 4. CAPS RULED — an import may never loosen

Seven cap-like keys resolve to their TIGHT end for both null and absent: `partCapPct` and
`clusterCapPct` to **1**, `scoutT1Cap`, `scoutT2Cap`, `sibPerSeed`, `sibTotal` to **0**,
`sleeveMaxPos` to **1**. Budgets and both reserves keep their defaults.

`impTight(v, tight)` takes the tight end **explicitly rather than deriving it from the clamp**,
because **the floor is not always the tight end** — and `[R104.5]` asserts the four counterexamples
keep their defaults, which is what proves the classification was read rather than pattern-matched:
`pumpThinGp`'s floor of 0 means nothing is ever thin enough to flag; `seedTrips`' floor of 1 seeds a
lineage on a third of the evidence; `pumpWindowD`'s floor of 1 looks back a single day;
`clusterMinDays`' floor of 5 confirms a basket on a sixth of the history. **A rule that mechanically
floored every clamp would have loosened four settings in the name of a rule against loosening.**
`[R104.4]`, seeds S170c and S170d.

## 5. The two wrong numbers, and M169's count

**271 `num()` call sites** remain in `validateImport`, not 274 — the earlier figure was taken with a
comment filter that stripped only continuation lines, so it counted mentions inside the sweep's own
block comments. **101 `nz()` across 47 lines** there, plus 2 on the intel import path. Corrected in
this file, in MISTAKES M169, in the probe's §103 header and in `HANDOFF.md`.

**M169's occurrence count was wrong and the correction is recorded in the entry rather than edited
over it.** It claimed *"the third occurrence of the same helper producing the same defect"* citing
the friction ledger's `exp`/`res`, the qual store's `src`, and the item store's cleared override.
**Only the last is the same root** — the other two are the carry-completeness defect, fields the
sanitizer dropped entirely so they restored as *absent* rather than as *zero*, and `src` is a string
`num()` never touched. **The corrected standing: this coercion has two recorded occurrences, and
neither pattern reaches the three-instance bar on its own.**

## 6. The bands sentence — ruling kept, claim fixed

Both the new `bands` comment and the pre-existing one above `opsOf`'s band states said withholding
an override is the conservative direction, **as a universal**. `tierOv: 0` is the counterexample:
zero means untiered, an untiered item is benched, so withholding *that* override removes a bench and
widens. Withholding a `tierOv: 1` or `2` narrows.

**The ruling stands on its own terms** — a malformed stamp must not become an applied override — and
now rests on the argument that actually holds: withholding is the **smaller** change, because it
leaves the item where the untouched book already had it. That needs no claim about direction, and
the claim was false.

---

## Still owed from pass 5

- **`dieOffLog[].voidH` is write-only** — set when an episode is voided as noise, carried faithfully
  by the import, read nowhere. The `voidHs` array that looks like its reader recomputes
  `(e.rec - e.t) / 3600e3`, a different quantity. Pre-existing; no assertion holds it alive; not
  named as a staged store.
- **`[R103.2]`'s ambient dependence on working capital** (pass 5 finding A8, left uncertain). It
  sizes against a value it neither injects nor pins, so an earlier probe section could move its
  subject. Unresolved rather than dismissed.
- **The `DB` key enumeration** — `DB = Object.assign(DB, v.db)` means any key `validateImport` does
  not write silently keeps the importing browser's current value. Queued by the user as its own
  pass, in three buckets: deliberate, harmless, wrong. **This is the same restore path that dropped
  `hzH` and turned `qty: null` into zero**, which is why it earns an enumeration rather than a spot
  check.
