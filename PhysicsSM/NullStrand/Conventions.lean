import Mathlib
import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdgeDiracSlashCore

/-!
# NullStrand.Conventions

This module defines the minimal null-strand conventions used by the Lean roadmap:
Minkowski 4-vectors, the Pauli/Sigma Hermitian lift, and the small algebraic
compatibility lemmas needed by downstream wrappers.

Provenance: clean-room reconciliation of existing project formulas from
`PhysicsSM.Draft.NullEdgeDiracSlashCore` and `PhysicsSM.Spinor.PluckerMass`,
explicitly fixing the `(+---)` signature.
-/

noncomputable section

namespace PhysicsSM.NullStrand

open Matrix Complex

/-- Weyl spinors in the two-component convention used by this stack. -/
abbrev WeylSpinor := Fin 2 -> Complex

/-- Raw real 4-vectors for Minkowski calculations. -/
abbrev Minkowski4 := Fin 4 -> Real

/-- 2x2 complex Hermitian block type. -/
abbrev Herm2 := Matrix (Fin 2) (Fin 2) Complex

/-- Bilinear form `eta = diag(1,-1,-1,-1)` on `Fin 4 -> Real`. -/
def minkowskiInner (p q : Minkowski4) : Real :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- Minkowski norm-squared with `(+---)` convention. -/
def minkowskiSq (p : Minkowski4) : Real :=
  minkowskiInner p p

/-- Future-pointing test in this convention. -/
def IsFuture (p : Minkowski4) : Prop := 0 < p 0

/-- Nullity in this convention. -/
def IsNull (p : Minkowski4) : Prop := minkowskiSq p = 0

/-- Timelike in this convention. -/
def IsTimelike (p : Minkowski4) : Prop := 0 < minkowskiSq p

/-- Unit future timelike vectors. -/
def IsUnitFutureTimelike (u : Minkowski4) : Prop :=
  And (IsFuture u) (minkowskiSq u = 1)

/-- Pauli/Hermitian lift of a real 4-vector to a 2x2 complex matrix. -/
def pauliHermitianEquiv (p : Minkowski4) : Herm2 :=
  PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum (fun i => (p i : Complex))

/-- Component formula for the Pauli/Hermitian lift. -/
theorem pauliHermitianEquiv_apply (p : Minkowski4) (a b : Fin 2) :
    pauliHermitianEquiv p a b =
      (if a = 0 /\ b = 0 then
          ((p 0 + p 3 : Real) : Complex)
        else if a = 0 /\ b = 1 then
          (p 1 : Complex) - Complex.I * (p 2 : Complex)
        else if a = 1 /\ b = 0 then
          (p 1 : Complex) + Complex.I * (p 2 : Complex)
        else ((p 0 - p 3 : Real) : Complex)) := by
  fin_cases a <;> fin_cases b <;>
    simp [pauliHermitianEquiv, PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum]

/-- Determinant of the Pauli/Hermitian lift is the Minkowski scalar. -/
theorem hermitian_det_eq_minkowskiSq (p : Minkowski4) :
    (pauliHermitianEquiv p).det = (minkowskiSq p : Complex) := by
  simpa [pauliHermitianEquiv, minkowskiSq, minkowskiInner,
    PhysicsSM.Draft.NullEdgeDiracSlashCore.minkowskiNorm, mul_comm, mul_left_comm, mul_assoc]
    using
      (PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm
        (fun i => (p i : Complex)))

/-- Congruence by an SL(2,C) matrix preserves determinant under `A M A†`. -/
theorem sl2_congruence_preserves_det
    (A M : Matrix (Fin 2) (Fin 2) Complex) (hA : Matrix.det A = 1) :
    Matrix.det (A * M * Matrix.conjTranspose A) = Matrix.det M := by
  have hAT : Matrix.det (Matrix.conjTranspose A) = (1 : Complex) := by
    rw [Matrix.det_conjTranspose]
    simpa [hA]
  calc
    Matrix.det (A * M * Matrix.conjTranspose A)
        = Matrix.det A * (Matrix.det M * Matrix.det (Matrix.conjTranspose A)) := by
          simp [Matrix.det_mul, mul_assoc]
    _ = Matrix.det M := by
          simp [hA, hAT, mul_assoc, mul_left_comm, mul_comm]

end PhysicsSM.NullStrand
