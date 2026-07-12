import PhysicsSM.Spinor.SpinorTenfoldWeakQuotientSO10Generator

/-!
# Coordinates of the so(10) raising action on the weak quotient

`SpinorTenfoldWeakQuotientSO10Generator` constructs the infinitesimal complex
`so(10)` generator `e_3 wedge f_4`, proves that it preserves the fixed
normal-form annihilator and common color axis, and descends it to the derived
two-dimensional quotient. This module computes that descended action in the
proved coordinate equivalence with `Complex^2`.

In coordinates `(w_3, w_4)`, the action is exactly `(0, -w_3)`. The two basis
controls pin both the orientation and sign convention.

Claim boundary: this is the coordinate matrix of one infinitesimal complex
`so(10)` generator. It is not yet an `sl(2)` triple, compact `su(2)`, group
representation, stabilizer classification, or physical `SU(2)_L` action.

Provenance: proof architecture and code were returned by Aristotle project
`ec71b329-76eb-44dc-8428-097f3df81d23`, then independently compiled against
the live pinned repository. No compiled evaluator is used.

Status: trusted - proof complete under the pinned toolchain.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

/-- The coordinate transport of the quotient class represented by `x` is its
explicit pair of weak coordinates. -/
private theorem weakQuotientLinearEquivC2_mk (x : VacuumAnnihilator) :
    weakQuotientLinearEquivC2 (Submodule.Quotient.mk x) = weakCoordinates x := by
  simp only [weakQuotientLinearEquivC2, LinearEquiv.trans_apply,
    Submodule.quotEquivOfEq_mk, LinearMap.quotKerEquivOfSurjective_apply_mk]

/-- Pointwise evaluation of a descended operator in the explicit weak
coordinates. -/
private theorem weakCoordinateAction_apply
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum)
    (w : Fin 2 -> Complex) :
    weakCoordinateAction f hcolor w =
      weakCoordinates (f (weakCoordinatesInv w)) := by
  have hsymm : weakQuotientLinearEquivC2.symm w =
      Submodule.Quotient.mk (weakCoordinatesInv w) := by
    apply weakQuotientLinearEquivC2.injective
    rw [LinearEquiv.apply_symm_apply, weakQuotientLinearEquivC2_mk]
    funext j
    fin_cases j <;> simp [weakCoordinates, weakCoordinatesInv]
  simp only [weakCoordinateAction, LinearMap.comp_apply,
    LinearEquiv.coe_coe, hsymm, weakQuotientDescend_mk,
    weakQuotientLinearEquivC2_mk]

/-- In coordinates `(w_3, w_4)`, the generator `e_3 wedge f_4` sends
`(w_3, w_4)` to `(0, -w_3)`. -/
theorem weakCoordinateAction_raising_formula (w : Fin 2 -> Complex) :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color w =
      fun j => if j = (0 : Fin 2) then 0 else -w 0 := by
  rw [weakCoordinateAction_apply]
  funext j
  fin_cases j <;>
    simp [weakCoordinates, weakRaisingGenerator_coe, soAd, B10,
      weakCoordinatesInv, eMode, fMode, Fin.sum_univ_five, Pi.single_apply]

/-- The first coordinate basis vector is moved to minus the second. -/
theorem weakCoordinateAction_raising_basis0 :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color (Pi.single 0 1) =
      -(Pi.single 1 1) := by
  rw [weakCoordinateAction_raising_formula]
  funext j
  fin_cases j <;> simp

/-- The second coordinate basis vector is killed. -/
theorem weakCoordinateAction_raising_basis1 :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color (Pi.single 1 1) = 0 := by
  rw [weakCoordinateAction_raising_formula]
  funext j
  fin_cases j <;> simp

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakCoordinateAction_raising_formula' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakCoordinateAction_raising_formula

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakCoordinateAction_raising_basis0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakCoordinateAction_raising_basis0

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakCoordinateAction_raising_basis1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakCoordinateAction_raising_basis1

end PhysicsSM.Spinor.SpinorTenfold
