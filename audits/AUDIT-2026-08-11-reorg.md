# Integration audit — 2026-08-11 (surface reorganization, same-session)

Scope: the surface reorganization ruled today — 6 tabs → 4 (Home / Trade / Sleeve /
Review), tier-1 Home (NOW → rulings digest → what-changed → vitals → walk-up), Trade
sub-views (Plan & Watchlist / Scanner / Flip Log), Shadow Fund folded into Review.
Composition change only: no new data, no new mechanisms. This audit ran **before**
calling the build done, per the ruling; findings caught mid-walk were fixed in the same
change (they are build defects, not strategy parameters — nothing here moves a gate,
budget, or verdict boundary). Numbering continues from AUDIT-2026-08-10b.md.

## Workflow walks

**Walk-up (phone-first, the majority case).** Boot lands on Home with zero clicks: NOW
bar (unchanged, global, above the tabs), rulings digest with its inline
ratify/dismiss/snooze (1 click per ruling), delta block, vitals, then the walk-up
checklist with its plan/sell/quote/ladder inlines exactly as before. Every checklist
"→ open" link and NOW-bar "→ go" resolves through the legacy-name aliases
(`watch`/`scan`/`log`/`shadow`/`routine` → new surfaces, probe `[R20.6]`). Mobile: the
vitals grid stacks to one column at phone width, the delta block truncates at 6 lines
with "+N more" (`[R20.5]`), and no Home block uses the `.sec` columns the phone
stylesheet hides. Walk-up attention budget unchanged and still probe-asserted ≤7 on the
new surface (`[R13.1]`, `[R20.4]`).

**Briefing cycle.** The handoff reminder renders in the walk-up panel on Home (its
elevation logic untouched); flags-pending export rides it; Import briefing stays on
Sleeve (1 click); ratified/dismissed records land in the digest and decision log as
before. The delta block adds the read-only "briefing state: X → Y" transition line.

**Sleeve entry-to-exit.** Tab unchanged. Armed rungs surface in three tiers now, all
read-only until pressed: delta line when a rung armed since the last visit, vitals
one-liner (nearest rung distance, nearest catalyst countdown), and the walk-up sell
step's SELL cards as before. Exits still record only through the user's press.

**Weekly review.** The Review tab is the weekly checklist (same steps: per-item table,
markouts, baskets, sleeve, scorecard, discovery audit, shadow book, attention &
dormancy, friction, bank, export) plus the Shadow-fund panels below it.
`lastReviewAt` stamps on step interaction as before, since mode follows the tab.

## Findings

**F9 — default-tab machinery starvation (composition, caught mid-walk, fixed).** The
funnel ledger (`deployLog` hourly snapshots) and the entire shadow book
(`shadowScan`/`shadowTick` per-refresh ride) were side-effects of `renderDeploy`,
which ran because the old boot tab was Watchlist. With Home as the boot surface,
sitting on Home would have silently starved both — the shadow book only fills while
observed. *Fix shipped:* the vitals' funnel tile performs the same plan read and calls
`renderDeploy(P)` — one code path, now riding the tier-1 surface (`[R20.3]`).

**F10 — rulings digest duplication (redundancy, caught mid-walk, fixed).** Home's
digest block and the walk-up checklist's "Rule on what's pending" step both rendered
`rulingsInline()` — the same interactive lines twice on one screen. *Fix shipped:* on
Home the checklist step is a pointer to the digest above; everywhere else (including
the probe fixtures' legacy surface) the step keeps the full inline. Probe-asserted
non-duplication (`[R20.2]`).

**F11 — stale feature-touch keys would poison the dormancy report (observation layer,
fixed).** After the rename, `tab:watch`/`tab:shadow`/`tab:routine` keys stop being
written; in 90 days the dormancy report would have proposed demoting surfaces that are
alive under `tab:trade/watch`/`tab:review`/`tab:home`. *Fix shipped:* one-time key
migration in `load()` (stamps merged earliest-first/latest-last); the removed mode
buttons' keys dropped because the buttons no longer exist; decision-logged.

**F12 — visit state does not survive export→import (accepted, stated).** The delta
clock (`lastOpenAt`/`prevOpenAt`) and end-of-visit snapshot are attention state, not
trading data, and are deliberately outside the export sanitizer — a restored browser
says "first visit with the delta tracker — changes accrue from now" instead of diffing
against a foreign baseline. Alternative (exporting attention state) considered and not
recommended; flagging so the omission is a decision, not an accident.

## Orphan scan

Every new element has a writer, a reader, and a decision it serves: the digest is the
existing rulings queue rendered at tier 1; delta lines read only existing stores
(`flagArchive`, `anomalyFlags`, `shadowBook`, `shadowDivLog`, `catalysts`, sleeve
ladders, briefing state) against the visit clock; all four vitals tiles are
click-throughs to their full surfaces. No write-only stores added; `homeSnap` is
written by the render tick and read by the next visit's delta. Nothing was deleted:
Routine's two checklists live on Home/Review, Shadow Fund's three panels on Review,
Scanner and Flip Log one level down in Trade.

## Redundancy scan

One near-miss (F10, fixed). The Shadow-fund progress headline now appears twice by
design — a one-liner on the Capital vitals tile, full bars on Review — which is the
ruled vitals pattern (headline + click-through), not a duplicated surface.

## Click audit (probe-asserted where measurable)

| Information | Clicks | Assertion |
|---|---|---|
| NOW actions | 0 | `[R20.1]` |
| Any pending ruling | 1 (inline on Home) | `[R20.2]` |
| Shadow/regime results | 1 (vitals → Review) | `[R20.3]` |
| Plan / watchlist / positions | 1 (Trade) | `[R20.6]` |
| Sleeve position state | 0–1 (vitals one-liner; tab) | `[R20.3]` |
| Funnel headline | 0 (vitals) · 1 for full funnel | `[R20.3]` |
| Scanner, Flip Log | 2 (Trade sub-views) | `[R20.6]` |
| Collapsed disclosures (benched, scout log, beyond-net…) | 2–3 | `[R20.7]` flags any 3-click surface used in 30d |

**The 30-day usage sanity-check:** the feature-touch ledger lives in the browser's
localStorage — it cannot be read from the repo, so the check ships as machinery
instead of a one-off: `tierContradictions()` renders in the attention & dormancy
report and names any surface used in the last 30 days that now sits deeper than 2
clicks ("usage contradicts the tier assignment — propose a promotion"), with an
explicit clean line otherwise (`[R20.7]`). On your next open, if your actual usage
contradicts the tier assignments above, the report will say so rather than silently
following either the data or the stated priorities.

## Complexity governance price tag

This change removes two top-level tabs (6 → 4) and adds no decisions: the digest is
the same capped queue relocated, the delta block and vitals are read-only. The
walk-up decision budget (≤7) still binds and is still probe-asserted. Feature freeze
answer: the Home surface replaces the Routine tab and absorbs the Shadow Fund tab.

## Verification

`bash tools/probe/run.sh` → **PROBE-PASS**, 80 requirement IDs asserted including the
new §20 rows (REQUIREMENTS.md). All pre-existing requirement assertions pass unchanged
against the merged layout.
