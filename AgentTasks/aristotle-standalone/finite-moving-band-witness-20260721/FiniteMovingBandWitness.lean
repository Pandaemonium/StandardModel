import Mathlib

/-!
# Exact gapped moving-band witness

This focused target constructs a two-level Hermitian family with a fixed gap
and an explicitly moving rank-one low-energy projector. The local leakage is
nonzero at every finite regulator but has a summable changing-regulator budget.

The result is a finite control for the HNU physical-sector program. It is not an
HNU instantiation, an adiabatic theorem, a quasi-locality theorem, or an
interacting continuum result.
-/

noncomputable section

open Matrix
open scoped BigOperators Topology

namespace FiniteMovingBandWitness

abbrev Vec2 := Fin 2 -> Real
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Real

/-- Rational stereographic unit vector. -/
def lowVec (t : Real) : Vec2 :=
  ![(1 - t ^ 2) / (1 + t ^ 2), 2 * t / (1 + t ^ 2)]

/-- Its displayed orthogonal unit complement. -/
def highVec (t : Real) : Vec2 :=
  ![-2 * t / (1 + t ^ 2), (1 - t ^ 2) / (1 + t ^ 2)]

def dot (x y : Vec2) : Real := Finset.univ.sum fun i => x i * y i

def outer (x y : Vec2) : Mat2 := fun i j => x i * y j

/-- Rank-one low-energy projector. -/
def lowProjector (t : Real) : Mat2 := outer (lowVec t) (lowVec t)

/-- A two-level Hamiltonian with target eigenvalues `-1` and `+1`. -/
def gappedHamiltonian (t : Real) : Mat2 := 1 - 2 • lowProjector t

/-- Selected-to-complement transition amplitude between two displayed bands. -/
def defectAmplitude (s t : Real) : Real := dot (highVec t) (lowVec s)

theorem one_add_sq_pos (t : Real) : 0 < 1 + t ^ 2 := by
  sorry

theorem lowVec_unit (t : Real) : dot (lowVec t) (lowVec t) = 1 := by
  sorry

theorem highVec_unit (t : Real) : dot (highVec t) (highVec t) = 1 := by
  sorry

theorem low_high_orthogonal (t : Real) : dot (highVec t) (lowVec t) = 0 := by
  sorry

theorem lowProjector_idempotent (t : Real) :
    lowProjector t * lowProjector t = lowProjector t := by
  sorry

theorem lowProjector_symmetric (t : Real) :
    (lowProjector t).transpose = lowProjector t := by
  sorry

theorem gappedHamiltonian_low_eigenvector (t : Real) :
    gappedHamiltonian t *ᵥ lowVec t = -lowVec t := by
  sorry

theorem gappedHamiltonian_high_eigenvector (t : Real) :
    gappedHamiltonian t *ᵥ highVec t = highVec t := by
  sorry

/-- The family has an exact, parameter-independent two-level gap. -/
theorem exact_uniform_gap (t : Real) :
    gappedHamiltonian t *ᵥ lowVec t = (-1 : Real) • lowVec t /\
      gappedHamiltonian t *ᵥ highVec t = (1 : Real) • highVec t /\
      (1 : Real) - (-1 : Real) = 2 := by
  sorry

theorem defectAmplitude_formula (s t : Real) :
    defectAmplitude s t =
      2 * (s - t) * (1 + s * t) /
        ((1 + s ^ 2) * (1 + t ^ 2)) := by
  sorry

/-- Exact matrix factorization of one moving-projector defect. -/
theorem moving_projector_defect_factorization (s t : Real) :
    (1 - lowProjector t) * lowProjector s =
      defectAmplitude s t • outer (highVec t) (lowVec s) := by
  sorry

/-- Slow schedule with `N` steps and total parameter displacement `1/N`. -/
def slowParameter (N k : Nat) : Real := (k : Real) / (N : Real) ^ 2

/-- Each finite step moves the band nontrivially. -/
theorem finite_step_defect_nonzero (N k : Nat) (hN : 0 < N) (hk : k < N) :
    Ne (defectAmplitude (slowParameter N k) (slowParameter N (k + 1))) 0 := by
  sorry

/-- Uniform local budget for the explicit slow schedule. -/
theorem finite_step_defect_bound (N k : Nat) (hN : 0 < N) (hk : k < N) :
    |defectAmplitude (slowParameter N k) (slowParameter N (k + 1))| <=
      4 / (N : Real) ^ 2 := by
  sorry

/-- The accumulated `N`-step scalar leakage budget vanishes. -/
theorem accumulated_budget_tendsto_zero :
    Filter.Tendsto
      (fun n : Nat =>
        ((n + 1 : Nat) : Real) * (4 / ((n + 1 : Nat) : Real) ^ 2))
      Filter.atTop (nhds 0) := by
  sorry

end FiniteMovingBandWitness

end
