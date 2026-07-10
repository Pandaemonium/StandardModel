import Mathlib

/-!
# Search space for a stationary-amplitude Dirac-walk factor

This standalone file defines the smallest translation-invariant nearest-neighbor
symbol with a stationary amplitude.  Aristotle should determine whether one
can impose exact unitarity, the desired Dirac tangent, and separation of the
zone edge simultaneously, then return an explicit theorem, a no-go theorem, or
the smallest sharpened hypothesis under which one of those outcomes is true.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace NullEdgeDoublerFree

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def alpha : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

/-- Degree-one Laurent symbol.  `A` and `C` are the two directed hops and
`B` is the stationary amplitude. -/
def laurentStep (A B C : Mat4) (q : Real) : Mat4 :=
  Complex.exp (I * q) • A + B + Complex.exp (-I * q) • C

def UnitaryAllMomenta (F : Real -> Mat4) : Prop :=
  forall q, F q ∈ Matrix.unitaryGroup (Fin 4) Complex

/-- Exact normalization and first-order Dirac tangent at the origin. -/
def HasDiracTangent (F : Real -> Mat4) : Prop :=
  F 0 = 1 ∧ HasDerivAt F ((-I : Complex) • alpha) 0

/-- The single-axis zone edge is not a scalar Floquet phase. -/
def SeparatesPi (F : Real -> Mat4) : Prop :=
  F Real.pi ≠ 1 ∧ F Real.pi ≠ -(1 : Mat4)

/-- The stationary channel is genuinely present. -/
def HasStationaryAmplitude (B : Mat4) : Prop := B ≠ 0

end NullEdgeDoublerFree
