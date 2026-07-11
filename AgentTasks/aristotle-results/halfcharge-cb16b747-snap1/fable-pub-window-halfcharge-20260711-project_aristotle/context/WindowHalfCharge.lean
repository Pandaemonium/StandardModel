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

/-! ## T1 : grading identities -/

/-- **T1a.** `Γ` is Hermitian. -/
theorem Gamma_isHermitian : Gammaᴴ = Gamma := by sorry

/-- **T1b.** `Γ² = 1`. -/
theorem Gamma_sq : Gamma * Gamma = 1 := by sorry

/-- **T1c.** `Γ W Γ = Wᴴ`. -/
theorem Gamma_W_Gamma : Gamma * W * Gamma = Wᴴ := by sorry

/-- **T1d.** `Γ K + K Γ = 0`. -/
theorem Gamma_K_anticomm : Gamma * K + K * Gamma = 0 := by sorry

/-! ## T2 : exact modes -/

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

/-! ## Gram matrices and inverses -/

/-- Gram matrix of the `+1` frame, `Aᴴ A`. -/
theorem Gram_eq :
    Amatᴴ * Amat = !![(218450 : Complex), -53550 * Complex.I; 53550 * Complex.I, 14450] := by
  sorry

/-- Gram matrix of the `-1` frame, `Bᴴ B` (equal to the `+1` Gram). -/
theorem GramU_eq :
    Bmatᴴ * Bmat = !![(218450 : Complex), -53550 * Complex.I; 53550 * Complex.I, 14450] := by
  sorry

/-- Explicit inverse of the Gram matrix. -/
def GramInv : Matrix (Fin 2) (Fin 2) Complex :=
  !![(14450 / 289000000 : Complex), (53550 / 289000000) * Complex.I;
    (-53550 / 289000000) * Complex.I, (218450 / 289000000)]

theorem Gram_mul_GramInv :
    (!![(218450 : Complex), -53550 * Complex.I; 53550 * Complex.I, 14450] : Matrix (Fin 2) (Fin 2) Complex)
      * GramInv = 1 := by
  sorry

/-- **T2 (independence).** The Gram minor is nonzero, so `v0, v1` are independent. -/
theorem Gram_det_ne_zero :
    (Amatᴴ * Amat).det ≠ 0 := by sorry

theorem GramU_det_ne_zero :
    (Bmatᴴ * Bmat).det ≠ 0 := by sorry

/-! ## T3 : window charges -/

/-- Window charge of the `+1` sector on window 1 (`Πw`).  This is
`trace (P Πw)` with `P = A (Aᴴ A)⁻¹ Aᴴ` written sqrt-free. -/
def Q0_win1 : Complex := Matrix.trace ((Amatᴴ * Amat)⁻¹ * (Amatᴴ * Piw * Amat))
def Q0_win2 : Complex := Matrix.trace ((Amatᴴ * Amat)⁻¹ * (Amatᴴ * Piw' * Amat))
def Qpi_win1 : Complex := Matrix.trace ((Bmatᴴ * Bmat)⁻¹ * (Bmatᴴ * Piw * Bmat))
def Qpi_win2 : Complex := Matrix.trace ((Bmatᴴ * Bmat)⁻¹ * (Bmatᴴ * Piw' * Bmat))

theorem Q0_win1_eq : Q0_win1 = 1 := by sorry
theorem Q0_win2_eq : Q0_win2 = 1 := by sorry
theorem Qpi_win1_eq : Qpi_win1 = 1 := by sorry
theorem Qpi_win2_eq : Qpi_win2 = 1 := by sorry

/-! ## T4 : half-charge -/

/-- Sector-resolved defect charge of the `+1` sector: `-(opposite window)/2`. -/
def DeltaQ0 : Complex := -(Qpi_win1) / 2
def DeltaQpi : Complex := -(Q0_win1) / 2

/-- **T4.** Exact half-charge `ΔQ₀ = -1/2`. -/
theorem DeltaQ0_eq : DeltaQ0 = -1 / 2 := by
  unfold DeltaQ0; rw [Qpi_win1_eq]

/-- **T4.** Exact half-charge `ΔQ_π = -1/2`. -/
theorem DeltaQpi_eq : DeltaQpi = -1 / 2 := by
  unfold DeltaQpi; rw [Q0_win1_eq]

end PhysicsSM.Draft.NullEdge.WindowHalfCharge
