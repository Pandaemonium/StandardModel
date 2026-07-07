# Aristotle harvest: Q10 Spin/Weyl scalar-amplitude obstruction

Project:
- `05fdd744-2daa-447f-b865-2e81e615069a`
- `ne-solo-lane-q10-spinweyl-scalar-amplitude-classification-strategy-20260707`
- Task `f388eb1d-4c4e-4ac6-930f-a0b5d934523f`

## Result

Aristotle returned a kernel-checkable Lean payload for the Q10 same-chirality
scalar-amplitude lane.  The payload fills the missing bridge between the
existing finite weight-census obstruction and the invariant-bilinear-form
criterion.

Integrated file:
- `PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean`

Key declarations:
- `diagonal_charpoly_roots`
- `diagonal_charpoly_comp_neg_roots`
- `diag_spec_negSymmetric_of_invariant_form`
- `no_invariant_selfdual_form_of_spec_not_negSymmetric`
- `census_no_invariant_selfdual_form`
- `weyl_no_invariant_selfdual_form_d6`
- `weyl_no_invariant_selfdual_form_d10`

## Claim boundary

This is finite real/complex linear algebra over a diagonal Cartan avatar.  It
does not prove physical dimension selection, a continuum Lorentzian
classification, a genuine `Spin(1,d-1)` Weyl-module theorem, or Standard Model
representation content.

The remaining Q10 scalar-amplitude targets are:
- construct the positive `d = 4` invariant form in the same theorem shape,
- replace the finite diagonal Cartan avatar with the actual Spin/Weyl module,
- prove the representation-theoretic scalar-amplitude classification.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude`
- `lake build PhysicsSM.Draft.NullEdge.GateI1`
- Changed-file placeholder-token scan
- Duplicate future Aristotle-name scan for `GOAL_PROMPT_CODEX.md`
- `git diff --check`
- `pre-commit run --all-files`
