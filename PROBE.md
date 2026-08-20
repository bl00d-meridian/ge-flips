# PROBE.md — headless-Edge verification suite

This repo has no build step and the dev machines have no Node. All syntax and behavior
verification runs the real app (`index.html`) in headless Microsoft Edge with a test
script injected, and the results come back over a loopback HTTP beacon. This file is the
complete, self-contained workflow: a fresh session on a new machine should be able to run
the suite from this document alone.

## TL;DR — run the suite

```bash
bash tools/probe/run.sh
```

Run from any directory, in Git Bash (the shell that ships with Git for Windows).
Exit codes: `0` = PROBE-PASS, `1` = setup failure (message says what), `2` = PROBE-FAIL
(in-page assertions, or the requirements pairing check — see below)
or script error (read the report), `3` = no report within 90s (see "If the suite hangs").

Prerequisites: Windows with Microsoft Edge installed (the script tries both standard
install paths; edit `EDGE=` in `run.sh` if yours differs), Windows PowerShell 5.1
(always present), Git Bash. No network needed — the suite deliberately runs with DNS dead.

## The suite runs COLD (user ruling, Aug 19 2026)

**`run.sh` deletes the browser profile before every run. There is nothing extra to remember.**

The profile carries localStorage and IndexedDB between runs, so a reused one means the suite starts
warm and an assertion needing accumulated state can pass on state an earlier run left behind — a
green that does not mean what it says. `[R82.4]` did exactly that: it read reconciliation rows out
of IndexedDB that no fixture ever seeded, so a fresh profile went red on a correct tree and every
run after it passed (MISTAKES **M166**).

```bash
PROBE_WARM=1 bash tools/probe/run.sh   # keep the profile — only to compare
```

**The only reason to run warm is to compare against a cold run, and if the two ever differ, THAT
DIFFERENCE IS A FINDING** — some assertion is reading state nothing wrote. Not a flake to re-run
past: a defect to trace, because the warm green is the one that was lying.

**And never point an instrumented variant at this profile.** Running a modified page through
`run.sh` writes whatever that page loads into the same store — once, real market data leaked in
this way and two unrelated assertions failed on the next run. Assemble experiments into their own
output directory with their own profile.

## The requirements pairing check (`tools/probe/reqpair.sh`)

Runs after the browser exits, appends a `===PAIRING===` section to the report, and
**rewrites the report's first line** if it finds anything — so `head -1` never says
PROBE-PASS while a pairing failure stands. It fails the suite on either direction:

```
PAIRING FAIL R61.1 — assertion reports this id and REQUIREMENTS.md has no row for it …
PAIRING FAIL R31.2 — REQUIREMENTS.md cites this assertion and no assertion reported it …
```

**Fixing the first:** add the requirement row, or retag the assertion to the row it
actually verifies. A tag with no row reports PASS against nothing.
**Fixing the second:** write the assertion, correct the citation to the tag that really
covers the row, or state the row's real verification method — rows verified by
inspection, UI or documentation cite no probe tag and are exempt automatically.

It lives outside the page because it reads `REQUIREMENTS.md`, which the in-page suite
cannot. Run it alone against an existing report with
`bash tools/probe/reqpair.sh . tools/probe/out/probe-report.txt`.

## Running the suite against a STAGED copy (user ruling, Aug 19 2026)

A repair pass writes to `staging/` and never to the tree, so that the **next** session can review
the diff cold — shown what changed and not the finding that provoked it. That only works if the
staged copy can be fully verified before it lands, seeds included, which is what three environment
overrides are for:

```bash
bash tools/stage/new.sh          # copy the tree into staging/, record the tree's hashes
# ...edit staging/index.html and staging/probe-snippet.html...
bash tools/stage/run.sh          # the FULL suite against the staged copy
PROBE_WINDOW=390,844 bash tools/stage/run.sh    # and the phone viewport
bash tools/stage/check.sh        # freeze proof + the diff, written to staging/DIFF.patch
bash tools/stage/land.sh --yes   # guarded landing, once the cold review has passed
```

`tools/stage/run.sh` is a wrapper, and it exists because the failure it prevents is the obvious
one: setting the three variables by hand, forgetting one, and reading a **tree** run as proof that
the staged repairs verify. Under the hood it is just:

```bash
PROBE_SRC=staging/index.html \
PROBE_SNIPPET=staging/probe-snippet.html \
PROBE_REQ=staging/REQUIREMENTS.md \
bash tools/probe/run.sh
```

**`PROBE_REQ` is in that list because the pairing check is part of the suite.** A staged repair that
adds an assertion needs its requirement row staged too, or the run fails on a pairing orphan that is
an artefact of staging rather than a defect.

**A staged run is stamped in the report header**, the same way a pairing failure rewrites it:

