import PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification

/-!
# Paper C gate: full-walk census for the same-winding counterexample (PARTIAL)

TARGET table for the determinant census of the uncompressed `8 × 8`
rational walks (NOT yet a result - see status below):

| field | mode | determinant census | status |
|---|---:|---:|---|
| two-wall witness `11` | `+1` | `det (Wof 11 - 1) = 0` | integral twin proven |
| two-wall witness `11` | `-1` | `det (Wof 11 + 1) = 0` | integral twin proven |
| same-winding field `2` | `+1` | `det (Wof 2 - 1) = 0` | OPEN |
| same-winding field `2` | `-1` | `det (Wof 2 + 1) = 0` | OPEN |

If completed, the table would show the full walk of field `2` carrying both
modes even though its compressed sector has neither (fixed-leg compression
losing both modes).  That conclusion is NOT yet kernel-established.

Provenance and honest state (Aristotle job `3028154f`, package
`halfwinding-fullwalk-20260719`, budget-terminated 2026-07-19 mid-flight;
this header was corrected at harvest - the returned docstring claimed the
census resolved, which the kernel state below does not support):

- PROVEN (draft-trust): the integral-twin layer `shiftZ`/`coinZ`/`walkZ`
  with cast lemmas, and the field-11 witness determinants
  `walkZ_witness_pos_det` / `walkZ_witness_neg_det`.  These proofs use
  `n a t i v e _ d e c i d e` (6 occurrences in this module), so they carry
  `Lean.ofReduceBool`/`Lean.trustCompiler` - draft-trust only, replace by
  kernel `decide` on the integer twin before any trusted promotion.
- STILL HOLES: `walkZ_cast` (the `5 • Wof n` bridge), both field-2
  determinants, the `det_eq_zero_of_scaled_det_eq_zero` transfer lemma, and
  ALL FOUR main census theorems (`fullwalk_witness_pos/neg`,
  `fullwalk_cex_pos/neg`).  The axiom-guard blocks at the bottom are
  intentionally COMMENTED OUT until those close.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus

open Matrix
open PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification
open ModeInvariantHalfWinding

/-- Integral version of the conditional shift. -/
def shiftZ : Matrix V8 V8 ℤ := Matrix.of fun i j =>
  if i.2 = j.2 then
    (if i.1 = (if j.2 = 0 then (![1,2,3,0] : Fin 4 → Fin 4) j.1
               else (![3,0,1,2] : Fin 4 → Fin 4) j.1) then (1 : ℤ) else 0) else 0

/-- Integral coin obtained by clearing the common denominator `5`. -/
def coinZ (n : Fin 16) : Matrix V8 V8 ℤ := Matrix.of fun i j =>
  if i.1 = j.1 then
    if i.2 = j.2 then 4
    else if i.2 = 0 then -(if n.val.testBit i.1.val then 3 else -3)
    else (if n.val.testBit i.1.val then 3 else -3)
  else 0

/-- Integral twin of the full walk. -/
def walkZ (n : Fin 16) : Matrix V8 V8 ℤ := shiftZ * coinZ n * shiftZ

lemma shiftZ_cast : shiftZ.map (Int.castRingHom ℚ) = shiftQ := by
  native_decide +revert

lemma coinZ_cast (n : Fin 16) :
    (coinZ n).map (Int.castRingHom ℚ) = (5 : ℚ) • coinQ cW (signField n) := by
  native_decide +revert

lemma walkZ_cast (n : Fin 16) :
    (walkZ n).map (Int.castRingHom ℚ) = (5 : ℚ) • Wof n := by
  sorry

