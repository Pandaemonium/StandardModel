import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Hermitian

/-!
# Sorkin-Johnston (SJ) reference state for a finite causal diamond

Discrete Sorkin-Johnston state construction over a finite causet `V = Fin n`.
We define:
- `FinCauset` (acyclic causal relation)
- `causalMatrix`
- `RetardedGreen`
- `pauliJordanReal` (R - Rᵀ)
- `iDelta` (i * (R - Rᵀ))
and prove:
- `pauliJordanReal_antisymm` (R - Rᵀ is real antisymmetric)
- `iDelta_isHermitian` (iDelta is Hermitian self-adjoint)
-/

namespace NullEdgeP9SJReferenceState.Core

open Matrix Complex

variable {n : ℕ}

/-- Causal relation as a decidable relation. `prec x y` means `x ≼ y`
    (`x` is in the causal past of `y`, including `x = y`). -/
structure FinCauset (n : ℕ) where
  prec : Fin n → Fin n → Prop
  decPrec : DecidableRel prec
  refl  : ∀ x, prec x x
  trans : ∀ x y z, prec x y → prec y z → prec x z
  antisymm : ∀ x y, prec x y → prec y x → x = y

attribute [instance] FinCauset.decPrec

/-- Causal matrix `C x y = 1` if `x ≼ y` (else 0), as a real matrix. -/
def causalMatrix (P : FinCauset n) : Matrix (Fin n) (Fin n) ℝ :=
  fun x y => if P.prec x y then 1 else 0

/-- Retarded Green's function: supported on `x ≼ y`. -/
structure RetardedGreen (P : FinCauset n) where
  R : Matrix (Fin n) (Fin n) ℝ
  support : ∀ x y, ¬ P.prec x y → R x y = 0

/-- Advanced Green's function is the transpose of the retarded one. -/
def advanced {P : FinCauset n} (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℝ :=
  G.Rᵀ

/-- Real Pauli–Jordan matrix Δ = R − A = R − Rᵀ (real, antisymmetric). -/
def pauliJordanReal {P : FinCauset n} (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℝ :=
  G.R - G.Rᵀ

/-- Hermitian Pauli–Jordan operator iΔ over ℂ. -/
def iDelta {P : FinCauset n} (G : RetardedGreen P) : Matrix (Fin n) (Fin n) ℂ :=
  Complex.I • (pauliJordanReal G).map (fun r => (r : ℂ))

/-- Real Pauli-Jordan matrix is antisymmetric. -/
theorem pauliJordanReal_antisymm {P : FinCauset n} (G : RetardedGreen P) :
    (pauliJordanReal G)ᵀ = - pauliJordanReal G := by
  unfold pauliJordanReal
  ext i j
  simp

/-- The Hermitian Pauli-Jordan operator iΔ is indeed Hermitian. -/
theorem iDelta_isHermitian {P : FinCauset n} (G : RetardedGreen P) :
    (iDelta G).IsHermitian := by
  unfold Matrix.IsHermitian iDelta pauliJordanReal
  ext i j
  simp [Matrix.conjTranspose_apply, Matrix.map_apply, mul_comm, Complex.ext_iff]

end NullEdgeP9SJReferenceState.Core
