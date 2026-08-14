# Tracker Review — prioritized improvements

Critical review of `index.html` (single file, ~68 KB, no deps).
Effort **S** = under an hour · **M** = a focused session · **L** = a rebuild of something.
Impact **1–5**, where 5 means it changes what you actually do in-game or costs you gp.

Ordered by impact within each section.

> **Status: sections 1–4 are all implemented as of 8 Aug 2026.** This file is now the record of
> *why* each change was made rather than a to-do list. Section 5 remains rejected by design.
> The one item that could not be closed in code is **4.1 (phone access)** — it needs a hosting
> decision from you; the layout work is done but the file still lives on a laptop disk.

---

## 1. BUGS / CORRECTNESS

### 1.1 `gp()` deletes significant digits — **VERIFIED, live right now** · S · **5**
`.replace(/\.?0+$/,"")` strips trailing zeros even when there is no decimal point.
Measured output: `100,000,000 → "1m"` · `250,000,000 → "25m"` · `790,000,000 → "79m"` · `-790,000,000 → "-79m"`.
Only bites values ≥100m whose millions digits end in zero, which is why `792,000,000 → "792m"` looks fine and
the bug survived. **This is on the Shadow Fund tab**, the one place you read a nine-figure number: the Shadow's
live price, "Still needed", and every gear target price are understating by up to 10×.
*Sketch:* `const trim = s => s.includes(".") ? s.replace(/\.?0+$/,"") : s;` and route both the `m` and `b` branches through it.

### 1.2 Bank + realized profit double-counts your stack — M · **5**
`stack() = DB.bank + realized()`. You read the bank field off your *actual in-game bank*, which already contains
the profit from every flip you logged. So each logged flip inflates the stack twice. This is not cosmetic: `stack()`
drives the one-third clamp (so positions get sized too large), the Total row, and the Shadow progress bar.
It is also self-worsening — the longer the log, the larger the error.
*Sketch:* relabel the field "bank value **excluding** logged profit", or store a `bankAsOf` timestamp and only add flips logged after it.

### 1.3 Liquidity gate counts the wrong side of the book — S · **4**
`c.vol = highPriceVolume + lowPriceVolume`. To *buy* you need people selling into your offer — that's one side, not
the sum. The `volume ≥ 4× plan qty` gate and the scanner's volume floor both overstate available liquidity, roughly
2× on a balanced item and much worse on a lopsided one.
*Sketch:* gate on `lowPriceVolume` for the buy leg and `highPriceVolume` for the sell leg; keep the sum for display only.

### 1.4 Margin comes from two unrelated instants — M · **4**
`/latest` gives the last high trade and the last low trade, which may be seconds or hours apart and may each be a
one-off. A "margin" built from them can be an artifact that never existed as a simultaneous spread. This is the
mechanism behind most of the `check me` rows.
*Sketch:* compute a second margin from `/1h`'s `avgHighPrice`/`avgLowPrice` and show both; bench anything where they disagree by >30%.

### 1.5 Tax exemptions match by name and fail silently — S · **4**
`EXEMPT_SET` is keyed on exact lowercased names from `/mapping`. This already broke once: seven teleport tablets
carry a `(tablet)` suffix I hadn't matched, so they were taxed when they shouldn't be. Nothing in the app would
have told you — margins were just quietly 2% low. A wiki rename re-breaks it at any time.
*Sketch:* after `applyMapping`, assert `exemptIds.size === 48` and surface a visible banner if not.

### 1.6 `trendPct` is endpoint-to-endpoint — S · **3**
`(last - first) / first` over 7 days. An item that crashed 20% and recovered reads as "flat chart", and a single
bad final data point can flip the gate. The gate that's supposed to keep you off knives is the shallowest
calculation in the file.
*Sketch:* use a least-squares slope over the series, or median of first/last quartile instead of single points.

### 1.7 Sparkline silently mixes two different series — S · **3**
`p.avgHighPrice ?? p.avgLowPrice` — when an hour has no high trades it substitutes the low price, injecting a fake
drop of exactly the spread width. Feeds 1.6's trend gate.
*Sketch:* plot the midpoint when both exist, `null`-gap the segment when neither does.

