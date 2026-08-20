#!/usr/bin/env bash
# DEPLOYMENT CHECK — one real boot, real network, phone viewport.
#
# WHY THIS EXISTS (M154): seeded tests prove the code; ONE REAL BOOT proves the
# schedule reaches it. A stubbed fetch resolves instantly and in order, which
# collapses exactly the concurrency a boot race lives in — so a green suite
# over a scheduled pipeline proves the functions and not the schedule. This is
# the separate detector.
#
# WHY IT IS A SCRIPT AND NOT AN INLINE COMMAND: backgrounding the listener from
# an ad-hoc shell invocation did not start it (empty log, no bind message, no
# beacon) while the identical lines inside run.sh work every time. Whatever the
# cause — job control, process reaping between calls — the working pattern is
# "one script, children live for its duration", so this mirrors run.sh exactly
# rather than trying to be clever.
#
# ═══ STATUS: DOES NOT WORK IN THIS ENVIRONMENT (Aug 19 2026) ═══════════════
# Kept, with its diagnosis, so the next session does not re-derive it. The
# beacon DESIGN is sound and the harness is 80% right; the environment is what
# fails. What was tried, and what each proved:
#
#  1. `--screenshot` + `--virtual-time-budget` — never terminates. The app
#     polls forever, so virtual time never goes idle and the budget never
#     elapses. Not fixable by tuning the budget.
#  2. Beacon on `S.scoredBucket` with a 90s window — silence. Silence carried
#     no information, which is why the beacon was rewritten to fire on a
#     DETERMINISTIC EVENT (first scored bucket) OR a 75s deadline that reports
#     how far the boot got.
#  3. A stale `listen.ps1` process was found holding 8347 and was killed; the
#     cleanup is now step 2 above. It was not the cause.
#  4. ISOLATION TEST — a minimal page whose only content is the POST. It also
#     produced no beacon under this invocation, while `run.sh` beacons on every
#     run. So the failure is in the INVOCATION, not in the app and not in the
#     beacon.
#  5. Rewritten as this script to mirror run.sh exactly (one script, children
#     live for its duration). Still silent, with and without the
#     `--host-resolver-rules` flag — so the network policy is not the cause
#     either.
#  6. `--dump-dom` on the assembled page returns nothing matching even STATIC
#     markup from index.html, which says the page is not executing under any
#     invocation that permits real network.
#
# CONCLUSION: headless Edge in this environment executes reliably only under
# run.sh's exact flag set, which blocks the network on purpose. A real-network
# boot either never terminates or never reports. The substitute is the
# operator checklist in PROBE.md ("Deployment check — operator-verified"),
# which carries the same evidentiary weight because it observes the same three
# things on the real device.
#
# Exit codes: 0 = beacon received, 3 = no beacon (report says how far it got).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
OUT="$HERE/out"
mkdir -p "$OUT/deploy-profile"
rm -f "$OUT/deploy-report.txt" "$OUT/probe-report.txt"

# 1. Assemble: the REAL index.html plus the early stub (prompt/confirm guards
#    and the error trap) plus a beacon that fires on a DETERMINISTIC EVENT.
LN=$(grep -n '^<script>$' "$ROOT/index.html" | head -1 | cut -d: -f1)
[ -n "$LN" ] || { echo "FATAL: no '^<script>\$' line in index.html"; exit 1; }
head -n $((LN-1)) "$ROOT/index.html" > "$OUT/deploy.html"
cat "$HERE/early-stub.html" >> "$OUT/deploy.html"
tail -n +$LN "$ROOT/index.html" | head -n -2 >> "$OUT/deploy.html"
cat "$HERE/deploy-beacon.html" >> "$OUT/deploy.html"
printf '</body>\n</html>\n' >> "$OUT/deploy.html"

# 2. Kill any stale listener first — a previous run's process can hold 8347 and
#    swallow the beacon into a directory nobody is reading.
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { \$_.CommandLine -match 'listen.ps1' } | ForEach-Object { Stop-Process -Id \$_.ProcessId -Force -ErrorAction SilentlyContinue }" >/dev/null 2>&1

# 3. Listener, then the browser — same shape as run.sh.
powershell -NoProfile -ExecutionPolicy Bypass -File "$HERE/listen.ps1" -OutDir "$(cygpath -w "$OUT" 2>/dev/null || echo "$OUT")" &
LISTENPID=$!
sleep 2

EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
[ -f "$EDGE" ] || EDGE="/c/Program Files/Microsoft/Edge/Application/msedge.exe"
[ -f "$EDGE" ] || { echo "FATAL: msedge.exe not found"; kill $LISTENPID 2>/dev/null; exit 1; }
OUTW="$(cygpath -m "$OUT" 2>/dev/null || echo "$OUT")"

# NOTE: no --host-resolver-rules here. run.sh blocks the network on purpose so
# fixtures are not poisoned by live data; this check needs the opposite.
"$EDGE" --headless=new --disable-gpu --no-first-run --no-default-browser-check --disable-extensions \
  --window-size="${DEPLOY_WINDOW:-390,844}" \
  --disable-sync --disable-component-update \
  --disable-features=BlockInsecurePrivateNetworkRequests,PrivateNetworkAccessSendPreflights,PrivateNetworkAccessChecks \
  --user-data-dir="$OUTW/deploy-profile" "file:///$OUTW/deploy.html" &
EDGEPID=$!

for i in $(seq 1 60); do [ -s "$OUT/probe-report.txt" ] && break; sleep 2; done

kill $EDGEPID 2>/dev/null
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"Name='msedge.exe'\" | Where-Object { \$_.CommandLine -match 'deploy-profile' } | ForEach-Object { Stop-Process -Id \$_.ProcessId -Force -ErrorAction SilentlyContinue }" >/dev/null 2>&1
kill $LISTENPID 2>/dev/null

if [ -s "$OUT/probe-report.txt" ]; then
  mv "$OUT/probe-report.txt" "$OUT/deploy-report.txt"
  cat "$OUT/deploy-report.txt"
  exit 0
else
  echo "NO BEACON — the boot produced nothing in 120s. That is itself the finding:"
  echo "the beacon fires on the first scored bucket OR a 75s deadline, so silence"
  echo "means the page did not execute at all rather than that the app was slow."
  exit 3
fi
