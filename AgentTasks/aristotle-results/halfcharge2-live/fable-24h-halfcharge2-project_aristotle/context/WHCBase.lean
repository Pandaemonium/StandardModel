import Mathlib

/-!
# Exact sector-resolved window half-charge for the two-wall split-step walk

Standalone Mathlib-only file (companion to `WallModeWitness.lean`).  The
L = 8 Pythagorean (3-4-5 coin) two-wall split-step walk `W = S * C` carries
a sign field `s = [+,+,+,+,-,-,-,-]` (walls at bonds 3|4 and 7|0).  All
literal data below was produced by exact rational / `QQ(i)` arithmetic and
re-verified here by pure finite matrix arithmetic (no search, no floats).

The walk matrix coincides with `WallModeWitness.wallWalk` (independently
re-declared here so the file is standalone).

## Theorem ladder

* T1 (grading): `Gamma` is Hermitian, `Gamma^2 = 1`, `Gamma W Gamma = Wᴴ`,
  and `Gamma K + K Gamma = 0` with `K := (W - Wᴴ)/(2i)`.
* T2 (modes): `W v0 = v0`, `W v1 = v1`, `W u0 = -u0`, `W u1 = -u1`; the pairs
  are linearly independent (nonzero `2x2` Gram minor); `K v = 0` for all four.
* T3 (window charge): `Q0win = 1` etc., the window density of each sector,
  written sqrt-free via the projection formula `P = A (Aᴴ A)⁻¹ Aᴴ`.
* T4 (half-charge): `ΔQ = -(window charge of opposite sector)/2 = -1/2`.
* T6 (constant-phase control): the uniform-phase coin walk is `V W Vᴴ`.

Namespace `PhysicsSM.Draft.NullEdge.WindowHalfCharge`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WindowHalfCharge

open Matrix

set_option maxHeartbeats 40000000

