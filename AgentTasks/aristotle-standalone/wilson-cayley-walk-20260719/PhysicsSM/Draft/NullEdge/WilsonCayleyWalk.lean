import PhysicsSM.Draft.NullEdge.Strict3Plus1TorusDoubling

/-!
# The Wilson-Cayley walk: a candidate refutation of universal torus doubling

Target statements for the Aristotle job `wilson-cayley-walk-20260719`.

Context.  The predecessor project proved the live walk's torus-genuine
doubling and left the universal gate (`admissible_doubling_torus`) open
with a designed candidate COUNTEREXAMPLE (its TORUS_DOUBLING_PROOF_PLAN,
reproduced in the prompt): the Cayley transform of the Wilson Hamiltonian

  `K(q) = (1/2) (Σ_j sin(q_j) α_j + (Σ_j (1 - cos q_j)) β)`,
  `U(q) = (I - iK(q)) (I + iK(q))⁻¹`.

Structure that makes the crossing analysis EXACT: `U - 1 = -2iK (1+iK)⁻¹`
is singular iff `K` is singular, and `U + 1 = 2 (1+iK)⁻¹` is NEVER
singular - so the walk has NO pi-crossings anywhere and zero-crossings
exactly on the zero set of `K`, which (by the Clifford square) is the
origin lattice.  If the assembly closes, `admissible_doubling_torus` is
REFUTED - and the honest reading is recorded below: the `AdmissibleWalk`
interface omits LOCALITY (a Cayley transform is not finite-range) and
CHIRAL structure, so Nielsen-Ninomiya cannot be stated on it; the true
frontier statement needs a locality field.  Either outcome (verified
counterexample, or a discovered obstruction to admissibility) is a
first-class result.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

open Compact3Plus1DiracRate

/-- The Wilson mass function `s(q) = Σ_j (1 - cos q_j)`. -/
def wilsonS (q : Fin 3 → ℝ) : ℝ := ∑ j, (1 - Real.cos (q j))

/-- The Wilson Hamiltonian symbol. -/
def wilsonK (q : Fin 3 → ℝ) : Mat4 :=
  (1 / 2 : ℂ) • (((Real.sin (q 0) : ℂ) • alpha1 + (Real.sin (q 1) : ℂ) • alpha2
    + (Real.sin (q 2) : ℂ) • alpha3) + (wilsonS q : ℂ) • beta)

/-- The Cayley transform of a matrix. -/
def cayley (K : Mat4) : Mat4 := (1 - Complex.I • K) * (1 + Complex.I • K)⁻¹

/-
**Lemma (i): the Clifford square.**  `wilsonK q` squares to the scalar
`(1/4)(Σ sin² q_j + s(q)²)`.
-/
theorem wilsonK_sq (q : Fin 3 → ℝ) :
    wilsonK q * wilsonK q =
      ((1 / 4 : ℂ) * ((∑ j, (Real.sin (q j) : ℂ) ^ 2) + (wilsonS q : ℂ) ^ 2))
        • 1 := by
  norm_num [ Fin.sum_univ_three, wilsonS, wilsonK ];
  simp +decide [ Fin.ext_iff, Fin.sum_univ_three, alpha1, alpha2, alpha3, beta ] ; ring;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num

