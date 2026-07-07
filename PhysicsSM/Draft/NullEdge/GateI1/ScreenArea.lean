import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core

/-!
# Gate I1 / Q09: screen area as aperture polarization

This module records the first finite horizon-area theorem suggested by the Q09
Fable memo (`AgentTasks/fable_parallel/Q09_answer.md`): a cut has no invariant
single-edge area weight.  The invariant finite object is the polarization of the
same `2 x 2` determinant/aperture form used for Pluecker mass.

For a `2 x 2` Hermitian momentum block `P` and a screen block `N`, define

`screenArea P N = trace ((trace P * I - P) * N)`.

For a null screen `N = rankOne chi`, this is exactly the sum of squared spinor
wedges against the pierced spinors.  Thus area is relational: it is the mixed
term obtained by adding the screen direction to the pierced null bundle, not the
internal determinant of the bundle by itself.

Claim label: finite kinematic identity.  No entropy, continuum limit, horizon
thermodynamics, or Einstein-equation claim is asserted here.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateI1.ScreenArea

open BigOperators
open Matrix Complex
open scoped ComplexOrder

/-- The `2 x 2` trace-reversal/adjugate formula `adj(P) = trace(P) I - P`.

For `2 x 2` matrices this agrees with the classical adjugate.  We use this
definition because it is exactly the linear polarization object for the
determinant form. -/
def screenAdj (P : Herm2) : Herm2 :=
  Matrix.trace P • (1 : Herm2) - P

/-- The screen-relative area polarization `trace(adj(P) N)`. -/
def screenArea (P N : Herm2) : Complex :=
  Matrix.trace (screenAdj P * N)

/-- The trace-reversal operator is additive in the momentum block. -/
theorem screenAdj_add (P Q : Herm2) :
    screenAdj (P + Q) = screenAdj P + screenAdj Q := by
  ext i j
  simp [screenAdj, Matrix.trace_fin_two]
  ring

/-- The trace-reversal operator sends zero to zero. -/
theorem screenAdj_zero : screenAdj 0 = (0 : Herm2) := by
  ext i j
  simp [screenAdj]

/-- Screen area is additive in the pierced momentum block. -/
theorem screenArea_add_left (P Q N : Herm2) :
    screenArea (P + Q) N = screenArea P N + screenArea Q N := by
  simp [screenArea, screenAdj_add, Matrix.add_mul, Matrix.trace_add]

/-- Screen area vanishes on the zero pierced block. -/
theorem screenArea_zero_left (N : Herm2) :
    screenArea 0 N = 0 := by
  simp [screenArea, screenAdj_zero]

/-- Screen area distributes over a finite sum of pierced momentum blocks. -/
theorem screenArea_finset_sum_left {ι : Type*} (s : Finset ι)
    (P : ι -> Herm2) (N : Herm2) :
    screenArea (∑ i ∈ s, P i) N = ∑ i ∈ s, screenArea (P i) N := by
  classical
  refine Finset.induction_on s ?base ?step
  · simp [screenArea_zero_left]
  · intro a s ha ih
    rw [Finset.sum_insert ha, Finset.sum_insert ha, screenArea_add_left, ih]

/-- The determinant polarization identity for `2 x 2` blocks.

Equivalently, `screenArea P N` is the mixed term in
`det(P + N) = det P + screenArea P N + det N`. -/
theorem screenArea_eq_det_add_sub (P N : Herm2) :
    screenArea P N = (P + N).det - P.det - N.det := by
  simp +decide [screenArea, screenAdj, Matrix.trace_fin_two, Matrix.det_fin_two,
    Matrix.mul_apply]
  ring

/-- Polynomial form of the first-variation statement:
`det(P + tN) = det P + t * screenArea(P,N) + t^2 det N`. -/
theorem det_add_smul_eq_det_add_screenArea (P N : Herm2) (t : Complex) :
    (P + t • N).det = P.det + t * screenArea P N + t ^ 2 * N.det := by
  simp +decide [screenArea, screenAdj, Matrix.trace_fin_two, Matrix.det_fin_two,
    Matrix.mul_apply]
  ring

/-- A null screen evaluates area as one squared Pluecker wedge. -/
theorem screenArea_rankOne_rankOne_eq_wedge (psi chi : CSpinor) :
    screenArea (rankOne psi) (rankOne chi) =
      complexAbsSq (spinorWedge psi chi) := by
  simp +decide [screenArea, screenAdj, rankOne, spinorWedge, complexAbsSq,
    Matrix.trace_fin_two, Matrix.mul_apply, Matrix.vecMulVec]
  ring

/-- For a finite pierced bundle and a null screen, area is the sum of squared
wedges against the screen direction. -/
theorem screenArea_finBundleMomentum_rankOne_eq_sum_wedge {n : Nat}
    (psi : Fin n -> CSpinor) (chi : CSpinor) :
    screenArea (finBundleMomentum psi) (rankOne chi) =
      ∑ i : Fin n, complexAbsSq (spinorWedge (psi i) chi) := by
  rw [finBundleMomentum]
  calc
    screenArea (∑ i : Fin n, rankOne (psi i)) (rankOne chi)
        = ∑ i : Fin n, screenArea (rankOne (psi i)) (rankOne chi) := by
          simpa using
            screenArea_finset_sum_left (Finset.univ : Finset (Fin n))
              (fun i => rankOne (psi i)) (rankOne chi)
    _ = ∑ i : Fin n, complexAbsSq (spinorWedge (psi i) chi) := by
          exact Finset.sum_congr rfl fun i _ =>
            screenArea_rankOne_rankOne_eq_wedge (psi i) chi

/-- Real-valued form of the null-screen area formula. -/
theorem screenArea_finBundleMomentum_rankOne_eq_ofReal_sum_normSq {n : Nat}
    (psi : Fin n -> CSpinor) (chi : CSpinor) :
    screenArea (finBundleMomentum psi) (rankOne chi) =
      ((∑ i : Fin n, Complex.normSq (spinorWedge (psi i) chi)) : Complex) := by
  rw [screenArea_finBundleMomentum_rankOne_eq_sum_wedge]
  simp [complexAbsSq_eq_ofReal_normSq]

/-- The null-screen area of a finite pierced bundle has nonnegative real part. -/
theorem screenArea_finBundleMomentum_rankOne_re_nonneg {n : Nat}
    (psi : Fin n -> CSpinor) (chi : CSpinor) :
    0 <= (screenArea (finBundleMomentum psi) (rankOne chi)).re := by
  rw [screenArea_finBundleMomentum_rankOne_eq_ofReal_sum_normSq]
  simpa using
    (Finset.sum_nonneg fun i _ => Complex.normSq_nonneg (spinorWedge (psi i) chi))

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ScreenArea.screenArea_eq_det_add_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms screenArea_eq_det_add_sub

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ScreenArea.screenArea_finBundleMomentum_rankOne_eq_sum_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms screenArea_finBundleMomentum_rankOne_eq_sum_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ScreenArea.screenArea_finBundleMomentum_rankOne_re_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms screenArea_finBundleMomentum_rankOne_re_nonneg

end PhysicsSM.Draft.NullEdge.GateI1.ScreenArea

end
