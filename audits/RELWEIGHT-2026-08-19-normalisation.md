# The reliability weight: proposal, and what I could and could not measure

**2026-08-19. Nothing built. This needs a ruling because it changes what gets funded first.**

## The problem, stated plainly

The plan ranks items by a score that multiplies four "history" terms onto a core figure. One of
them is **reliability** — how consistently your own logged trips on that item completed, were
profitable, and were quick. It needs **4 completed round trips in 30 days** to be computed at all.

**Below that bar it returns 1.0** — the exact number a perfectly average item returns. So an item you
have never traded and an item you have traded and found middling are the same number in the sort.

**Measured on your live watchlist today: 3 of 43 items clear the bar.** For the other 40, the plan is
ranking on a figure that means "no information" while treating it as if it meant "average".

You ratified the reason this is different from the hour and stability weights: a missing price series
is a **tool state** (a fetch failed, the archive is still filling), while a missing trade history is a
**fact about your book**. That distinction is right, and it is why the hold-out shipped for the
series-derived weights only. But it does not make 1.0 evidence. *"I have not traded this"* is still
not a claim that it fills averagely.

## The proposal

Instead of injecting a neutral for the missing term, **rank each item on the history terms it
actually has, scaled so items with different amounts of history are on the same footing.**

Concretely: of the three two-sided weights (hour, stability, reliability), take the ones that are
fed, multiply them, and raise the product to the power `3 / (number fed)`. An item with all three
keeps today's number exactly. An item with two fed gets those two extrapolated to stand in for the
third.

`wins` stays exactly as it is. Its absence gives its **floor**, not its middle — an untraded item
simply gets no bonus, which is the conservative reading rather than a fabricated average. That is the
same principle already applied to the pool group, which sorts on the core with no history terms at
all.

## What each option costs

**Ship the proposal.** An item whose measurable weights are above average gets its unmeasured one
assumed above average too, and vice versa. That is still an assumption — but it is an assumption
drawn from *that item's own data* rather than from nowhere. Cost: the assumption is unfalsifiable
per-item, and items with one fed weight get that weight cubed, which amplifies noise.

**Do nothing.** 40 of 43 items keep ranking on a fabricated average. Cost: the ranking is quietly
wrong in an unknown direction, and it is wrong for the *majority* of the list rather than the tail.

**A third option, cheaper and weaker:** rank on the core plus only `wins`, dropping all three
two-sided weights whenever any is unfed. That treats a partially-informed item like a pool item.
Cost: it throws away the hour and stability readings you *do* have for those 40 items, which are fed
43 of 43.

## What I could not measure, and why

**I could not produce the before/after ordering on today's book, and you should not rule without
it.** I built a harness to run the real app against real market data — your watchlist from the
collected backup, live prices and hourly series fetched fresh — so that production's own `buildPlan`
would produce both orderings and no arithmetic would be re-derived by me. It never reported.

The cause is now understood and is worth recording: **a syntax error in an injected script is
silent** in that harness unless it happens to reach the page's error trap, so several attempts failed
with no diagnostic at all. Separately, running an instrumented variant through the normal probe
runner **wrote real market data into the test browser's stored profile**, which then made two
unrelated assertions fail on the next run.

What would settle it, next session: fix the harness (the error trap works, so this is a short job),
or add a temporary export to the plan surface that dumps each candidate's core and four weights, run
it once on your machine, and compute the two orderings from that. The second is more work for you and
less for me; the first needs no involvement from you at all.

**What I do have, and it is solid:** the population figures above (3 of 43 fed, 43 of 43 for hour and
stability) come from your real watchlist run against live `/timeseries` data through the app's own
`byHour` construction. The proposal's mechanism is arithmetic and does not depend on the
measurement. Only the *size of the effect* is unknown, and that is exactly the thing you said you
wanted to see before ruling.

## Shipped alongside this, and not needing a ruling

**Reliability now says when it has nothing.** It already explained a *partial* history — *"thin
history (2/4 trips in 30d) — reliability weight off"* — and said nothing at all when there were zero
trips, which is the inverse of useful, and the silent case is 30 of your 43 items. It now names it.
The pool group's header already states this over its whole population, so a pool row does not repeat
it; a tenured row's absence is specific to that item and earns its line.