/-
**Lemma (i'): the zero set.**  `wilsonK q = 0` iff `q` is
lattice-congruent to the origin.
-/
theorem wilsonK_eq_zero_iff (q : Fin 3 → ℝ) :
    wilsonK q = 0 ↔ LatticeCongruentZero q := by
  constructor <;> intro hq;
  · -- By definition of $wilsonK$, we know that if $wilsonK q = 0$, then $1 - (q_j) = 0$ for all $j$.
    have h_wilsonS : wilsonS q = 0 := by
      have := congr_arg ( fun m => m 0 0 ) hq; norm_num [ Fin.sum_univ_three, wilsonK, alpha1, alpha2, alpha3, beta ] at this;
      exact this;
    -- Since $wilsonS q = 0$, we have $1 - \cos(q_j) = 0$ for all $j$, which implies $\cos(q_j) = 1$ for all $j$.
    have h_cos_one : ∀ j, Real.cos (q j) = 1 := by
      exact fun j => by linarith [ Real.cos_le_one ( q j ), show ∑ j, ( 1 - Real.cos ( q j ) ) = 0 from h_wilsonS, Finset.single_le_sum ( fun i _ => sub_nonneg.mpr ( Real.cos_le_one ( q i ) ) ) ( Finset.mem_univ j ) ] ;
    simp_all +decide [ Real.cos_eq_one_iff ];
    exact ⟨ fun j => Classical.choose ( h_cos_one j ), fun j => by linarith [ Classical.choose_spec ( h_cos_one j ) ] ⟩;
  · obtain ⟨ n, hn ⟩ := hq;
    unfold wilsonK;
    unfold wilsonS; norm_num [ hn, mul_assoc, mul_left_comm, Real.sin_two_mul, mul_comm Real.pi ] ;

/-
The Cayley denominator has nonzero determinant for a Hermitian matrix.
-/
lemma cayley_denom_det_ne_zero (K : Mat4) (hK : K.IsHermitian) :
    Matrix.det (1 + Complex.I • K) ≠ 0 := by
  -- Assume for contradiction that $\det(1 + IK) = 0$. Then there exists a nonzero vector $v$ such that $(1 + IK)v = 0$.
  by_contra h_det_zero
  obtain ⟨v, hv⟩ : ∃ v : Fin 4 → ℂ, v ≠ 0 ∧ (1 + Complex.I • K).mulVec v = 0 := by
    convert Matrix.exists_mulVec_eq_zero_iff.mpr h_det_zero;
  -- Expanding $(IK)v = -v$ gives $Kv = i v$.
  have h_eigenvalue : K.mulVec v = Complex.I • v := by
    simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
    simp_all +decide [ Finset.sum_add_distrib, add_mul, Finset.mul_sum _ _ _, Complex.ext_iff, Matrix.one_apply ];
    exact fun x => ⟨ by linarith [ hv.2 x ], by linarith [ hv.2 x ] ⟩;
  -- Since $K$ is Hermitian, we have $v^\dagger K v = (K v)^\dagger v = (i v)^\dagger v = -i v^\dagger v$.
  have h_inner_conj : star v ⬝ᵥ K.mulVec v = star (K.mulVec v) ⬝ᵥ v := by
    simp +decide [ dotProduct, Matrix.mulVec, Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm ];
    rw [ Finset.sum_comm ];
    exact Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => by rw [ ← hK.apply ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
  simp_all +decide [ Complex.ext_iff, dotProduct ];
  norm_num [ Finset.sum_add_distrib, mul_comm ] at h_inner_conj;
  exact hv.1 ( funext fun i => by norm_num [ Complex.ext_iff ] ; constructor <;> nlinarith only [ h_inner_conj, Finset.single_le_sum ( fun a _ => mul_self_nonneg ( v a |> Complex.re ) ) ( Finset.mem_univ i ), Finset.single_le_sum ( fun a _ => mul_self_nonneg ( v a |> Complex.im ) ) ( Finset.mem_univ i ) ] )

/-
**Lemma (ii-a): Cayley unitarity.**  The Cayley transform of a
Hermitian matrix is unitary.
-/
theorem cayley_mem_unitary (K : Mat4) (hK : K.IsHermitian) :
    cayley K ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  unfold cayley;
  constructor;
  · by_cases h : IsUnit ( Matrix.det ( 1 + Complex.I • K ) ) <;> simp_all +decide [ Matrix.nonsing_inv_apply_not_isUnit ];
    · rw [ show star ( 1 + I • K ) ⁻¹ = ( 1 - I • K ) ⁻¹ from ?_ ];
      · rw [ show star K = K from hK ];
        rw [ show ( 1 - I • K ) * ( 1 + I • K ) ⁻¹ = ( 1 + I • K ) ⁻¹ * ( 1 - I • K ) from ?_ ];
        · simp +decide [ ← mul_assoc, h, isUnit_iff_ne_zero ];
          rw [ Matrix.nonsing_inv_mul _ ];
          convert isUnit_iff_ne_zero.mpr ( show Matrix.det ( 1 - Complex.I • K ) ≠ 0 from ?_ ) using 1;
          convert cayley_denom_det_ne_zero ( -K ) ( by simpa using hK.neg ) using 1;
          norm_num [ sub_eq_add_neg ];
        · have h_comm : (1 - Complex.I • K) * (1 + Complex.I • K) = (1 + Complex.I • K) * (1 - Complex.I • K) := by
            simp +decide [ mul_add, add_mul, sub_mul, mul_sub ];
            ext i j ; norm_num ; ring;
          apply_fun ( fun x => x * ( 1 + I • K ) ⁻¹ ) at h_comm;
          apply_fun ( fun x => ( 1 + I • K ) ⁻¹ * x ) at h_comm;
          simp_all +decide [ Matrix.mul_assoc, isUnit_iff_ne_zero ];
      · rw [ Matrix.star_eq_conjTranspose, Matrix.conjTranspose_nonsing_inv ];
        simp_all +decide [ Matrix.IsHermitian, Matrix.conjTranspose_add, Matrix.conjTranspose_smul ];
        rw [ sub_eq_add_neg ];
    · exact absurd h ( by simpa [ hK ] using cayley_denom_det_ne_zero K hK );
  · have h_det : Matrix.det (1 + Complex.I • K) ≠ 0 := by
      convert cayley_denom_det_ne_zero K hK using 1;
    simp_all +decide [ mul_assoc, Matrix.mul_nonsing_inv, IsUnit ];
    rw [ show star K = K from hK ];
    simp +decide [ ← mul_assoc, h_det, isUnit_iff_ne_zero ];
    rw [ Matrix.mul_assoc, Matrix.mul_assoc, mul_eq_one_comm ];
    simp +decide [ ← mul_assoc, ← Matrix.mul_assoc, ← Matrix.mul_nonsing_inv, h_det ];
    rw [ Matrix.star_eq_conjTranspose, Matrix.conjTranspose_nonsing_inv ];
    rw [ show ( 1 + I • K )ᴴ = 1 - I • K from ?_ ];
    · rw [ ← Matrix.mul_inv_rev ];
      rw [ show ( 1 - I • K ) * ( 1 + I • K ) = ( 1 + I • K ) * ( 1 - I • K ) by
            grind +splitIndPred ];
      rw [ mul_assoc, Matrix.nonsing_inv_mul _ ];
      simp_all +decide [ Matrix.det_mul, isUnit_iff_ne_zero ];
      convert cayley_denom_det_ne_zero ( -K ) ( by simpa using hK.neg ) using 1;
      norm_num [ sub_eq_add_neg ];
    · simp +decide [ Matrix.conjTranspose_add, Matrix.conjTranspose_smul, hK.eq ];
      rw [ sub_eq_add_neg ]

/-
**Lemma (ii-b): crossing dictionary.**  For Hermitian `K`: the Cayley
walk has a `+1` crossing iff `K` is singular, and NEVER has a `-1`
crossing.
-/
theorem cayley_crossings (K : Mat4) (hK : K.IsHermitian) :
    (Matrix.det (cayley K - 1) = 0 ↔ Matrix.det K = 0) ∧
      Matrix.det (cayley K + 1) ≠ 0 := by
  -- By definition of $cayley$, we know that $(1 + \mathrm{i}K)$ is invertible if $K$ is Hermitian.
  have h_inv : Invertible (1 + Complex.I • K) := by
    convert Matrix.invertibleOfDetInvertible _;
    -- Since $K$ is Hermitian, $1 + iK$ is invertible.
    have h_inv : ∀ (v : Fin 4 → ℂ), (1 + Complex.I • K).mulVec v = 0 → v = 0 := by
      intro v hv
      have h_inner : ∑ i, (v i) * starRingEnd ℂ (v i) + Complex.I * ∑ i, (K.mulVec v i) * starRingEnd ℂ (v i) = 0 := by
        convert congr_arg ( fun x : Fin 4 → ℂ => ∑ i, x i * starRingEnd ℂ ( v i ) ) hv using 1 ; simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm ];
        · simp +decide [ Matrix.one_apply, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_add_distrib ];
        · norm_num;
      have h_inner_real : ∑ i, (K.mulVec v i) * starRingEnd ℂ (v i) = starRingEnd ℂ (∑ i, (K.mulVec v i) * starRingEnd ℂ (v i)) := by
        simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm ];
        rw [ Finset.sum_comm ];
        exact Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => by rw [ ← hK.apply ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
      norm_num [ Complex.ext_iff ] at *;
      simp_all +decide [ Finset.sum_add_distrib, mul_comm ];
      exact funext fun i => by norm_num [ Complex.ext_iff ] ; constructor <;> nlinarith [ Finset.single_le_sum ( fun a _ => mul_self_nonneg ( v a |> Complex.re ) ) ( Finset.mem_univ i ), Finset.single_le_sum ( fun a _ => mul_self_nonneg ( v a |> Complex.im ) ) ( Finset.mem_univ i ) ] ;
    exact invertibleOfNonzero fun h => by have := Matrix.exists_mulVec_eq_zero_iff.mpr h; tauto;
  unfold cayley;
  have h_det : ((1 - Complex.I • K) * (1 + Complex.I • K)⁻¹ - 1) = (-2 * Complex.I) • K * (1 + Complex.I • K)⁻¹ := by
    have h_det : ((1 - Complex.I • K) * (1 + Complex.I • K)⁻¹ - 1) = ((1 - Complex.I • K) - (1 + Complex.I • K)) * (1 + Complex.I • K)⁻¹ := by
      simp +decide [ sub_mul ];
    convert h_det using 2 ; ext i j ; norm_num ; ring;
  have h_det : ((1 - Complex.I • K) * (1 + Complex.I • K)⁻¹ + 1) = 2 • (1 + Complex.I • K)⁻¹ := by
    simp_all +decide [ mul_add, add_mul, sub_mul, mul_sub, two_smul ];
    have := mul_invOf_self ( 1 + Complex.I • K ) ; simp_all +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul ] ;
    grind;
  simp_all +decide [ Matrix.det_smul ];
  erw [ Matrix.det_neg, Matrix.det_smul ] ; norm_num [ h_inv.2 ];
  exact ⟨ fun h => absurd h <| Matrix.det_ne_zero_of_left_inverse h_inv.2, by erw [ Matrix.det_diagonal ] ; norm_num, by exact Matrix.det_ne_zero_of_left_inverse h_inv.2 ⟩

