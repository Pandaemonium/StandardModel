import PhysicsSM.Draft.Spin10StandardizablePairs

/-!
# The Chevalley incidence lemma: genuine Krasnov pairs meet in dimension 3

Target statements for the Aristotle job `spin10-incidence-20260719`.

Context.  The corrected-S1 chain is now one geometric lemma from closure:
the predecessor (215bd4d5, integrated) proved the reduction of corrected S1
to `standardizable_of_genuine_krasnov_pair`, added the annihilator
invariant (`commonAnnihilator`, `annihilatorIntersectionDim`), the vacuum
stabilizer, and the `d = 3` fiber - and its PROOF_STATUS names THIS lemma
as the exact first blocker (the Chevalley incidence theorem connecting the
coordinate `IsPureSpinor` to the annihilator invariant).

Route notes (from the predecessor's analysis + the landed trichotomy):
the basis-pair annihilator trichotomy
(`SpinorTenfoldBasisTrichotomyAristotle`: `dim(N_S ∩ N_T) = 5 - |S Δ T| ∈
{1,3,5}`) settles the BASIS-monomial case; the general case should move a
pure spinor to a basis monomial by the landed orbit machinery and track
the annihilator equivariantly (`annihilator (g ψ) = g ⋅ annihilator ψ`
under the Clifford conjugation action on `V10` - prove the equivariance
as a helper if not already available).  Orthogonality excludes `d = 1`;
projective distinctness excludes `d = 5`.

Pre-registered honesty license: if the correct genuine-pair dimension is
another odd value under the repo's conventions, prove the true value,
rename, record prominently, and adjust the downstream fiber definition
consistently in the report (do not edit the landed files).  A kernel
counterexample is a first-class outcome.  Every `s o r r y` below is a
documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10AnnihilatorIncidence

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StandardizablePairs

/-
Equivariance helper: the annihilator of a transformed spinor is the
transformed annihilator (state precisely against the repo's conjugation
action; adjust the transport formulation honestly if the action is by the
twisted conjugation).
-/
theorem annihilatorIntersectionDim_smul (g : evenCliffordGroup)
    (ψ₁ ψ₂ : FockSpinor) :
    annihilatorIntersectionDim (g.val.val ψ₁) (g.val.val ψ₂) =
      annihilatorIntersectionDim ψ₁ ψ₂ := by
  unfold annihilatorIntersectionDim;
  -- By `evenCliffordGroup_conj_exists`, there exists a linear bijection `L` such that `g.val.val ∘ gammaEnd v = gammaEnd (L v) ∘ g.val.val`.
  obtain ⟨L, hL⟩ : ∃ L : V10 ≃ₗ[ℂ] V10, ∀ v : V10, (g.val.val : Module.End ℂ FockSpinor) ∘ gammaEnd v = gammaEnd (L v) ∘ (g.val.val : Module.End ℂ FockSpinor) := by
    obtain ⟨L, hL⟩ : ∃ L : V10 → V10, ∀ v : V10, (g.val.val : Module.End ℂ FockSpinor) * gammaEnd v * ((g⁻¹ : (Module.End ℂ FockSpinor)ˣ) : Module.End ℂ FockSpinor) = gammaEnd (L v) := by
      have := evenCliffordGroup_conj_exists g g.2;
      exact ⟨ fun v => Classical.choose ( this v |>.1 ), fun v => Classical.choose_spec ( this v |>.1 ) |>.1 ⟩;
    have hL_linear : ∀ (v w : V10) (c : ℂ), L (v + w) = L v + L w ∧ L (c • v) = c • L v := by
      have hL_linear : ∀ (v w : V10) (c : ℂ), gammaEnd (L (v + w)) = gammaEnd (L v + L w) ∧ gammaEnd (L (c • v)) = gammaEnd (c • L v) := by
        simp +decide [ ← hL, gammaEnd_add, gammaEnd_smul ];
        simp +decide [ ← mul_add, ← add_mul, ← smul_assoc, gammaEnd_add, gammaEnd_smul ];
      exact fun v w c => ⟨ gammaEnd_injective <| hL_linear v w c |>.1, gammaEnd_injective <| hL_linear v w c |>.2 ⟩;
    have hL_bijective : Function.Bijective L := by
      have hL_injective : Function.Injective L := by
        intro v w hvw
        have h_eq : gammaEnd v = gammaEnd w := by
          have := hL v; have := hL w; simp_all +decide [ mul_assoc ] ;
          convert congr_arg ( fun x => ( g⁻¹ : ( Module.End ℂ FockSpinor ) ˣ ).val * x * ( g : ( Module.End ℂ FockSpinor ) ˣ ).val ) ( hL v.1 v.2 |> Eq.trans <| hvw.symm ▸ hL w.1 w.2 |> Eq.symm ) using 1 <;> simp +decide [ mul_assoc, Units.mul_inv_eq_iff_eq_mul ];
        exact gammaEnd_injective h_eq;
      refine' ⟨ hL_injective, _ ⟩;
      exact LinearMap.surjective_of_injective ( show Function.Injective ( show V10 →ₗ[ℂ] V10 from { toFun := L, map_add' := fun v w => hL_linear v w 1 |>.1, map_smul' := fun c v => hL_linear v 0 c |>.2 } ) from hL_injective );
    refine' ⟨ { Equiv.ofBijective L hL_bijective with map_add' := fun v w => hL_linear v w 1 |>.1, map_smul' := fun c v => hL_linear v 0 c |>.2 }, fun v => _ ⟩;
    ext; simp +decide [ ← hL ] ;
    congr! 2;
    exact Eq.symm ( by exact congr_arg ( fun f : ( Module.End ℂ FockSpinor )ˣ => f.val ‹_› ) ( inv_mul_cancel _ ) );
  -- By `hL`, the annihilator of `g ψ₁` is the image of the annihilator of `ψ₁` under `L`.
  have h_annihilator_g_psi₁ : ∀ v : V10, v ∈ annihilator (g.val.val ψ₁) ↔ L.symm v ∈ annihilator ψ₁ := by
    intro v
    constructor
    intro hv
    have hLhv : (g.val.val : Module.End ℂ FockSpinor) (gammaEnd (L.symm v) ψ₁) = 0 := by
      have := congr_fun ( hL ( L.symm v ) ) ψ₁; aesop;
    have hv' : gammaEnd (L.symm v) ψ₁ = 0 := by
      have h_inj : Function.Injective (g.val.val : Module.End ℂ FockSpinor) := by
        have h_inv : ∃ g_inv : Module.End ℂ FockSpinor, g.val.val * g_inv = 1 ∧ g_inv * g.val.val = 1 := by
          exact ⟨ _, Units.mul_inv _, Units.inv_mul _ ⟩
        exact Function.LeftInverse.injective ( fun x => by simpa using congr_arg ( fun f => f x ) h_inv.choose_spec.2 );
      exact h_inj <| by simpa using hLhv;
    exact hv';
    intro hv
    have hLhv : (g.val.val : Module.End ℂ FockSpinor) (gammaEnd (L.symm v) ψ₁) = 0 := by
      rw [ mem_annihilator ] at hv ; aesop
    have hv' : gammaEnd v (g.val.val ψ₁) = 0 := by
      have := congr_fun ( hL ( L.symm v ) ) ψ₁; aesop;
    exact hv';
  -- By `hL`, the annihilator of `g ψ₂` is the image of the annihilator of `ψ₂` under `L`.
  have h_annihilator_g_psi₂ : ∀ v : V10, v ∈ annihilator (g.val.val ψ₂) ↔ L.symm v ∈ annihilator ψ₂ := by
    intro v; specialize hL ( L.symm v ) ; simp_all +decide [ funext_iff, Submodule.mem_span_singleton ] ;
    simp_all +decide [ mem_annihilator, funext_iff ];
    constructor <;> intro h x <;> have := hL ψ₂ x <;> simp_all +decide [ funext_iff ] ;
    · have hL_inv : ∀ x : FockSpinor, g.val.val x = 0 → x = 0 := by
        intro x hx; have := g.1.isUnit; simp_all +decide [ Units.ext_iff ] ;
        have := g.1.isUnit; obtain ⟨ y, hy ⟩ := this.exists_left_inv; replace hy := congr_arg ( fun f => f x ) hy; aesop;
      specialize hL_inv ( cliffordAction ( L.symm v ) ψ₂ ) ; simp_all +decide [ funext_iff ] ;
    · rw [ ← hL, show cliffordAction ( L.symm v ) ψ₂ = 0 from funext h ] ; norm_num;
  -- By `hL`, the common annihilator of `g ψ₁` and `g ψ₂` is the image of the common annihilator of `ψ₁` and `ψ₂` under `L`.
  have h_commonAnnihilator_g : commonAnnihilator (g.val.val ψ₁) (g.val.val ψ₂) = Submodule.map L.toLinearMap (commonAnnihilator ψ₁ ψ₂) := by
    ext v; simp [commonAnnihilator, h_annihilator_g_psi₁, h_annihilator_g_psi₂];
  rw [ h_commonAnnihilator_g, ← LinearEquiv.finrank_eq ( L.submoduleMap ( commonAnnihilator ψ₁ ψ₂ ) ) ]

/-- Diagonal specialization of two-argument equivariance. -/
theorem annihilator_smul (g : evenCliffordGroup) (ψ : FockSpinor) :
    annihilatorIntersectionDim (g.val.val ψ) (g.val.val ψ) =
      annihilatorIntersectionDim ψ ψ :=
  annihilatorIntersectionDim_smul g ψ ψ

/-! ## The basis-monomial incidence calculation -/

/-
A vector annihilates a wedge-basis monomial exactly when its creation
coordinates vanish off the occupied set and its contraction coordinates
vanish on the occupied set.
-/
lemma mem_annihilator_basisSpinor_iff (S : Finset (Fin 5)) (v : V10) :
    v ∈ annihilator (basisSpinor S) ↔
      (∀ i, i ∉ S → v.1 i = 0) ∧ (∀ i, i ∈ S → v.2 i = 0) := by
  constructor <;> intro h <;> simp_all +decide [ mem_annihilator, annihilator ];
  · simp_all +decide [ funext_iff, Finset.sum_apply, basisSpinor, wedge, contract, cliffordAction ];
    constructor <;> intro i hi <;> have := h ( Insert.insert i S ) <;> simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Finset.mem_insert, Finset.mem_erase ];
    · rw [ Finset.sum_eq_single i, Finset.sum_eq_zero ] at this <;> simp_all +decide [ Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ];
      · exact this.resolve_right ( opSign_ne_zero _ _ );
      · intro x hx₁ hx₂ hx₃; replace hx₃ := Finset.ext_iff.mp hx₃ x; aesop;
      · grind;
    · specialize h ( S.erase i ) ; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ;
      rw [ Finset.sum_eq_zero, Finset.sum_eq_single i ] at h <;> simp_all +decide [ Finset.filter_eq', Finset.filter_ne' ];
      · exact h.resolve_right ( opSign_ne_zero _ _ );
      · grind;
      · grind;
  · ext T; simp [cliffordAction, h];
    rw [ ← Finset.sum_add_distrib ] ; refine' Finset.sum_eq_zero fun i hi => _ ; by_cases hiS : i ∈ S <;> simp_all +decide [ wedge, contract ] ;
    · exact fun hiT => Or.inr <| Or.inr <| by unfold basisSpinor; aesop;
    · unfold basisSpinor; aesop;