```
PROBE-PASS [STAGED: staging/index.html]
===SOURCE=== STAGED RUN - this report does NOT describe the working tree
SOURCE src=staging/index.html
SOURCE snippet=staging/probe-snippet.html
SOURCE requirements=staging/REQUIREMENTS.md
```

The header is the line that gets quoted into HANDOFF.md as the tree's status, so **the caveat
travels with the claim**. Exit codes are unchanged: a staged pass *is* a pass of what it read.

**`land.sh` refuses to land** unless the freeze is intact, a green staged report carrying the
`[STAGED:]` stamp exists for **both** viewports, every repair in `staging/PASS.md` carries
`Verdict: PASS`, and every repair carries the cold reviewer's own answer to *"name the property this
repair is about"*. That last one is the point of the whole mechanism, so it is a hard gate rather
than a note. `staging/` is gitignored; the durable record is `audits/REPAIR-LEDGER.md`.

**The overrides were proven the way any new detector is proven**, by seeding a defect and watching
the right thing go red:

| seed | result |
|---|---|
| flip the sign of `pearson`'s return in `staging/index.html` only | `PROBE-FAIL 8 [STAGED: …]`, `pearson +1` and `pearson -1` red plus six cluster-detector consumers; `index.html` hashed unchanged |
| add an always-false `ok()` to `staging/probe-snippet.html` only | `PROBE-FAIL 1 [STAGED: …]`, that assertion alone |

The first proves `PROBE_SRC` is the file that ran — had the runner read the tree, the suite would
have been green. The second proves `PROBE_SNIPPET` is too. Both were run one at a time with the
staged copy restored between.

## Why a beacon instead of --dump-dom

The obvious approach — `msedge --headless=new --dump-dom page.html` — **hangs forever on
current Edge builds** (observed Aug 2026): Edge's sync/identity background services keep
the browser process alive, and adding `--virtual-time-budget` deadlocks against pending
network requests. Killing the process loses the output, because dump-dom prints only at
exit.

So instead the probe page **pushes** its results out: when the test script finishes, it
POSTs a plain-text report to `http://127.0.0.1:8347/report`, where a tiny listener writes
it to `tools/probe/out/probe-report.txt`. The browser is then killed without ceremony —
its exit was never load-bearing.

Three Edge behaviors will silently break the beacon if you don't handle them (run.sh
already does — this is why those flags exist):

1. **Private Network Access** blocks `file://` pages from fetching loopback addresses.
   Flag: `--disable-features=BlockInsecurePrivateNetworkRequests,PrivateNetworkAccessSendPreflights,PrivateNetworkAccessChecks`.
2. **A boot-time `prompt()` stalls headless parsing forever** (the app has one-time
   migration prompts). The stub in `tools/probe/early-stub.html` must be injected
   *before* the app's `<script>` so `window.prompt/confirm/alert` are already stubbed
   when boot runs. The stub also installs a `window.onerror` → beacon trap, so a parse
   error in the app or the probe reports itself as `PROBE SCRIPT-ERROR` with file:line
   instead of hanging silently.
3. **The app's real network calls poison fixtures.** The live `/mapping` fetch resolves
   mid-run and `applyMapping` rebuilds `S.byId`, wiping synthetic test items — a
   timing-dependent heisenbug. Kill all DNS except the beacon:
   `--host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"`.

One more Git-Bash trap: POSIX paths (`/c/dev/...`) inside `file:///` URLs or `--flag=value`
arguments break Edge silently (the page never loads, so no beacon, no error). Always pass
mixed-style paths (`C:/dev/...`) via `cygpath -m` — run.sh does.

## The listener

`tools/probe/listen.ps1` — a raw `TcpListener` on `127.0.0.1:8347` (deliberately not
`HttpListener`, which needs URL ACLs for non-admin users). It accepts one HTTP POST whose
body contains `PROBE`, writes the body to `<OutDir>\probe-report.txt`, replies `204`, and
exits. It self-terminates after 150s if nothing arrives. run.sh starts and stops it for
you; to run it by hand:

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File tools/probe/listen.ps1 -OutDir "C:\path\to\out" &
# self-test — expect 204 and the file to appear:
curl -s -X POST -H "Content-Type: text/plain" --data "PROBE selftest" \
  http://127.0.0.1:8347/report -o /dev/null -w "%{http_code}\n"
