import Mathlib
import GRFacts
import GRDiag

/-!
# Momentum block-diagonalization of the free pair lift on the four-site ring

E-lane structural companion (strategy3 Q3-a).  On the L=4 complex-coin
ring (8 modes, mode = site*2 + component), the free one-particle step is
`U1 = S1 * C1` with per-site coin `[[4/5, -3i/5], [-3i/5, 4/5]]` and
component-0 shift site+1 / component-1 shift site-1.  `U2` is the 28x28
determinant-minor pair lift of `U1` (pairs `(i,j)`, `i<j`, lexicographic),
`T1` the one-site translation, `T2` its pair lift, and
`P K = (1/4) * sum_j (I^(-K*j)) * T2^j` the four momentum projectors.
`K2` is the supplied pair kick (identity except the exact 3-4-5 rotation
block on pair indices 0 = (0,1) and 13 = (2,3)); `V = U2 * K2` is the
composed interacting step (same conventions as the sibling
PairSpectrumFixture job - verified by a charpoly cross-check gate in the
seed oracle).

## Verified statement table (exact sympy oracle, 2026-07-11, gated by
## reproducing the composed-step factorization before anything else)

* translation symmetry: `[T1,U1] = 0`, `[T2,U2] = 0`, `T2^4 = 1`;
* `P K` are idempotent, sum to `1`, commute with `U2`;
  block dimensions `tr (P K) = 6, 8, 6, 8` for `K = 0,1,2,3`;
* block annihilators (minimal polynomials on each block - the free-level
  identification):
    K=0: `(U2 - 1)(U2 + 1) P0 = 0`                       (only exact +-1 levels)
    K=1: `(5U2^2 - 6U2 + 5)(5U2^2 + 6U2 + 5) P1 = 0`      (the two quadruples)
    K=2: `(U2 - 1)(U2 + 1)(25U2^2 + 14U2 + 25) P2 = 0`    (+-1 and the doubled-phase pair)
    K=3: same annihilator as K=1;
* exact multiplicities inside the blocks (spectral projector traces):
    `tr ((1 + U2)/2 * P0) = 4`  and  `tr ((1 - U2)/2 * P0) = 2`
    (K=0 carries four +1 and two -1 modes; (1 +- U2)/2 are genuine
    spectral projectors there because the K=0 annihilator is quadratic);
    at K=2 the +-1 projectors must also kill the phase pair
    `q(U2) = 25U2^2 + 14U2 + 25` (note `q(1) = 64`, `q(-1) = 36`):
    `Rplus  = q(U2) * (U2 + 1) / 128`,  `Rminus = q(U2) * (1 - U2) / 72`,
    `Rpair = 1 - Rplus - Rminus`, and
    `tr (Rplus * P2) = 2`, `tr (Rminus * P2) = 2`, `tr (Rpair * P2) = 2`,
    with `Rplus * P2` idempotent (a genuine projector);
  so the free two-particle spectrum is
  `(lam-1)^6 (lam+1)^4 (25lam^2+14lam+25) (5lam^2-6lam+5)^4 (5lam^2+6lam+5)^4`
  distributed as: all +-1 levels at K=0 (4+2) and K=2 (2+2), the
  doubled-phase pair `((3+4i)/5)^2` at K=2, quadruples at K=1,3;
* the kick BREAKS the symmetry (the composed automaton has no exact
  momentum decomposition): `(T2*K2 - K2*T2) 0 0 = 3i/5` and
  `(T2*V - V*T2) 9 13 = 3i/5`;
* the kick support is exactly momentum-neutral: for `e01` the pair-basis
  vector at index 0, `(P K e01)^H (P K e01) = 1/4` for every `K` - the
  local pair kick weights all four momentum sectors equally;
* charpoly identification: `charpoly U2` equals the monic block product
  above (native_decide acceptable for THIS item only, loudly disclosed in
  the docstring, mirroring the sibling job's T3; everything else should
  be kernel via simp/norm_num/decide on explicit entries or `ring`).

