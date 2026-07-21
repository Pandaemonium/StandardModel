import Mathlib

/-!
# Rank-one finite reflection kernel from exponential decay

This focused Aristotle target isolates the finite Osterwalder--Schrader
Hankel-kernel step needed by the null-edge origin-of-mass program.  It does not
claim an interacting field-algebra measure, an infinite-volume reconstruction,
or an LSZ pole.

For a decay factor `lambda`, the reflected time kernel is
`K i j = lambda^(i+j)`.  The main target identifies its quadratic form with one
square and hence proves positive semidefiniteness.  The two-time null vector is
retained to expose that this one-mode kernel has rank one rather than a hidden
strict gap.
-/

open scoped BigOperators

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace PlueckerOSHankelKernel

variable {n : Nat}

/-- The finite positive-time exponential vector. -/
def decayVector (lambda : Real) : Fin n -> Real :=
  fun i => lambda ^ (i : Nat)

/-- The reflected Hankel kernel of a single finite transfer eigenmode. -/
def decayKernel (lambda : Real) : Matrix (Fin n) (Fin n) Real :=
  fun i j => lambda ^ ((i : Nat) + (j : Nat))

/-- The reflected kernel is the outer product of its decay vector. -/
theorem decayKernel_eq_vecMulVec (lambda : Real) :
    decayKernel (n := n) lambda =
      Matrix.vecMulVec (decayVector (n := n) lambda)
        (decayVector (n := n) lambda) := by
  sorry

/-- The reflected quadratic form is exactly one square. -/
theorem reflectionQuadratic_eq_sq (lambda : Real) (f : Fin n -> Real) :
    dotProduct f (Matrix.mulVec (decayKernel (n := n) lambda) f) =
      (∑ i, f i * lambda ^ (i : Nat)) ^ 2 := by
  sorry

/-- Every one-mode exponential Hankel kernel is positive semidefinite. -/
theorem decayKernel_posSemidef (lambda : Real) :
    (decayKernel (n := n) lambda).PosSemidef := by
  sorry

/-- The factor selected by a complex Pluecker rest gap. -/
noncomputable def plueckerDecayFactor (z : Complex) (a : Real) : Real :=
  Real.exp (-a * norm z)

/-- A nonzero Pluecker gap and positive Euclidean spacing give genuine decay. -/
theorem plueckerDecayFactor_between_zero_one (z : Complex) (a : Real)
    (hz : z ≠ 0) (ha : 0 < a) :
    0 < plueckerDecayFactor z a ∧ plueckerDecayFactor z a < 1 := by
  sorry

/-- The Pluecker-selected positive-energy mode therefore gives an exact finite
reflection-positive kernel. -/
theorem plueckerDecayKernel_posSemidef (z : Complex) (a : Real) :
    (decayKernel (n := n) (plueckerDecayFactor z a)).PosSemidef := by
  sorry

/-- The exact two-time null vector of the one-mode kernel. -/
def twoTimeNullVector (lambda : Real) : Fin 2 -> Real :=
  ![-lambda, 1]

/-- The null vector is genuinely nonzero. -/
theorem twoTimeNullVector_ne_zero (lambda : Real) :
    twoTimeNullVector lambda ≠ 0 := by
  sorry

/-- The two-time kernel has a nonzero null direction, exposing the rank-one
boundary of this finite one-particle reconstruction. -/
theorem twoTimeNullVector_quadratic_zero (lambda : Real) :
    dotProduct (twoTimeNullVector lambda)
      (Matrix.mulVec (decayKernel (n := 2) lambda) (twoTimeNullVector lambda)) = 0 := by
  sorry

/-- Exact nondegenerate `3-4-5` Pluecker control at unit Euclidean spacing. -/
theorem threeFourFive_control :
    let z : Complex := 3 + 4 * Complex.I
    norm z = 5 ∧
      plueckerDecayFactor z 1 = Real.exp (-5) ∧
      (decayKernel (n := 2) (plueckerDecayFactor z 1)).PosSemidef := by
  sorry

end PlueckerOSHankelKernel