/-
The common annihilator of two basis monomials has one coordinate for
each mode on which their occupation statuses agree.
-/
lemma basis_commonAnnihilator_finrank (S T : Finset (Fin 5)) :
    annihilatorIntersectionDim (basisSpinor S) (basisSpinor T) =
      ((S ∩ T).card + (Sᶜ ∩ Tᶜ).card) := by
  simp [annihilatorIntersectionDim, commonAnnihilator];
  rw [ show annihilator ( basisSpinor S ) ⊓ annihilator ( basisSpinor T ) = ( Submodule.span ℂ ( Set.image ( fun i => ( fun j => if j = i then 1 else 0, fun j => 0 ) ) ( S ∩ T ) ) ⊔ Submodule.span ℂ ( Set.image ( fun i => ( fun j => 0, fun j => if j = i then 1 else 0 ) ) ( Sᶜ ∩ Tᶜ ) ) ) from ?_ ];
  · rw [ ← Submodule.span_union, finrank_span_set_eq_card ];
    · rw [ Set.toFinset_union ];
      rw [ Finset.card_union_of_disjoint ] <;> norm_num [ Finset.disjoint_left ];
      · rw [ Finset.card_image_of_injective, Finset.card_image_of_injective ] <;> norm_num [ Function.Injective ];
        · simp +decide [ funext_iff ];
          exact fun i j h => by simpa using h i;
        · simp +decide [ funext_iff ];
          exact fun i j h => by simpa using h i;
      · intro a b x hxS hxT ha hb y hyS hyT ha' hb'; subst_vars; simp_all +decide [ funext_iff ] ;
    · refine' LinearIndepOn.union _ _ _;
      · refine' LinearIndepOn.mono _ _;
        exact Set.range ( fun i : Fin 5 => ( fun j => if j = i then 1 else 0, fun j => 0 ) );
        · refine' LinearIndependent.linearIndepOn_id _;
          refine' Fintype.linearIndependent_iff.2 _;
          intro g hg i; replace hg := congr_arg ( fun f => f.1 i ) hg; simp_all +decide [ Finset.sum_apply, funext_iff ] ;
          erw [ Prod.fst_sum ] at hg ; aesop;
        · exact Set.image_subset_range _ _;
      · refine' LinearIndepOn.mono _ _;
        exact Set.range ( fun i : Fin 5 => ( fun j => 0, fun j => if j = i then 1 else 0 ) );
        · refine' LinearIndependent.linearIndepOn_id _;
          refine' Fintype.linearIndependent_iff.2 _;
          intro g hg i; replace hg := congr_arg ( fun f => f.2 i ) hg; simp_all +decide [ Finset.sum_apply, funext_iff ] ;
          erw [ Prod.snd_sum ] at hg ; aesop;
        · exact Set.image_subset_range _ _;
      · rw [ Submodule.disjoint_def ];
        intro x hx₁ hx₂;
        rw [ Submodule.mem_span ] at hx₁ hx₂;
        specialize hx₁ ( LinearMap.ker ( LinearMap.snd ℂ ( Fin 5 → ℂ ) ( Fin 5 → ℂ ) ) ) ; specialize hx₂ ( LinearMap.ker ( LinearMap.fst ℂ ( Fin 5 → ℂ ) ( Fin 5 → ℂ ) ) ) ; simp_all +decide [ Set.subset_def ];
        exact Prod.ext ( hx₂ fun a b x hx₁ hx₂ hx₃ hx₄ => by aesop ) ( hx₁ fun a b x hx₁ hx₂ hx₃ hx₄ => by aesop );
  · refine' le_antisymm _ _;
    · intro v hv; simp_all +decide [ mem_annihilator_basisSpinor_iff ] ;
      rw [ Submodule.mem_sup ];
      refine' ⟨ _, _, _, _, _ ⟩;
      exact ( fun i => if i ∈ S ∩ T then v.1 i else 0, fun i => 0 );
      rotate_left;
      exact ( fun i => 0, fun i => if i ∈ ( Sᶜ ∩ Tᶜ : Finset ( Fin 5 ) ) then v.2 i else 0 );
      · rw [ Submodule.mem_span ];
        intro p hp;
        convert p.sum_mem fun i ( hi : i ∈ ( Sᶜ ∩ Tᶜ : Finset ( Fin 5 ) ) ) => p.smul_mem ( v.2 i ) ( hp <| Set.mem_image_of_mem _ <| show i ∈ ( Sᶜ ∩ Tᶜ : Set ( Fin 5 ) ) from by simpa using hi ) using 1;
        ext i; simp +decide [ Finset.sum_apply, Finset.sum_ite ] ;
        · erw [ Prod.fst_sum ] ; aesop;
        · rw [ Prod.snd_sum ] ; aesop;
      · ext i; by_cases hi : i ∈ S <;> by_cases hi' : i ∈ T <;> simp_all +decide ;
        by_cases hi : i ∈ S <;> by_cases hi' : i ∈ T <;> simp_all +decide [ Finset.mem_inter, Finset.mem_compl ];
      · rw [ Submodule.mem_span ];
        intro p hp;
        convert p.sum_mem fun i ( hi : i ∈ ( S ∩ T : Finset ( Fin 5 ) ) ) => p.smul_mem ( v.1 i ) ( hp <| Set.mem_image_of_mem _ <| show i ∈ ( S ∩ T : Set ( Fin 5 ) ) from by aesop ) using 1;
        ext i; simp +decide [ Finset.sum_ite ] ;
        · rw [ Prod.fst_sum ] ; aesop;
        · simp +decide [ Prod.snd_sum ];
    · simp +decide [ Submodule.span_le, Set.image_subset_iff ];
      simp +decide [ Set.subset_def, mem_annihilator_basisSpinor_iff ];
      grind

