/-
# S1-CC: existence of a `β`-eigenbasis of a complement of `range φ` in `ker φ`

This file provides the *genuine* (non-degenerate) linear-algebra core behind the
physical-sector presentation.  The physical Gauss/BRST charge is **nilpotent and
non-Hermitian** (self-adjoint only for the indefinite Krein form), so the only
structural hypotheses are:

* `β : V →ₗ[ℂ] V` is an involution (`β ∘ β = id`) — the `±1` closure grading;
* `φ : V →ₗ[ℂ] V` is nilpotent (`φ ∘ φ = 0`) — the BRST charge; and
* `β` and `φ` commute (`β ∘ φ = φ ∘ β`) — scalar-metric / diagonal grading.

The main result `eigenbasis_core` produces a finite family `v : κ → V` of
`β`-eigenvectors (with `±1` eigenvalues `e`) lying in `ker φ`, that is linearly
independent and whose span is a **complement of `range φ` inside `ker φ`**:
every kernel vector decomposes as `∑ w j • v j + φ z`.  The cardinality is pinned
to the true physical dimension `card κ + 2·dim(range φ) = dim V`, i.e.
`dim(ker φ) − dim(range φ)`.

Because `β` is an involution commuting with `φ`, both `ker φ` and `range φ` are
`β`-invariant and `range φ ⊆ ker φ` (from `φ² = 0`); `β` descends to
`ker φ / range φ`, and we choose a `β`-eigenbasis of a complement of `range φ`
there.  This is the genuine simultaneous-structure argument — non-degenerate,
since no Hermitian hypothesis collapses `φ`.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCEigenbasis

open LinearMap Module Submodule

