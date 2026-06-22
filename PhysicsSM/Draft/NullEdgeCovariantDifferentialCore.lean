import Mathlib

/-!
# Draft.NullEdgeCovariantDifferentialCore

Finite covariant-differential curvature algebra for the null-edge operator
spine.

This draft module isolates the scalar transport identity behind
"covariant differential squared is curvature" on an oriented triangle.  A
transport function `U i j` defines a twisted zero-cochain differential; applying
the next differential gives the triangle defect
`(U i j * U j k - U i k) * f k`.

This is a finite algebraic seed for the curvature block in a future causal
super-Dirac operator.  It is not yet a full order-complex connection or
non-Abelian higher-gauge theorem.

Provenance: integrated from the focused Aristotle job
`null-edge-covariant-differential-curvature-core-20260621`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCovariantDifferentialCore

open Complex

variable {V : Type}

/-- Twisted differential of a zero-cochain. -/
def covariantD0 (U : V -> V -> Complex) (f : V -> Complex) :
    V -> V -> Complex :=
  fun i j => U i j * f j - f i

/-- Twisted differential of a one-cochain on an oriented triangle. -/
def covariantD1 (U : V -> V -> Complex) (a : V -> V -> Complex) :
    V -> V -> V -> Complex :=
  fun i j k => U i j * a j k - a i k + a i j

/-- Scalar triangle transport defect. -/
def triangleCurvature (U : V -> V -> Complex) :
    V -> V -> V -> Complex :=
  fun i j k => U i j * U j k - U i k

/-- Applying the twisted differential twice gives the triangle curvature. -/
theorem covariantD1_covariantD0_eq_curvature
    (U : V -> V -> Complex) (f : V -> Complex) (i j k : V) :
    covariantD1 U (covariantD0 U f) i j k =
      triangleCurvature U i j k * f k := by
  simp only [covariantD1, covariantD0, triangleCurvature]
  ring

/-- A flat triangle has zero twice-twisted differential. -/
theorem covariantD1_covariantD0_eq_zero_of_flat
    (U : V -> V -> Complex) (f : V -> Complex) (i j k : V)
    (hflat : triangleCurvature U i j k = 0) :
    covariantD1 U (covariantD0 U f) i j k = 0 := by
  rw [covariantD1_covariantD0_eq_curvature, hflat, zero_mul]

/-- Gauge-transformed scalar edge transport. -/
def gaugeEdge (g : V -> Units Complex) (U : V -> V -> Complex) :
    V -> V -> Complex :=
  fun i j => (g i : Complex) * U i j * ((g j)⁻¹ : Complex)

/-- Gauge-transformed vertex cochain. -/
def gaugeVertexCochain (g : V -> Units Complex) (f : V -> Complex) :
    V -> Complex :=
  fun i => (g i : Complex) * f i

/-- Gauge-transformed edge cochain. -/
def gaugeEdgeCochain (g : V -> Units Complex) (a : V -> V -> Complex) :
    V -> V -> Complex :=
  fun i j => (g i : Complex) * a i j

/-- The zero-cochain covariant differential is gauge-covariant. -/
theorem covariantD0_gauge_covariant
    (g : V -> Units Complex) (U : V -> V -> Complex) (f : V -> Complex)
    (i j : V) :
    covariantD0 (gaugeEdge g U) (gaugeVertexCochain g f) i j =
      (g i : Complex) * covariantD0 U f i j := by
  simp only [covariantD0, gaugeEdge, gaugeVertexCochain]
  have h : ((g j : Complex))⁻¹ * (g j : Complex) = 1 :=
    inv_mul_cancel₀ (Units.ne_zero (g j))
  linear_combination (g i : Complex) * U i j * f j * h

/-- The one-cochain covariant differential is gauge-covariant. -/
theorem covariantD1_gauge_covariant
    (g : V -> Units Complex) (U : V -> V -> Complex) (a : V -> V -> Complex)
    (i j k : V) :
    covariantD1 (gaugeEdge g U) (gaugeEdgeCochain g a) i j k =
      (g i : Complex) * covariantD1 U a i j k := by
  simp only [covariantD1, gaugeEdge, gaugeEdgeCochain]
  have h : ((g j : Complex))⁻¹ * (g j : Complex) = 1 :=
    inv_mul_cancel₀ (Units.ne_zero (g j))
  linear_combination (g i : Complex) * U i j * a j k * h

/-- The triangle curvature transforms covariantly from the first to last vertex. -/
theorem triangleCurvature_gauge_transform
    (g : V -> Units Complex) (U : V -> V -> Complex) (i j k : V) :
    triangleCurvature (gaugeEdge g U) i j k =
      (g i : Complex) * triangleCurvature U i j k * ((g k)⁻¹ : Complex) := by
  simp only [triangleCurvature, gaugeEdge]
  have h : ((g j : Complex))⁻¹ * (g j : Complex) = 1 :=
    inv_mul_cancel₀ (Units.ne_zero (g j))
  linear_combination
    (g i : Complex) * U i j * U j k * ((g k)⁻¹ : Complex) * h

end PhysicsSM.Draft.NullEdgeCovariantDifferentialCore

end