/-
Basis-monomial Chevalley incidence: for positive-chirality monomials,
gamma-orthogonality and projective distinctness select the dimension-three
stratum.  Here orthogonality excludes the transversal (`d = 1`) case, while
projective distinctness excludes the diagonal (`d = 5`) case.
-/
theorem basis_annihilatorIntersectionDim_eq_three_of_genuine
    (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0)
    (horth : OrthogonalPureSpinors (basisSpinor S) (basisSpinor T))
    (hdist : ProjectivelyDistinct (basisSpinor S) (basisSpinor T)) :
    annihilatorIntersectionDim (basisSpinor S) (basisSpinor T) = 3 := by
  simp_all +decide [ OrthogonalPureSpinors, ProjectivelyDistinct ];
  have h_cases : ∀ S : Finset (Fin 5), S.card % 2 = 0 → ∀ T : Finset (Fin 5), T.card % 2 = 0 → S ≠ T → gammaBilinear (basisSpinor S) (basisSpinor T) + gammaBilinear (basisSpinor T) (basisSpinor S) = 0 → ((S ∩ T).card + (Sᶜ ∩ Tᶜ).card) = 3 := by
    simp +decide [ funext_iff, gammaBilinear, chevalleyPairing, wedge, contract, basisSpinor ];
    simp +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', chevalleySign, opSign ] at *;
    norm_cast at *;
  convert h_cases S hS T hT _ horth using 1;
  · convert basis_commonAnnihilator_finrank S T using 1;
  · exact fun h => hdist 1 <| by simp +decide [ h ] ;

