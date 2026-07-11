# Fable phase-defect spectrum Aristotle result

## Metadata

- Project: `497535a1-9dfd-4c13-a8a2-fa726ed78849`
- Aristotle run: `59ac08e6-1d32-4c50-a4b6-6076bee43236`
- Returned target: `RequestProject/Main.lean`
- Live module: `PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean`
- Status: integrated

## Result

The returned Mathlib-only file proves the exact symbolic finite `4x4`
phase-defect polynomial, a concrete counterexample showing that equal moduli
are load-bearing, the eigenvalue polynomial consequence, trace balance, the
exact nonnegative-coupling zero-gap locus, and common-phase unitary conjugacy.

The target was downloaded after the project became idle, scanned for proof
holes and escape hatches, and compiled directly under the repository's pinned
toolchain before integration. The live theorem is scoped to the displayed
two-site free Hamiltonian. It does not establish topological protection,
spatial localization, perturbation stability, or an interacting defect.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean`
- `lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard`
- `python Scripts/publication/verify_null_edge_paper_a.py --output-dir artifact/paper-a-verification-final-20260711`
