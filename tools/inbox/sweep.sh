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
QUIET=0
for a in "$@"; do case "$a" in -q|--quiet) QUIET=1 ;; esac; done
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

sweep_class(){
  local label="$1" pat="$2" dest="$3"
  local newest="" f
  # Newest by mtime across the class, duplicates included.
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    if [ -z "$newest" ] || [ "$f" -nt "$newest" ]; then newest="$f"; fi
  done < <(find "$DL" -maxdepth 1 -type f -name "$pat" 2>/dev/null)

  if [ -z "$newest" ]; then
    say "$(printf '%-22s none found' "$label")"
    return
  fi

  local base gat ah note dropped=0
  base="$(basename "$newest")"
  gat="$(gen_at "$newest")"
  ah="$(age_h "$gat")"

  # Older members of the same class go, including the browser's " (N)" copies.
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    [ "$f" = "$newest" ] && continue
    rm -f -- "$f" && dropped=$((dropped+1))
  done < <(find "$DL" -maxdepth 1 -type f -name "$pat" 2>/dev/null)

  mkdir -p "$dest"
  mv -f -- "$newest" "$dest/$base" 2>/dev/null || {
    say "$(printf '%-22s MOVE FAILED %s' "$label" "$base")"; MOVED=1; return; }
  MOVED=1

  if [ -z "$gat" ]; then
    note="generatedAt: absent — age unknown, do not read as current"
  elif [ -z "$ah" ]; then
    note="generatedAt: $gat (unparseable — age unknown)"
  elif [ "$ah" -ge "$STALE_H" ]; then
    note="generatedAt: $gat — ${ah}h old · STALE (>${STALE_H}h): do not read as current state"
  else
    note="generatedAt: $gat — ${ah}h old · current"
  fi
  say "$(printf '%-22s %s -> %s/  · %s%s' "$label" "$base" \
    "$(basename "$dest")" "$note" \
    "$([ "$dropped" -gt 0 ] && printf ' · %d older duplicate(s) deleted' "$dropped")")"
}

sweep_class "analysis-paper"       "analysis-paper-*.json"       "$INBOX"
sweep_class "analysis-prospecting" "analysis-prospecting-*.json" "$INBOX"
sweep_class "analysis-gates"       "analysis-gates-*.json"       "$INBOX"
sweep_class "analysis-calibration" "analysis-calibration-*.json" "$INBOX"
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
if [ "$QUIET" -eq 1 ] && [ "$MOVED" -eq 0 ]; then exit 0; fi
echo "INBOX-SWEEP  Downloads: $DL  ·  stale after ${STALE_H}h"
printf '%s' "$LINES"
exit 0
