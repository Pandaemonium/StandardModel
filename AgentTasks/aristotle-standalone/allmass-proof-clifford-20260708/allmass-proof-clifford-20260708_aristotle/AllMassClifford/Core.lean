/-
# Certify the T2 carrier: the hand-typed HAC/Jmet ARE the Cl(4) Kronecker assembly

Proof job (Aristotle). Mathlib-only. This closes an audit gap (2026-07-08): in the
all-mass program, the flagship `T2_positive_mass` proves a positive squared mass
of a `12×12` Krein form `HAC` and metric `Jmet` that are entered as **hand-typed
literal matrices**. Their Clifford provenance — that they are the two-edge `Cl(4)`
carrier's `J(Q_A+Q_C)` and fundamental symmetry `J = Js⊗I3` — is currently only in
docstrings + an oracle, NOT kernel-certified. Your job: build the Clifford
assembly from Pauli-Kronecker products and prove it EQUALS the hand-typed matrices
(or, if it does not, report the exact discrepancy — a real convention bug would be
a valuable finding).

## The Clifford recipe (conventions, aperture strength lam = 2)

- Pauli: `sx = !![0,1;1,0]`, `sy = !![0,-I;I,0]`, `sz = !![1,0;0,-1]` (I = Complex.I).
- Hermitian gammas on `C^4 = C^2 ⊗ C^2` (use `Matrix.kroneckerMap (·*·)` / `⊗ₖ`):
  `g1 = sx ⊗ I2`, `g2 = sy ⊗ I2`, `g3 = sz ⊗ sx`, `g4 = sz ⊗ sy`.
- `omega = g1 * g2`, `Js = Complex.I • (g3 * g4)`  (both `4×4`).
- Krein metric `J_cl = Js ⊗ I3`  (`12×12`).
- aperture `Q_A = I4 ⊗ ((2 : ℂ) • I3)`  (`12×12`).
- closure `Q_C = omega ⊗ K` with `K = !![0,1,0; -1,0,0; 0,0,0]`  (`12×12`).
- assembly `HAC_cl = J_cl * (Q_A + Q_C)`  (`12×12`).

## Result (kernel-clean, no `sorry`)

Both targets hold **verbatim, with no convention change**. The Kronecker order is
the standard row-major one induced by `finProdFinEquiv : Fin m × Fin n ≃ Fin (m*n)`
(`(i,k) ↦ n*i + k`), the gamma signs are exactly as recipe'd, and `K` is oriented
exactly as recipe'd. Concretely one computes

  `omega = diag(I, I, -I, -I)`,  `Js = diag(-1, 1, -1, 1)`,

so `J_cl = Js ⊗ I3 = Jmet` (the hand-typed diagonal), and, since `omega` is
diagonal, `Q_C = omega ⊗ K` is block-diagonal with blocks `I·K, I·K, -I·K, -I·K`,
whence `J_cl * (Q_A + Q_C) = 2·Jmet + (block-diag −I·K, I·K, I·K, −I·K) = HAC`.

- **Jmet_eq_clifford:** `Js ⊗ I3 = Jmet` (i.e. `J_cl = Jmet`).
- **HAC_eq_clifford:** `J_cl * (Q_A + Q_C) = HAC`.

Semantic alignment: the hand-typed T2 carrier IS the Cl(4) Kronecker assembly, in
the kernel — no gamma-sign, Kronecker-order, or K-orientation discrepancy.

Provenance: all-mass solo run 2026-07-08 [orig]; closes the T2 Clifford-provenance
audit gap.
-/

import Mathlib

namespace AllMassClifford

open Matrix Complex
open scoped Kronecker

/-- Hand-typed Krein form (target), verbatim from `SectorGroundMassWitness.HAC`. -/
def HAC : Matrix (Fin 12) (Fin 12) ℂ :=
  !![ (-2 : ℂ), -Complex.I, 0,  0, 0, 0,   0, 0, 0,   0, 0, 0;
      Complex.I, -2, 0,          0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, -2,                  0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   (2 : ℂ), Complex.I, 0,     0, 0, 0,   0, 0, 0;
      0, 0, 0,   -Complex.I, 2, 0,          0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 2,                   0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 0,   (-2 : ℂ), Complex.I, 0,    0, 0, 0;
      0, 0, 0,   0, 0, 0,   -Complex.I, -2, 0,         0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, -2,                  0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   (2 : ℂ), -Complex.I, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   0, 0, 2]

/-- Hand-typed Krein metric (target), verbatim from `SectorGroundMassWitness.Jmet`. -/
def Jmet : Matrix (Fin 12) (Fin 12) ℂ :=
  Matrix.diagonal ![(-1 : ℂ), -1, -1, 1, 1, 1, -1, -1, -1, 1, 1, 1]

/-! ## The Clifford assembly -/

/-- Pauli `σx`. -/
def sx : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
/-- Pauli `σy`. -/
def sy : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
/-- Pauli `σz`. -/
def sz : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `2×2` identity. -/
def I2 : Matrix (Fin 2) (Fin 2) ℂ := 1
/-- `3×3` identity. -/
def I3 : Matrix (Fin 3) (Fin 3) ℂ := 1
/-- `4×4` identity. -/
def I4 : Matrix (Fin 4) (Fin 4) ℂ := 1