### 1.8 Shadow price staleness is invisible — S · **3**
Tumeken's Shadow trades ~27/hour. Its `/latest` entry can be hours old while the header cheerfully says
"prices 12s ago" (true of the *fetch*, not of *that item*). The denominator of your headline progress bar can be
badly stale with no indication.
*Sketch:* show `ago(L.highTime*1000)` next to the Shadow price, amber past ~6h.

### 1.9 `/1h` volume is up to 60 min old while the freshness filter is 60 min — S · **2**
Two different clocks presented as one. An item can pass "data age ≤ 60 min" on price while its volume is from an
hour ago and the market has since died.
*Sketch:* display the `/1h` fetch age in the volume column header; it's already tracked as `S.hourAt`.

### 1.10 "no chart yet" conflates *loading* with *no data exists* — S · **2**
Items with no timeseries are benched forever with a message implying they'll resolve on their own.
*Sketch:* cache a `noData` flag when `/timeseries` returns an empty array and word the bench reason accordingly.

### 1.11 Checklist date rolls only when the Routine tab renders — S · **2**
`DB.checks.date !== today()` is checked inside `renderRoutine`. Leave the app open overnight on another tab and
yesterday's ticks persist until you visit Routine.
*Sketch:* move the roll into `refresh()`.

### 1.12 Flip log stores the item name at log time — S · **1**
Renamed items produce two rows in the per-item table. Cosmetic; `itemId` is what's used for tax.

---

## 2. WORKFLOW FRICTION
*Constraint respected throughout: propose and prefill, never log or decide.*

### 2.1 Open positions don't exist in the model — L · **5**
The app knows watchlist items and *completed* round trips. It has no concept of "I bought 6,500 manta at 1,015 this
morning and they're sitting in my sell slot." So the evening touch can't tell you what to relist, the one-third
clamp can't see committed capital, and every flip must be entered from memory hours later. This is the single
biggest gap between the tool and the two-touch routine.
*Sketch:* an `openPositions` array written from Today's Plan on your confirmation; evening mode reads it and prefills the sell side.

### 2.2 The margin test — the guide's "truth" — is captured nowhere — M · **5**
§3 says buy one unit, sell one unit, and trust *that* spread over the displayed one. There's no field for the
result, so the tested number lives in your head and the tool keeps ranking on the number the guide told you to distrust.
*Sketch:* a "tested" price pair per watchlist row; when present, Today's Plan uses it instead of `/latest` and tags the line "tested".

### 2.3 Evening relist prices aren't proposed — S · **4**
Morning gets a full checklist; evening gets generic prose. You re-derive sell prices by hand at the exact moment
you're tired and most likely to accept a bad number.
*Sketch:* an evening variant of Today's Plan: "SELL 6,500 manta at 1,032 (tested margin 137k)".

### 2.4 Yesterday's plan can't become today's log — M · **4**
You executed 3–5 specific lines last night. Logging them means retyping every item, qty and price into a form.
*Sketch:* persist each generated plan; a "log from yesterday's plan" button prefills one form per line, still requiring your press per flip.

### 2.5 Deletes are instant and unrecoverable — S · **3**
The `✕` on a flip row fires immediately. One misclick silently destroys a row of the only dataset you can't rebuild.
*Sketch:* soft-delete with a 5-second "undo" toast — the toast already exists.

### 2.6 The plan doesn't flow into the checklist — S · **3**
Morning step 3 says "place buys across 3–5 items" while the exact list sits on another tab.
*Sketch:* render the current plan lines inline under that step as sub-items.

### 2.7 Weekly review names no bottom performer — S · **2**
§5 says cut the worst item. The per-item table sorts by profit, but you still eyeball it.
*Sketch:* highlight the lowest gp/touch row and offer a "remove from watchlist" button.

### 2.8 No stale-offer tracking — M · **3**
"Never chase a fill" needs to know how long an offer has sat. Nothing records placement time.
*Sketch:* falls out of 2.1 for free — timestamp each open position, flag any older than 24h.

---

## 3. DATA I'M NOT USING

