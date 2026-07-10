import Mathlib

/-!
# Frame-blindness forces the Poisson (everpresent) branch — a finite theorem

This file makes the finite core of the following statement a theorem.

*Context.* The everpresent-Lambda identification survives iff the pierced-null-edge count of a
region has EXTENSIVE variance (Poisson, `Var ~ N`); it dies if the count is HYPERUNIFORM
(sub-extensive, `Var ≪ N`). Poisson sprinkling is the unique Lorentz-invariant discretization: a
regular/hyperuniform point set picks out a preferred frame.

*Finite avatar.* We model a count ensemble by its rational covariance matrix
`C : Matrix (Fin k) (Fin k) ℚ`. FRAME-BLINDNESS is permutation invariance (`C` commutes with every
permutation matrix), the finite avatar of "no preferred direction". We prove, for the explicit case
`k = 3`:

* `perm_inv_iff_aI_bJ` — a symmetric rational `C` commutes with all permutation matrices **iff**
  `C = a • I + b • J` for rationals `a, b`.
* `suppressed_dir_is_uniform` — for `C = a • I + b • J` with `a ≠ 0`, the *only* suppressed
  direction (null eigenvector) is the uniform one; hence a frame-blind ensemble can only suppress
  the grand-total mode (and then `a + k·b = 0`).
* `nonuniform_suppression_breaks_symmetry` — an explicit symmetric PSD `C'` that suppresses the
  non-uniform direction `![1,-1,0]` but does **not** commute with the transposition `swap 0 2`
  (and is not of the form `a • I + b • J`): hyperuniformity in a regional mode costs a preferred
  covector.
* `frame_blind_everpresent_verdict` — the package.

*Honest scope.* Permutation invariance is the finite avatar of Lorentz frame-blindness; the
continuum "Lorentz-invariance ⇒ Poisson" step stays imported. This is the finite structural core of
"the hyperuniform branch costs a preferred frame."
-/

namespace LambdaFrameConstraint

open Matrix

/-- The all-ones `3 × 3` rational matrix `J`. -/
def Jm : Matrix (Fin 3) (Fin 3) ℚ := Matrix.of fun _ _ => 1

/-- The uniform (grand-total) direction. -/
def ones : Fin 3 → ℚ := fun _ => 1

/-- Finite frame-blindness: `C` commutes with every permutation matrix. -/
def FrameBlind (C : Matrix (Fin 3) (Fin 3) ℚ) : Prop :=
  ∀ σ : Equiv.Perm (Fin 3), C * σ.permMatrix ℚ = σ.permMatrix ℚ * C

/-- Entrywise formula for `(a • I + b • J) *ᵥ v`. -/
theorem mulVec_aIbJ_apply (a b : ℚ) (v : Fin 3 → ℚ) (i : Fin 3) :
    ((a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm).mulVec v) i
      = a * v i + b * (v 0 + v 1 + v 2) := by
  fin_cases i <;>
    simp [Jm, Matrix.mulVec, dotProduct, Fin.sum_univ_three, Matrix.one_apply] <;> ring

/-- Frame-blindness is equivalent to invariance of `C` under the simultaneous permutation of rows
and columns. -/
theorem frameBlind_iff_invariant (C : Matrix (Fin 3) (Fin 3) ℚ) :
    FrameBlind C ↔ ∀ (σ : Equiv.Perm (Fin 3)) i j, C (σ i) (σ j) = C i j := by
  constructor
  · intro h σ i j
    have h2 := h σ
    rw [PEquiv.mul_toMatrix_toPEquiv, PEquiv.toMatrix_toPEquiv_mul] at h2
    have h3 := congrFun (congrFun h2 i) (σ j)
    simpa [Matrix.submatrix_apply] using h3.symm
  · intro h σ
    rw [PEquiv.mul_toMatrix_toPEquiv, PEquiv.toMatrix_toPEquiv_mul]
    ext i j
    simp only [Matrix.submatrix_apply, id]
    simpa using (h σ i (σ.symm j)).symm

/-- **Target 1.** A symmetric rational `C` commutes with every permutation matrix **iff** it has
the frame-blind form `a • I + b • J`.

