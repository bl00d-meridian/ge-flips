#!/usr/bin/env bash
# Land a staged pass onto the tree. GUARDED, because the guard is the rule.
#
# A staged pass may only land once a COLD reader — one that was shown the diff
# and NOT the finding that provoked it — has named the property each repair is
# about and run a property-scoped search. Without that, this is just a slower
# way to do what M170 recorded going wrong three times.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
ST="$ROOT/staging"
[ -f "$ST/BASELINE.sha256" ] || { echo "FATAL: no staged pass open"; exit 1; }
FAIL=0
say(){ echo "  $1"; }

echo "═══ LANDING CHECKS ═══"
if ( cd "$ROOT" && sha256sum -c --status "$ST/BASELINE.sha256" ); then say "OK    freeze intact — the tree did not move";
else say "BLOCK freeze broken — the tree moved while the pass was open"; FAIL=1; fi

for W in 1200 390; do
  R="$ST/REPORT-staged-$W.txt"
  if [ ! -f "$R" ]; then say "BLOCK no staged suite report for the ${W}px viewport (tools/stage/run.sh)"; FAIL=1; continue; fi
  H=$(head -1 "$R")
  case "$H" in
    PROBE-PASS*\[STAGED:*) say "OK    ${W}px: $H";;
    *\[STAGED:*)           say "BLOCK ${W}px staged run is not green: $H"; FAIL=1;;
    *)                     say "BLOCK ${W}px report carries no [STAGED:] stamp — it read the TREE, not staging/: $H"; FAIL=1;;
  esac
done

NV=$(grep -c "^- Verdict:" "$ST/PASS.md" 2>/dev/null; true)
NP=$(grep -c "^- Verdict: PASS" "$ST/PASS.md" 2>/dev/null; true)
NR=$(grep -c "^- Reviewer.s answer to" "$ST/PASS.md" 2>/dev/null; true)
if [ "$NV" -eq 0 ]; then say "BLOCK PASS.md records no repair verdicts"; FAIL=1
elif [ "$NP" -ne "$NV" ]; then say "BLOCK $NP of $NV repairs carry 'Verdict: PASS' — the rest are PENDING or SENT BACK"; FAIL=1
else say "OK    $NP of $NV repairs passed cold review"; fi
if grep -q "^- Reviewer's answer to .*: *$" "$ST/PASS.md" 2>/dev/null || [ "$NR" -lt "$NV" ]; then
  say "BLOCK a repair has no recorded reviewer-named property. That record is the point: it is what tells a"
  say "      later pass whether the property was named too narrowly or the search was run too narrowly."
  FAIL=1
else say "OK    every repair carries the cold reviewer's named property"; fi

[ $FAIL -eq 0 ] || { echo; echo "NOT LANDED."; exit 1; }
if [ "${1:-}" != "--yes" ]; then echo; echo "All checks pass. Re-run with --yes to copy staging/ over the tree."; exit 0; fi

cp "$ST/index.html"         "$ROOT/index.html"
cp "$ST/probe-snippet.html" "$ROOT/tools/probe/probe-snippet.html"
cp "$ST/REQUIREMENTS.md"    "$ROOT/REQUIREMENTS.md"
echo; echo "LANDED. Now run the suite on the REAL files (both viewports) to confirm the move was clean:"
echo "  bash tools/probe/run.sh  &&  PROBE_WINDOW=390,844 bash tools/probe/run.sh"
echo "Then append this pass to audits/REPAIR-LEDGER.md and clear staging/."
