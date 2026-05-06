# Task: Furey SM Symmetry - Operator Representations and Gauge Actions

**Agent**: Aristotle
**Status**: Complete - integrated
**Priority**: MOONSHOT
**Job IDs**: `0bcaa9b0-9a92-48e0-a3a3-30969e8742aa`, `38b00d57-1e6d-4ace-aefc-d4e147739b4a`
**Type**: definition / proof

## Goal

Formalize the minimal left ideal `J` as a `Submodule Complex ComplexOctonion`
and prove that the Furey operator-level symmetry maps act correctly on the
verified eight-state basis.

## Convention Note

The operator `(-1/3) * (N1 + N2 + N3)` is the electric-charge operator on the
current Furey basis:

- `omega`: `-1`
- `v1`, `v2`, `v3`: `-2/3`
- `v4`, `v5`, `v6`: `-1/3`
- `nu`: `0`

The integrated code names this operator `Q_op`. Hypercharge belongs to a
separate weak-isospin bridge using `Q = T3 + Y / 2`.

## Integrated File

`PhysicsSM/Algebra/Furey/OperatorRepresentations.lean`

## Result

The integrated code includes:

- `Lmul`, the left-multiplication linear map.
- `basisState`, `J`, and `J_basis`.
- Operator-level Cl(6) diagonal and off-diagonal relations on all `x in J`.
- The six off-diagonal color operators `T12_op`, `T21_op`, `T13_op`,
  `T31_op`, `T23_op`, and `T32_op`, with verified transition rules.
- Number operators `N1_op`, `N2_op`, `N3_op`, total number `Ntot_op`, and
  electric-charge operator `Q_op` with basis-state eigenvalue theorems.

## Support Fixes

- `PhysicsSM/Algebra/Octonion/ComplexOctonion.lean`: repaired the
  `sub_eq_add_neg` proof for the additive group instance.
- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`: added the mathlib import
  needed by the existing `basis_linear_independent` theorem and simplified
  three now-redundant charge proofs.

## Verification

Targeted checks passed on 2026-04-29:

- `lake env lean PhysicsSM\Algebra\Octonion\ComplexOctonion.lean`
- `lake env lean PhysicsSM\Algebra\Furey\MinimalLeftIdeal.lean`
- `lake env lean PhysicsSM\Algebra\Furey\OperatorRepresentations.lean`

Windows note: direct `.olean` compilation was used for dependencies where
needed, because full `lake build` can hit the known ProofWidgets path issue on
Windows.