(The symmetry hypothesis `_hsymm` is requested in the statement; it turns out to be unnecessary,
since commuting with all permutation matrices already forces symmetry.) -/
theorem perm_inv_iff_aI_bJ (C : Matrix (Fin 3) (Fin 3) ℚ) (_hsymm : C.IsSymm) :
    FrameBlind C ↔ ∃ a b : ℚ, C = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm := by
  rw [frameBlind_iff_invariant]
  constructor
  · intro hinv
    refine ⟨C 0 0 - C 0 1, C 0 1, ?_⟩
    have d11 : C 1 1 = C 0 0 := by have := hinv (Equiv.swap 0 1) 0 0; simpa using this
    have d22 : C 2 2 = C 0 0 := by have := hinv (Equiv.swap 0 2) 0 0; simpa using this
    have o10 : C 1 0 = C 0 1 := by have := hinv (Equiv.swap 0 1) 0 1; simpa using this
    have o02 : C 0 2 = C 0 1 := by have := hinv (Equiv.swap 1 2) 0 1; simpa using this
    have o21 : C 2 1 = C 0 1 := by have := hinv (Equiv.swap 0 2) 0 1; simpa using this
    have o20 : C 2 0 = C 0 1 := by
      have h1 := hinv (Equiv.swap 0 2) 0 2; simp at h1
      rw [h1, o02]
    have o12 : C 1 2 = C 0 1 := by
      have h1 := hinv (Equiv.swap 1 2) 2 1; simp at h1
      rw [h1, o21]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp only [Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply, Jm, Matrix.of_apply,
        smul_eq_mul, Fin.isValue, Fin.zero_eta, Fin.mk_one] <;>
      norm_num [d11, d22, o10, o02, o21, o20, o12] <;>
      first
        | rfl | exact d11 | exact d22 | exact o10 | exact o02 | exact o21 | exact o20 | exact o12
  · rintro ⟨a, b, rfl⟩ σ i j
    simp only [Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply, Jm, Matrix.of_apply,
      smul_eq_mul]
    by_cases h : i = j <;> simp [h, Equiv.injective σ |>.eq_iff]

/-- **Target 2 (payload).** For a frame-blind covariance `C = a • I + b • J` with nondegenerate base
variance `a ≠ 0`, the only suppressed direction (null eigenvector) is the uniform one: if
`C *ᵥ v = 0` with `v ≠ 0`, then `v = (fun _ ↦ c)` for some `c ≠ 0`, and `a + 3·b = 0`.

I.e. a frame-blind ensemble can only suppress the grand-total mode. -/
theorem suppressed_dir_is_uniform (a b : ℚ) (ha : a ≠ 0) (v : Fin 3 → ℚ)
    (hv : (a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm).mulVec v = 0) (hne : v ≠ 0) :
    (∃ c : ℚ, c ≠ 0 ∧ v = fun _ => c) ∧ a + 3 * b = 0 := by
  have key : ∀ i : Fin 3, a * v i + b * (v 0 + v 1 + v 2) = 0 := by
    intro i; have := congrFun hv i; rw [mulVec_aIbJ_apply] at this; simpa using this
  have e0 := key 0; have e1 := key 1; have e2 := key 2
  have h01 : v 0 = v 1 := mul_left_cancel₀ ha (by linarith)
  have h02 : v 0 = v 2 := mul_left_cancel₀ ha (by linarith)
  have hvform : v = fun _ => v 0 := by
    funext i; fin_cases i
    · rfl
    · exact h01.symm
    · exact h02.symm
  refine ⟨⟨v 0, ?_, hvform⟩, ?_⟩
  · intro h0; apply hne; rw [hvform]; funext i; simp [h0]
  · have hz : v 0 * (a + 3 * b) = 0 := by rw [← h01, ← h02] at e0; linarith [e0]
    rcases mul_eq_zero.1 hz with h | h
    · exfalso; apply hne; rw [hvform]; funext i; simp [h]
    · exact h

/-- **Mandatory non-degeneracy witness (uniform mode).** With `a = 1`, `b = -1/3` (so `a + 3b = 0`)
the frame-blind matrix `1 • I + (-1/3) • J` annihilates the uniform direction `ones`. -/
theorem uniform_suppressed_witness :
    (1 + 3 * (-1/3 : ℚ) = 0) ∧
    ((1 : ℚ) • (1 : Matrix (Fin 3) (Fin 3) ℚ) + (-1/3 : ℚ) • Jm).mulVec ones = 0 := by
  refine ⟨by norm_num, ?_⟩
  funext i
  rw [mulVec_aIbJ_apply]
  simp [ones]
  norm_num

/-- The explicit symmetric PSD witness suppressing a non-uniform mode:
`C' = ![![1,1,0],![1,1,0],![0,0,0]]`, the rank-one covariance `w wᵀ` with `w = ![1,1,0]`. -/
def Cp : Matrix (Fin 3) (Fin 3) ℚ := !![1, 1, 0; 1, 1, 0; 0, 0, 0]

theorem Cp_isSymm : Cp.IsSymm := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

theorem Cp_posSemidef : Cp.PosSemidef := by
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  refine ⟨by ext i j; fin_cases i <;> fin_cases j <;> rfl, fun x => ?_⟩
  have hx : (star x) ⬝ᵥ Cp.mulVec x = (x 0 + x 1) * (x 0 + x 1) := by
    simp [Cp, Matrix.mulVec, dotProduct, Fin.sum_univ_three, star]; ring
  rw [hx]; exact mul_self_nonneg _

/-- `C'` suppresses the non-uniform direction `![1,-1,0]`. -/
theorem Cp_suppresses_nonuniform : Cp.mulVec ![1, -1, 0] = 0 := by
  funext i
  fin_cases i <;> simp [Cp, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-- `C'` does **not** commute with the transposition `swap 0 2`. -/
theorem Cp_not_frameBlind : ¬ FrameBlind Cp := by
  intro h
  have h3 := congrFun (congrFun (h (Equiv.swap 0 2)) 0) 1
  simp [Matrix.mul_apply, Cp, Equiv.Perm.permMatrix, Fin.sum_univ_three,
    Equiv.swap_apply_def] at h3

/-- `C'` is not of the frame-blind form `a • I + b • J` (its diagonal is non-constant). -/
theorem Cp_not_aIbJ : ¬ ∃ a b : ℚ, Cp = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm := by
  rintro ⟨a, b, h⟩
  have h00 := congrFun (congrFun h 0) 0
  have h22 := congrFun (congrFun h 2) 2
  simp [Cp, Jm] at h00 h22
  rw [← h00] at h22; norm_num at h22

/-- **Target 3 (payload).** There is an explicit symmetric PSD covariance `C'` that suppresses the
non-uniform direction `![1,-1,0]`, yet does **not** commute with the transposition `swap 0 2` (nor
does it equal any `a • I + b • J`): suppressing a regional (non-uniform) mode requires a preferred
covector and breaks frame-blindness. -/
theorem nonuniform_suppression_breaks_symmetry :
    ∃ C' : Matrix (Fin 3) (Fin 3) ℚ,
      C'.IsSymm ∧ C'.PosSemidef ∧ C'.mulVec ![1, -1, 0] = 0 ∧
      ¬ FrameBlind C' ∧ ¬ ∃ a b : ℚ, C' = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm :=
  ⟨Cp, Cp_isSymm, Cp_posSemidef, Cp_suppresses_nonuniform, Cp_not_frameBlind, Cp_not_aIbJ⟩

/-- **Target 4 (verdict).** Packaging.

* (A) A frame-blind (permutation-invariant) ensemble with nondegenerate base variance suppresses
  *at most* the uniform grand-total mode: every suppressed nonzero direction is uniform. Hence
  regional (non-uniform) variance stays extensive — the everpresent/Poisson branch.
* (B) Conversely, hyperuniform suppression of a regional (non-uniform) mode is realizable by a
  symmetric PSD covariance, but any such covariance fails frame-blindness (needs a preferred
  covector).

Honest scope: permutation invariance is the finite avatar of Lorentz frame-blindness; the continuum
Lorentz-invariance ⇒ Poisson step stays imported. -/
theorem frame_blind_everpresent_verdict :
    (∀ (C : Matrix (Fin 3) (Fin 3) ℚ), C.IsSymm → FrameBlind C →
        ∀ a b : ℚ, C = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • Jm → a ≠ 0 →
          ∀ v : Fin 3 → ℚ, C.mulVec v = 0 → v ≠ 0 → ∃ c : ℚ, c ≠ 0 ∧ v = fun _ => c) ∧
    (∃ C' : Matrix (Fin 3) (Fin 3) ℚ,
        C'.IsSymm ∧ C'.PosSemidef ∧ C'.mulVec ![1, -1, 0] = 0 ∧ ¬ FrameBlind C') := by
  refine ⟨?_, Cp, Cp_isSymm, Cp_posSemidef, Cp_suppresses_nonuniform, Cp_not_frameBlind⟩
  intro C _hsymm _hfb a b hC ha v hv hne
  subst hC
  exact (suppressed_dir_is_uniform a b ha v hv hne).1

-- Axiom-footprint checks on every headline result.
/-- info: 'LambdaFrameConstraint.perm_inv_iff_aI_bJ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms perm_inv_iff_aI_bJ
/-- info: 'LambdaFrameConstraint.suppressed_dir_is_uniform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms suppressed_dir_is_uniform
/-- info: 'LambdaFrameConstraint.uniform_suppressed_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms uniform_suppressed_witness
/-- info: 'LambdaFrameConstraint.nonuniform_suppression_breaks_symmetry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms nonuniform_suppression_breaks_symmetry
/-- info: 'LambdaFrameConstraint.frame_blind_everpresent_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms frame_blind_everpresent_verdict

end LambdaFrameConstraint