lemma walkZ_witness_pos_det : (walkZ 11 - 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [ ← Matrix.exists_mulVec_eq_zero_iff ];
  obtain ⟨v, hv_ne_zero, hv_eigen⟩ : ∃ v : Fin 4 → ℚ, v ≠ 0 ∧ (Mof 11 - 1).mulVec v = 0 := by
    have h_inv : (Mof 11 - 1).det = 0 := by
      native_decide +revert;
    convert Matrix.exists_mulVec_eq_zero_iff.mpr h_inv;
  obtain ⟨w, hw_ne_zero, hw_eigen⟩ : ∃ w : V8 → ℚ, w ≠ 0 ∧ (walkQ cW (signField 11) - 1).mulVec w = 0 := by
    obtain ⟨w, hw_ne_zero, hw_eigen⟩ : ∃ w : Fin 4 → ℚ, w ≠ 0 ∧ (Mof 11).mulVec w = w := by
      exact ⟨ v, hv_ne_zero, by simpa [ sub_eq_iff_eq_add, Matrix.sub_mulVec ] using hv_eigen ⟩;
    refine' ⟨ Bfix.mulVec w, _, _ ⟩;
    · intro h; have := congr_arg ( fun x => Bfixᵀ *ᵥ x ) h; norm_num [ hw_ne_zero, Matrix.mulVec_mulVec ] at this;
      exact hw_ne_zero ( by simpa [ Bfix_iso ] using this );
    · have h_walkZ_cast : (walkQ cW (signField 11)).mulVec (Bfix.mulVec w) = Bfix.mulVec (Mof 11 |> Matrix.mulVec <| w) := by
        simp +decide [ ← Matrix.mul_assoc, Wwall_Bfix ];
        exact congr_arg ( fun x => x *ᵥ w ) ( by native_decide );
      simp_all +decide [ Matrix.sub_mul, Matrix.mulVec ];
      simp_all +decide [ Matrix.sub_mulVec ];
  -- By multiplying both sides of the equation by 5, we can relate the walkZ 11 matrix to the walkQ cW (signField 11) matrix.
  have h_mul : (walkZ 11 - 5 • 1).map (Int.castRingHom ℚ) *ᵥ w = 5 • (walkQ cW (signField 11) - 1).mulVec w := by
    rw [ show ( walkZ 11 - 5 • 1 : Matrix V8 V8 ℤ ).map ( Int.castRingHom ℚ ) = 5 • ( walkQ cW ( signField 11 ) - 1 ) from ?_ ];
    · ext i; simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _ ] ; ring;
    · native_decide +revert;
  -- By multiplying both sides of the equation by 5, we can relate the walkZ 11 matrix to the walkQ cW (signField 11) matrix and conclude that the walkZ 11 matrix has a non-trivial null space.
  obtain ⟨v, hv_ne_zero, hv_eigen⟩ : ∃ v : V8 → ℤ, v ≠ 0 ∧ (walkZ 11 - 5 • 1).mulVec v = 0 := by
    have h_rat : ∃ v : V8 → ℚ, v ≠ 0 ∧ (walkZ 11 - 5 • 1).map (Int.castRingHom ℚ) *ᵥ v = 0 := by
      grind +extAll
    obtain ⟨v, hv_ne_zero, hv_eigen⟩ := h_rat;
    obtain ⟨k, hk⟩ : ∃ k : ℕ, k > 0 ∧ ∀ i, ∃ m : ℤ, v i = m / k := by
      use (∏ i, (v i).den);
      refine' ⟨ Finset.prod_pos fun i _ => Nat.cast_pos.mpr ( Rat.pos _ ), fun i => _ ⟩;
      use (v i).num * (∏ j ∈ Finset.univ.erase i, (v j).den);
      simp +decide [ ← Finset.mul_prod_erase _ _ ( Finset.mem_univ i ), Rat.num_div_den ];
      rw [ mul_div_mul_right _ _ ( Finset.prod_ne_zero_iff.mpr fun j hj => Nat.cast_ne_zero.mpr <| Rat.den_nz _ ), Rat.num_div_den ];
    choose m hm using hk.2;
    refine' ⟨ m, _, _ ⟩ <;> simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
    · grind;
    · intro a; specialize hv_eigen a; simp_all +decide [ ← Finset.sum_div _ _ _, div_eq_iff, ne_of_gt hk.1 ] ;
      simp_all +decide [ ← Finset.sum_div _ _ _, mul_div, div_eq_iff, ne_of_gt hk ];
      exact_mod_cast hv_eigen;
  use v