### 3.1 Buy/sell volume imbalance — already fetched, currently summed away — S · **4**
`/1h` returns `highPriceVolume` and `lowPriceVolume` separately and I collapse them. The ratio is the most
actionable free signal available: `low >> high` means sellers are dumping and your buy fills fast but your sell
may not; `high >> low` is the reverse. It predicts *fill risk*, which is your actual failure mode.
*Sketch:* `imbalance = lowVol / (lowVol + highVol)`; display as a bar, bench anything outside 0.35–0.65.

### 3.2 Time-of-day patterns — free in data already fetched for sparklines — M · **4**
`/timeseries?timestep=1h` returns 365 hourly points with volumes. Bucketing by hour-of-day tells you when *this
item* actually trades. Directly serves a two-touch schedule: it answers "is 7am a good touch time for manta ray, or
should I shift to 9pm?" — a question the guide raises and the tool currently can't answer.
*Sketch:* bucket `highPriceVolume+lowPriceVolume` by `new Date(ts*1000).getHours()`, render a 24-bar mini-histogram per watchlist item.

### 3.3 Sustained spread vs instantaneous spread — S · **4**
See 1.4. `/1h` already gives hourly average high and low — a spread that survives an hour of averaging is real;
one visible only in `/latest` often isn't.
*Sketch:* add a "1h margin" column; rank Today's Plan on the lower of the two.

### 3.4 The `/5m` endpoint — one cheap extra call — S · **3**
Same shape as `/1h`, twelve times fresher. Better for the volume gate at the moment you're about to commit.
*Sketch:* fetch alongside `/1h`, use for gating, keep `/1h` for display stability.

### 3.5 Volume *trend*, not just volume level — S · **3**
The timeseries carries volume per hour, so a dying item is visible before its price moves. Directly addresses the
guide's "dying item post-update" trap, which the current volume floor cannot catch.
*Sketch:* compare mean volume of the last 24h against the prior 6 days; bench on a >40% decline.

### 3.6 `highTime` / `lowTime` skew as a liquidity tell — S · **3**
Already in `/latest` and used only for the age filter. A large gap between the two timestamps means one side of the
book is dead — precisely the item where you buy fine and then can't sell.
*Sketch:* bench when `|highTime - lowTime| > 30 min`.

### 3.7 `mapping.value` / `highalch` as a downside floor — S · **2**
Unused. High-alch value is a soft price floor on consumables and bounds how far a bad entry can fall.
*Sketch:* show `buy price ÷ highalch` as a "downside" ratio in the scanner.

---

## 4. ROBUSTNESS

### 4.1 Your phone can't open this at all — M · **5**
The guide is explicitly built for a mobile-first schedule, and the deliverable is a `file://` page on a Windows
laptop. There is no path by which you open it on a phone during a morning touch. Everything else in this section is
smaller than this.
*Sketch:* it's a static file with no build — commit to a repo and enable GitHub Pages, or `npx serve` on the LAN. `localStorage` won't follow you, so JSON export/import becomes the sync mechanism.

### 4.2 No backoff when the API is down — S · **4**
`setInterval(refresh, 60e3)` runs forever regardless of failures. If the wiki is down or rate-limiting you, this
hammers it every 60s indefinitely — the opposite of the politeness the API asks for, and exactly when it's under load.
*Sketch:* exponential backoff to a 15 min ceiling on consecutive failures, reset on first success.

### 4.3 Import accepts anything shaped like JSON — S · **4**
`Object.assign(DB, d)` with no validation. A truncated or hand-edited file silently produces flips with missing
fields, `NaN` profits, and a corrupted running total that looks plausible.
*Sketch:* validate each flip has numeric `qty`/`buy`/`sell` and a known `itemId`; report a count of rejected rows instead of merging them.

### 4.4 `localStorage` will eventually fill — M · **4**
The mapping cache (~200 KB trimmed) plus an unbounded flip log share a ~5 MB budget. On overflow `save()` shows an
error once, then every subsequent write fails — and the mapping-cache write is in a bare `catch(e){}` that swallows
it entirely. You could log a week of flips into a void.
*Sketch:* on quota error, evict `gef.map` first, retry, and only then warn; add a persistent "unsaved changes" indicator.

