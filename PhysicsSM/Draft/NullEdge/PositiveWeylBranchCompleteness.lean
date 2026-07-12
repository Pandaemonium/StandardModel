import PhysicsSM.Draft.NullEdge.LiveWeylJacobian
import PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
import PhysicsSM.Draft.NullEdge.LiveMasslessWeylCensusBridge

/-!
# Branch-resolved completeness of the live positive Weyl step

The full `4 x 4` massless determinant-root set is already classified, but each
body center carries both zero and pi quasienergies across the two Weyl blocks.
This module classifies the positive `2 x 2` block itself. The sign of `u0`
separates the branches rather than being inferred from the full determinant.

The results are global trigonometric biconditionals, not a finite list of
sampled points. They do not claim a Chern theorem: the local charge remains the
repository's exact sign of the real crossing-Jacobian determinant.

Provenance: theorem design and independent quaternion case audit by Codex;
proofs by Aristotle project `ae7aec57-4900-4422-b2f2-d5a0d702993f`, rebuilt
against the pinned local toolchain on July 11, 2026.
-/

namespace PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness

open Matrix
open SU2LocalCrossingCharge
open LiveWeylJacobian

abbrev V3 := LiveWeylJacobian.V3

/-- Exact positive-Weyl zero-quasienergy branch data in trigonometric
coordinates: even-parity corners or body centers with negative sine product. -/
def ZeroBranchData (q : V3) : Prop :=
  ((Real.cos (q 0)) ^ 2 = 1 ∧
      (Real.cos (q 1)) ^ 2 = 1 ∧
      (Real.cos (q 2)) ^ 2 = 1 ∧
      Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) = 1) ∨
    (Real.cos (q 0) = 0 ∧ Real.cos (q 1) = 0 ∧ Real.cos (q 2) = 0 ∧
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2) = -1)

/-- Exact positive-Weyl pi-quasienergy branch data in trigonometric
coordinates: odd-parity corners or body centers with positive sine product. -/
def PiBranchData (q : V3) : Prop :=
  ((Real.cos (q 0)) ^ 2 = 1 ∧
      (Real.cos (q 1)) ^ 2 = 1 ∧
      (Real.cos (q 2)) ^ 2 = 1 ∧
      Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) = -1) ∨
    (Real.cos (q 0) = 0 ∧ Real.cos (q 1) = 0 ∧ Real.cos (q 2) = 0 ∧
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2) = 1)

/-! ## Helper lemmas -/

/-
Pythagorean identity: the live positive Weyl symbol is a unit quaternion.
-/
lemma u0_sq_add_weylVector_sq (q : V3) :
    LiveWeylJacobian.u0 q ^ 2 + LiveWeylJacobian.weylVector q 0 ^ 2
      + LiveWeylJacobian.weylVector q 1 ^ 2 + LiveWeylJacobian.weylVector q 2 ^ 2 = 1 := by
  unfold u0; unfold weylVector; ring;
  simpa only [ Real.sin_sq ] using by ring;

/-
The live positive Weyl block equals `+I` exactly when its scalar part is `1`
and its Pauli-vector part vanishes.
-/
lemma weylStep_eq_one_iff_components (q : V3) :
    LiveWeylJacobian.weylStep q = 1 ↔
      LiveWeylJacobian.u0 q = 1 ∧ LiveWeylJacobian.weylVector q 0 = 0 ∧
        LiveWeylJacobian.weylVector q 1 = 0 ∧ LiveWeylJacobian.weylVector q 2 = 0 := by
  rw [ LiveWeylJacobian.weylStep_eq_pauliForm ];
  unfold pauliForm;
  unfold CubicWeylSectorCharge.sigma1 CubicWeylSectorCharge.sigma2 CubicWeylSectorCharge.sigma3; norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ ] ;
  norm_num [ Complex.ext_iff ] ; aesop;

/-
The live positive Weyl block equals `-I` exactly when its scalar part is
`-1` and its Pauli-vector part vanishes.
-/
lemma weylStep_eq_neg_one_iff_components (q : V3) :
    LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2) ↔
      LiveWeylJacobian.u0 q = -1 ∧ LiveWeylJacobian.weylVector q 0 = 0 ∧
        LiveWeylJacobian.weylVector q 1 = 0 ∧ LiveWeylJacobian.weylVector q 2 = 0 := by
  rw [ weylStep_eq_pauliForm ] ; constructor <;> intro h <;> simp_all +decide [ Matrix.one_fin_two ];
  · unfold pauliForm at h;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Complex.ext_iff, CubicWeylSectorCharge.sigma1, CubicWeylSectorCharge.sigma2, CubicWeylSectorCharge.sigma3 ];
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, pauliForm ]

