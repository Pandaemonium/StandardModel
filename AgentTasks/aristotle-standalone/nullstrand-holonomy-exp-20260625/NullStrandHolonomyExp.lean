import Mathlib

/-!
# NullStrand holonomy exponential proof targets

Focused standalone version of the live HOL-002/HOL-003 handoffs.
-/

noncomputable section

namespace NullStrandHolonomyExp

open Matrix Complex

/-- Ordered product of finite matrix factors, in list order. -/
def internalHolonomy {d : Type*} [Fintype d] [DecidableEq d]
    (segments : List (Matrix d d Complex)) : Matrix d d Complex :=
  segments.prod

/-- Single holonomy step from a real duration and Hermitian generator. -/
def internalSegment {d : Type*} [Fintype d] [DecidableEq d] (ds : Real)
    (M : Matrix d d Complex) : Matrix d d Complex :=
  NormedSpace.exp (-(Complex.I : Complex) • (Complex.ofReal ds • M))

/-- HOL-002. Exponentiating `-I * ds * M` gives a unitary matrix when `M` is Hermitian. -/
theorem internalSegment_unitary_of_hermitian {d : Type*} [Fintype d] [DecidableEq d]
    (ds : Real) (M : Matrix d d Complex) (hHermitian : M.IsHermitian) :
    internalSegment ds M ∈ Matrix.unitaryGroup d Complex := by
  apply Matrix.mem_unitaryGroup_iff.mpr
  -- The exponential of a skew-adjoint matrix is unitary.
  have hstar : ∀ A : Matrix d d ℂ, star (NormedSpace.exp A) = NormedSpace.exp (star A) := by
    intro A
    simp [Matrix.star_eq_conjTranspose, Matrix.exp_conjTranspose]
  have h_exp_unitary : ∀ A : Matrix d d ℂ,
      star A = -A → NormedSpace.exp A * star (NormedSpace.exp A) = 1 := by
    intro A hA
    rw [hstar, hA, ← Matrix.exp_add_of_commute] <;> norm_num [mul_comm]
  refine h_exp_unitary _ ?_
  simp [hHermitian.eq, Matrix.star_eq_conjTranspose]

/-- Matrix exponential is natural under unitary conjugation for this holonomy generator. -/
theorem internalSegment_conj {d : Type*} [Fintype d] [DecidableEq d]
    (U : Matrix.unitaryGroup d Complex) (ds : Real) (M : Matrix d d Complex) :
    internalSegment ds ((U : Matrix d d Complex) * M * ((U : Matrix d d Complex))⁻¹) =
      (U : Matrix d d Complex) * internalSegment ds M * ((U : Matrix d d Complex))⁻¹ := by
  unfold internalSegment
  have h_unit : IsUnit (U : Matrix d d Complex) :=
    IsUnit.of_mul_eq_one _ U.2.2
  have h_exp : ∀ A : Matrix d d ℂ,
      NormedSpace.exp (U.val * A * U.val⁻¹)
        = U.val * NormedSpace.exp A * U.val⁻¹ := by
    intro A
    convert Matrix.exp_units_conj h_unit.unit A using 1
    · simp [Matrix.inv_def]
    · simp
  convert h_exp _ using 2
  simp [mul_assoc]

/-- HOL-003. Path-level gauge covariance for finite internal holonomy. -/
theorem internalHolonomy_gaugeCovariant_path {N : Nat} {d : Type*}
    [Fintype d] [DecidableEq d] (U : Matrix.unitaryGroup d Complex)
    (ds : Fin (N + 1) -> Real) (M : Fin (N + 1) -> Matrix d d Complex) :
    internalHolonomy
        (List.ofFn fun i : Fin (N + 1) =>
          internalSegment (ds i) ((U : Matrix d d Complex) * M i * ((U : Matrix d d Complex))⁻¹)) =
      (U : Matrix d d Complex) *
        internalHolonomy (List.ofFn fun i : Fin (N + 1) => internalSegment (ds i) (M i)) *
          ((U : Matrix d d Complex))⁻¹ := by
  induction N with
  | zero =>
    simp only [List.ofFn_succ, List.ofFn_zero]
    simp [internalHolonomy, internalSegment_conj]
  | succ k ih =>
    have hUU := U.2.2
    have hcong :=
      congr_arg (fun x => internalSegment (ds 0) (U.val * M 0 * U.val⁻¹) * x)
        (ih (fun i => ds i.succ) (fun i => M i.succ))
    convert hcong using 1
    · simp only [internalHolonomy, List.ofFn_succ, List.prod_cons]
    · unfold internalHolonomy
      simp only [← mul_assoc, internalSegment_conj]
      simp [mul_assoc, Matrix.inv_eq_right_inv hUU]

end NullStrandHolonomyExp
