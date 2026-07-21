import PhysicsSM.Draft.NullEdge.HNURealSpaceBridge
import PhysicsSM.Draft.NullEdge.HNUTransversePiComposite

/-!
# Local decoded HNU schedule with a visible pi complement

This file constructs the requested finite real-space update.  The transverse
selector is applied pointwise at each lattice site (hence is strictly onsite).
The selected line carries the depth-eight HNU schedule; its orthogonal
complement is multiplied by `-1`.  No anomaly-cancellation or species-uniqueness
claim is made.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.FloquetTransverseComposite
open PhysicsSM.Draft.NullEdge.HNUTransversePiComposite

namespace PhysicsSM.Draft.NullEdge.HNUDecodedLocalStay

noncomputable section

abbrev TSite := FloquetTransverseComposite.TSite
abbrev Spin := FloquetTransverseComposite.Spin
abbrev Site (L : ℕ) := HNURealSpace.Site L

/-- Finite real-space states with the three-state transverse register, HNU spin,
and finite periodic site registers. -/
abbrev ExtendedState (L : ℕ) := Site L → (TSite × Spin → ℂ)

/-- Pointwise transverse selector.  This operation never reads another site. -/
def selected {L : ℕ} (ψ : ExtendedState L) : ExtendedState L :=
  fun x q => (selector *ᵥ fun t => ψ x (t, q.2)) q.1

/-- Pointwise orthogonal transverse complement. -/
def complement {L : ℕ} (ψ : ExtendedState L) : ExtendedState L :=
  fun x q => (((1 : Matrix TSite TSite ℂ) - selector) *ᵥ
    fun t => ψ x (t, q.2)) q.1

/-- Lift the HNU schedule independently over the transverse register. -/
def scheduleLift {L : ℕ} [NeZero L] (ψ : ExtendedState L) : ExtendedState L :=
  fun x q => HNURealSpace.schedule (fun y s => ψ y (q.1, s)) x q.2

/-- The complete update: HNU on the selected line and the explicit phase `-1`
on the orthogonal complement. -/
def update {L : ℕ} [NeZero L] (ψ : ExtendedState L) : ExtendedState L :=
  scheduleLift (selected ψ) - complement ψ

/-- Physical encoding with transverse profile `w`. -/
def encode {L : ℕ} (φ : HNURealSpace.State L) : ExtendedState L :=
  fun x q => w q.1 * φ x q.2

/-- A concrete left inverse (read transverse component zero and divide by two). -/
def decode {L : ℕ} (ψ : ExtendedState L) : HNURealSpace.State L :=
  fun x s => (1 / 2 : ℂ) * ψ x (0, s)

/-- Product plane wave in the extended register. -/
def extendedPlaneWave {L : ℕ} (k : Site L) (a : TSite × Spin → ℂ) :
    ExtendedState L := fun x q => HNURealSpace.char k x * a q

/-- Inner product on the full finite state space, grouped by transverse
component so schedule unitarity applies directly. -/
def inner {L : ℕ} (ψ φ : ExtendedState L) : ℂ :=
  ∑ t, HNURealSpace.gInner (fun x s => ψ x (t,s)) (fun x s => φ x (t,s))

/-
The onsite selector and complement reconstruct every state.
-/
lemma selected_add_complement {L : ℕ} (ψ : ExtendedState L) :
    selected ψ + complement ψ = ψ := by
      ext x q; simp +decide [ selected, complement ] ;
      simp +decide [ Matrix.sub_mulVec, Matrix.one_mulVec ]

/-
The concrete decoder is a left inverse, hence the physical encoding is
injective.
-/
lemma decode_encode {L : ℕ} (φ : HNURealSpace.State L) : decode (encode φ) = φ := by
  ext x s; simp +decide [ decode, encode ] ; ring;
  unfold w; norm_num; ring;

theorem encode_injective {L : ℕ} : Function.Injective (@encode L) := by
  intro φ ψ h; ext x s; have := congr_fun ( congr_fun h x ) ( 0, s ) ; simp_all +decide [ encode ] ;
  exact this.resolve_right ( by unfold w; norm_num )