### 4.5 The 150 ms save debounce can lose the last write — S · **3**
Log a flip and close the tab immediately and it's gone.
*Sketch:* flush on `visibilitychange` and `beforeunload`.

### 4.6 Fourteen columns on a phone screen — M · **3**
The watchlist scrolls horizontally on desktop already. On a phone it's unusable, and Today's Plan — the one section
you'd actually want on mobile — sits above it in the same tab.
*Sketch:* below 620 px, collapse the watchlist to name/margin/plan-qty and hide the rest behind a per-row expander.

### 4.7 Autocomplete's 120 ms blur timer is tuned for a mouse — S · **2**
Touch taps can register after the list has closed, so selection intermittently fails on a phone.
*Sketch:* use `pointerdown` instead of the blur race.

### 4.8 Nothing reminds you to export — S · **3**
The log is the only irreplaceable data and lives in the most volatile storage available.
*Sketch:* if flips have been added since the last export, show a quiet "N flips unexported" chip next to the export button.

### 4.9 The mapping cache has no schema version — S · **2**
If the trimmed field set ever changes, a stale 24h cache yields `undefined` limits and silently wrong sizing.
*Sketch:* store `{v:1, at, items}` and discard on mismatch.

### 4.10 Sparkline fetches are serial at 250 ms — S · **2**
A 20-item watchlist takes 5 s to populate, and `renderWatch` (now including a full plan rebuild) runs after each one.
*Sketch:* keep the pacing, but batch the re-render to once per 5 completions.

---

## 5. WON'T DO — considered and rejected

| Idea | Why not |
|---|---|
| **Auto-place or auto-cancel GE offers** | Requires client automation. Bannable, and it violates your own rule that the tool proposes and you decide. Not a close call. |
| **Price prediction / ML forecasting** | The guide's thesis is that you're paid for patience, not prediction. A model here would manufacture false confidence in exactly the situations (thin volume, manipulated items) where the data is worst. |
| **Auto-import from RuneLite** | A browser page can't read another process. Flipping Utilities already does this properly, and it can't see your mobile flips anyway — so it wouldn't remove the manual step it appears to remove. |
| **Server-side price history / account sync** | Violates "everything client-side". Also makes you dependent on a service that will outlive your interest in maintaining it. |
| **Polling faster than 60 s** | The API asks for politeness and `/latest` only updates on trades. Faster polling adds load and no information. |
| **A framework or build step** | Explicit constraint, and the page is 68 KB with no toolchain — that's the feature, not a limitation to fix. |
| **Wiki item icons in tables** | 50 extra image requests per scanner render on an old laptop, for decoration. |
| **Push notifications / price alerts** | A `file://` page can't reliably register a service worker, and a browser tab that must stay open to alert you defeats the two-touch premise. |
| **Multi-account or multi-portfolio support** | You have one stack and one goal. Generalizing this would double the state model to serve a user who doesn't exist. |
| **Replacing `localStorage` with IndexedDB** | Real capacity win, but §4.4's eviction fix costs a fraction as much and the flip log won't approach 5 MB for years. Revisit if it does. |

---

## 6. Noticed in the Aug 10 2026 friction session — queued, not built

### 6.1 vol5 die-off streaks are session state — S · **2**
`S.vol5Low` (the 2-consecutive-refreshes confirmation for the 5m volume gate) lives in memory, so a
browser reload resets a half-confirmed die-off and it must re-confirm from zero. Conservative direction
(a reload can only *delay* a bench, never cause one), but worth persisting if reloads are frequent.
*Sketch:* move the map into `DB` keyed by id with a staleness cutoff.

### 6.2 Scanner's ✗ gates badge can't see seasoning — S · **2**
The badge reports gate-chain failures only; an item mid-qualification shows no marker on the scan tab
even though the plan won't fund it yet. A "qualifying n/3" mini-badge on scan rows for watch items with
an active streak would make the two tabs tell one story.