/-
The Wilson symbol is Hermitian.
-/
lemma wilsonK_isHermitian (q : Fin 3 → ℝ) : (wilsonK q).IsHermitian := by
  unfold wilsonK;
  ext i j; simp +decide [ alpha1, alpha2, alpha3, beta ] ; ring;
  fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ]

/-- The Wilson-Cayley symbol is periodic in every momentum coordinate. -/
lemma wilsonCayley_periodic (q : Fin 3 → ℝ) (i : Fin 3) :
    cayley (wilsonK (fun k => q k + if k = i then 2 * Real.pi else 0)) =
      cayley (wilsonK q) := by
  sorry

/-- The Wilson-Cayley symbol is continuous. -/
lemma wilsonCayley_continuous : Continuous (fun q => cayley (wilsonK q)) := by
  sorry

/-- The Wilson-Cayley symbol equals one at the origin. -/
lemma wilsonCayley_origin : cayley (wilsonK (fun _ => 0)) = 1 := by
  sorry

/-- The Wilson-Cayley symbol has the prescribed axiswise Dirac tangent. -/
lemma wilsonCayley_dirac (j : Fin 3) :
    HasDerivAt (fun t : ℝ => cayley (wilsonK (axisRay j t)))
      ((-Complex.I) • diracAlpha j) 0 := by
  sorry