/-
Exact selected schedule and zero leakage.
-/
theorem update_encode {L : ℕ} [NeZero L] (φ : HNURealSpace.State L) :
    update (encode φ) = encode (HNURealSpace.schedule φ) := by
      funext x q; simp [update, scheduleLift, selected, complement, encode, decode];
      -- Apply the linearity of the schedule in the transverse coefficient w t.
      have h_schedule_linear : ∀ (c : ℂ) (ψ : HNURealSpace.State L), HNURealSpace.schedule (fun x s => c * ψ x s) = fun x s => c * HNURealSpace.schedule ψ x s := by
        intro c ψ;
        -- Apply the linearity of the schedule in the transverse coefficient w t to each step of the schedule.
        have h_schedule_step : ∀ (P Q : M2) (σ : Site L ≃ Site L) (ψ : HNURealSpace.State L), HNURealSpace.condShift P Q σ (fun x s => c * ψ x s) = fun x s => c * HNURealSpace.condShift P Q σ ψ x s := by
          intros P Q σ ψ; funext x s; simp [HNURealSpace.condShift, Matrix.mulVec]; ring;
        simp +decide only [HNURealSpace.schedule];
        simp +decide only [HNURealSpace.W1, HNURealSpace.W2, HNURealSpace.W3, HNURealSpace.W4, HNURealSpace.W5,
            HNURealSpace.W6, HNURealSpace.W7, HNURealSpace.W8, h_schedule_step];
      convert congr_fun ( congr_fun ( h_schedule_linear ( w q.1 ) φ ) x ) q.2 using 1;
      simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ];
      fin_cases q <;> simp +decide [ selector ];
      all_goals unfold vecMulVec; norm_num [ w ] ;; all_goals simp +decide [ Matrix.one_apply ] ; ring

/-
Complement product states receive exactly the visible quasienergy-pi phase.
-/
theorem update_complement {L : ℕ} [NeZero L] (f : TSite → ℂ)
    (φ : HNURealSpace.State L) (hf : selector *ᵥ f = 0) :
    update (fun x q => f q.1 * φ x q.2) =
      -(fun x q => f q.1 * φ x q.2) := by
        ext x q; simp +decide [ update, scheduleLift, selected, complement, hf ] ;
        rw [ show ( fun y s => ( selector *ᵥ fun t => f t * φ y s ) q.1 ) = 0 from _ ];
        · simp +decide [ Matrix.sub_mulVec, hf ];
          rw [ show ( fun t => f t * φ x q.2 ) = φ x q.2 • f from funext fun _ => mul_comm _ _ ] ; simp +decide [ hf, Matrix.mulVec_smul ];
          unfold HNURealSpace.schedule; simp +decide [ HNURealSpace.W1, HNURealSpace.W2, HNURealSpace.W3, HNURealSpace.W4, HNURealSpace.W5, HNURealSpace.W6, HNURealSpace.W7, HNURealSpace.W8 ] ;
          unfold HNURealSpace.condShift; simp +decide [ HNURealSpace.shPlus1, HNURealSpace.shPlus2, HNURealSpace.shPlus3, HNURealSpace.shMinus1, HNURealSpace.shMinus2, HNURealSpace.shMinus3 ] ;
        · ext y s; simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ] ;
          simp_all +decide [ ← mul_assoc, ← Finset.sum_mul ]

/-
Orthogonal Pythagorean decomposition for the onsite selector.
-/
lemma inner_sector_split {L : ℕ} (ψ φ : ExtendedState L) :
    inner ψ φ = inner (selected ψ) (selected φ) +
      inner (complement ψ) (complement φ) := by
        unfold inner selected complement;
        simp +decide only [HNURealSpace.gInner];
        simp +decide only [selector];
        simp +decide only [HNURealSpace.sinner, smul_mulVec, sub_mulVec, one_mulVec, Pi.sub_apply];
        simp +decide only [Fin.sum_univ_three, vecMulVec, w];
        simp +decide only [starRingEnd_apply];
        simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ] ; ring;
        norm_num [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _ ] ; ring;
        norm_num [ ← Finset.sum_mul _ _ _ ] ; ring

/-
Lifting the HNU schedule over transverse components preserves the full
inner product.
-/
lemma scheduleLift_inner {L : ℕ} [NeZero L] (ψ φ : ExtendedState L) :
    inner (scheduleLift ψ) (scheduleLift φ) = inner ψ φ := by
      -- By definition of `scheduleLift`, we know that it preserves the inner product.
      apply Finset.sum_congr rfl;
      intro t ht; exact HNURealSpace.schedule_gInner ( fun x s => ψ x ( t, s ) ) ( fun x s => φ x ( t, s ) ) ;

