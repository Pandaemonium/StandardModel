import PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-!
# Global zero/pi gap target for the massive HNU walk

This module proves the strongest immediate consequence suggested by the exact
HNU census and the Pluecker mass composition. The headline claim is global
over the closed Brillouin cube and is not implied by exact unitarity or by the
infrared Dirac tangent alone.

The endpoint-centrality and massive-crossing reductions were proved in two
independent Aristotle jobs and composed here only after local review. Their
provenance is `e98719ee-0bc7-4449-ae38-b84a3c22fcaf` and
`46717581-7d99-422d-9bca-cdecd2692383`. No numerical oracle is used in the
proofs below.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

/-- Closed first Brillouin cube in the conventions of `HNUExactCore`. -/
def InBZ (k : Fin 3 -> Real) : Prop :=
  forall i, Set.Icc (-Real.pi) Real.pi (k i)

/-- Boundary of the chosen closed Brillouin cube. -/
def OnBZBoundary (k : Fin 3 -> Real) : Prop :=
  Exists fun i => k i = Real.pi ∨ k i = -Real.pi

set_option maxHeartbeats 800000 in
/-- The diagonal entry of reversal equality gives the first exact trigonometric
constraint. -/
lemma endpoint_reversal_diag_constraint (k : Fin 3 -> Real)
    (h : endpoint k = endpoint (fun i => -k i)) :
    Real.sin (k 2) * (1 + Real.cos (k 0)) * (1 + Real.cos (k 1)) = 0 := by
  unfold endpoint at h;
  simp_all +decide [ Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3 ];
  replace h := congr_arg ( fun m => m 0 0 ) h ; norm_num [ Matrix.mul_apply, Complex.exp_re, Complex.exp_im, pow_two ] at h ; ring_nf at h ;
  norm_num [ mul_assoc, ← Complex.exp_nat_mul, ← Complex.exp_add ] at * ; ring_nf at * ; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] at *;
  norm_num [ Real.sin_add, Real.sin_sub, Real.cos_add, Real.cos_sub ] at * ; ring_nf at * ; norm_num at *;
  grind

/-- Once the third coordinate vanishes, the off-diagonal entry gives the two
remaining exact trigonometric constraints. -/
lemma endpoint_reversal_offdiag_constraints (k : Fin 3 -> Real)
    (hk2 : k 2 = 0) (h : endpoint k = endpoint (fun i => -k i)) :
    Real.sin (k 0) * (1 + Real.cos (k 1)) = 0 ∧
      Real.sin (k 1) * (1 + Real.cos (k 0)) = 0 := by
  unfold endpoint at h;
  simp_all +decide [ Uplus, Uminus, Pplus, Pminus, σ1, σ2, σ3 ];
  replace h := congr_fun ( congr_fun h 0 ) 1 ; norm_num [ Complex.ext_iff, Matrix.mul_apply ] at h;
  norm_num [ Complex.exp_re, Complex.exp_im ] at * ; ring_nf at * ; norm_num at *;
  norm_num [ Real.sin_sq ] at * ; ring_nf at * ;
  grind

