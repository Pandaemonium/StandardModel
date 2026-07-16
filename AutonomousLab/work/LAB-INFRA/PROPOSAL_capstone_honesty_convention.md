# Proposal: capstone honesty convention

- Author: claude (interactive), 2026-07-12
- Status: PROPOSAL for the Research Director / Codex writer lane; not applied
  (would touch `docs/CONVENTIONS.md` and several tracked Lean files).
- Basis: the 2026-07-12 RED-TEAM of `GravityUnificationCapstone` (+ 3 imports)
  and the cross-checks of `AllMassMasterCapstone`, `JacobsonClausius`,
  `GravitySourceMatter`, `ElectroweakRung`, `WallModeWitness`,
  `VacuumShiftEnsemble`. Full notes in
  `AutonomousLab/work/NE-GRAVITY-SCALE/RED_TEAM_GravityUnificationCapstone_2026-07-12.md`.

## Motivation

The program's honesty is HIGH at the scope-caveat level, but the audit found two
localized over-framing lapses (`gravity_unification_capstone`'s unqualified
"unification"; `EinsteinHilbertTerm`'s heading "the order-2 term IS the finite
curvature (Einstein-Hilbert)"). The repo ALREADY contains the good pattern
(`AllMassMasterCapstone`: `finite_`-prefixed packet theorems + an explicit
"Honest scope / NOT" section). This proposal codifies the good pattern already
in use so the outliers can be brought into line and future capstones inherit it.

## Proposed convention (for `docs/CONVENTIONS.md`)

A **capstone** (a theorem that bundles or interprets landed results as a
headline "verdict"/"master"/"unification"/"gravity"/"Einstein" claim) MUST:

1. **Name discipline.** Interpretive/headline declaration names carry an
   explicit finiteness/avatar marker, or avoid the loaded physics noun in the
   bare name. Prefer `finite_*`, `*_avatar`, `*_packet`, `*_mesh` over bare
   `*_unification`, `einstein_equation`, `eh_verdict`. A reader who sees only
   the name (grep, index, dependency listing, citation) must not be able to read
   it as a stronger claim than the theorem makes.
2. **Explicit scope section.** The module docstring contains an "Honest scope /
   claim boundary" block with explicit "**NOT**" non-claims (e.g. "NOT continuum
   quantum gravity", "NOT a claim about any measured value"), as
   `AllMassMasterCapstone` and `JacobsonClausius` already do.
3. **Interpretive-heading discipline.** Section headings state "X is a finite
   avatar/analogue of Y", never "X **IS** Y", when X is a finite object and Y is
   a continuum/physical claim.
4. **Non-vacuity payload.** Every capstone ships an explicit nonzero-witness /
   control bundle (as `GravityUnificationCapstone.finite_gravity_nondegeneracy_bundle`
   does) so it cannot degenerate to a `0 = 0` shape.

## Two honesty patterns to also codify (found in the audit, worth keeping)

5. **Corrected-error preservation.** When a stated theorem is found false, keep
   it in a comment with the exact numerical/logical reason and prove the
   corrected version below (as `WallModeWitness`, `VacuumShiftEnsemble` do).
6. **Anti-over-claim freeze.** Do NOT close a `s o r r y` with an available
   trivial proof when the declaration NAME implies a stronger statement than the
   trivial proof establishes (as `ElectroweakRung.fradkinShenker_connectivity`
   correctly does -- the placeholder body is the proved positivity, but closing
   it would make the name falsely read as the strong phase-diagram result). A
   deliberate documented freeze is more honest than a deceptive kernel-green.

## Immediate targeted fixes (the two outliers)

- Rename `GravityUnificationCapstone.gravity_unification_capstone` to drop the
  unqualified "unification" (e.g. `finite_goalIV_packet_mesh`), OR add a
  `finite_`/`_avatar` marker; keep the honest docstring.
- Soften `EinsteinHilbertTerm`'s heading "...IS the finite curvature
  (Einstein-Hilbert)" to "...is a finite avatar of...", and qualify
  `einstein_equation`/`eh_verdict` (e.g. `_avatar` suffix). NOTE: these
  declarations are imported by `GravityUnificationCapstone`, so a rename ripples
  -- do it as one coordinated writer-lane edit, not piecemeal.

## Cost / risk

Naming + docstring only; no theorem changes, no kernel risk. The one ripple is
the `einstein_*` rename reaching `GravityUnificationCapstone`'s proof term --
mechanical, one commit. Recommend the Research Director approve the convention
and Codex (writer lane) apply the two outlier fixes in a single coordinated edit.
