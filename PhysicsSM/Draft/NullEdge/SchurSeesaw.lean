/-
# Finite seesaw: small mass from protected leakage through a heavy hidden block

The null-edge program integrates out hidden structure by the Schur complement:
coupling a visible block to a hidden block `M` and eliminating the hidden register
produces an effective visible operator `A − B M⁻¹ Bᴴ`. When a visible mode is
protected (would be exactly massless in isolation, `A *ᵥ v = 0`) but the protection
is weakly violated through a coupling `B` to a heavy hidden block `M`, the induced
effective mass is **suppressed** by `M⁻¹`:

    m_eff  ~  ‖B‖² / ‖M‖   →  0   as the hidden scale ‖M‖ → ∞.

This is the finite information-theoretic **seesaw**: the smallness is not a tuning —
it is the resolvent suppression of a heavy hidden channel. Candidate mechanism for
neutrino lightness (a protected mode + suppressed hidden leakage).

Throughout, the (squared) Euclidean norm of a vector `w : n → ℂ` is written
`(star w ⬝ᵥ w).re = ∑ i, ‖w i‖²`, and the quadratic form of a matrix `X` at `w` is
`star w ⬝ᵥ X *ᵥ w` (`⟨w, X w⟩`).  The least eigenvalue of the positive-definite
hidden block `M` is `leastEigen hM = λ_min(M) > 0`.

## Targets

- `seesaw_effective_mass_eq`: on a protected mode `v` (`A *ᵥ v = 0`) the induced
  effective mass is `⟨v, (A − B M⁻¹ Bᴴ) v⟩ = −⟨M⁻¹ (Bᴴ v), (Bᴴ v)⟩`.
- `resolvent_quadratic_bound`: the resolvent estimate `⟨w, M⁻¹ w⟩ ≤ ‖w‖² / λ_min(M)`.
- `seesaw_suppression`: the induced effective mass on the protected mode is bounded by
  `‖Bᴴ v‖² / λ_min(M)`, hence → 0 as `λ_min(M) → ∞` (heavy hidden block ⇒ tiny visible
  mass).
- `seesaw_zero_iff_no_overlap`: the induced mass vanishes iff the protected mode has
  no overlap with the hidden coupling (`Bᴴ v = 0`) — protection is exact iff the
  leakage channel is closed.
-/

import Mathlib

open Matrix
open scoped ComplexOrder

namespace PhysicsSM.Draft.NullEdge.SchurSeesaw

variable {nv nh : Type*} [Fintype nv] [DecidableEq nv] [Fintype nh] [DecidableEq nh]

/-- The least eigenvalue `λ_min(M)` of a positive-definite hidden block `M`. -/
noncomputable def leastEigen [Nonempty nh] {M : Matrix nh nh ℂ} (hM : M.PosDef) : ℝ :=
  Finset.univ.inf' Finset.univ_nonempty hM.1.eigenvalues

/-- Every eigenvalue of `M` is at least `λ_min(M)`. -/
lemma leastEigen_le [Nonempty nh] {M : Matrix nh nh ℂ} (hM : M.PosDef) (i : nh) :
    leastEigen hM ≤ hM.1.eigenvalues i :=
  Finset.inf'_le _ (Finset.mem_univ i)