## Discipline

Statements must not be weakened.  Complex entries are exact Gaussian
rationals; equalities reduce to rational identities.  If any displayed
constant fails to verify, prove the corrected single identity, name it,
and stop (kill condition) - do not silently repair.  Off-diagonal
convention: `Matrix.mul` is row-times-column; pair index order is
lexicographic on `(i,j)`, `i < j`, so index 0 = (0,1), 13 = (2,3).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairMomentumBlocks

open Matrix Complex

abbrev M8 := Matrix (Fin 8) (Fin 8) ℂ
abbrev M28 := Matrix (Fin 28) (Fin 28) ℂ

/-- Mode index: site `s` (0..3), component `c` (0..1) -> `2*s + c`. -/
def modeIdx (s : Fin 4) (c : Fin 2) : Fin 8 := ⟨2 * s.1 + c.1, by omega⟩

/-- One-particle shift: component 0 advances the site, component 1 retreats. -/
def S1 : M8 := Matrix.of fun i j =>
  if (i.1 % 2 = 0 ∧ j.1 % 2 = 0 ∧ i.1 / 2 = (j.1 / 2 + 1) % 4)
   ∨ (i.1 % 2 = 1 ∧ j.1 % 2 = 1 ∧ i.1 / 2 = (j.1 / 2 + 3) % 4)
  then (1 : ℂ) else 0

/-- Site-diagonal complex coin `[[4/5, -3i/5], [-3i/5, 4/5]]`. -/
def C1 : M8 := Matrix.of fun i j =>
  if i.1 / 2 = j.1 / 2 then
    (if i.1 % 2 = j.1 % 2 then (4/5 : ℂ) else (-Complex.I * (3/5)))
  else 0

/-- The free one-particle ring step. -/
def U1 : M8 := S1 * C1

/-- One-site translation (both components advance). -/
def T1 : M8 := Matrix.of fun i j =>
  if i.1 % 2 = j.1 % 2 ∧ i.1 / 2 = (j.1 / 2 + 1) % 4 then (1 : ℂ) else 0

/-- Lexicographic enumeration of pairs `(i,j)`, `i < j`, of `Fin 8`:
index `k` -> the `k`-th pair.  (Explicit table to keep everything
computable and convention-pinned.) -/
def pairFst : Fin 28 → Fin 8 :=
  ![0,0,0,0,0,0,0, 1,1,1,1,1,1, 2,2,2,2,2, 3,3,3,3, 4,4,4, 5,5, 6]
def pairSnd : Fin 28 → Fin 8 :=
  ![1,2,3,4,5,6,7, 2,3,4,5,6,7, 3,4,5,6,7, 4,5,6,7, 5,6,7, 6,7, 7]

/-- The determinant-minor pair lift of an 8x8 matrix. -/
def minorLift (A : M8) : M28 := Matrix.of fun r c =>
  A (pairFst r) (pairFst c) * A (pairSnd r) (pairSnd c)
    - A (pairFst r) (pairSnd c) * A (pairSnd r) (pairFst c)

/-- The free pair lift. -/
def U2 : M28 := minorLift U1
/-- The pair-lifted translation. -/
def T2 : M28 := minorLift T1

/-- The supplied pair kick: identity except the exact 3-4-5 rotation on
pair indices 0 = (0,1) and 13 = (2,3). -/
def K2 : M28 := Matrix.of fun r c =>
  if r = 0 ∧ c = 0 then (4/5 : ℂ)
  else if r = 0 ∧ c = 13 then -Complex.I * (3/5)
  else if r = 13 ∧ c = 0 then -Complex.I * (3/5)
  else if r = 13 ∧ c = 13 then (4/5 : ℂ)
  else if r = c then 1 else 0

/-- The composed interacting step. -/
def V : M28 := U2 * K2