/-- Reversal equality forces the endpoint into one of the two central Floquet
sectors. -/
lemma endpoint_eq_reverse_imp_central (k : Fin 3 -> Real) (hk : InBZ k)
    (h : endpoint k = endpoint (fun i => -k i)) :
    endpoint k = 1 ∨ endpoint k = -1 := by
  have := HNUExactCore.zero_census k;
  have := HNUExactCore.pi_census k;
  have := endpoint_reversal_diag_constraint k h; simp_all +decide [ Fin.forall_fin_succ ] ;
  by_cases h0 : 1 + Real.cos (k 0) = 0 <;> by_cases h1 : 1 + Real.cos (k 1) = 0 <;> simp_all +decide [ Real.sin_eq_zero_iff_cos_eq ];
  · exact Or.inr ( this ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) ( hk 2 |>.1 ) ( hk 2 |>.2 ) |>.2 ⟨ 0, by
      obtain ⟨ m, hm ⟩ := Real.cos_eq_cos_iff.mp ( show Real.cos ( k 0 ) = Real.cos ( Real.pi ) by norm_num; linarith );
      rcases hm with ( hm | hm ) <;> rcases m with ⟨ _ | _ | m ⟩ <;> norm_num at hm <;> first | left; nlinarith [ Real.pi_pos, hk 0 |>.1, hk 0 |>.2 ] | right; nlinarith [ Real.pi_pos, hk 0 |>.1, hk 0 |>.2 ] ; ⟩ );
  · have h0 : k 0 = Real.pi ∨ k 0 = -Real.pi := by
      obtain ⟨ m, hm ⟩ := Real.cos_eq_neg_one_iff.mp ( by linarith : Real.cos ( k 0 ) = -1 );
      rcases m with ( ⟨ _ | _ | m ⟩ | ⟨ _ | _ | m ⟩ ) <;> norm_num at hm <;> first | left; nlinarith [ Real.pi_pos, hk 0 |>.1, hk 0 |>.2 ] | right; nlinarith [ Real.pi_pos, hk 0 |>.1, hk 0 |>.2 ] ;
    exact Or.inr ( this ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) ( hk 2 |>.1 ) ( hk 2 |>.2 ) |>.2 ⟨ 0, h0 ⟩ );
  · exact Or.inr ( this ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) ( hk 2 |>.1 ) ( hk 2 |>.2 ) |>.2 ⟨ 1, by
      obtain ⟨ m, hm ⟩ := Real.cos_eq_neg_one_iff.mp ( by linarith : Real.cos ( k 1 ) = -1 );
      rcases m with ( ⟨ _ | _ | m ⟩ | ⟨ _ | _ | m ⟩ ) <;> norm_num at hm <;> first | left; nlinarith [ Real.pi_pos, hk 1 |>.1, hk 1 |>.2 ] | right; nlinarith [ Real.pi_pos, hk 1 |>.1, hk 1 |>.2 ] ; ⟩ );
  · cases this <;> simp_all +decide [ Real.cos_eq_one_iff, Real.cos_eq_neg_one_iff ];
    · rcases ‹∃ n : ℤ, _› with ⟨ n, hn ⟩ ; rcases n with ⟨ _ | _ | n ⟩ <;> norm_num at hn <;> first | left; nlinarith [ Real.pi_pos, hk 2 |>.1, hk 2 |>.2 ] | skip;
      have := endpoint_reversal_offdiag_constraints k ( by linarith ) h; simp_all +decide [ Real.sin_eq_zero_iff_cos_eq ] ;
      norm_num [ ← hn ] at *;
      simp_all +decide [ Real.sin_eq_zero_iff_cos_eq ];
      cases this.1 <;> cases this.2 <;> simp_all +decide [ add_eq_zero_iff_eq_neg ];
      exact Or.inl ( by rename_i h₁ h₂; exact ‹-Real.pi ≤ k 0 → k 0 ≤ Real.pi → -Real.pi ≤ k 1 → k 1 ≤ Real.pi → 0 ≤ Real.pi → ( ( endpoint fun i => -k i ) = 1 ↔ k 0 = 0 ∧ k 1 = 0 ) › ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) Real.pi_pos.le |>.2 ⟨ by rw [ Real.cos_eq_one_iff ] at h₁; obtain ⟨ n, hn ⟩ := h₁; rcases n with ⟨ _ | n ⟩ <;> norm_num at hn <;> nlinarith [ Real.pi_pos, hk 0 |>.1, hk 0 |>.2 ], by rw [ Real.cos_eq_one_iff ] at h₂; obtain ⟨ n, hn ⟩ := h₂; rcases n with ⟨ _ | n ⟩ <;> norm_num at hn <;> nlinarith [ Real.pi_pos, hk 1 |>.1, hk 1 |>.2 ] ⟩ );
    · rename_i h; rcases h with ⟨ i, hi ⟩ ; rcases i with ⟨ _ | _ | i ⟩ <;> norm_num at hi <;> first | nlinarith [ Real.pi_pos, hk 2 |>.1, hk 2 |>.2 ] | skip;
      · exact Or.inr ( this ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) ( hk 2 |>.1 ) ( hk 2 |>.2 ) |>.2 ⟨ 2, Or.inl hi.symm ⟩ );
      · exact Or.inr ( this ( hk 0 |>.1 ) ( hk 0 |>.2 ) ( hk 1 |>.1 ) ( hk 1 |>.2 ) ( hk 2 |>.1 ) ( hk 2 |>.2 ) |>.2 ⟨ 2, Or.inr <| by nlinarith [ Real.pi_pos, hk 2 |>.1, hk 2 |>.2 ] ⟩ )

