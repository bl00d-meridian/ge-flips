#!/usr/bin/env bash
# The freeze proof and the diff — the two artefacts the pass ends with.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
ST="$ROOT/staging"
[ -f "$ST/BASELINE.sha256" ] || { echo "FATAL: no staged pass open"; exit 1; }

echo "═══ FREEZE ═══ (the tree must not have moved while the pass was open)"
if ( cd "$ROOT" && sha256sum -c "$ST/BASELINE.sha256" ) ; then
  FREEZE=ok
else
  FREEZE=broken
fi
echo

echo "═══ DIFF ═══ (staged vs tree; written to staging/DIFF.patch)"
: > "$ST/DIFF.patch"
for pair in "index.html:index.html" \
            "tools/probe/probe-snippet.html:probe-snippet.html" \
            "REQUIREMENTS.md:REQUIREMENTS.md"; do
  T="${pair%%:*}"; S="${pair##*:}"
  diff -u "$ROOT/$T" "$ST/$S" --label "a/$T" --label "b/staging/$S" >> "$ST/DIFF.patch"
done
if [ -s "$ST/DIFF.patch" ]; then
  awk '/^--- /{f=$2} /^\+\+\+ /{next} /^\+/&&!/^\+\+\+/{a[f]++} /^-/&&!/^---/{d[f]++} END{for(k in a) printf "  %-12s +%d\n", k, a[k]; for(k in d) printf "  %-12s -%d\n", k, d[k]}' "$ST/DIFF.patch" | sort
  echo "  ($(grep -c '^[+-]' "$ST/DIFF.patch") changed lines total)"
else
  echo "  (no staged changes yet)"
fi
echo

echo "═══ RECORD ═══"
for f in PASS.md REPORT-staged-1200.txt REPORT-staged-390.txt; do
  if [ -f "$ST/$f" ]; then echo "  present  $f"; else echo "  MISSING  $f"; fi
done
grep -n 'Verdict:' "$ST/PASS.md" 2>/dev/null | sed 's/^/  /'
echo
[ "$FREEZE" = ok ] && echo "FREEZE OK — index.html hashes to what it did when the pass opened." \
                   || { echo "FREEZE BROKEN — the tree moved during the pass. The diff above is not what you think it is."; exit 1; }