/-- Kronecker product of two `2×2` matrices, reindexed to `Fin 4` (row-major,
via `finProdFinEquiv`). -/
noncomputable def kron4 (A B : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.reindex finProdFinEquiv finProdFinEquiv (A ⊗ₖ B)

/-- Kronecker product of a `4×4` and a `3×3` matrix, reindexed to `Fin 12`
(row-major, via `finProdFinEquiv`). -/
noncomputable def kron12 (A : Matrix (Fin 4) (Fin 4) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 12) (Fin 12) ℂ :=
  Matrix.reindex finProdFinEquiv finProdFinEquiv (A ⊗ₖ B)

/-- Hermitian gamma `g1 = sx ⊗ I2`. -/
noncomputable def g1 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sx I2
/-- Hermitian gamma `g2 = sy ⊗ I2`. -/
noncomputable def g2 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sy I2
/-- Hermitian gamma `g3 = sz ⊗ sx`. -/
noncomputable def g3 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sz sx
/-- Hermitian gamma `g4 = sz ⊗ sy`. -/
noncomputable def g4 : Matrix (Fin 4) (Fin 4) ℂ := kron4 sz sy

/-- `omega = g1 * g2`. -/
noncomputable def omega : Matrix (Fin 4) (Fin 4) ℂ := g1 * g2
/-- Fundamental symmetry `Js = I • (g3 * g4)`. -/
noncomputable def Js : Matrix (Fin 4) (Fin 4) ℂ := Complex.I • (g3 * g4)

/-- Krein metric `J_cl = Js ⊗ I3`. -/
noncomputable def J_cl : Matrix (Fin 12) (Fin 12) ℂ := kron12 Js I3

/-- Aperture `Q_A = I4 ⊗ (2 • I3)`. -/
noncomputable def Q_A : Matrix (Fin 12) (Fin 12) ℂ := kron12 I4 ((2 : ℂ) • I3)

/-- Closure kernel `K`. -/
def K : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; -1, 0, 0; 0, 0, 0]

/-- Closure `Q_C = omega ⊗ K`. -/
noncomputable def Q_C : Matrix (Fin 12) (Fin 12) ℂ := kron12 omega K

/-- Full assembly `HAC_cl = J_cl * (Q_A + Q_C)`. -/
noncomputable def HAC_cl : Matrix (Fin 12) (Fin 12) ℂ := J_cl * (Q_A + Q_C)

/-! ## Explicit small-matrix forms -/

/-- `Js` computes to `diag(-1, 1, -1, 1)`. -/
theorem Js_eq : Js = !![(-1 : ℂ), 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1] := by
  unfold Js g3 g4 kron4 sz sx sy
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.reindex_apply,
      Matrix.kroneckerMap_apply, finProdFinEquiv, Fin.divNat, Fin.modNat]

/-- `omega` computes to `diag(I, I, -I, -I)`. -/
theorem omega_eq :
    omega = !![Complex.I, 0, 0, 0; 0, Complex.I, 0, 0; 0, 0, -Complex.I, 0; 0, 0, 0, -Complex.I] := by
  unfold omega g1 g2 kron4 sx sy I2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, Matrix.reindex_apply,
      Matrix.kroneckerMap_apply, finProdFinEquiv, Fin.divNat, Fin.modNat,
      Matrix.one_apply]

/-- Explicit form of the aperture-plus-closure operator `Q_A + Q_C`. -/
def QAC : Matrix (Fin 12) (Fin 12) ℂ :=
  !![ (2 : ℂ), Complex.I, 0,   0, 0, 0,   0, 0, 0,   0, 0, 0;
      -Complex.I, 2, 0,       0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 2,               0, 0, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   (2:ℂ), Complex.I, 0,   0, 0, 0,   0, 0, 0;
      0, 0, 0,   -Complex.I, 2, 0,      0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 2,              0, 0, 0,   0, 0, 0;
      0, 0, 0,   0, 0, 0,   (2:ℂ), -Complex.I, 0,  0, 0, 0;
      0, 0, 0,   0, 0, 0,   Complex.I, 2, 0,       0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 2,              0, 0, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   (2:ℂ), -Complex.I, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   Complex.I, 2, 0;
      0, 0, 0,   0, 0, 0,   0, 0, 0,   0, 0, 2]

set_option maxHeartbeats 1600000 in
/-- `Q_A + Q_C` computes to the explicit matrix `QAC`. -/
theorem QAC_eq : Q_A + Q_C = QAC := by
  unfold Q_A Q_C kron12 I4 I3 K QAC
  rw [omega_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.reindex_apply, Matrix.kroneckerMap_apply, finProdFinEquiv,
      Fin.divNat, Fin.modNat, Matrix.add_apply]

/-! ## Targets -/

set_option maxHeartbeats 1600000 in
/-- The Clifford metric `J_cl = Js ⊗ I3` equals the hand-typed `Jmet`, verbatim. -/
theorem Jmet_eq_clifford : J_cl = Jmet := by
  unfold J_cl kron12 I3 Jmet
  rw [Js_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.reindex_apply, Matrix.kroneckerMap_apply, finProdFinEquiv,
      Fin.divNat, Fin.modNat, Matrix.diagonal]

set_option maxHeartbeats 1600000 in
/-- The Clifford assembly `J_cl * (Q_A + Q_C)` equals the hand-typed `HAC`, verbatim. -/
theorem HAC_eq_clifford : J_cl * (Q_A + Q_C) = HAC := by
  rw [Jmet_eq_clifford, QAC_eq]
  unfold Jmet QAC HAC
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.diagonal]

end AllMassClifford

-- #print axioms AllMassClifford.Jmet_eq_clifford
-- #print axioms AllMassClifford.HAC_eq_clifford