/-
`λ_min(M) > 0` for positive-definite `M`.
-/
lemma leastEigen_pos [Nonempty nh] {M : Matrix nh nh ℂ} (hM : M.PosDef) :
    0 < leastEigen hM := by
  -- `leastEigen hM = Finset.univ.inf' Finset.univ_nonempty hM.1.eigenvalues`. By `Finset.lt_inf'_iff`, it suffices to show `0 < hM.1.eigenvalues i` for every `i`, which is `Matrix.PosDef.eigenvalues_pos hM i`. So: `rw [leastEigen, Finset.lt_inf'_iff]; intro i _; exact hM.eigenvalues_pos i`.
  rw [leastEigen, Finset.lt_inf'_iff]; intro i _; exact hM.eigenvalues_pos i

/-
**Resolvent estimate.** For positive-definite `M` and any hidden vector `w`,
`⟨w, M⁻¹ w⟩ ≤ ‖w‖² / λ_min(M)`.
-/
lemma resolvent_quadratic_bound [Nonempty nh] {M : Matrix nh nh ℂ} (hM : M.PosDef)
    (w : nh → ℂ) :
    (star w ⬝ᵥ M⁻¹ *ᵥ w).re ≤ (star w ⬝ᵥ w).re / leastEigen hM := by
  -- By the properties of the eigenvalues and eigenvectors, we can expand $w$ in the orthonormal eigenbasis of $M$.
  obtain ⟨C, hC⟩ : ∃ (C : nh → ℂ), (∑ i, C i • hM.1.eigenvectorBasis i) = w := by
    have h_decomp : ∀ w : EuclideanSpace ℂ nh, ∃ C : nh → ℂ, (∑ i, C i • hM.1.eigenvectorBasis i) = w := by
      intro w
      use fun i => inner ℂ (hM.1.eigenvectorBasis i) w;
      convert ( hM.1.eigenvectorBasis.sum_repr w );
      simp +decide [ OrthonormalBasis.repr_apply_apply ];
    exact?;
  -- By the properties of the eigenvalues and eigenvectors, we can expand $M^{-1} w$ in the orthonormal eigenbasis of $M$.
  have h_expand_inv : M⁻¹.mulVec w = ∑ i, (hM.1.eigenvalues i)⁻¹ • C i • hM.1.eigenvectorBasis i := by
    have h_inv_eigen : ∀ i, M⁻¹.mulVec (hM.1.eigenvectorBasis i) = (hM.1.eigenvalues i)⁻¹ • hM.1.eigenvectorBasis i := by
      intro i
      have h_inv_eigen : M.mulVec ((hM.1.eigenvalues i)⁻¹ • hM.1.eigenvectorBasis i) = hM.1.eigenvectorBasis i := by
        have := hM.1.mulVec_eigenvectorBasis i;
        rw [ Matrix.mulVec_smul, this, smul_smul, inv_mul_cancel₀ ( ne_of_gt ( hM.eigenvalues_pos i ) ), one_smul ];
      rw [ ← h_inv_eigen, Matrix.mulVec_mulVec ];
      rw [ Matrix.nonsing_inv_mul _ ];
      · aesop;
      · exact isUnit_iff_ne_zero.mpr hM.det_pos.ne';
    simp +decide [ ← hC, ← h_inv_eigen, Matrix.mulVec_smul, Finset.mul_sum _ _ _ ];
    induction' ( Finset.univ : Finset nh ) using Finset.induction <;> simp_all +decide [ Finset.sum_insert, Matrix.mulVec_add, Matrix.mulVec_smul ];
    rw [ SMulCommClass.smul_comm ];
  -- By the properties of the eigenvalues and eigenvectors, we can expand $w$ and $M^{-1} w$ in the orthonormal eigenbasis of $M$.
  have h_expand : (star w ⬝ᵥ M⁻¹ *ᵥ w).re = ∑ i, (hM.1.eigenvalues i)⁻¹ * ‖C i‖^2 ∧ (star w ⬝ᵥ w).re = ∑ i, ‖C i‖^2 := by
    have h_expand : ∀ (u v : nh → ℂ), (star (∑ i, u i • hM.1.eigenvectorBasis i) ⬝ᵥ (∑ i, v i • hM.1.eigenvectorBasis i)).re = ∑ i, (star (u i) * v i).re := by
      intro u v
      have h_expand : (star (∑ i, u i • hM.1.eigenvectorBasis i) ⬝ᵥ (∑ i, v i • hM.1.eigenvectorBasis i)) = ∑ i, star (u i) * v i := by
        have h_expand : ∀ (i j : nh), (star (hM.1.eigenvectorBasis i) ⬝ᵥ hM.1.eigenvectorBasis j) = if i = j then 1 else 0 := by
          intro i j; have := hM.1.eigenvectorBasis.orthonormal; simp_all +decide [ orthonormal_iff_ite ] ;
          convert this i j using 1;
          exact Finset.sum_congr rfl fun _ _ => mul_comm _ _;
        simp +decide [ dotProduct, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_left_comm, h_expand ];
        simp +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, ← Finset.sum_comm, h_expand ];
        simp_all +decide [ dotProduct, mul_comm ];
      rw [ h_expand, Complex.re_sum ];
    simp_all +decide;
    rw [ ← hC ];
    convert And.intro ( h_expand C ( fun i => ( hM.1.eigenvalues i ) ⁻¹ * C i ) ) ( h_expand C C ) using 2 <;> simp +decide [ Complex.normSq, Complex.sq_norm ] <;> ring;
    · simp +decide [ mul_assoc, mul_comm, mul_left_comm, Algebra.smul_def ];
      congr! 3;
      ext; simp +decide [ Algebra.algebraMap_eq_smul_one ];
    · ac_rfl;
  -- Since $leastEigen hM$ is the smallest eigenvalue of $M$, we have $(hM.1.eigenvalues i)⁻¹ ≤ (leastEigen hM)⁻¹$ for all $i$.
  have h_inv_le : ∀ i, (hM.1.eigenvalues i)⁻¹ ≤ (leastEigen hM)⁻¹ := by
    exact fun i => inv_anti₀ ( leastEigen_pos hM ) ( leastEigen_le hM i );
  simp_all +decide [ div_eq_inv_mul, Finset.mul_sum _ _ _ ];
  exact Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_right ( h_inv_le i ) ( sq_nonneg _ )