/-- Momentum projectors `P K = (1/4) sum_j I^(-K j) T2^j`. -/
def P (K : Fin 4) : M28 :=
  (1/4 : ℂ) • (1 + (Complex.I)^(((4 - K.1) * 1) % 4) • T2
    + (Complex.I)^(((4 - K.1) * 2) % 4) • T2^2
    + (Complex.I)^(((4 - K.1) * 3) % 4) • T2^3)

/-! ## Transfer machinery: `ℂ` matrices are images of the computable `GR` model.

The entries of every matrix here are Gaussian rationals, so each matrix over `ℂ`
is the entrywise image, under the injective ring homomorphism `GR.toC`, of the
corresponding matrix over the computable model `GR` (file `GRCore`).  All matrix
identities therefore transfer, fully kernel-checked, from the `native_decide`-
verified `GR` facts (file `GRFacts`). -/

section Transfer
open GR

/-- Entrywise map `GR → ℂ` on 8×8 matrices. -/
noncomputable abbrev Φ8 : N8 →+* M8 := GR.toC.mapMatrix
/-- Entrywise map `GR → ℂ` on 28×28 matrices. -/
noncomputable abbrev Φ : N28 →+* M28 := GR.toC.mapMatrix

theorem map_entry (M : N28) (i j : Fin 28) : (Φ M) i j = GR.toC (M i j) := by
  simp [Φ, RingHom.mapMatrix_apply, Matrix.map_apply]
theorem map_entry8 (M : N8) (i j : Fin 8) : (Φ8 M) i j = GR.toC (M i j) := by
  simp [Φ8, RingHom.mapMatrix_apply, Matrix.map_apply]

theorem phi_smul (c : GR) (M : N28) : Φ (c • M) = GR.toC c • Φ M := by
  ext i j
  simp only [map_entry, Matrix.smul_apply, smul_eq_mul, map_mul]

theorem phi_trace (M : N28) : (Φ M).trace = GR.toC (M.trace) := by
  simp only [Matrix.trace, Matrix.diag, map_sum]
  exact Finset.sum_congr rfl (fun i _ => map_entry M i i)

theorem phi_mulVec (M : N28) (v : Fin 28 → GR) :
    Φ M *ᵥ (fun i => GR.toC (v i)) = fun i => GR.toC ((M *ᵥ v) i) := by
  funext i
  have hL : (Φ M *ᵥ (fun i => GR.toC (v i))) i = ∑ j, (Φ M) i j * GR.toC (v j) := by
    simp [Matrix.mulVec, dotProduct]
  have hR : (M *ᵥ v) i = ∑ j, M i j * v j := by simp [Matrix.mulVec, dotProduct]
  rw [hL, hR, map_sum]
  exact Finset.sum_congr rfl (fun j _ => by rw [map_entry, map_mul])

/-- Scalar-constant images. -/
@[simp] theorem toC_mk_re (x : ℚ) : GR.toC ⟨x, 0⟩ = (x : ℂ) := by simp [GR.toC]
theorem toC_gI : GR.toC gI = Complex.I := by simp [gI, GR.toC]

/-! ### Base correspondences. -/

theorem hcpf : ∀ r : Fin 28, pairFst r = pf r := by decide
theorem hcps : ∀ r : Fin 28, pairSnd r = ps r := by decide

set_option maxHeartbeats 1600000 in
theorem hcU1 : U1 = Φ8 U1g := by
  ext i j
  rw [map_entry8]
  fin_cases i <;> fin_cases j <;>
    simp [U1, S1, C1, U1g, gA, gB, Matrix.mul_apply, Fin.sum_univ_succ, GR.toC] <;> norm_num <;> ring

set_option maxHeartbeats 1600000 in
theorem hcT1 : T1 = Φ8 T1g := by
  ext i j
  rw [map_entry8]
  fin_cases i <;> fin_cases j <;> simp [T1, T1g, GR.toC]

set_option maxHeartbeats 1600000 in
theorem hcU2 : U2 = Φ U2g := by
  have hU1e : ∀ i j, U1 i j = GR.toC (U1g i j) := fun i j => by rw [hcU1]; exact map_entry8 U1g i j
  ext r c
  rw [map_entry]
  simp only [U2, minorLift, U2g, minorLiftG, Matrix.of_apply, map_sub, map_mul, hcpf, hcps, hU1e]

set_option maxHeartbeats 1600000 in
theorem hcT2 : T2 = Φ T2g := by
  have hT1e : ∀ i j, T1 i j = GR.toC (T1g i j) := fun i j => by rw [hcT1]; exact map_entry8 T1g i j
  ext r c
  rw [map_entry]
  simp only [T2, minorLift, T2g, minorLiftG, Matrix.of_apply, map_sub, map_mul, hcpf, hcps, hT1e]

theorem hcP (K : Fin 4) : P K = Φ (Pg K) := by
  rw [P, Pg]
  simp only [phi_smul, map_add, map_one, map_pow, ← hcT2, toC_gI, toC_mk_re]
  push_cast
  norm_num

theorem hcK2 : K2 = Φ K2g := by
  ext r c
  rw [map_entry]
  simp only [K2, K2g, Matrix.of_apply, apply_ite GR.toC]
  split_ifs <;> simp [gA, gB, GR.toC] <;> norm_num <;> ring

theorem hcV : V = Φ Vg := by
  rw [V, Vg, map_mul, ← hcU2, ← hcK2]

theorem toC_conj (z : GR) : star (GR.toC z) = GR.toC (conjG z) := by
  simp [GR.toC, conjG]

end Transfer

/-! ## T1 - the momentum kit -/

set_option maxHeartbeats 4000000 in
theorem one_particle_translation_invariance : T1 * U1 = U1 * T1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [T1, U1, S1, C1, Matrix.mul_apply, Fin.sum_univ_succ]

theorem pair_translation_order_four : T2^4 = 1 := by
  rw [hcT2, ← map_pow, gr_T2pow4, map_one]

theorem pair_translation_invariance : T2 * U2 = U2 * T2 := by
  rw [hcT2, hcU2, ← map_mul, gr_comm, map_mul]

theorem momentum_projector_idem (K : Fin 4) : P K * P K = P K := by
  rw [hcP, ← map_mul, gr_idem]

theorem momentum_projector_complete : P 0 + P 1 + P 2 + P 3 = 1 := by
  simp only [hcP]
  rw [← map_add, ← map_add, ← map_add, gr_complete, map_one]

theorem momentum_projector_commutes (K : Fin 4) : P K * U2 = U2 * P K := by
  rw [hcP, hcU2, ← map_mul, gr_commutes, map_mul]

theorem momentum_block_dims :
    (P 0).trace = 6 ∧ (P 1).trace = 8 ∧ (P 2).trace = 6 ∧ (P 3).trace = 8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [hcP, phi_trace, gr_tr0, toC_mk_re]; norm_num
  · rw [hcP, phi_trace, gr_tr1, toC_mk_re]; norm_num
  · rw [hcP, phi_trace, gr_tr2, toC_mk_re]; norm_num
  · rw [hcP, phi_trace, gr_tr3, toC_mk_re]; norm_num

/-! ## T2 - block annihilators (the free-level identification) -/

theorem block_annihilator_K0 : (U2 - 1) * (U2 + 1) * P 0 = 0 := by
  have h := congrArg Φ gr_ann0
  simp only [map_mul, map_sub, map_add, map_one, map_zero, ← hcU2, ← hcP] at h
  exact h

theorem block_annihilator_K1 :
    (5 • U2^2 - 6 • U2 + 5 • (1 : M28)) * (5 • U2^2 + 6 • U2 + 5 • (1 : M28)) * P 1 = 0 := by
  have h := congrArg Φ gr_ann1
  simp only [map_mul, map_sub, map_add, map_nsmul, map_pow, map_one, map_zero, ← hcU2, ← hcP] at h
  exact h

