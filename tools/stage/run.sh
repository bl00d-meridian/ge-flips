#!/usr/bin/env bash
# Run the FULL probe suite against the staged copy, and keep the report with it.
#
# This wrapper exists because the failure it prevents is the obvious one: setting
# the three env vars by hand, forgetting one, and reading a tree run as proof that
# the staged repairs verify. Every flag the real runner takes still works —
#   PROBE_WINDOW=390,844 bash tools/stage/run.sh
#   PROBE_WARM=1         bash tools/stage/run.sh
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
ST="$ROOT/staging"
[ -f "$ST/index.html" ] || { echo "FATAL: no staged pass — run tools/stage/new.sh first"; exit 1; }

PROBE_SRC="$ST/index.html" \
PROBE_SNIPPET="$ST/probe-snippet.html" \
PROBE_REQ="$ST/REQUIREMENTS.md" \
bash "$ROOT/tools/probe/run.sh"
RC=$?

# Keep the staged report beside the staged code. land.sh requires a green one,
# and it must be the report of a run that actually read this directory — which
# is what the header's [STAGED: ...] stamp certifies.
SUF="${PROBE_WINDOW:-1200,900}"; SUF="${SUF%%,*}"
cp "$ROOT/tools/probe/out/probe-report.txt" "$ST/REPORT-staged-$SUF.txt" 2>/dev/null
echo "staged report kept at staging/REPORT-staged-$SUF.txt"
exit $RC