/-- Both central endpoint sectors are invariant under momentum reversal. -/
lemma endpoint_central_imp_eq_reverse (k : Fin 3 -> Real)
    (h : endpoint k = 1 ∨ endpoint k = -1) :
    endpoint k = endpoint (fun i => -k i) := by
  cases h <;> simp_all +decide [trace_endpoint]
  · rw [← HNUExactCore.endpoint_eq_one_of_trace]
    convert HNUExactCore.trace_endpoint (fun i => -k i) using 1
    have := HNUExactCore.trace_endpoint k
    simp_all +decide [Complex.ext_iff]
    ring
    norm_num [Complex.cos, Complex.exp_re, Complex.exp_im, sq] at *
    ring_nf at *
    aesop (simp_config := { decide := true })
  · rw [← HNUExactCore.endpoint_eq_neg_one_of_trace]
    convert HNUExactCore.trace_endpoint (fun i => -k i) using 1
    have := HNUExactCore.trace_endpoint k
    norm_num [‹endpoint k = -1›] at this
    convert this using 1
    norm_cast
    norm_num [neg_div]

/-- Hard parity census: the endpoint agrees with its momentum-reversed copy
only at the origin or on the exact pi boundary. -/
theorem endpoint_eq_momentumReverse_iff (k : Fin 3 -> Real) (hk : InBZ k) :
    endpoint k = endpoint (fun i => -k i) <->
      (forall i, k i = 0) ∨ OnBZBoundary k := by
  have hz := HNUExactCore.zero_census k hk
  have hp := HNUExactCore.pi_census k hk
  constructor
  · intro h
    rcases endpoint_eq_reverse_imp_central k hk h with h0 | hpi
    · exact Or.inl (hz.mp h0)
    · exact Or.inr (hp.mp hpi)
  · intro h
    apply endpoint_central_imp_eq_reverse k
    rcases h with h0 | hpi
    · exact Or.inl (hz.mpr h0)
    · exact Or.inr (hp.mpr hpi)

set_option maxHeartbeats 800000 in
/-- Exact shifted determinants of the local mass coin at the origin. -/
lemma massCoin4_one_shifted_determinants (a : Real) :
    (PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4 1 a - 1).det =
        (2 - 2 * Real.cos a) ^ 2 ∧
      (PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4 1 a + 1).det =
        (2 + 2 * Real.cos a) ^ 2 := by
  norm_num [Pluecker3Plus1ComplexMass.massCoin4,
    Pluecker3Plus1ComplexMass.mass4, Pluecker3Plus1ComplexMass.beta,
    Pluecker3Plus1ComplexMass.beta5, Pluecker3Plus1ComplexMass.gamma5]
  norm_num [Matrix.det_succ_row_zero, Matrix.det_fin_three]
  simp +decide [Fin.sum_univ_succ, Fin.succAbove]
  ring
  simp +decide [Fin.succAbove, Matrix.one_apply] at *
  norm_cast
  rw [show Real.sin a ^ 4 = (Real.sin a ^ 2) ^ 2 by ring,
    show Real.sin a ^ 3 = Real.sin a * Real.sin a ^ 2 by ring,
    Real.sin_sq]
  ring
  constructor <;> push_cast <;> ring

