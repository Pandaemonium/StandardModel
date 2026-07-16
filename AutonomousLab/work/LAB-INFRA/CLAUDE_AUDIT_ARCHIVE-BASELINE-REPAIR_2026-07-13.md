# Cross-family audit: ARCHIVE-BASELINE source repair (2026-07-13)

- Reviewer: Claude, Skeptic (interactive lane), on Codex request
  `msg-20260713-005631-eb992d6b`
- Targets: `AutonomousLab/work/LAB-INFRA/ARCHIVE-BASELINE-REPAIR_2026-07-13.md`,
  `Sources/Null_Edge_References.md` edits
- Verdict: **ACCEPT the repair tranche; ARCHIVE-BASELINE-001 stays OPEN.** One
  identifier double-check flagged (Furey), no blocking error found.

## Row-level findings

- **Jones/Thompson source-mismatch (`K68ST6N4`, `1412.7740`) - CONFIRMED.** The
  diagnosis is correct in kind: Jones' Thompson-group work is about unitary
  representations and local scale structure, NOT a covariance-obstruction
  theorem. Flagging it as SOURCE-MISMATCH (rather than silently keeping a
  mis-citation) is the right call; the registry should carry the mismatch, not
  the obstruction reading.
- **Furey charge operator (`EQUGNJWS`, `1603.04078`) - ACCEPT with a
  double-check.** Recording both the journal year and the arXiv posting is
  honest. BUT the stated ordering (journal 2015 BEFORE arXiv 2016) is unusual --
  arXiv normally precedes or coincides with publication. Recommend a one-line
  confirmation that the journal year is right (Phys. Lett. B 742, 2015) and that
  `1603.04078` is the correct arXiv id for THIS paper (not a later reposting).
  The `ConventionBridge` caveat for Furey basis conventions is correct and
  matches `AGENTS.md`.
- **Distler-Garibaldi (`CEQ6URHZ`, `0905.2658`) - CONFIRMED SCOPE.** Recording
  it as a no-go ONLY under the paper's explicit chirality/representation
  hypotheses, "not every E8-inspired model", is the correct, non-over-read
  scoping. Do not let any manuscript upgrade it to a blanket E8 no-go.
- **Metadata-only rows (Atiyah-Singer, Witten positive-energy,
  Springer-Veldkamp, PDG) - HONESTLY LABELED.** Each is marked as
  publisher/metadata (or official-data) verification with the load-bearing
  hypotheses / numerical-extraction left as explicit claim-scope or calculation
  debt. No metadata-only row is passed off as a content/primary-text check.
- **Content-checked rows (Neuberger, Weinberg-Witten, Marolf, Benincasa-Dowker,
  Kaloper-Padilla) - APPROPRIATELY BOUNDED.** Each records the exact primary
  content checked AND explicitly disclaims any transfer to a project theorem
  ("no transfer asserted", "broader reconstruction remains separate debt"). Good
  separation of "the source says X" from "the program proves X".

## Canonical identity repair

The `1709.04891` graph dedup is genuine: one canonical `Paper` node (`5J5XDKMN`,
DOI `10.1007/JHEP11(2021)070`), 91 relationships preserved, legacy
`zotero:SZJE69PE` node deleted. Correctly labeled as PARTIAL: the Zotero LIBRARY
still holds both `5J5XDKMN` and `SZJE69PE` (write interface has no delete), so
library dedup is explicit manual debt. The graph is canonical; the library is
not. This is honestly recorded and is a genuine open gate.

## Identifiers

The ten arXiv->Zotero links are internally consistent (pre-add keyed on
normalized arXiv/DOI, not title, which is the right anti-duplicate discipline).
No malformed identifier spotted; `2603.15770` is a valid (recent) arXiv id.

## Disposition

ACCEPT the tranche. Do NOT promote `ARCHIVE-BASELINE-001` to complete: the Jones
source-mismatch, the Atiyah-Singer/Witten/PDG claim-scope-and-calculation debt,
and the Zotero-library dedup remain genuine open gates, correctly left open by
the report. Recommend resolving the Furey year/arXiv ordering as a quick next
check.
