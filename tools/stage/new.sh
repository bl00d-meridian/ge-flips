#!/usr/bin/env bash
# ═══ OPEN A STAGED REPAIR PASS (user ruling, Aug 19 2026) ═══════════════════
#
# Repairs made under the pressure of a just-delivered finding get scoped to that
# finding's SPELLING rather than to its property. Three instances in one week,
# each the repair for the one before it (MISTAKES M170). The separation that
# works is not time — the same reader an hour later still has the finding in
# front of it — but a COLD reader, shown the diff and not the finding.
#
# So a repair pass writes here, and lands in the NEXT session:
#
#   bash tools/stage/new.sh            # copy the tree into staging/
#   ...edit staging/index.html etc...
#   bash tools/stage/run.sh            # full suite + seeds against the STAGED copy
#   bash tools/stage/check.sh          # freeze proof + the diff
#   (next session) cold review -> record the verdict in staging/PASS.md
#   bash tools/stage/land.sh --yes     # guarded landing
#
# ESCAPE HATCH, as scoped by the user: a SINGLE-SITE fix with no generalisation
# available may land in one session. The moment a repair implies "and everywhere
# else like it", it stages.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
ST="$ROOT/staging"
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

if [ -d "$ST" ] && [ -n "$(ls -A "$ST" 2>/dev/null)" ] && [ $FORCE -eq 0 ]; then
  echo "REFUSED: staging/ is not empty — a pass is already open."
  echo "  Land it (tools/stage/land.sh), or discard it with: rm -rf staging && bash tools/stage/new.sh"
  exit 1
fi
rm -rf "$ST"; mkdir -p "$ST"

cp "$ROOT/index.html"                   "$ST/index.html"
cp "$ROOT/tools/probe/probe-snippet.html" "$ST/probe-snippet.html"
cp "$ROOT/REQUIREMENTS.md"              "$ST/REQUIREMENTS.md"

# The freeze baseline: the TREE's hashes at the moment the pass opened. check.sh
# and land.sh both re-verify these. `index.html` unchanged for the whole pass is
# the property the whole mechanism rests on, and a freeze that is claimed rather
# than verified is not a freeze.
( cd "$ROOT" && sha256sum index.html tools/probe/probe-snippet.html REQUIREMENTS.md ) > "$ST/BASELINE.sha256"

cat > "$ST/PASS.md" <<'MD'
# Staged repair pass

**Opened:** (fill in) · **Tree frozen at:** see `BASELINE.sha256`

Nothing in this directory has landed. `index.html` in the tree is untouched.

---

## Repair 1 — (short name)

**The finding that provoked it:** (one line — for the record; the cold reviewer is NOT shown this)

**THE PROPERTY THIS REPAIR IS ABOUT** (the repairer's answer, written BEFORE the search):
> (state it as a property of code, not as the text of the finding)

**The property-scoped search:** (the command, and every site it returned)

**Sites touched:** (file:line each)
**Sites returned but deliberately NOT touched:** (each with the reason, and the reason also
goes in the source at that site — a deliberate exception recorded only in an audit is one the
next reader will "complete")

**Seeds:** (id, what was seeded, which assertion went red, restored green)

**COLD REVIEW** — filled in by the NEXT session, which is shown the diff and not the finding:
- Reviewer's answer to *"name the property this repair is about"*: (verbatim)
- Sites the reviewer's property-scoped search returned: (list)
- Verdict: PENDING     <!-- one of: PENDING | PASS | SENT BACK -->

MD

echo "STAGE OPEN — staging/ created from the tree"
sed 's/^/  BASELINE  /' "$ST/BASELINE.sha256"
echo "  Next: edit staging/index.html and staging/probe-snippet.html, then: bash tools/stage/run.sh"