set_option maxHeartbeats 3000000 in
/-- Exact reduction of the live four-component shifted determinant to the
opposite-chirality two-component blocks. -/
lemma massiveHNU_shifted_det_reduction (a : Real) (k : Fin 3 -> Real)
    (sgn : Complex) (hsgn : sgn = 1 ∨ sgn = -1) :
    (massiveHNU (1 : Complex) a k -
        sgn • (1 : Matrix (Fin 4) (Fin 4) Complex)).det =
      (endpoint k * endpoint (fun i => -k i) -
        (sgn * Real.cos a) •
          (endpoint k + endpoint (fun i => -k i)) +
        (1 : Matrix (Fin 2) (Fin 2) Complex)).det := by
  cases hsgn <;> simp +decide [ *, massiveHNU ]
  · unfold Pluecker3Plus1ComplexMass.massCoin4
    simp +decide [ diracHNU ]
    unfold Pluecker3Plus1ComplexMass.mass4
    simp +decide [ diracBasis, doubledChiralEndpoint ]
    simp +decide [ Pluecker3Plus1ComplexMass.beta,
      Pluecker3Plus1ComplexMass.beta5, Pluecker3Plus1ComplexMass.gamma5,
      Matrix.det_succ_row_zero, Matrix.det_fin_three, Matrix.det_fin_two,
      Matrix.mul_apply, Fin.sum_univ_succ ] at *
    simp +decide [ Matrix.vecMul, dotProduct, Fin.sum_univ_succ ]
    simp +decide [ Fin.succAbove, Matrix.one_apply ]
    field_simp
    norm_cast
    norm_num [ pow_succ, mul_assoc ]
    ring
    norm_num [ Complex.sin_sq ]
    ring
    grind +suggestions
  · unfold diracHNU Pluecker3Plus1ComplexMass.massCoin4
      Pluecker3Plus1ComplexMass.mass4 Pluecker3Plus1ComplexMass.beta
      Pluecker3Plus1ComplexMass.beta5 Pluecker3Plus1ComplexMass.gamma5
    unfold diracBasis doubledChiralEndpoint
    norm_num [ Matrix.det_succ_row_zero ]
    simp +decide [ Fin.sum_univ_succ, Fin.succAbove, Matrix.mul_apply,
      Matrix.one_apply ] at *
    simp +decide [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] at *
    ring_nf at *
    norm_cast
    norm_num [ show (Real.sqrt 2 : Real) ^ 6 = (Real.sqrt 2 ^ 2) ^ 3 by ring,
      show (Real.sqrt 2 : Real) ^ 8 = (Real.sqrt 2 ^ 2) ^ 4 by ring ]
    ring_nf
    norm_cast
    norm_num [ show (Real.sqrt 2 : Real) ^ 4 = (Real.sqrt 2 ^ 2) ^ 2 by ring,
      show (Real.sqrt 2 : Real) ^ 2 = 2 by norm_num ]
    ring
    grind +suggestions