/-- Because the symbol is a unit quaternion, `weylStep q = 1` is equivalent to
its scalar part being `1`. -/
lemma weylStep_eq_one_iff_u0 (q : V3) :
    LiveWeylJacobian.weylStep q = 1 ↔ LiveWeylJacobian.u0 q = 1 := by
  rw [weylStep_eq_one_iff_components]
  constructor
  · rintro ⟨h, _, _, _⟩; exact h
  · intro h
    have hp := u0_sq_add_weylVector_sq q
    refine ⟨h, ?_, ?_, ?_⟩ <;>
      nlinarith [sq_nonneg (LiveWeylJacobian.weylVector q 0),
        sq_nonneg (LiveWeylJacobian.weylVector q 1),
        sq_nonneg (LiveWeylJacobian.weylVector q 2), hp, h]

/-- Because the symbol is a unit quaternion, `weylStep q = -I` is equivalent to
its scalar part being `-1`. -/
lemma weylStep_eq_neg_one_iff_u0 (q : V3) :
    LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2) ↔ LiveWeylJacobian.u0 q = -1 := by
  rw [weylStep_eq_neg_one_iff_components]
  constructor
  · rintro ⟨h, _, _, _⟩; exact h
  · intro h
    have hp := u0_sq_add_weylVector_sq q
    refine ⟨h, ?_, ?_, ?_⟩ <;>
      nlinarith [sq_nonneg (LiveWeylJacobian.weylVector q 0),
        sq_nonneg (LiveWeylJacobian.weylVector q 1),
        sq_nonneg (LiveWeylJacobian.weylVector q 2), hp, h]

/-
Scalar-part classification on the zero branch.
-/
lemma u0_eq_one_iff_zeroBranch (q : V3) :
    LiveWeylJacobian.u0 q = 1 ↔ ZeroBranchData q := by
  constructor <;> intro h;
  · unfold u0 at h;
    by_cases hc1 : Real.cos ( q 1 ) = 0;
    · have := Real.sin_sq_add_cos_sq ( q 1 ) ; simp_all +decide [ ZeroBranchData ];
      cases this <;> simp_all +decide;
      · exact ⟨ by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 2 ) ], by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 2 ) ], by linarith ⟩;
      · constructor <;> nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 2 ) ];
    · -- Since $c1 \neq 0$, we have $c0 = c1 * c2$ and $s0 = -s1 * s2$.
      have hc0 : Real.cos (q 0) = Real.cos (q 1) * Real.cos (q 2) := by
        by_contra hc0;
        exact hc0 <| by nlinarith [ sq_nonneg ( Real.cos ( q 0 ) - Real.cos ( q 1 ) * Real.cos ( q 2 ) ), sq_nonneg ( Real.sin ( q 0 ) + Real.sin ( q 1 ) * Real.sin ( q 2 ) ), Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ;
      have hs0 : Real.sin (q 0) = -Real.sin (q 1) * Real.sin (q 2) := by
        by_cases hc2 : Real.cos ( q 2 ) = 0 <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
        · cases eq_or_eq_neg_of_sq_eq_sq ( Real.sin ( q 0 ) ) 1 ( by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ) ] ) <;> nlinarith [ Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ];
        · have := Real.sin_sq_add_cos_sq ( q 0 ) ; ( have := Real.sin_sq_add_cos_sq ( q 1 ) ; ( have := Real.sin_sq_add_cos_sq ( q 2 ) ; ( rw [ hc0 ] at *; ring_nf at *; nlinarith [ mul_self_pos.mpr hc1, mul_self_pos.mpr hc2 ] ; ) ) );
      by_cases hc2 : Real.cos (q 2) = 0 <;> simp_all +decide [ mul_comm, mul_left_comm ];
      · exact False.elim <| hc1 <| by nlinarith [ Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ;
      · have hc1_sq : Real.cos (q 1) ^ 2 = 1 := by
          by_contra hc1_sq_ne_one;
          exact hc1_sq_ne_one <| mul_left_cancel₀ ( pow_ne_zero 2 hc2 ) <| by nlinarith [ Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ;
        simp_all +decide [ Real.cos_sq' ];
        exact Or.inl ⟨ by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ], by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ], by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ], by nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ⟩;
  · cases h <;> simp_all +decide [ LiveWeylJacobian.u0 ];
    exact Or.inl <| Or.inl <| by rcases ‹_› with ⟨ h₀ | h₀, h₁ | h₁, h₂ | h₂, h₃ ⟩ <;> nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ;

