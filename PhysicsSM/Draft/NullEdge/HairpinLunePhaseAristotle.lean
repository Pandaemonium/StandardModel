import Mathlib

/-!
# Hairpin lune phase

This draft module records finite rational witnesses for the geometric-phase
layer of a spiral-resolved checkerboard hairpin.  The bare antipodal product
vanishes.  Resolving a pair of hairpins through opposite meridians gives
trace `-1/4`, while the same-meridian backtrack gives `+1/4`; the common
magnitude is the product of two right-angle bend factors.

These are exact finite matrix identities.  Their interpretation as the
origin of the checkerboard corner phase, and the general solid-angle law for
arbitrary histories, are not proved here.

## Conventions and provenance

The matrices are the standard spin-coherent projectors for the directions
`+z`, `-z`, `+x`, and `-x`, over the rationals.  The file is a clean-room
formalization from Pauli projector algebra.  Aristotle project
`0e4a3f50-4bad-4d01-ae49-32c6cef117b5` supplied the proof bodies; they were
reviewed against the unchanged standalone statements and checked locally
with the pinned Lean toolchain on 2026-07-14.
-/

namespace PhysicsSM.Draft.NullEdge.HairpinLunePhase

open Matrix

/-- Two-by-two rational matrices containing the four axis projectors. -/
abbrev CoinMat := Matrix (Fin 2) (Fin 2) ℚ

/-- Spin-coherent projector for `+z`. -/
def Pz : CoinMat := !![1, 0; 0, 0]

/-- Spin-coherent projector for `-z`. -/
def Pmz : CoinMat := !![0, 0; 0, 1]

/-- Spin-coherent projector for `+x`. -/
def Px : CoinMat := !![1/2, 1/2; 1/2, 1/2]

/-- Spin-coherent projector for `-x`. -/
def Pmx : CoinMat := !![1/2, -(1/2); -(1/2), 1/2]

/-- The `+z` projector is idempotent. -/
theorem Pz_idem : Pz * Pz = Pz := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Pz, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The `+x` projector is idempotent. -/
theorem Px_idem : Px * Px = Px := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Px, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The unresolved antipodal hairpin has zero projector product. -/
theorem hairpin_annihilation : Pz * Pmz = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Pz, Pmz, Matrix.mul_apply, Fin.sum_univ_succ]

/-- A right-angle bend from `+z` to `+x` has trace factor `1/2`. -/
theorem bend_trace : (Pz * Px).trace = 1 / 2 := by
  norm_num [Pz, Px, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The antipodal right-angle return bend also has trace factor `1/2`. -/
theorem bend_trace_return : (Pmz * Pmx).trace = 1 / 2 := by
  norm_num [Pmz, Pmx, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The opposite-meridian four-projector history has Bargmann trace `-1/4`. -/
theorem hairpin_pair_trace : (Pz * Px * Pmz * Pmx).trace = -(1 / 4) := by
  norm_num [Pz, Px, Pmz, Pmx, Matrix.trace, Matrix.mul_apply,
    Fin.sum_univ_succ]

/-- The same-meridian backtrack has Bargmann trace `+1/4`. -/
theorem backtrack_pair_trace : (Pz * Px * Pmz * Px).trace = 1 / 4 := by
  norm_num [Pz, Px, Pmz, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The hairpin magnitude is the product of its two bend factors. -/
theorem hairpin_magnitude :
    |(Pz * Px * Pmz * Pmx).trace| = (Pz * Px).trace * (Pmz * Pmx).trace := by
  rw [hairpin_pair_trace, bend_trace, bend_trace_return]
  norm_num

end PhysicsSM.Draft.NullEdge.HairpinLunePhase