```

Note: launching the listener via `Start-Process -WindowStyle Hidden` **fails silently**
in some session contexts — start it as a plain background child (`... &` from bash, or a
backgrounded command in your harness) as above.

## Anatomy of a run (what run.sh does)

1. **Assemble** `tools/probe/out/probe.html`:
   `index.html` up to (not including) its first bare `<script>` line, then
   `early-stub.html`, then the rest of `index.html` minus its closing
   `</body></html>`, then `probe-snippet.html` (the test suite), then closing tags.
   Order matters: stub before app, suite after app.
2. **Start** the listener.
3. **Launch** headless Edge on the assembled page with the flags above and
   `--user-data-dir=tools/probe/out/edge-profile`.
   **NEVER point --user-data-dir at a real browser profile** — a probe once wrote a
   test flip into real localStorage. The scratch profile under `out/` is disposable.
4. **Poll** for `out/probe-report.txt` (up to 90s; a full run takes ~15–30s, mostly the
   detector's polite 300ms-per-item fixture delays).
5. **Kill** the Edge launcher and any `msedge.exe` whose command line contains
   `edge-profile`, stop the listener, print the report.

## Reading the report

First line is the verdict: `PROBE-PASS`, `PROBE-FAIL <n>`, or `PROBE SCRIPT-ERROR`.
Then one line per assertion between `===PROBE===` and `===END===`:

```
PASS funded member cluster-clamped with note
FAIL detector flags the co-moving trio :: ["9001,9002,9003:dormant", ...]
```

- `PASS <name>` — assertion held. Names may carry `[R#]` tags cross-referencing
  REQUIREMENTS.md; the report ends with a `===REQS===` section (lines prefixed `REQ`)
  giving per-requirement PASS/FAIL derived from those tags.
- `FAIL <name> :: <extra>` — the extra is JSON evidence captured at the assertion site
  (the actual plan picks, bench reasons, candidate list, etc.) — usually enough to
  diagnose without rerunning.
- `FAIL exception :: <stack>` — the suite itself threw; the stack names the line.
- `PROBE SCRIPT-ERROR` + lines — a script failed to *parse or boot* (from the error
  trap); fix the syntax error at the reported file:line before anything else.

The suite runs against **synthetic market data only** — never judge it by whether live
items pass gates (with DNS dead, zero live items can pass; that's by design).

## If the suite hangs (exit 3, "NO REPORT")

Work this list in order — each item has actually caused this failure:

1. **Did the page even load?** Check the assembled `out/probe.html` exists and contains
   `__probeErrs` (the stub) — `grep -c __probeErrs tools/probe/out/probe.html` should
   print ≥ 2. If 0, the assembly's `<script>`-line detection failed (did the main
   `<script>` tag in index.html change form?).
2. **Is the listener alive and reachable?** Run the curl self-test above while the run
   is stuck. `000` → listener not running (port taken by a stale listener from a
   previous run? another process on 8347?) or it was started via the silent-failure
   `Start-Process` path.
3. **PNA flags present?** Without the `--disable-features=...PrivateNetworkAccess...`
   flag the fetch is blocked with no visible error. Diff your Edge invocation against
   run.sh.
4. **Path style.** If you modified run.sh or run by hand: `file:////c/...` (POSIX path
   leaked in) loads nothing and reports nothing. Use `cygpath -m`.
5. **Stale Edge holding the profile.** Kill leftovers:
   `powershell -Command "Get-CimInstance Win32_Process -Filter \"Name='msedge.exe'\" | ? { $_.CommandLine -match 'edge-profile' } | % { Stop-Process -Id $_.ProcessId -Force }"`
   then rerun (optionally `rm -rf tools/probe/out/edge-profile` for a clean profile).
6. **Edge path.** If neither standard install path exists, run.sh exits 1 telling you —
   but if you bypassed it, check `msedge.exe` actually launched.
7. Still stuck: run Edge *without* `--headless=new` (headed) on the assembled
   `out/probe.html` and look at the DevTools console.

## Writing new probes

Add assertions to `tools/probe/probe-snippet.html` (it is the suite — plain JS using the
app's globals: `DB`, `S`, `buildPlan`, `calc`, ...). Conventions:

- `ok(name, condition, extraOnFail)` — keep `extra` a JSON.stringify of the actual
  objects; it's your only debugging view on a failure.
- Reset the parts of `DB` your block touches; don't rely on earlier blocks' state.
- **Synthetic items must clear every plan gate**, or your allocator test silently tests
  the wrong bench reason. The `mkItem` fixture in the suite is the known-good shape:
  buy 4000 / sell 4400 (margin 312 beats 3× tax and the tick floor), balanced 50k/h
  volumes on both sides, fresh trade timestamps, a flat 168-point sparkline, buy limit
  25000, plus a fresh walk-up stamp in `DB.touchLog` (else the drift bench can fire).
  Floors and ramps interact — pin `DB.minExpectGp`, budgets, and `DB.slots` like the
  suite does or synthetic volumes starve every line.
- Async app APIs (the cluster scan) are awaitable from the suite; pre-fill their caches
  (`dailyCache`, the `gef.wikicats.v1` localStorage cache) so nothing needs network.
- The report beacon fires once at the end — long-running additions are fine, the
  listener waits 150s and run.sh polls 90s (raise both if you add something slower).

## Manual checklist (not probe-coverable)

Things the headless suite can't see — walk these by hand when they change:

- **Verify `/briefing` resolves in a fresh session.** Mechanism (Claude Code ≥ 2.1.x):
  skills at `.claude/skills/<name>/SKILL.md` auto-register as `/<name>` slash commands
  (the old `.claude/commands/` form is legacy — same effect, don't add a duplicate
  wrapper). Registration is scanned **at session startup**, so a session started before
  the skill directory existed says "no commands match" until you restart Claude Code —
  that is staleness, not a broken skill. Non-interactive check from Git Bash:
  `claude -p "/briefing" --max-turns 1 --output-format stream-json --verbose | head -c 2000`
  — the first (`init`) event's `slash_commands` array must contain `"briefing"`
  (`--max-turns 1` stops it before the actual web sweep runs). Fallback if the command
  ever won't resolve: the skill is a thin pointer — telling Claude to "run the
  BRIEFING.md procedure" produces the same output (BRIEFING.md is the binding contract).
- **After any edit to BRIEFING.md or `.claude/skills/briefing/SKILL.md`, re-verify the
  equivalence invariant.** The two paths are stated-equivalent: the skill is a thin
  pointer, BRIEFING.md the binding source. Diff the skill's step summary and standing
  rules against BRIEFING.md's run procedure and confirm neither path carries a rule the
  other lacks — a guard living in only one path (the caught drift: the do-not-commit
  guard existed only in the skill) is the failure mode.
- **flags-pending.json download flow.** The probe asserts the export's content
  (`analystFlagsPending()`) and that the tape-question reminder line carries the
  export button, but not the actual browser download. When touched: press
  **⭳ flags for analyst** on a live tape-question reminder, confirm the file downloads
  as `flags-pending.json`, and that saving it into `briefings/` gets it read (by name)
  on the next `/briefing` run.

## Kit inventory

```
tools/probe/
  run.sh              one-command runner (assemble → listen → launch → report)
  listen.ps1          beacon listener (TcpListener, port 8347)
  early-stub.html     prompt/confirm stubs + error→beacon trap (injected BEFORE the app)
  probe-snippet.html  the test suite (injected AFTER the app, before </body>)
  out/                disposable run artifacts (gitignored): probe.html, edge-profile/,
                      probe-report.txt
  reqpair.sh          the REQUIREMENTS.md cross-reference, both directions
tools/stage/
  new.sh              open a staged repair pass (copy the tree, record its hashes)
  run.sh              the full suite against staging/, with the three PROBE_* overrides set
  check.sh            the freeze proof and the diff (staging/DIFF.patch)
  land.sh             the guarded landing — refuses without a recorded cold-review verdict
staging/              a repair pass in flight (gitignored); the durable record is
                      audits/REPAIR-LEDGER.md
```

## Deployment check — OPERATOR-VERIFIED (tooling limitation, ruled Aug 19 2026)

**M154's lesson stands: seeded tests prove the code, one real boot proves the schedule
reaches it.** That detector cannot be automated in this environment, and the substitute is
the operator running it on the real device. Diagnosis and the six things tried are in the
header of `tools/probe/deploy.sh`, which is kept for exactly that reason; the short version
is that headless Edge here executes reliably only under `run.sh`'s flag set, which blocks the
network on purpose, and every real-network invocation either never terminates or never
reports — including a minimal page whose only content is the beacon POST.

**A requirement row that would have cited a deployment artifact reads `operator-verified`
against this checklist, not `owed`.** The gap closes honestly rather than standing open
across sessions.

### The two-minute check, on the phone, at cutover

Open the app cold (fully close it first — the point is the boot, not a resumed tab).

1. **Does it boot and show live prices?** The plan sub-line should read
   *"N pass the gates, of M scored (watchlist)"* with a prices age of seconds, not
   "not yet". If M is 0 or the age says "not yet", the boot did not complete — stop and say so.
2. **Did the instrument's clocks advance within one poll?** Trade → Scorer, top of the
   screen: **market archive**, **universe scorer**, **reconciliation diff** and **fill sim**
   should each show a bucket age in seconds or minutes — not *"not yet this session"*. Any
   one still saying "not yet" a minute after boot is the finding, and it names which layer.
3. **Does anything render broken?** Scan the plan and the Scorer for `NaN`, `undefined`,
   `[object Object]` or an empty panel where a number belongs. The cold-start suite checks
   this synthetically; you are checking it against real data.

**Why these three and not more:** they are exactly what the automated artifact was for —
(1) the boot completes, (2) the scheduled accrual actually fires under real timing rather
than under a stub that resolves instantly and in order, and (3) real data does not produce
copy the fixtures never generated. Nothing else in the app needs a real boot to be trusted.

**Report format that closes the gap:** "booted, N of M, four clocks live, nothing broken" —
or which of the three failed. That sentence is the artifact.