/-
The HNU lift commutes with the constant onsite transverse selector.
-/
lemma selected_scheduleLift {L : ℕ} [NeZero L] (ψ : ExtendedState L) :
    selected (scheduleLift ψ) = scheduleLift (selected ψ) := by
      apply funext;
      -- By definition of `selected` and `scheduleLift`, we can commute them.
      have h_comm : ∀ x t a, (HNURealSpace.schedule (fun y s => (selector *ᵥ fun t => ψ y (t, s)) t) x a) = (selector *ᵥ fun t => (HNURealSpace.schedule (fun y s => ψ y (t, s)) x) a) t := by
        have h_linear : ∀ x t a, (HNURealSpace.schedule (fun y s => (selector *ᵥ fun t => ψ y (t, s)) t) x) a = (selector *ᵥ fun t => (HNURealSpace.schedule (fun y s => ψ y (t, s)) x) a) t := by
          intro x t a
          have h_linear_step : ∀ (ψ φ : HNURealSpace.State L), HNURealSpace.schedule (ψ + φ) = HNURealSpace.schedule ψ + HNURealSpace.schedule φ := by
            have h_linear_step : ∀ (ψ φ : HNURealSpace.State L), ∀ (P Q : M2) (σ : HNURealSpace.Site L ≃ HNURealSpace.Site L), HNURealSpace.condShift P Q σ (ψ + φ) = HNURealSpace.condShift P Q σ ψ + HNURealSpace.condShift P Q σ φ := by
              intros ψ φ P Q σ; ext x; simp [HNURealSpace.condShift, Matrix.mulVec_add, Matrix.mulVec_smul]; ring;
            simp +decide [ HNURealSpace.schedule, h_linear_step ];
            simp +decide [ HNURealSpace.W1, HNURealSpace.W2, HNURealSpace.W3, HNURealSpace.W4, HNURealSpace.W5, HNURealSpace.W6, HNURealSpace.W7, HNURealSpace.W8, h_linear_step ]
          have h_linear_step : ∀ (c : ℂ) (ψ : HNURealSpace.State L), HNURealSpace.schedule (c • ψ) = c • HNURealSpace.schedule ψ := by
            have h_linear_step : ∀ (c : ℂ) (ψ : HNURealSpace.State L), ∀ (σ : Site L ≃ Site L) (s : M2), HNURealSpace.condShift (Pplus s) (Pminus s) σ (c • ψ) = c • HNURealSpace.condShift (Pplus s) (Pminus s) σ ψ := by
              intros c ψ σ s; ext x; simp [HNURealSpace.condShift, Matrix.mulVec_smul]; ring;
            have h_linear_step : ∀ (c : ℂ) (ψ : HNURealSpace.State L) (σ : Site L ≃ Site L) (s : M2), HNURealSpace.condShift (Pminus s) (Pplus s) σ (c • ψ) = c • HNURealSpace.condShift (Pminus s) (Pplus s) σ ψ := by
              intros c ψ σ s; ext x; simp [HNURealSpace.condShift, Matrix.mulVec, dotProduct, Fin.sum_univ_three];
              ring;
            unfold HNURealSpace.schedule; simp +decide [ *, HNURealSpace.W1, HNURealSpace.W2, HNURealSpace.W3, HNURealSpace.W4, HNURealSpace.W5, HNURealSpace.W6, HNURealSpace.W7, HNURealSpace.W8 ] ;
          simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ];
          rename_i h;
          rw [ show ( fun y s => selector t 0 * ψ y ( 0, s ) + selector t 1 * ψ y ( 1, s ) + selector t 2 * ψ y ( 2, s ) ) = ( fun y s => selector t 0 * ψ y ( 0, s ) ) + ( fun y s => selector t 1 * ψ y ( 1, s ) ) + ( fun y s => selector t 2 * ψ y ( 2, s ) ) by ext; simp +decide [ mul_comm ] ] ; simp +decide [ h, h_linear_step ] ;
          congr! 1;
          · congr! 1;
            · convert congr_fun ( congr_fun ( h_linear_step ( selector t 0 ) ( fun y s => ψ y ( 0, s ) ) ) x ) a using 1;
            · convert congr_fun ( congr_fun ( h_linear_step ( selector t 1 ) ( fun y s => ψ y ( 1, s ) ) ) x ) a using 1;
          · convert congr_fun ( congr_fun ( h_linear_step ( selector t 2 ) ( fun y s => ψ y ( 2, s ) ) ) x ) a using 1;
        assumption;
      intro x; ext q; unfold selected scheduleLift; simp +decide [ h_comm ] ;

/-
Selected block of the complete update.
-/
lemma selected_update {L : ℕ} [NeZero L] (ψ : ExtendedState L) :
    selected (update ψ) = scheduleLift (selected ψ) := by
      -- By definition of selected, we can distribute it over the subtraction.
      have h_selected_sub : selected (scheduleLift (selected ψ) - complement ψ) = selected (scheduleLift (selected ψ)) - selected (complement ψ) := by
        ext x q; simp +decide [ selected, Matrix.mulVec ] ;
        simp +decide [ dotProduct, Finset.sum_sub_distrib, mul_sub ];
      convert h_selected_sub using 1;
      rw [ selected_scheduleLift ];
      ext x q; simp +decide [ selected, complement ] ;
      simp +decide [ selector_mul_complement, Matrix.mulVec ];
      unfold selected; simp +decide [ selector_idempotent ] ;

/-
Complement block of the complete update, displaying the pi phase.
-/
lemma complement_update {L : ℕ} [NeZero L] (ψ : ExtendedState L) :
    complement (update ψ) = - complement ψ := by
      have h_complement_update : ∀ x q, (complement (update ψ) x q) = (complement (scheduleLift (selected ψ)) x q) - (complement (complement ψ) x q) := by
        unfold update complement;
        simp +decide [ Matrix.mulVec, dotProduct ];
        simp +decide [ mul_sub, Finset.sum_sub_distrib ];
      -- By definition of $complement$, we know that $complement (scheduleLift (selected ψ)) = 0$.
      have h_complement_scheduleLift_selected : ∀ x q, (complement (scheduleLift (selected ψ)) x q) = 0 := by
        intro x q
        have h_complement_scheduleLift_selected : ∀ x q, (complement (selected (scheduleLift ψ)) x q) = 0 := by
          intros x q
          have h_complement_scheduleLift_selected : ∀ x q, (selector *ᵥ (fun t => (selected (scheduleLift ψ) x) (t, q.2))) q.1 = (selected (scheduleLift ψ) x) q := by
            intros x q
            simp [selected];
            rw [ FloquetTransverseComposite.selector_idempotent ];
          unfold complement;
          simp +decide [ Matrix.sub_mulVec, h_complement_scheduleLift_selected ];
        convert h_complement_scheduleLift_selected x q using 1;
        rw [ selected_scheduleLift ];
      ext x q; simp [h_complement_update, h_complement_scheduleLift_selected];
      unfold complement; simp +decide [ complement_idempotent ] ;

/-
Negating both arguments preserves the full Hermitian inner product.
-/
lemma inner_neg_neg {L : ℕ} (ψ φ : ExtendedState L) : inner (-ψ) (-φ) = inner ψ φ := by
  unfold inner;
  unfold HNURealSpace.gInner; simp +decide [ HNURealSpace.sinner ] ;

/-
Full inner-product preservation, not merely selected-sector isometry.
-/
theorem update_inner {L : ℕ} [NeZero L] (ψ φ : ExtendedState L) :
    inner (update ψ) (update φ) = inner ψ φ := by
      convert inner_sector_split ( update ψ ) ( update φ ) using 1;
      rw [ selected_update, selected_update, complement_update, complement_update ];
      rw [ scheduleLift_inner, inner_neg_neg, ← inner_sector_split ]

/-
Exact Fourier intertwiner with the already-audited `hnuPiComposite`.
-/
theorem update_fourier {L : ℕ} [NeZero L] (hL : 2 ≤ L) (k : Site L)
    (a : TSite × Spin → ℂ) :
    update (extendedPlaneWave k a) =
      extendedPlaneWave k (hnuPiComposite (HNURealSpace.kR k) *ᵥ a) := by
        -- By definition of update, we have:
        funext x q; simp [update, scheduleLift, selected, complement, extendedPlaneWave];
        simp +decide [ HNURealSpace.schedule_symbol, hnuPiComposite, controlled, Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_left_comm, mul_comm ];
        rw [ show ( fun y s => ∑ x, a ( x, s ) * ( selector q.1 x * HNURealSpace.char k y ) ) = fun y s => HNURealSpace.char k y * ∑ x, a ( x, s ) * selector q.1 x by ext y s; rw [ Finset.mul_sum _ _ _ ] ; ac_rfl ];
        convert congr_arg₂ ( · - · ) ( congr_arg ( fun f => f x q.2 ) ( HNURealSpace.schedule_symbol hL k ( fun s => ∑ x, a ( x, s ) * selector q.1 x ) ) ) rfl using 1;
        simp +decide [ HNURealSpace.planeWave, Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_left_comm, mul_comm ];
        simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul, Vpi ];
        rw [ show ( Finset.univ : Finset ( TSite × Spin ) ) = Finset.image ( fun x : TSite => ( x, 0 ) ) Finset.univ ∪ Finset.image ( fun x : TSite => ( x, 1 ) ) Finset.univ from ?_, Finset.sum_union ];
        · rw [ Finset.sum_union ];
          · cases q.2 ; simp +decide [ Finset.sum_image, Matrix.one_apply ] ; ring;
            interval_cases ( ‹_› : ℕ ) <;> simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] <;> ring;
          · simp +decide [ Finset.disjoint_left ];
        · simp +decide [ Finset.disjoint_left ];
        · decide +revert