/-
**Relative complement.** If `A ≤ B` are submodules of a finite-dimensional
space, then `A` has a complement inside `B`.
-/
theorem exists_relCompl {V : Type*} [AddCommGroup V] [Module ℂ V]
    [FiniteDimensional ℂ V] (A B : Submodule ℂ V) (h : A ≤ B) :
    ∃ C, C ≤ B ∧ Disjoint A C ∧ A ⊔ C = B := by
  -- By Submodule.exists_isCompl there is C' with IsCompl A' C'.
  obtain ⟨C', hC'⟩ : ∃ C' : Submodule ℂ B, IsCompl (Submodule.comap (Submodule.subtype B) A) C' := by
    apply_rules [ Submodule.exists_isCompl ];
  refine' ⟨ Submodule.map B.subtype C', _, _, _ ⟩;
  · exact Submodule.map_subtype_le _ _;
  · rw [ disjoint_iff ];
    simp +decide [ Submodule.eq_bot_iff ];
    intro x hx hx' hx''; have := hC'.disjoint.le_bot ⟨ show ⟨ x, hx' ⟩ ∈ comap B.subtype A from hx, hx'' ⟩ ; aesop;
  · convert congr_arg ( Submodule.map B.subtype ) ( hC'.sup_eq_top ) using 1;
    · simp +decide [ Submodule.map_sup, Submodule.comap_map_eq, h ];
    · aesop

variable {V : Type*} [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]

/-
The `+1` and `-1` eigenspaces of an involution `β` are complementary.
-/
theorem involution_isCompl_eigenspaces (β : V →ₗ[ℂ] V)
    (hββ : β ∘ₗ β = LinearMap.id) :
    IsCompl (LinearMap.ker (β - LinearMap.id)) (LinearMap.ker (β + LinearMap.id)) := by
  refine' ⟨ _, _ ⟩;
  · simp +decide [ Submodule.disjoint_def ];
    intro x hx₁ hx₂; rw [ sub_eq_zero ] at hx₁; simp_all +decide [ ← two_smul ℂ ] ;
  · rw [ codisjoint_iff_le_sup ];
    intro x hx; simp_all +decide [ sub_eq_zero, add_eq_zero_iff_eq_neg ] ;
    rw [ Submodule.mem_sup ];
    refine' ⟨ ( 1 / 2 : ℂ ) • ( x + β x ), _, ( 1 / 2 : ℂ ) • ( x - β x ), _, _ ⟩ <;> norm_num [ LinearMap.ext_iff ] at *;
    · simp +decide [ hββ, add_comm ];
    · rw [ hββ, sub_self ];
    · module

section
variable (β φ : V →ₗ[ℂ] V)
variable (hββ : β ∘ₗ β = LinearMap.id) (hφφ : φ ∘ₗ φ = 0) (hbc : β ∘ₗ φ = φ ∘ₗ β)

include hφφ in
/-- `φ² = 0` gives `range φ ≤ ker φ`. -/
theorem range_le_ker : LinearMap.range φ ≤ LinearMap.ker φ := by
  exact fun x hx => by obtain ⟨ y, rfl ⟩ := hx; exact LinearMap.congr_fun hφφ y;

include hbc in
/-- `ker φ` is `β`-invariant. -/
theorem ker_beta_invariant : ∀ x ∈ LinearMap.ker φ, β x ∈ LinearMap.ker φ := by
  intro x hx; replace hbc := LinearMap.congr_fun hbc x; aesop;

include hbc in
/-- `range φ` is `β`-invariant. -/
theorem range_beta_invariant : ∀ x ∈ LinearMap.range φ, β x ∈ LinearMap.range φ := by
  simp_all +decide [ funext_iff, LinearMap.ext_iff ]

include hββ in
/-- A `β`-invariant submodule `U` is the sup of its intersections with the two
eigenspaces of the involution `β`. -/
theorem invariant_eigen_sup (U : Submodule ℂ V) (hU : ∀ x ∈ U, β x ∈ U) :
    (U ⊓ LinearMap.ker (β - LinearMap.id)) ⊔ (U ⊓ LinearMap.ker (β + LinearMap.id)) = U := by
  refine' le_antisymm ( sup_le inf_le_left inf_le_left ) fun x hx => _;
  refine' Submodule.mem_sup.mpr ⟨ ( 1 / 2 : ℂ ) • ( x + β x ), _, ( 1 / 2 : ℂ ) • ( x - β x ), _, _ ⟩ <;> norm_num;
  · simp_all +decide [ ← two_smul ℂ, LinearMap.ext_iff ];
    exact ⟨ U.add_mem ( U.smul_mem _ hx ) ( U.smul_mem _ ( hU x hx ) ), by abel1 ⟩;
  · exact ⟨ U.smul_mem _ ( U.sub_mem hx ( hU x hx ) ), by rw [ show β ( β x ) = x from LinearMap.congr_fun hββ x ] ; simp +decide ⟩;
  · module

set_option maxHeartbeats 1000000 in
include hββ hφφ hbc in
/-- **The eigen-complement construction.** There exist submodules `Wp, Wm` with
`Wp` in the `+1` eigenspace ∩ `ker φ`, `Wm` in the `-1` eigenspace ∩ `ker φ`,
whose sum is a complement of `range φ` inside `ker φ`, of the full physical
dimension. -/
theorem exists_eigen_complement :
    ∃ (Wp Wm : Submodule ℂ V),
      Wp ≤ LinearMap.ker φ ⊓ LinearMap.ker (β - LinearMap.id) ∧
      Wm ≤ LinearMap.ker φ ⊓ LinearMap.ker (β + LinearMap.id) ∧
      Disjoint (Wp ⊔ Wm) (LinearMap.range φ) ∧
      (Wp ⊔ Wm) ⊔ LinearMap.range φ = LinearMap.ker φ ∧
      finrank ℂ Wp + finrank ℂ Wm + 2 * finrank ℂ (LinearMap.range φ) = finrank ℂ V := by
  -- Let K = LinearMap.ker φ, R = LinearMap.range φ, Ep = LinearMap.ker (β - LinearMap.id), Em = LinearMap.ker (β + LinearMap.id).
  set K := LinearMap.ker φ
  set R := LinearMap.range φ
  set Ep := LinearMap.ker (β - LinearMap.id)
  set Em := LinearMap.ker (β + LinearMap.id);
  obtain ⟨Wp, Wm, hWp, hWm, hsum⟩ : ∃ (Wp Wm : Submodule ℂ V), Wp ≤ K ⊓ Ep ∧ Wm ≤ K ⊓ Em ∧ (LinearMap.range φ ⊓ Ep) ⊔ Wp = K ⊓ Ep ∧ (LinearMap.range φ ⊓ Em) ⊔ Wm = K ⊓ Em ∧ Disjoint (Wp) (LinearMap.range φ ⊓ Ep) ∧ Disjoint (Wm) (LinearMap.range φ ⊓ Em) := by
    have hWp := exists_relCompl (LinearMap.range φ ⊓ Ep) (K ⊓ Ep) (by
    exact inf_le_inf ( LinearMap.range_le_ker_iff.mpr hφφ ) le_rfl)
    have hWm := exists_relCompl (LinearMap.range φ ⊓ Em) (K ⊓ Em) (by
    exact inf_le_inf ( range_le_ker _ hφφ ) le_rfl);
    exact ⟨ hWp.choose, hWm.choose, hWp.choose_spec.1, hWm.choose_spec.1, hWp.choose_spec.2.2, hWm.choose_spec.2.2, hWp.choose_spec.2.1.symm, hWm.choose_spec.2.1.symm ⟩;
  refine' ⟨ Wp, Wm, hWp, hWm, _, _, _ ⟩;
  · have h_disjoint : Disjoint (Wp ⊔ Wm) (LinearMap.range φ ⊓ Ep ⊔ LinearMap.range φ ⊓ Em) := by
      simp_all +decide [ Submodule.disjoint_def ];
      intro x₁ hx₁ x₂ hx₂ h; rw [ Submodule.mem_sup ] at h; obtain ⟨ y, hy, z, hz, h ⟩ := h; simp_all +decide [ add_eq_zero_iff_eq_neg ] ;
      have h_eq : y - x₁ = x₂ - z := by
        exact eq_of_sub_eq_zero ( by rw [ ← sub_eq_zero_of_eq h ] ; abel1 );
      have h_eq_zero : y - x₁ ∈ Ep ∧ y - x₁ ∈ Em := by
        exact ⟨ Submodule.sub_mem _ hy.2 ( hWp.2 hx₁ ), h_eq.symm ▸ Submodule.sub_mem _ ( hWm.2 hx₂ ) hz.2 ⟩;
      have h_eq_zero : y - x₁ = 0 := by
        have := involution_isCompl_eigenspaces β hββ; exact this.disjoint.le_bot ⟨ h_eq_zero.1, h_eq_zero.2 ⟩ ;
      grind;
    refine' h_disjoint.mono_right _;
    intro x hx;
    have := invariant_eigen_sup β hββ R ( range_beta_invariant β φ hbc );
    exact this.symm ▸ hx;
  · convert congr_arg₂ ( · ⊔ · ) hsum.1 hsum.2.1 using 1;
    · simp +decide [ sup_assoc, sup_comm, sup_left_comm ];
      rw [ show φ.range ⊓ Em ⊔ φ.range ⊓ Ep = φ.range from ?_ ];
      convert invariant_eigen_sup β hββ R _ using 1;
      · exact sup_comm _ _;
      · grind +suggestions;
    · convert Eq.symm ( invariant_eigen_sup β hββ K _ ) using 1;
      exact?;
  · -- Using the dimensions from the previous steps, we can derive the required equality.
    have h_dim : finrank ℂ (↥(K ⊓ Ep)) = finrank ℂ (↥(R ⊓ Ep)) + finrank ℂ (↥Wp) ∧ finrank ℂ (↥(K ⊓ Em)) = finrank ℂ (↥(R ⊓ Em)) + finrank ℂ (↥Wm) ∧ finrank ℂ (↥K) = finrank ℂ (↥(K ⊓ Ep)) + finrank ℂ (↥(K ⊓ Em)) ∧ finrank ℂ (↥R) = finrank ℂ (↥(R ⊓ Ep)) + finrank ℂ (↥(R ⊓ Em)) := by
      refine' ⟨ _, _, _, _ ⟩;
      · rw [ ← hsum.1, ← Submodule.finrank_sup_add_finrank_inf_eq, add_comm ];
        rw [ hsum.2.2.1.symm.eq_bot, finrank_bot, zero_add ];
      · rw [ ← hsum.2.1, ← Submodule.finrank_sup_add_finrank_inf_eq ];
        simp_all +decide [ disjoint_iff ];
        rw [ show R ⊓ Em ⊓ Wm = ⊥ from _ ] ; aesop;
        rw [ inf_comm, hsum.2.2.2 ];
      · rw [ ← Submodule.finrank_sup_add_finrank_inf_eq ];
        rw [ show K ⊓ Ep ⊔ K ⊓ Em = K from ?_, show K ⊓ Ep ⊓ ( K ⊓ Em ) = ⊥ from ?_ ] <;> norm_num;
        · have := involution_isCompl_eigenspaces β hββ;
          exact eq_bot_iff.mpr fun x hx => this.disjoint.le_bot ⟨ hx.1.2, hx.2.2 ⟩;
        · grind +suggestions;
      · rw [ ← Submodule.finrank_sup_add_finrank_inf_eq ];
        rw [ show R ⊓ Ep ⊔ R ⊓ Em = R from ?_, show R ⊓ Ep ⊓ ( R ⊓ Em ) = ⊥ from ?_ ] <;> norm_num;
        · simp +decide [ Submodule.eq_bot_iff ];
          intro x hx₁ hx₂ hx₃ hx₄; have := congr_arg β hx₂; simp_all +decide [ sub_eq_iff_eq_add, add_eq_zero_iff_eq_neg ] ;
          simp +zetaDelta at *;
          simp_all +decide [ sub_eq_zero ];
          simpa [ ← two_smul ℂ x ] using hx₄;
        · grind +suggestions;
    linarith [ LinearMap.finrank_range_add_finrank_ker φ ]

include hββ hφφ hbc in
/-- **Eigenbasis core.** A `β`-eigenbasis of a complement of `range φ` in
`ker φ`: a linearly independent family `v` of `β`-eigenvectors (`±1` eigenvalues
`e`) lying in `ker φ`, spanning a complement of `range φ` in `ker φ`, with
`card κ + 2·dim(range φ) = dim V`. -/
theorem eigenbasis_core :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ) (v : κ → V) (e : κ → ℂ),
      (∀ j, e j = 1 ∨ e j = -1) ∧
      (∀ j, β (v j) = e j • v j) ∧
      (∀ j, φ (v j) = 0) ∧
      LinearIndependent ℂ v ∧
      (∀ x, φ x = 0 → ∃ (w : κ → ℂ) (z : V), x = (∑ j, w j • v j) + φ z) ∧
      Fintype.card κ + 2 * finrank ℂ (LinearMap.range φ) = finrank ℂ V := by
  obtain ⟨Wp, Wm, hWp, hWm, hdisj, hsupK, hcount⟩ := exists_eigen_complement β φ hββ hφφ hbc;
  obtain ⟨bp, hbp⟩ : ∃ bp : Basis (Fin (finrank ℂ Wp)) ℂ Wp, True := by
    exact ⟨ Module.finBasis ℂ Wp, trivial ⟩
  obtain ⟨bm, hbm⟩ : ∃ bm : Basis (Fin (finrank ℂ Wm)) ℂ Wm, True := by
    exact ⟨ Module.finBasis ℂ Wm, trivial ⟩;
  refine' ⟨ _, _, _, Sum.elim ( fun i => ( bp i : V ) ) ( fun i => ( bm i : V ) ), Sum.elim ( fun _ => 1 ) ( fun _ => -1 ), _, _, _, _, _ ⟩;
  all_goals try infer_instance;
  · rintro ( j | j ) <;> simp +decide;
  · rintro ( i | i ) <;> simp_all +decide [ LinearMap.mem_ker, sub_eq_zero, add_eq_zero_iff_eq_neg ];
    · exact sub_eq_zero.mp ( hWp.2 ( bp i |>.2 ) );
    · have := hWm.2 ( bm i |>.2 ) ; simp_all +decide [ LinearMap.mem_ker, add_eq_zero_iff_eq_neg ] ;
  · rintro ( i | i ) <;> simp_all +decide [ SetLike.le_def ];
  · refine' LinearIndependent.sum_type _ _ _;
    · exact bp.linearIndependent.map' ( Submodule.subtype Wp ) ( by simp +decide );
    · exact bm.linearIndependent.map' ( Submodule.subtype Wm ) ( by simp +decide [ Submodule.ker_subtype ] );
    · rw [ Submodule.disjoint_def ];
      intro x hx₁ hx₂;
      have h_disjoint : Disjoint (Wp) (Wm) := by
        have h_disjoint : Disjoint (LinearMap.ker (β - LinearMap.id)) (LinearMap.ker (β + LinearMap.id)) := by
          exact involution_isCompl_eigenspaces β hββ |>.disjoint;
        exact h_disjoint.mono ( fun x hx => hWp hx |>.2 ) ( fun x hx => hWm hx |>.2 );
      exact h_disjoint.le_bot ⟨ by exact Submodule.span_le.mpr ( Set.range_subset_iff.mpr fun i => bp i |>.2 ) hx₁, by exact Submodule.span_le.mpr ( Set.range_subset_iff.mpr fun i => bm i |>.2 ) hx₂ ⟩;
  · refine' ⟨ _, _ ⟩;
    · intro x hx;
      -- By definition of $Wp$ and $Wm$, we can write $x$ as $x = y + r$ where $y \in Wp \oplus Wm$ and $r \in \text{range}(\varphi)$.
      obtain ⟨y, r, hy, hr⟩ : ∃ y ∈ Wp ⊔ Wm, ∃ r ∈ LinearMap.range φ, x = y + r := by
        have := Submodule.mem_sup.mp ( show x ∈ Wp ⊔ Wm ⊔ φ.range from hsupK.symm ▸ hx );
        tauto;
      -- Since $y \in Wp \oplus Wm$, we can write $y$ as a linear combination of the basis vectors of $Wp$ and $Wm$.
      obtain ⟨w, hw⟩ : ∃ w : Fin (finrank ℂ Wp) ⊕ Fin (finrank ℂ Wm) → ℂ, y = ∑ j, w j • (Sum.elim (fun i => (bp i : V)) (fun i => (bm i : V)) j) := by
        have h_decomp : y ∈ Submodule.map (Submodule.subtype Wp) (Submodule.span ℂ (Set.range bp)) ⊔ Submodule.map (Submodule.subtype Wm) (Submodule.span ℂ (Set.range bm)) := by
          simp +decide [ Submodule.map_span, bp.span_eq, bm.span_eq ];
          exact r;
        rw [ Submodule.mem_sup ] at h_decomp;
        obtain ⟨ y, hy, z, hz, rfl ⟩ := h_decomp;
        rw [ Submodule.mem_map ] at hy hz;
        rcases hy with ⟨ y, hy, rfl ⟩ ; rcases hz with ⟨ z, hz, rfl ⟩ ; rw [ Finsupp.mem_span_range_iff_exists_finsupp ] at hy hz; obtain ⟨ w₁, rfl ⟩ := hy; obtain ⟨ w₂, rfl ⟩ := hz; use fun j => Sum.elim ( fun i => w₁ i ) ( fun i => w₂ i ) j; simp +decide [ Finsupp.sum_fintype ] ;
      obtain ⟨ z, rfl ⟩ := hr.1; exact ⟨ w, z, by simpa [ hw ] using hr.2 ⟩ ;
    · simp +decide [ ← hcount ]

end

end PhysicsSM.Draft.NullEdge.GateYM.S1CCEigenbasis
