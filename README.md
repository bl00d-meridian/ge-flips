# Two-Touch Flip Tracker

A single-file OSRS Grand Exchange flip tracker: one `index.html`, no build step, no framework,
everything client-side. Prices come live from the
[RuneLite / OSRS Wiki real-time prices API](https://prices.runescape.wiki/api/v1/osrs)
(polled no faster than 60s, with backoff).

**Your data never leaves your browser.** Flips, watchlist, bank value and settings live in
`localStorage` on each device. Use Export/Import JSON (Flip Log tab) to move data between devices
or back it up — the log is the only irreplaceable part.

## What's inside

- **Scanner** — post-tax margins over the whole market, gated on the thin side of the order book,
  with crowding ranks and a conversion-spreads panel (decanting, herb cleaning)
- **Watchlist** — auto-scouted on sustained ROI (with a journaled add/evict log and reasons),
  sparklines, hour-of-day volume profiles, margin-test capture (16h TTL), and hard sizing clamps
  (one-third rule, buy-limit windows, liquidity)
- **Today's Plan** — gated, ranked, capital-allocated buy list with NEXT UP substitutes,
  promote/demote, caution categories for pump-prone items, and per-item graduation from your log
- **Positions** — full lifecycle (buy pending → awaiting sell → sell pending → sold) with partial
  fills; leg timings feed gp-per-slot-hour analytics
- **Flip log** — realized post-tax profit, gp/touch, gp/slot-hour, weekly-review table, and an
  equity curve: cumulative profit over time with daily bank snapshots overlaid, a daily-return
  strip, an unannualized daily Sharpe (once 7 days exist), and gp-per-couch-minute as the
  headline metric. A separate game-gp ledger keeps non-flip bank changes (supplies bought,
  drops sold) out of the flipping stats while netting them from the snapshot dots
- **Routine** — morning / evening / weekly checklists with the live plan inlined
- **Shadow fund** — progress toward Tumeken's Shadow at its live price, secondary targets, and
  long-term holds tracked against a baseline with an exit thesis per item
- **Explainers everywhere** — a trading glossary, tap-to-explain tooltips on mobile, and per-item
  "what does this become in-game" notes that explain where the daily volume comes from

GE tax (2%, floored, 5M cap, 48 exempt items) verified against the
[OSRS Wiki](https://oldschool.runescape.wiki/w/Grand_Exchange#Convenience_fee_and_item_sink).

## Run it

Open `index.html`. That's all.