/-
Scalar-part classification on the pi branch.
-/
lemma u0_eq_neg_one_iff_piBranch (q : V3) :
    LiveWeylJacobian.u0 q = -1 ↔ PiBranchData q := by
  constructor <;> intro h <;> simp_all +decide [ PiBranchData ];
  · -- By definition of $u0$, we know that $u0(q) = -1$ implies $w0(q) = w1(q) = w2(q) = 0$.
    have hw : LiveWeylJacobian.weylVector q 0 = 0 ∧ LiveWeylJacobian.weylVector q 1 = 0 ∧ LiveWeylJacobian.weylVector q 2 = 0 := by
      have := u0_sq_add_weylVector_sq q; norm_num [ h ] at this; exact ⟨ by nlinarith, by nlinarith, by nlinarith ⟩ ;
    generalize_proofs at *; (
    cases eq_or_ne ( Real.cos ( q 1 ) ) 0 <;> simp_all +decide [ mul_assoc ];
    · unfold u0 weylVector at *; simp_all +decide ;
      grind;
    · unfold u0 weylVector at * ; simp_all +decide [ mul_assoc ] ; ring_nf at * ;
      have h_cos_sq : Real.cos (q 0) ^ 2 = 1 ∧ Real.cos (q 1) ^ 2 = 1 ∧ Real.cos (q 2) ^ 2 = 1 := by
        have h_cos_sq : Real.cos (q 0) ^ 2 * Real.cos (q 1) ^ 2 * Real.cos (q 2) ^ 2 = 1 := by
          grind +ring
        generalize_proofs at *; (
        have h_cos_sq : Real.cos (q 0) ^ 2 ≤ 1 ∧ Real.cos (q 1) ^ 2 ≤ 1 ∧ Real.cos (q 2) ^ 2 ≤ 1 := by
          exact ⟨ Real.cos_sq_le_one _, Real.cos_sq_le_one _, Real.cos_sq_le_one _ ⟩
        generalize_proofs at *; (
        exact ⟨ by nlinarith [ mul_nonneg ( sq_nonneg ( Real.cos ( q 0 ) ) ) ( sq_nonneg ( Real.cos ( q 1 ) ) ) ], by nlinarith [ mul_nonneg ( sq_nonneg ( Real.cos ( q 1 ) ) ) ( sq_nonneg ( Real.cos ( q 2 ) ) ) ], by nlinarith [ mul_nonneg ( sq_nonneg ( Real.cos ( q 2 ) ) ) ( sq_nonneg ( Real.cos ( q 0 ) ) ) ] ⟩))
      generalize_proofs at *; (
      grind));
  · unfold u0; cases h <;> simp_all +decide ;
    exact Or.inl <| Or.inl <| by rcases ‹_› with ⟨ h₀ | h₀, h₁ | h₁, h₂ | h₂, h ⟩ <;> nlinarith [ Real.sin_sq_add_cos_sq ( q 0 ), Real.sin_sq_add_cos_sq ( q 1 ), Real.sin_sq_add_cos_sq ( q 2 ) ] ;

/-- Auxiliary: the middle-axis frequency factor is nonzero on either branch
shape (corner `cos^2 = 1` or body center `cos = 0`). -/
lemma cos_sq_sub_sin_sq_ne_zero (q : V3)
    (h : Real.cos (q 1) ^ 2 = 1 ∨ Real.cos (q 1) = 0) :
    Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2 ≠ 0 := by
  have hs := Real.sin_sq_add_cos_sq (q 1)
  rcases h with h | h
  · have : Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2 = 1 := by linarith
    rw [this]; norm_num
  · have hc2 : Real.cos (q 1) ^ 2 = 0 := by rw [h]; ring
    have : Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2 = -1 := by linarith
    rw [this]; norm_num

/-! ## The six target theorems -/

/-- The live positive Weyl block equals `+I` exactly on its zero branch. -/
theorem weylStep_eq_one_iff (q : V3) :
    LiveWeylJacobian.weylStep q = 1 ↔ ZeroBranchData q :=
  (weylStep_eq_one_iff_u0 q).trans (u0_eq_one_iff_zeroBranch q)

