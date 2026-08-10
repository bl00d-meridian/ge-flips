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
or script error (read the report), `3` = no report within 90s (see "If the suite hangs").

Prerequisites: Windows with Microsoft Edge installed (the script tries both standard
install paths; edit `EDGE=` in `run.sh` if yours differs), Windows PowerShell 5.1
(always present), Git Bash. No network needed — the suite deliberately runs with DNS dead.

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

- `PASS <name>` — assertion held.
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

## Kit inventory

```
tools/probe/
  run.sh              one-command runner (assemble → listen → launch → report)
  listen.ps1          beacon listener (TcpListener, port 8347)
  early-stub.html     prompt/confirm stubs + error→beacon trap (injected BEFORE the app)
  probe-snippet.html  the test suite (injected AFTER the app, before </body>)
  out/                disposable run artifacts (gitignored): probe.html, edge-profile/,
                      probe-report.txt
```