### 6.3 Deployment funnel lumps held/inventory into one residual row — S · **1**
Items skipped from planning because a position or inventory buffer already commits their capital are
attributed to a single "live position / inventory" row computed as a residual, not counted directly.
Fine at current scale; count them explicitly if the row ever looks wrong.

### 6.4 Gate-health ledger stays first-fail only — M · **3**
The live snapshot now knows *all* gates each item fails (`fails[]`), but the 30-day ledger still records
only the headline reason — deliberate, to preserve the audit's bucket semantics. A parallel ledger of
full failure sets would let the marginal-gate attribution be computed over weeks instead of one refresh.
Revisit after the panel has earned trust on live data.

### 6.5 Thesis detail's first open can take ~8s on a cold cache — S · **1**
The market factor needs dailies for the whole watchlist at 250ms politeness spacing; the 20h cache makes
subsequent opens instant. Could prefetch after the weekly scan, which already pulls the same series.

### 6.6 Thin-book floor (10m gp/day) — revisit at the first monthly scorecard read — S · **3**
Ratified Aug 10 2026 as a **starting value** for the pump fingerprint's structural check
(promoted + daily gp flow below the floor = pump vehicle). The right floor is empirical:
at the first monthly read of the briefing scorecard, check it against the flagged items'
actual books and propose a correction. The setting lives in the intel panel (`pumpThin`).

### 6.7 Harden the stratum classifier with wiki categories — **CLOSED (mooted) 2026-08-14** · M · **3**

> **CLOSED 2026-08-14, mooted by the slice retirement (user ruling):** the discovery
> slice's sampling role retired to the dormancy lane — superseded by the universe
> scorer, which scores every mapped item each 5m bucket. This entry's own trigger
> ("the first time a per-stratum finding is cited in an actual ruling") can no longer
> arrive: the map is a frozen historical ledger and steers nothing. The reasoning below
> stays recorded as sound-but-moot (the row-6 pattern); if the slice's sampling role is
> ever un-retired by ruling, this entry revives with it.
Ratified Aug 11 2026, and deliberately **not built yet**. The pond-prospecting slice sorts the item
universe into 21 structural strata, but the prices API's mapping carries only name, members, buy
limit, value and high-alch — no categories. So 19 of the 21 strata are matched on item *names*
(`/\b(helm|helmet|coif|hood|mask)\b/i` and friends); only F2P (the mapping's own members flag) and
the two price-band strata are exact. That makes the per-stratum map **directional, not a census**:
a Dragon *pickaxe* lands in the weapon stratum, "Ring of recoil" and "Ring of shadows" both land in
the ring stratum whether or not they are equipment at all, and anything the patterns miss is
credited to no region.

The fix, when it is worth paying for: enrich each sampled item with its real wiki categories
through the **existing** MediaWiki path this file already uses for basket metadata — `wikiCatsFor()`
(`WIKI_API`, `action=query&prop=categories`, batched 50 titles per request, cached in
`localStorage` under `WCAT_KEY` on a 7-day TTL). Classification would then key off
`Category:Head slot items` and similar rather than a regex, and the caveat could come off.

**Why it is deferred:** the enrichment costs an API round trip per uncached item, and the slice
samples items nothing else has ever fetched — the cache would be cold constantly, which is exactly
the traffic pattern the politeness rules exist to prevent. The map is not load-bearing: today it
steers *sampling* and nothing else, and being wrong about which bucket an item belongs to is cheap.

**The trigger to build it:** the first time a per-stratum finding is cited in an actual ruling — a
scanner proposal, a scout priority change, a gate proposal. Until then the tripwire carries the
warning to the point of decision instead (every stratum verdict renders "Depends on approximate
stratum classification — verify before ruling"). When that warning starts appearing on things you
are about to *rule* on, the classifier has become load-bearing and this entry comes due.

---

## Suggested order

1. **1.1** (`gp()`) — misreporting your headline number today, ten-second fix.
2. **1.2** (double-count) — silently mis-sizing every position.
3. **4.1** (phone access) — the routine the whole tool serves happens on a phone.
4. **2.1 / 2.2** (open positions + margin test) — together these close the gap between the app and the guide.
5. **3.1 / 3.3** (imbalance + sustained spread) — best selection improvement per line of code.
