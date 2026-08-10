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

## Verification

No Node on the dev machines. All verification runs as headless-Edge probes against the
real app with synthetic market data, reporting over a loopback beacon.
**The complete workflow, prerequisites, and troubleshooting live in [PROBE.md](PROBE.md).**

```bash
bash tools/probe/run.sh   # exit 0 = PROBE-PASS
```

Run the suite after any nontrivial change to `index.html`, and extend
`tools/probe/probe-snippet.html` alongside new features.

## Repo hygiene

- Commit only under the repo-configured anonymized identity (`git config user.name` /
  `user.email` in this clone) — never a personal name or email.
- `ge-flipping-guide.md` and `cleanup.html` are gitignored on purpose (personal); don't
  force-add them.
- The site deploys via GitHub Pages from `main` — pushing `main` is publishing.
- The flip log lives only in the user's browser localStorage; nothing in this repo ever
  contains user trading data.