theorem block_annihilator_K2 :
    (U2 - 1) * (U2 + 1) * (25 • U2^2 + 14 • U2 + 25 • (1 : M28)) * P 2 = 0 := by
  have h := congrArg Φ gr_ann2
  simp only [map_mul, map_sub, map_add, map_nsmul, map_pow, map_one, map_zero, ← hcU2, ← hcP] at h
  exact h

theorem block_annihilator_K3 :
    (5 • U2^2 - 6 • U2 + 5 • (1 : M28)) * (5 • U2^2 + 6 • U2 + 5 • (1 : M28)) * P 3 = 0 := by
  have h := congrArg Φ gr_ann3
  simp only [map_mul, map_sub, map_add, map_nsmul, map_pow, map_one, map_zero, ← hcU2, ← hcP] at h
  exact h

/-! ## T3 - exact multiplicities inside the blocks -/

theorem plusminus_counts_K0 :
    (((1 + U2) * P 0).trace = 2 * 4) ∧ (((1 - U2) * P 0).trace = 2 * 2) := by
  refine ⟨?_, ?_⟩
  · have h := congrArg GR.toC gr_pm0a
    rw [← phi_trace] at h
    simp only [map_mul, map_add, map_one, ← hcU2, ← hcP] at h
    rw [h, toC_mk_re]; norm_num
  · have h := congrArg GR.toC gr_pm0b
    rw [← phi_trace] at h
    simp only [map_mul, map_sub, map_one, ← hcU2, ← hcP] at h
    rw [h, toC_mk_re]; norm_num

/-- K=2 spectral projectors (the +-1 projectors must annihilate the
doubled-phase pair; `q(1) = 64`, `q(-1) = 36`). -/
def Rplus : M28 := (128 : ℂ)⁻¹ • ((25 • U2^2 + 14 • U2 + 25 • (1 : M28)) * (U2 + 1))
def Rminus : M28 := (72 : ℂ)⁻¹ • ((25 • U2^2 + 14 • U2 + 25 • (1 : M28)) * (1 - U2))

theorem hcRplus : Rplus = Φ Rplus_g := by
  rw [Rplus, Rplus_g, phi_smul]
  simp only [map_mul, map_add, map_nsmul, map_pow, map_one, ← hcU2, toC_mk_re]
  norm_num

theorem hcRminus : Rminus = Φ Rminus_g := by
  rw [Rminus, Rminus_g, phi_smul]
  simp only [map_mul, map_add, map_sub, map_nsmul, map_pow, map_one, ← hcU2, toC_mk_re]
  norm_num

theorem plusminus_counts_K2 :
    ((Rplus * P 2).trace = 2) ∧ ((Rminus * P 2).trace = 2)
      ∧ (((1 - Rplus - Rminus) * P 2).trace = 2) := by
  refine ⟨?_, ?_, ?_⟩
  · have h := congrArg GR.toC gr_rp
    rw [← phi_trace] at h
    simp only [map_mul, ← hcRplus, ← hcP] at h
    rw [h, toC_mk_re]; norm_num
  · have h := congrArg GR.toC gr_rm
    rw [← phi_trace] at h
    simp only [map_mul, ← hcRminus, ← hcP] at h
    rw [h, toC_mk_re]; norm_num
  · have h := congrArg GR.toC gr_rpair
    rw [← phi_trace] at h
    simp only [map_mul, map_sub, map_one, ← hcRplus, ← hcRminus, ← hcP] at h
    rw [h, toC_mk_re]; norm_num

theorem Rplus_P2_projector : (Rplus * P 2) * (Rplus * P 2) = Rplus * P 2 := by
  rw [hcRplus, hcP]
  simp only [← map_mul]
  rw [gr_rp2idem]

/-! ## T4 - the kick breaks translation, but is momentum-neutral -/

