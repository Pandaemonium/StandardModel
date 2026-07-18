# Equivariant polynomial probe projector

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`  
Status: integrated, built, and independently approved including certificate transport

## Purpose

The corrected G2 interface needs a basis-free rank-four projector, not four
individually canonical probe vectors. A polynomial filter of a graph-derived
operator is a natural candidate because it can select a whole spectral sector
without ordering eigenvectors.

## Integrated result

`PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean` proves:

- polynomial evaluation at intertwining real-linear endomorphisms also
  intertwines;
- the filtered ranges transport exactly under the linear equivalence;
- an idempotent polynomial filter with four-dimensional range packages as the
  existing `RankFourProbeProjector`;
- applying one common polynomial to two order-intertwining carrier operators
  transports the selected rank-four sector exactly;
- source-side idempotence and rank-four certificates transport automatically,
  so the carrier capstone does not duplicate them at the target;
- the coordinate polynomial of the identity on four scalar coordinates is an
  explicit nonvacuous idempotent rank-four certificate.

The proof uses Mathlib's conjugation equivalence of endomorphism algebras and
polynomial evaluation under algebra homomorphisms. No eigenbasis is selected.

## Scope boundary

The theorem does not derive:

- a graph-native carrier operator;
- a polynomial corresponding to a physical threshold;
- idempotence of that polynomial on the operator spectrum;
- a fourth/fifth-mode gap or rank four;
- Lorentzian inertia of the corrected pairing;
- overlap compatibility or refinement convergence.

It closes only the naturality link: once those certificates are supplied,
order isomorphisms transport the whole selected sector exactly.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean`
  passes cleanly;
- the exact strengthened source passes direct Lean and
  `lake build PhysicsSM.Draft.NullEdge.EquivariantPolynomialProbeProjector`
  passes (`8038` jobs);
- Lean MCP reports a clean source scan and only `propext`,
  `Classical.choice`, and `Quot.sound` for the strengthened carrier capstone;
- the module carries build-enforced guards for the general intertwining
  theorem, carrier capstone, and nonvacuity witness;
- the first targeted build attempt hit the shell timeout while the shared Lean
  process pool was busy and produced no diagnostic; the longer exact rerun
  completed successfully.

## Next review

The core result was independently approved without revision in
`AutonomousLab/reviews/CLAUDE_REVIEW_POLYNOMIAL_PROBE_PROJECTOR_2026-07-16.md`.
The small post-review strengthening derives target idempotence and range rank
from source certificates under the exact intertwining equivalence. Claude's
addendum audit (message `msg-20260716-144157-ba292548`) independently approved
both derivations and confirmed that no physical hypothesis was silently
discharged.