/-- A generic selected-sector conditioned spatial primitive, with an onsite
stay action on the transverse complement. -/
def primitiveAt {L : ℕ} (P Q : HNUExactCore.M2) (σ : Site L ≃ Site L)
    (ψ : ExtendedState L) : ExtendedState L :=
  fun x q => (selector *ᵥ (fun t =>
      (P *ᵥ (fun s => ψ (σ x) (t,s)) + Q *ᵥ (fun s => ψ x (t,s))) q.2)) q.1
    + (((1 : Matrix TSite TSite ℂ) - selector) *ᵥ
        (fun t => ψ x (t,q.2))) q.1

/-
Strict one-edge support for every spatial primitive: equality at the site
and its single shifted neighbour suffices.
-/
theorem primitiveAt_local {L : ℕ} (P Q : HNUExactCore.M2) (σ : Site L ≃ Site L)
    {ψ φ : ExtendedState L} {x : Site L}
    (hnear : ψ (σ x) = φ (σ x)) (here : ψ x = φ x) :
    primitiveAt P Q σ ψ x = primitiveAt P Q σ φ x := by
      unfold primitiveAt; aesop;

/-
The transverse selector itself is strictly onsite.
-/
theorem selected_onsite {L : ℕ} {ψ φ : ExtendedState L} {x : Site L}
    (h : ψ x = φ x) : selected ψ x = selected φ x := by
      unfold selected; aesop;

/-
Nonzero selected origin witness.
-/
theorem selected_origin_witness {L : ℕ} [NeZero L] :
    encode (HNURealSpace.planeWave (HNURealSpace.char (0 : Site L)) ![1,0]) ≠ 0 ∧
    update (encode (HNURealSpace.planeWave (HNURealSpace.char (0 : Site L)) ![1,0])) =
      encode (HNURealSpace.planeWave (HNURealSpace.char (0 : Site L)) ![1,0]) := by
        constructor;
        · intro h; have := congr_fun ( congr_fun h ⟨ 0, 0, 0 ⟩ ) ( 0, 0 ) ; simp_all +decide [ encode, HNURealSpace.planeWave ] ;
          unfold w at this; simp_all +decide [ HNURealSpace.char ] ;
          exact absurd ( this.resolve_left ( by exact Complex.exp_ne_zero _ ) ) ( by exact Complex.exp_ne_zero _ );
        · convert update_encode _;
          ext x q;
          unfold HNURealSpace.schedule; simp +decide [ HNURealSpace.planeWave ] ;
          unfold HNURealSpace.W1 HNURealSpace.W2 HNURealSpace.W3 HNURealSpace.W4 HNURealSpace.W5 HNURealSpace.W6 HNURealSpace.W7 HNURealSpace.W8 HNURealSpace.planeWave; simp +decide [ HNURealSpace.char ] ;
          unfold HNURealSpace.cphase; norm_num [ HNURealSpace.condShift ] ;
          simp +decide [ Pplus, Pminus, σ1, σ2, σ3 ];
          norm_num [ Fin.forall_fin_two, Matrix.vecHead, Matrix.vecTail, Matrix.vecMul, Matrix.mulVec ] at *;
          fin_cases q <;> norm_num [ Matrix.one_apply ]

/-
Explicit nonzero pi-complement witness.
-/
theorem pi_complement_witness {L : ℕ} [NeZero L] :
    let ξ : ExtendedState L := fun _ q => (![0,1,0] : TSite → ℂ) q.1 *
      (![1,0] : Spin → ℂ) q.2
    ξ ≠ 0 ∧ update ξ = -ξ := by
      refine' ⟨ _, _ ⟩;
      · intro h; have := congr_fun ( congr_fun h ⟨ 0, 0, 1 ⟩ ) ⟨ 1, 0 ⟩ ; simp +decide at this;
      · convert update_complement _ _ _;
        ext i; fin_cases i <;> simp +decide [ selector_mulVec, w, dotProduct, Fin.sum_univ_three ] ;

end
end PhysicsSM.Draft.NullEdge.HNUDecodedLocalStay
