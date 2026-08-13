#!/usr/bin/env bash
# Headless-Edge probe runner — full workflow and troubleshooting in PROBE.md.
# Run from anywhere:  bash tools/probe/run.sh
# Exit codes: 0 = PROBE-PASS, 1 = setup failure, 2 = PROBE-FAIL, 3 = no report (hang).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
OUT="$HERE/out"
mkdir -p "$OUT/edge-profile"
rm -f "$OUT/probe-report.txt"

# 1. Assemble probe.html:
#    [index.html up to the main <script>] + early-stub + [rest of index.html
#    minus its closing </body></html>] + probe-snippet + closing tags.
#    The early stub MUST come before the app's script: it pre-stubs
#    prompt/confirm (a boot-time prompt stalls headless parsing forever) and
#    installs the error->beacon trap that reports parse errors.
LN=$(grep -n '^<script>$' "$ROOT/index.html" | head -1 | cut -d: -f1)
if [ -z "$LN" ]; then echo "FATAL: no '^<script>\$' line found in index.html"; exit 1; fi
head -n $((LN-1)) "$ROOT/index.html" > "$OUT/probe.html"
cat "$HERE/early-stub.html" >> "$OUT/probe.html"
tail -n +$LN "$ROOT/index.html" | head -n -2 >> "$OUT/probe.html"
cat "$HERE/probe-snippet.html" >> "$OUT/probe.html"
printf '</body>\n</html>\n' >> "$OUT/probe.html"
grep -q "__probeErrs" "$OUT/probe.html" || { echo "FATAL: early stub missing from assembled probe"; exit 1; }

# 2. Start the beacon listener (TcpListener on 127.0.0.1:8347).
powershell -NoProfile -ExecutionPolicy Bypass -File "$HERE/listen.ps1" -OutDir "$(cygpath -w "$OUT" 2>/dev/null || echo "$OUT")" &
LISTENPID=$!
sleep 2

# 3. Launch headless Edge. Every flag is load-bearing — see PROBE.md before
#    removing any. NEVER point --user-data-dir at a real profile.
EDGE="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
[ -f "$EDGE" ] || EDGE="/c/Program Files/Microsoft/Edge/Application/msedge.exe"
if [ ! -f "$EDGE" ]; then echo "FATAL: msedge.exe not found — edit EDGE in $0"; kill $LISTENPID 2>/dev/null; exit 1; fi
# Mixed-style (C:/...) paths: a POSIX /c/... path inside file:/// or a flag
# value silently breaks Edge (file:////c/... never loads, so no beacon ever
# fires). cygpath -m produces C:/... which works in both positions.
OUTW="$(cygpath -m "$OUT" 2>/dev/null || echo "$OUT")"
# PROBE_WINDOW=390,844 bash tools/probe/run.sh  → phone-viewport pass (deep-link
# landings measure sticky chrome at scroll time; both viewports must pass).
WINSIZE="${PROBE_WINDOW:-1200,900}"
"$EDGE" --headless=new --disable-gpu --no-first-run --no-default-browser-check --disable-extensions \
  --window-size="$WINSIZE" \
  --disable-sync --disable-background-networking --disable-component-update \
  --disable-features=BlockInsecurePrivateNetworkRequests,PrivateNetworkAccessSendPreflights,PrivateNetworkAccessChecks \
  --host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1" \
  --user-data-dir="$OUTW/edge-profile" "file:///$OUTW/probe.html" &
EDGEPID=$!

# 4. Wait for the beacon (up to 90s).
for i in $(seq 1 45); do [ -s "$OUT/probe-report.txt" ] && break; sleep 2; done

# 5. Cleanup: the launcher pid plus any Edge child still holding the probe profile.
kill $EDGEPID 2>/dev/null
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"Name='msedge.exe'\" | Where-Object { \$_.CommandLine -match 'edge-profile' } | ForEach-Object { Stop-Process -Id \$_.ProcessId -Force -ErrorAction SilentlyContinue }" >/dev/null 2>&1
kill $LISTENPID 2>/dev/null

# 6. The requirements pairing check (user ruling, Aug 13 2026). Runs OUTSIDE
#    the browser because it needs the filesystem: the in-page suite cannot read
#    REQUIREMENTS.md, which is exactly why six [R61.x] tags reported PASS
#    against rows that did not exist. Its findings are SUITE FAILURES — they
#    are appended to the report and they rewrite the header, so `head -1` never
#    says PASS while a pairing failure stands.
if [ -s "$OUT/probe-report.txt" ]; then
  PAIR="$(bash "$HERE/reqpair.sh" "$ROOT" "$OUT/probe-report.txt")"
  PAIRRC=$?
  # The beacon body ends without a trailing newline, so append one first or
  # the pairing section lands glued to ===END=== and greps miss it.
  [ -n "$(tail -c1 "$OUT/probe-report.txt")" ] && printf '\n' >> "$OUT/probe-report.txt"
  printf '%s\n' "$PAIR" >> "$OUT/probe-report.txt"
  if [ $PAIRRC -ne 0 ]; then
    NP=$(printf '%s\n' "$PAIR" | grep -c '^PAIRING FAIL')
    HDR=$(head -1 "$OUT/probe-report.txt")
    case "$HDR" in
      PROBE-PASS*) NEW="PROBE-FAIL $NP (pairing)";;
      PROBE-FAIL*) NEW="$HDR + $NP pairing";;
      *)           NEW="PROBE-FAIL $NP (pairing)";;
    esac
    { printf '%s\n' "$NEW"; tail -n +2 "$OUT/probe-report.txt"; } > "$OUT/probe-report.tmp"
    mv "$OUT/probe-report.tmp" "$OUT/probe-report.txt"
  fi
fi

# 7. Report.
if [ -s "$OUT/probe-report.txt" ]; then
  cat "$OUT/probe-report.txt"
  head -1 "$OUT/probe-report.txt" | grep -q "^PROBE-PASS" && exit 0 || exit 2
else
  echo "NO REPORT after 90s — work the 'If the suite hangs' checklist in PROBE.md"
  exit 3
fi
