import Mathlib

/-!
# Covariant differential curvature core

Standalone finite algebra for the graph/gauge block of the null-edge
super-Dirac program.

The target is the minimal identity behind "covariant differential squared is
curvature" on an oriented triangle.  A scalar transport `U i j` defines a
twisted zero-cochain differential.  Applying the next differential gives the
triangle defect `(U i j * U j k - U i k) * f k`.

The same file asks for basic finite gauge-covariance identities using
nonzero complex gauge factors represented as `Units Complex`.
-/

noncomputable section

namespace NullEdgeCovariantDifferentialCore

open Complex

variable {V : Type}

def covariantD0 (U : V -> V -> Complex) (f : V -> Complex) :
    V -> V -> Complex :=
  fun i j => U i j * f j - f i

def covariantD1 (U : V -> V -> Complex) (a : V -> V -> Complex) :
    V -> V -> V -> Complex :=
  fun i j k => U i j * a j k - a i k + a i j

def triangleCurvature (U : V -> V -> Complex) :
    V -> V -> V -> Complex :=
  fun i j k => U i j * U j k - U i k

theorem covariantD1_covariantD0_eq_curvature
    (U : V -> V -> Complex) (f : V -> Complex) (i j k : V) :
    covariantD1 U (covariantD0 U f) i j k =
      triangleCurvature U i j k * f k := by
  sorry

theorem covariantD1_covariantD0_eq_zero_of_flat
    (U : V -> V -> Complex) (f : V -> Complex) (i j k : V)
    (hflat : triangleCurvature U i j k = 0) :
    covariantD1 U (covariantD0 U f) i j k = 0 := by
  sorry

def gaugeEdge (g : V -> Units Complex) (U : V -> V -> Complex) :
    V -> V -> Complex :=
  fun i j => (g i : Complex) * U i j * ((g j)⁻¹ : Complex)

def gaugeVertexCochain (g : V -> Units Complex) (f : V -> Complex) :
    V -> Complex :=
  fun i => (g i : Complex) * f i

def gaugeEdgeCochain (g : V -> Units Complex) (a : V -> V -> Complex) :
    V -> V -> Complex :=
  fun i j => (g i : Complex) * a i j

theorem covariantD0_gauge_covariant
    (g : V -> Units Complex) (U : V -> V -> Complex) (f : V -> Complex)
    (i j : V) :
    covariantD0 (gaugeEdge g U) (gaugeVertexCochain g f) i j =
      (g i : Complex) * covariantD0 U f i j := by
  sorry

theorem covariantD1_gauge_covariant
    (g : V -> Units Complex) (U : V -> V -> Complex) (a : V -> V -> Complex)
    (i j k : V) :
    covariantD1 (gaugeEdge g U) (gaugeEdgeCochain g a) i j k =
      (g i : Complex) * covariantD1 U a i j k := by
  sorry

theorem triangleCurvature_gauge_transform
    (g : V -> Units Complex) (U : V -> V -> Complex) (i j k : V) :
    triangleCurvature (gaugeEdge g U) i j k =
      (g i : Complex) * triangleCurvature U i j k * ((g k)⁻¹ : Complex) := by
  sorry

end NullEdgeCovariantDifferentialCore

end