/-
Nonzero rescaling of either spinor does not alter the common-annihilator
dimension.
-/
lemma annihilatorIntersectionDim_smul_scalars
    (c₁ c₂ : ℂ) (hc₁ : c₁ ≠ 0) (hc₂ : c₂ ≠ 0) (ψ₁ ψ₂ : FockSpinor) :
    annihilatorIntersectionDim (c₁ • ψ₁) (c₂ • ψ₂) =
      annihilatorIntersectionDim ψ₁ ψ₂ := by
  unfold annihilatorIntersectionDim;
  unfold commonAnnihilator;
  rw [ show annihilator ( c₁ • ψ₁ ) = annihilator ψ₁ from ?_, show annihilator ( c₂ • ψ₂ ) = annihilator ψ₂ from ?_ ];
  · ext v; simp [annihilator];
    rw [ cliffordAction_smul_spinor ] ; aesop;
  · ext v; simp [annihilator];
    rw [ cliffordAction_smul_spinor ] ; aesop

/-
The proved normal-form transport step: once one group element carries a
pair to nonzero multiples of even basis monomials, the basis incidence
calculation transports back to the original pair.
-/
theorem annihilatorIntersectionDim_eq_three_of_basis_normalForm
    (ψ₁ ψ₂ : FockSpinor)
    (g : evenCliffordGroup) (S T : Finset (Fin 5))
    (hS : S.card % 2 = 0) (hT : T.card % 2 = 0)
    (c₁ c₂ : ℂ) (hc₁ : c₁ ≠ 0) (hc₂ : c₂ ≠ 0)
    (hg₁ : g.val.val ψ₁ = c₁ • basisSpinor S)
    (hg₂ : g.val.val ψ₂ = c₂ • basisSpinor T)
    (horth' : OrthogonalPureSpinors (basisSpinor S) (basisSpinor T))
    (hdist' : ProjectivelyDistinct (basisSpinor S) (basisSpinor T)) :
    annihilatorIntersectionDim ψ₁ ψ₂ = 3 := by
  convert annihilatorIntersectionDim_smul_scalars c₁ c₂ hc₁ hc₂ ( basisSpinor S ) ( basisSpinor T ) using 1;
  · rw [ ← hg₁, ← hg₂, annihilatorIntersectionDim_smul ];
  · exact Eq.symm ( basis_annihilatorIntersectionDim_eq_three_of_genuine S T hS hT horth' hdist' )

/-- Basis-monomial version of the vacuum-fiber packaging. -/
theorem inVacuumThreeFiber_basis_of_genuine (T : Finset (Fin 5))
    (hT : T.card % 2 = 0)
    (hψ : IsPureSpinor (basisSpinor T))
    (horth : OrthogonalPureSpinors vacuumSpinor (basisSpinor T))
    (hdist : ProjectivelyDistinct vacuumSpinor (basisSpinor T)) :
    InVacuumThreeFiber (basisSpinor T) := by
  refine ⟨hψ, ?_⟩
  simpa [vacuumSpinor] using
    basis_annihilatorIntersectionDim_eq_three_of_genuine ∅ T (by decide) hT horth hdist

/-- **The Chevalley incidence lemma (the named blocker).**  Purity,
orthogonality, and projective distinctness force common-annihilator
dimension exactly three.

The basis-monomial case and full two-argument equivariance are proved above.
The remaining hole is precisely the unavailable general pure-spinor normal
form: a simultaneous reduction of a genuine pair to basis monomials (or an
equivalent coordinate proof of Chevalley's line-incidence theorem). -/
theorem annihilatorIntersectionDim_eq_three_of_genuine
    (ψ₁ ψ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (horth : OrthogonalPureSpinors ψ₁ ψ₂)
    (hdist : ProjectivelyDistinct ψ₁ ψ₂) :
    annihilatorIntersectionDim ψ₁ ψ₂ = 3 := by
  sorry

/-
Fiber corollary: a genuine partner of the vacuum lies in the vacuum's
`d = 3` fiber.
-/
theorem inVacuumThreeFiber_of_genuine (ψ : FockSpinor)
    (hψ : IsPureSpinor ψ)
    (horth : OrthogonalPureSpinors vacuumSpinor ψ)
    (hdist : ProjectivelyDistinct vacuumSpinor ψ) :
    InVacuumThreeFiber ψ := by
  refine' And.intro _ ( _ );
  · exact hψ;
  · exact annihilatorIntersectionDim_eq_three_of_genuine _ _ ( isPureSpinor_vacuumSpinor ) hψ horth hdist

end PhysicsSM.Draft.Spin10AnnihilatorIncidence
