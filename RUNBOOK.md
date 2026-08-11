# RUNBOOK — the tool looks wrong after time away

Written for you, on the assumption you've been gone a while and something looks off.
Work it top to bottom; each step tells you what you'd see and what it means.

---

## 0. The one thing to know before you leave

**Accrual requires the tab to be open AND visible.** The poll skips entirely while the
tab is hidden — backgrounded behind another tab, or the window minimized. Nothing
collects in that state: no shadow fills, no stratum samples, no daily regime snapshots,
no gate-health rows. Nothing is *lost*; nothing is *gained* either.

If you want two weeks of data, the tab has to be the foreground tab in a window that
isn't minimized, on a machine that isn't asleep. A second browser window sitting on
another monitor is the reliable setup. A machine that sleeps overnight collects roughly
the hours it was awake, and that is fine — it just means the ledgers say fewer days than
the calendar does, which the freshness panel will tell you.

---

## 1. First stop, always: **Review → Check data freshness**

Every background stream reports when it last accrued. Read this *before* reading any
number anywhere else, because it tells you whether the numbers below it are real.

- **"✓ every scheduled stream is current"** — the data is trustworthy, go read it.
- **"⚠ N streams behind schedule"** — the listed streams stopped collecting. If the tab
  was closed or hidden, that is the expected and complete explanation, and they resume on
  their own within a cycle or two. If the tab was genuinely open and visible the whole
  time, something is throwing: open the browser console (F12) and look for red.
- **Streams marked event-driven** (markouts, die-off episodes, basis breaks, accumulation
  flags) are never "late". Silence there means nothing happened, which is a finding in
  itself, not a fault.

The panel also surfaces two specific conditions worth knowing on sight:

- **"Price-history fetching is paused"** — the timeseries circuit breaker tripped after 8
  consecutive failures and suspended those requests for 30 minutes rather than hammering
  a struggling API. Charts, trend gates and the hours ledger are running on cached data.
  Live prices are unaffected. It clears itself; if it keeps re-tripping, the wiki's
  timeseries endpoint is having a bad day.
- **"N trips resolved UNOBSERVED"** — shadow positions whose horizon expired while the tab
  was closed. They are held out of every aggregate rather than priced at today's stale
  price. Expect a batch of these after any absence; it is the honest outcome, not a bug.

---

## 2. The three most likely causes, in order

### Cause 1 — the tab wasn't collecting (most likely by far)

**Symptoms:** several scheduled streams stale by roughly the length of your absence;
charts flat; shadow trip counts barely moved; "book flat since <date>" on Home; a batch of
unobserved trips.

**Confirm:** freshness panel shows the stale ages clustering around when you left.

**Do:** nothing. Leave it open and visible for a few cycles and everything resumes. The
ledgers keep their history; they simply have fewer days in them than the calendar. Be
aware when reading the weekly review that windows described in *readings* are not the same
as windows in *days* — the regime evidence line says so explicitly when the two diverge.

### Cause 2 — the API is unreachable or throttling

**Symptoms:** a red banner under the header ("Price API unreachable…"), prices showing a
stale "prices Nh ago" in the status line, or the timeseries breaker banner.

**Confirm:** the header status line and the warning box at the top of the page. These are
global — they render on every tab.

**Do:** the poll backs itself off automatically (up to 15 minutes between attempts) and
recovers on its own. If it persists for hours, check whether the wiki's prices API is up
in a browser tab: `https://prices.runescape.wiki/api/v1/osrs/latest`. Nothing in the tool
needs fixing for this; it is designed to keep showing the last good data and say how old
it is.

### Cause 3 — storage filled up

**Symptoms:** a persistent banner saying storage is full and your last change could not be
saved.

**Confirm:** that banner is the only symptom that matters; it is deliberately impossible
to miss and does not clear on re-render.

**Do:** **export to JSON immediately, before closing the tab.** The tool first tries to
free space by evicting the cached item list (which re-fetches harmlessly); the banner only
appears if that wasn't enough. Measured headroom is comfortable — roughly 1.4 MB against a
5 MB budget with every auto-growing collection capped — so if this fires, something is
genuinely wrong and the export is your insurance.

---

## 3. Specific things that look broken but aren't

- **The watchlist shrank.** The scout evicts its own entries after 48h of failed gates. It
  will not evict on the first pass after a cold start any more (an unloaded chart is no
  longer treated as a failed screen), but genuine 48h failures are still pruned. Check
  **Trade → scout log** for the reason on each. Anything you added, margin-tested, hold, or
  hold a position in is never touched.
- **Seasoning counters didn't advance.** Deliberate: a gap is not a pass. Qualification
  counts *observed* full-gate passes, so an absence stalls the streak instead of handing
  items credit for time nobody was watching.
- **Die-off episodes show "not confirmed recovered".** That is not the gate being proven
  right — it includes windows nobody observed. The wording says exactly what was measured.
- **A row shows a dim `◌`.** Shadow accruing: fewer than 3 closed trips, so no verdict yet.
  It is telling you data exists, not that something failed.
- **Numbers look small.** Compare against the freshness panel's ages before concluding the
  market was quiet — a stalled stream and a quiet market look identical on a chart, which
  is the entire reason that panel exists.

---

## 4. If you need to prove the tool itself still works

```bash
bash tools/probe/run.sh     # exit 0 and "PROBE-PASS" means the parts are sound
```

The suite runs against the real app with synthetic market data, including a cold-start
case (one watched item, empty ledgers) that asserts nothing crashes or renders broken on
sparse data. If it passes and the app still looks wrong, the problem is data or
environment, not code — go back to section 1.

---

## 5. Getting back to normal

1. Leave the tab open and visible for a couple of cycles.
2. Read **Review → Check data freshness** and confirm the streams are green again.
3. Run the weekly review. Expect the first one back to be thin — its windows describe
   readings, and there are fewer readings than days.
4. Before ruling on anything the review proposes, check whether its evidence line mentions
   a window that spanned more days than readings. If it does, let it accrue another few
   days rather than ruling on a window that quietly widened while you were away.
