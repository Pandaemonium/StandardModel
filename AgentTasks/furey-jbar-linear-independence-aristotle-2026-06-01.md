# Aristotle task: Furey Jbar basis linear independence and basis package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Stretch
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `5ad34f44-41b7-4b97-bffe-a8423e42f6dd`
**Submission project**: `AgentTasks/aristotle-submit/paper-stretch-wave8-20260601-project`
**Output**: `AgentTasks/aristotle-output/furey-jbar-linear-independence-20260601`
**Integrated**: 2026-06-01
**Type**: Furey minimal-left-ideal dimension theorem

## Goal

Close one of the largest explicit open items in the Furey layer: prove that the
eight `JbarBasisState` vectors are linearly independent over `Complex`, build
the basis of the `Jbar` span, and package the result for the paper theorem
index.

This is intentionally ambitious but concrete. It should be a large finite
coordinate proof analogous to `basis_linear_independent` in
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`.

## Requested file

Create:

```text
PhysicsSM/Algebra/Furey/JbarLinearIndependence.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.OperatorRepresentations
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.JbarLinearIndependence
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState`
- `PhysicsSM.Algebra.Furey.AnomalyBridge.Jbar`
- `PhysicsSM.Algebra.Furey.MinimalLeftIdeal.basis_linear_independent`
- `PhysicsSM.Algebra.Furey.OperatorRepresentations.J_basis`
- component extensionality and simp lemmas for `ComplexOctonion`
- definitions `omega_bar`, `vbar1`, ..., `vbar6`, `nu_bar`

## Target declarations

Prove:

```lean
theorem JbarBasisState_linearIndependent :
    LinearIndependent Complex
      PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState := ...
```

Build the span basis:

```lean
noncomputable def Jbar_basis :
    Module.Basis (Fin 8) Complex
      PhysicsSM.Algebra.Furey.AnomalyBridge.Jbar := ...
```

If the finrank API is reachable, prove:

```lean
theorem Jbar_finrank_eq_eight :
    Module.finrank Complex
      PhysicsSM.Algebra.Furey.AnomalyBridge.Jbar = 8 := ...
```

If `Module.finrank` needs extra finite-dimensional instances that are awkward,
skip the finrank theorem and include only the basis.

Add useful wrappers:

```lean
theorem JbarBasisState_ne_zero (i : Fin 8) :
    PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState i != 0 := ...

structure FureyJbarLinearIndependencePackage where
  linear_independent :
    LinearIndependent Complex
      PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState
  basis :
    Module.Basis (Fin 8) Complex
      PhysicsSM.Algebra.Furey.AnomalyBridge.Jbar

noncomputable def fureyJbarLinearIndependencePackage :
    FureyJbarLinearIndependencePackage := ...
```

Use `≠` rather than `!=` in the actual Lean code if needed; the spelling above
is only to keep this Markdown ASCII-heavy.

## Proof guidance

The old J proof is:

```lean
theorem basis_linear_independent :
    LinearIndependent Complex (fun i : Fin 8 => ...) := by
  rw [Fintype.linearIndependent_iff]
  intro g hg
  simp +decide [Fin.sum_univ_succ] at hg
  simp_all +decide [Complex.ext_iff, ComplexOctonion.ext_iff]
  simp_all +decide [omega, v1, v2, v3, v4, v5, v6, nu, Octonion.ext_iff]
  norm_num [Fin.forall_fin_succ] at *
  grind
```

Try the same structure with:

```lean
omega_bar, vbar1, vbar2, vbar3, vbar4, vbar5, vbar6, nu_bar
```

If the direct automation times out, split out coordinate-witness lemmas.

## Claim boundary

This proves a vector-space fact about the explicit Jbar coordinate states. It
does not prove a physical right-handed-sector realization theorem, weak-isospin
derivation, or a full Standard Model representation theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change existing Furey state definitions.
- Do not edit `PhysicsSM.lean`.
- If the full target is too hard, create only a trusted partial theorem file
  with no placeholders, and add a separate draft handoff note under
  `PhysicsSM/Draft/` if needed.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Furey.JbarLinearIndependence
```
