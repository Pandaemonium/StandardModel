import Mathlib

/-!
# Rank-one finite reflection kernel from exponential decay

This file isolates the finite reflected Hankel-kernel step needed by the
null-edge origin-of-mass program.  For a decay factor `lambda`, the reflected
time kernel is `K i j = lambda^(i+j)`.  Its quadratic form is one square and is
therefore positive semidefinite.  An explicit two-time null vector records that
the one-mode kernel is rank one, not strictly positive.

The Pluecker specialization uses `lambda = exp (-a * norm z)`, where `z` is the
complex null-spinor wedge.  This is a finite two-point reflection-kernel result;
it is not reflection positivity of an interacting field algebra, an
infinite-volume reconstruction, or an LSZ pole theorem.

Provenance: proof returned by Aristotle project
`de164bed-3ccc-4934-8263-6e511988015e`, informed by the finite transfer-kernel
shape in Osterwalder-Seiler and Usui.  Claim grade `M`, `[comp]`.
-/

open scoped BigOperators

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace PlueckerOSHankelKernel

variable {n : Nat}

/-- The finite positive-time exponential vector. -/
def decayVector (lambda : Real) : Fin n → Real :=
  fun i => lambda ^ (i : Nat)

/-- The reflected Hankel kernel of a single finite transfer eigenmode. -/
def decayKernel (lambda : Real) : Matrix (Fin n) (Fin n) Real :=
  fun i j => lambda ^ ((i : Nat) + (j : Nat))

/-- The reflected kernel is the outer product of its decay vector. -/
theorem decayKernel_eq_vecMulVec (lambda : Real) :
    decayKernel (n := n) lambda =
      Matrix.vecMulVec (decayVector (n := n) lambda)
        (decayVector (n := n) lambda) := by
  ext i j
  simp +decide [decayKernel, decayVector, Matrix.vecMulVec]
  ring

/-- The reflected quadratic form is exactly one square. -/
theorem reflectionQuadratic_eq_sq (lambda : Real) (f : Fin n → Real) :
    dotProduct f (Matrix.mulVec (decayKernel (n := n) lambda) f) =
      (∑ i, f i * lambda ^ (i : Nat)) ^ 2 := by
  simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_comm]
  simp +decide [decayKernel, pow_add, mul_assoc, mul_comm, mul_left_comm, sq,
    Finset.mul_sum _ _ _]

/-- Every one-mode exponential reflected Hankel kernel is positive
semidefinite. -/
theorem decayKernel_posSemidef (lambda : Real) :
    (decayKernel (n := n) lambda).PosSemidef := by
  constructor
  · ext i j
    simp +decide [decayKernel]
    ring
  · intro x
    have h_sum :
        x.sum (fun i xi => x.sum (fun j xj =>
          star xi * lambda ^ ((i : Nat) + (j : Nat)) * xj)) =
          (∑ i, x i * lambda ^ (i : Nat)) ^ 2 := by
      simp +decide [Finsupp.sum_fintype, pow_add, mul_assoc, mul_comm,
        mul_left_comm, Finset.mul_sum _ _ _, sq]
    exact h_sum.symm ▸ sq_nonneg _

/-- The decay factor selected by a complex Pluecker rest gap. -/
noncomputable def plueckerDecayFactor (z : Complex) (a : Real) : Real :=
  Real.exp (-a * norm z)

/-- A nonzero Pluecker gap and positive Euclidean spacing give genuine decay. -/
theorem plueckerDecayFactor_between_zero_one (z : Complex) (a : Real)
    (hz : z ≠ 0) (ha : 0 < a) :
    0 < plueckerDecayFactor z a ∧ plueckerDecayFactor z a < 1 := by
  exact ⟨Real.exp_pos _, Real.exp_lt_one_iff.mpr <|
    mul_neg_of_neg_of_pos (neg_lt_zero.mpr ha) <| norm_pos_iff.mpr hz⟩

/-- The Pluecker-selected positive-energy mode gives an exact finite positive
reflected Hankel kernel. -/
theorem plueckerDecayKernel_posSemidef (z : Complex) (a : Real) :
    (decayKernel (n := n) (plueckerDecayFactor z a)).PosSemidef := by
  exact decayKernel_posSemidef (plueckerDecayFactor z a)

/-- The exact two-time null vector of the one-mode kernel. -/
def twoTimeNullVector (lambda : Real) : Fin 2 → Real :=
  ![-lambda, 1]

/-- The two-time null vector is genuinely nonzero. -/
theorem twoTimeNullVector_ne_zero (lambda : Real) :
    twoTimeNullVector lambda ≠ 0 := by
  exact ne_of_apply_ne (fun x => x 1) (by norm_num [twoTimeNullVector])

/-- The two-time kernel has a nonzero null direction, exposing the rank-one
boundary of this finite one-particle reconstruction. -/
theorem twoTimeNullVector_quadratic_zero (lambda : Real) :
    dotProduct (twoTimeNullVector lambda)
      (Matrix.mulVec (decayKernel (n := 2) lambda) (twoTimeNullVector lambda)) = 0 := by
  convert reflectionQuadratic_eq_sq _ _
  norm_num [twoTimeNullVector]

/-- Exact nondegenerate `3-4-5` Pluecker control at unit Euclidean spacing. -/
theorem threeFourFive_control :
    let z : Complex := 3 + 4 * Complex.I
    norm z = 5 ∧
      plueckerDecayFactor z 1 = Real.exp (-5) ∧
      (decayKernel (n := 2) (plueckerDecayFactor z 1)).PosSemidef := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [Complex.normSq, Complex.norm_def]
  · unfold plueckerDecayFactor
    norm_num [Complex.normSq, Complex.norm_def]
  · convert plueckerDecayKernel_posSemidef (3 + 4 * Complex.I) 1 using 1

end PlueckerOSHankelKernel