theorem kick_breaks_translation : (T2 * K2 - K2 * T2) 0 0 = Complex.I * (3/5) := by
  have h := congrArg GR.toC gr_kick1
  rw [← map_entry] at h
  simp only [map_sub, map_mul, ← hcT2, ← hcK2] at h
  rw [h, GR.toC_apply]; push_cast; ring

theorem composed_breaks_translation : (T2 * V - V * T2) 9 13 = Complex.I * (3/5) := by
  have h := congrArg GR.toC gr_kick2
  rw [← map_entry] at h
  simp only [map_sub, map_mul, ← hcT2, ← hcV] at h
  rw [h, GR.toC_apply]; push_cast; ring

/-- The kick-support basis state `e01` weights all four momentum sectors
equally: `|P K e01|^2 = 1/4` for every `K`.  Stated entrywise via the
standard basis vector. -/
theorem kick_support_momentum_neutral (K : Fin 4) :
    (star (P K *ᵥ (Pi.single 0 1 : Fin 28 → ℂ)) ⬝ᵥ (P K *ᵥ (Pi.single 0 1 : Fin 28 → ℂ)))
      = 1/4 := by
  have he : (Pi.single 0 1 : Fin 28 → ℂ) = fun i => GR.toC (egv i) := by
    funext i; simp only [egv, Pi.single_apply]; split_ifs <;> simp
  rw [he, hcP, phi_mulVec, dotProduct]
  simp only [Pi.star_apply]
  have hsum : (∑ i, star (GR.toC ((Pg K *ᵥ egv) i)) * GR.toC ((Pg K *ᵥ egv) i))
      = GR.toC (∑ i, conjG ((Pg K *ᵥ egv) i) * (Pg K *ᵥ egv) i) := by
    rw [map_sum]
    exact Finset.sum_congr rfl (fun i _ => by rw [toC_conj, ← map_mul])
  rw [hsum, gr_neutral, toC_mk_re]; norm_num

/-! ## T5 - charpoly identification (native_decide acceptable HERE only,
disclosed) -/

/-- Factoring a monic quadratic into two linear factors. -/
theorem key_quad (r s : ℂ) :
    (Polynomial.X - Polynomial.C r) * (Polynomial.X - Polynomial.C s)
      = Polynomial.X ^ 2 - Polynomial.C (r + s) * Polynomial.X + Polynomial.C (r * s) := by
  rw [Polynomial.C_add, Polynomial.C_mul]; ring

open Polynomial in
/-- The `(-7±24i)/25` conjugate pair. -/
theorem quad1c : (X ^ 2 + C (14/25 : ℂ) * X + 1)
    = (X - C ((-7 + 24*Complex.I)/25)) * (X - C ((-7 - 24*Complex.I)/25)) := by
  have hI : Complex.I ^ 2 = -1 := Complex.I_sq
  have hsum : ((-7 + 24*Complex.I)/25 : ℂ) + (-7 - 24*Complex.I)/25 = -(14/25) := by ring
  have hprod : ((-7 + 24*Complex.I)/25 : ℂ) * ((-7 - 24*Complex.I)/25) = 1 := by
    rw [div_mul_div_comm,
      show ((-7 + 24*Complex.I) * (-7 - 24*Complex.I) : ℂ) = 625 by linear_combination (-576:ℂ)*hI]
    norm_num
  rw [key_quad, hsum, hprod, C_neg, map_one]; ring

open Polynomial in
/-- The `(3±4i)/5` conjugate pair. -/
theorem quad2c : (X ^ 2 - C (6/5 : ℂ) * X + 1)
    = (X - C ((3 + 4*Complex.I)/5)) * (X - C ((3 - 4*Complex.I)/5)) := by
  have hI : Complex.I ^ 2 = -1 := Complex.I_sq
  have hsum : ((3 + 4*Complex.I)/5 : ℂ) + (3 - 4*Complex.I)/5 = 6/5 := by ring
  have hprod : ((3 + 4*Complex.I)/5 : ℂ) * ((3 - 4*Complex.I)/5) = 1 := by
    rw [div_mul_div_comm,
      show ((3 + 4*Complex.I) * (3 - 4*Complex.I) : ℂ) = 25 by linear_combination (-16:ℂ)*hI]
    norm_num
  rw [key_quad, hsum, hprod, map_one]

