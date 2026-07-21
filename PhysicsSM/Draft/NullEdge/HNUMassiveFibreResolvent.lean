import PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator

/-!
# Explicit fibre resolvents for the massive HNU Dirac symbol

The live massive HNU Hamiltonian satisfies the scalar Dirac square
`H(q)^2 = (|q|^2 + |z|^2) I`. This module converts that identity into explicit
two-sided inverses for `H(q) - i I` and `H(q) + i I` at every momentum. These
finite-fibre certificates are the algebraic input for the maximal graph-domain
self-adjointness proof; they are not themselves an unbounded-operator theorem.

Provenance: clean-room composition of `Pluecker3Plus1ComplexMass.H4_sq` and
`HNUMassiveCompactSupportL2Generator.massiveGenerator_eq_H4`, informed by the
standard resolvent proof of self-adjointness for Dirac multiplication
operators. Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent

open HNUMassiveContinuumReduction
open HNUMassiveCompactSupportL2Generator
open Pluecker3Plus1ComplexMass

abbrev Momentum3 := Fin 3 -> Real
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Fibre4 := EuclideanSpace Complex (Fin 4)

/-- The nonnegative scalar in the massive Dirac square. -/
def massShellSq (z : Complex) (q : Momentum3) : Real :=
  q 0 ^ 2 + q 1 ^ 2 + q 2 ^ 2 + Complex.normSq z

/-- The resolvent denominator at spectral parameter `i`. -/
def resolventDenom (z : Complex) (q : Momentum3) : Real :=
  massShellSq z q + 1

/-- The live massive HNU Hamiltonian has the exact scalar relativistic square. -/
theorem massiveGenerator_sq (z : Complex) (q : Momentum3) :
    massiveGenerator z q * massiveGenerator z q =
      (massShellSq z q : Complex) • (1 : Mat4) := by
  rw [massiveGenerator_eq_H4]
  simpa [massShellSq] using H4_sq (q 0) (q 1) (q 2) z

/-- The explicit resolvent denominator is strictly positive. -/
theorem resolventDenom_pos (z : Complex) (q : Momentum3) :
    0 < resolventDenom z q := by
  unfold resolventDenom massShellSq
  have hz : 0 <= Complex.normSq z := Complex.normSq_nonneg z
  positivity

/-- The complex coercion of the resolvent denominator is nonzero. -/
theorem resolventDenom_ne_zero_complex (z : Complex) (q : Momentum3) :
    (resolventDenom z q : Complex) ≠ 0 :=
  Complex.ofReal_ne_zero.mpr (ne_of_gt (resolventDenom_pos z q))

/-- The two spectral shifts multiply to the positive scalar denominator. -/
theorem shifted_minus_mul_plus (z : Complex) (q : Momentum3) :
    (massiveGenerator z q - (I : Complex) • (1 : Mat4)) *
        (massiveGenerator z q + (I : Complex) • (1 : Mat4)) =
      (resolventDenom z q : Complex) • (1 : Mat4) := by
  rw [sub_mul, mul_add, massiveGenerator_sq]
  simp only [Matrix.mul_one, Matrix.one_mul, Matrix.smul_mul,
    Matrix.mul_smul]
  ext i j
  simp [resolventDenom, massShellSq, Complex.ext_iff] <;> ring
  all_goals exact ⟨trivial, trivial⟩

/-- The reverse product gives the same scalar denominator. -/
theorem shifted_plus_mul_minus (z : Complex) (q : Momentum3) :
    (massiveGenerator z q + (I : Complex) • (1 : Mat4)) *
        (massiveGenerator z q - (I : Complex) • (1 : Mat4)) =
      (resolventDenom z q : Complex) • (1 : Mat4) := by
  rw [add_mul, mul_sub, massiveGenerator_sq]
  simp only [Matrix.mul_one, Matrix.one_mul, Matrix.smul_mul,
    Matrix.mul_smul]
  ext i j
  simp [resolventDenom, massShellSq, Complex.ext_iff] <;> ring
  all_goals exact ⟨trivial, trivial⟩

/-- The negative imaginary shift has the exact positive Gram square. This is
the finite-fibre coercivity identity behind the uniform resolvent estimate. -/
theorem shifted_minus_star_mul_self (z : Complex) (q : Momentum3) :
    (massiveGenerator z q - (I : Complex) • (1 : Mat4))ᴴ *
        (massiveGenerator z q - (I : Complex) • (1 : Mat4)) =
      (resolventDenom z q : Complex) • (1 : Mat4) := by
  rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul,
    (massiveGenerator_isHermitian z q).eq]
  simpa [Complex.conj_I] using shifted_plus_mul_minus z q

/-- The positive imaginary shift has the same exact positive Gram square. -/
theorem shifted_plus_star_mul_self (z : Complex) (q : Momentum3) :
    (massiveGenerator z q + (I : Complex) • (1 : Mat4))ᴴ *
        (massiveGenerator z q + (I : Complex) • (1 : Mat4)) =
      (resolventDenom z q : Complex) • (1 : Mat4) := by
  rw [Matrix.conjTranspose_add, Matrix.conjTranspose_smul,
    (massiveGenerator_isHermitian z q).eq]
  simpa [Complex.conj_I] using shifted_minus_mul_plus z q

