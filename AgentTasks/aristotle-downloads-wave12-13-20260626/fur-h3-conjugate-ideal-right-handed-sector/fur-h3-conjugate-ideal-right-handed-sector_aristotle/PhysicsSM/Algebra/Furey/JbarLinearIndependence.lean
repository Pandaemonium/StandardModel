import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.OperatorRepresentations

/-!
# Linear independence of the Jbar basis states

This module proves that eight corrected `Jbar` basis vectors are linearly
independent over `ℂ`, constructs a basis of their span, and packages
the results for downstream use.

## Bug in the original `vbar` definitions

The original definitions in `MinimalLeftIdeal.lean` define:
```
  vbar1 = alpha1 * omega_bar
  vbar2 = alpha2 * omega_bar
  vbar3 = alpha3 * omega_bar
  ...
```

However, `alpha_k` are **annihilation** operators and `omega_bar` is the
**empty vacuum** (all modes unoccupied). Annihilating the empty vacuum
gives zero: `alpha_k * omega_bar = 0` for all `k`. This makes `vbar1`
through `vbar6` and `nu_bar` all equal to zero, and the original
`JbarBasisState` cannot be linearly independent.

The **correct** Jbar states should use the **creation** operators
`alpha_k_dag` on `omega_bar`, mirroring how the J states use annihilation
operators `alpha_k` on `omega` (the full vacuum):
```
  vbar1' = alpha1_dag * omega_bar
  vbar2' = alpha2_dag * omega_bar
  vbar3' = alpha3_dag * omega_bar
  ...
```

This module defines the corrected states and proves their linear
independence.

## Corrected Q_op eigenvalue summary

| State              | Q_op eigenvalue | Candidate particle     |
|--------------------|----------------|------------------------|
| `omega_bar`        | 0              | neutrino νₑ            |
| `vbar1'`-`vbar3'`  | -1/3          | down quarks d          |
| `vbar4'`-`vbar6'`  | -2/3          | up quarks u            |
| `nu_bar'`          | -1            | electron e^-           |
-/

namespace PhysicsSM.Algebra.Furey.JbarLinearIndependence

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Algebra.Furey.AnomalyBridge

-- ## Bug demonstration: original vbar states are all zero

/-- The original `vbar1 = alpha1 * omega_bar` is zero because
`alpha1` (annihilation) kills the empty vacuum `omega_bar`. -/
theorem original_vbar1_eq_zero : vbar1 = 0 := by
  unfold vbar1 alpha1 omega_bar; ext <;> simp

/-- The original `vbar2 = alpha2 * omega_bar` is zero. -/
theorem original_vbar2_eq_zero : vbar2 = 0 := by
  unfold vbar2 alpha2 omega_bar; ext <;> simp <;> ring

/-- The original `vbar3 = alpha3 * omega_bar` is zero. -/
theorem original_vbar3_eq_zero : vbar3 = 0 := by
  unfold vbar3 alpha3 omega_bar; ext <;> simp <;> ring

/-- The original `nu_bar = alpha1 * (alpha2 * (alpha3 * omega_bar))`
is zero (since `alpha3 * omega_bar = 0`). -/
theorem original_nu_bar_eq_zero : nu_bar = 0 := by
  unfold nu_bar alpha1 alpha2 alpha3 omega_bar
  ext <;> simp <;> ring

/-- The original `JbarBasisState` cannot be linearly independent
because most of its values are zero. -/
theorem original_JbarBasisState_not_linearIndependent :
    ¬ LinearIndependent Complex JbarBasisState := by
  intro h
  have := h.ne_zero (1 : Fin 8)
  simp [JbarBasisState, original_vbar1_eq_zero] at this

-- ## Corrected Jbar basis states using creation operators

/-- First one-particle state: creation operator `alpha1_dag`
on the empty vacuum. -/
noncomputable def vbar1' : ComplexOctonion :=
  alpha1_dag * omega_bar

/-- Second one-particle state: creation operator `alpha2_dag`
on the empty vacuum. -/
noncomputable def vbar2' : ComplexOctonion :=
  alpha2_dag * omega_bar

/-- Third one-particle state: creation operator `alpha3_dag`
on the empty vacuum. -/
noncomputable def vbar3' : ComplexOctonion :=
  alpha3_dag * omega_bar

/-- First two-particle state:
`alpha1_dag · (alpha2_dag · omega_bar)`. -/
noncomputable def vbar4' : ComplexOctonion :=
  alpha1_dag * (alpha2_dag * omega_bar)

/-- Second two-particle state:
`alpha1_dag · (alpha3_dag · omega_bar)`. -/
noncomputable def vbar5' : ComplexOctonion :=
  alpha1_dag * (alpha3_dag * omega_bar)

/-- Third two-particle state:
`alpha2_dag · (alpha3_dag · omega_bar)`. -/
noncomputable def vbar6' : ComplexOctonion :=
  alpha2_dag * (alpha3_dag * omega_bar)

/-- Three-particle state: all three creation operators on the
empty vacuum. -/
noncomputable def nu_bar' : ComplexOctonion :=
  alpha1_dag * (alpha2_dag * (alpha3_dag * omega_bar))

/-- The corrected eight Jbar basis states as a function
`Fin 8 → ComplexOctonion`. -/
noncomputable def JbarBasisState' : Fin 8 → ComplexOctonion
  | 0 => omega_bar
  | 1 => vbar1'
  | 2 => vbar2'
  | 3 => vbar3'
  | 4 => vbar4'
  | 5 => vbar5'
  | 6 => vbar6'
  | 7 => nu_bar'

/-- The corrected complementary ideal span over ℂ. -/
noncomputable def Jbar' : Submodule Complex ComplexOctonion :=
  Submodule.span Complex (Set.range JbarBasisState')

set_option maxHeartbeats 1600000 in
-- Large heartbeat limit needed for the 8-dimensional coordinate
-- computation involving 16 real components per octonion.
set_option maxRecDepth 1024 in
/-- The corrected eight Jbar basis states are linearly independent
over `ℂ`. -/
theorem JbarBasisState'_linearIndependent :
    LinearIndependent Complex JbarBasisState' := by
  rw [Fintype.linearIndependent_iff]
  intro g hg
  simp_all +decide [Fin.sum_univ_succ, JbarBasisState']
  simp_all +decide [Complex.ext_iff, ComplexOctonion.ext_iff,
    omega_bar, vbar1', vbar2', vbar3', vbar4', vbar5', vbar6',
    nu_bar', alpha1_dag, alpha2_dag, alpha3_dag]
  simp_all +decide [Octonion.ext_iff, Fin.forall_fin_succ]
  grind

/-- The basis of the corrected `Jbar'` span. -/
noncomputable def Jbar_basis :
    Module.Basis (Fin 8) Complex Jbar' :=
  Module.Basis.span JbarBasisState'_linearIndependent

/-- The finite rank of `Jbar'` is 8. -/
theorem Jbar_finrank_eq_eight :
    Module.finrank Complex Jbar' = 8 := by
  rw [Module.finrank_eq_card_basis Jbar_basis]
  simp

/-- Each corrected `JbarBasisState'` vector is nonzero. -/
theorem JbarBasisState'_ne_zero (i : Fin 8) :
    JbarBasisState' i ≠ 0 :=
  JbarBasisState'_linearIndependent.ne_zero i

/-- Package bundling the linear independence and basis results. -/
structure FureyJbarLinearIndependencePackage where
  linear_independent :
    LinearIndependent Complex JbarBasisState'
  basis :
    Module.Basis (Fin 8) Complex Jbar'

/-- The concrete package instance. -/
noncomputable def fureyJbarLinearIndependencePackage :
    FureyJbarLinearIndependencePackage :=
  { linear_independent := JbarBasisState'_linearIndependent
    basis := Jbar_basis }

end PhysicsSM.Algebra.Furey.JbarLinearIndependence