open Polynomial in
/-- The `(-3±4i)/5` conjugate pair. -/
theorem quad3c : (X ^ 2 + C (6/5 : ℂ) * X + 1)
    = (X - C ((-3 + 4*Complex.I)/5)) * (X - C ((-3 - 4*Complex.I)/5)) := by
  have hI : Complex.I ^ 2 = -1 := Complex.I_sq
  have hsum : ((-3 + 4*Complex.I)/5 : ℂ) + (-3 - 4*Complex.I)/5 = -(6/5) := by ring
  have hprod : ((-3 + 4*Complex.I)/5 : ℂ) * ((-3 - 4*Complex.I)/5) = 1 := by
    rw [div_mul_div_comm,
      show ((-3 + 4*Complex.I) * (-3 - 4*Complex.I) : ℂ) = 25 by linear_combination (-16:ℂ)*hI]
    norm_num
  rw [key_quad, hsum, hprod, C_neg, map_one]; ring

/-- Values of `GR.toC` on the eigenvalue constants. -/
theorem tv1  : GR.toC ⟨1,0⟩ = (1 : ℂ) := by simp [GR.toC_apply]
theorem tvm1 : GR.toC ⟨-1,0⟩ = (-1 : ℂ) := by simp [GR.toC_apply]
theorem tv3a : GR.toC ⟨-7/25,24/25⟩ = ((-7 + 24*Complex.I)/25 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring
theorem tv3b : GR.toC ⟨-7/25,-24/25⟩ = ((-7 - 24*Complex.I)/25 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring
theorem tv2a : GR.toC ⟨3/5,4/5⟩ = ((3 + 4*Complex.I)/5 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring
theorem tv2b : GR.toC ⟨3/5,-4/5⟩ = ((3 - 4*Complex.I)/5 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring
theorem tv4a : GR.toC ⟨-3/5,4/5⟩ = ((-3 + 4*Complex.I)/5 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring
theorem tv4b : GR.toC ⟨-3/5,-4/5⟩ = ((-3 - 4*Complex.I)/5 : ℂ) := by
  simp only [GR.toC_apply]; push_cast; ring

theorem charpoly_U2_block_product :
    U2.charpoly =
      (Polynomial.X - 1)^6 * (Polynomial.X + 1)^4
        * (Polynomial.X^2 + Polynomial.C (14/25 : ℂ) * Polynomial.X + 1)
        * (Polynomial.X^2 - Polynomial.C (6/5 : ℂ) * Polynomial.X + 1)^4
        * (Polynomial.X^2 + Polynomial.C (6/5 : ℂ) * Polynomial.X + 1)^4 := by
  have hmap : U2 = U2g.map (⇑GR.toC) := by rw [hcU2, RingHom.mapMatrix_apply]
  rw [hmap, Matrix.charpoly_map, U2g_charpoly_prod, Polynomial.map_prod]
  simp only [Polynomial.map_sub, Polynomial.map_X, Polynomial.map_C]
  simp only [Fin.prod_univ_succ, Fin.prod_univ_zero, dgv, Matrix.cons_val_zero,
    Matrix.cons_val_succ, Matrix.head_cons, mul_one,
    tv1, tvm1, tv3a, tv3b, tv2a, tv2b, tv4a, tv4b, map_one, Polynomial.C_neg]
  rw [quad1c, quad2c, quad3c]
  simp only [pow_succ, pow_zero, one_mul,
    show (Polynomial.X + 1 : Polynomial ℂ) = Polynomial.X - -1 from by ring]
  ac_rfl

end PhysicsSM.Draft.NullEdge.PairMomentumBlocks
