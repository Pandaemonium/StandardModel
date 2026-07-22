import Mathlib

open scoped BigOperators
open ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace SpectralMeasureRepair

/-! We work over `ℝ`.  This file concerns the finite spectral-measure response that
underlies the corresponding physics readout; it does not identify that response with
physical mass. -/

/-- The nonnegative spectral weight of a source vector in a real orthonormal eigenbasis. -/
noncomputable def spectralWeight {n : ℕ}
    (e : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (v : EuclideanSpace ℝ (Fin n)) (j : Fin n) : ℝ :=
  inner ℝ (e j) v ^ 2

/-- The moments of a finite atomic spectral measure. -/
def moments {n : ℕ} (lam w : Fin n → ℝ) (k : Fin n) : ℝ :=
  ∑ j, w j * lam j ^ (k : ℕ)

/-- The resolvent response of finite spectral data. -/
noncomputable def response {n : ℕ} (lam w : Fin n → ℝ) (z : ℝ) : ℝ :=
  ∑ j, w j / (z - lam j)

/-
Spectral weights are nonnegative.
-/
theorem spectralWeight_nonneg {n : ℕ}
    (e : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (v : EuclideanSpace ℝ (Fin n)) (j : Fin n) :
    0 ≤ spectralWeight e v j := by
  exact sq_nonneg _

/-
Parseval: the total spectral weight is the squared norm of the source.
-/
theorem sum_spectralWeight {n : ℕ}
    (e : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (v : EuclideanSpace ℝ (Fin n)) :
    ∑ j, spectralWeight e v j = ‖v‖ ^ 2 := by
  convert OrthonormalBasis.sum_sq_norm_inner_right e v;
  unfold spectralWeight; aesop;

/-
For fixed atoms and weights, the displayed formula makes the response well-defined.
-/
theorem response_ext {n : ℕ} {lam w w' : Fin n → ℝ} (hw : w = w') :
    response lam w = response lam w' := by
  rw [hw]

/-
Distinct known atoms make the first `n` moments injective in the weights
(Vandermonde invertibility).
-/
theorem moments_injective {n : ℕ} {lam : Fin n → ℝ}
    (hlam : Function.Injective lam) : Function.Injective (moments lam) := by
  -- Let $A$ be the Vandermonde matrix with entries $A_{ij} = \lambda_j^{i-1}$.
  set A : Matrix (Fin n) (Fin n) ℝ := Matrix.of (fun i j => lam j ^ (i : ℕ)) with hA_def
  have hA_inv : A.det ≠ 0 := by
    erw [ Matrix.det_transpose, Matrix.det_vandermonde ];
    exact Finset.prod_ne_zero_iff.mpr fun i hi => Finset.prod_ne_zero_iff.mpr fun j hj => sub_ne_zero_of_ne <| hlam.ne <| by aesop;
  have hA_inj : Function.Injective (Matrix.mulVec A) := by
    exact fun x y hxy => by simpa [ hA_inv, isUnit_iff_ne_zero ] using congr_arg ( fun z => A⁻¹.mulVec z ) hxy;
  intro w w' h_eq; have := @hA_inj ( fun i => w i ) ( fun i => w' i ) ; simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ] ;
  exact this ( fun i => by simpa only [ mul_comm ] using h_eq i )

/-
The spectral moment formula for a real matrix with the given orthonormal
eigenbasis. The eigenbasis hypothesis already contains the needed diagonalization;
Hermitianity is therefore not repeated as a redundant assumption.
-/
theorem matrix_power_inner_eq_moment {n : ℕ}
    (H : Matrix (Fin n) (Fin n) ℝ) (lam : Fin n → ℝ)
    (e : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hEig : ∀ j, Matrix.toEuclideanLin H (e j) = lam j • e j)
    (v : EuclideanSpace ℝ (Fin n)) (k : ℕ) :
    inner ℝ v (((Matrix.toEuclideanLin H : EuclideanSpace ℝ (Fin n) →
      EuclideanSpace ℝ (Fin n))^[k]) v) =
      ∑ j, spectralWeight e v j * lam j ^ k := by
  -- We expand v in the orthonormal basis using e.sum_repr and repr_apply_apply.
  have h_expand : ∀ k, (Matrix.toEuclideanLin H)^[k] v = ∑ j, (inner ℝ (e j) v) • (lam j)^k • e j := by
    intro k;
    induction' k with k ih generalizing v <;> simp_all +decide [ pow_succ', Function.iterate_succ_apply', Matrix.toEuclideanLin ];
    · conv_lhs => rw [ ← e.sum_repr v ];
      simp +decide [ OrthonormalBasis.repr_apply_apply ];
    · simp +decide only [smul_smul, mul_comm];
  rw [ h_expand k ];
  simp +decide [ spectralWeight, inner_sum, inner_smul_right ];
  simp +decide only [real_inner_comm, mul_left_comm, pow_two, mul_comm]

/-
Consequently, for known distinct atoms, equal first `n` moments give the same
resolvent response.
-/
theorem response_eq_of_moments_eq {n : ℕ} {lam : Fin n → ℝ}
    (hlam : Function.Injective lam) {w w' : Fin n → ℝ}
    (hm : moments lam w = moments lam w') :
    response lam w = response lam w' := by
  convert response_ext _;
  exact moments_injective hlam hm

/-
Linear independence of the simple-pole functions, phrased as uniqueness from an
infinite subset of the common resolvent set (for fixed distinct atoms).
-/
theorem weights_eq_of_response_eq_on_infinite {n : ℕ} {lam : Fin n → ℝ}
    (hlam : Function.Injective lam) {w w' : Fin n → ℝ} {S : Set ℝ}
    (hS : S.Infinite)
    (hresp : ∀ z ∈ S, (∀ j, z ≠ lam j) → response lam w z = response lam w' z) :
    w = w' := by
  -- By assumption, $P(z) \neq 0$ for all $z \in S$, so the equality of responses implies that $\sum_j (w_j - w'_j)Q_j(z) = 0$.
  have h_sum_zero : ∀ z ∈ S, (∀ j, z ≠ lam j) → ∑ j, (w j - w' j) * (∏ k ∈ Finset.erase Finset.univ j, (z - lam k)) = 0 := by
    intro z hz hz'; specialize hresp z hz hz'; simp_all +decide [ response ] ;
    convert congr_arg ( fun x : ℝ => x * ∏ k, ( z - lam k ) ) ( sub_eq_zero.mpr hresp ) using 1 <;> norm_num [ sub_mul, Finset.sum_mul _ _ _ ];
    exact congrArg₂ _ ( Finset.sum_congr rfl fun i hi => by rw [ div_mul_eq_mul_div, eq_div_iff ( sub_ne_zero_of_ne <| hz' i ) ] ; rw [ mul_assoc, Finset.prod_erase_mul _ _ hi ] ) ( Finset.sum_congr rfl fun i hi => by rw [ div_mul_eq_mul_div, eq_div_iff ( sub_ne_zero_of_ne <| hz' i ) ] ; rw [ mul_assoc, Finset.prod_erase_mul _ _ hi ] );
  -- Since $P$ is a polynomial of degree at most $n-1$, and it vanishes at infinitely many points in $S$, it must be the zero polynomial.
  have hP_zero : ∑ j, (w j - w' j) • (Finset.prod (Finset.erase Finset.univ j) fun k => (Polynomial.X - Polynomial.C (lam k))) = 0 := by
    have hP_zero : Set.Infinite {z : ℝ | ∑ j, (w j - w' j) * (∏ k ∈ Finset.erase Finset.univ j, (z - lam k)) = 0} := by
      have h_poly_zero : Set.Infinite (S \ {z : ℝ | ∃ j, z = lam j}) := by
        exact Set.Infinite.diff hS ( Set.Finite.subset ( Set.toFinite ( Set.range lam ) ) fun x hx => by aesop );
      exact h_poly_zero.mono fun x hx => h_sum_zero x hx.1 fun j hj => hx.2 ⟨ j, hj ⟩;
    refine' Classical.not_not.1 fun h => hP_zero <| Set.Finite.subset ( Polynomial.roots ( ∑ j, ( w j - w' j ) • ∏ k ∈ Finset.univ.erase j, ( Polynomial.X - Polynomial.C ( lam k ) ) ) |> Multiset.toFinset |> Finset.finite_toSet ) _;
    intro z hz; simp_all +decide [ Polynomial.eval_finset_sum, Polynomial.eval_prod ] ;
  ext j; replace hP_zero := congr_arg ( Polynomial.eval ( lam j ) ) hP_zero; simp_all +decide ;
  rw [ Polynomial.eval_finset_sum, Finset.sum_eq_single j ] at hP_zero <;> simp_all +decide [ Polynomial.eval_prod, Finset.prod_eq_zero_iff, sub_eq_zero, hlam.eq_iff ];
  exact fun k hk => Or.inr ( Ne.symm hk )

/-
Two distinct, nonzero-weight atom lists with the same response on infinitely many
common resolvent points agree up to relabelling; equivalently, they define the same
finite atomic measure.
-/
theorem response_data_unique_on_infinite {n : ℕ} {lam lam' w w' : Fin n → ℝ}
    (hlam : Function.Injective lam) (hw : ∀ j, w j ≠ 0) {S : Set ℝ}
    (hS : S.Infinite)
    (hresp : ∀ z ∈ S, (∀ j, z ≠ lam j) → (∀ j, z ≠ lam' j) →
      response lam w z = response lam' w' z) :
    ∃ σ : Equiv.Perm (Fin n), ∀ j, lam' (σ j) = lam j ∧ w' (σ j) = w j := by
  -- Prove that for any $j$, $lam j$ occurs in $lam'$.
  have h_range : ∀ j, ∃ j', lam j = lam' j' := by
    intro j
    by_contra h_contra
    have h_poly : ∀ z ∈ S, (∀ j, z ≠ lam j) → (∀ j, z ≠ lam' j) → (∑ j, w j * (∏ i ∈ Finset.univ.erase j, (z - lam i)) * (∏ i, (z - lam' i))) = (∑ j, w' j * (∏ i, (z - lam i)) * (∏ i ∈ Finset.univ.erase j, (z - lam' i))) := by
      intro z hz hz' hz''; specialize hresp z hz hz' hz''; simp_all +decide [ response ] ;
      convert congr_arg ( fun x : ℝ => x * ( ∏ i, ( z - lam i ) ) * ( ∏ i, ( z - lam' i ) ) ) hresp using 1 <;> norm_num [ Finset.prod_erase_mul _ _ ( Finset.mem_univ _ ), Finset.sum_mul _ _ _ ] ; ring;
      · refine Finset.sum_congr rfl fun i hi => ?_ ; rw [ ← Finset.mul_prod_erase _ _ hi ] ; ring;
        rw [ ← Finset.mul_prod_erase _ _ hi ] ; ring;
        grind;
      · exact Finset.sum_congr rfl fun i hi => by rw [ div_mul_eq_mul_div, div_mul_eq_mul_div, eq_div_iff ( sub_ne_zero_of_ne <| hz'' i ) ] ; rw [ mul_assoc, Finset.prod_erase_mul _ _ hi ] ;
    have h_poly_zero : ∀ z, (∑ j, w j * (∏ i ∈ Finset.univ.erase j, (z - lam i)) * (∏ i, (z - lam' i))) = (∑ j, w' j * (∏ i, (z - lam i)) * (∏ i ∈ Finset.univ.erase j, (z - lam' i))) := by
      have h_poly_zero : Set.Infinite {z ∈ S | (∀ j, z ≠ lam j) ∧ (∀ j, z ≠ lam' j)} := by
        have h_poly_zero : Set.Infinite (S \ (Set.range lam ∪ Set.range lam')) := by
          exact Set.Infinite.diff hS ( Set.toFinite _ );
        exact h_poly_zero.mono fun x hx => ⟨ hx.1, fun j hj => hx.2 <| Or.inl <| hj ▸ Set.mem_range_self _, fun j hj => hx.2 <| Or.inr <| hj ▸ Set.mem_range_self _ ⟩;
      have h_poly_zero : ∀ p q : Polynomial ℝ, (∀ z ∈ {z ∈ S | (∀ j, z ≠ lam j) ∧ (∀ j, z ≠ lam' j)}, p.eval z = q.eval z) → p = q := by
        intros p q hpq;
        exact Classical.not_not.1 fun h => h_poly_zero <| Set.Finite.subset ( p - q |> Polynomial.roots |> Multiset.toFinset |> Finset.finite_toSet ) fun x hx => by simp_all +decide [ sub_eq_iff_eq_add ] ;
      convert h_poly_zero ( ∑ j, Polynomial.C ( w j ) * ( ∏ i ∈ Finset.univ.erase j, ( Polynomial.X - Polynomial.C ( lam i ) ) ) * ( ∏ i, ( Polynomial.X - Polynomial.C ( lam' i ) ) ) ) ( ∑ j, Polynomial.C ( w' j ) * ( ∏ i, ( Polynomial.X - Polynomial.C ( lam i ) ) ) * ( ∏ i ∈ Finset.univ.erase j, ( Polynomial.X - Polynomial.C ( lam' i ) ) ) ) _ using 1;
      · constructor <;> intro h;
        · exact h_poly_zero _ _ fun z hz => by simpa [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_C ] using h z;
        · intro z; replace h := congr_arg ( Polynomial.eval z ) h; simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_prod ] at h ⊢; exact h;
      · simp +contextual [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_C, h_poly ];
    specialize h_poly_zero ( lam j );
    rw [ Finset.sum_eq_single j, Finset.sum_eq_zero ] at h_poly_zero;
    · simp_all +decide [ Finset.prod_eq_zero_iff, sub_eq_zero, hlam.eq_iff ];
    · simp +decide [ Finset.prod_eq_zero ( Finset.mem_univ j ) ];
    · exact fun k hk hk' => mul_eq_zero_of_left ( mul_eq_zero_of_right _ <| Finset.prod_eq_zero ( Finset.mem_erase_of_ne_of_mem ( Ne.symm hk' ) <| Finset.mem_univ _ ) <| sub_self _ ) _;
    · grind;
  choose σ hσ using h_range;
  -- By weights_eq_of_response_eq_on_infinite, there exists a permutation σ such that w' (σ j) = w j for all j.
  have h_weights_eq : w' ∘ σ = w := by
    apply weights_eq_of_response_eq_on_infinite hlam;
    any_goals exact S \ ( Set.range lam ∪ Set.range lam' );
    · exact Set.Infinite.diff hS ( Set.toFinite _ );
    · simp_all +decide [ response ];
      intro z hz h₁ h₂ h₃; specialize hresp z hz; simp_all +decide [ eq_comm ] ;
      rw [ ← hresp, ← Equiv.sum_comp ( Equiv.ofBijective σ ( by
        exact ⟨ fun x y hxy => hlam <| by aesop, Finite.injective_iff_surjective.mp <| fun x y hxy => hlam <| by aesop ⟩ ) ) ] ; aesop;
  exact ⟨ Equiv.ofBijective σ ( Finite.injective_iff_bijective.mp ( show Function.Injective σ from fun i j hij => hlam <| by have := hσ i; have := hσ j; aesop ) ), fun j => ⟨ Eq.symm ( hσ j ), congr_fun h_weights_eq j ⟩ ⟩

/-
A concrete sharpness witness: for atoms `0,1,2`, two nonnegative weight vectors
have the same moments of orders `0,1` (that is, `n-1` moments for `n=3`) but differ.
-/
theorem two_moments_do_not_determine_three_weights :
    let lam : Fin 3 → ℝ := ![0, 1, 2]
    let w : Fin 3 → ℝ := ![1, 0, 1]
    let w' : Fin 3 → ℝ := ![0, 2, 0]
    (∀ j, 0 ≤ w j) ∧ (∀ j, 0 ≤ w' j) ∧ w ≠ w' ∧
      (∀ k : Fin 2, (∑ j, w j * lam j ^ (k : ℕ)) =
        ∑ j, w' j * lam j ^ (k : ℕ)) := by
  norm_num [ Fin.forall_fin_succ, Fin.sum_univ_succ ]

/-
Four moments determine a two-atom positive spectral measure, up to swapping its
atoms.  This is the `n=2` Hankel/Prony statement.
-/
theorem four_moments_determine_two_atoms
    {a b c d p q r s : ℝ}
    (hp : 0 < p) (hq : 0 < q) (hr : 0 < r) (hs : 0 < s)
    (hab : a ≠ b) (hcd : c ≠ d)
    (hm : ∀ k : Fin 4, p * a ^ (k : ℕ) + q * b ^ (k : ℕ) =
      r * c ^ (k : ℕ) + s * d ^ (k : ℕ)) :
    ((a = c ∧ b = d ∧ p = r ∧ q = s) ∨
     (a = d ∧ b = c ∧ p = s ∧ q = r)) := by
  -- By solving the system of linear equations derived from the equalities, we find that $p + q = r + s$ and $pa + qb = rc + sd$.
  have h_sum : p + q = r + s := by
    simpa using hm 0
  have h_prod_sum : p * a + q * b = r * c + s * d := by
    simpa using hm 1;
  -- By solving the system of linear equations derived from the equalities, we find that $p * a^2 + q * b^2 = r * c^2 + s * d^2$ and $p * a^3 + q * b^3 = r * c^3 + s * d^3$.
  have h_prod_sum_sq : p * a^2 + q * b^2 = r * c^2 + s * d^2 := by
    exact hm 2
  have h_prod_sum_cubed : p * a^3 + q * b^3 = r * c^3 + s * d^3 := by
    exact hm 3;
  grind +splitImp

/-
Minimal same-spectrum obstruction: the atom list `0,1` supports two probability
weights whose responses at `z=2` differ.
-/
theorem same_spectrum_different_readout :
    let lam : Fin 2 → ℝ := ![0, 1]
    let w₀ : Fin 2 → ℝ := ![1, 0]
    let w₁ : Fin 2 → ℝ := ![0, 1]
    (∑ j, w₀ j = 1) ∧ (∑ j, w₁ j = 1) ∧
      response lam w₀ 2 ≠ response lam w₁ 2 := by
  unfold response; norm_num [ Fin.sum_univ_succ ] ;

/-
The exact finite-dimensional dichotomy: spectrum alone admits different readouts,
whereas, at distinct known atoms, the first `n` moments determine every response.
-/
theorem spectrum_obstructed_moments_repair :
    (∃ (lam w₀ w₁ : Fin 2 → ℝ) (z : ℝ),
      (∑ j, w₀ j = 1) ∧ (∑ j, w₁ j = 1) ∧
      response lam w₀ z ≠ response lam w₁ z) ∧
    (∀ {n : ℕ} (lam : Fin n → ℝ), Function.Injective lam →
      ∀ w w' : Fin n → ℝ, moments lam w = moments lam w' →
        response lam w = response lam w') := by
  constructor;
  · convert same_spectrum_different_readout;
    constructor <;> intro h;
    · convert same_spectrum_different_readout;
    · use ![0, 1], ![1, 0], ![0, 1], 2;
  · -- Apply the hypothesis `response_eq_of_moments_eq` with the given hypotheses.
    apply response_eq_of_moments_eq

#print axioms spectralWeight_nonneg
#print axioms sum_spectralWeight
#print axioms moments_injective
#print axioms matrix_power_inner_eq_moment
#print axioms weights_eq_of_response_eq_on_infinite
#print axioms response_data_unique_on_infinite
#print axioms two_moments_do_not_determine_three_weights
#print axioms four_moments_determine_two_atoms
#print axioms same_spectrum_different_readout
#print axioms spectrum_obstructed_moments_repair

end SpectralMeasureRepair
