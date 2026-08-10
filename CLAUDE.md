# CLAUDE.md

Single-file OSRS Grand Exchange flip tracker: `index.html` — no build step, no
dependencies, all client-side, localStorage persistence. Opening the file in a browser
*is* the app. Data comes from the RuneLite / OSRS Wiki real-time prices API, polled no
faster than 60s.

## Product constitution (binding — do not soften these in code or copy)

- **The tool proposes and prefills; it never acts.** No flip is logged, no offer placed,
  no watchlist commitment made without an explicit user button press.
- **House convention (strategy layer):** strategy parameters — ceilings, floors, budgets,
  gates, tier bands, cluster caps — may be *proposed* in review copy but change only on
  the user's explicit instruction. Never self-apply.
- **Advisory layers stay advisory.** Scout, cluster discovery, audits, and verdicts queue
  candidates and recommendations; nothing caps or spends capital until the user ratifies.
- **The blacklist is the user's alone.** No automated path may admit, fund, quote, or
  clear an entry — not even a margin test.
- **Automated decisions show their work.** Every bench, clamp, and cap states its reason
  inline where the user reads it.
- Known repeated bug class: gates that re-punish what sizing already priced in
  (double-counting). Bench only on information the sizing/margin logic doesn't use.
- **Restraint may auto-arm; deployment never** (user ruling, Aug 10 2026). Defensive
  intel may act pre-ratification precisely because its only power is restraint — a false
  caution costs nothing (absence, lifted by one dismissal), a late defense costs whatever
  the pump extracts before the next walk-up. Anything that could DEPLOY capital stays
  ratification-gated. New features inherit this distinction.
- **A manipulation defense never relaxes on the manipulator's chosen evidence** (user
  ruling, Aug 10 2026). Recent wins during a pump are the bait, so wins never graduate a
  flagged pump caution; the only lift path is the user dismissing the warning record —
  nothing else.
- **Disclosure-in-summary is not ratification** (user ruling, Aug 10 2026). Judgment
  thresholds and verdict boundaries discovered mid-build are strategy parameters: propose
  them and leave them unapplied until the user rules. Applying one and mentioning it in
  the summary is a near miss, not compliance (the incident: entry-watch DISCOUNTED set to
  ≤ −2% in-flight; ratified after the fact).
- **Concur-recommended proposals skip the ruling ceremony** (user ruling, Aug 10 2026).
  A proposal that argues FOR keeping an existing rule against softer data is the correct
  default posture, not a decision point: flag it "concur-recommended", batch such entries
  under their own header in review copy, and keep them out of the rulings-pending count.
  The full ruling flow is reserved for proposals that want to change something.

## Definitions protocol (metric honesty — user ruling, Aug 10 2026)

When the user asks what a metric measures, the standing rule is **answer first, build
later**: state exactly what the current code computes (not what it was meant to compute),
show one concrete data row as proof, flag known biases unprompted, and propose
corrections without applying anything until the user rules. The house standard for every
metric: **realized quantities only** — actual logged round trips, tax netted; no
counterfactual fills, no price drift counted as missed profit — and where a signal could
flatter the machine's own case (e.g. a "gate too tight" verdict), the copy must claim
exactly what is measured and no more. Gate health is the reference implementation:
"traded while still benched" (the user overrode the gate — clean evidence for or against
it) is never conflated with "traded after unbenching" (re-admission latency only — the
gate eventually agreeing with itself is not the user being right against it).

## Verification

No Node on the dev machines. All verification runs as headless-Edge probes against the
real app with synthetic market data, reporting over a loopback beacon.
**The complete workflow, prerequisites, and troubleshooting live in [PROBE.md](PROBE.md).**

```bash
bash tools/probe/run.sh   # exit 0 = PROBE-PASS
```

Run the suite after any nontrivial change to `index.html`, and extend
`tools/probe/probe-snippet.html` alongside new features. Ruled requirements live in
[REQUIREMENTS.md](REQUIREMENTS.md) with stable IDs; probe assertions carry `[R#]` tags
and the report's `===REQS===` section cross-references them — when adding a gated
feature, add its requirement row and a tagged assertion together, never one without
the other.

## Repo hygiene

- Commit only under the repo-configured anonymized identity (`git config user.name` /
  `user.email` in this clone) — never a personal name or email.
- `ge-flipping-guide.md` and `cleanup.html` are gitignored on purpose (personal); don't
  force-add them.
- The site deploys via GitHub Pages from `main` — pushing `main` is publishing.
- The flip log lives only in the user's browser localStorage; nothing in this repo ever
  contains user trading data.