/-- **Lemma (iii): the assembled admissible walk.**  The Wilson-Cayley
symbol satisfies every `AdmissibleWalk` field (unitarity, periodicity,
continuity, `U 0 = 1`, the three Dirac tangents). -/
def wilsonCayleyWalk : AdmissibleWalk where
  U := fun q => cayley (wilsonK q)
  unitary := fun q => cayley_mem_unitary _ (wilsonK_isHermitian q)
  periodic := wilsonCayley_periodic
  continuous := wilsonCayley_continuous
  origin := wilsonCayley_origin
  dirac := wilsonCayley_dirac

/-- **The refutation.**  The Wilson-Cayley walk's combined crossings all
sit on the origin lattice; hence the universal torus-doubling statement is
FALSE for the current (locality-free) `AdmissibleWalk` interface. -/
theorem wilsonCayley_no_offlattice_crossing (q : Fin 3 → ℝ)
    (h : ZeroOrPiAlias (wilsonCayleyWalk.U q)) :
    LatticeCongruentZero q := by
  sorry

/-- Formal negation of the universal gate on this interface. -/
theorem not_admissible_doubling_torus :
    ¬ (∀ W : AdmissibleWalk, ∃ q : Fin 3 → ℝ,
        ¬ LatticeCongruentZero q ∧ ZeroOrPiAlias (W.U q)) := by
  sorry

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