/-- The negative imaginary shift has exact fibrewise coercivity in the
Euclidean norm. -/
theorem shifted_minus_norm_sq (z : Complex) (q : Momentum3) (v : Fibre4) :
    ‖(Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
        (massiveGenerator z q - (I : Complex) • (1 : Mat4)) v‖ ^ 2 =
      resolventDenom z q * ‖v‖ ^ 2 := by
  let A : Fibre4 →L[Complex] Fibre4 :=
    (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
    (massiveGenerator z q - (I : Complex) • (1 : Mat4))
  have hA : ContinuousLinearMap.adjoint A ∘L A =
      (resolventDenom z q : Complex) •
        ContinuousLinearMap.id Complex Fibre4 := by
    change
      star ((Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q - (I : Complex) • (1 : Mat4))) ∘L
        (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q - (I : Complex) • (1 : Mat4)) =
        (resolventDenom z q : Complex) •
          ContinuousLinearMap.id Complex Fibre4
    rw [← map_star]
    rw [← ContinuousLinearMap.mul_def, ← map_mul]
    rw [Matrix.star_eq_conjTranspose]
    rw [shifted_minus_star_mul_self]
    simpa only [map_smul, map_one, ContinuousLinearMap.one_def]
  change ‖A v‖ ^ 2 = resolventDenom z q * ‖v‖ ^ 2
  rw [A.apply_norm_sq_eq_inner_adjoint_left, hA]
  simp only [ContinuousLinearMap.smul_apply, ContinuousLinearMap.id_apply]
  rw [inner_smul_left]
  rw [inner_self_eq_norm_sq_to_K]
  norm_num [Complex.mul_re]
  left
  rw [← Complex.ofReal_pow]
  exact Complex.ofReal_re _

/-- The positive imaginary shift has the same exact fibrewise coercivity. -/
theorem shifted_plus_norm_sq (z : Complex) (q : Momentum3) (v : Fibre4) :
    ‖(Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
        (massiveGenerator z q + (I : Complex) • (1 : Mat4)) v‖ ^ 2 =
      resolventDenom z q * ‖v‖ ^ 2 := by
  let A : Fibre4 →L[Complex] Fibre4 :=
    (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
      (massiveGenerator z q + (I : Complex) • (1 : Mat4))
  have hA : ContinuousLinearMap.adjoint A ∘L A =
      (resolventDenom z q : Complex) •
        ContinuousLinearMap.id Complex Fibre4 := by
    change
      star ((Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q + (I : Complex) • (1 : Mat4))) ∘L
        (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q + (I : Complex) • (1 : Mat4)) =
        (resolventDenom z q : Complex) •
          ContinuousLinearMap.id Complex Fibre4
    rw [← map_star]
    rw [← ContinuousLinearMap.mul_def, ← map_mul]
    rw [Matrix.star_eq_conjTranspose]
    rw [shifted_plus_star_mul_self]
    simpa only [map_smul, map_one, ContinuousLinearMap.one_def]
  change ‖A v‖ ^ 2 = resolventDenom z q * ‖v‖ ^ 2
  rw [A.apply_norm_sq_eq_inner_adjoint_left, hA]
  simp only [ContinuousLinearMap.smul_apply, ContinuousLinearMap.id_apply]
  rw [inner_smul_left]
  rw [inner_self_eq_norm_sq_to_K]
  norm_num [Complex.mul_re]
  left
  rw [← Complex.ofReal_pow]
  exact Complex.ofReal_re _

/-- Explicit inverse candidate for `H(q) - i I`. -/
def minusShiftInverse (z : Complex) (q : Momentum3) : Mat4 :=
  (((resolventDenom z q : Real) : Complex)⁻¹) •
    (massiveGenerator z q + (I : Complex) • (1 : Mat4))

/-- Explicit inverse candidate for `H(q) + i I`. -/
def plusShiftInverse (z : Complex) (q : Momentum3) : Mat4 :=
  (((resolventDenom z q : Real) : Complex)⁻¹) •
    (massiveGenerator z q - (I : Complex) • (1 : Mat4))

/-- The candidate is a left inverse for the negative spectral shift. -/
theorem shifted_minus_mul_inverse (z : Complex) (q : Momentum3) :
    (massiveGenerator z q - (I : Complex) • (1 : Mat4)) *
        minusShiftInverse z q = 1 := by
  rw [minusShiftInverse, Matrix.mul_smul, shifted_minus_mul_plus]
  ext i j
  simp [resolventDenom_ne_zero_complex z q]

/-- The candidate is also a right inverse for the negative spectral shift. -/
theorem inverse_mul_shifted_minus (z : Complex) (q : Momentum3) :
    minusShiftInverse z q *
        (massiveGenerator z q - (I : Complex) • (1 : Mat4)) = 1 := by
  rw [minusShiftInverse, Matrix.smul_mul, shifted_plus_mul_minus]
  ext i j
  simp [resolventDenom_ne_zero_complex z q]

/-- The candidate is a left inverse for the positive spectral shift. -/
theorem shifted_plus_mul_inverse (z : Complex) (q : Momentum3) :
    (massiveGenerator z q + (I : Complex) • (1 : Mat4)) *
        plusShiftInverse z q = 1 := by
  rw [plusShiftInverse, Matrix.mul_smul, shifted_plus_mul_minus]
  ext i j
  simp [resolventDenom_ne_zero_complex z q]

/-- The candidate is also a right inverse for the positive spectral shift. -/
theorem inverse_mul_shifted_plus (z : Complex) (q : Momentum3) :
    plusShiftInverse z q *
        (massiveGenerator z q + (I : Complex) • (1 : Mat4)) = 1 := by
  rw [plusShiftInverse, Matrix.smul_mul, shifted_minus_mul_plus]
  ext i j
  simp [resolventDenom_ne_zero_complex z q]

/-- The resolvent at `+i` is a pointwise contraction, uniformly in momentum. -/
theorem minusShiftInverse_norm_le (z : Complex) (q : Momentum3) (v : Fibre4) :
    ‖(Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
        (minusShiftInverse z q) v‖ ≤ ‖v‖ := by
  let Rv : Fibre4 :=
    (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
      (minusShiftInverse z q) v
  have hresolve :
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q - (I : Complex) • (1 : Mat4)) Rv = v := by
    change
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q - (I : Complex) • (1 : Mat4))
        ((Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (minusShiftInverse z q) v) = v
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_minus_mul_inverse]
    simp
  have hcoercive := shifted_minus_norm_sq z q Rv
  rw [hresolve] at hcoercive
  have hdenom : 1 ≤ resolventDenom z q := by
    unfold resolventDenom massShellSq
    have hz : 0 ≤ Complex.normSq z := Complex.normSq_nonneg z
    nlinarith [sq_nonneg (q 0), sq_nonneg (q 1), sq_nonneg (q 2)]
  have hsq : ‖Rv‖ ^ 2 ≤ ‖v‖ ^ 2 := by
    nlinarith [sq_nonneg ‖Rv‖]
  change ‖Rv‖ ≤ ‖v‖
  exact (sq_le_sq₀ (norm_nonneg Rv) (norm_nonneg v)).mp hsq

/-- The resolvent at `-i` is also a pointwise contraction, uniformly in
momentum. -/
theorem plusShiftInverse_norm_le (z : Complex) (q : Momentum3) (v : Fibre4) :
    ‖(Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
        (plusShiftInverse z q) v‖ ≤ ‖v‖ := by
  let Rv : Fibre4 :=
    (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
      (plusShiftInverse z q) v
  have hresolve :
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q + (I : Complex) • (1 : Mat4)) Rv = v := by
    change
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (massiveGenerator z q + (I : Complex) • (1 : Mat4))
        ((Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex))
          (plusShiftInverse z q) v) = v
    rw [← ContinuousLinearMap.mul_apply, ← map_mul,
      shifted_plus_mul_inverse]
    simp
  have hcoercive := shifted_plus_norm_sq z q Rv
  rw [hresolve] at hcoercive
  have hdenom : 1 ≤ resolventDenom z q := by
    unfold resolventDenom massShellSq
    have hz : 0 ≤ Complex.normSq z := Complex.normSq_nonneg z
    nlinarith [sq_nonneg (q 0), sq_nonneg (q 1), sq_nonneg (q 2)]
  have hsq : ‖Rv‖ ^ 2 ≤ ‖v‖ ^ 2 := by
    nlinarith [sq_nonneg ‖Rv‖]
  change ‖Rv‖ ≤ ‖v‖
  exact (sq_le_sq₀ (norm_nonneg Rv) (norm_nonneg v)).mp hsq

/-- Both imaginary spectral shifts are invertible, with the displayed exact
inverses. -/
theorem imaginary_shifts_are_units (z : Complex) (q : Momentum3) :
    IsUnit (massiveGenerator z q - (I : Complex) • (1 : Mat4)) ∧
      IsUnit (massiveGenerator z q + (I : Complex) • (1 : Mat4)) := by
  constructor
  · exact isUnit_iff_exists_inv.mpr
      ⟨minusShiftInverse z q, shifted_minus_mul_inverse z q⟩
  · exact isUnit_iff_exists_inv.mpr
      ⟨plusShiftInverse z q, shifted_plus_mul_inverse z q⟩

end PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.massiveGenerator_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.massiveGenerator_sq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.shifted_minus_star_mul_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.shifted_minus_star_mul_self

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.minusShiftInverse_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.minusShiftInverse_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.plusShiftInverse_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.plusShiftInverse_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.imaginary_shifts_are_units' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent.imaginary_shifts_are_units