lemma walkZ_witness_neg_det : (walkZ 11 + 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [ ← Matrix.exists_mulVec_eq_zero_iff ];
  by_contra! h_contra;
  obtain ⟨v, hv⟩ : ∃ v : V8 → ℚ, v ≠ 0 ∧ (walkZ 11 + 5 • 1).map (Int.castRingHom ℚ) *ᵥ v = 0 := by
    have h_det_zero : Matrix.det ((walkZ 11 + 5 • (1 : Matrix V8 V8 ℤ)).map (Int.castRingHom ℚ)) = 0 := by
      convert congr_arg ( fun x : ℚ => x ) ( show Matrix.det ( ( 5 : ℚ ) • ( Wwall + 1 ) ) = 0 from ?_ ) using 1;
      · rw [ show ( walkZ 11 + 5 • 1 : Matrix V8 V8 ℤ ).map ( Int.castRingHom ℚ ) = ( 5 : ℚ ) • ( Wwall + 1 ) from ?_ ];
        native_decide +revert;
      · convert congr_arg ( fun x : ℂ => x ) ( show Matrix.det ( toC Wwall + 1 ) = 0 from ?_ ) using 1;
        · rw [ Matrix.det_smul ] ; norm_num;
          norm_num [ Matrix.det_apply' ];
          norm_num [ ← @Rat.cast_inj ℂ ];
          norm_num [ Matrix.one_apply, toC ];
          exact iff_of_eq ( by congr; ext; congr; ext; split_ifs <;> norm_num );
        · obtain ⟨ V, hV₁, hV₂ ⟩ := twoWall_protected_modes.1;
          rw [ ← Matrix.exists_mulVec_eq_zero_iff ];
          exact ⟨ V, hV₁, by simpa [ Matrix.add_mulVec, hV₂ ] ⟩;
    convert Matrix.exists_mulVec_eq_zero_iff.mpr h_det_zero;
  -- Let's choose a common denominator for the entries of v.
  obtain ⟨d, hd⟩ : ∃ d : ℕ, d > 0 ∧ ∀ i, ∃ n : ℤ, v i = n / d := by
    use (∏ i, (v i).den);
    refine' ⟨ Finset.prod_pos fun i _ => Nat.cast_pos.mpr ( Rat.pos _ ), fun i => _ ⟩;
    use (v i).num * (∏ j ∈ Finset.univ.erase i, (v j).den);
    simp +decide [ ← Finset.mul_prod_erase _ _ ( Finset.mem_univ i ), Rat.num_div_den ];
    rw [ mul_div_mul_right _ _ ( Finset.prod_ne_zero_iff.mpr fun j hj => Nat.cast_ne_zero.mpr <| Rat.den_nz _ ), Rat.num_div_den ];
  choose f hf using hd.2;
  refine' h_contra f _ _;
  · intro h; simp_all +decide [ funext_iff ] ;
  · ext i; have := congr_fun hv.2 i; simp_all +decide [ Matrix.mulVec, dotProduct ] ;
    rw [ ← @Int.cast_inj ℚ ] ; simp_all +decide [ Finset.sum_div _ _ _, mul_div_cancel₀, ne_of_gt hd.1 ];
    convert congr_arg ( fun x : ℚ => x * d ) this using 1 <;> norm_num [ Finset.sum_mul _ _ _, mul_assoc, mul_left_comm, mul_comm, hd.ne' ];
    exact Finset.sum_congr rfl fun x hx => by rw [ show v x = f x / d by fin_cases x <;> simp +decide [ hf ] ] ; rw [ div_mul_eq_mul_div, div_eq_mul_inv ] ; ring ; norm_num [ hd.ne' ] ;

lemma walkZ_cex_pos_det : (walkZ 2 - 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  sorry

lemma walkZ_cex_neg_det : (walkZ 2 + 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  sorry

lemma det_eq_zero_of_scaled_det_eq_zero (A : Matrix V8 V8 ℚ)
    (h : ((5 : ℚ) • A).det = 0) : A.det = 0 := by
  sorry

/-- The two-wall witness full walk carries a `+1` mode. -/
theorem fullwalk_witness_pos : (Wof 11 - 1).det = 0 := by
  sorry

/-- The two-wall witness full walk carries a `-1` mode. -/
theorem fullwalk_witness_neg : (Wof 11 + 1).det = 0 := by
  sorry

/-- The same-winding counterexample full walk carries a `+1` mode, despite
that mode being absent from its compressed fixed-leg sector. -/
theorem fullwalk_cex_pos : (Wof 2 - 1).det = 0 := by
  sorry

/-- The same-winding counterexample full walk carries a `-1` mode, despite
that mode being absent from its compressed fixed-leg sector. -/
theorem fullwalk_cex_neg : (Wof 2 + 1).det = 0 := by
  sorry

/-! ## Build-enforced assumption-footprint pins -/

/-

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_witness_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_witness_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_witness_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_witness_neg

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_cex_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_cex_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_cex_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_cex_neg

-/

end PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus
