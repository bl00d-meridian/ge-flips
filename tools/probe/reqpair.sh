#!/usr/bin/env bash
# ═══ THE REQUIREMENTS PAIRING CHECK (user ruling, Aug 13 2026) ═══
#
# The ledger is only a ledger if it is checked in BOTH directions. Before this
# existed it was checked in neither:
#
#   • Six assertions carried [R61.x] tags and no §61 rows existed, so the
#     report's ===REQS=== section printed "REQ PASS R61.1" against nothing.
#     A requirement that does not exist cannot fail, and the report said it
#     passed — the ledger lying in exactly the direction it was built to
#     prevent.
#   • Two withdrawn rows (§31) went on claiming `probe [R31.x]` after their
#     assertions were deleted with the feature, and a third row (R35.4) cited
#     one of them. That is the seasoning-gate shape: a spec claiming an
#     implementation that is not there, with nothing cross-referencing them.
#
# This runs OUTSIDE the browser because the check needs the filesystem — the
# in-page suite cannot read REQUIREMENTS.md. It reads the two artefacts and
# compares their id sets:
#
#   CLAIMED — every id the report's ===REQS=== section reported this run.
#   KNOWN   — every row id in REQUIREMENTS.md, plus every tag it cites in
#             backticks (a row may legitimately be verified by an assertion
#             tagged with a different id, e.g. R1.1b by `[R1.1a]`).
#
#   A: CLAIMED \ KNOWN  → an assertion reporting against no requirement.
#   B: CITED   \ CLAIMED → a requirement citing an assertion that did not run.
#
# Both are FAILURES, not notes. A row deliberately verified some other way —
# inspection, UI, documentation — cites no probe tag and is exempt by
# construction, which is what makes B safe to state globally.
set -u
ROOT="$1"
REPORT="$2"
REQ="${3:-$ROOT/REQUIREMENTS.md}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

[ -f "$REQ" ] || { echo "PAIRING FATAL: REQUIREMENTS.md not found at $REQ"; exit 1; }
[ -s "$REPORT" ] || { echo "PAIRING FATAL: no probe report to check"; exit 1; }

# CLAIMED: ids from the report's ===REQS=== block, which is what the run says
# it verified. Reading the report rather than the snippet source is deliberate
# — an assertion that exists but never ran verified nothing, and the whole
# point of this check is that a claim of coverage must be true.
sed -n '/^===REQS===/,$p' "$REPORT" | grep -oE '^REQ (PASS|FAIL) R[0-9]+\.[0-9]+[a-z]?$' \
  | awk '{print $3}' | sort -u > "$TMP/claimed"
if [ ! -s "$TMP/claimed" ]; then
  echo "PAIRING FAIL: the report carries no ===REQS=== section — nothing cross-referenced this run"
  exit 1
fi

# KNOWN: row ids, plus tags the ledger cites in backticks.
grep -oE '^\| R[0-9]+\.[0-9]+[a-z]? \|' "$REQ" | tr -d '| ' | sort -u > "$TMP/rows"
grep -oE '`\[R[0-9]+\.[0-9]+[a-z]?\]`' "$REQ" | tr -d '`[]' | sort -u > "$TMP/cited"
sort -u "$TMP/rows" "$TMP/cited" > "$TMP/known"

comm -23 "$TMP/claimed" "$TMP/known" > "$TMP/orphanTags"
comm -13 "$TMP/claimed" "$TMP/cited" > "$TMP/orphanCites"

nT=$(grep -c . < "$TMP/orphanTags")
nC=$(grep -c . < "$TMP/orphanCites")

echo "===PAIRING=== (REQUIREMENTS.md ↔ probe assertions, both directions)"
echo "PAIRING claimed by the run: $(grep -c . < "$TMP/claimed") · row ids: $(grep -c . < "$TMP/rows") · cited tags: $(grep -c . < "$TMP/cited")"
if [ "$nT" -gt 0 ]; then
  while read -r t; do
    echo "PAIRING FAIL $t — assertion reports this id and REQUIREMENTS.md has no row for it and cites it nowhere. Add the row or retag the assertion; a tag with no requirement reports PASS against nothing."
  done < "$TMP/orphanTags"
fi
if [ "$nC" -gt 0 ]; then
  while read -r t; do
    echo "PAIRING FAIL $t — REQUIREMENTS.md cites this assertion and no assertion reported it. Write it, correct the citation, or state the row's real verification method; a row citing a probe that does not run claims coverage it does not have."
  done < "$TMP/orphanCites"
fi
if [ "$nT" -eq 0 ] && [ "$nC" -eq 0 ]; then
  echo "PAIRING PASS — every reported tag has a requirement, and every cited assertion ran."
  exit 0
fi
echo "PAIRING: $nT orphaned tag(s), $nC orphaned citation(s)"
exit 1