set_option maxHeartbeats 800000 in
/-- Two determinant-one unitary matrices with equal trace cannot make the
reduced massive crossing determinant vanish at a nonzero sine unless they
coincide. -/
lemma su2_pair_massive_det_zero_imp_eq (a : Real) (hsin : Real.sin a != 0)
    (U V : Matrix (Fin 2) (Fin 2) Complex)
    (hU : U ∈ Matrix.unitaryGroup (Fin 2) Complex)
    (hV : V ∈ Matrix.unitaryGroup (Fin 2) Complex)
    (hUdet : U.det = 1) (hVdet : V.det = 1)
    (htrace : U.trace = V.trace)
    (sgn : Complex) (hsgn : sgn = 1 ∨ sgn = -1)
    (hdet : (U * V - (sgn * Real.cos a) • (U + V) + 1).det = 0) :
    U = V := by
  have h_entries : ∃ r x y z r' x' y' z' : Real,
      U = !![r + x * Complex.I, y + z * Complex.I;
        -y + z * Complex.I, r - x * Complex.I] ∧
      V = !![r' + x' * Complex.I, y' + z' * Complex.I;
        -y' + z' * Complex.I, r' - x' * Complex.I] := by
    have h_entries : ∀ (W : Matrix (Fin 2) (Fin 2) Complex),
        W ∈ unitaryGroup (Fin 2) Complex -> W.det = 1 ->
        ∃ r x y z : Real,
          W = !![r + x * Complex.I, y + z * Complex.I;
            -y + z * Complex.I, r - x * Complex.I] := by
      intros W hW hWdet
      obtain ⟨a, b, c, d, ha, hb, hc, hd⟩ :
          ∃ a b c d : Complex, W = !![a, b; c, d] ∧
            a * star a + b * star b = 1 ∧
            a * star c + b * star d = 0 ∧
            c * star a + d * star b = 0 ∧
            c * star c + d * star d = 1 ∧ a * d - b * c = 1 := by
        simp_all +decide [ Matrix.mem_unitaryGroup_iff, Matrix.det_fin_two ]
        simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two,
          Matrix.mul_apply ]
      simp_all +decide [ Complex.ext_iff ]
      grind
    exact ⟨ _, _, _, _, _, _, _, _,
      h_entries U hU hUdet |> Classical.choose_spec |> Classical.choose_spec |>
        Classical.choose_spec |> Classical.choose_spec,
      h_entries V hV hVdet |> Classical.choose_spec |> Classical.choose_spec |>
        Classical.choose_spec |> Classical.choose_spec ⟩
  obtain ⟨ r, x, y, z, r', x', y', z', rfl, rfl ⟩ := h_entries
  simp_all +decide [ Complex.ext_iff, Matrix.det_fin_two,
    Matrix.trace_fin_two ]
  cases hsgn <;> simp_all +decide [ Complex.cos_ofReal_re,
    Complex.sin_ofReal_re ]
  · norm_num [ show r = r' by linarith ] at *
    have h_eq : (r' - Real.cos a)^2 + (x - x')^2 + (y - y')^2 +
        (z - z')^2 = 0 := by
      nlinarith [ Real.sin_sq_add_cos_sq a, mul_self_pos.mpr hsin ]
    norm_num [ show x = x' by nlinarith only [ h_eq ],
      show y = y' by nlinarith only [ h_eq ],
      show z = z' by nlinarith only [ h_eq ] ] at *
  · norm_num [ show r = r' by linarith ] at *
    have h_eq : 4 * (r' + Real.cos a) ^ 2 + (Real.sin a) ^ 2 *
        ((x - x') ^ 2 + (y - y') ^ 2 + (z - z') ^ 2) = 0 := by
      rw [ Real.sin_sq ]
      nlinarith
    norm_num [ show x = x' by
        exact eq_of_sub_eq_zero (by contrapose! h_eq; positivity),
      show y = y' by
        exact eq_of_sub_eq_zero (by contrapose! h_eq; positivity),
      show z = z' by
        exact eq_of_sub_eq_zero (by contrapose! h_eq; positivity) ] at *

/-- A zero or pi crossing for a nontrivial mass angle forces equality of the
opposite-momentum chiral endpoints. -/
lemma massiveHNU_crossing_forces_endpoint_eq (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) (k : Fin 3 -> Real)
    (sgn : Complex) (hsgn : sgn = 1 ∨ sgn = -1)
    (hcross : (massiveHNU (1 : Complex) a k -
        sgn • (1 : Matrix (Fin 4) (Fin 4) Complex)).det = 0) :
    endpoint k = endpoint (fun i => -k i) := by
  apply su2_pair_massive_det_zero_imp_eq a
  any_goals exact hsgn
  all_goals norm_num [ HNUExactCore.endpoint_unitary,
    HNUExactCore.endpoint_det, HNUExactCore.trace_endpoint ]
  · exact ne_of_gt (Real.sin_pos_of_pos_of_lt_pi ha0 hapi)
  · norm_num [ neg_div ]
  · convert hcross using 1
    convert massiveHNU_shifted_det_reduction a k sgn hsgn |> Eq.symm using 1
    norm_num [ mul_add, add_smul ]

/-- A nontrivial real Pluecker mass angle removes both zero and pi
quasienergy crossings over the complete Brillouin cube. -/
theorem massiveHNU_zero_pi_gap (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) (k : Fin 3 -> Real) (hk : InBZ k) :
    (massiveHNU (1 : Complex) a k - 1).det != 0 /\
      (massiveHNU (1 : Complex) a k + 1).det != 0 := by
  by_contra h_contra; contrapose! h_contra; simp_all +decide [ InBZ ] ;
  by_cases h : endpoint k = endpoint ( fun i => -k i ) <;> simp_all +decide [ massiveHNU ];
  · by_cases h' : ∀ i, k i = 0 <;> simp_all +decide [ InBZ, OnBZBoundary ];
    · rw [ show k = 0 from funext h' ] ; norm_num [ diracHNU_zero ] ;
      have := massCoin4_one_shifted_determinants a; simp_all +decide [ Pluecker3Plus1ComplexMass.massCoin4 ] ;
      norm_cast; constructor <;> nlinarith only [ Real.sin_sq_add_cos_sq a, Real.sin_pos_of_pos_of_lt_pi ha0 hapi ] ;
    · have h_endpoint_boundary : endpoint k = -1 ∧ endpoint (fun i => -k i) = -1 := by
        have := HNUExactCore.pi_census k hk;
        have := endpoint_eq_momentumReverse_iff k hk; aesop;
      have h_doubledChiralEndpoint_boundary : doubledChiralEndpoint k = -1 := by
        unfold doubledChiralEndpoint; simp +decide [ h_endpoint_boundary ] ;
        ext i j ; fin_cases i <;> fin_cases j <;> norm_num;
      have h_diracHNU_boundary : diracHNU k = -1 := by
        unfold diracHNU; simp +decide [ h_doubledChiralEndpoint_boundary ] ;
        exact diracBasis_unitary.2;
      simp_all +decide [ Matrix.det_neg ];
      have := massCoin4_one_shifted_determinants a; simp_all +decide [ Matrix.det_neg ] ;
      rw [ show ( -Pluecker3Plus1ComplexMass.massCoin4 1 a - 1 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) = - ( Pluecker3Plus1ComplexMass.massCoin4 1 a + 1 ) by abel1, show ( -Pluecker3Plus1ComplexMass.massCoin4 1 a + 1 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) = - ( Pluecker3Plus1ComplexMass.massCoin4 1 a - 1 ) by abel1, Matrix.det_neg, Matrix.det_neg ] ; norm_num [ this ];
      norm_cast; constructor <;> nlinarith only [ Real.sin_sq_add_cos_sq a, Real.sin_pos_of_pos_of_lt_pi ha0 hapi ] ;
  · contrapose! h; ( contrapose! h; ( have := @massiveHNU_crossing_forces_endpoint_eq; ( have := @endpoint_eq_momentumReverse_iff; ( simp_all +decide [ InBZ, OnBZBoundary ] ; ) ) ) );
    rename_i h_contra; specialize h_contra a ha0 hapi k; simp_all +decide [ massiveHNU ] ;
    grind

/-- The origin is a nonvacuous control: the massive update is the exact local
mass coin, while the global gap theorem still excludes eigenvalues `+1` and
`-1` for a nontrivial angle. -/
theorem massiveHNU_origin_zero_pi_gap (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) :
    massiveHNU (1 : Complex) a 0 =
        PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4 1 a /\
      (massiveHNU (1 : Complex) a 0 - 1).det != 0 /\
      (massiveHNU (1 : Complex) a 0 + 1).det != 0 := by
  simp [massiveHNU_rest, diracHNU_zero,
    massCoin4_one_shifted_determinants]
  constructor <;> norm_cast <;>
    nlinarith [Real.sin_sq_add_cos_sq a,
      Real.sin_pos_of_pos_of_lt_pi ha0 hapi]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.endpoint_reversal_diag_constraint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_reversal_diag_constraint

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.endpoint_reversal_offdiag_constraints' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_reversal_offdiag_constraints

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.endpoint_eq_reverse_imp_central' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_eq_reverse_imp_central

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.endpoint_central_imp_eq_reverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_central_imp_eq_reverse

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.endpoint_eq_momentumReverse_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_eq_momentumReverse_iff

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.massCoin4_one_shifted_determinants' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massCoin4_one_shifted_determinants

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.massiveHNU_shifted_det_reduction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_shifted_det_reduction

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.su2_pair_massive_det_zero_imp_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms su2_pair_massive_det_zero_imp_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.massiveHNU_crossing_forces_endpoint_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_crossing_forces_endpoint_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.massiveHNU_zero_pi_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_zero_pi_gap

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap.massiveHNU_origin_zero_pi_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_origin_zero_pi_gap

end PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
