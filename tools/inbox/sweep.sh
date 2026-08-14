#!/usr/bin/env bash
# Downloads → inbox/ collector for every export class this tool produces.
#
# WHY THIS EXISTS: the tracker's exports are downloaded by the browser and read
# by the analyst at the desk, so every read used to cost a manual hop — find it
# in Downloads, move it, delete the " (1)" copies the browser leaves behind.
# Generalised from the flags-only sweep the briefing procedure carried.
#
# CONTRACT
#   - Downloads is resolved from the Windows known-folder API, never hardcoded.
#   - Per class: the NEWEST file by mtime is kept and moved; older members of
#     that class are deleted from Downloads, which is where the " (1)" / " (2)"
#     duplicates go.
#   - flags-pending keeps its EXISTING destination (briefings/), because the
#     briefing procedure reads it there by name. Everything else lands in inbox/.
#   - Every class reports a line whether or not it found anything: "none found"
#     is a result, and silence is not.
#   - A file's age is read from its own generatedAt, never from its mtime — an
#     export that sat in Downloads for a day is a day old regardless of when it
#     was moved.
#
# Output is a stable, greppable table so a session can act on it without
# re-deriving anything. Exit 0 always: nothing here should fail a session.

#   - EXPORTS HAPPEN MID-SESSION BY NATURE, so a session-start-only trigger is
#     the wrong shape: it collects what was already there and misses everything
#     the user presses export for while working. Run it opportunistically — the
#     UserPromptSubmit hook does this in --quiet mode, which prints nothing at
#     all unless something actually moved, so a silent no-op costs nothing and
#     a collected file always announces itself.

set -u
QUIET=0; STATUS=0
for a in "$@"; do case "$a" in -q|--quiet) QUIET=1 ;; --status) STATUS=1 ;; esac; done
STALE_H="${STALE_H:-6}"                       # hours after which a file is stale
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INBOX="$REPO/inbox"
BRIEFINGS="$REPO/briefings"

DL="$(powershell -NoProfile -Command \
  "(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path" 2>/dev/null \
  | tr -d '\r')"
if [ -z "${DL:-}" ] || [ ! -d "$DL" ]; then
  # Fall back to the profile default only if the API gave us nothing usable.
  DL="${USERPROFILE:-$HOME}/Downloads"
  DL="$(printf '%s' "$DL" | sed 's|\\|/|g')"
fi
[ -d "$DL" ] || { echo "INBOX-SWEEP: no Downloads folder resolved — nothing done."; exit 0; }

mkdir -p "$INBOX" "$BRIEFINGS"

# --status answers "did it fire?" from the record rather than from silence.
if [ "$STATUS" -eq 1 ]; then
  if [ -f "$INBOX/.last-sweep" ]; then
    echo "INBOX-SWEEP last ran: $(cat "$INBOX/.last-sweep")"
  else
    echo "INBOX-SWEEP has never run in this clone — no stamp at $INBOX/.last-sweep"
  fi
  exit 0
fi

# generatedAt, read from the file's own header. Absent is a real answer.
gen_at(){ grep -o '"generatedAt"[[:space:]]*:[[:space:]]*"[^"]*"' "$1" 2>/dev/null \
            | head -1 | sed 's/.*"\([^"]*\)"$/\1/'; }

# Whole hours between an ISO-8601 UTC stamp and now. Prints "" if unparseable.
age_h(){
  local iso="$1" e n
  [ -n "$iso" ] || { printf ''; return; }
  e="$(date -u -d "$iso" +%s 2>/dev/null)" || { printf ''; return; }
  [ -n "$e" ] || { printf ''; return; }
  n="$(date -u +%s)"
  printf '%s' "$(( (n - e) / 3600 ))"
}

MOVED=0
LINES=""
say(){ LINES="$LINES$1"$'\n'; }

# SEARCH ROOTS, not just Downloads (corrected Aug 13 2026). Sweeping only the
# download folder leaves a class with its newest copy in inbox/ and stale copies
# in a second directory — which is exactly how a 3-hour-old paper export got
# read while a fresher one existed. The property is "ONE copy per class, the
# newest, in its destination", and that cannot be enforced by looking at one
# place. Roots are Downloads plus the repo itself, excluding the destinations,
# so a file carried in by hand is consolidated like any other.
# The destination is a root like any other: a file already sitting there must be
# able to WIN (so it is not displaced by an older copy carried in from
# elsewhere) and must be able to LOSE (so stale copies do not accumulate in the
# very folder whose promise is "one per class"). Excluding it broke both.
find_class(){
  local pat="$1"
  find "$DL" -maxdepth 1 -type f -name "$pat" 2>/dev/null
  find "$REPO" -maxdepth 2 -type f -name "$pat" -not -path "$REPO/.git/*" 2>/dev/null
}
# RANK BY THE FILE'S OWN generatedAt, not by mtime. mtime is a fact about the
# filesystem, not about the export: `mv` carries it, a re-download resets it,
# and a file consolidated from another directory arrives looking newer than it
# is. The stamp inside the file is the only honest ordering key; mtime is the
# fallback for a class that carries no stamp (the state backup).
rank_of(){
  local g; g="$(gen_at "$1")"
  if [ -n "$g" ]; then date -u -d "$g" +%s 2>/dev/null && return; fi
  date -u -r "$1" +%s 2>/dev/null || echo 0
}

sweep_class(){
  local label="$1" pat="$2" dest="$3"
  local newest="" newestRank=-1 f r
  # Newest by its own generatedAt across every root, duplicates included.
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    r="$(rank_of "$f")"
    if [ -z "$newest" ] || [ "$r" -gt "$newestRank" ]; then newest="$f"; newestRank="$r"; fi
  done < <(find_class "$pat")

  if [ -z "$newest" ]; then
    say "$(printf '%-22s none found' "$label")"
    return
  fi

  local base gat ah note dropped=0
  base="$(basename "$newest")"
  gat="$(gen_at "$newest")"
  ah="$(age_h "$gat")"

  # Older members of the same class go, including the browser's " (N)" copies,
  # and including any that drifted into a directory that is not the destination.
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    [ "$f" = "$newest" ] && continue
    rm -f -- "$f" && dropped=$((dropped+1))
  done < <(find_class "$pat")

  mkdir -p "$dest"
  local already=0
  if [ "$newest" = "$dest/$base" ]; then
    already=1
  else
    mv -f -- "$newest" "$dest/$base" 2>/dev/null || {
      say "$(printf '%-22s MOVE FAILED %s' "$label" "$base")"; MOVED=1; return; }
  fi
  # Already-in-place with nothing pruned is a no-op and stays quiet in --quiet.
  [ "$already" -eq 1 ] && [ "$dropped" -eq 0 ] || MOVED=1

  if [ -z "$gat" ]; then
    note="generatedAt: absent — age unknown, do not read as current"
  elif [ -z "$ah" ]; then
    note="generatedAt: $gat (unparseable — age unknown)"
  elif [ "$ah" -ge "$STALE_H" ]; then
    note="generatedAt: $gat — ${ah}h old · STALE (>${STALE_H}h): do not read as current state"
  else
    note="generatedAt: $gat — ${ah}h old · current"
  fi
  say "$(printf '%-22s %s %s %s/  · %s%s' "$label" "$base" \
    "$([ "$already" -eq 1 ] && printf 'already in' || printf '->')" \
    "$(basename "$dest")" "$note" \
    "$([ "$dropped" -gt 0 ] && printf ' · %d older duplicate(s) deleted' "$dropped")")"
}

sweep_class "analysis-paper"       "analysis-paper-*.json"       "$INBOX"
sweep_class "analysis-prospecting" "analysis-prospecting-*.json" "$INBOX"
sweep_class "analysis-gates"       "analysis-gates-*.json"       "$INBOX"
sweep_class "analysis-calibration" "analysis-calibration-*.json" "$INBOX"
sweep_class "analysis-scorer"      "analysis-scorer-*.json"      "$INBOX"
sweep_class "analysis-all"         "analysis-all-*.json"         "$INBOX"
sweep_class "state-backup"         "ge-flips-*.json"             "$INBOX"
# flags-pending keeps its existing home: the briefing procedure reads it there
# by name, and generalising the sweep must not move that target.
sweep_class "flags-pending"        "flags-pending*.json"         "$BRIEFINGS"

# QUIET mode prints only when something actually moved, so the opportunistic
# hook is silent on the overwhelming majority of turns and impossible to ignore
# on the ones that matter. Verbose mode always prints the full table, including
# every "none found", because a reader who asked for the sweep is owed the
# per-class result rather than a blank.
# THE RUN LEAVES A RECORD EVEN WHEN IT IS SILENT (corrected Aug 13 2026, second
# report of "the collector did not fire"). Both times it HAD fired and found
# nothing — but in --quiet mode "ran and moved nothing" printed exactly what
# "never ran" printed, so silence was unfalsifiable and the only way to answer
# "did it fire?" was to reason about it. That is absence rendered as
# data-of-absence, the rule this repo holds BINDING, violated by its own tool.
# The transcript stays quiet, which is what makes a per-prompt hook viable; the
# STATE becomes observable. `--status` reads it back without sweeping.
STAMP="$INBOX/.last-sweep"
mkdir -p "$INBOX"
printf '%s\tmoved=%d\tclasses=%d\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$MOVED" \
  "$(printf '%s' "$LINES" | grep -vc 'none found' || true)" > "$STAMP" 2>/dev/null || true

if [ "$QUIET" -eq 1 ] && [ "$MOVED" -eq 0 ]; then exit 0; fi
if [ -f "$STAMP" ]; then
  prev="$(cat "$STAMP" 2>/dev/null | cut -f1)"
fi
echo "INBOX-SWEEP  Downloads: $DL  ·  stale after ${STALE_H}h  ·  this run ${prev:-just now}"
printf '%s' "$LINES"
exit 0
