import Mathlib

/-!
# Finite scalar celestial-channel contraction

This standalone Aristotle target isolates the smallest channel-dynamics theorem
behind the l=1 relaxation sharpening of the null-edge program.

The visible celestial qubit is represented only by its Bloch vector `r`.  The
normalized mass-ratio square is `1 - |r|^2`.  A scalar Bloch contraction
`r -> c r` is the finite model of an isotropic l=1 channel.  The main monotonicity
target says such a contraction can only increase the mixedness / mass-ratio
square when `c^2 <= 1`.
-/

noncomputable section

namespace NullEdgeCelestialScalarChannel

open BigOperators

/-- A real three-vector in Bloch coordinates. -/
abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def dot (a b : Vec3) : Real :=
  Finset.univ.sum fun k : Fin 3 => a k * b k

/-- Squared Euclidean norm. -/
def normSq (a : Vec3) : Real :=
  dot a a

/-- Normalized mass-ratio square for a Bloch vector: `1 - |r|^2`. -/
def massRatioSq (r : Vec3) : Real :=
  1 - normSq r

/-- Isotropic scalar action on the Bloch vector. -/
def scalarBlochChannel (c : Real) (r : Vec3) : Vec3 :=
  fun k : Fin 3 => c * r k

/-- Squared norm is nonnegative. -/
theorem normSq_nonneg (r : Vec3) :
    0 <= normSq r := by
  sorry

/-- Scalar Bloch contraction scales squared norm by `c^2`. -/
theorem normSq_scalarBlochChannel (c : Real) (r : Vec3) :
    normSq (scalarBlochChannel c r) = c ^ 2 * normSq r := by
  sorry

/-- The normalized mass-ratio square after a scalar Bloch channel. -/
theorem massRatioSq_after_scalarChannel (c : Real) (r : Vec3) :
    massRatioSq (scalarBlochChannel c r) = 1 - c ^ 2 * normSq r := by
  unfold massRatioSq
  rw [normSq_scalarBlochChannel]

/--
If `c^2 <= 1`, scalar Bloch contraction cannot decrease the mass-ratio square.
-/
theorem scalarChannel_massRatioSq_mono_of_contraction
    (c : Real) (r : Vec3) (hc : c ^ 2 <= 1) :
    massRatioSq r <= massRatioSq (scalarBlochChannel c r) := by
  rw [massRatioSq_after_scalarChannel]
  unfold massRatioSq
  have hnorm : 0 <= normSq r := normSq_nonneg r
  nlinarith

end NullEdgeCelestialScalarChannel

end
