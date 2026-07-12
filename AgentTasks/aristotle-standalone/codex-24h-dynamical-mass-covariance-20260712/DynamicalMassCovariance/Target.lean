import Mathlib

/-!
# Dynamical covariance of the complex Dirac rest family

This focused target closes the gap between covariance of the static family
`B z` and covariance of the full momentum-dependent Dirac generator

`H(k,z) = k Gamma + B z`.

The same-momentum branch must preserve `Gamma`, hence is diagonal and is the
chiral phase circle modulo a global scalar.  The orientation-reversing branch
is antidiagonal and becomes a covariance only when accompanied by parity
`k -> -k`.  The theorem is finite `2 x 2` complex matrix algebra.

This target concerns covariance of the Dirac generator family.  It does not by
itself classify every symmetry of the ordered `3+1` split-step regulator.
-/

noncomputable section

namespace DynamicalMassCovariance

open Matrix Complex
open scoped Matrix ComplexConjugate

abbrev Mat := Matrix (Fin 2) (Fin 2) Complex

def velocity : Mat := !![1, 0; 0, -1]

def massOperator (z : Complex) : Mat := !![0, z; conj z, 0]

def diracSymbol (k : Real) (z : Complex) : Mat :=
  (k : Complex) • velocity + massOperator z

def chiralPhase (u : Complex) : Mat := !![u, 0; 0, 1]

def chiralFlip (u : Complex) : Mat := !![0, u; 1, 0]

def IsUnitary (W : Mat) : Prop := W * Wᴴ = 1

def SameMomentumCovariant (W : Mat) : Prop :=
  IsUnitary W ∧
    ∃ f : Complex → Complex, ∀ (k : Real) (z : Complex),
      W * diracSymbol k z * Wᴴ = diracSymbol k (f z)

def ParityCovariant (W : Mat) : Prop :=
  IsUnitary W ∧
    ∃ f : Complex → Complex, ∀ (k : Real) (z : Complex),
      W * diracSymbol k z * Wᴴ = diracSymbol (-k) (f z)

/-- Same-momentum dynamical covariance forces the velocity grading to be
preserved. -/
theorem sameMomentum_forces_velocity (W : Mat) (h : SameMomentumCovariant W) :
    W * velocity * Wᴴ = velocity := by
  sorry

/-- A unitary preserving the velocity grading is diagonal. -/
theorem unitary_preserving_velocity_is_diagonal (W : Mat)
    (hW : IsUnitary W) (hGamma : W * velocity * Wᴴ = velocity) :
    W 0 1 = 0 ∧ W 1 0 = 0 := by
  sorry

/-- Complete same-momentum classification: the dynamical covariance group is
the chiral phase circle modulo global phase. -/
theorem sameMomentum_covariant_iff (W : Mat) :
    SameMomentumCovariant W ↔
      ∃ lam u : Complex, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧
        W = lam • chiralPhase u := by
  sorry

/-- Parity covariance forces reversal of the velocity grading. -/
theorem parity_forces_velocity_reversal (W : Mat) (h : ParityCovariant W) :
    W * velocity * Wᴴ = -velocity := by
  sorry

/-- Complete parity branch: orientation reversal is the antidiagonal coset,
again modulo a global phase. -/
theorem parity_covariant_iff (W : Mat) :
    ParityCovariant W ↔
      ∃ lam u : Complex, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧
        W = lam • chiralFlip u := by
  sorry

/-- Non-vacuity: every chiral phase is a same-momentum covariance with
`z -> u z`. -/
theorem chiralPhase_covariant (u : Complex) (hu : ‖u‖ = 1) :
    SameMomentumCovariant (chiralPhase u) := by
  sorry

/-- Non-vacuity: every chiral flip is a parity covariance. -/
theorem chiralFlip_parity_covariant (u : Complex) (hu : ‖u‖ = 1) :
    ParityCovariant (chiralFlip u) := by
  sorry

end DynamicalMassCovariance