/-- The live positive Weyl block equals `-I` exactly on its pi branch. -/
theorem weylStep_eq_neg_one_iff (q : V3) :
    LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2) ↔ PiBranchData q :=
  (weylStep_eq_neg_one_iff_u0 q).trans (u0_eq_neg_one_iff_piBranch q)

/-- Zero- and pi-branch data are disjoint for the positive Weyl block. -/
theorem zeroBranchData_disjoint_piBranchData (q : V3) :
    ¬ (ZeroBranchData q ∧ PiBranchData q) := by
  rintro ⟨hz, hp⟩
  have h1 : LiveWeylJacobian.weylStep q = 1 := (weylStep_eq_one_iff q).mpr hz
  have h2 : LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2) :=
    (weylStep_eq_neg_one_iff q).mpr hp
  rw [h1] at h2
  have hcontra : (1 : Complex) = -1 := by
    have := congrFun (congrFun h2 0) 0
    simpa [Matrix.one_apply] using this
  norm_num at hcontra

/-- Every positive-Weyl zero crossing has a nondegenerate actual Frechet
Jacobian. -/
theorem zeroBranch_jacobian_det_ne_zero (q : V3)
    (hq : LiveWeylJacobian.weylStep q = 1) :
    (LiveWeylJacobian.weylJacobian q).det ≠ 0 := by
  have hz : ZeroBranchData q := (weylStep_eq_one_iff q).mp hq
  have hu : LiveWeylJacobian.u0 q = 1 := (u0_eq_one_iff_zeroBranch q).mpr hz
  rw [LiveWeylJacobian.det_weylJacobian]
  apply mul_ne_zero
  · rw [hu]; norm_num
  · apply cos_sq_sub_sin_sq_ne_zero
    rcases hz with ⟨_, hc1, _, _⟩ | ⟨_, hc1, _, _⟩
    · exact Or.inl hc1
    · exact Or.inr hc1

/-- Every positive-Weyl pi crossing has a nondegenerate actual Frechet
Jacobian. -/
theorem piBranch_jacobian_det_ne_zero (q : V3)
    (hq : LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2)) :
    (LiveWeylJacobian.weylJacobian q).det ≠ 0 := by
  have hp : PiBranchData q := (weylStep_eq_neg_one_iff q).mp hq
  have hu : LiveWeylJacobian.u0 q = -1 := (u0_eq_neg_one_iff_piBranch q).mpr hp
  rw [LiveWeylJacobian.det_weylJacobian]
  apply mul_ne_zero
  · rw [hu]; norm_num
  · apply cos_sq_sub_sin_sq_ne_zero
    rcases hp with ⟨_, hc1, _, _⟩ | ⟨_, hc1, _, _⟩
    · exact Or.inl hc1
    · exact Or.inr hc1

/-- Negative control: rank deficiency at the quarter-axis point is not a
crossing of either quasienergy branch. -/
theorem rankDeficientControl_not_crossing :
    LiveWeylJacobian.weylStep LiveWeylJacobian.rankDeficientControl ≠ 1 ∧
      LiveWeylJacobian.weylStep LiveWeylJacobian.rankDeficientControl ≠
        -(1 : LiveWeylJacobian.M2) := by
  have hu : LiveWeylJacobian.u0 LiveWeylJacobian.rankDeficientControl = Real.sqrt 2 / 2 := by
    simp [LiveWeylJacobian.u0, LiveWeylJacobian.rankDeficientControl,
      Real.cos_pi_div_four, Real.cos_zero, Real.sin_zero]
  have hsqrt : Real.sqrt 2 < 2 := by
    rw [show (2 : ℝ) = Real.sqrt 4 by rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq]; norm_num]
    exact Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
  have hsqrtpos : 0 < Real.sqrt 2 := Real.sqrt_pos.mpr (by norm_num)
  constructor
  · rw [ne_eq, weylStep_eq_one_iff_u0, hu]
    intro h; nlinarith [h, hsqrt]
  · rw [ne_eq, weylStep_eq_neg_one_iff_u0, hu]
    intro h; nlinarith [h, hsqrtpos]

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness.weylStep_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weylStep_eq_one_iff

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness.weylStep_eq_neg_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weylStep_eq_neg_one_iff

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness.zeroBranch_jacobian_det_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zeroBranch_jacobian_det_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness.piBranch_jacobian_det_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms piBranch_jacobian_det_ne_zero

end PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness
