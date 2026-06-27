import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency

/-!
# Operator-level electroweak identity

This module lifts the pointwise Gell-Mann–Nishijima relation
`Q = T₃ + Y / 2` from the table theorem `ElectroweakBridge.gellMannNishijima_all`
to an equality of diagonal linear operators on the finite state-function space
`JbarWavefunction := JbarState → ℂ`.

## Claim boundary

This theorem package proves a diagonal operator equality for the explicit
finite Jbar electroweak table. It does not derive weak isospin from the
octonionic ladder algebra.

## Main declarations

- `JbarWavefunction` — the finite state-function space `JbarState → ℂ`.
- `diagonalEnd` — diagonal continuous linear operator from a function `JbarState → ℂ`.
- `physicalQEnd`, `targetT3End`, `targetYEnd` — the charge operators.
- `physicalQEnd_eq_targetT3End_add_half_targetYEnd` — the main operator identity.
- `physicalQEnd_apply_eq_gmn` — the pointwise operator form.
-/

namespace PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity

open Complex ElectroweakBridge

/-- The finite state-function space for the Jbar sector. -/
abbrev JbarWavefunction := ElectroweakBridge.JbarState → ℂ

/-- A diagonal linear map on `JbarWavefunction` that multiplies each
    component by a fixed complex value. -/
noncomputable def diagonalLM
    (f : ElectroweakBridge.JbarState → ℂ) :
    JbarWavefunction →ₗ[ℂ] JbarWavefunction where
  toFun := fun psi s => f s * psi s
  map_add' := fun x y => by ext s; simp [mul_add]
  map_smul' := fun c x => by
    ext s; simp [Pi.smul_apply, smul_eq_mul, mul_left_comm]

/-- A diagonal continuous linear operator on `JbarWavefunction`. Since the
    space is finite-dimensional, continuity is automatic. -/
noncomputable def diagonalEnd
    (f : ElectroweakBridge.JbarState → ℂ) :
    JbarWavefunction →L[ℂ] JbarWavefunction where
  toLinearMap := diagonalLM f
  cont := (diagonalLM f).continuous_of_finiteDimensional

@[simp] theorem diagonalEnd_apply
    (f : ElectroweakBridge.JbarState → ℂ)
    (psi : JbarWavefunction) (s : ElectroweakBridge.JbarState) :
    diagonalEnd f psi s = f s * psi s :=
  rfl

/-- The physical electric charge operator. -/
noncomputable def physicalQEnd :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.physicalQ s : ℂ))

/-- The target weak-isospin third-component operator. -/
noncomputable def targetT3End :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.targetT3 s : ℂ))

/-- The target hypercharge operator. -/
noncomputable def targetYEnd :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.targetY s : ℂ))

@[simp] theorem physicalQEnd_apply
    (psi : JbarWavefunction)
    (s : ElectroweakBridge.JbarState) :
    physicalQEnd psi s =
      (ElectroweakBridge.physicalQ s : ℂ) * psi s :=
  rfl

@[simp] theorem targetT3End_apply
    (psi : JbarWavefunction)
    (s : ElectroweakBridge.JbarState) :
    targetT3End psi s =
      (ElectroweakBridge.targetT3 s : ℂ) * psi s :=
  rfl

@[simp] theorem targetYEnd_apply
    (psi : JbarWavefunction)
    (s : ElectroweakBridge.JbarState) :
    targetYEnd psi s =
      (ElectroweakBridge.targetY s : ℂ) * psi s :=
  rfl

/-- **Gell-Mann–Nishijima operator identity**: `Q = T₃ + Y / 2` as an
    equality of diagonal continuous linear operators on
    `JbarWavefunction`. -/
theorem physicalQEnd_eq_targetT3End_add_half_targetYEnd :
    physicalQEnd =
      targetT3End + (1 / 2 : ℂ) • targetYEnd := by
  ext1 psi
  exact funext fun i => by
    fin_cases i <;>
      simp +decide [ElectroweakBridge.physicalQ,
        ElectroweakBridge.targetT3,
        ElectroweakBridge.targetY] <;>
      ring!

/-- The pointwise operator form of the Gell-Mann–Nishijima identity. -/
theorem physicalQEnd_apply_eq_gmn
    (psi : JbarWavefunction)
    (s : ElectroweakBridge.JbarState) :
    physicalQEnd psi s =
      (targetT3End psi s) +
        (1 / 2 : ℂ) * (targetYEnd psi s) := by
  rw [physicalQEnd_eq_targetT3End_add_half_targetYEnd]
  simp [ContinuousLinearMap.add_apply,
    ContinuousLinearMap.smul_apply, smul_eq_mul]

end PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
