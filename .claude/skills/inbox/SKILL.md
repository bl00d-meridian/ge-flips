---
name: inbox
description: Collect the tracker's exports from Downloads into inbox/ — analysis-paper, -prospecting, -gates, -calibration, -all, the ge-flips state backup, and flags-pending. Use when the user says they have just exported something, asks to collect or fetch an export, or when about to read an export and wanting the newest copy first. Also the manual trigger for the sweep that otherwise runs on session start and opportunistically.
---

# Collect the exports from Downloads

Run:

```bash
bash tools/inbox/sweep.sh
```

That is the whole action. It is idempotent and safe to run at any time.

## What it does

For each export class it takes the **newest by modified time**, moves it, and deletes that
class's older copies from Downloads — including the browser's ` (1)` / ` (2)` duplicates.

| Class | Lands in |
|---|---|
| `analysis-paper-*` · `analysis-prospecting-*` · `analysis-gates-*` · `analysis-calibration-*` · `analysis-all-*` | `inbox/` |
| `ge-flips-*` (state backup) | `inbox/` |
| `flags-pending*` | `briefings/` — the briefing procedure reads it there by name |

## Reporting the result

**Relay the table, including the `none found` lines.** Absence of a file and absence of a
report are different things and the user must not have to tell them apart.

**Age comes from each file's own `generatedAt`, never its mtime** — an export that sat in
Downloads for a day is a day old regardless of when it was collected. The script marks
anything over **6h** as `STALE`, and a file with no `generatedAt` as *age unknown*.

**A STALE file is not current state.** If the user asks something the file predates, say
so and offer a re-export rather than answering from it.

## When to run it without being asked

Exports happen mid-session by nature, so the session-start run is never sufficient:

- The user says they exported, downloaded, or dropped a file.
- Before reading any export — the copy in `inbox/` may be older than what is in Downloads.
- Before a briefing (BRIEFING.md step 0 runs it as part of the procedure).

A `--quiet` run prints nothing unless something moved, which is how the opportunistic
`UserPromptSubmit` hook stays silent; run it verbose here, because someone who asked is
owed the per-class result.

Everything collected is gitignored — the repo carries the tool, never the data it produced.