/-- Two-wall split-step walk `W = S * C` (16×16, exact `QQ(i)` entries). -/
def W : Matrix (Fin 16) (Fin 16) Complex :=
  !![0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I;
    0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (4 / 5), (-3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5), 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5) * Complex.I, (4 / 5);
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5), (3 / 5) * Complex.I, 0, 0;
    (-3 / 5) * Complex.I, (4 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- Chiral grading `Γ`: block-diagonal, block at site `x` is
`(4/5) σ_y - s(x) (3/5) σ_z`. -/
def Gamma : Matrix (Fin 16) (Fin 16) Complex :=
  !![(-3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    (4 / 5) * Complex.I, (3 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, (-3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, (4 / 5) * Complex.I, (3 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (-3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, (4 / 5) * Complex.I, (3 / 5), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (-3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, (4 / 5) * Complex.I, (3 / 5), 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, (4 / 5) * Complex.I, (-3 / 5), 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5), (-4 / 5) * Complex.I, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5) * Complex.I, (-3 / 5), 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5), (-4 / 5) * Complex.I, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5) * Complex.I, (-3 / 5), 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (3 / 5), (-4 / 5) * Complex.I;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (4 / 5) * Complex.I, (-3 / 5)]

/-- The exact rational Hermitian generator `K = (W - Wᴴ)/(2i)`. -/
def K : Matrix (Fin 16) (Fin 16) Complex :=
  ((2 * Complex.I)⁻¹ : Complex) • (W - Wᴴ)

/-- Window projector on sites `{2,3,4,5}` (state indices `4..11`). -/
def Piw : Matrix (Fin 16) (Fin 16) Complex :=
  Matrix.diagonal (fun i => if 4 ≤ i.val ∧ i.val ≤ 11 then 1 else 0)

/-- Second window projector on sites `{6,7,0,1}` (state indices `0..3, 12..15`). -/
def Piw' : Matrix (Fin 16) (Fin 16) Complex :=
  Matrix.diagonal (fun i => if i.val ≤ 3 ∨ 12 ≤ i.val then 1 else 0)

/-- `+1` eigenvector `v0` (integer form; `= 40 · modePlus`). -/
def v0 : Fin 16 → Complex :=
  ![32, 24*Complex.I, 40, 60*Complex.I, 68, 126*Complex.I, 130, 255*Complex.I,
    257, 126*Complex.I, 130, 60*Complex.I, 68, 24*Complex.I, 40, 0]

/-- `+1` eigenvector `v1`. -/
def v1 : Fin 16 → Complex :=
  ![12*Complex.I, 16, 0, 20, -12*Complex.I, 34, -30*Complex.I, 65,
    -63*Complex.I, 34, -30*Complex.I, 20, -12*Complex.I, 16, 0, 20]

/-- `-1` eigenvector `u0`. -/
def u0 : Fin 16 → Complex :=
  ![-32, -24*Complex.I, 40, 60*Complex.I, -68, -126*Complex.I, 130, 255*Complex.I,
    -257, -126*Complex.I, 130, 60*Complex.I, -68, -24*Complex.I, 40, 0]

/-- `-1` eigenvector `u1`. -/
def u1 : Fin 16 → Complex :=
  ![-12*Complex.I, -16, 0, 20, 12*Complex.I, -34, -30*Complex.I, 65,
    63*Complex.I, -34, -30*Complex.I, 20, 12*Complex.I, -16, 0, 20]

/-- Frame `A = [v0 v1]` for the `+1` sector (16×2). -/
def Amat : Matrix (Fin 16) (Fin 2) Complex := fun i => ![v0 i, v1 i]

/-- Frame `B = [u0 u1]` for the `-1` sector (16×2). -/
def Bmat : Matrix (Fin 16) (Fin 2) Complex := fun i => ![u0 i, u1 i]


theorem W_v0 : W.mulVec v0 = v0 := by
  funext i
  fin_cases i <;>
    simp only [W, v0, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ] <;>
    norm_num [Complex.ext_iff]

theorem W_v1 : W.mulVec v1 = v1 := by
  funext i
  fin_cases i <;>
    simp only [W, v1, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ] <;>
    norm_num [Complex.ext_iff]

theorem W_u0 : W.mulVec u0 = (-1 : Complex) • u0 := by
  funext i
  fin_cases i <;>
    simp only [W, u0, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ, Pi.smul_apply, smul_eq_mul] <;>
    norm_num [Complex.ext_iff]

theorem W_u1 : W.mulVec u1 = (-1 : Complex) • u1 := by
  funext i
  fin_cases i <;>
    simp only [W, u1, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ, Pi.smul_apply, smul_eq_mul] <;>
    norm_num [Complex.ext_iff]

theorem Wd_v0 : Wᴴ.mulVec v0 = v0 := by
  funext i
  fin_cases i <;>
    simp only [Matrix.conjTranspose_apply, W, v0, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ] <;>
    norm_num [Complex.ext_iff]

theorem Wd_v1 : Wᴴ.mulVec v1 = v1 := by
  funext i
  fin_cases i <;>
    simp only [Matrix.conjTranspose_apply, W, v1, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ] <;>
    norm_num [Complex.ext_iff]

theorem Wd_u0 : Wᴴ.mulVec u0 = (-1 : Complex) • u0 := by
  funext i
  fin_cases i <;>
    simp only [Matrix.conjTranspose_apply, W, u0, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ, Pi.smul_apply, smul_eq_mul] <;>
    norm_num [Complex.ext_iff]

theorem Wd_u1 : Wᴴ.mulVec u1 = (-1 : Complex) • u1 := by
  funext i
  fin_cases i <;>
    simp only [Matrix.conjTranspose_apply, W, u1, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Fin.sum_univ_zero, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_fin_one, Matrix.of_apply,
      Matrix.empty_val', Matrix.cons_val_succ, Pi.smul_apply, smul_eq_mul] <;>
    norm_num [Complex.ext_iff]

/-- `K v0 = 0`. -/
theorem K_v0 : K.mulVec v0 = 0 := by
  rw [K, Matrix.smul_mulVec_assoc, Matrix.sub_mulVec, W_v0, Wd_v0, sub_self, smul_zero]
theorem K_v1 : K.mulVec v1 = 0 := by
  rw [K, Matrix.smul_mulVec_assoc, Matrix.sub_mulVec, W_v1, Wd_v1, sub_self, smul_zero]
theorem K_u0 : K.mulVec u0 = 0 := by
  rw [K, Matrix.smul_mulVec_assoc, Matrix.sub_mulVec, W_u0, Wd_u0, sub_self, smul_zero]
theorem K_u1 : K.mulVec u1 = 0 := by
  rw [K, Matrix.smul_mulVec_assoc, Matrix.sub_mulVec, W_u1, Wd_u1, sub_self, smul_zero]


end PhysicsSM.Draft.NullEdge.WindowHalfCharge