/-
**Effective mass on the protected mode.** With `A *ᵥ v = 0`, integrating out the
hidden block gives `⟨v, (A − B M⁻¹ Bᴴ) v⟩ = −⟨Bᴴ v, M⁻¹ (Bᴴ v)⟩`.
-/
omit [DecidableEq nv] in
lemma seesaw_effective_mass_eq
    (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
    (v : nv → ℂ) (hprot : A *ᵥ v = 0) :
    star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v
      = - (star (Bᴴ *ᵥ v) ⬝ᵥ M⁻¹ *ᵥ (Bᴴ *ᵥ v)) := by
  simp +decide [ Matrix.sub_mulVec, hprot ]
  simp +decide only [star_mulVec]
  simp +decide [ Matrix.mul_assoc, Matrix.dotProduct_mulVec ]

/-
**Seesaw suppression (TARGET).** For a Hermitian visible block `A`, coupling `B`
to a positive-definite hidden block `M`, the effective mass induced on a protected
visible mode `v` (with `A *ᵥ v = 0`) by integrating out the hidden block, namely
`⟨v, (A − B M⁻¹ Bᴴ) v⟩`, has magnitude bounded by `‖Bᴴ v‖² / λ_min(M)` — suppressed
by the heavy hidden scale, so `→ 0` as `λ_min(M) → ∞`.

(The Hermitian hypothesis on `A` is not needed for this quantity, since `A *ᵥ v = 0`
kills the visible contribution; the bound is a pure resolvent estimate.)
-/
omit [DecidableEq nv] in
theorem seesaw_suppression [Nonempty nh]
    (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
    (hM : M.PosDef) (v : nv → ℂ) (hprot : A *ᵥ v = 0) :
    |(star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re|
      ≤ (star (Bᴴ *ᵥ v) ⬝ᵥ (Bᴴ *ᵥ v)).re / leastEigen hM := by
  -- By `seesaw_effective_mass_eq A B M v hprot`, `star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = -(star w ⬝ᵥ M⁻¹ *ᵥ w)`, so its real part is `-(star w ⬝ᵥ M⁻¹ *ᵥ w).re`.
  have h_real_part : (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re = -(star (Bᴴ *ᵥ v) ⬝ᵥ M⁻¹ *ᵥ (Bᴴ *ᵥ v)).re := by
    convert congr_arg Complex.re ( seesaw_effective_mass_eq A B M v hprot ) using 1;
  convert resolvent_quadratic_bound hM ( Bᴴ *ᵥ v ) using 1;
  rw [ h_real_part, abs_neg, abs_of_nonneg ];
  convert Matrix.PosSemidef.re_dotProduct_nonneg ( hM.inv.posSemidef ) ( Bᴴ *ᵥ v ) using 1

/-
**Exact protection (TARGET).** The induced effective mass on the protected mode
vanishes iff the protected mode has no overlap with the hidden coupling `Bᴴ v = 0`
(the leakage channel is closed).
-/
omit [DecidableEq nv] in
theorem seesaw_zero_iff_no_overlap
    (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
    (hM : M.PosDef) (v : nv → ℂ) (hprot : A *ᵥ v = 0) :
    star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0 := by
  constructor <;> intro H <;> simp_all +decide [ Matrix.mul_assoc ]
  · contrapose! H with h;
    -- By the properties of the inner product and the positive definiteness of $M^{-1}$, we have:
    have h_inner_pos : 0 < Complex.re (star (Bᴴ *ᵥ v) ⬝ᵥ (M⁻¹ *ᵥ (Bᴴ *ᵥ v))) := by
      convert hM.inv.re_dotProduct_pos h using 1;
    have := seesaw_effective_mass_eq A B M v hprot; simp_all +decide [ Matrix.mul_assoc ] ;
    exact fun h' => h_inner_pos.ne' <| by simp +decide [ h' ] ;
  · simp_all +decide [ Matrix.sub_mulVec, ← Matrix.mulVec_mulVec ]

end PhysicsSM.Draft.NullEdge.SchurSeesaw

-- Axiom footprint checks: each of the delivered results is kernel-checked and depends
-- only on `[propext, Classical.choice, Quot.sound]` (no `sorry`, no extra axioms).
#print axioms PhysicsSM.Draft.NullEdge.SchurSeesaw.resolvent_quadratic_bound
#print axioms PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_effective_mass_eq
#print axioms PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_suppression
#print axioms PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_zero_iff_no_overlap
